#==============================================================================
# ** Parche para Voltseon's Overworld Encounters **
# ** Patch for Voltseon's Overworld Encounters **
#==============================================================================
if PluginManager.installed?("Voltseon's Overworld Encounters")

  def pbChangeEventSprite(event, pkmn, water = false)
    shiny = pkmn.shiny?
    
    fname = pbOWSpriteFilename(pkmn.species, pkmn.form, pkmn.gender, shiny, pkmn.shadow, water)
    fname = pbOWSpriteFilename(pkmn.species, 0, pkmn.gender, shiny, pkmn.shadow, water) if pkmn.species == :MINIOR
    raise "Following Pokémon sprites were not found." if nil_or_empty?(fname)
    
    fname.gsub!("Graphics/Characters/", "")
    event.character_name = fname


    hue = 0
    if pkmn.respond_to?(:zbox_hue_value) && pkmn.zbox_hue_value
      hue = pkmn.zbox_hue_value
    elsif pkmn.super_shiny?
      hue = pkmn.zbox_get_super_shiny_hue
    end

    event.character_hue = hue
  end

  def pbGenerateOverworldEncounters(water = false)
    return if $scene.is_a?(Scene_Intro) || $scene.is_a?(Scene_DebugIntro)
    return if !$PokemonEncounters
    return if $player.able_pokemon_count == 0

    if VOESettings.current_encounters < VOESettings.get_max
      tile = get_grass_tile
      tile_id = $game_map.map_id < 2 ? :Grass : pbGetTileID($game_map.map_id, tile[0], tile[1])
      water = VOESettings::WATER_TILES.include?(tile_id)

      return if tile == []

      if water
        enc_type = $PokemonEncounters.find_valid_encounter_type_for_time(:Water, pbGetTimeNow)
      else
        enc_type = $PokemonEncounters.find_valid_encounter_type_for_time(:Land, pbGetTimeNow)
        if enc_type.nil?
          enc_type = $PokemonEncounters.has_cave_encounters? ? $PokemonEncounters.find_valid_encounter_type_for_time(:Cave, pbGetTimeNow) : $PokemonEncounters.encounter_type
        end
      end

      return if enc_type.nil?

      if VOESettings::DIFFERENT_ENCOUNTERS
        pkmn_data = pbChooseWildPokemonByVersion($game_map.map_id, enc_type, VOESettings::ENCOUNTER_TABLE)
      else
        pkmn_data = $PokemonEncounters.choose_wild_pokemon_for_map($game_map.map_id, enc_type)
      end

      pkmn = Pokemon.new(pkmn_data[0], pkmn_data[1])

      if [:SCATTERBUG, :SPEWPA, :VIVILLON].include?(pkmn.species)
        region = pbGetCurrentRegion
        v_form = (region == 0) ? 3 : 0
        pkmn.form = v_form
      end

      pkmn.level = (pkmn.level + rand(-2..2)).clamp(2, GameData::GrowthRate.max_level)
      pkmn.calc_stats
      pkmn.reset_moves
      
      # =================================================================================
      # FACTORY PATHS
      # =================================================================================
      if rand(VOESettings::SHINY_RATE) == 0
        pkmn.shiny = true
        if defined?(Settings::SUPER_SHINY) && Settings::SUPER_SHINY
           if rand(16) == 0
             pkmn.shiny = false
             pkmn.super_shiny = true
             pkmn.zbox_get_super_shiny_hue
           end
        end
      end

      if defined?(Settings::VARIATION_COLOR_WILDPOKEMON) && Settings::VARIATION_COLOR_WILDPOKEMON && Settings::VARIATION_COLOR > 0
        if !pkmn.super_shiny? && (!pkmn.respond_to?(:zbox_hue_value) || !pkmn.zbox_hue_value)
          range = (Settings::VARIATION_COLOR * 2) + 1
          random_hue = rand(range) - Settings::VARIATION_COLOR
          pkmn.zbox_hue_value = random_hue
        end
      end

      if defined?(Settings::VARIATION_STATS_WILDPOKEMON) && Settings::VARIATION_STATS_WILDPOKEMON && Settings::VARIATION_STATS > 0
        stat_additions = {}
        range = (Settings::VARIATION_STATS * 2) + 1
        GameData::Stat.each_main do |s|
          random_mod = rand(range) - Settings::VARIATION_STATS
          stat_additions[s.id] = random_mod
        end
        pkmn.zbox_stat_additions = stat_additions
        pkmn.calc_stats
      end
      # =================================================================================
      # 
      # =================================================================================
      
      r_event = Rf.create_event do |e|
        e.name = water ? "OverworldPkmn_Swim" : "OverworldPkmn"
        e.name = e.name + " Reflection" if VOESettings::REFLECTION_MAP_IDS.include?($game_map.map_id)
        e.name = e.name + " (Shiny)" if pkmn.shiny?

        e.x = tile[0]
        e.y = tile[1]

        e.pages[0].step_anime = true
        e.pages[0].trigger = 0
        e.pages[0].list.clear
        e.pages[0].move_speed = 2
        e.pages[0].move_frequency = 2

        move_data = VOEMovement::Poke_Move[pkmn.species] || VOEMovement::Poke_Move[pkmn.species.to_sym]
        move_data = VOEMovement::Nature_Move[pkmn.nature.id] unless move_data

        if move_data
          route = RPG::MoveRoute.new
          route.repeat = true
          route.skippable = true
          route.list = pbConvertMoveCommands(move_data[:move_route])

          e.pages[0].move_speed = move_data[:move_speed] if move_data.has_key?(:move_speed)
          e.pages[0].move_frequency = move_data[:move_frequency] if move_data.has_key?(:move_frequency)
          e.pages[0].move_type = 3
          e.pages[0].move_route = route
          e.pages[0].trigger = 2 if move_data.has_key?(:touch) && move_data[:touch] == true
        end

        Compiler.push_script(e.pages[0].list, "pbInteractOverworldEncounter")
        Compiler.push_end(e.pages[0].list)
      end

      event = r_event[:event]
      event.setVariable([pkmn, r_event])

      spriteset = $scene.spriteset($game_map.map_id)
      dist = (((event.x - $game_player.x).abs + (event.y - $game_player.y).abs) / 4).floor
      
      if pkmn.shiny?
        pbSEPlay(VOESettings::SHINY_SOUND, [75, 65, 55, 40, 27, 22, 15][dist], 100) if dist <= 6 && dist >= 0
        spriteset&.addUserAnimation(VOESettings::SHINY_ANIMATION, event.x, event.y, true, 1)
      end
      
      pbChangeEventSprite(event, pkmn, water)
      
      event.direction = rand(1..4) * 2
      event.through = false
      spriteset&.addUserAnimation(VOESettings::SPAWN_ANIMATION, event.x, event.y, true, 1)
      GameData::Species.play_cry_from_pokemon(pkmn, [75, 65, 55, 40, 27, 22, 15][dist]) if dist <= 6 && dist >= 0 && rand(20) == 1 unless dist.nil?
      VOESettings.current_encounters += 1
    end
  end
end