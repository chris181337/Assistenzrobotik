function sysCall_init() 
    -- Prepare a floating view with the camera views:
    cam=sim.getObjectAssociatedWithScript(sim.handle_self)
    view=sim.floatingViewAdd(0.9,0.9,0.2,0.2,0)
    sim.adjustView(view,cam,64)

    -- Get some handles:
    visionSensor=sim.getObjectHandle('visionSensor')
    proxSensor=sim.getObjectHandle('Proximity_sensor')

    -- Enable an image publisher and subscriber:
    pub=simROS.advertise('/Image', 'sensor_msgs/Image')
    simROS.publisherTreatUInt8ArrayAsString(pub) -- treat uint8 arrays as strings (much faster, tables/arrays are kind of slow in Lua)
--    sub=simROS.subscribe('/Category', 'std_msgs/Int16', 'classification_callback')
--    simROS.subscriberTreatUInt8ArrayAsString(sub) -- treat uint8 arrays as strings (much faster, tables/arrays are kind of slow in Lua)

    -- set flag of proximity sensor to false (doesn't detect something)
    flag = false

end

--function classification_callback(msg)
--    print(msg.data)
--end


function sysCall_sensing()
    ---- send one picture only, if sensor detects the cuboid 
--    conveyerHdl = sim.getObjectHandle("customizableConveyer")
--    conveyerScriptHdl = sim.getScriptAssociatedWithObject(conveyerHdl)
--    beltVelocity = sim.getScriptSimulationParameter(conveyerHdl,"conveyorBeltVelocity")

    if ( sim.readProximitySensor(proxSensor) > 0 and flag==false) then
--        sim.setScriptSimulationParameter(conveyerScriptHdl,"conveyorBeltVelocity", 0) -- stop belt
	flag = true

	-- Publish the image of the active vision sensor
   		local data,w,h=sim.getVisionSensorCharImage(visionSensor)
		d={}
		d['header']={seq=0,stamp=simROS.getTime(), frame_id="a"}
		d['height']=h
		d['width']=w
		d['encoding']='rgb8'
		d['is_bigendian']=1
		d['step']=w*3
		d['data']=data
		simROS.publish(pub,d)
   end

   if ( sim.readProximitySensor(proxSensor) <= 0 and flag==true) then
	flag = false
   end

end

function sysCall_cleanup()
    if sim.isHandleValid(cam)==1 then
        sim.floatingViewRemove(view)
    end

    -- Shut down publisher and subscriber. Not really needed from a simulation script (automatic shutdown)
    simROS.shutdownPublisher(pub)
--    simROS.shutdownSubscriber(sub)
end