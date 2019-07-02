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
    self.model = keras.models.load_model(rospack.get_path('vision') + '/src/arobModel_Xception_mAmD30_SGD.h5') #arob_classification_model_xModel1 #arobModel_mNetV2_mD20_16ep #arobModel_Xception_mAmD30_SGD #arobModel_Xception_mAoD
    self.sgd = keras.optimizers.SGD(lr=0.001, momentum=0.8, decay=0.0, nesterov=False)
    self.model.compile(loss='categorical_crossentropy',
              optimizer=self.sgd,
              metrics=['categorical_accuracy'])

#    self.model.compile(loss='categorical_crossentropy',
#              optimizer='Adam',
#              metrics=['categorical_accuracy'])
    self.model._make_predict_function()


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

    probs = self.classify_objects(image) # returns array like [[2.7373236e-08 1.0000000e+00 0.0000000e+00]]
    self.publish_classification(image_msg, probs)


  def classify_objects(self, image):
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
    print(probs)
    return probs 

  def publish_classification(self, image_msg, probs):
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
    classif =Int16Msg()

    obj_max_probs = np.argmax(probs)
    max_probs = np.max(probs)
    if  max_probs <= 0.6:
      # no recognition
      classif.data = 3

   # class with highest probability 
    else:
      classif.data = obj_max_probs

    print("[Vision_node] class: %s" %classif.data)
    self.pub.publish(classif)


##### Main #######

def main():
  rospy.init_node('vision_node')
  classific = ObjectClassification()
  print("[Vision_node] started")

  while not rospy.is_shutdown():
    rospy.spin()


if __name__ == "__main__":
  main()
