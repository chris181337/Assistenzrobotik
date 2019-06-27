function sysCall_init() 
    model=sim.getObjectAssociatedWithScript(sim.handle_self)
    uiH=simGetUIHandle('producerUI')
    sens=sim.getObjectHandle('Producer_sensOut')

--    col_=sim.getScriptSimulationParameter(sim.handle_self,'partColor')
--    ft=sim.getScriptSimulationParameter(sim.handle_self,"fabricationTime")
--    simSetUIButtonLabel(uiH,23,ft)
--    simSetUIButtonLabel(uiH,24,col_)

 
    output=-1
    rawCol={0,0,0}
    fabStart=0
    produced=0
    pause=false

-- config
    col={0,0,0} 
    ft = 1.8
    h=sim.createPureShape(0,1+2+8+4,{0.1,0.1,0.1},1,nil) --get handle for the newly created shape
    simAddObjectCustomData(h,125487,0)
    sim.setObjectParent(h,model,true)
    startPos={0,0,0}
    nextTargetPos={0.25,0,0.6}
    sim.setObjectPosition(h,model,startPos)
    st=0 -- simulation time
    projectTexture()

--conveyer dependence
    sensor=sim.getObjectHandle('ConveyorBelt_sensor')

-- subscriber on Object-Class
    sub=simROS.subscribe('/Category', 'std_msgs/Int16', 'classification_callback')
    simROS.subscriberTreatUInt8ArrayAsString(sub) -- treat uint8 arrays as strings (much faster, tables/arrays are kind of slow in Lua)

end
------------------------------------------------------------------------------ 
-- Following few lines automatically added by V-REP to guarantee compatibility 
-- with V-REP 3.1.3 and earlier: 
colorCorrectionFunction=function(_aShapeHandle_) 
  local version=sim.getInt32Parameter(sim.intparam_program_version) 
  local revision=sim.getInt32Parameter(sim.intparam_program_revision) 
  if (version<30104)and(revision<3) then 
      return _aShapeHandle_ 
  end 
  return '@backCompatibility1:'.._aShapeHandle_ 
end 
------------------------------------------------------------------------------ 

function classification_callback(msg)
    print(msg.data)
end

 
projectTexture = function()
    -- texture from random image-file
    -- http://www.forum.coppeliarobotics.com/viewtopic.php?t=2793

    rndClass = math.random(0, 3)

    if (rndClass == 3) then
      rndPic = math.random(0, 9)
      filename = "none" .. rndPic .. ".jpg"
      print(filename)

    end

    if (rndClass == 2) then
      rndPic = math.random(0, 29)
      filename = "unterlegscheibe" .. rndPic .. ".jpg"
      print(filename)
    end

    if (rndClass == 1) then
      rndPic = math.random(0, 29)
      filename = "schraube" .. rndPic .. ".jpg"
      print(filename)
    end

    if (rndClass == 0) then
      rndPic = math.random(0, 29)
      filename = "nagel" .. rndPic .. ".jpg"
      print(filename)
    end

    path = sim.getStringParameter(sim.stringparam_scene_path)
    path = path .. '/../catkin_ws/src/presentation_dataset/'
    textureHandle, textureId = simCreateTexture(path .. filename, 1, nil, nil, nil, 0, nil)
--    print("Handle: " .. textureHandle) 
--    print("ID: " .. textureId)
    print("h: " .. h)
    print("------------------------")

    if (textureId~=-1 and h~=-1) then
        simSetShapeTexture(h, textureId, sim.texturemap_plane, 3, {0.15,0.15}, nil, nil)
        simSetObjectSpecialProperty(h,sim.objectspecialproperty_renderable+sim.objectspecialproperty_detectable_all)
        simSetObjectSpecialProperty(textureHandle,sim.objectspecialproperty_renderable+sim.objectspecialproperty_detectable_all)
    end
end


