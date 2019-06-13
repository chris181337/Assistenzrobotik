#!/usr/bin/env python

from __future__ import division, print_function

import numpy as np
import rospkg
import rospy
import tensorflow as tf
from cv_bridge import CvBridge, CvBridgeError
from PIL import Image, ImageDraw, ImageFont
from sensor_msgs.msg import Image as ImageMsg
from vision.msg import classific

class ObjectClassification(object):
  def __init__(self):

    self.pub = rospy.Publisher(
        '/Category', classific, queue_size=10) # (topicName, messageType, bufferSize)
    self.sub = rospy.Subscriber(
        "/Image", ImageMsg, self.callback)
    self.bridge = CvBridge()

    rospack = rospkg.RosPack()
    self.model = tf.keras.models.load_model(rospack.get_path('vision') + '/src/arob_classification_model.h5')
    self.model._make_predict_function()
    self.model.summary()
    print(self.model.output)


  def classify_objects(self, image):
    """ Calculates the object classification neural network output

    Args:
      image: np.array with shape [H, W, 3] and dtype np.uint8
        the image to detect objects in

    Returns:
      probs: np.array with shape [NumDetections]
        probabilitiy of the detected object
    """

    image = np.array(Image.fromarray(image).resize((256, 256)))
    image = np.expand_dims(image, axis=0)
    return self.model.predict(image)


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
    classif = classific()

    obj_max_probs = np.argmax(probs)
    max_probs = np.max(probs)
    if  max_probs <= 0.6:
      # no recognition 
      classif.obj_type = 3
      classif.prob = max_probs
      # class with highest probability 
    else:
      classif.obj_type = obj_max_probs
      classif.prob = max_probs

    self.pub.publish(classif)


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

    probs = self.classify_objects(image)
    self.publish_classification(image_msg, probs)


##### Main #######

def main():
  rospy.init_node('vision_node')
  classific = ObjectClassification()

  while not rospy.is_shutdown():
    rospy.spin()


if __name__ == "__main__":
  main()
