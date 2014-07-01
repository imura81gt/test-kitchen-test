# -*- encoding: utf-8 -*-
#
# Author:: Fletcher Nichol (<fnichol@nichol.ca>)
#
# Copyright (C) 2012, Fletcher Nichol
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require_relative '../spec_helper'
require 'stringio'

require 'kitchen/logging'
require 'kitchen/instance'
require 'kitchen/driver'
require 'kitchen/driver/dummy'
require 'kitchen/platform'
require 'kitchen/provisioner'
require 'kitchen/provisioner/dummy'
require 'kitchen/suite'

class DummyStateFile

  def initialize(*args) ; end

  def read
    @_state = Hash.new unless @_state
    @_state.dup
  end

  def write(state)
    @_state = state.dup
  end

  def destroy
    @_state = nil
  end
end

class SerialDummyDriver < Kitchen::Driver::Dummy

  no_parallel_for :create, :verify, :destroy

  attr_reader :action_in_mutex

  def track_locked(action)
    @action_in_mutex = Hash.new unless @action_in_mutex
    @action_in_mutex[action] = Kitchen::Instance.mutexes[self.class].locked?
  end

  def create(state)
    track_locked(:create)
    super
  end

  def converge(state)
    track_locked(:converge)
    super
  end

  def setup(state)
    track_locked(:setup)
    super
  end

  def verify(state)
    track_locked(:verify)
    super
  end

  def destroy(state)
    track_locked(:destroy)
    super
  end
end

