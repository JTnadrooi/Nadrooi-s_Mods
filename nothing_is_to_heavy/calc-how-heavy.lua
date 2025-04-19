local defaultWeight = data.raw["utility-constants"].default.default_item_weight
local defaultWeightCoefficient = 0.5
local rocket_lift_weight = data.raw["utility-constants"].default.rocket_lift_weight

local function getWeight(itemName, seen, depth)
    seen = seen or {}
    depth = depth or 1
    if seen[itemName] then -- for when starting a loop
        return { weight = defaultWeight, startLoop = seen[itemName]}
    end
    seen[itemName] = depth

    if data.raw["fluid"][itemName] ~= nil then -- if the item is a fluid, return 100
        return { weight = 100 }
    end
    local tmpItem = data.raw["item-with-entity-data"][itemName] -- for spidertrons and more
    if tmpItem ~= nil then
        if tmpItem.weight then
            return { weight = tmpItem.weight}
        end
    end
    local tmpItem = data.raw["tool"][itemName] -- for sciencepacks and more
    if tmpItem ~= nil then
        if tmpItem.weight then
            return { weight = tmpItem.weight}
        end
    end
    
    local item = data.raw["item"][itemName]
    if item == nil then
        error("item is nog an item")
    end
    if item.flags then
        for _, flag in pairs(item.flags) do
            if flag == "spawnable" then
                return { weight = 0 }
            end
            if flag == "only-in-cursor" then
                return { weight = 0 }
            end
        end
    end


    if item.weight then-- some are already set, but this may be nil
        return { weight = item.weight }
    end

    local recipe = data.raw["recipe"][itemName]
    local weight = 0;
    for _, ingredients in pairs(recipe.ingredients) do -- for each ingredient in the recipe
        local ingredientWeight = getWeight(ingredients.name, table.deepcopy(seen))
        if ingredientWeight.startLoop then
            if ingredientWeight.startLoop >= depth then
                return { weight = defaultWeight, startLoop = ingredientWeight.startLoop}
            end
        end
        weight = weight + ingredients.amount * ingredientWeight.weight
    end

    if weight == 0 then -- if mostly to prevent if there are no ingredients in the recipe
        -- item.weight = defaultWeight
        return { weight = defaultWeight }
    end

    local intermediateResult
    if item.ingredient_to_weight_coefficient then
        intermediateResult = weight * item.ingredient_to_weight_coefficient
    else
        intermediateResult = weight * defaultWeightCoefficient
    end

    if recipe.allow_productivity ~= true then
        local simpleResult = rocket_lift_weight / item.stack_size
        if(simpleResult >= weight) then
            -- item.weight = simpleResult
            return { weight = simpleResult }
        end
    end
    local stack_count = rocket_lift_weight / intermediateResult / item.stack_size
    if(stack_count <= 1) then
        return { weight = intermediateResult }
    end
    weight = rocket_lift_weight / math.floor(stack_count) / item.stack_size
    -- item.weight = weight
    return { weight = weight }

end

--bloemgamer