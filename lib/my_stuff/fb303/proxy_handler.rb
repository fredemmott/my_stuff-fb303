# Copyright 2011-present Fred Emmott. All Rights Reserved.

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
          raise
        end
      end
    end
  end
end