updateUI=function(uiHandle,number)
    if (previousCounter~=number) then
        activeCol={0.1,1.0,0.1}
        passiveCol={0.1,0.1,0.1}
        c=math.fmod(number,1000)
        for i=0,2,1 do
            d=math.floor(c/(10^(2-i)))
            b=100+i*10
            if (d==0) then
                simSetUIButtonColor(uiHandle,b+0,activeCol)
                simSetUIButtonColor(uiHandle,b+1,activeCol)
                simSetUIButtonColor(uiHandle,b+2,activeCol)
                simSetUIButtonColor(uiHandle,b+3,passiveCol)
                simSetUIButtonColor(uiHandle,b+4,activeCol)
                simSetUIButtonColor(uiHandle,b+5,activeCol)
                simSetUIButtonColor(uiHandle,b+6,activeCol)
            end
            if (d==1) then
                simSetUIButtonColor(uiHandle,b+0,passiveCol)
                simSetUIButtonColor(uiHandle,b+1,passiveCol)
                simSetUIButtonColor(uiHandle,b+2,activeCol)
                simSetUIButtonColor(uiHandle,b+3,passiveCol)
                simSetUIButtonColor(uiHandle,b+4,passiveCol)
                simSetUIButtonColor(uiHandle,b+5,activeCol)
                simSetUIButtonColor(uiHandle,b+6,passiveCol)
            end
            if (d==2) then
                simSetUIButtonColor(uiHandle,b+0,activeCol)
                simSetUIButtonColor(uiHandle,b+1,passiveCol)
                simSetUIButtonColor(uiHandle,b+2,activeCol)
                simSetUIButtonColor(uiHandle,b+3,activeCol)
                simSetUIButtonColor(uiHandle,b+4,activeCol)
                simSetUIButtonColor(uiHandle,b+5,passiveCol)
                simSetUIButtonColor(uiHandle,b+6,activeCol)
            end
            if (d==3) then
                simSetUIButtonColor(uiHandle,b+0,activeCol)
                simSetUIButtonColor(uiHandle,b+1,passiveCol)
                simSetUIButtonColor(uiHandle,b+2,activeCol)
                simSetUIButtonColor(uiHandle,b+3,activeCol)
                simSetUIButtonColor(uiHandle,b+4,passiveCol)
                simSetUIButtonColor(uiHandle,b+5,activeCol)
                simSetUIButtonColor(uiHandle,b+6,activeCol)
            end
            if (d==4) then
                simSetUIButtonColor(uiHandle,b+0,passiveCol)
                simSetUIButtonColor(uiHandle,b+1,activeCol)
                simSetUIButtonColor(uiHandle,b+2,activeCol)
                simSetUIButtonColor(uiHandle,b+3,activeCol)
                simSetUIButtonColor(uiHandle,b+4,passiveCol)
                simSetUIButtonColor(uiHandle,b+5,activeCol)
                simSetUIButtonColor(uiHandle,b+6,passiveCol)
            end
            if (d==5) then
                simSetUIButtonColor(uiHandle,b+0,activeCol)
                simSetUIButtonColor(uiHandle,b+1,activeCol)
                simSetUIButtonColor(uiHandle,b+2,passiveCol)
                simSetUIButtonColor(uiHandle,b+3,activeCol)
                simSetUIButtonColor(uiHandle,b+4,passiveCol)
                simSetUIButtonColor(uiHandle,b+5,activeCol)
                simSetUIButtonColor(uiHandle,b+6,activeCol)
            end
            if (d==6) then
                simSetUIButtonColor(uiHandle,b+0,activeCol)
                simSetUIButtonColor(uiHandle,b+1,activeCol)
                simSetUIButtonColor(uiHandle,b+2,passiveCol)
                simSetUIButtonColor(uiHandle,b+3,activeCol)
                simSetUIButtonColor(uiHandle,b+4,activeCol)
                simSetUIButtonColor(uiHandle,b+5,activeCol)
                simSetUIButtonColor(uiHandle,b+6,activeCol)
            end
            if (d==7) then
                simSetUIButtonColor(uiHandle,b+0,activeCol)
                simSetUIButtonColor(uiHandle,b+1,passiveCol)
                simSetUIButtonColor(uiHandle,b+2,activeCol)
                simSetUIButtonColor(uiHandle,b+3,passiveCol)
                simSetUIButtonColor(uiHandle,b+4,passiveCol)
                simSetUIButtonColor(uiHandle,b+5,activeCol)
                simSetUIButtonColor(uiHandle,b+6,passiveCol)
            end
            if (d==8) then
                simSetUIButtonColor(uiHandle,b+0,activeCol)
                simSetUIButtonColor(uiHandle,b+1,activeCol)
                simSetUIButtonColor(uiHandle,b+2,activeCol)
                simSetUIButtonColor(uiHandle,b+3,activeCol)
                simSetUIButtonColor(uiHandle,b+4,activeCol)
                simSetUIButtonColor(uiHandle,b+5,activeCol)
                simSetUIButtonColor(uiHandle,b+6,activeCol)
            end
            if (d==9) then
                simSetUIButtonColor(uiHandle,b+0,activeCol)
                simSetUIButtonColor(uiHandle,b+1,activeCol)
                simSetUIButtonColor(uiHandle,b+2,activeCol)
                simSetUIButtonColor(uiHandle,b+3,activeCol)
                simSetUIButtonColor(uiHandle,b+4,passiveCol)
                simSetUIButtonColor(uiHandle,b+5,activeCol)
                simSetUIButtonColor(uiHandle,b+6,activeCol)
            end
            c=c-d*(10^(2-i))
        end
    end
    previousCounter=number
