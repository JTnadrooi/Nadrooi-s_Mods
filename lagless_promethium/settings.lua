-- remove from recipes.
-- promethium from asteroid chunks. (reprocessing)
-- remove science pack.
-- stack size.
-- increase science per chunk.
-- enable recipe xyz.

data:extend({
    {
        type = "bool-setting",
        name = "lp-remove-from-recipes",
        setting_type = "startup",
        default_value = true,
        order = "ca",
    },
    {
        type = "bool-setting",
        name = "lp-remove-from-science",
        setting_type = "startup",
        default_value = true,
        order = "cb",
    },
    {
        type = "bool-setting",
        name = "lp-remove-from-technologies",
        setting_type = "startup",
        default_value = false,
        order = "cc",
    },
    -- {
    --     type = "bool-setting",
    --     name = "lp-promethium-from-asteroid-chunks",
    --     setting_type = "startup",
    --     default_value = false,
    --     order = "da",
    -- },
    -- {
    --     type = "bool-setting",
    --     name = "lp-promethium-from-aquilo-ocean",
    --     setting_type = "startup",
    --     default_value = false,
    --     order = "db",
    -- },
    -- {
    --     type = "bool-setting",
    --     name = "lp-promethium-from-biter-eggs",
    --     setting_type = "startup",
    --     default_value = false,
    --     order = "dc",
    -- },
    {
        type = "double-setting",
        name = "lp-promethium-science-chunk-cost",
        setting_type = "startup",
        default_value = 25,
        minimum_value = 1,
        maximum_value = 1000,
        order = "ea",
    },
    {
        type = "int-setting",
        name = "lp-promethium-asteroid-chunk-stack-size",
        setting_type = "startup",
        default_value = 1,
        minimum_value = 1,
        maximum_value = 5000,
        order = "fa",
    },
})
