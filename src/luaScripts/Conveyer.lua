function sysCall_init() 
    forwarder=sim.getObjectHandle('customizableConveyor_forwarder')
    textureShape=sim.getObjectHandle('customizableConveyor_tableTop')
    sensor=sim.getObjectHandle('ConveyorBelt_sensor')
end

function sysCall_cleanup() 
 
end 

function sysCall_actuation() 

-- Conveyor abschalten wenn Sensor Objekt detektiert
    beltVelocity=sim.getScriptSimulationParameter(sim.handle_self,"conveyorBeltVelocity")
    if (sim.readProximitySensor(sensor)>0) then
    beltVelocity=0
    end
    -- We move the texture attached to the conveyor belt to give the impression of movement:
    t=sim.getSimulationTime()
    sim.setObjectFloatParameter(textureShape,sim.shapefloatparam_texture_x,t*beltVelocity)
    


    -- Here we "fake" the transportation pads with a single static rectangle that we dynamically reset
    -- at each simulation pass (while not forgetting to set its initial velocity vector) :
    relativeLinearVelocity={beltVelocity,0,0}
    -- Reset the dynamic rectangle from the simulation (it will be removed and added again)
    sim.resetDynamicObject(forwarder)
    -- Compute the absolute velocity vector:
    m=sim.getObjectMatrix(forwarder,-1)
    m[4]=0 -- Make sure the translation component is discarded
    m[8]=0 -- Make sure the translation component is discarded
    m[12]=0 -- Make sure the translation component is discarded
    absoluteLinearVelocity=sim.multiplyVector(m,relativeLinearVelocity)
    -- Now set the initial velocity of the dynamic rectangle:
    sim.setObjectFloatParameter(forwarder,sim.shapefloatparam_init_velocity_x,absoluteLinearVelocity[1])
    sim.setObjectFloatParameter(forwarder,sim.shapefloatparam_init_velocity_y,absoluteLinearVelocity[2])
    sim.setObjectFloatParameter(forwarder,sim.shapefloatparam_init_velocity_z,absoluteLinearVelocity[3])


end 
