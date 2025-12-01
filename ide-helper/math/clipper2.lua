---@meta

--[[
    Clipper2 is a high-performance polygon clipping and offsetting library using double precision coordinates.
    More documentation can be found at: https://www.angusj.com/clipper2/Docs/Overview.htm

    Usage example:
    local clipper2 = require("clipper2")
    local PointD = clipper2.PointD
    local PathD = clipper2.PathD
    local PathsD = clipper2.PathsD
    local BooleanOpD = clipper2.BooleanOpD
    local Enum = clipper2.Enum
]]

---@class clipper2
clipper2 = {}

---Enumeration types
---@class clipper2.Enum
clipper2.Enum = {}

---Clipping type enumeration
---@class clipper2.Enum.ClipType
clipper2.Enum.ClipType = {
    None = 0,         -- No operation
    Intersection = 1, -- Intersection
    Union = 2,        -- Union
    Difference = 3,   -- Difference
    Xor = 4           -- Exclusive OR
}

---Fill rule enumeration
---@class clipper2.Enum.FillRule
clipper2.Enum.FillRule = {
    EvenOdd = 0,  -- Even-odd rule
    NonZero = 1,  -- Non-zero rule
    Positive = 2, -- Positive rule
    Negative = 3  -- Negative rule
}

---Join type enumeration
---@class clipper2.Enum.JoinType
clipper2.Enum.JoinType = {
    Square = 0, -- Square join
    Bevel = 1,  -- Bevel join
    Round = 2,  -- Round join
    Miter = 3   -- Miter join
}

---End type enumeration
---@class clipper2.Enum.EndType
clipper2.Enum.EndType = {
    Polygon = 0, -- Polygon end
    Joined = 1,  -- Joined end
    Butt = 2,    -- Butt end
    Square = 3,  -- Square end
    Round = 4    -- Round end
}

---Double precision point class
---@class PointD
---@field x number X coordinate
---@field y number Y coordinate
PointD = {}

--[[
    local point = PointD(100.5, 200.7)
]]
---Create a new double precision point
---@param x number X coordinate
---@param y number Y coordinate
---@return PointD
function clipper2.PointD(x, y) end

---Double precision path class (polygon)
---@class PathD
PathD = {}

--[[
    -- Create empty path
    local path = PathD()

    -- Create path with initial points
    local p1 = PointD(0, 0)
    local p2 = PointD(100, 0)
    local p3 = PointD(50, 100)
    local path = PathD(p1, p2, p3)
]]
---Create a new double precision path
---@param ... PointD Optional initial points
---@return vec2
function clipper2.PathD(...) end

--[[
    local path = PathD()
    path:Add(0, 0)
    path:Add(100, 0)
    path:Add(50, 100)
]]
---Add a point to the path
---@param x number X coordinate
---@param y number Y coordinate
function PathD:Add(x, y) end

--[[
    local path = PathD()
    path:Add(0, 0)
    path:Add(100, 0)
    print(path:ChildCount()) -- Outputs 2
]]
---Get the number of points in the path
---@return number
function PathD:ChildCount() end

--[[
    local path = PathD()
    path:Add(0, 0)
    path:Add(100, 0)
    local point = path:Childs(0)
    print(point.x, point.y) -- Outputs 0, 0
]]
---Get the point at the specified index
---@param index number Index (starting from 0)
---@return PointD
function PathD:Childs(index) end

--[[
    local path = PathD()
    path:Add(0, 0)
    path:Clear()
    print(path:ChildCount()) -- Outputs 0
]]
---Clear all points in the path
function PathD:Clear() end

--[[
    local path = PathD()
    path:Add(0, 0)
    path:Add(100, 0)
    path:Add(100, 100)
    path:Add(0, 100)
    print(path:Area()) -- Outputs 10000
]]
---Calculate the area of the polygon
---@return number
function PathD:Area() end

--[[
    local path = PathD()
    path:Add(0, 0)
    path:Add(100, 0)
    path:Add(100, 100)
    path:Add(0, 100)
    print(path:Orientation()) -- Outputs true (clockwise)
]]
---Get the orientation of the polygon
---@return boolean
function PathD:Orientation() end

--[[
    local path = PathD()
    path:Add(0, 0)
    path:Add(100, 0)
    path:Add(100, 100)
    path:Reverse()
]]
---Reverse the order of points in the path
function PathD:Reverse() end

