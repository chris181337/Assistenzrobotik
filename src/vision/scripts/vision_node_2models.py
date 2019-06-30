#!/usr/bin/env python

from __future__ import division, print_function

import numpy as np
import rospkg
import rospy
import tensorflow as tf
import keras
from cv_bridge import CvBridge, CvBridgeError
from PIL import Image, ImageDraw, ImageFont
from sensor_msgs.msg import Image as ImageMsg
from std_msgs.msg import Int16 as Int16Msg
# from vision.msg import classific

class ObjectClassification(object):
  def __init__(self):

    rospack = rospkg.RosPack()
    self.model = keras.models.load_model(rospack.get_path('vision') + '/src/arobModel_Xception_mAoD.h5') #arobModel_Xception_mAmD30_SGD
    self.sgd = keras.optimizers.SGD(lr=0.01, momentum=0.8, decay=0.0, nesterov=False)
    self.model.compile(loss='categorical_crossentropy',
              optimizer=self.sgd,
              metrics=['categorical_accuracy'])

    self.model_2 = keras.models.load_model(rospack.get_path('vision') + '/src/arob_classification_model_xModel1.h5') 
    self.model_2.compile(loss='categorical_crossentropy',
              optimizer='Adam',
              metrics=['categorical_accuracy'])
    self.model._make_predict_function()
    self.model_2._make_predict_function()


    self.pub = rospy.Publisher(
#       '/Category', classific, queue_size=10) # (topicName, messageType, bufferSize)
	'/Category', Int16Msg, queue_size=1)
    self.sub = rospy.Subscriber(
        "/Image", ImageMsg, self.callback)
    self.bridge = CvBridge()




  def callback(self, image_msg):
    """ Called once a new image becomes available. Performs object
          detection and publishes results.

    Args:
      image_msg: sensor_msgs.msg.Image
        camera image to perform object detection with

    Returns:
      None

    Side-Effects:
      Publishes robotto_msgs/Detections with contained objects
    """
    print("Hello Image :)")
    try:
      # converting to numpy-array
      image = self.bridge.imgmsg_to_cv2(image_msg, "rgb8")
    except CvBridgeError as e:
      rospy.logerr(e)
      return

## used to be an extra functions
#    probs = self.classify_objects(image) # returns array like [[2.7373236e-08 1.0000000e+00 0.0000000e+00]]
#  def classify_objects(self, image):
    """ Calculates the object classification neural network output

    Args:
      image: np.array with shape [H, W, 3] and dtype np.uint8
        the image to detect objects in

    Returns:
      probs: np.array with shape [NumDetections]
        probabilitiy of the detected object
    """

    image = np.array(Image.fromarray(image).resize((128, 128)))
    image = np.expand_dims(image, axis=0)
    probs = self.model.predict(image) # returns probability for each class in an array
    probs_2 = self.model_2.predict(image)

#    return probs 

## used to be an extra function
#    self.publish_classification(image_msg, probs)
#  def publish_classification(self, image_msg, probs):
    """    Args:
      image_msg: sensor_msgs.msg.Image
        initial Image received from the camera gives timestamp to detection
      probs: np.array with shape [NumDetections]
        probabilitiy of the detected object

    Returns:
      None

    Side-Effects:
      Publishes classification_message.msg
    """

    #new msg-object
#    classif = classific()
    classif =Int16Msg()

    obj_max_probs = np.argmax(probs)
    obj_max_probs_2 = np.argmax(probs_2)
    max_probs = np.max(probs)
    if  max_probs <= 0.6:
      # no recognition
      classif.data = 3
#      classif.data = 3
#      classif.prob = max_probs

   # class with highest probability 
    elif obj_max_probs_2 == 2:
      classif.data = obj_max_probs_2 # 2
      print("model_2")
    else:
      classif.data = obj_max_probs
#      classif.obj_type = obj_max_probs
#      classif.prob = max_probs

    print("[Vision_node] class: %s" %classif.data)
    self.pub.publish(classif)



##### Main #######

def main():
  rospy.init_node('vision_node')
  print("[Vision_node] started")
  classific = ObjectClassification()

  while not rospy.is_shutdown():
    rospy.spin()


if __name__ == "__main__":
  main()
