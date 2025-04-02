data.raw["assembling-machine"]["assembling-machine-1"].crafting_speed = 0.5
data.raw["assembling-machine"]["assembling-machine-2"].crafting_speed = 1.0
data.raw["assembling-machine"]["assembling-machine-3"].crafting_speed = 2.0

data.raw["furnace"]["electric-furnace"].crafting_speed = 4.0

local base_speed = 0.03125 -- yellow belt
local new_line = string.char(10)


local prototypes_string = "local prototypes = " .. new_line .. "  {" .. new_line

local autoprototypes = {}

local tiers = {} -- for table like tiers = {["transport-belt"] = {[1] = true, [2] = true, [3] = true}, ["underground-belt"] = {[1] = true, [2] = true, [3] = true}}

for i, type_name in pairs({ 'transport-belt', 'underground-belt', 'splitter', 'loader', "loader-1x1" }) do
	if not tiers[type_name] then tiers[type_name] = {} end

	local type_prot = data.raw[type_name]
	for prot_name, prot in pairs(type_prot) do
		if prot.speed > 0 then
			local tier = (prot.speed / base_speed)
			if not tiers[type_name][tier] then tiers[type_name][tier] = {} end
			table.insert(tiers[type_name][tier], prot_name)
			prototypes_string = (prototypes_string .. "    {type = '" .. type_name .. "', name = '" .. prot_name .. "', tier = " .. tier .. "}," .. new_line)
			table.insert(autoprototypes, { type = type_name, name = prot_name, tier = tier })
		end
	end
end
log(prototypes_string .. "  }")


function next_not_empty_value_index(tabl, start_index)
	-- for i = start_index, end_index do -- how about next_index = 9.75?
	for i, v in pairs(tabl) do
		if (i >= start_index) and tabl[i] then
			return i
		end
	end
end

for type_name, ts in pairs(tiers) do
	-- log ('unsorted: ' .. serpent.line (ts))
	-- table.sort(ts)
	-- log ('  sorted: ' .. serpent.line (ts))
	local are_tiers_correct = true
	local higherst_tier = 1
	for tier, nil_or_table in pairs(ts) do
		if tier > higherst_tier then higherst_tier = tier end
	end
	for i = 1, (higherst_tier - 1) do
		if ts[i] and ts[i + 1] then
			-- ok
		else
			are_tiers_correct = false
		end
	end

	if not are_tiers_correct then -- renumber them
		log('must be fixed: ' .. type_name)
		for i = 1, higherst_tier do
			if not (ts[i]) then
				local next_index = next_not_empty_value_index(ts, (i + 1))
				if next_index then
					ts[i] = ts[next_index]
					ts[next_index] = nil
					for j, autoprototype in pairs(autoprototypes) do
						if (autoprototype.type == type_name) then
							for k, prot_name in pairs(ts[i]) do
								if (autoprototype.name == prot_name) then
									log('correction: ' ..
										prot_name ..
										' (' .. type_name .. ') old tier: ' .. autoprototype.tier .. ' new tier: ' .. i)
									autoprototype.tier = i
								end
							end
						end
					end
				end
			end
		end
	end
end