--[[
    local path = PathD()
    path:Add(0, 0)
    path:Add(50, 1)
    path:Add(100, 0)
    local simplified = path:Simplify(2.0, false)
]]
---Simplify the path by removing unnecessary points
---@param epsilon number Simplification tolerance
---@param isClosedPath? boolean Whether the path is closed (default: true)
---@return PathD
function PathD:Simplify(epsilon, isClosedPath) end

--[[
    local path = PathD()
    path:Add(0, 0)
    path:Add(100, 0)
    path:Add(100, 100)
    path:Add(0, 100)
    local point = PointD(50, 50)
    print(path:Contains(point)) -- Outputs 1 (inside)
]]
---Check if a point is inside the polygon
---@param point PointD Point to test
---@return number
function PathD:Contains(point) end

---Check if the path is visible on 2D screen
---@return boolean
function PathD:OnScreen2D() end

---Check if the path is visible on 3D screen
---@param y? number Y coordinate (default: 0)
---@return boolean
function PathD:OnScreen3D(y) end

--[[
    local path = PathD()
    path:Add(0, 0)
    path:Add(100, 0)
    path:Add(50, 100)
    path:Draw2D(2, 0xFF00FF00) -- Green line, 2 pixels wide
]]
---Draw the path in 2D
---@param width? number Line width (default: 0)
---@param color? number ARGB format color (default: 0xffffffff)
function PathD:Draw2D(width, color) end

--[[
    local path = PathD()
    path:Add(0, 0)
    path:Add(100, 0)
    path:Add(50, 100)
    path:Draw3D(player.y, 2, 0xFF00FF00)
]]
---Draw the path in 3D
---@param y number Y coordinate
---@param width? number Line width (default: 0)
---@param color? number ARGB format color (default: 0xffffffff)
function PathD:Draw3D(y, width, color) end

--[[
    local path = PathD()
    path:Add(0, 0)
    path:Add(100, 0)
    path:Add(50, 100)
    local p0 = PointD(25, -10)
    local p1 = PointD(25, 110)
    print(path:Intersection(p0, p1)) -- Outputs true
]]
---Test if the path intersects with a line segment
---@overload fun(self: PathD, p0: PointD, p1: PointD): boolean
---@param x0 number Line start X coordinate
---@param y0 number Line start Y coordinate
---@param x1 number Line end X coordinate
---@param y1 number Line end Y coordinate
---@return boolean
function PathD:Intersection(x0, y0, x1, y1) end

---Get intersection points between the path and a line segment
---@overload fun(self: PathD, p0: PointD, p1: PointD): PathD
---@param x0 number Line start X coordinate
---@param y0 number Line start Y coordinate
---@param x1 number Line end X coordinate
---@param y1 number Line end Y coordinate
---@return PathD
function PathD:IntersectionPoint(x0, y0, x1, y1) end

--[[
    -- Create empty collection
    local paths = PathsD()

    -- Create collection with initial paths
    local path1 = PathD()
    local path2 = PathD()
    local paths = PathsD(path1, path2)
]]
---Create a new path collection
---@param ... PathD Optional initial paths
---@return PathsD
function clipper2.PathsD(...) end

---Double precision path collection class
---@class PathsD
PathsD = {}

--[[
    local paths = PathsD()
    local path = PathD()
    path:Add(0, 0)
    path:Add(100, 0)
    path:Add(50, 100)
    paths:Add(path)
]]
---Add a path to the collection
---@param path PathD Path to add
function PathsD:Add(path) end

---Get the number of paths in the collection
---@return number
function PathsD:ChildCount() end

---Get the path at the specified index
---@param index number Index (starting from 0)
---@return PathD
function PathsD:Childs(index) end

---Clear all paths in the collection
function PathsD:Clear() end

---Simplify all paths in the collection
---@param epsilon number Simplification tolerance
---@param isClosedPath? boolean Whether paths are closed (default: true)
---@return PathsD
function PathsD:Simplify(epsilon, isClosedPath) end

---Reverse the order of points in all paths in the collection
function PathsD:Reverse() end

--[[
    local paths = PathsD()
    local path = PathD()
    path:Add(0, 0)
    path:Add(100, 0)
    path:Add(100, 100)
    path:Add(0, 100)
    paths:Add(path)
    local offset_paths = paths:Offset(10, Enum.JoinType.Round, Enum.EndType.Polygon)
]]
---Create offset paths from the collection
---@param delta number Offset distance (positive for expansion, negative for contraction)
---@param joinType number Join type from Enum.JoinType
---@param endType? number End type from Enum.EndType (default: 0)
---@return PathsD
function PathsD:Offset(delta, joinType, endType) end

