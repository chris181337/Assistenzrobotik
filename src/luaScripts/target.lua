function sysCall_init()

    local thisObjectHandle = sim.getObjectAssociatedWithScript(sim.handle_self)
    local changePositionOnly = 1
    local changeOrientationOnly = 2
    local changePositionAndOrientation = 3
    local category_buffer={}
    local security_speed=1;
    --local pathHandle = sim.getObjectHandle('Path2')--gibt den pfad an der abgefahren werden soll
    --sim.followPath(thisObjectHandle, pathHandle, changePositionOnly, 0, 0.2, 1)--fahre fahrt von oben ab
   sub=simROS.subscribe('/qbit_ready', 'std_msgs/Bool', 'qbitready_callback')--subscribe: chris qbit ready
   sub=simROS.subscribe('/Category', 'std_msgs/Int16', 'cubit_sort_callback')--subscribe: nele qbit category
   --sub=simROS.subscribe('/safety_sensor_data', 'std_msgs/Float32MultiArray','security_callback')--subscribe: tom security speed
   simROS.subscriberTreatUInt8ArrayAsString(sub) -- treat uint8 arrays as strings (much faster, tables/arrays are kind of slow in Lua)
end

--qbit type auslesen
function cubit_sort_callback(qbit_cat)
print('Erkenne Qbit: ' .. qbit_cat.data)
--category_buffer=category_buffer+qbit_cat.data[0]--füge erkanntes objekt in puffer ein
    end

--[[
--Security auslesen
function security_callback(speed)
	--security_speed=speed.data
print('Geht in security speed schleife rein')
end
]]--


--conveyor sensor auslesen => wenn ready motion start
function qbitready_callback(ready)
if(ready.data==false) then 
--print('Cube Not in position yet!')--verified
  end

if(ready.data==true) then 
--print('Cube in position! Now Grabbing it...')--verified
--[[
        --drop box into case of category
	local pathHandle = sim.getObjectHandle('Path' .. category_buffer[0])                  --hin zum objekt 
	sim.followPath(thisObjectHandle, pathHandle, changePositionOnly, 0, security_speed, 1)--fahre ab
	--greifen attach to gripper
	category_buffer.data[0].remove;                                                       --qbit aus buffer rausschmeißen
	local pathHandle = sim.getObjectHandle('Path' .. category_buffer[0] .. 'r')           --zurück vom objekt
        sim.followPath(thisObjectHandle, pathHandle, changePositionOnly, 0, security_speed, 1)--fahre ab
]]--
   end
end
