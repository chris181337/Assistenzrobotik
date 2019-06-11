function sysCall_threadmain()
    local thisObjectHandle = sim.getObjectAssociatedWithScript(sim.handle_self)
    local pathHandle = sim.getObjectHandle('Path0')
    local changePositionOnly = 1
    sim.followPath(thisObjectHandle, pathHandle, changePositionOnly, 0, 0.01, 1)
end