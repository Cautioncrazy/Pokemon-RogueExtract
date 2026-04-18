#===============================================================================
# Global JoiPlay Crash Logger
# Intercepts EventScriptError exceptions directly from Interpreter#execute_script
# By dumping the error stack to a text file, this enables debugging of all
# engine and procedural event crashes on the JoiPlay emulator before a hard crash.
#===============================================================================

class Interpreter
  unless method_defined?(:execute_script_joiplay_logger)
    alias execute_script_joiplay_logger execute_script

    def execute_script(script)
      begin
        execute_script_joiplay_logger(script)
      rescue Exception => e
        # Build the error message payload, keeping it simple to avoid syntax issues.
        # Essentials already wraps eval() errors in EventScriptError and provides a robust string.
        error_msg = "=== EVENT SCRIPT CRASH ===\n"
        error_msg += e.message + "\n"
        error_msg += e.backtrace.join("\n") if e.backtrace
        error_msg += "\n\n"

        # Write to local file
        begin
          File.open("joiplay_crash_log.txt", "a") { |f| f.puts(error_msg) }
        rescue
          # Failsafe if file I/O is somehow locked
        end

        # Attempt to display it gracefully
        begin
          pbMessage(_INTL("CRASH CAUGHT! Check joiplay_crash_log.txt"))
        rescue
        end

        # Return false to safely abort the event execution without bubbling up the crash.
        return false
      end
    end
  end
end
