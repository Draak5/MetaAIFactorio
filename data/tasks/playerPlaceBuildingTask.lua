PlayerPlaceBuildingTask = Task:new{taskid = "player-place-building-task"}

function PlayerPlaceBuildingTask:achieved (args)
    if (self.completed) then
        args.player.set_goal_description("");
    end

    return self.completed
end

function PlayerPlaceBuildingTask:init (args)
    local player = args.player;
    local entity = player.surface.create_entity{name="entity-ghost", ghost_name=self.type, position=self.position, force=player.force}

    player.set_gui_arrow{type="entity", entity=entity}
end

function PlayerPlaceBuildingTask:tick (args)
    local player = PLAYER;
    self.completed = self.completed or false
    self.started = self.started or false

    local entities = player.surface.find_entities_filtered{position=self.position}


    PLAYER.set_goal_description("Place " .. self.type, self.started);

    self.started = true
end

function PlayerPlaceBuildingTask:entityPlaced (event)
	local player = game.get_player(event.player_index);
	local entity = event.created_entity

    if (entity.name == self.type) then
        self.completed = true
    end
end