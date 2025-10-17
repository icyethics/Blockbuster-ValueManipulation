local igo = Game.init_game_object
Game.init_game_object = function(self)
    if Cryptid or Talisman then
        Blockbuster.cryptid_crossmod()
    end
    local ret = igo(self)
    return ret
end