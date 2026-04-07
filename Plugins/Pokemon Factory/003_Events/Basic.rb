module ZBox
  # Puedes poner el nombre que sea siempre que incie con "self." y el nombre sea separado con "_" si es necesario.
  # Para llamarlos mediante un evento, se usa ZBox.(nombre sin el self.). Revisar los de ejemplo.
  # You can use any name as long as it starts with "self." and the name is separated with "_" if necessary.
  # To call them via an event, use ZBox.(name without the self.). Review the examples.

  #==============================================================================
  # Ejemplo básico.
  # Basic example.
  #==============================================================================

  # Se puede llamar mediante un evento con: ZBox.give_eevee
  # Can be called from an event with: ZBox.give_eevee
  def self.give_eevee
    eevee_data = {
      species: :EEVEE,
      level: 10,
      nickname: "Hope",
      shiny: true,
      nature: :TIMID,
      item: :SOOTHEBELL,
      poke_ball: :PREMIERBALL,
      ivs: { hp: 31, attack: 31, defense: 31, spatk: 31, spdef: 31, speed: 31 },
      moves: [:SWIFT, :CHARM, :BITE]
    }

    pkmn = PokemonFactory.create(eevee_data)
    pbAddPokemonWithNickname(pkmn)
  end
end