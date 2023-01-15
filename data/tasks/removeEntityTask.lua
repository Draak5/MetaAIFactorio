RemoveEntityTask = Task:new{taskid = "remove-entity-task"}

function RemoveEntityTask:achieved (args)
    self.force_completed = self.force_completed or false
    local comp = (not self.entity.valid) or self.force_completed

    if (comp) then
        args.player.clear_gui_arrow()
    end
    return comp
end

function RemoveEntityTask:init (args)
    local player = args.player;

    player.set_gui_arrow{type="entity", entity=self.entity}
end

function RemoveEntityTask:tick (args)
    local player = PLAYER;
    self.miningProgress = self.miningProgress or 0;
    self.started = self.started or false
    self.force_completed = self.force_completed or false

    player.set_goal_description("Destroy " .. self.entity.name, self.started);

    local pos = {
        x = self.entity.position.x + self.entity.prototype.collision_box.left_top.x,
        y = self.entity.position.y + self.entity.prototype.collision_box.left_top.y
    }
    if (player.position.x > self.entity.position.x) then pos.x = self.entity.position.x + self.entity.prototype.collision_box.right_bottom.x; end
    if (player.position.y > self.entity.position.y) then pos.y = self.entity.position.y + self.entity.prototype.collision_box.right_bottom.y; end

    if (util.distance(player.position, pos) > 9) then
        args.machine:pushSingle(MoveToPointTask:new{x=pos.x, y=pos.y, margin=5})
    else
        self.miningProgress = self.miningProgress + 1/60
        if (self.miningProgress > self.entity.prototype.mineable_properties.mining_time * 2) then
            if (self.entity.type == "resource") then
                self.force_completed = true
            end
            player.mine_entity(self.entity)
            self.miningProgress = 0
        end
    end

    self.started = true
end
