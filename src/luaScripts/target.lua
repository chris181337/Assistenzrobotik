function sysCall_threadmain()
    local thisObjectHandle = sim.getObjectAssociatedWithScript(sim.handle_self)
    local changePositionOnly = 1
    local changeOrientationOnly = 2
    local changePositionAndOrientation = 3
    local pathHandle = sim.getObjectHandle('Path2')
    sim.followPath(thisObjectHandle, pathHandle, changePositionOnly, 0, 0.2, 1)
--    sub=simROS.subscribe('/Category', 'std_msgs/Int16', 'cubit_sort_callback')
--    simROS.subscriberTreatUInt8ArrayAsString(sub) -- treat uint8 arrays as strings (much faster, tables/arrays are kind of slow in Lua)
end

--function cubit_sort_callback
--    local category = msg.data
--    print('Read this value as category: ' .. msg.data)
    --local pathHandle = sim.getObjectHandle('Path' .. category)
--    if msg.data and sim.readProximitySensor(proxSensor)>0 then
--             sim.followPath(thisObjectHandle, pathHandle, changePositionOnly, 0, 0.25, 1)
--    end 
--end

--sub=simROS.subscribe('/qbit_ready', 'std_msgs/Bool', 'qbitready_callback')
--function qbitready_callback(msg)
--    print(msg.data)--permanent true/false ausgeben
--end