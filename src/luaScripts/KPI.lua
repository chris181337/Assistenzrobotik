function sysCall_init()
    consoleHandle = sim.auxiliaryConsoleOpen('KPI-viewer', 10000, 2+4)

-- subscriber on Object-Class
    subTrue = simROS.subscribe('/True_Class', 'std_msgs/Int8', 'true_class_callback', 20)
    subPred = simROS.subscribe('/Category', 'std_msgs/Int16', 'nn_class_callback', 20)

-- subscriber on lead time for maxCuboids (100)
--    subTime = simROS.subscribe('/Lead_time', 'std_msgs/Float16', 'lead_time_callback', 20)

-- counter
    cnt_pred = 0
    cnt_true = 0

    --PARAMETER:  max. number of cuboids
    maxCuboids = 10
    executed2 = false

-- initialize arrays in order to collect 
    predClassesArray = {} -- predicted classes from /Category-Topic
    trueClassesArray = {} -- true class/label
    for i=1, maxCuboids do
	predClassesArray[i] = 4
	trueClassesArray[i] = 4
    end

    lead_time = 0
    executed1 = false

    path_scene = sim.getStringParameter(sim.stringparam_scene_path)
    path_results = path_scene .. '/../catkin_ws/results/'
end


function nn_class_callback(msg)
    cnt_pred = cnt_pred +1
-- collect data for later calucations
    predClassesArray[cnt_pred] = msg.data
    sim.auxiliaryConsolePrint(consoleHandle,'\nFor Image Nr. ' .. cnt_pred .. ', the neural network says: ' .. msg.data)
end


function true_class_callback(msg)
    cnt_true = cnt_true +1
-- collect data for later calucations
    trueClassesArray[cnt_true] = msg.data
    sim.auxiliaryConsolePrint(consoleHandle, '\nFor Image Nr. ' .. cnt_true .. ', the true class is: ' .. msg.data)
end

--[[
function lead_time_callback(msg)
    if (not executed1) then
      lead_time = msg.data
      executed1 = true
    end
end
--]]

function sysCall_actuation()
 -- ...
end


function sysCall_sensing()
    if (cnt_true >= maxCuboids and cnt_pred == maxCuboids and (not executed2)) then

	--print array with the predicted classes
	sim.auxiliaryConsolePrint(consoleHandle,"\nArray of pred. classes: " )	
	for i = 1, maxCuboids do
	  sim.auxiliaryConsolePrint(consoleHandle, predClassesArray[i] .. " -- ")
	end

	--print array with the real classes
	sim.auxiliaryConsolePrint(consoleHandle,"\nArray of true classes: " )	
	for i = 1, maxCuboids do
	  sim.auxiliaryConsolePrint(consoleHandle, trueClassesArray[i] .. " -- ")
	end

-- empty counter for each class to calculate the KPIs later
	TP_0 = 0
	FP_0 = 0
	FN_0 = 0
	TN_0 = 0

	TP_1 = 0
	FP_1 = 0
	FN_1 = 0
	TN_1 = 0

	TP_2 = 0
	FP_2 = 0
	FN_2 = 0
	TN_2 = 0

	TP_3 = 0
	FP_3 = 0
	FN_3 = 0
	TN_3 = 0

	for i =1, maxCuboids do
	-- Class 0: Nagel
	  if (predClassesArray[i] == 0 and trueClassesArray[i] == 0) then
	    TP_0 = TP_0 +1
	  end
	  if (predClassesArray[i] == 0 and trueClassesArray[i] ~= 0) then
	    FP_0 = FP_0 +1
	  end
	  if (predClassesArray[i] ~= 0 and trueClassesArray[i] == 0) then
	    TN_0 = TN_0 +1
	  end
	  if (predClassesArray[i] ~= 0 and trueClassesArray[i] ~= 0) then
	    FN_0 = FN_0 +1
	  end

	-- Class 1: Schraube
	  if (predClassesArray[i] == 1 and trueClassesArray[i] == 1) then
	    TP_1 = TP_1 +1
	  end
	  if (predClassesArray[i] == 1 and trueClassesArray[i] ~= 1) then
	    FP_1 = FP_1 +1
	  end
	  if (predClassesArray[i] ~= 1 and trueClassesArray[i] == 1) then
	    TN_1 = TN_1 +1
	  end
	  if (predClassesArray[i] ~= 1 and trueClassesArray[i] ~= 1) then
	    FN_1 = FN_1 +1
	  end


	-- Class 2: Unterlegscheibe
	  if (predClassesArray[i] == 2 and trueClassesArray[i] == 2) then
	    TP_2 = TP_2 +1
	  end
	  if (predClassesArray[i] == 2 and trueClassesArray[i] ~= 2) then
	    FP_2 = FP_2 +1
	  end
	  if (predClassesArray[i] ~= 2 and trueClassesArray[i] == 2) then
	    TN_2 = TN_2 +1
	  end
	  if (predClassesArray[i] ~= 2 and trueClassesArray[i] ~= 2) then
	    FN_2 = FN_2 +1
	  end


	-- Class 3: None
	  if (predClassesArray[i] == 3 and trueClassesArray[i] == 3) then
	    TP_3 = TP_3 +1
	  end
	  if (predClassesArray[i] == 3 and trueClassesArray[i] ~= 3) then
	    FP_3 = FP_3 +1
	  end
	  if (predClassesArray[i] ~= 3 and trueClassesArray[i] == 3) then
	    TN_3 = TN_3 +1
	  end
	  if (predClassesArray[i] ~= 3 and trueClassesArray[i] ~= 3) then
	    FN_3 = FN_3 +1
	  end

	end  	

	-- calculate precisiona and recall for each class
