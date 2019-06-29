function sysCall_init()
   sub=simROS.subscribe('/qbit_ready', 'std_msgs/Bool', 'qbitready_callback')--subscribe: chris qbit ready
   sub=simROS.subscribe('/Category', 'std_msgs/Int16', 'cubit_sort_callback')--subscribe: nele qbit category
   --sub=simROS.subscribe('/safety_sensor_data', 'std_msgs/Float32MultiArray','security_callback')--subscribe: tom security speed
   simROS.subscriberTreatUInt8ArrayAsString(sub) -- treat uint8 arrays as strings (much faster, tables/arrays are kind of slow in Lua)
end


------------------------------------------------------------
--qbit type auslesen
function cubit_sort_callback(qbit_cat)
print('Projektor sendet category:')
print(qbit_cat.data)
sim.setIntegerSignal("category_signal", qbit_cat.data)
--category_buffer=category_buffer+qbit_cat.data[0]--füge erkanntes objekt in puffer ein
end
------------------------------------------------------------


--[[------------------------------------------------------------
--Security auslesen
function security_callback(speed)
	--security_speed=speed.data
print('Geht in security speed schleife rein')
end
------------------------------------------------------------]]


------------------------------------------------------------
--conveyor sensor auslesen
function qbitready_callback(ready)
 if(ready.data==false) then 
 sim.setIntegerSignal("ready_signal", 0)
--print('ready signal false gesendet')
 end
 if(ready.data==true) then 
 sim.setIntegerSignal("ready_signal", 1)        
 end
end
------------------------------------------------------------