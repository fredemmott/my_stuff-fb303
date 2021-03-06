# Copyright 2011-present Fred Emmott. See COPYING file.

require 'my_stuff/fb303/proxy_handler'

# Code used for MyStuff.ws
module MyStuff
  module Fb303
    class Server
      def initialize interface, name, version = ''
        @name      = name
        @version   = version
        @interface = interface

        @status         = Fb_status::STARTING
        @status_details = ''
        @started_at     = Time.new.to_i
        @counters       = Hash.new(0)

        logger.info 'Starting fb303 service...'
        start_fb303_server
        logger.info 'fb303 service running.'
        logger.info 'Loading handler...'
        handler
        logger.info 'Handler loaded.'
      end

      def run!
        @status  = Fb_status::ALIVE
        logger.info 'Alive, waiting on server thread.'
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
        @fb303_thread.kill if @fb303_thread
        @status = Fb_status::STOPPED
      end

      def increment_counter name
        @counters[name] += 1
      end

      def method_missing *args
        unless self.getStatus == Fb_status::ALIVE
          raise 'Handler unavailable in current status.'
        end

        if self.handler != self
            self.handler.send *args
        else
          super *args
        end
      end

      def handler
        self
      end

      attr_writer :logger
      def logger
        @logger || self.class.logger
      end

      class <<self
        attr_writer :logger
        def logger
          return @logger if @logger
          begin
            @logger = MyStuff::Logger.new
          rescue NameError
            require 'logger'
            @logger = ::Logger.new(STDOUT)
          end
        end
      end

      protected

      def server_for processor
        raise NotImplementedError.new
      end

      def start_fb303_server
        handler   = MyStuff::Fb303::ProxyHandler.new(self)
        processor = @interface.const_get(:Processor).new(handler)
        @server   = server_for(processor)

        @server_thread = Thread.new do
          @server.serve
        end
      end
    end
  end
end
