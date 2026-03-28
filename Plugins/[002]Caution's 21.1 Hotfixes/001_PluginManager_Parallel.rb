module PluginManager
  def self.compilePlugins(order, plugins)
    Console.echo_li("Compiling plugin scripts...")
    scripts = []

    # go through the entire order one by one
    order.each do |o|
      # save name, metadata and scripts array
      meta = plugins[o].clone
      meta.delete(:scripts)
      meta.delete(:dir)
      dat = [o, meta, []]

      # Use a queue to safely distribute files among threads
      queue = Queue.new
      plugins[o][:scripts].each { |file| queue << file }

      mutex = Mutex.new
      local_dat = []

      # Determine optimal number of threads (capped at 8 or the number of scripts)
      num_threads = [8, plugins[o][:scripts].size].min
      num_threads = 1 if num_threads < 1

      threads = num_threads.times.map do
        Thread.new do
          thread_dat = []
          while !queue.empty?
            begin
              file = queue.pop(true)
              # Read and compress file contents in parallel
              thread_dat << [file, Zlib::Deflate.deflate(File.binread("#{plugins[o][:dir]}/#{file}"))]
            rescue ThreadError
              break
            end
          end
          # Synchronize when merging thread results into main array
          mutex.synchronize { local_dat.concat(thread_dat) }
        end
      end

      threads.each(&:join)

      # Preserve the original file order
      plugins[o][:scripts].each do |file|
        # Find the compressed data for this file
        found = local_dat.find { |d| d[0] == file }
        dat[2].push(found) if found
      end

      # push to the main scripts array
      scripts.push(dat)
    end

    # save to main `PluginScripts.rxdata` file
    File.open("Data/PluginScripts.rxdata", "wb") { |f| Marshal.dump(scripts, f) }

    # collect garbage
    GC.start
    Console.echo_done(true)
  end
end
