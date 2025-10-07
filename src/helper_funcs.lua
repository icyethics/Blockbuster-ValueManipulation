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