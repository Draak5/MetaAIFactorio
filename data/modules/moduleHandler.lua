
local function RotatePosition(position, rotation)
    local pos = {
        x = position.x,
        y = position.y
    }

    if (rotation == 2) then
        pos = {
            x = -position.y,
            y = position.x
        }
    elseif (rotation == 4) then
        pos = {
            y = -position.y,
            x = -position.x
        }
    elseif (rotation == 6) then
        pos = {
            x = position.y,
            y = -position.x
        }
    end
    return pos;
end

function PlaceModuleInWorld(module)

end

function FindValidPositionForModule(module, rotation)
    local rotation = rotation or 0;
    local player = game.get_player(1);

    if (#module.geometry > 0) then
        -- check geometry
        game.print(baseOrePosition)
        local startPosition = player.surface.find_entities_filtered{position=baseOrePosition, radius=100, limit=1, name=module.geometry[1].name}[1].position;
        
        local posFound = false
        local tries = 0
        while tries < 64 do
            tries = tries + 1
            local pos = startPosition
            pos.x = pos.x + (math.floor(tries/8) - 4)
            pos.y = pos.y + (math.floor(tries%8) - 4)
            if (ValidPositionForModule(module, pos, rotation)) then
                LoadModule(module, pos, rotation);
                game.print("ghost created at " .. pos.x .. ' ' .. pos.y)
                posFound = true
                break;
            end
        end
        game.print(posFound)
    end

    -- check other buildings

    
end

function ValidPositionForModule(module, position, rotation)
    local rotation = rotation or 0;
    local player = game.get_player(1);

    if (#module.geometry == 0) then return true end

    local validGeometry = true
    for _, part in pairs(module.geometry) do
        local pos = RotatePosition(part.position, rotation)
        pos.x = pos.x + position.x;
        pos.y = pos.y + position.y;

        local geometryAtPos = #player.surface.find_entities_filtered{position=pos, name=part.name} == 1
        if (not geometryAtPos) then
            validGeometry = false
        end
    end
    return validGeometry
end

function LoadModule(module, position, rotation)
    local rotation = rotation or 0;
    local player = game.get_player(1);

    local ghostEntities = {}

    local validGeometry = ValidPositionForModule(module, position, rotation)

    if (not validGeometry) then
        player.print("Invalid Geometry!");
        return
    end

    for _, part in pairs(module.blueprint) do
        
        local rot = part.direction + rotation;
        if (rot >= 8) then rot = rot - 8 end;
        
        local pos = RotatePosition(part.position, rotation)
        pos.x = pos.x + position.x;
        pos.y = pos.y + position.y;

        local entity = player.surface.create_entity{position=pos, name="entity-ghost", ghost_name=part.name, force=player.force, direction=rot}
        ghostEntities[#ghostEntities + 1] = entity;
    end

    return ghostEntities;
end


-- /c game.player.surface.create_entity{position={0,0}, name="entity-ghost", ghost_name="stone-furnace",force=game.player.force, direction=5}