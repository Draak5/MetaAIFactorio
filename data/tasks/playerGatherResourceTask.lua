PlayerGatherResourceTask = Task:new{taskid = "player-gather-resource-task"}

function PlayerGatherResourceTask:achieved (args)
    local comp = args.player.get_main_inventory().get_item_count(self.type) >= self.qty;

    if (comp) then
        args.player.set_goal_description("");
    end

    return comp
end

function PlayerGatherResourceTask:tick (args)
    local player = PLAYER;
    self.started = self.started or false
    
    local remainingAmount = self.qty - player.get_main_inventory().get_item_count(self.type)
    PLAYER.set_goal_description("Gather " .. remainingAmount .. " " .. self.type .. " ("..self.qty..")", self.started);

    self.started = true;
end