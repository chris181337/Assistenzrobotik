#!/usr/bin/env python

from __future__ import division, print_function

import rospkg
import rospy

from std_msgs.msg import Float32MultiArray as std_msg_f32_array
from std_msgs.msg import Float32 as std_msg_f32

publisher = ""

def message_callback(msg):
	minimum = min(msg.data)
	if minimum < 0.3:
		print("0")
		publisher.publish(0)
	else:
		print("1")
		publisher.publish(1)

def message_callback_2(msg):
	#minimum = min(data)
	#print(minimum)
	#publisher.publish(minimum)
	pass

def main():
	rospy.init_node("safety_node")
	global publisher
	publisher = rospy.Publisher("/safety_level", std_msg_f32, queue_size=10) # (topicName, messageType, bufferSize)
	rospy.Subscriber("/safety_sensor_data", std_msg_f32_array, message_callback)
	rospy.Subscriber("/safety_sensor_data_2", std_msg_f32_array, message_callback_2)

	while not rospy.is_shutdown():
		rospy.spin()

if __name__ == "__main__":
	main()
