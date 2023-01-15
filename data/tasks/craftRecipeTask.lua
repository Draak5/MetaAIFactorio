CraftRecipeTask = Task:new{goalSet = false}

function CraftRecipeTask:achieved (args)
    return self.started and args.player.crafting_queue_size == 0;
end

function CraftRecipeTask:tick (args) 
    local player = PLAYER;

    if (not self.started) then
        local recipe = player.force.recipes[self.recipe]

        if ((not recipe) or (not recipe.enabled)) then
            player.print("Knowledge of recipe '" .. self.recipe .. "' unknown")
            return
        end

        if (player.get_craftable_count(recipe.name) < self.qty) then
            player.print("Insufficient materials to craft ".. self.qty .. " of " .. self.recipe)
            return
        end

        local numEnqueued = player.begin_crafting{count = self.qty, recipe=recipe}
        if (numEnqueued > 0) then
            self.started = true
        end
    end
end
