ClearSpaceshipWreckTask = Task:new{taskid = "clear-spaceship-wreck-task"}

function ClearSpaceshipWreckTask:achieved (args)
    local wrecks = self.targetWrecks or {1, 2, 3}
    return #wrecks == 0
end

function ClearSpaceshipWreckTask:init (args)
    local player = args.player;
    
    self.targetWrecks = {}

    local allSpawnEntities = player.surface.find_entities_filtered{position={x=0, y=0}, radius=55}
    for _, entity in pairs(allSpawnEntities) do
        if (string.find(entity.name, "wreck") or entity.name == "crash-site-spaceship") then
            self.targetWrecks[#self.targetWrecks + 1] = entity
        end
    end

    if (#self.targetWrecks > 0) then
        for _, entity in pairs(self.targetWrecks) do
            args.machine:pushSingle(RemoveEntityTask:new{entity=entity})
        end
    end

end

