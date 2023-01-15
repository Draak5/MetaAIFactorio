Task = {taskid = "nil task"}

function Task:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Task:achieved (arg)
    return false
end

function Task:tick (arg)
end

function Task:init (arg)
end

function Task:entityPlaced (event)
end

function Task:tostring()
    return self.taskid
end