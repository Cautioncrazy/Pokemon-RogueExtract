#===================================================================================
# Añade una ligera variación de HUE y STATS a los Pokémon de entrenadores.
# Adds a slight variation of HUE and STATS to trainer Pokémon.
#===================================================================================
module GameData
  class Trainer
    alias_method :zbox_to_trainer, :to_trainer

    def to_trainer
      trainer = zbox_to_trainer

      trainer.party.each do |pkmn|
        if Settings::VARIATION_COLOR_TRAINERPOKEMON && Settings::VARIATION_COLOR_TRAINER > 0
          if !pkmn.super_shiny? && (!pkmn.respond_to?(:zbox_hue_value) || !pkmn.zbox_hue_value)
            range = (Settings::VARIATION_COLOR_TRAINER * 2) + 1
            random_hue = rand(range) - Settings::VARIATION_COLOR_TRAINER
            pkmn.zbox_hue_value = random_hue
          end
        end

        if Settings::VARIATION_STATS_TRAINERPOKEMON && Settings::VARIATION_STATS_TRAINER > 0
          if !pkmn.respond_to?(:zbox_stat_additions) || !pkmn.zbox_stat_additions
            stat_additions = {}
            range = (Settings::VARIATION_STATS_TRAINER * 2) + 1

            GameData::Stat.each_main do |s|
              random_mod = rand(range) - Settings::VARIATION_STATS_TRAINER
              stat_additions[s.id] = random_mod
            end

            pkmn.zbox_stat_additions = stat_additions
            pkmn.calc_stats
          end
        end
      end

      return trainer
    end
  end
end