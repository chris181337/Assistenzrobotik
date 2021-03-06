function sysCall_init()
   sub1=simROS.subscribe('/qbit_ready', 'std_msgs/Bool', 'qbitready_callback')--subscribe: chris qbit ready
   sub2=simROS.subscribe('/Category', 'std_msgs/Int16', 'cubit_sort_callback')--subscribe: nele qbit category
   sub3=simROS.subscribe('/safety_level', 'std_msgs/Float32','safety_callback')--subscribe: tom security speed
  --initial Signale
	sim.setIntegerSignal("safety_signal",0)   --nich safe
	sim.setIntegerSignal("category_signal", 4)--nix erkannt
	sim.setIntegerSignal("ready_signal", 0)   --nich ready
end


------------------------------------------------------------
--qbit type auslesen
function cubit_sort_callback(qbit_cat)
sim.setIntegerSignal("category_signal", qbit_cat.data)
end
------------------------------------------------------------


--------------------------------------------------------------
--Security auslesen
function safety_callback(safe)

	if safe.data then
	sim.setIntegerSignal("safety_signal",safe.data)
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
function sysCall_cleanup()
    simROS.shutdownSubscriber(sub1)
    simROS.shutdownSubscriber(sub2)
    simROS.shutdownSubscriber(sub3)
end