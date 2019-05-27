function sysCall_init() 
    model=sim.getObjectAssociatedWithScript(sim.handle_self)
    uiH=simGetUIHandle('producerUI')
    output=-1
    sens=sim.getObjectHandle('Producer_sensOut')
    rawCol={0,0,0}
    fabStart=0
    produced=0
    pause=false
   
    h=sim.createPureShape(0,1+2+8+4,{0.1,0.1,0.1},1,nil) --get handle for the newly created shape
    simAddObjectCustomData(h,125487,0)
    sim.setObjectParent(h,model,true)
    startPos={0,0,0}
    nextTargetPos={0.25,0,0.6}
    sim.setObjectPosition(h,model,startPos)

-- TODO random taken pictures, perhabs an array
--    texturePath = sim.getStringParameter(sim.stringparam_scene_path)
--    texturePath = path .. '/../catkin_ws/src/'
--    sim.includeAbs(texturePath)

--    simCreateTexture('picture1',1,const simFloat* planeSizes,const simFloat* scalingUV,const simFloat* xy_g,simInt fixedResolution,simInt* textureId,simInt* resolution,const simVoid* reserved)
--    sim.setShapeTexture(
    
    st=0
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

------ CONFIGURATION ------
    col={0,0,0} -- color of parts
    ft = 2.0    -- fabrication time
---------------------------

    -- Make a cube slowly appear:
    t=(st-fabStart)/ft
    if t>1.0 then t=1.0 end
    if (t<=0.5) then
        t=t/0.5
        pp={0,0,startPos[3]*(1-t)+nextTargetPos[3]*t}
        sim.setObjectPosition(h,model,pp)
        cc={rawCol[1]*(1-t)+col[1]*t,rawCol[2]*(1-t)+col[2]*t,rawCol[3]*(1-t)+col[3]*t}
        sim.setShapeColor(colorCorrectionFunction(h),nil,0,cc)
    else
        t=(t-0.5)/0.5
        pp={startPos[1]*(1-t)+nextTargetPos[1]*t,startPos[2]*(1-t)+nextTargetPos[2]*t,nextTargetPos[3]}
        sim.setObjectPosition(h,model,pp)
        sim.setShapeColor(colorCorrectionFunction(h),nil,0,col)
    end
    
    if (st>=fabStart+ft) then
        produced=produced+1
        fabStart=st
        sim.setShapeColor(colorCorrectionFunction(h),nil,0,col)
        r=0.1+math.random()*0.15
        a=math.pi*2*math.random()
        sim.setObjectPosition(h,model,nextTargetPos)
        nextTargetPos={0.25,0,0.6}
    
        s=sim.getScriptSimulationParameter(sim.handle_self,'outBuffer')
        s=s..sim.packInt32Table({h})
        sim.setScriptSimulationParameter(sim.handle_self,'outBuffer',s)
        h=sim.createPureShape(0,1+2+8+4,{0.1,0.1,0.1},1,nil)
        
        simAddObjectCustomData(h,125487,0)
        sim.setObjectParent(h,model,true)
        sim.setObjectPosition(h,model,startPos)
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
        
   if not paused then
        st=st+sim.getSimulationTimeStep()
        sim.setShapeColor(colorCorrectionFunction(model),nil,0,{0.75,0.75,0.75})
    else --]]
        sim.setShapeColor(colorCorrectionFunction(model),nil,0,{0.8,0.1,0.1})
    end
end 