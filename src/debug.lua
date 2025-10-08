local counters = nil
local timesused = 0
function GetCounters()
    if counters then
        return counters
    end

    counters = {"None"}
    for i, v in pairs(G.P_COUNTERS) do
        counters[v.order + 1] = i
    end

    return counters
end

Blockbuster.Debug = {}
function Blockbuster.Debug.hasExtra()
    print("Function Called:")
    local _index = 0
    for _key, _object in pairs(G.P_CENTERS) do
        _index = _index + 1
        -- print(_index .. ": " .. _key)
        if _object.set == "Joker" then
            if _object.config then
                if _object.config.extra then
                    
                else
                    print(_key)
                end
            end
        end
    end
end

function Blockbuster.Debug.valManipMult()
    print("Function Called:")
    local _index = 0
    for _index, _object in ipairs(G.jokers.cards) do
        if _object.ability and _object.ability.blockbuster_multipliers then
            for _source, _mult in pairs(_object.ability.blockbuster_multipliers) do
                print(_source .. ": x" .. _mult)
            end
        end
    end
end

SMODS.Keybind({
    key_pressed = "k",
    held_keys = { "space" },
    action = function(self)
        if G and G.CONTROLLER and G.CONTROLLER.hovering.target and G.CONTROLLER.hovering.target:is(Card) then
            local _card = G.CONTROLLER.hovering.target
            for _index, _joker in ipairs(G.jokers.cards) do
                if _joker.config.center and _joker.config.center.original_mod then
                end
                -- print(_joker.mod.id)
                local _value = 10
                Card:bb_set_multiplication_bonus(_joker, "debug", _value)
                card_eval_status_text(_joker, 'extra', nil, nil, nil,
                { message = "x" .. _value .. " VALUE (DEBUG)", colour = G.C.BLACK })
            end

        end

    end
})

SMODS.Keybind({
    key_pressed = "k",
    held_keys = { "ralt" },
    event = 'pressed',
    action = function(self)
        if G and G.CONTROLLER and G.CONTROLLER.hovering.target and G.CONTROLLER.hovering.target:is(Card) then
            local _card = G.CONTROLLER.hovering.target
            for _index, _joker in ipairs(G.jokers.cards) do
                if _joker.config.center and _joker.config.center.original_mod then
                    print(_joker.config.center.original_mod.id)
                end
                Card:bb_set_multiplication_bonus(_joker, "debug", 1)
                card_eval_status_text(_joker, 'extra', nil, nil, nil,
                { message = "RESET VALUE (DEBUG)", colour = G.C.BLACK })
            end
        end
    end
})

