if not mods["Additional-Turret-revived"] then return end
data.raw["item"]["at-cannon-turret-mk1"].weight = 125 * 1000
data.raw["ammo-turret"]["at-cannon-turret-mk1"].surface_conditions =
{
    {
        property = "pressure",
        min = 10,
    }
}
data.raw["item"]["at-rocket-turret-mk1"].weight = 125 * 1000
data.raw["ammo-turret"]["at-rocket-turret-mk1"].surface_conditions =
{
    {
        property = "pressure",
        min = 10,
    }
}
data.raw["ammo"]["gatling-gun-magazine"].weight = 200 * 1000
data.raw["item"]["at-cannon-turret-mk2"].weight = 1000 * 1000
data.raw["item"]["at-gatling-turret"].weight = 200 * 1000

local mk2CannonTurretRecipe = data.raw["recipe"]["at-cannon-turret-mk2"]
mk2CannonTurretRecipe.ingredients =
{
    { type = "item", name = "superconductor",       amount = 10 },
    { type = "item", name = "quantum-processor",    amount = 15 },
    { type = "item", name = "tungsten-plate",       amount = 15 },
    { type = "item", name = "at-cannon-turret-mk1", amount = 2 },
}

local mk2RocketTurretRecipe = data.raw["recipe"]["at-rocket-turret-mk2"]
mk2RocketTurretRecipe.ingredients =
{
    { type = "item", name = "superconductor",       amount = 10 },
    { type = "item", name = "quantum-processor",    amount = 12 },
    { type = "item", name = "carbon-fiber",         amount = 10 },
    { type = "item", name = "at-rocket-turret-mk1", amount = 2 },
}
local destroyerTurretRecipe = data.raw["recipe"]["at_CR_b"]
destroyerTurretRecipe.ingredients =
{
    { type = "item", name = "superconductor",       amount = 25 },
    { type = "item", name = "quantum-processor",    amount = 20 },
    { type = "item", name = "tungsten-plate",       amount = 20 },
    { type = "item", name = "at-cannon-turret-mk2", amount = 2 },
}


local mk3TurretTech = data.raw["technology"]["turret-mk3-unlock"]
mk3TurretTech.prerequisites = { "quantum-processor", "turret-mk2-unlock" }
mk3TurretTech.unit = data.raw["technology"]["railgun"].unit
-- mk3TurretTech.effects = {
--     { type = "unlock-recipe", recipe = "at_CR_b" },
--     { type = "unlock-recipe", recipe = "at-rocket-turret-mk2" }
-- }

table.insert(data.raw["technology"]["turret-mk3-unlock"].effects,
    { type = "unlock-recipe", recipe = "at-cannon-turret-mk2" }
)

for i, effect in ipairs(data.raw["technology"]["turret-mk3-unlock"].effects) do
    if effect.type == "unlock-recipe" and effect.recipe == "at-cannon-turret-mk2" then
        table.remove(data.raw["technology"]["turret-mk3-unlock"].effects, i)
        break
    end
end

data.raw["technology"]["artillery-set"].prerequisites = { "piranha-research" }

if true then
    local coreRecipe = data.raw["recipe"]["piranha-core"]
    coreRecipe.ingredients =
    {
        { type = "item",  name = "stone",         amount = 10 },
        { type = "item",  name = "carbon",        amount = 5 },
        { type = "fluid", name = "sulfuric-acid", amount = 20 }
    }
    coreRecipe.results =
    {
        { type = "item", name = "piranha-core", amount = 5 },
    }
end
