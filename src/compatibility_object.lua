Blockbuster.ValueManipulation.CompatStandards = {}
Blockbuster.ValueManipulation.ModToCompatStandard = {}

Blockbuster.ValueManipulation.CompatStandard = SMODS.GameObject:extend {
    obj_table = Blockbuster.ValueManipulation.CompatStandards,
    obj_buffer = {},
    required_params = {
        'key'
    },
    set = 'CompatStandards',
    process_loc_text = function(self)
        SMODS.process_loc_text(G.localization.misc.quips, self.key:lower(), self.loc_txt)
    end,
    variable_conventions = {
        full_vars = {},
        ends_on = {},
        starts_with = {},
    },
    exempt_jokers = nil,
    source_mod = nil,
    register = function(self)
        if self.registered then
            sendWarnMessage(('Detected duplicate register call on Blockbuster.ValueManipulation.CompatStandard %s'):format(self.key:lower()), self.set)
            return
        end
        if self:check_dependencies() then
            self.obj_buffer[#self.obj_buffer + 1] = self.key:lower()
            self.obj_table[self.key:lower()] = self
            self.registered = true
        end
    end,
    inject = function(self)
        self.extra = self.extra or {center = 'j_joker'}
        if self.source_mod then
            Blockbuster.RegisterCompatStandardWithMod(self.key:lower(), self.source_mod)
        end
        
    end
}

function Blockbuster.RegisterCompatStandardWithMod(key_to_standard, mod_id)
    Blockbuster.ValueManipulation.ModToCompatStandard[mod_id] = key_to_standard
end