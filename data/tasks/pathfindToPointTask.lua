require 'util'--("util.utilMath")
require 'task'
require 'util/pathfinding_fringe'

local log = Logger.makeLogger("PathfindToPointTask");
PathfindToPointTask = {}
PathfindToPointTask.__index = PathfindToPointTask

local heuristicCoeff = 1;
local costCoeff = 1;
local playerMarginCoeff = 1.05;

function PathfindToPointTask:new (o)
    c = o
    setmetatable(c, PathfindToPointTask)
    c.pathFound = false
    return c
end

function PathfindToPointTask:achieved()
    return self.pathFound;
end

local impassibleTiles = {
    "out-of-map",
    "deepwater",
    "deepwater-green",
    "water",
    "water-green"
}

function PathfindToPointTask:isPassable(player, tile)
    local onPlayerLayer = false;
    for i, tileType in ipairs(impassibleTiles) do
        if (tile.prototype.name == tileType) then
            Logger.log("Found impassible tile " .. tileType);
            onPlayerLayer = true;
        end
    end
    if (onPlayerLayer) then
        return false
    end

    return true
end

function PathfindToPointTask:getBoundingBox(player)
    return {
        left_top = {math.min(player.position.x, self.x), math.min(player.position.y, self.y)},
        right_bottom = {math.max(player.position.x, self.x), math.max(player.position.y, self.y)}
    };
end

function PathfindToPointTask:contains(arr, item)
    for i, other in pairs(arr) do
        if (other == item) then
            return true
        end
    end
    return false;
end

function PathfindToPointTask:pointCollidesWithEntities(point, entities, excl)
    excl = excl or {};
    local player_margin = player.character.prototype.collision_box;
    local player_margins = {
        left_top = {x = player_margin.left_top.x * playerMarginCoeff, y = player_margin.left_top.y * playerMarginCoeff},
        right_bottom = {x = player_margin.right_bottom.x * playerMarginCoeff, y = player_margin.right_bottom.y * playerMarginCoeff},
    };

    for i, entity in pairs(entities) do
        if (not self:contains(excl, entity)) then
            local box = entity.prototype.collision_box;
            local hitbox = {
                left_top = {x = entity.position.x + box.left_top.x + player_margins.left_top.x, y = entity.position.y + box.left_top.y + player_margins.left_top.y},
                right_bottom = {x = entity.position.x + box.right_bottom.x + player_margins.right_bottom.x, y = entity.position.y + box.right_bottom.y + player_margins.right_bottom.y}
            }
            if (point.x > hitbox.left_top.x and point.x < hitbox.right_bottom.x) then
                if (point.y > hitbox.left_top.y and point.y < hitbox.right_bottom.y) then
                    return true
                end
            end

        end
    end

    return false

end

-- returns list of positions
function PathfindToPointTask:pathfind()
    player = PLAYER

    local nodes = {}
    local player_margin = player.character.prototype.collision_box;

    game.print(tostring(self:getBoundingBox(player)))
    local trees = player.surface.find_entities_filtered{area=self:getBoundingBox(player), type="tree"}
    for i, tree in pairs(trees) do
        local box = tree.prototype.collision_box;
        local topLeft = {
            x = tree.position.x + box.left_top.x + (player_margin.left_top.x * playerMarginCoeff),
            y = tree.position.y + box.left_top.y + (player_margin.left_top.y * playerMarginCoeff)
        }
        local topRight = {
            x = tree.position.x + box.right_bottom.x + (player_margin.right_bottom.x * playerMarginCoeff),
            y = tree.position.y + box.left_top.y + (player_margin.left_top.y * playerMarginCoeff)
        }
        local botLeft = {
            x = tree.position.x + box.left_top.x + (player_margin.left_top.x * playerMarginCoeff),
            y = tree.position.y + box.right_bottom.y + (player_margin.right_bottom.y * playerMarginCoeff)
        }
        local botRight = {
            x = tree.position.x + box.right_bottom.x + (player_margin.right_bottom.x * playerMarginCoeff),
            y = tree.position.y + box.right_bottom.y + (player_margin.right_bottom.y * playerMarginCoeff)
        }

        for i, point in pairs({topLeft, topRight, botLfet, botRight}) do
            if (not self:pointCollidesWithEntities(point, trees, {tree})) then
                nodes[#nodes + 1] = point
            end
        end
    end
    
    log("Found " .. #trees .. " trees, and generated " .. #nodes .. " nav points (expected " .. #trees*4 .. ")", "INFO")

    local fringe = Fringe:new();
    
    -- while (fringe:size() > 0) do

    -- end

    log("Error! Unable to find path!", "ERROR")
    return {}
end

function PathfindToPointTask:tick(args)
    local player = PLAYER;

    if (not self.pathFound) then
        local dest = player.surface.get_tile(self.x, self.y)
        if (not self:isPassable(player, dest)) then
            log("Destination is not walkable terrain (" .. dest.prototype.name .. ")")
            player.print("Destination is not walkable terrain (" .. dest.prototype.name .. ")")
            self.pathFound = true;
            return;
        end

        local path = self:pathfind(player);
        log("Path Found!", "INFO")
        for i, position in ipairs(path) do
            log("Path Step: " .. position.x .. ", " .. position.y, "INFO")
            path[i] = MoveToPointTask:new({x = position.x, y = position.y + 0.5});
        end
        args.machine:pushNext(path);
        self.pathFound = true;
    else
        player.print("Path is already found!")
    end

end