--	sim.auxiliaryConsolePrint(consoleHandle,"\n----------------RESULTS---------------------")
	recallTN_0 = TP_0/(TP_0 + TN_0)
	recallFN_0 = TP_0/(TP_0 + FN_0)
	precision_0 = TP_0/(TP_0 + FP_0)
--	sim.auxiliaryConsolePrint(consoleHandle,"\n--- on Class 0 Nagel --- recall (TN): " .. recallTN_0 .. ", recall (NF): " .. recallFN_0 .. ", precision: " .. precision_0) 

	recallTN_1 = TP_1/(TP_1 + TN_1)
	recallFN_1 = TP_1/(TP_1 + FN_1)
	precision_1 = TP_1/(TP_1 + FP_1)
--	sim.auxiliaryConsolePrint(consoleHandle,"\n--- on Class 1 --- Schraube: recall (TN): " .. recallTN_1 .. ", recall (NF): " .. recallFN_1 .. ", precision: " .. precision_1)

	recallTN_2 = TP_2/(TP_2 + TN_2)
	recallFN_2 = TP_2/(TP_2 + FN_2)
	precision_2 = TP_2/(TP_2 + FP_2)
--	sim.auxiliaryConsolePrint(consoleHandle,"\n--- on Class 2 --- Unterlegscheibe: recall (TN): " .. recallTN_2 .. ", recall (NF): " .. recallFN_2 .. ", precision: " .. precision_2)

	recallTN_3 = TP_3/(TP_3 + TN_3)
	recallFN_3 = TP_3/(TP_3 + FN_3)
	precision_3 = TP_3/(TP_3 + FP_3)
--	sim.auxiliaryConsolePrint(consoleHandle,"\n--- on Class 3 --- None: recall (TN): " .. recallTN_3 .. ", recall (NF): " .. recallFN_3 .. ", precision: " .. precision_3)

	-- calculate correctly predicted cuboids and resulting accuracy
	correctPred = TP_0 + TP_1 + TP_2 + TP_3
	accuracy_all = correctPred/maxCuboids
--	sim.auxiliaryConsolePrint(consoleHandle,"\n--- overall accuracy: " .. accuracy_all)

	noRec = FP_3 + TP_3

	-- write everything into result-file
	-- Open a file in append mode
	file = io.open(path_results .. "result.txt", "a")
	-- set the default output file as test.lua
	io.output(file)
	-- append a word test to the last line of the file
	io.write("\n\n---------------RESULTS on vision--------------------- ")
	io.write("\nrecallTN // recallFN // precision")
	io.write("\n" .. recallTN_0 .. "\t" .. recallFN_0 .. "\t" .. precision_0)
	io.write("\n" .. recallTN_1 .. "\t" .. recallFN_1 .. "\t" .. precision_1)
	io.write("\n" .. recallTN_2 .. "\t" .. recallFN_2 .. "\t" .. precision_2)
	io.write("\n" .. recallTN_3 .. "\t" .. recallFN_3 .. "\t" .. precision_3)
	io.write("\naccuracy: " .. accuracy_all)
	io.write("\nnot recognized: " .. noRec)
	io.write("\nArray of pred. classes: " )	
	for i = 1, maxCuboids do
	  io.write(predClassesArray[i] .. " - ")
	end
	io.write("\nArray of true classes: " )	
	for i = 1, maxCuboids do
	  io.write(trueClassesArray[i] .. " - ")
	end
	io.write("\n\n----------------RESULTS on sorting-------------------- ")
	io.write("\nLead time for " .. maxCuboids .. " cuboids: " .. lead_time)
	io.write("\nAverage lead time for one cuboid: " .. (lead_time/maxCuboids))	
	io.write("\nNr. of correctly sorted cuboids: " .. correctPred)
	io.write("\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
	-- close open file
	io.close(file)

    executed2 = true
    end

end

function sysCall_cleanup()
   simROS.shutdownSubscriber(subTrue)
   simROS.shutdownSubscriber(subPred)
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
