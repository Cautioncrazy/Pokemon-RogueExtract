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
end