local prototypes =
{
	-- transport-belt

	{ type = 'transport-belt',   name = 'basic-transport-belt',                                   tier = 0 }, -- bob logistics

	{ type = 'transport-belt',   name = 'transport-belt',                                         tier = 1 }, -- vanilla
	{ type = 'transport-belt',   name = 'fast-transport-belt',                                    tier = 2 }, -- vanilla
	{ type = 'transport-belt',   name = 'express-transport-belt',                                 tier = 3 }, -- vanilla

	{ type = 'transport-belt',   name = 'turbo-transport-belt',                                   tier = 4 }, -- bob logistics
	{ type = 'transport-belt',   name = 'ultimate-transport-belt',                                tier = 5 }, -- bob logistics

	{ type = 'transport-belt',   name = 'ultra-fast-belt',                                        tier = 4 }, -- UltimateBelts
	{ type = 'transport-belt',   name = 'extreme-fast-belt',                                      tier = 5 }, -- UltimateBelts  -- cannot see animation
	{ type = 'transport-belt',   name = 'ultra-express-belt',                                     tier = 6 }, -- UltimateBelts
	{ type = 'transport-belt',   name = 'extreme-express-belt',                                   tier = 7 }, -- UltimateBelts
	{ type = 'transport-belt',   name = 'ultimate-belt',                                          tier = 8 }, -- UltimateBelts

	{ type = 'transport-belt',   name = 'uranium-transport-belt',                                 tier = 4 }, -- uranium-belts-upd

	-- beltlayer
	{ type = 'transport-belt',   name = 'beltlayer-bpproxy-basic-transport-belt',                 tier = 0 },

	{ type = 'transport-belt',   name = 'beltlayer-bpproxy-transport-belt',                       tier = 1 },
	{ type = 'transport-belt',   name = 'beltlayer-bpproxy-fast-transport-belt',                  tier = 2 },
	{ type = 'transport-belt',   name = 'beltlayer-bpproxy-express-transport-belt',               tier = 3 },

	{ type = 'transport-belt',   name = 'beltlayer-bpproxy-turbo-transport-belt',                 tier = 4 },
	{ type = 'transport-belt',   name = 'beltlayer-bpproxy-ultimate-transport-belt',              tier = 5 },

	{ type = 'transport-belt',   name = 'beltlayer-bpproxy-ultra-fast-belt',                      tier = 4 },
	{ type = 'transport-belt',   name = 'beltlayer-bpproxy-extreme-fast-belt',                    tier = 5 },
	{ type = 'transport-belt',   name = 'beltlayer-bpproxy-ultra-express-belt',                   tier = 6 },
	{ type = 'transport-belt',   name = 'beltlayer-bpproxy-extreme-express-belt',                 tier = 7 },
	{ type = 'transport-belt',   name = 'beltlayer-bpproxy-ultimate-belt',                        tier = 8 },

	{ type = 'transport-belt',   name = 'rapid-transport-belt-mk1',                               tier = 4 }, -- FactorioExtended Plus-Transport
	{ type = 'transport-belt',   name = 'rapid-transport-belt-mk2',                               tier = 5 },

	{ type = 'transport-belt',   name = 'k-transport-belt',                                       tier = 4 }, -- Krastorio

	-- underground-belt
	{ type = 'underground-belt', name = 'basic-underground-belt',                                 tier = 0 }, -- bob logistics

	{ type = 'underground-belt', name = 'underground-belt',                                       tier = 1 }, -- vanilla
	{ type = 'underground-belt', name = 'fast-underground-belt',                                  tier = 2 }, -- vanilla
	{ type = 'underground-belt', name = 'express-underground-belt',                               tier = 3 }, -- vanilla

	{ type = 'underground-belt', name = 'turbo-underground-belt',                                 tier = 4 }, -- bob logistics
	{ type = 'underground-belt', name = 'ultimate-underground-belt',                              tier = 5 }, -- bob logistics

	{ type = 'underground-belt', name = 'ultra-fast-underground-belt',                            tier = 4 },
	{ type = 'underground-belt', name = 'extreme-fast-underground-belt',                          tier = 5 },
	{ type = 'underground-belt', name = 'ultra-express-underground-belt',                         tier = 6 },
	{ type = 'underground-belt', name = 'extreme-express-underground-belt',                       tier = 7 },
	{ type = 'underground-belt', name = 'original-ultimate-underground-belt',                     tier = 8 },

	{ type = 'underground-belt', name = 'uranium-underground-belt',                               tier = 4 }, -- uranium-belts-upd

	{ type = 'underground-belt', name = 'beltlayer-bpproxy-basic-underground-belt',               tier = 0 },

	{ type = 'underground-belt', name = 'beltlayer-bpproxy-underground-belt',                     tier = 1 },
	{ type = 'underground-belt', name = 'beltlayer-bpproxy-fast-underground-belt',                tier = 2 },
	{ type = 'underground-belt', name = 'beltlayer-bpproxy-express-underground-belt',             tier = 3 },

	{ type = 'underground-belt', name = 'beltlayer-bpproxy-turbo-underground-belt',               tier = 4 },
	{ type = 'underground-belt', name = 'beltlayer-bpproxy-ultimate-underground-belt',            tier = 5 },

	{ type = 'underground-belt', name = 'beltlayer-bpproxy-ultra-fast-underground-belt',          tier = 4 },
	{ type = 'underground-belt', name = 'beltlayer-bpproxy-extreme-fast-underground-belt',        tier = 5 },
	{ type = 'underground-belt', name = 'beltlayer-bpproxy-ultra-express-underground-belt',       tier = 6 },
	{ type = 'underground-belt', name = 'beltlayer-bpproxy-extreme-express-underground-belt',     tier = 7 },
	{ type = 'underground-belt', name = 'beltlayer-bpproxy-original-ultimate-underground-belt',   tier = 8 },

	{ type = 'underground-belt', name = 'rapid-transport-belt-to-ground-mk1',                     tier = 4 }, -- FactorioExtended Plus-Transport
	{ type = 'underground-belt', name = 'rapid-transport-belt-to-ground-mk2',                     tier = 5 },

	{ type = 'underground-belt', name = 'k-underground-belt',                                     tier = 4 }, -- Krastorio

	-- splitter
	{ type = 'splitter',         name = 'basic-splitter',                                         tier = 0 },

	{ type = 'splitter',         name = 'splitter',                                               tier = 1 },
	{ type = 'splitter',         name = 'fast-splitter',                                          tier = 2 },
	{ type = 'splitter',         name = 'express-splitter',                                       tier = 3 },

	{ type = 'splitter',         name = 'turbo-splitter',                                         tier = 4 },
	{ type = 'splitter',         name = 'ultimate-splitter',                                      tier = 5 },

	{ type = 'splitter',         name = 'ultra-fast-splitter',                                    tier = 4 },
	{ type = 'splitter',         name = 'extreme-fast-splitter',                                  tier = 5 },
	{ type = 'splitter',         name = 'ultra-express-splitter',                                 tier = 6 },
	{ type = 'splitter',         name = 'extreme-express-splitter',                               tier = 7 },
	{ type = 'splitter',         name = 'original-ultimate-splitter',                             tier = 8 },

	{ type = 'splitter',         name = 'uranium-splitter',                                       tier = 4 }, -- uranium-belts-upd

	{ type = 'splitter',         name = 'rapid-splitter-mk1',                                     tier = 4 }, -- FactorioExtended Plus-Transport
	{ type = 'splitter',         name = 'rapid-splitter-mk2',                                     tier = 5 },

	{ type = 'splitter',         name = 'k-splitter',                                             tier = 4 }, -- Krastorio

	-- loader
	{ type = 'loader',           name = 'basic-loader',                                           tier = 0 }, -- ask for it by bob's logistics mod

	{ type = 'loader',           name = 'loader',                                                 tier = 1 },
	{ type = 'loader',           name = 'fast-loader',                                            tier = 2 },
	{ type = 'loader',           name = 'express-loader',                                         tier = 3 },

	{ type = 'loader',           name = 'uranium-loader',                                         tier = 4 }, -- uranium-belts-upd (not ready)

	{ type = 'loader',           name = 'basic-underground-belt-beltlayer-connector',             tier = 0 },

	{ type = 'loader',           name = 'underground-belt-beltlayer-connector',                   tier = 1 },
	{ type = 'loader',           name = 'fast-underground-belt-beltlayer-connector',              tier = 2 },
	{ type = 'loader',           name = 'express-underground-belt-beltlayer-connector',           tier = 3 },

	{ type = 'loader',           name = 'turbo-underground-belt-beltlayer-connector',             tier = 4 },
	{ type = 'loader',           name = 'ultimate-underground-belt-beltlayer-connector',          tier = 5 },

	{ type = 'loader',           name = 'ultra-fast-underground-belt-beltlayer-connector',        tier = 4 },
	{ type = 'loader',           name = 'extreme-fast-underground-belt-beltlayer-connector',      tier = 5 },
	{ type = 'loader',           name = 'ultra-express-underground-belt-beltlayer-connector',     tier = 6 },
	{ type = 'loader',           name = 'extreme-express-underground-belt-beltlayer-connector',   tier = 7 },
	{ type = 'loader',           name = 'original-ultimate-underground-belt-beltlayer-connector', tier = 8 },

	{ type = 'loader',           name = 'chute-miniloader-loader',                                tier = 0 }, -- miniloader
	{ type = 'loader',           name = 'miniloader-loader',                                      tier = 1 },
	{ type = 'loader',           name = 'fast-miniloader-loader',                                 tier = 2 },
	{ type = 'loader',           name = 'express-miniloader-loader',                              tier = 3 },

	{ type = 'loader',           name = 'filter-miniloader-loader',                               tier = 1 },
	{ type = 'loader',           name = 'fast-filter-miniloader-loader',                          tier = 2 },
	{ type = 'loader',           name = 'express-filter-miniloader-loader',                       tier = 3 },

	{ type = 'loader',           name = 'space-miniloader-loader',                                tier = 3 }, -- miniloader and Space Exploration
	{ type = 'loader',           name = 'space-filter-miniloader-loader',                         tier = 3 },

	{ type = 'loader',           name = 'deep-space-miniloader-loader',                           tier = 4 },
	{ type = 'loader',           name = 'deep-space-filter-miniloader-loader',                    tier = 4 },

	{ type = 'loader',           name = 'rapid-mk1-miniloader-loader',                            tier = 4 }, -- FactorioExtended Plus-Transport and Miniloader
	{ type = 'loader',           name = 'rapid-mk1-filter-miniloader-loader',                     tier = 4 },
	{ type = 'loader',           name = 'rapid-mk2-miniloader-loader',                            tier = 5 },
	{ type = 'loader',           name = 'rapid-mk2-filter-miniloader-loader',                     tier = 5 },

	-- deadlocks:
	{ type = 'loader',           name = 'transport-belt-loader',                                  tier = 1 },
	{ type = 'loader',           name = 'fast-transport-belt-loader',                             tier = 2 },
	{ type = 'loader',           name = 'express-transport-belt-loader',                          tier = 3 },

	{ type = 'loader',           name = 'ultra-fast-belt-loader',                                 tier = 4 }, -- deadlocks + something:
	{ type = 'loader',           name = 'extreme-fast-belt-loader',                               tier = 5 },
	{ type = 'loader',           name = 'ultra-express-belt-loader',                              tier = 6 },
	{ type = 'loader',           name = 'extreme-express-belt-loader',                            tier = 7 },
	{ type = 'loader',           name = 'ultimate-belt-loader',                                   tier = 8 },

	{ type = 'loader',           name = 'loader-kr',                                              tier = 1 }, -- Krastorio
	{ type = 'loader',           name = 'loader-kr-02',                                           tier = 2 },
	{ type = 'loader',           name = 'loader-kr-03',                                           tier = 3 },
	{ type = 'loader',           name = 'loader-kr-04',                                           tier = 4 },


	{ type = 'loader-1x1',       name = 'loader-1x1',                                             tier = 1 },
	{ type = 'loader-1x1',       name = 'transport-belt-loader',                                  tier = 1 },
	{ type = 'loader-1x1',       name = 'fast-transport-belt-loader',                             tier = 2 },
	{ type = 'loader-1x1',       name = 'express-transport-belt-loader',                          tier = 3 },
	{ type = 'loader-1x1',       name = 'rapid-transport-belt-mk1-loader',                        tier = 4 },
	{ type = 'loader-1x1',       name = 'rapid-transport-belt-mk2-loader',                        tier = 5 },

	-- linked-belt
	{ type = 'linked-belt',      name = 'linked-belt',                                            tier = 1 }, -- vanilla
	{ type = 'linked-belt',      name = 'fast-linked-belt',                                       tier = 2 }, -- vanilla
	{ type = 'linked-belt',      name = 'express-linked-belt',                                    tier = 3 }, -- vanilla

	{ type = 'linked-belt',      name = 'beltlayer-connector',                                    tier = 1 }, -- Beltlayer
	{ type = 'linked-belt',      name = 'fast-beltlayer-connector',                               tier = 2 }, -- Beltlayer
	{ type = 'linked-belt',      name = 'express-beltlayer-connector',                            tier = 3 }, -- Beltlayer
}


