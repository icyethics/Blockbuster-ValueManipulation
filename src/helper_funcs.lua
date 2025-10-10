function Blockbuster.get_mod_id_from_card(card)

    if card then
        if card.config.center and card.config.center.original_mod then
            return card.config.center.original_mod.id
        end

        if card.config.center and not card.config.center.original_mod then
            return "Vanilla"
        end
    else
        return nil
    end
    
end

function Blockbuster.get_standard_from_card(card)
    if not card then
        print("DEBUG: No card object")
        return nil
    end

    if card.config.center.bb_alternate_standard then
        return card.config.center.bb_alternate_standard
    end

    local _mod_id = Blockbuster.get_mod_id_from_card(card)

    if _mod_id then
        return Blockbuster.ValueManipulation.ModToCompatStandard[_mod_id]
    else
        return nil
    end

end

function Blockbuster.value_manipulation_compat(card, standard)
    if not standard then 
        return nil
    end

    if type(standard) == "string" then
        standard = Blockbuster.ValueManipulation.CompatStandards[standard]
    end

    if standard.exempt_jokers and standard.exempt_jokers[card.config.center.key] then
        return false
    else
        return true
    end
end

function Blockbuster.get_keys_of_value_manip_sources(card, partial_key_match)
    local _table = {}

    if card and card.ability and card.ability.multiplier then
        for _key, _garb in pairs(card.ability.multiplier) do
            if partial_key_match then
                if string.find(_key, partial_key_match) then
                    _table[#_table + 1] = _key
                end
            else
                _table[#_table + 1] = _key
            end
        end
    end

    return _table
end

function Blockbuster.is_value_manip_compatible(card)
    if not card or not card.config or not card.config.center then
        return false
    end

    if Cryptid then
        return true
    end

    local _standard = card.config.center.bb_personal_standard or Blockbuster.get_standard_from_card(card)
    if _standard  then
        if Blockbuster.value_manipulation_compat(card, _standard) then
            return true
        end
    end

    return false
end