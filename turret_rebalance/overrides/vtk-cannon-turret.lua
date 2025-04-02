if not mods["vtk-cannon-turret"] then return end
data.raw["ammo-turret"]["vtk-cannon-turret"].surface_conditions =
{
    {
        property = "pressure",
        min = 10,
    }
}
local heavyTurretRecipe = data.raw["recipe"]["vtk-cannon-turret-heavy"]
heavyTurretRecipe.category = "crafting"
heavyTurretRecipe.ingredients =
{
    { type = "item", name = "low-density-structure", amount = 10 },
    { type = "item", name = "superconductor",        amount = 5 },
    { type = "item", name = "quantum-processor",     amount = 10 },
    { type = "item", name = "tungsten-plate",        amount = 15 },
}
local heavyTurretTech = data.raw["technology"]["vtk-cannon-turret-heavy-unlock"]
heavyTurretTech.prerequisites = { "quantum-processor", "vtk-cannon-turret-unlock" }
heavyTurretTech.unit = data.raw["technology"]["railgun"].unit
data.raw["item"]["vtk-cannon-turret-heavy"].weight = 1000 * 1000
