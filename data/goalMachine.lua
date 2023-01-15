GoalMachine = Task:new()

function GoalMachine:achieved(arg)
    return self.goals == nil
end

function GoalMachine:init(arg)
    self.baseOrePosition = {x=0, y=0}
end

function GoalMachine:tick(arg)

    if (self.goals ~= nil) then
        if (self.goals.current:achieved{player=PLAYER, machine=self}) then
            PLAYER.print("Goal ".. self.goals.current:tostring() .." Achieved");
            PLAYER.set_goal_description("");
            self.goals = self.goals.next;
        else
            if (not self.goals.init) then
                self.goals.current:init{player=PLAYER, machine=self};
                self.goals.init = true;
            end
            self.goals.current:tick{player=PLAYER, machine=self};
        end
    end

end

function GoalMachine:entityPlaced(event)
    if (self.goals ~= nil) then
        self.goals.current:entityPlaced(event);
    end
end

function GoalMachine:pushSingle(goal)
    self.goals = {current = goal, next = self.goals, init = false}
end

function GoalMachine:pushStart(goals)
    goals = array_reverse(goals)
    for i, goal in pairs(goals) do
        self:pushSingle(goal)
    end
end

function GoalMachine:pushNext(goal)
    self.goals[#self.goals + 1] = goal
end

function GoalMachine:logTasks(player)
    self:logTask(1, self.goals, player)
end
function GoalMachine:logTask(index, goals, player)
    player.print(index.. ": " .. goals.current:tostring())
    if (goals.next ~= nil) then
        self:logTask(index+1, goals.next, player)
    end
end

function array_reverse(x)
    local n, m = #x, #x/2
    for i=1, m do
      x[i], x[n-i+1] = x[n-i+1], x[i]
    end
    return x
  end