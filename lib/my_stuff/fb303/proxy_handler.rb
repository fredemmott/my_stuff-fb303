# Copyright 2011-present Fred Emmott. See COPYING file.

module MyStuff
  module Fb303
    class ProxyHandler
      def initialize server
        @s = server
      end

      def method_missing meth, *args
        @s.increment_counter "#{meth}.called"
        begin
          result = @s.send(meth, *args)
          @s.increment_counter "#{meth}.success"
          result
        rescue => e
          @s.increment_counter "#{meth}.exception"
          @s.increment_counter "#{meth}.exception.#{e.class.name}"

          if e.is_a? Thrift::Exception
            # Presumably defined in the Thrift interface file
            level = :warn
          else
            # Definitely not :(
            level = :error
          end

          begin
            # MyStuff::Logger exception, allowing us to specify the
            # backtrace.
            @s.logger.raw_log e.backtrace, level, e
          rescue NoMethodError
            @s.logger.send level, e
          end

          raise
        end
      end
    end
  end
end
