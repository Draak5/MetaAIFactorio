FindEarlyCoalTask = Task:new{taskid = "find-early-coal-task"}

function FindEarlyCoalTask:achieved (args)
    return args.player.get_main_inventory().get_item_count("coal") >= 10;
end

function FindEarlyCoalTask:init (args)
    local player = args.player;
    
    self.closestOreTile = nil

    local allHugeRocks = player.surface.find_entities_filtered{position=args.machine.baseOrePosition, radius=75, name="rock-huge"}
    player.print(#allHugeRocks)
    if (#allHugeRocks > 0) then
        args.machine:pushSingle(RemoveEntityTask:new{entity=allHugeRocks[1]})
    else
        local coalTiles = player.surface.find_entities_filtered{name="coal"}
        local closestTile = coalTiles[1];
        local cDist = 1000;
        for i,tile in pairs(coalTiles) do
            local dist = util.distance(tile.position, player.position);
            if (dist < cDist) then
                cDist = dist;
                closestTile = tile;
            end
        end
        self.closestOreTile = closestTile
    end
end

function FindEarlyCoalTask:tick (args)
    local player = args.player;

    if (self.closestOreTile ~= nil) then
        args.machine:pushSingle(RemoveEntityTask:new{entity = self.closestOreTile})
    end
    

end

