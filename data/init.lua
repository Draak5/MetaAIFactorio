require("data.tasks.task")
require("data.tasks.pathfindToPointTask")
require("data.tasks.moveToPointTask")
require("data.tasks.craftRecipeTask")
require("data.tasks.removeEntityTask")
require("data.tasks.earlyGame.clearSpaceshipWreckTask")
require("data.tasks.earlyGame.findEarlyCoalTask")

require("data.tasks.playerGatherResourceTask")
require("data.tasks.playerPlaceBuildingTask")

require("data.modules.moduleHandler")
require("data.modules.earlyGameModules")

require("data.goalMachine")
require("data.ai")
require("data.save_blueprint")


PLAYER = nil
ACTIVE = false

local function start_ai(event)
    game.print("* START AI");
    
	local player = game.get_player(event.player_index);
    
    PLAYER = player;
    ACTIVE = true;
end

local function stop_ai(event)
    game.print("* STOP AI");
    
    ACTIVE = false
end

local function save_blueprint(event)
    local player = game.get_player(event.player_index);
    local item = player.cursor_stack;

    if (item.valid_for_read) then
        if (item.is_blueprint) then
            log_blueprint(item, player)
        else
            player.print("Item is not a blueprint!")
        end
    end
end

commands.add_command("start", "Wakes up the AI", start_ai);
commands.add_command("stop", "Force stop the AI", stop_ai);
commands.add_command("save_blueprint", "Save cursor blueprint to logs", save_blueprint);
commands.add_command("tasks", "Returns goal machine tasks", function(event) print_goal_machine(event) end)


local initialized = false;
local function tick(event)
    if (not initialized) then
        start()
        initialized = true
    end
    if (ACTIVE) then
        update()
    end
end

script.on_event(defines.events.on_tick, tick);
script.on_event(defines.events.on_player_created, start_ai);
script.on_event(defines.events.on_built_entity, function(event)
    handle_entity_placed(event)
end)

