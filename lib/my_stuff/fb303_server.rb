# Copyright 2011-present Fred Emmott. All Rights Reserved.

# Code used for MyStuff.ws
module MyStuff
  # Ruby implementation of Facebook's fb303 interface.
  class Fb303Server
    def initialize interface, name, version = ''
      @name      = name
      @version   = version
      @interface = interface

      @status         = Fb_status::STARTING
      @status_details = ''
      @started_at     = Time.new.to_i
      @counters       = Hash.new(0)

      start_fb303_server
    end

    def run!
      @status  = Fb_status::ALIVE
      @server_thread.join
    end

    ##### fb303 implementation #####

    def getName; @name; end
    def getVersion; @version; end
    def getStatus; @status; end
    def getStatusDetails; @status_details; end
    def aliveSince; @started_at; end
    def getCounters; @counters; end
    def getCounter key; @counters[key]; end
    def getOption key; ''; end
    def getOptions; {}; end
    def getCpuProfile duration; ''; end
    def setOption key, value; end
    def reinitialize; raise NotImplementedError.new; end

    def shutdown
      @status = Fb_status::STOPPING
      @status_details = 'Shutdown requested via fb303'
      @fb303_thread.kill
      @status = Fb_status::STOPPED
    end

    def increment_counter name
      @counters[name] += 1
    end

    protected

    def server_for processor
      raise NotImplementedError.new
    end

    def handler
      self
    end

    def start_fb303_server
      processor = @interface.const_get(:Processor).new(handler)
      @server   = server_for(processor)

      @server_thread = Thread.new do
        @server.serve
      end
    end
  end
end
