function sysCall_init()
    consoleHandle = sim.auxiliaryConsoleOpen('KPI-viewer', 10000, 2+4)

-- subscriber on Object-Class
    subTrue = simROS.subscribe('/True_Class', 'std_msgs/Int8', 'true_class_callback', 10)
    subPred = simROS.subscribe('/Category', 'std_msgs/Int16', 'nn_class_callback', 10)

    cnt_pred = 1
    cnt_true = 1

    --PARAMETER:  max. number of cuboids
    maxCuboids = 5
    executeOnce = 0

-- initialize arrays in order to collect 
    predClassesArray = {} -- predicted classes from /Category-Topic
    trueClassesArray = {} -- true class/label
    for i=1, maxCuboids do
	predClassesArray[i] = 4
	trueClassesArray[i] = 4
    end

-- initialize matrix
--[[	confusionMtx = {}
	    for i=0,3 do
	      confusionMtx[i] = {}     -- create a new row
	      for j=1, do
		confusionMtx[i][j] = 0
	      end
	    end
--]]
end


function nn_class_callback(msg)
    sim.auxiliaryConsolePrint(consoleHandle,'\nFor Image Nr. ' .. cnt_pred .. ', the neural network says: ' .. msg.data)

-- collect data for later calucations
    predClassesArray[cnt_pred] = msg.data
    cnt_pred = cnt_pred +1
    print("cnt_pred: " .. cnt_pred)
end


function true_class_callback(msg)
    sim.auxiliaryConsolePrint(consoleHandle, '\nFor Image Nr. ' .. cnt_true .. ', the true class is: ' .. msg.data)

-- collect data for later calucations
    trueClassesArray[cnt_true] = msg.data
    cnt_true = cnt_true +1
    print("cnt_true: " .. cnt_true)
end



function sysCall_actuation()
-- calculate precisiona nd recall, when reaching the nmax. number of cuboids
--[[    if (cnt_true == maxCuboids and cnt_pred == maxCuboids and executeOnce == 0) then
	-- Class 0: Nagel
	TP_0 = 0
	FP_0 = 0
	TN_0 = 0
	for i = 1, maxCuboids do
	  if (predClassesArray[i] == 0 and trueClassesArray[i] == 0) then
	    TP_0 = TP_0 +1
	  end
	  if (predClassesArray[i] == 0 and trueClassesArray[i] ~= 0) then
	    FP_0 = FP_0 +1
	  end
	  if (predClassesArray[i] ~= 0 and trueClassesArray[i] == 0) then
	    TN_0 = TN_0 +1
	  end

	sim.auxiliaryConsolePrint(consoleHandle,"\n----------------RESULTS---------------------")
	recall_0 = TP_0/(TP_0 + TN_0)
	precision_0 = TP_0/(TP_0 + FP_0)
	sim.auxiliaryConsolePrint(consoleHandle,"\n--- on Class 0 Nagel: recall: " .. recall_0 .. " and precision: " .. precision_0) 


	-- Class 1: Schraube
	TP_1 = 0
	FP_1 = 0
	TN_1 = 0
	  if (predClassesArray[i] == 1 and trueClassesArray[i] == 1) then
	    TP_1 = TP_1 +1
	  end
	  if (predClassesArray[i] == 1 and trueClassesArray[i] ~= 1) then
	    FP_1 = FP_1 +1
	  end
	  if (predClassesArray[i] ~= 1 and trueClassesArray[i] == 1) then
	    TN_1 = TN_1 +1
	  end

	recall_1 = TP_1/(TP_1 + TN_1)
	precision_1 = TP_1/(TP_1 + FP_1)
	sim.auxiliaryConsolePrint(consoleHandle,"\n--- on Class 1: Schraube: recall: " .. recall_1 .. " and precision: " .. precision_1)

	-- Class 2: Unterlegscheibe
	TP_2 = 0
	FP_2 = 0
	TN_2 = 0
	  if (predClassesArray[i] == 2 and trueClassesArray[i] == 2) then
	    TP_2 = TP_2 +1
	  end
	  if (predClassesArray[i] == 2 and trueClassesArray[i] ~= 2) then
	    FP_2 = FP_2 +1
	  end
	  if (predClassesArray[i] ~= 2 and trueClassesArray[i] == 2) then
	    TN_2 = TN_2 +1
	  end

	recall_2 = TP_0/(TP_2 + TN_2)
	precision_2 = TP_2/(TP_2 + FP_2)
	sim.auxiliaryConsolePrint(consoleHandle,"\n--- on Class 2: Unterlegscheibe: recall: " .. recall_2 .. " and precision: " .. precision_2)

	-- Class 3: None
	TP_3 = 0
	FP_3 = 0
	TN_3 = 0
	  if (predClassesArray[i] == 3 and trueClassesArray[i] == 3) then
	    TP_3 = TP_3 +1
	  end
	  if (predClassesArray[i] == 3 and trueClassesArray[i] ~= 3) then
	    FP_3 = FP_3 +1
	  end
	  if (predClassesArray[i] ~= 3 and trueClassesArray[i] == 3) then
	    TN_3 = TN_3 +1
	  end
	end  	

	recall_3 = TP_3/(TP_3 + TN_3)
	precision_3 = TP_3/(TP_3 + FP_3)
	sim.auxiliaryConsolePrint(consoleHandle,"\n--- on Class 3: None: recall: " .. recall_3 .. " and precision: " .. precision_3)

    executeOnce = executeOnce +1
    end

--]]

