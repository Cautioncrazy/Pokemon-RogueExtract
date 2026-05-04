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
  HUD_SCALE        = 0.66
  HUD_BASE_X       = Graphics.width - 350
  HUD_BASE_Y       = -40
  BAR_OFFSET_X     = 10
  BAR_OFFSET_Y     = 118
  TEXT_OFFSET_X    = 0
  TEXT_OFFSET_Y    = 66
  BAR_WINDOW_WIDTH = 225
  BAR_SECTION_WIDTH= 242
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

  # When the master switch is toggled, reset the timer and tier
  EventHandlers.add(:on_game_switch_change, :roguelike_timer_reset,
    proc { |switch_id, value|
      if switch_id == ROGUELIKE_RUN_ACTIVE_SWITCH
        $game_variables[TIMER_SECONDS_VAR] = 0
        $game_variables[DIFFICULTY_TIER_VAR] = 1
        @frame_counter = 0 if value == true
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

      # Determine text width with generous padding
      base_width = @hud_text.bitmap.text_size(text_str).width
      text_width = base_width + 40
      box_height = 32

      # The exact center of our 500px wide canvas is 250
      center_x = 250

      box_x = center_x - (text_width / 2)
      box_y = 2

      @hud_text.bitmap.fill_rect(box_x, box_y, text_width, box_height, Color.new(0, 0, 0, 150))

      text_pos = [
        [text_str, center_x, 6, 2, Color.new(255, 255, 255), Color.new(0, 0, 0)]
      ]
      pbDrawTextPositions(@hud_text.bitmap, text_pos)
      @last_drawn_text = text_str
    end

    # Animate Progress Bar (Color Panning & Endless Loop)
    max_run_seconds = 8 * SECONDS_PER_TIER
    max_scroll = 8 * BAR_SECTION_WIDTH

    if seconds < max_run_seconds
      # Normal panning for the first 8 blocks (Scrolls from 0 to 1936)
      fill_percentage = seconds.to_f / max_run_seconds.to_f
      @hud_bar.src_rect.x = (max_scroll * fill_percentage).to_i
    else
      # Endless loop of the final 9th segment
      # How many seconds into the current endless loop are we?
      overflow_seconds = seconds - max_run_seconds
      loop_progress = (overflow_seconds % SECONDS_PER_TIER).to_f / SECONDS_PER_TIER.to_f

      # Start at 1936 and slide to 2178. When it hits 2178 (at 27 mins), it snaps back to 1936.
      loop_start_x = max_scroll

      @hud_bar.src_rect.x = (loop_start_x + (BAR_SECTION_WIDTH * loop_progress)).to_i
    end

    # Ensure the width is permanently locked so it always fills the UI hole
    @hud_bar.src_rect.width = BAR_WINDOW_WIDTH
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

        # Calculate tier strictly based on total seconds (Floor division)
        # Tier 1 = 0-179s, Tier 2 = 180-359s, etc.
        calculated_tier = ($game_variables[TIMER_SECONDS_VAR] / SECONDS_PER_TIER) + 1
        $game_variables[DIFFICULTY_TIER_VAR] = calculated_tier > 8 ? 8 : calculated_tier
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
    @hud_bg.x = HUD_BASE_X
    @hud_bg.y = HUD_BASE_Y
    @hud_bg.zoom_x = HUD_SCALE
    @hud_bg.zoom_y = HUD_SCALE
    @hud_bg.z = 10
    @hud_bg.visible = false

    @hud_bar = Sprite.new(@hud_viewport)
    @hud_bar.bitmap = Bitmap.new(BAR_IMAGE)
    @hud_bar.src_rect = Rect.new(0, 0, BAR_WINDOW_WIDTH, @hud_bar.bitmap.height)

    @hud_bar.zoom_x = HUD_SCALE
    @hud_bar.zoom_y = HUD_SCALE
    @hud_bar.x = HUD_BASE_X + (BAR_OFFSET_X * HUD_SCALE)
    @hud_bar.y = HUD_BASE_Y + (BAR_OFFSET_Y * HUD_SCALE)
    @hud_bar.z = 5
    @hud_bar.visible = false

    @hud_text = Sprite.new(@hud_viewport)
    # Give the text a massive 500px wide canvas so it never clips
    @hud_text.bitmap = Bitmap.new(500, 100)

    # Re-apply the HUD_SCALE
    @hud_text.zoom_x = HUD_SCALE
    @hud_text.zoom_y = HUD_SCALE

    # Center this massive scaled canvas over the scaled background
    bg_scaled_width = @hud_bg.bitmap.width * HUD_SCALE
    text_scaled_half_width = 250 * HUD_SCALE

    @hud_text.x = HUD_BASE_X + (bg_scaled_width / 2) - text_scaled_half_width
    @hud_text.y = HUD_BASE_Y + (TEXT_OFFSET_Y * HUD_SCALE)
    @hud_text.z = 15
    @hud_text.visible = false
    pbSetSystemFont(@hud_text.bitmap)
  end

  def self.dispose_hud
    if @hud_bg && !@hud_bg.disposed?
      @hud_bg.bitmap.dispose if @hud_bg.bitmap && !@hud_bg.bitmap.disposed?
      @hud_bg.dispose
    end
    @hud_bg = nil

    if @hud_bar && !@hud_bar.disposed?
      @hud_bar.bitmap.dispose if @hud_bar.bitmap && !@hud_bar.bitmap.disposed?
      @hud_bar.dispose
    end
    @hud_bar = nil

    if @hud_text && !@hud_text.disposed?
      @hud_text.bitmap.dispose if @hud_text.bitmap && !@hud_text.bitmap.disposed?
      @hud_text.dispose
    end
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