local enabled_autoprototypes = settings.startup["ptdp-autoprototypes"].value

if enabled_autoprototypes then
	prototypes = autoprototypes
end


for i, p in pairs(prototypes) do
	local prototype = data.raw[p.type][p.name]
	if prototype then
		local tier = p.tier
		if tier > 13 then tier = 13 end -- 14 was too high
		local speed = 0.03125 * (2 ^ (tier - 1))
		-- log ('type: ' .. p.type .. ' entity: ' .. p.name .. ' tier: ' .. tier .. ' speed: ' .. speed)
		if tier >= 1 then -- 0.4.2
			prototype.speed = speed
		end
		if speed >= 0.5 then -- can't see animation
			prototype.animation_speed_coefficient = 0
		end
	end
end



if data.raw.furnace["express-transport-belt-beltbox"] and
	data.raw.furnace["express-transport-belt-beltbox"].crafting_speed and
	data.raw.furnace["express-transport-belt-beltbox"].crafting_speed == 3 then
	-- start
	data.raw.furnace["express-transport-belt-beltbox"].crafting_speed = 4
	data.raw.furnace["express-transport-belt-beltbox"].energy_usage = "360kW"
	log('DSB: replaced speed for ["express-transport-belt-beltbox"]')
end



-- miniloader
-- local extension_speed = 1
-- local rotation_speed = 0.12
-- local energy_per_movement = "2kJ"
-- local energy_per_rotation = "2kJ"
local miniloaders =
{
	["basic-miniloader-inserter"] = { tier = 0 },
	["chute-miniloader-inserter"] = { tier = 0 },

	["miniloader-inserter"] = { tier = 1 }, -- 15 items/s
	["filter-miniloader-inserter"] = { tier = 1 },

	["fast-miniloader-inserter"] = { tier = 2 }, -- 30 items/s
	["fast-filter-miniloader-inserter"] = { tier = 2 },

	["express-miniloader-inserter"] = { tier = 3 }, -- 60 items/s
	["express-filter-miniloader-inserter"] = { tier = 3 },

	-- Space Exploration + Miniloader
	["space-miniloader-inserter"] = { tier = 3 },
	["space-filter-miniloader-inserter"] = { tier = 3 },

	["deep-space-miniloader-inserter"] = { tier = 4 },
	["deep-space-filter-miniloader-inserter"] = { tier = 4 },

	-- bob + miniloader
	["turbo-miniloader-inserter"] = { tier = 4 }, -- 120
	["turbo-filter-miniloader-inserter"] = { tier = 4 },

	["ultimate-miniloader-inserter"] = { tier = 5 }, -- 240
	["ultimate-filter-miniloader-inserter"] = { tier = 5 },

	-- ultimate belts

	["ub-ultra-fast-miniloader-inserter"] = { tier = 6 }, -- green, was 90, must be 480
	["ub-ultra-fast-filter-miniloader-inserter"] = { tier = 6 },

	["ub-extreme-fast-miniloader-inserter"] = { tier = 7 }, -- red, was 135, must be 480
	["ub-extreme-fast-filter-miniloader-inserter"] = { tier = 7 },

	["ub-ultra-express-miniloader-inserter"] = { tier = 8 }, -- purple , was 180, must be 960
	["ub-ultra-express-filter-miniloader-inserter"] = { tier = 8 },

	["ub-extreme-express-miniloader-inserter"] = { tier = 9 }, -- dark blue, was 225, must be 2*960
	["ub-extreme-express-filter-miniloader-inserter"] = { tier = 9 },

	["ub-ultimate-miniloader-inserter"] = { tier = 10 }, -- light blue, was 270, must be 4*960
	["ub-ultimate-filter-miniloader-inserter"] = { tier = 10 },

}