--[[
-- print time after max. number of cuboids
    if (cnt_pred == maxCuboids) then
      sim.auxiliaryConsolePrint(consoleHandle, '!!! Lead time for 100 cuboids: ' .. sim.getSimulationTime )
    end
end
--]]


end


function sysCall_sensing()
    if (cnt_true >= maxCuboids and cnt_pred >= maxCuboids and executeOnce == 0) then
	--print arrays
	sim.auxiliaryConsolePrint(consoleHandle,"\nArray of predicted classes: " )	
	for i = 1, maxCuboids do
	  sim.auxiliaryConsolePrint(consoleHandle, predClassesArray[i])
	end

	sim.auxiliaryConsolePrint(consoleHandle,"\nArray of true classes: " )	
	for i = 1, maxCuboids do
	  sim.auxiliaryConsolePrint(consoleHandle, trueClassesArray[i])
	end

	-- Class 0: Nagel
	TP_0 = 0
	FP_0 = 0
	TN_0 = 0
	for i = 1, maxCuboids do
	  if (predClassesArray[i] == 0 and trueClassesArray[i] == 0) then
	    TP_0 = TP_0 +1
	  end
	  if (predClassesArray[i] == 0 and trueClassesArray[i] ~= 0) then
	    FP_0 = FP_0 +1
	  end
	  if (predClassesArray[i] ~= 0 and trueClassesArray[i] == 0) then
	    TN_0 = TN_0 +1
	  end

	-- Class 1: Schraube
	TP_1 = 0
	FP_1 = 0
	TN_1 = 0
	  if (predClassesArray[i] == 1 and trueClassesArray[i] == 1) then
	    TP_1 = TP_1 +1
	  end
	  if (predClassesArray[i] == 1 and trueClassesArray[i] ~= 1) then
	    FP_1 = FP_1 +1
	  end
	  if (predClassesArray[i] ~= 1 and trueClassesArray[i] == 1) then
	    TN_1 = TN_1 +1
	  end


	-- Class 2: Unterlegscheibe
	TP_2 = 0
	FP_2 = 0
	TN_2 = 0
	  if (predClassesArray[i] == 2 and trueClassesArray[i] == 2) then
	    TP_2 = TP_2 +1
	  end
	  if (predClassesArray[i] == 2 and trueClassesArray[i] ~= 2) then
	    FP_2 = FP_2 +1
	  end
	  if (predClassesArray[i] ~= 2 and trueClassesArray[i] == 2) then
	    TN_2 = TN_2 +1
	  end


	-- Class 3: None
	TP_3 = 0
	FP_3 = 0
	TN_3 = 0
	  if (predClassesArray[i] == 3 and trueClassesArray[i] == 3) then
	    TP_3 = TP_3 +1
	  end
	  if (predClassesArray[i] == 3 and trueClassesArray[i] ~= 3) then
	    FP_3 = FP_3 +1
	  end
	  if (predClassesArray[i] ~= 3 and trueClassesArray[i] == 3) then
	    TN_3 = TN_3 +1
	  end
	end  	

	sim.auxiliaryConsolePrint(consoleHandle,"\n----------------RESULTS---------------------")
	recall_0 = TP_0/(TP_0 + TN_0)
	precision_0 = TP_0/(TP_0 + FP_0)
	sim.auxiliaryConsolePrint(consoleHandle,"\n--- on Class 0 Nagel: recall: " .. recall_0 .. " and precision: " .. precision_0) 
	recall_1 = TP_1/(TP_1 + TN_1)
	precision_1 = TP_1/(TP_1 + FP_1)
	sim.auxiliaryConsolePrint(consoleHandle,"\n--- on Class 1: Schraube: recall: " .. recall_1 .. " and precision: " .. precision_1)
	recall_2 = TP_0/(TP_2 + TN_2)
	precision_2 = TP_2/(TP_2 + FP_2)
	sim.auxiliaryConsolePrint(consoleHandle,"\n--- on Class 2: Unterlegscheibe: recall: " .. recall_2 .. " and precision: " .. precision_2)
	recall_3 = TP_3/(TP_3 + TN_3)
	precision_3 = TP_3/(TP_3 + FP_3)
	sim.auxiliaryConsolePrint(consoleHandle,"\n--- on Class 3: None: recall: " .. recall_3 .. " and precision: " .. precision_3)

    executeOnce = executeOnce +1
    end

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
