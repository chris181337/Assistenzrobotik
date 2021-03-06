--[[function sysCall_init()

    local thisObjectHandle = sim.getObjectAssociatedWithScript(sim.handle_self)
    local changePositionOnly = 1
    local changeOrientationOnly = 2
    local changePositionAndOrientation = 3
    local category_buffer={}
    local security_speed=1
    local conveyor_ready=false
    --local pathHandle = sim.getObjectHandle('Path2')--gibt den pfad an der abgefahren werden soll
    --sim.followPath(thisObjectHandle, pathHandle, changePositionOnly, 0, 0.2, 1)--fahre fahrt von oben ab
   sub=simROS.subscribe('/qbit_ready', 'std_msgs/Bool', 'qbitready_callback')--subscribe: chris qbit ready
   sub=simROS.subscribe('/Category', 'std_msgs/Int16', 'cubit_sort_callback')--subscribe: nele qbit category
   --sub=simROS.subscribe('/safety_sensor_data', 'std_msgs/Float32MultiArray','security_callback')--subscribe: tom security speed
   simROS.subscriberTreatUInt8ArrayAsString(sub) -- treat uint8 arrays as strings (much faster, tables/arrays are kind of slow in Lua)
end



------------------------------------------------------------
function sysCall_threadmain()
------------- Put some initialization code here:
    local thisObjectHandle = sim.getObjectAssociatedWithScript(sim.handle_self)
    local changePositionOnly = 1
    local changeOrientationOnly = 2
    local changePositionAndOrientation = 3
    local category_buffer={}
    local security_speed=1
    local conveyor_ready=false
    --local pathHandle = sim.getObjectHandle('Path2')--gibt den pfad an der abgefahren werden soll
    --sim.followPath(thisObjectHandle, pathHandle, changePositionOnly, 0, 0.2, 1)--fahre fahrt von oben ab
   sub=simROS.subscribe('/qbit_ready', 'std_msgs/Bool', 'qbitready_callback')--subscribe: chris qbit ready
   sub=simROS.subscribe('/Category', 'std_msgs/Int16', 'cubit_sort_callback')--subscribe: nele qbit category
   --sub=simROS.subscribe('/safety_sensor_data', 'std_msgs/Float32MultiArray','security_callback')--subscribe: tom security speed
   simROS.subscriberTreatUInt8ArrayAsString(sub) -- treat uint8 arrays as strings (much faster, tables/arrays are kind of slow in Lua)
------------init finished


------------ Here we execute the regular thread code:
    while sim.getSimulationState()~=sim.simulation_advancing_abouttostop do



local pathHandle = sim.getObjectHandle('Path' .. 1)                  --hin zum objekt 
sim.followPath(thisObjectHandle, pathHandle, changePositionOnly, 0, security_speed, 1)--fahre ab
        --drop box into case of category
	--local pathHandle = sim.getObjectHandle('Path' .. 1)                  --hin zum objekt 
	--sim.followPath(thisObjectHandle, pathHandle, changePositionOnly, 0, security_speed, 1)--fahre ab
	--greifen attach to gripper
	--category_buffer.data[0].remove;                                                       --qbit aus buffer rausschmeißen
	--local pathHandle = sim.getObjectHandle('Path' .. category_buffer[0] .. 'r')           --zurück vom objekt
        --sim.followPath(thisObjectHandle, pathHandle, changePositionOnly, 0, security_speed, 1)--fahre ab



        end
        sim.switchThread() -- Explicitely switch to another thread now!
        -- from now on, above loop is executed once in each simulation step.
        -- this way you do not waste precious computation time and run synchronously.
    end
------------regular thread code finished
end
------------------------------------------------------------Syscall_threadmain() finished


------------------------------------------------------------
--qbit type auslesen
function cubit_sort_callback(qbit_cat)
print('Erkenne Qbit: ' .. qbit_cat.data)
--category_buffer=category_buffer+qbit_cat.data[0]--füge erkanntes objekt in puffer ein
    end
------------------------------------------------------------


------------------------------------------------------------

--Security auslesen
function security_callback(speed)
	--security_speed=speed.data
print('Geht in security speed schleife rein')
end

------------------------------------------------------------


------------------------------------------------------------
--conveyor sensor auslesen
function qbitready_callback(ready)
if(ready.data==false) then 
print('Cube Not in position yet!')--verified
conveyor_ready=false
  end
if(ready.data==true) then 
conveyor_ready=true
--print('Cube in position! Now Grabbing it...')--verified
        

        --drop box into case of category
	--local pathHandle = sim.getObjectHandle('Path' .. 1)                  --hin zum objekt 
	--sim.followPath(thisObjectHandle, pathHandle, changePositionOnly, 0, security_speed, 1)--fahre ab
	--greifen attach to gripper
	--category_buffer.data[0].remove;                                                       --qbit aus buffer rausschmeißen
	--local pathHandle = sim.getObjectHandle('Path' .. category_buffer[0] .. 'r')           --zurück vom objekt
        --sim.followPath(thisObjectHandle, pathHandle, changePositionOnly, 0, security_speed, 1)--fahre ab
   end
end
------------------------------------------------------------
--]]