end
    
scanOutput=function()
    r,dist,pt,obj=sim.handleProximitySensor(sens)
    if (r==1) then
        output=sim.getObjectParent(obj)
    else
        output=-1
    end
end


function sysCall_cleanup() 
    if sim.isHandleValid(model)==1 then
        sim.setShapeColor(colorCorrectionFunction(model),nil,0,{0.75,0.75,0.75})
    end
end 

function sysCall_actuation() 
-- config
    col={0,0,0}
    ft=1.8

    simSetUIButtonLabel(uiH,23,ft)
    paused=sim.boolAnd32(simGetUIButtonProperty(uiH,22),sim.buttonproperty_isdown)~=0
    scanOutput() -- allow dynamic reconfiguration
    
    -- stop belt when conveyer-senor detects cuboid
    if (sim.readProximitySensor(sensor)<=0) then
    
	    -- Make a cube slowly appear:
	    t=(st-fabStart)/ft
	    if t>1 then t=1 end
	    if (t<=0.5) then
		t=t/0.5
		pp={0,0,startPos[3]*(1-t)+nextTargetPos[3]*t}
		sim.setObjectPosition(h,model,pp)
	--        cc={rawCol[1]*(1-t)+col[1]*t,rawCol[2]*(1-t)+col[2]*t,rawCol[3]*(1-t)+col[3]*t}
		sim.setShapeColor(colorCorrectionFunction(h),nil,0,{0.75,0.75,0.75})
	    else
		t=(t-0.5)/0.5
		pp={startPos[1]*(1-t)+nextTargetPos[1]*t,startPos[2]*(1-t)+nextTargetPos[2]*t,nextTargetPos[3]}
		sim.setObjectPosition(h,model,pp)
		sim.setShapeColor(colorCorrectionFunction(h),nil,0,{0.75,0.75,0.75})
	    end
	    
	    if (st>=fabStart+ft) then
		produced=produced+1
		fabStart=st
		sim.setShapeColor(colorCorrectionFunction(h),nil,0,{0.75,0.75,0.75})
		r=0.1+math.random()*0.15
		sim.setObjectPosition(h,model,nextTargetPos)
		nextTargetPos={0.25,0,0.6}
	    
		s=sim.getScriptSimulationParameter(sim.handle_self,'outBuffer')
		s=s..sim.packInt32Table({h})
		sim.setScriptSimulationParameter(sim.handle_self,'outBuffer',s)
		h=sim.createPureShape(0,1+2+8+4,{0.1,0.1,0.1},1,nil)
		
		simAddObjectCustomData(h,125487,0)
		sim.setObjectParent(h,model,true)
		sim.setObjectPosition(h,model,startPos)
		projectTexture()
	    end
	    
	    if (output~=-1) then
		d=sim.getScriptSimulationParameter(sim.handle_self,'outBuffer')
		sim.setScriptSimulationParameter(sim.handle_self,'outBuffer','')
		if (#d>0) then
		    dat=sim.unpackInt32Table(d)
		    for i=1,#dat,1 do
		        h2=dat[i]
		        sim.setObjectParent(h2,output,true)
		        s=sim.getScriptSimulationParameter(sim.getScriptAssociatedWithObject(output),'inBuffer')
		        s=s..sim.packInt32Table({h2})
		        sim.setScriptSimulationParameter(sim.getScriptAssociatedWithObject(output),'inBuffer',s)
		    end
		end
	    end
	    
	    
	    updateUI(uiH,produced)
	    
	    if not paused then
		st=st+sim.getSimulationTimeStep()
		sim.setShapeColor(colorCorrectionFunction(model),nil,0,{0.75,0.75,0.75})
	    else
		sim.setShapeColor(colorCorrectionFunction(model),nil,0,{0.8,0.1,0.1})
	    end
    end
end 
