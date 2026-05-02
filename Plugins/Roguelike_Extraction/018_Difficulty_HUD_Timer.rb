#===============================================================================
# Risk of Rain Style Difficulty Timer & HUD
#===============================================================================
# Manages the active run timer and displays the difficulty tier overlay.
# The timer pauses in menus, battles, messages, and the Hub.
#===============================================================================

module RoguelikeDifficultyHUD
  # Configuration Constants
  DIFFICULTY_TIER_VAR         = 90
  TIMER_SECONDS_VAR           = 91
  ROGUELIKE_RUN_ACTIVE_SWITCH = 90
  SECONDS_PER_TIER            = 180
  HUB_MAP_ID                  = 77

  # UI Positioning & Assets
  HUD_X = Graphics.width - 200 # Adjust based on actual asset width later if needed
  HUD_Y = 10
  BG_IMAGE  = "Graphics/Plugins/Rogue Extract/Timer_UI"
  BAR_IMAGE = "Graphics/Plugins/Rogue Extract/Timer_Bar"

  TIER_NAMES = [
    "Safe",
    "Routine",
    "Alert",
    "Risky",
    "Perilous",
    "Extreme",
    "Nightmare",
    "Terminal"
  ]

  # State variables
  @frame_counter = 0

  # When the master switch is toggled ON, reset the timer and tier
  EventHandlers.add(:on_game_switch_change, :roguelike_timer_reset,
    proc { |switch_id, value|
      if switch_id == ROGUELIKE_RUN_ACTIVE_SWITCH && value == true
        $game_variables[TIMER_SECONDS_VAR] = 0
        $game_variables[DIFFICULTY_TIER_VAR] = 1
        @frame_counter = 0 # reset internal frame tracker
      end
    }
  )

  # Update HUD Visuals
  def self.update_hud
    return if !@hud_bg || @hud_bg.disposed? || !@hud_bar || @hud_bar.disposed? || !@hud_text || @hud_text.disposed?

    # Check Visibility (Pause Conditions)
    is_visible = true
    is_visible = false if !$game_switches || !$game_switches[ROGUELIKE_RUN_ACTIVE_SWITCH]
    is_visible = false if !$game_map || $game_map.map_id == HUB_MAP_ID
    is_visible = false if $game_temp && $game_temp.in_battle
    is_visible = false if $game_temp && $game_temp.message_window_showing
    is_visible = false if !$scene.is_a?(Scene_Map)
    is_visible = false if $game_player && $game_player.move_route_forcing
    is_visible = false if defined?(pbMapInterpreter) && pbMapInterpreter && pbMapInterpreter.running?

    @hud_bg.visible = is_visible
    @hud_bar.visible = is_visible
    @hud_text.visible = is_visible

    return if !is_visible

    # Get Variables
    seconds = $game_variables[TIMER_SECONDS_VAR] || 0
    tier = $game_variables[DIFFICULTY_TIER_VAR] || 1
    tier = 1 if tier < 1
    tier = 8 if tier > 8

    # Format Time (MM:SS)
    mm = seconds / 60
    ss = seconds % 60
    time_str = sprintf("%02d:%02d", mm, ss)

    # Format Tier
    tier_name = TIER_NAMES[tier - 1] || "Unknown"
    text_str = "Time: #{time_str} | Tier: #{tier} (#{tier_name})"

    # Check if text needs to be redrawn (to save performance)
    @last_drawn_text ||= ""
    if @last_drawn_text != text_str
      @hud_text.bitmap.clear
      text_pos = [
        [text_str, @hud_text.bitmap.width / 2, 4, 2, Color.new(255, 255, 255), Color.new(0, 0, 0)]
      ]
      pbDrawTextPositions(@hud_text.bitmap, text_pos)
      @last_drawn_text = text_str
    end

    # Animate Progress Bar
    if tier == 8
      # Terminal: Bar stays 100% full
      @hud_bar.src_rect.width = @hud_bar.bitmap.width
    else
      progress_seconds = seconds % SECONDS_PER_TIER
      fill_percentage = progress_seconds.to_f / SECONDS_PER_TIER.to_f
      @hud_bar.src_rect.width = (@hud_bar.bitmap.width * fill_percentage).to_i
    end
  end

  # Timer Update Loop
  EventHandlers.add(:on_frame_update, :roguelike_difficulty_timer,
    proc {
      # Always update the HUD visibility and display
      update_hud

      # Pause conditions for ticking the clock
      next if !$game_switches || !$game_switches[ROGUELIKE_RUN_ACTIVE_SWITCH]
      next if !$game_map || $game_map.map_id == HUB_MAP_ID
      next if $game_temp && $game_temp.in_battle
      next if $game_temp && $game_temp.message_window_showing
      next if !$scene.is_a?(Scene_Map)
      next if $game_player && $game_player.move_route_forcing
      # In Essentials, to check if an event is running, we usually check pbMapInterpreter.running?
      next if defined?(pbMapInterpreter) && pbMapInterpreter && pbMapInterpreter.running?

      # Ensure variables exist
      $game_variables[TIMER_SECONDS_VAR] ||= 0
      $game_variables[DIFFICULTY_TIER_VAR] ||= 1

      @frame_counter ||= 0
      @frame_counter += 1

      if @frame_counter >= Graphics.frame_rate
        @frame_counter = 0
        $game_variables[TIMER_SECONDS_VAR] += 1

        # Check for tier increase (Cap at 8)
        current_tier = $game_variables[DIFFICULTY_TIER_VAR]
        if current_tier < 8 && ($game_variables[TIMER_SECONDS_VAR] % SECONDS_PER_TIER == 0)
          $game_variables[DIFFICULTY_TIER_VAR] += 1
        end
      end
    }
  )

  # --- HUD Sprite Management ---
  @hud_bg = nil
  @hud_bar = nil
  @hud_text = nil
  @hud_viewport = nil

  def self.create_hud
    dispose_hud
    @hud_viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @hud_viewport.z = 99999

    @hud_bg = Sprite.new(@hud_viewport)
    @hud_bg.bitmap = Bitmap.new(BG_IMAGE)
    @hud_bg.x = HUD_X
    @hud_bg.y = HUD_Y
    @hud_bg.visible = false

    @hud_bar = Sprite.new(@hud_viewport)
    @hud_bar.bitmap = Bitmap.new(BAR_IMAGE)
    @hud_bar.x = HUD_X
    @hud_bar.y = HUD_Y
    @hud_bar.visible = false

    @hud_text = Sprite.new(@hud_viewport)
    @hud_text.bitmap = Bitmap.new(@hud_bg.bitmap.width, @hud_bg.bitmap.height)
    @hud_text.x = HUD_X
    @hud_text.y = HUD_Y
    @hud_text.visible = false
    pbSetSystemFont(@hud_text.bitmap)
  end

  def self.dispose_hud
    @hud_bg.dispose if @hud_bg && !@hud_bg.disposed?
    @hud_bg = nil
    @hud_bar.dispose if @hud_bar && !@hud_bar.disposed?
    @hud_bar = nil
    @hud_text.dispose if @hud_text && !@hud_text.disposed?
    @hud_text = nil
    @hud_viewport.dispose if @hud_viewport && !@hud_viewport.disposed?
    @hud_viewport = nil
  end

  EventHandlers.add(:on_enter_map, :roguelike_hud_create,
    proc {
      create_hud
    }
  )

  EventHandlers.add(:on_leave_map, :roguelike_hud_dispose,
    proc {
      dispose_hud
    }
  )
end
