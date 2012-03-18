# Copyright 2011-2012 Fred Emmott. See COPYING file.

require 'spec_helper'

require 'my_stuff/fb303/server'

require 'logger'

class DummyServer < MyStuff::Fb303::Server
  def initialize
  end
end

describe MyStuff::Fb303::Server do
  before :each do
    MyStuff::Fb303::Server.logger = Logger.new(nil)
    EchoServer.logger = Logger.new(nil)
  end

  it 'can be constructed' do
    lambda{
      EchoServer.new
    }.should_not raise_error
  end

  describe '#logger' do
    before :each do
    end

    it 'returns the class logger if not overriden' do
      DummyServer.new.logger.should be DummyServer.logger
    end

    it 'returns any overridden logger' do
      instance = DummyServer.new
      logger = Object.new
      instance.logger = logger
      instance.logger.should be logger
    end
  end

  describe '.logger' do
    before :each do
      @server = MyStuff::Fb303::Server
      @server.logger = nil
    end

    it 'creates a standard logger' do
      @server.logger.should be_a ::Logger
    end

    it 'creates a MyStuff::Logger if available' do
      begin
        logger = Class.new(::Logger)
        logger.send(:define_method, :initialize, lambda{super STDOUT})
        @server.logger.should_not be_a logger
        MyStuff.const_set(:Logger, logger)
        @server.logger = nil
        @server.logger.should be_a logger
      ensure
        MyStuff.send :remove_const, :Logger rescue nil
      end
    end

    it 'returns the same logger for multiple calls' do
      @server.logger.object_id.should == @server.logger.object_id
    end
  end

  describe '#shutdown' do
    before :each do
      @server = DummyServer.new
    end

    it 'should work even if theres no thread yet' do
      lambda{
        @server.instance_eval {
          @fb303_thread = nil
          shutdown
        }
      }.should_not raise_error
    end

    it 'should kill the thread if there is one' do
      fake_thread = Object.new
      fake_thread.should_receive :kill
      lambda{
        @server.instance_eval {
          @fb303_thread = fake_thread
          shutdown
        }
      }.should_not raise_error
    end

    it 'changes the status to STOPPED' do
      @server.getStatus.should_not == Fb_status::STARTING
      @server.shutdown
      @server.getStatus.should == Fb_status::STOPPED
    end
  end
end