describe Kitchen::Instance do

  let(:driver)      { Kitchen::Driver::Dummy.new({}) }
  let(:logger_io)   { StringIO.new }
  let(:logger)      { Kitchen::Logger.new(:logdev => logger_io) }
  let(:instance)    { Kitchen::Instance.new(opts) }
  let(:provisioner) { Kitchen::Provisioner::Dummy.new({}) }
  let(:state_file)  { DummyStateFile.new }
  let(:busser)      { Kitchen::Busser.new(suite.name, {}) }

  let(:opts) do
    { :suite => suite, :platform => platform, :driver => driver,
      :provisioner => provisioner, :busser => busser,
      :logger => logger, :state_file => state_file }
  end

  def suite(name = "suite")
    @suite ||= Kitchen::Suite.new({ :name => name })
  end

  def platform(name = "platform")
    @platform ||= Kitchen::Platform.new({ :name => name })
  end

  describe ".name_for" do

    it "combines the suite and platform names with a dash" do
      Kitchen::Instance.name_for(suite("suite"), platform("platform")).
        must_equal "suite-platform"
    end

    it "squashes periods in suite name" do
      Kitchen::Instance.name_for(suite("suite.ness"), platform("platform")).
        must_equal "suiteness-platform"
    end

    it "squashes periods in platform name" do
      Kitchen::Instance.name_for(suite("suite"), platform("platform.s")).
        must_equal "suite-platforms"
    end

    it "squashes periods in suite and platform names" do
      Kitchen::Instance.name_for(suite("s.s"), platform("p.p")).
        must_equal "ss-pp"
    end

    it "transforms underscores to dashes in suite name" do
      Kitchen::Instance.name_for(suite("suite_ness"), platform("platform")).
        must_equal "suite-ness-platform"
    end

    it "transforms underscores to dashes in platform name" do
      Kitchen::Instance.name_for(suite("suite"), platform("platform_s")).
        must_equal "suite-platform-s"
    end

    it "transforms underscores to dashes in suite and platform names" do
      Kitchen::Instance.name_for(suite("_s__s_"), platform("pp_")).
        must_equal "-s--s--pp-"
    end
  end

  describe "#suite" do

    it "returns its suite" do
      instance.suite.must_equal suite
    end

    it "raises an ArgumentError if missing" do
      opts.delete(:suite)
      proc { Kitchen::Instance.new(opts) }.must_raise Kitchen::ClientError
    end
  end

  describe "#platform" do

    it "returns its platform" do
      instance.platform.must_equal platform
    end

    it "raises an ArgumentError if missing" do
      opts.delete(:platform)
      proc { Kitchen::Instance.new(opts) }.must_raise Kitchen::ClientError
    end
  end

  describe "#driver" do

    it "returns its driver" do
      instance.driver.must_equal driver
    end

    it "raises an ArgumentError if missing" do
      opts.delete(:driver)
      proc { Kitchen::Instance.new(opts) }.must_raise Kitchen::ClientError
    end

    it "sets Driver#instance to itself" do
      # it's mind-bottling
      instance.driver.instance.must_equal instance
    end
  end

  describe "#logger" do

    it "returns its logger" do
      instance.logger.must_equal logger
    end

    it "uses Kitchen.logger by default" do
      opts.delete(:logger)
      instance.logger.must_equal Kitchen.logger
    end
  end

  describe "#provisioner" do

    it "returns its provisioner" do
      instance.provisioner.must_equal provisioner
    end

    it "raises an ArgumentError if missing" do
      opts.delete(:provisioner)
      proc { Kitchen::Instance.new(opts) }.must_raise Kitchen::ClientError
    end

    it "sets Provisioner#instance to itself" do
      # it's mind-bottling
      instance.provisioner.instance.must_equal instance
    end
  end

  describe "#busser" do

    it "returns its busser" do
      instance.busser.must_equal busser
    end

    it "raises and ArgumentError if missing" do
      opts.delete(:busser)
      proc { Kitchen::Instance.new(opts) }.must_raise Kitchen::ClientError
    end
  end

  describe "#state_file" do

    it "raises an ArgumentError if missing" do
      opts.delete(:state_file)
      proc { Kitchen::Instance.new(opts) }.must_raise Kitchen::ClientError
    end
  end

  it "#name returns it name" do
    instance.name.must_equal "suite-platform"
  end

  it "#to_str returns a string representation with its name" do
    instance.to_str.must_equal "<suite-platform>"
  end

  it "#login executes the driver's login_command" do
    driver.stubs(:login_command).with(Hash.new).
      returns(Kitchen::LoginCommand.new(["echo", "hello"], {:purple => true}))
    Kernel.expects(:exec).with("echo", "hello", {:purple => true})

    instance.login
  end

  describe "performing actions" do

    describe "#create" do

      describe "with no state" do

        it "calls Driver#create with empty state hash" do
          driver.expects(:create).with(Hash.new)

          instance.create
        end

        it "writes the state file with last_action" do
          instance.create

          state_file.read[:last_action].must_equal "create"
        end

        it "logs the action start" do
          instance.create

          logger_io.string.must_match regex_for("Creating #{instance.to_str}")
        end

        it "logs the action finish" do
          instance.create

          logger_io.string.
            must_match regex_for("Finished creating #{instance.to_str}")
        end

      end

      describe "with last_action of create" do

        before { state_file.write({ :last_action => "create"}) }

        it "calls Driver#create with state hash" do
          driver.expects(:create).
            with { |state| state[:last_action] == "create" }

          instance.create
        end

        it "writes the state file with last_action" do
          instance.create

          state_file.read[:last_action].must_equal "create"
        end
      end
    end

    describe "#converge" do

      describe "with no state" do

        it "calls Driver#create and converge with empty state hash" do
          driver.expects(:create).with(Hash.new)
          driver.expects(:converge).
            with { |state| state[:last_action] == "create" }

          instance.converge
        end

        it "writes the state file with last_action" do
          instance.converge

          state_file.read[:last_action].must_equal "converge"
        end

        it "logs the action start" do
          instance.converge

          logger_io.string.must_match regex_for("Converging #{instance.to_str}")
        end

        it "logs the action finish" do
          instance.converge

          logger_io.string.
            must_match regex_for("Finished converging #{instance.to_str}")
        end
      end

      describe "with last action of create" do

        before { state_file.write({ :last_action => "create"}) }

        it "calls Driver#converge with state hash" do
          driver.expects(:converge).
            with { |state| state[:last_action] == "create" }

          instance.converge
        end

        it "writes the state file with last_action" do
          instance.converge

          state_file.read[:last_action].must_equal "converge"
        end
      end

      describe "with last action of converge" do

        before { state_file.write({ :last_action => "converge"}) }

        it "calls Driver#converge with state hash" do
          driver.expects(:converge).
            with { |state| state[:last_action] == "converge" }

          instance.converge
        end

        it "writes the state file with last_action" do
          instance.converge

          state_file.read[:last_action].must_equal "converge"
        end
      end
    end

    describe "#setup" do

      describe "with no state" do

        it "calls Driver#create, converge, and setup with empty state hash" do
          driver.expects(:create).with(Hash.new)
          driver.expects(:converge).
            with { |state| state[:last_action] == "create" }
          driver.expects(:setup).
            with { |state| state[:last_action] == "converge" }

          instance.setup
        end

        it "writes the state file with last_action" do
          instance.setup

          state_file.read[:last_action].must_equal "setup"
        end

        it "logs the action start" do
          instance.setup

          logger_io.string.must_match regex_for("Setting up #{instance.to_str}")
        end

        it "logs the action finish" do
          instance.setup

          logger_io.string.
            must_match regex_for("Finished setting up #{instance.to_str}")
        end
      end

      describe "with last action of create" do

        before { state_file.write({ :last_action => "create"}) }

        it "calls Driver#converge and setup with state hash" do
          driver.expects(:converge).
            with { |state| state[:last_action] == "create" }
          driver.expects(:setup).
            with { |state| state[:last_action] == "converge" }

          instance.setup
        end

        it "writes the state file with last_action" do
          instance.setup

          state_file.read[:last_action].must_equal "setup"
        end
      end

      describe "with last action of converge" do

        before { state_file.write({ :last_action => "converge"}) }

        it "calls Driver#setup with state hash" do
          driver.expects(:setup).
            with { |state| state[:last_action] == "converge" }

          instance.setup
        end

        it "writes the state file with last_action" do
          instance.setup

          state_file.read[:last_action].must_equal "setup"
        end
      end

      describe "with last action of setup" do

        before { state_file.write({ :last_action => "setup"}) }

        it "calls Driver#setup with state hash" do
          driver.expects(:setup).
            with { |state| state[:last_action] == "setup" }

          instance.setup
        end

        it "writes the state file with last_action" do
          instance.setup

          state_file.read[:last_action].must_equal "setup"
        end
      end
    end

    describe "#verify" do

      describe "with no state" do

        it "calls Driver#create, converge, setup, and verify with empty state hash" do
          driver.expects(:create).with(Hash.new)
          driver.expects(:converge).
            with { |state| state[:last_action] == "create" }
          driver.expects(:setup).
            with { |state| state[:last_action] == "converge" }
          driver.expects(:verify).
            with { |state| state[:last_action] == "setup" }

          instance.verify
        end

        it "writes the state file with last_action" do
          instance.verify

          state_file.read[:last_action].must_equal "verify"
        end

        it "logs the action start" do
          instance.verify

          logger_io.string.must_match regex_for("Verifying #{instance.to_str}")
        end

        it "logs the action finish" do
          instance.verify

          logger_io.string.
            must_match regex_for("Finished verifying #{instance.to_str}")
        end
      end

      describe "with last of create" do

        before { state_file.write({ :last_action => "create"}) }

        it "calls Driver#converge, setup, and verify with state hash" do
          driver.expects(:converge).
            with { |state| state[:last_action] == "create" }
          driver.expects(:setup).
            with { |state| state[:last_action] == "converge" }
          driver.expects(:verify).
            with { |state| state[:last_action] == "setup" }

          instance.verify
        end

        it "writes the state file with last_action" do
          instance.verify

          state_file.read[:last_action].must_equal "verify"
        end
      end

      describe "with last of converge" do

        before { state_file.write({ :last_action => "converge"}) }

        it "calls Driver#setup, and verify with state hash" do
          driver.expects(:setup).
            with { |state| state[:last_action] == "converge" }
          driver.expects(:verify).
            with { |state| state[:last_action] == "setup" }

          instance.verify
        end

        it "writes the state file with last_action" do
          instance.verify

          state_file.read[:last_action].must_equal "verify"
        end
      end

      describe "with last of setup" do

        before { state_file.write({ :last_action => "setup"}) }

        it "calls Driver#verify with state hash" do
          driver.expects(:verify).
            with { |state| state[:last_action] == "setup" }

          instance.verify
        end

        it "writes the state file with last_action" do
          instance.verify

          state_file.read[:last_action].must_equal "verify"
        end
      end

      describe "with last of verify" do

        before { state_file.write({ :last_action => "verify"}) }

        it "calls Driver#verify with state hash" do
          driver.expects(:verify).
            with { |state| state[:last_action] == "verify" }

          instance.verify
        end

        it "writes the state file with last_action" do
          instance.verify

          state_file.read[:last_action].must_equal "verify"
        end
      end
    end

    describe "#destroy" do

      describe "with no state" do

        it "calls Driver#destroy with empty state hash" do
          driver.expects(:destroy).with(Hash.new)

          instance.destroy
        end

        it "destroys the state file" do
          state_file.expects(:destroy)

          instance.destroy
        end

        it "logs the action start" do
          instance.destroy

          logger_io.string.
            must_match regex_for("Destroying #{instance.to_str}")
        end

        it "logs the create finish" do
          instance.destroy

          logger_io.string.
            must_match regex_for("Finished destroying #{instance.to_str}")
        end
      end

      [:create, :converge, :setup, :verify].each do |action|

        describe "with last_action of #{action}" do

          before { state_file.write({ :last_action => action}) }

          it "calls Driver#create with state hash" do
            driver.expects(:destroy).
              with { |state| state[:last_action] == action }

            instance.destroy
          end

          it "destroys the state file" do
            state_file.expects(:destroy)

            instance.destroy
          end
        end
      end
    end

    describe "#test" do

      describe "with no state" do

        it "calls Driver#destroy, create, converge, setup, verify, destroy" do
          driver.expects(:destroy)
          driver.expects(:create)
          driver.expects(:converge)
          driver.expects(:setup)
          driver.expects(:verify)
          driver.expects(:destroy)

          instance.test
        end

        it "logs the action start" do
          instance.test

          logger_io.string.must_match regex_for("Testing #{instance.to_str}")
        end

        it "logs the action finish" do
          instance.test

          logger_io.string.
            must_match regex_for("Finished testing #{instance.to_str}")
        end
      end

      [:create, :converge, :setup, :verify].each do |action|

        describe "with last action of #{action}" do

          before { state_file.write({ :last_action => action}) }

          it "calls Driver#destroy, create, converge, setup, verify, destroy" do
            driver.expects(:destroy)
            driver.expects(:create)
            driver.expects(:converge)
            driver.expects(:setup)
            driver.expects(:verify)
            driver.expects(:destroy)

            instance.test
          end
        end
      end

      describe "with destroy mode of never" do

        it "calls Driver#destroy, create, converge, setup, verify" do
          driver.expects(:destroy).once
          driver.expects(:create)
          driver.expects(:converge)
          driver.expects(:setup)
          driver.expects(:verify)

          instance.test(:never)
        end
      end

      describe "with destroy mode of always" do

        it "calls Driver#destroy at even when action fails" do
          driver.stubs(:converge).raises(Kitchen::ActionFailed)

          driver.expects(:destroy)
          driver.expects(:create)
          driver.expects(:converge)
          driver.expects(:destroy)

          instance.test(:always)
        end
      end

      describe "with destroy mode of passing" do

        it "doesn't call Driver#destroy at when action fails" do
          skip "figure this one out"
          driver.stubs(:create).raises(Kitchen::ActionFailed, "death")

          driver.expects(:destroy)
          driver.expects(:create)

          instance.test(:passing)
        end
      end
    end

    [:create, :converge, :setup, :verify, :test].each do |action|

      describe "#{action} on driver crash with ActionFailed" do

        before do
          driver.stubs(:create).raises(Kitchen::ActionFailed, "death")
        end

        it "write the state file with last action" do
          begin
            instance.public_send(action)
          rescue Kitchen::Error => e
          end

          state_file.read[:last_action].must_be_nil
        end

        it "raises an InstanceFailure" do
          proc { instance.public_send(action) }.
            must_raise Kitchen::InstanceFailure
        end

        it "populates the InstanceFailure message" do
          begin
            instance.public_send(action)
          rescue Kitchen::Error => e
            e.message.must_match regex_for(
              "Create failed on instance #{instance.to_str}")
          end
        end

        it "logs the failure" do
          begin
            instance.public_send(action)
          rescue Kitchen::Error => e
          end

          logger_io.string.must_match regex_for(
            "Create failed on instance #{instance.to_str}")
        end
      end

      describe "on driver crash with unexpected exception class" do

        before do
          driver.stubs(:create).raises(RuntimeError, "watwat")
        end

        it "write the state file with last action" do
          begin
            instance.public_send(action)
          rescue Kitchen::Error => e
          end

          state_file.read[:last_action].must_be_nil
        end

        it "raises an ActionFailed" do
          proc { instance.public_send(action) }.
            must_raise Kitchen::ActionFailed
        end

        it "populates the ActionFailed message" do
          begin
            instance.public_send(action)
          rescue Kitchen::Error => e
            e.message.must_match regex_for(
              "Failed to complete #create action: [watwat]")
          end
        end

        it "logs the failure" do
          begin
            instance.public_send(action)
          rescue Kitchen::Error => e
          end

          logger_io.string.must_match regex_for(
            "Create failed on instance #{instance.to_str}")
        end
      end
    end

    describe "crashes preserve last action for desired verify action" do

      before do
        driver.stubs(:verify).raises(Kitchen::ActionFailed, "death")
      end

      [:create, :converge, :setup].each do |action|

        it "for last state #{action}" do
          state_file.write({ :last_action => action.to_s })
          begin
            instance.verify
          rescue Kitchen::Error => e
          end

          state_file.read[:last_action].must_equal "setup"
        end
      end

      it "for last state verify" do
        state_file.write({ :last_action => "verify" })
        begin
          instance.verify
        rescue Kitchen::Error => e
        end

        state_file.read[:last_action].must_equal "verify"
      end
    end

    describe "on drivers with serial actions" do

      let(:driver) { SerialDummyDriver.new({}) }

      it "runs in a synchronized block for serial actions" do
        instance.test

        driver.action_in_mutex[:create].must_equal true
        driver.action_in_mutex[:converge].must_equal false
        driver.action_in_mutex[:setup].must_equal false
        driver.action_in_mutex[:verify].must_equal true
        driver.action_in_mutex[:destroy].must_equal true
      end
    end
  end

  describe Kitchen::Instance::FSM do

    let(:fsm) { Kitchen::Instance::FSM }

    describe ".actions" do

      it "passing nils returns destroy" do
        fsm.actions(nil, nil).must_equal [:destroy]
      end

      it "accepts a string for desired argument" do
        fsm.actions(nil, "create").must_equal [:create]
      end

      it "accepts a symbol for desired argument" do
        fsm.actions(nil, :create).must_equal [:create]
      end

      it "starting from no state to create returns create" do
        fsm.actions(nil, :create).must_equal [:create]
      end

      it "starting from :create to create returns create" do
        fsm.actions(:create, :create).must_equal [:create]
      end

      it "starting from no state to converge returns create, converge" do
        fsm.actions(nil, :converge).must_equal [:create, :converge]
      end

      it "starting from create to converge returns converge" do
        fsm.actions(:create, :converge).must_equal [:converge]
      end

      it "starting from converge to converge returns converge" do
        fsm.actions(:converge, :converge).must_equal [:converge]
      end

      it "starting from no state to setup returns create, converge, setup" do
        fsm.actions(nil, :setup).must_equal [:create, :converge, :setup]
      end

      it "starting from create to setup returns converge, setup" do
        fsm.actions(:create, :setup).must_equal [:converge, :setup]
      end

      it "starting from converge to setup returns setup" do
        fsm.actions(:converge, :setup).must_equal [:setup]
      end

      it "starting from setup to setup return setup" do
        fsm.actions(:setup, :setup).must_equal [:setup]
      end

      it "starting from no state to verify returns create, converge, setup, verify" do
        fsm.actions(nil, :verify).must_equal [:create, :converge, :setup, :verify]
      end

      it "starting from create to verify returns converge, setup, verify" do
        fsm.actions(:create, :verify).must_equal [:converge, :setup, :verify]
      end

      it "starting from converge to verify returns setup, verify" do
        fsm.actions(:converge, :verify).must_equal [:setup, :verify]
      end

      it "starting from setup to verify returns verify" do
        fsm.actions(:setup, :verify).must_equal [:verify]
      end

      it "starting from verify to verify returns verify" do
        fsm.actions(:verify, :verify).must_equal [:verify]
      end

      [:verify, :setup, :converge].each do |s|
        it "starting from #{s} to create returns create" do
          fsm.actions(s, :create).must_equal [:create]
        end
      end

      [:verify, :setup].each do |s|
        it "starting from #{s} to converge returns converge" do
          fsm.actions(s, :converge).must_equal [:converge]
        end
      end

      it "starting from verify to setup returns setup" do
        fsm.actions(:verify, :setup).must_equal [:setup]
      end
    end
  end

  def regex_for(string)
    Regexp.new(Regexp.escape(string))
  end
end
