

local log = Logger.makeLogger("SaveBlueprint");

function log_blueprint(blueprint, player)
    player.print("Saving blueprint..")
    log("New Blueprint: ", "INFO")
    
    local dx = -blueprint.get_blueprint_entities()[1].position.x;
    local dy = -blueprint.get_blueprint_entities()[1].position.y;

    for index, entity in pairs(blueprint.get_blueprint_entities()) do
        local pos = {
            x = entity.position.x + dx,
            y = entity.position.y + dy
        }
        local direction = entity.direction or 0;

        local finalString = index .. ": \t{name = \"" .. entity.name .. "\""
        finalString = finalString .. ", position = {x = " .. pos.x .. ", y = " .. pos.y .. "}";
        finalString = finalString .. ", direction = " .. tostring(direction);
        log(finalString .. "}", "INFO");
    end
end