function sysCall_threadmain()

sim.setThreadIsFree(true)
--Put some initialization code here:
print('Initializiere Target:')
sim.setThreadAutomaticSwitch(false) --disable automatic thread switches
pub=simROS.advertise('/Simulation_Time_100', 'std_msgs/Float32', 10)
    
 --Für Motionplanning nötiige Variablen:
    local thisObjectHandle = sim.getObjectAssociatedWithScript(sim.handle_self)
    local changePositionOnly = 1
    local changeOrientationOnly = 2
    local changePositionAndOrientation = 3
    local pathHandle

    local suctionPad=sim.getObjectHandle('suctionPad')
    local workcycle_count=0
 --Sammle folgende Infos aus Signalen:
	local ready=0          --Ist der qbit schon da?
	local category=3       --was für ein Qbit ist das?
	local security=0	--safety gegeben?
	local security_temp
	local ready=0
	local category=4		--4= noch nix neues
	local category_buffer={}
-- Here we execute the regular thread code:
print('Starte Target Loop:')
    while sim.getSimulationState()~=sim.simulation_advancing_abouttostop do

--lese/aktualisiere Signalinfos:
--ready   =sim.getIntSignal("ready_signal")
--category=sim.getIntSignal("category_signal")

--security signal handling:
	--security signal update:	
	security_temp=sim.getIntegerSignal("safety_signal")
	if security_temp==1 then security=true
	else security=false
	end	
--ready signal handling:
        ready=sim.getIntegerSignal("ready_signal")

--Category Signal handling:
	

	category=sim.getIntegerSignal("category_signal")--Signal ansehn
	if category and category~=4 then--wenn nicht nil und was neues
	--print('ready:' .. ready)
	--print('safety' .. security_temp)
	--print('category' .. category)
	table.insert(category_buffer,category)--Signal in puffer schreiben
	sim.setIntegerSignal("category_signal",4)--signal zurücksetzen
	end	



--[[überbrücke vision node:
	category=3--nix erkannt
	table.insert(category_buffer,category)--Signal in puffer schreiben
	sim.setIntegerSignal("category_signal",4)	
--]]



--Wenn gerade alle Bedingungen erfüllt Bewegungen starten:

--Hinweg:
	if (ready==1) and (security==true) and (category_buffer[1]) then --qbit liegt auf sensor, bill is weit weg, qbit wert vorhanden
		print('Starting Motion to Category:' .. category_buffer[1])
--greifen
	        sim.setScriptSimulationParameter(sim.getScriptAssociatedWithObject(suctionPad),'active','true')
		pathHandle = sim.getObjectHandle('Path' .. category_buffer[1])--gibt den pfad an der abgefahren werden soll
		sim.followPath(thisObjectHandle, pathHandle, changePositionOnly, 0, 0.7, 1)--fahre fahrt von oben ab
--loslassen	
		sim.setScriptSimulationParameter(sim.getScriptAssociatedWithObject(suctionPad),'active','false')
              	
		
--Bill laufen
		if category_buffer[1] == 3 then
                sim.setIntegerSignal("the_other_bill_showtime", 1)
              	end
	
-- super fancy-ges delete cube stuff
              next_delete_handle = sim.getIntegerSignal("cube_next_delete")
              print("Removing " .. next_delete_handle)
              sim.setObjectPosition(next_delete_handle, -1, {0, 0, -1000})
              --sim.removeObject(next_delete_handle)
              --sim.removeModel(next_delete_handle)
              sim.setIntegerSignal("cube_deleted", 1)
		
    	    	workcycle_count=workcycle_count+1
		if workcycle_count ==10 then simROS.publish(pub,{data = sim.getSimulationTime()}) end
		end
--Rückweg
		sim.switchThread() -- Explicitely switch to another thread now!	
		if (ready==1) and (security==true) and (category_buffer[1]) then
		print('Starting Return motion')
--          	simSetIntegerSignal('VacuumCup_active',1) -- wird nicht benötigt, da wir derzeit nicht mit Signals arbeiten.
		pathHandle = sim.getObjectHandle('Path' .. category_buffer[1] .. 'r')--gibt den pfad an der abgefahren werden soll
		sim.followPath(thisObjectHandle, pathHandle, changePositionOnly, 0, 0.7, 1)--fahre fahrt von oben ab
		table.remove(category_buffer , 1)--qbit abgearbeitet, aus buffer rausnehmen
		end
--fertig
		sim.switchThread() -- Explicitely switch to another thread now!
        	-- from now on, above loop is executed once in each simulation step.
        	-- this way you do not waste precious computation time and run synchronously.
    end
end

function sysCall_cleanup()
    -- Put some clean-up code here
    simROS.shutdownPublisher(pub)
end
