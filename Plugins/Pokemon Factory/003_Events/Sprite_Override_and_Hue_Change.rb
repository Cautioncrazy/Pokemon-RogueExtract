module ZBox
    #==============================================================================
    # Ejemplo de sprite_override: y hue_change: 
    # Example of sprite_override: and hue_change:
    #==============================================================================

    # Se puede llamar mediante un evento con: ZBox.give_eevee_override
    # Can be called from an event with: ZBox.give_eevee_override
    def self.give_eevee_override 
      eevee_impostor = {
        species: :EEVEE,
        level: 10,
        nickname: "Impostor",
        shiny: true,
        nature: :TIMID,
        poke_ball: :PREMIERBALL,
        ivs: { hp: 31, attack: 31, defense: 31, spatk: 31, spdef: 31, speed: 31 },
        moves: [:SWIFT, :CHARM, :BITE],
        
        # El valor para cambiar el tono puede ser cualquier número entre -360 y 360. 
        # The value to shift the tone can be any number between -360 and 360.
        hue_change: 340, 
        
        # Se encarga de buscar los sprites con este nombre.
        # It is responsible for searching for sprites with this name.
        sprite_override: "PIKACHU" 
      }

      pkmn = PokemonFactory.create(eevee_impostor)
      pbAddPokemonWithNickname(pkmn)
    end
end   



