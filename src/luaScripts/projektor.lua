function sysCall_init()
   sub=simROS.subscribe('/qbit_ready', 'std_msgs/Bool', 'qbitready_callback')--subscribe: chris qbit ready
   sub=simROS.subscribe('/Category', 'std_msgs/Int16', 'cubit_sort_callback')--subscribe: nele qbit category
   sub=simROS.subscribe('/safety_level', 'std_msgs/Float32','safety_callback')--subscribe: tom security speed
   simROS.subscriberTreatUInt8ArrayAsString(sub) -- treat uint8 arrays as strings (much faster, tables/arrays are kind of slow in Lua)
--initial Signale
	sim.setIntegerSignal("safety_signal",0)   --nich safe
	sim.setIntegerSignal("category_signal", 4)--nix erkannt
	sim.setIntegerSignal("ready_signal", 0)   --nich ready
end


------------------------------------------------------------
--qbit type auslesen
function cubit_sort_callback(qbit_cat)
print('Projektor sendet category:')
print(qbit_cat.data)
sim.setIntegerSignal("category_signal", qbit_cat.data)
end
------------------------------------------------------------


--------------------------------------------------------------
--Security auslesen
function safety_callback(safe)

	if safe.data then
	sim.setIntegerSignal("safety_signal",safe.data)
	--print(safe.data)
	end
end
------------------------------------------------------------


------------------------------------------------------------
--conveyor sensor auslesen
function qbitready_callback(ready)
 if(ready.data==false) then 
 sim.setIntegerSignal("ready_signal", 0)
 end
 if(ready.data==true) then 
 sim.setIntegerSignal("ready_signal", 1)        
 end
end
------------------------------------------------------------
