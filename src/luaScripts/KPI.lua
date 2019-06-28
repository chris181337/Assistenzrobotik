function sysCall_init()
--    consoleHandle = sim.auxiliaryConsoleOpen(KPI-viewer, 10000, 2+4)
    
-- subscriber on Object-Class
    subNN = simROS.subscribe('/Category', 'std_msgs/Int16', 'nn_class_callback')
    subTrue = simROS.subscribe('/True_Class', 'std_msgs/Int8', 'true_class_callback')

--[[
--  arrays for collecting key values (-1 for empty space)
    class_nominal= {} 
    class_actual = {}
    for i=0, 99 do
      true_class[i] = -1
      nn_class[i] = -1
    end

    cnt_true = 0
    cnt_nn = 0
--]]
end

function nn_class_callback(msg)
    print('Neural Network says: ' .. msg.data)
--[[    class_actual[cnt] = msg.data
    cnt_act = cnt_act + 1
    if (cnt_act == 10) then --PARAMETER
	-- TODO calculate precision & recall per class here
	truePred = 0
	falsePred = 0
	for i=0, 99 do
	  if (class_nominal[i] - class_actual[i] == 0) then
	    truePred = truePred +1 
	  else
	    falsePred = falsePred +1
	  end
	end
	sim.stopSimulation()
    end
--]]
end


function true_class_callback(msg)
    print('True class is: ' .. msg.data)
end

function sysCall_actuation()
    -- put your actuation code here
    --
    -- For example:
    --
    -- local position=sim.getObjectPosition(handle,-1)
    -- position[1]=position[1]+0.001
    -- sim.setObjectPosition(handle,-1,position)
end

function sysCall_sensing()
    -- put your sensing code here
end

function sysCall_cleanup()
    -- do some clean-up here
end

-- You can define additional system calls here:
--[[
function sysCall_suspend()
end

function sysCall_resume()
end

function sysCall_dynCallback(inData)
end

function sysCall_jointCallback(inData)
    return outData
end

function sysCall_contactCallback(inData)
    return outData
end

function sysCall_beforeCopy(inData)
    for key,value in pairs(inData.objectHandles) do
        print("Object with handle "..key.." will be copied")
    end
end

function sysCall_afterCopy(inData)
    for key,value in pairs(inData.objectHandles) do
        print("Object with handle "..key.." was copied")
    end
end

function sysCall_beforeDelete(inData)
    for key,value in pairs(inData.objectHandles) do
        print("Object with handle "..key.." will be deleted")
    end
    -- inData.allObjects indicates if all objects in the scene will be deleted
end

function sysCall_afterDelete(inData)
    for key,value in pairs(inData.objectHandles) do
        print("Object with handle "..key.." was deleted")
    end
    -- inData.allObjects indicates if all objects in the scene were deleted
end
--]]
