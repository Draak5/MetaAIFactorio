require('data.goalMachine')

local goalMachine = GoalMachine:new();

goalMachine:pushStart({
    -- ClearSpaceshipWreckTask:new(),
    -- FindEarlyCoalTask:new()
    -- CraftRecipeTask:new{recipe = "stone-furnace", qty = 1},
    -- PlayerGatherResourceTask:new{type = "iron-ore", qty = 9},
    -- PlayerGatherResourceTask:new{type = "coal", qty = 1},
    -- PlayerPlaceBuildingTask:new{type = "stone-furnace", position={x=30, y=-66}},
    --PathfindToPointTask:new{x = 50, y = -30}
    -- MoveToPointTask:new{x = 0, y = 0}
    -- CraftRecipeTask:new{recipe = "iron-axe"}
    -- GatherResourceTask:new{type = "iron-ore", qty = 10}
})


baseOrePosition = {x=0, y=0}
function start()
    local ores = game.get_player(1).surface.find_entities_filtered{type="resource", position={x=0, y=0}, radius=130};
    local totalX = 0;
    local totalY = 0;
    for key,v in pairs(ores) do
        totalX = totalX + v.position.x;
        totalY = totalY + v.position.y;
    end
    totalX = totalX / #ores
    totalY = totalY / #ores

    baseOrePosition.x = totalX;
    baseOrePosition.y = totalY;

    goalMachine.baseOrePosition = baseOrePosition

    -- FindValidPositionForModule(EarlyGameModules.burnerMinerToFurnace, 0)
    -- LoadModule(EarlyGameModules.burnerMinerToFurnace, {x=34.5, y=-30.5}, 0)
end

local done = false
local initialized = false
function update()
    local player = PLAYER;

    if (not goalMachine:achieved{ player = player }) then
        goalMachine:tick{player = player}
    elseif (not done) then
        done = true
        player.print("Completed all goals")
    end
    
end


function handle_entity_placed(event)
    goalMachine:entityPlaced(event)
end

function print_goal_machine(event)
    local player = game.get_player(event.player_index);
    goalMachine:logTasks(player)
end