for inserter_name, tabl in pairs(miniloaders) do
	local prototype = data.raw.inserter[inserter_name]
	if prototype then
		local tier = tabl.tier
		if prototype.localised_description then
			local belt_speed = 15 * (2 ^ (tier - 1))
			if prototype.localised_description[5] then -- I know that this solution is ugly, but it works and was done very fast
				---@diagnostic disable-next-line: assign-type-mismatch
				prototype.localised_description[5] = belt_speed
			end
		end
		local rotation_speed = 0.5 * 0.12 * 2 ^ tier -- 0, 0.06; 1, 0.12; 2, 0.24; 3, 0.48
		prototype.rotation_speed = rotation_speed
	end
end

local beltbox_furnaces =
{
	["transport-belt-beltbox"] = { tier = 1 },
	["fast-transport-belt-beltbox"] = { tier = 2 },
	["express-transport-belt-beltbox"] = { tier = 3 },
	["rapid-transport-belt-mk1-beltbox"] = { tier = 4 },
	["rapid-transport-belt-mk2-beltbox"] = { tier = 5 },

	["kr-advanced-transport-belt-beltbox"] = { tier = 4 },
	["kr-superior-transport-belt-beltbox"] = { tier = 5 },
}
for name, tabl in pairs(beltbox_furnaces) do
	local prototype = data.raw.furnace[name]
	if prototype then
		local crafting_speed = 2 ^ (tabl.tier - 1) -- 1, 2, 4, 8, 16
		prototype.crafting_speed = crafting_speed
		log('furnace ["' .. name .. '"] crafting_speed: ' .. crafting_speed)
	end
