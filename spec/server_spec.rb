# Copyright 2011-2012 Fred Emmott. See COPYING file.

require 'spec_helper'

require 'my_stuff/fb303/server'

require 'logger'

describe MyStuff::Fb303::Server do
  it 'can be constructed' do
    lambda{
      EchoServer.new
    }.should_not raise_error
  end

  describe '#logger' do
    before :each do
      # Server calls logger in the constructor, so, lets just stub it out :)
      @serverclass = Class.new(MyStuff::Fb303::Server)
      @serverclass.send(:define_method, :initialize, lambda{})
    end

    it 'creates a standard logger' do
      @serverclass.new.logger.should be_a ::Logger
    end

    it 'creates a MyStuff::Logger if available' do
      begin
        logger = Class.new(::Logger)
        logger.send(:define_method, :initialize, lambda{super STDOUT})
        @serverclass.new.logger.should_not be_a logger
        MyStuff.const_set(:Logger, logger)
        @serverclass.new.logger.should be_a logger
      ensure
        MyStuff.send :remove_const, :Logger rescue nil
      end
    end

    it 'returns the same logger for multiple calls' do
      server = @serverclass.new
      server.logger.object_id.should == server.logger.object_id
    end
  end
end
