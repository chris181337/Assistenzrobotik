#!/usr/bin/env python

from __future__ import division, print_function

import numpy as np
import rospkg
import rospy
import tensorflow as tf
from cv_bridge import CvBridge, CvBridgeError
from PIL import Image, ImageDraw, ImageFont
from sensor_msgs.msg import Image as ImageMsg
#from std_msgs.msg import _Float64 as f64_msg
from std_msgs.msg import Float32MultiArray as std_msg_f32_array
from std_msgs.msg import Float32 as std_msg_f32

publisher = ""

def message_callback(msg):
	data = msg.data

	minimum = min(data)
	print(minimum)
	publisher.publish(minimum)

######## MAIN #############

def main():
	rospy.init_node("safety_node")
	print("[Safety_node] started")
	global publisher
	publisher = rospy.Publisher("/safety_level", std_msg_f32, queue_size=10) # (topicName, messageType, bufferSize)
	rospy.Subscriber("/safety_sensor_data", std_msg_f32_array, message_callback)

	while not rospy.is_shutdown():
		rospy.spin()


if __name__ == "__main__":
	main()