end

if data.raw["item-subgroup"]["bob-logistic-tier-1"] and false then -- bob
	local subgroups = {}
	for item_name, item in pairs(data.raw.item) do
		local subgroup_name = item.subgroup
		if subgroup_name then
			if not subgroups[subgroup_name] then subgroups[subgroup_name] = {} end
			table.insert(subgroups[subgroup_name], item_name)
		end
	end
	log('subgroups: ' .. serpent.block(subgroups))
end


--[[
  ["bob-logistic-tier-0"] = {
    "burner-inserter",
    "basic-transport-belt",
    "basic-underground-belt",
    "basic-splitter",
    "basic-miniloader",
    "basic-filter-miniloader"
  },
  ["bob-logistic-tier-1"] = {
    "transport-belt",
    "inserter",
    "splitter",
    "underground-belt",
    "yellow-filter-inserter",
    "miniloader",
    "filter-miniloader"
  },
  ["bob-logistic-tier-2"] = {
    "long-handed-inserter",
    "fast-transport-belt",
    "fast-underground-belt",
    "fast-splitter",
    "red-filter-inserter",
    "red-stack-inserter",
    "red-stack-filter-inserter",
    "fast-miniloader",
    "fast-filter-miniloader"
  },
  ["bob-logistic-tier-3"] = {
    "fast-inserter",
    "express-transport-belt",
    "filter-inserter",
    "stack-inserter",
    "stack-filter-inserter",
    "express-underground-belt",
    "express-splitter",
    "express-miniloader",
    "express-filter-miniloader"
  },
  ["bob-logistic-tier-4"] = {
    "turbo-transport-belt",
    "turbo-underground-belt",
    "turbo-splitter",
    "turbo-inserter",
    "turbo-filter-inserter",
    "turbo-stack-inserter",
    "turbo-stack-filter-inserter",
    "turbo-miniloader",
    "turbo-filter-miniloader"
  },
  ["bob-logistic-tier-5"] = {
    "ultimate-transport-belt",
    "ultimate-underground-belt",
    "ultimate-splitter",
    "express-inserter",
    "express-filter-inserter",
    "express-stack-inserter",
    "express-stack-filter-inserter",
    "ultimate-miniloader",
    "ultimate-filter-miniloader"
  },
]]




-- version 1.1.5; just quickfix, sorry for it
if data.raw.furnace["kr-advanced-transport-belt-beltbox"] then
	--	data.raw.furnace["kr-advanced-transport-belt-beltbox"].crafting_speed = 8 -- 4
	data.raw.furnace["kr-advanced-transport-belt-beltbox"].energy_usage = "560kW" -- "360kW"
end


if data.raw.furnace["kr-superior-transport-belt-beltbox"] then
	--	data.raw.furnace["kr-superior-transport-belt-beltbox"].crafting_speed = 16 -- 6
	data.raw.furnace["kr-superior-transport-belt-beltbox"].energy_usage = "840kW" -- "540kW"
end
