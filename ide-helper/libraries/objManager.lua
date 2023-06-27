---@class ObjManager
objManager = {}

--- Returns the player object.
---@return hero.obj
function objManager.player()
end

--- Returns the maximum object count.
---@return number
function objManager.maxObjects()
end

--- Returns the game object at the specified index.
---@param i number
---@return obj
function objManager.get(i)
end

--- Returns the number of enemy heroes.
---@return number
function objManager.enemies_n()
end

--- Returns an array of enemy hero objects.
---@return hero.obj[]
function objManager.enemies()
end

--- Returns the number of ally heroes.
---@return number
function objManager.allies_n()
end

--- Returns an array of ally hero objects.
---@return hero.obj[]
function objManager.allies()
end

--- Returns the number of minions of the respective team.
---@param team string
---@return number
function objManager.minions_size(team)
end

--- Returns the minion object at the specified index and team.
---@param team string
---@param i number
---@return minion.obj
function objManager.minions(team, i)
end

--- Returns the number of turrets of the respective team.
---@param team string
---@return number
function objManager.turrets_size(team)
end

--- Returns the turret object at the specified index and team.
---@param team string
---@param i number
---@return turret.obj
function objManager.turrets(team, i)
end

--- Returns the number of inhibitors of the respective team.
---@param team string
---@return number
function objManager.inhibs_size(team)
end

--- Returns the inhibitor object at the specified index and team.
---@param team string
---@param i number
---@return inhib.obj
function objManager.inhibs(team, i)
end

--- Returns the nexus object of the respective team.
---@param team string
---@return nexus.obj
function objManager.nexus(team)
end

--- Executes the provided function in a loop.
---@param f function
---@return void
function objManager.loop(f)
end

---@type ObjManager
_G.objManager = objManager
