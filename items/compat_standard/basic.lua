Blockbuster.ValueManipulation.CompatStandard{
    key = "basic",
    prefix_config = {key = { mod = false, atlas = false}},
    variable_conventions = {
        full_vars = {
            "stacks",
            "stacked",
            "odds",
            "denominator",
            "reset",
            "threshold",
        },
        ends_on = {
            "_non",
            "_stacks"
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
