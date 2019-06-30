#!/usr/bin/env python

from __future__ import division, print_function

import rospkg
import rospy

from std_msgs.msg import Float32MultiArray as std_msg_f32_array
from std_msgs.msg import Float32 as std_msg_f32

from threading import Lock

publisher = ""

def message_callback(msg):
	global turn_off_2, turn_off_2_lock
	turn_off_2_lock.acquire()
	if turn_off_2:
		print("Block beseitigen")
		publisher.publish(0)
		turn_off_2_lock.release()
		return
	turn_off_2_lock.release()

	minimum = min(msg.data)
	if minimum < 0.3:
		print("Sicherheitsabschaltung")
		publisher.publish(0)
	else:
		print("Alles in Ordnung")
		publisher.publish(1)

turn_off_2 = False
turn_off_2_lock = Lock()
def message_callback_2(msg):
	global turn_off_2, turn_off_2_lock
	turn_off_2_lock.acquire()
	minimum = min(msg.data)
	if minimum > 1:
		turn_off_2 = False
	else:
		turn_off_2 = True
	turn_off_2_lock.release()
	#publisher.publish(minimum)

def main():
	rospy.init_node("safety_node")
	global publisher
	publisher = rospy.Publisher("/safety_level", std_msg_f32, queue_size=1) # (topicName, messageType, bufferSize)
	rospy.Subscriber("/safety_sensor_data", std_msg_f32_array, message_callback)
	rospy.Subscriber("/safety_sensor_data_2", std_msg_f32_array, message_callback_2)

	while not rospy.is_shutdown():
		rospy.spin()

if __name__ == "__main__":
	main()
