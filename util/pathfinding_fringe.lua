
Fringe = {}
Fringe.__index = Fringe

function Fringe:new()
    o = {}
    o.parent = self;
    setmetatable(o, Fringe);
    return o
end