---Draw all paths in the collection in 2D
---@param width? number Line width (default: 0)
---@param color? number ARGB format color (default: 0xffffffff)
function PathsD:Draw2D(width, color) end

---Draw all paths in the collection in 3D
---@param y number Y coordinate
---@param width? number Line width (default: 0)
---@param color? number ARGB format color (default: 0xffffffff)
function PathsD:Draw3D(y, width, color) end

--[[
    local subjects = PathsD()
    local clips = PathsD()
    local solution = PathsD()

    -- Create subject rectangle
    local subject = PathD()
    subject:Add(0, 0)
    subject:Add(100, 0)
    subject:Add(100, 100)
    subject:Add(0, 100)
    subjects:Add(subject)

    -- Create clipping circle (approximated)
    local clip = PathD()
    for i = 0, 31 do
        local angle = i * 2 * math.pi / 32
        local x = 50 + 30 * math.cos(angle)
        local y = 50 + 30 * math.sin(angle)
        clip:Add(x, y)
    end
    clips:Add(clip)

    -- Perform intersection operation
    local result = BooleanOpD(
        Enum.ClipType.Intersection,
        Enum.FillRule.NonZero,
        subjects,
        clips,
        solution,
        2,
        false
    )

    -- Draw result
    cb.add(cb.draw, function()
        for i = 0, solution:ChildCount() - 1 do
            local path = solution:Childs(i)
            path:Draw2D(2, 0xFF00FF00)
        end
    end)
]]
---Perform boolean operations on path collections
---@param clipType number Operation type from Enum.ClipType
---@param fillRule number Fill rule from Enum.FillRule
---@param subjects PathsD Subject paths
---@param clips PathsD Clipping paths
---@param solution PathsD Result paths (output)
---@param precision number Calculation precision
---@param reverse_solution boolean Whether to reverse result orientation
---@return number
function clipper2.BooleanOpD(clipType, fillRule, subjects, clips, solution, precision, reverse_solution) end

---Solve polynomial equations using Eigen library
---@param a number Polynomial coefficient
---@param b number Polynomial coefficient
---@param c number Polynomial coefficient
---@param d number Polynomial coefficient
---@param e number Polynomial coefficient
---@return PathD
function clipper2.Eigen_PolynomialSolver(a, b, c, d, e) end

---Solve polynomial equations using Eigen library and return only real roots
---@param a number Polynomial coefficient
---@param b number Polynomial coefficient
---@param c number Polynomial coefficient
---@param d number Polynomial coefficient
---@param e number Polynomial coefficient
---@return PathD
function clipper2.Eigen_PolynomialSolver_realRoots(a, b, c, d, e) end

--[[
Complex boolean operation example:

local clipper2 = require("clipper2")

-- Create multiple overlapping circles
local function create_circle(center_x, center_y, radius, segments)
    local path = clipper2.PathD()
    for i = 0, segments - 1 do
        local angle = i * 2 * math.pi / segments
        local x = center_x + radius * math.cos(angle)
        local y = center_y + radius * math.sin(angle)
        path:Add(x, y)
    end
    return path
end

local function on_draw()
    local subjects = clipper2.PathsD()
    local clips = clipper2.PathsD()
    local solution = clipper2.PathsD()

    -- Create overlapping circles
    local circle1 = create_circle(100, 100, 50, 32)
    local circle2 = create_circle(150, 100, 50, 32)
    local circle3 = create_circle(125, 150, 50, 32)

    subjects:Add(circle1)
    clips:Add(circle2)
    clips:Add(circle3)

    -- Perform union operation
    local result = clipper2.BooleanOpD(
        clipper2.Enum.ClipType.Union,
        clipper2.Enum.FillRule.NonZero,
        subjects,
        clips,
        solution,
        2,
        false
    )

    if result == 1 then
        -- Draw unified shape
        for i = 0, solution:ChildCount() - 1 do
            local path = solution:Childs(i)
            path:Draw2D(3, 0xFF00FFFF)
        end

        -- Create offset version
        local offset_solution = solution:Offset(10, clipper2.Enum.JoinType.Round)
        for i = 0, offset_solution:ChildCount() - 1 do
            local path = offset_solution:Childs(i)
            path:Draw2D(1, 0xFFFF0000)
        end
    end
end

cb.add(cb.draw, on_draw)
]]

return clipper2
