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

require 'mixlib/shellout'

module Kitchen

  # Mixin that wraps a command shell out invocation, providing a #run_command
  # method.
  #
  # @author Fletcher Nichol <fnichol@nichol.ca>
  module ShellOut

    # Wrapped exception for any interally raised shell out commands.
    class ShellCommandFailed < TransientFailure ; end

    # Executes a command in a subshell on the local running system.
    #
    # @param cmd [String] command to be executed locally
    # @param options [Hash] additional configuration of command
    # @option options [TrueClass, FalseClass] :use_sudo whether or not to use
    #   sudo
    # @option options [String] :log_subject used in the output or log header
    #   for clarity and context. Default is "local".
    # @option options [String] :cwd the directory to chdir to before running
    #   the command
    # @option options [Hash] :environment a Hash of environment variables to
    #   set before the command is run. By default, the environment will
    #   *always* be set to 'LC_ALL' => 'C' to prevent issues with multibyte
    #   characters in Ruby 1.8. To avoid this, use :environment => nil for
    #   *no* extra environment settings, or
    #   :environment => {'LC_ALL'=>nil, ...} to set other environment settings
    #   without changing the locale.
    # @option options [Integer] :timeout Numeric value for the number of
    #   seconds to wait on the child process before raising an Exception.
    #   This is calculated as the total amount of time that ShellOut waited on
    #   the child process without receiving any output (i.e., IO.select
    #   returned nil). Default is 60000 seconds. Note: the stdlib Timeout
    #   library is not used.
    # @return [String] the standard output of the command as a String
    # @raise [ShellCommandFailed] if the command fails
    # @raise [Error] for all other unexpected exceptions
    def run_command(cmd, options = {})
      use_sudo = options[:use_sudo].nil? ? false : options[:use_sudo]
      cmd = "sudo -E #{cmd}" if use_sudo
      subject = "[#{options[:log_subject] || "local"} command]"

      debug("#{subject} BEGIN (#{display_cmd(cmd)})")
      sh = Mixlib::ShellOut.new(cmd, shell_opts(options))
      sh.run_command
      debug("#{subject} END #{Util.duration(sh.execution_time)}")
      sh.error!
      sh.stdout
    rescue Mixlib::ShellOut::ShellCommandFailed => ex
      raise ShellCommandFailed, ex.message
    rescue Exception => error
      error.extend(Kitchen::Error)
      raise
    end

    private

    def display_cmd(cmd)
      first_line, newline, rest = cmd.partition("\n")
      last_char = cmd[cmd.size - 1]

      newline == "\n" ? "#{first_line}\\n...#{last_char}" : cmd
    end

    def shell_opts(options)
      filtered_opts = options.reject do |key, value|
        [:use_sudo, :log_subject, :quiet].include?(key)
      end
      { :live_stream => logger, :timeout => 60000 }.merge(filtered_opts)
    end
  end
end
