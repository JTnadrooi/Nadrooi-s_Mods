local function remove_from_recipe(recipe)
    if recipe.ingredients then
        for i, ingredient in ipairs(recipe.ingredients) do
            if ingredient.name == "promethium-asteroid-chunk" then
                table.remove(recipe.ingredients, i)
                break
            end
        end
    end
end

if settings.startup["lp-remove-from-recipes"].value then
    for _, recipe in pairs(data.raw["recipe"]) do
        if not (recipe.name == "promethium-science-pack") then
            remove_from_recipe(recipe)
        end
    end
end

if settings.startup["lp-remove-from-science"].value then
    remove_from_recipe(data.raw["recipe"]["promethium-science-pack"])
end

if settings.startup["lp-remove-from-technologies"].value then
    for _, tech in pairs(data.raw["technology"]) do
        if tech.unit and tech.unit.ingredients then
            for i, ingredient in ipairs(tech.unit.ingredients) do
                if ingredient[1] == "promethium-science-pack" then
                    table.remove(tech.unit.ingredients, i)
                    break
                end
            end
        end
    end
end
