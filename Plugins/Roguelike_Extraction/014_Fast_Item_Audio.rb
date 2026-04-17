#===============================================================================
# Fast Item Audio Override (Roguelike QoL)
# Intercepts both direct ME calls and embedded \me[] message tags.
# Replaces them with a parallel SE (Sound Effect) and reduces wait times.
#===============================================================================

# 1. Intercept direct Audio Method Calls
alias rogue_fast_item_pbMEPlay pbMEPlay unless defined?(rogue_fast_item_pbMEPlay)

def pbMEPlay(me, volume = nil, pitch = nil)
  me_name = ""
  
  if me.is_a?(String)
    me_name = me
  elsif me.respond_to?(:name)
    me_name = me.name
  end

  clean_name = me_name.downcase.gsub(/[\s_]/, "")
  
  if clean_name.include?("item") || clean_name.include?("tmget")
    pbSEPlay("Rogue_Item", volume, pitch)
    return
  end

  rogue_fast_item_pbMEPlay(me, volume, pitch)
end

# 2. Intercept Message System Tags (Essentials v21.1 specific)
# Essentials often plays item MEs inside the text strings using \me[Item get].
# We intercept pbMessage to dynamically replace these tags before the text draws.
alias rogue_fast_item_pbMessage pbMessage unless defined?(rogue_fast_item_pbMessage)

def pbMessage(message, commands = nil, cmdIfCancel = 0, skin = nil, defaultCmd = 0, &block)
  if message.is_a?(String)
    # Find \me[Item get], \me[Key item get], etc. ignoring case
    if message.match(/\\me\[(.*?(item|tmget).*?)\]/i)
      
      # Replace the Musical Effect tag with our Sound Effect tag
      message = message.gsub(/\\me\[(.*?(item|tmget).*?)\]/i, "\\se[Rogue_Item]")
      
      # Speed up the auto-close wait time from 30 frames to 10 frames for fast looting
      message = message.gsub(/\\wtnp\[\d+\]/i, "\\wtnp[0]")
      
      # Strip out any explicit "Wait for ME to finish" tags to prevent forced pauses
      message = message.gsub(/\\wtME/i, "")
    end
  end
  
  rogue_fast_item_pbMessage(message, commands, cmdIfCancel, skin, defaultCmd, &block)
end