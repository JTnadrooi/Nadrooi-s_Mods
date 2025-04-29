local constants           = data.raw["utility-constants"].default
local DEFAULT_WEIGHT      = constants.default_item_weight
local DEFAULT_COEFFICIENT = 0.5
local ROCKET_LIFT_WEIGHT  = constants.rocket_lift_weight

-- check if an item has a specific flag
local function has_flag(item, flag_name)
    if not item.flags then return false end
    for _, flag in ipairs(item.flags) do
        if flag == flag_name then
            return true
        end
    end
    return false
end

-- recursive weight computation
local function compute_weight(item_name, seen, depth)
    seen  = seen or {}
    depth = depth or 1

    -- detect recursion loop
    if seen[item_name] then
        return { weight = DEFAULT_WEIGHT, startLoop = seen[item_name] }
    end
    seen[item_name] = depth

    -- fluids have fixed weight
    if data.raw.fluid[item_name] then
        return { weight = 100 }
    end

    -- standard items
    local success, item = pcall(vgal.any, item_name)
    if not success then return { weight = DEFAULT_WEIGHT } end
    if not item then
        error("Invalid item: " .. item_name)
    end

    -- zero-weight spawn-only items
    if has_flag(item, "spawnable") or has_flag(item, "only-in-cursor") then
        return { weight = 0 }
    end

    -- already assigned weight
    if item.weight then
        return { weight = item.weight }
    end

    -- derive from recipe ingredients
    local recipe = data.raw.recipe[item_name]
    local total_ing_weight = 0

    if not recipe then -- THIS IS WRONG
        return { weight = DEFAULT_WEIGHT }
    end

    for _, ing in ipairs(recipe.ingredients) do
        local result = compute_weight(ing.name, table.deepcopy(seen), depth + 1)
        -- loop detection
        if result.startLoop and result.startLoop >= depth then
            return { weight = DEFAULT_WEIGHT, startLoop = result.startLoop }
        end
        total_ing_weight = total_ing_weight + ing.amount * result.weight
    end

    if total_ing_weight == 0 then
        return { weight = DEFAULT_WEIGHT }
    end

    -- apply conversion coefficient
    local coeff = item.ingredient_to_weight_coefficient or DEFAULT_COEFFICIENT
    local computed = total_ing_weight * coeff

    -- if not productivity-allowed, consider simple rocket rule
    if not recipe.allow_productivity then
        local simple = ROCKET_LIFT_WEIGHT / item.stack_size
        if simple >= total_ing_weight then
            return { weight = simple }
        end
    end

    -- normalize weight to rocket lift and stack size
    local stacks = ROCKET_LIFT_WEIGHT / computed / item.stack_size
    if stacks <= 1 then
        return { weight = computed }
    end

    local final_weight = ROCKET_LIFT_WEIGHT
        / math.floor(stacks)
        / item.stack_size
    return { weight = final_weight }
end


local function do_table(tableName)
    for _, item in pairs(data.raw[tableName]) do
        local w = compute_weight(item.name).weight
        if w > ROCKET_LIFT_WEIGHT then
            item.weight = ROCKET_LIFT_WEIGHT
        end
    end
end

do_table("item")
do_table("tool")
do_table("ammo")
do_table("module")
do_table("capsule")
do_table("repair-tool")
do_table("armor")
do_table("item-with-entity-data")
do_table("rail-planner")
