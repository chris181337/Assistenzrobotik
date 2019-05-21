
function sysCall_init() 
    -- Prepare a floating view with the camera views:
    cam=sim.getObjectAssociatedWithScript(sim.handle_self)
    view=sim.floatingViewAdd(0.9,0.9,0.2,0.2,0)
    sim.adjustView(view,cam,64)

    -- Get some handles:
    visionSensor=sim.getObjectHandle('visionSensor')
    
    -- Enable an image publisher and subscriber:
    pub=simROS.advertise('/image', 'sensor_msgs/Image')
    simROS.publisherTreatUInt8ArrayAsString(pub) -- treat uint8 arrays as strings (much faster, tables/arrays are kind of slow in Lua)
--    sub=simROS.subscribe('/classification', classification, 'classification_callback')
--    simROS.subscriberTreatUInt8ArrayAsString(sub) -- treat uint8 arrays as strings (much faster, tables/arrays are kind of slow in Lua)
end


--function classification_callback(msg)
    -- TODO auslesen der Nachrichteninhalte und Weiterleitung der Aufgabe an Roboter ODER direkt von Roboter subscriben?! 
--end


function sysCall_sensing()
    -- Publish the image of the active vision sensor:
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

function sysCall_cleanup()
    if sim.isHandleValid(cam)==1 then
        sim.floatingViewRemove(view)
    end

    -- Shut down publisher and subscriber. Not really needed from a simulation script (automatic shutdown)
    simROS.shutdownPublisher(pub)
    simROS.shutdownSubscriber(sub)
end