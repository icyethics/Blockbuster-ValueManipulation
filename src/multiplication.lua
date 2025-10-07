function Card:bb_set_multiplication_bonus(card, source, num, is_actor, reset_from_value_for_cryptid)

    -- CRYPTID COMPATIBILITY
    -- if not card or not card.config or not card.config.center or not kino_config.actor_synergy or not card.config.center.kino_joker then
    --     if Cryptid and card and card.config and card.config.center then
    --         if not Card.no(card, "immutable", true) then
    --             local _val = num
    --             if reset_from_value_for_cryptid then
    --                 _val = 1 / reset_from_value_for_cryptid
    --             end
    --             Cryptid.with_deck_effects(card, function(cards)
    --                 Cryptid.misprintize(
    --                     cards,
    --                     { min = _val, max = _val},
    --                     nil,
    --                     true
    --                 )
    --             end)
    --             return true
    --         end
    --     end
    --     return false
    -- end

    -- Gather the right value manipulation method
    local _standard = Blockbuster.get_standard_from_card(card)
    

    if _standard and not Blockbuster.value_manipulation_compat(card, _standard) then
        return false
    end

    -- If No method was chosen, but a generic one exists, use generic one
    if _standard == nil and Cryptid then
        Blockbuster.Cryptid_bb_set_multiplication_bonus(card, source, num, is_actor, reset_from_value_for_cryptid)
        return true
    end

    local _standardObj = Blockbuster.ValueManipulation.CompatStandards[_standard]

    if not card.ability.multipliers then
        card.ability.base = {}
        card.ability.multipliers = {}
        if type(card.ability.extra) ~= "table" then
            card.ability.base = card.ability.extra

        else
            for key, val in pairs(card.ability.extra) do
                if type(val) == 'number' then
                    card.ability.base[key] = val
                end
            end
        end
    end

    local _multipliers = card.ability.multipliers
    local _source = source
    local _num = num

    -- Add the source, or replace it if already existing
    if _source and _num then
        if card.ability.multipliers[_source] == _num then
            return false
        elseif card.ability.multipliers[_source] ~= nil and _num == 1 then
            for index, item in ipairs(card.ability.multipliers) do
                if card.ability.multipliers[_source] == item then
                    table.remove(card.ability.multipliers, index)
                end    
            end
        end 

        _multipliers[_source] = _num        
    end

    local _cardextra = card and card.ability.extra
    local _baseextra = card.ability.base

    -- Override is the personal standard that's on the joker object itself
    local _override = nil
    if card.config.center.bb_personal_standard then
        _override = card.config.center.bb_personal_standard
    end
    
    if type(_cardextra) ~= 'table' then
        if Blockbuster.check_variable_validity_for_mult("extra", _standard, _override) and type(_cardextra) == "number" then

            _cardextra = _baseextra

            for source, mult in pairs(_multipliers) do
                _cardextra = _cardextra * mult
                card.ability.extra = _cardextra
            end
        end
    else
        for name, value in pairs(_cardextra) do

            -- check the values

            if Blockbuster.check_variable_validity_for_mult(name, _standard, _override) and type(_cardextra[name]) == "number" then
                _cardextra[name] = _baseextra[name]
                for source, mult in pairs(_multipliers) do
                    _cardextra[name] = _cardextra[name] * mult
                end

                if Blockbuster.check_variable_validity_for_int_only(name, _standard, _override) then
                    _cardextra[name] = math.floor(_cardextra[name] + 0.5)
                end

                if _standardObj and _standardObj.variable_caps and _standardObj.variable_caps[name] or
                _override and _override.variable_caps and _override.variable_caps[name] then
                    local _usedStandard = _override or _standardObj
                    _cardextra[name] = math.min(_cardextra[name], _usedStandard.variable_caps[name])                    
                end

                if _standardObj and _standardObj.min_max_values or
                (_override and _override.min_max_values) then
                    local _usedStandard = _override or _standardObj 
                    local _min = _usedStandard.min_max_values.min
                    local _max = _usedStandard.min_max_values.max
                    _cardextra[name] = math.min(math.max(_cardextra[name], (_baseextra[name] * _min)), _baseextra[name] * _max)
                end
            end
        end
    end

    if Blockbuster.ValueManipulation.vanilla_exemption_joker_list[card.config.center.key] then
        Blockbuster.value_manipulation_vanilla_card(card, source, num, is_actor, reset_from_value_for_cryptid)
    end

    return true
end

function Card:get_multiplier_by_source(card, source)
    if not card or not card.ability or 
    not card.ability.multipliers or 
    not card.ability.multipliers[source] then
        return false
    end

    return card.ability.multipliers[source]
end

function Card:get_total_multiplier(card)
    if not card or not card.ability or 
    not card.ability.multipliers then
        return false
    end

    local _total = 0

    for _source, _mult in pairs(card.ability.multipliers) do
        _total = _total + _mult
    end
    return _total
end

