#=======================================================================================================
# Puedes hacer tus eventos dentro de este módulo.
#
# You can create your events within this module.
#=======================================================================================================

module ZBox
  # Example events for the Data Core Gacha
  PokemonFactory.register(:pikachu_boss, {
    :species    => :PIKACHU,
    :level      => 5,
    :shiny      => true,
    :hue_change => 60,
    :first_moves=> [:THUNDERSHOCK, :GROWL, :QUICKATTACK],
    :ivs        => :PERFECT,
    :evs        => :SWEEPER_PHYSICAL,
    :nickname   => "Volt Core",
    :item       => :LIGHTBALL
  })

  PokemonFactory.register(:dragonite_boss, {
    :species    => :DRATINI,
    :level      => 5,
    :shiny      => true,
    :hue_change => 180,
    :first_moves=> [:WRAP, :LEER, :EXTREMESPEED],
    :ivs        => :PERFECT,
    :evs        => :TANK_PHYSICAL,
    :nickname   => "Aqua Core"
  })

  PokemonFactory.register(:bulbasaur_boss, {
    :species    => :BULBASAUR,
    :level      => 5,
    :shiny      => true,
    :hue_change => 45,
    :first_moves=> [:TACKLE, :GROWL, :LEECHSEED],
    :ivs        => :PERFECT,
    :evs        => :TANK_SPECIAL,
    :nickname   => "Verdant Core"
  })


PokemonFactory.register(:wartortle_gacha, {
  :species      => :WARTORTLE,
  :level        => 60,
  :nickname     => "Sparky",
  :item         => :ULTRABALL,
  :poke_ball    => :PREMIERBALL,
  :types        => [:ELECTRIC, :BUG],
  :hue_change   => 182,
  :nature       => :TIMID,
  :ivs          => :PERFECT,
  :first_moves  => [:SUBSTITUTE, :ICEBEAM, :AURASPHERE, :HYDROPUMP]
})

  pignite_data = {
    species: :PIGNITE,
    level: 19,
    nickname: "Pebbles",
    item: :TM39,
    poke_ball: :GREATBALL,
    types: [:WATER, :FIGHTING],
    hue_change: 189,
    nature: :LAX,
    ivs: :perfect,
    moves: [:WATERSHURIKEN, :DIZZYPUNCH]
  }

  PokemonFactory.register(:psyduck_data, {
    species: :PSYDUCK,
    level: 74,
    nickname: "Sparky",
    poke_ball: :GREATBALL,
    types: [:ICE],
    hue_change: 116,
    nature: :DOCILE,
    ivs: :random,
    moves: [:ICEBEAM, :MIST]
  })

  PokemonFactory.register(:boss_castform_data, {
    species: :CASTFORM,
    level: 22,
    nickname: "Aether",
    hp_boost: 4,
    item: :LIFEORB,
    poke_ball: :CHERISHBALL,
    shiny: true,
    egg_type: :EPIC,
    types: [:NORMAL, :FAIRY],
    hue_change: 280,
    ability: :PIXILATE,
    nature: :TIMID,
    ivs: :perfect,
    moves: [:BOOMBURST, :MOONBLAST, :FLAMETHROWER, :QUIVERDANCE]
  })

end
