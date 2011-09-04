# Copyright 2011-present Fred Emmott. See COPYING file.

# Monkey-patch Thrift::Processor to not completely bail on undefined
# exceptions.

module MyStuff
  module Fb303
    module ResilientProcessor
      class SpyIProt
        def initialize iprot
          @iprot = iprot
          @mode = :capture
        end

        def read_message_begin
          case @mode
          when :capture
            @header = @iprot.read_message_begin
            @mode = :replay
            @header
          when :replay
            @mode = :normal
            @header
          when :normal
            @iprot.read_message_begin
          else
            raise "Reached a bad state: %s" % @mode
          end
        end

        def method_missing *args
          @iprot.send *args
        end
      end

      def resilient_process iprot, oprot
        spy = SpyIProt.new(iprot)
        name, type, seqid = spy.read_message_begin

        begin
          unresilient_process(spy, oprot)
        rescue => e
          ae = Thrift::ApplicationException.new(
            Thrift::ApplicationException::UNKNOWN,
            e.inspect
          )
          oprot.write_message_begin(name, Thrift::MessageTypes::EXCEPTION, seqid)
          ae.write oprot
          oprot.write_message_end
          oprot.trans.flush
          false
        end
      end

      def self.extended other
        class <<other
          alias :unresilient_process :process
          alias :process :resilient_process
        end
      end
    end
  end
end
