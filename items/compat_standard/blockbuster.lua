Blockbuster.ValueManipulation.CompatStandard{
    key = "blockbuster",
    prefix_config = {key = { mod = false, atlas = false}},
    source_mod = "Blockbuster-ValueManipulation",
    variable_conventions = {
        full_vars = {
            "stacks",
            "goal",
            "chance",
            "chance_cur",
            "reset",
            "threshold",
            "time_spent",
            "codex_length"
        },
        ends_on = {
            "_non"
        },
        starts_with = {
            "base_",
            "time_",
            "stacked_",
            "rank_"
        }
    },
    integer_only_variable_conventions = {
        full_vars = {
            "cards_created",
            "max_highlighted",
            "retriggers",
            "repetitions"
        },
        ends_on = {
        },
        starts_with = {
        },
    },

    variable_caps = {
        retriggers = 25,
        repetitions = 25,
        cards_created = 25,
        max_highlighted = 25
    },
}
