# -*- encoding: utf-8 -*-
#
# Author:: Fletcher Nichol (<fnichol@nichol.ca>)
#
# Copyright (C) 2013, Fletcher Nichol
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

require 'kitchen/command'

require 'rubygems/spec_fetcher'
require 'safe_yaml'

module Kitchen

  module Command

    # Command to discover drivers published on RubyGems.
    #
    # @author Fletcher Nichol <fnichol@nichol.ca>
    class DriverDiscover < Kitchen::Command::Base

      def call
        specs = fetch_gem_specs.sort { |x, y| x[0] <=> y[0] }
        specs = specs[0, 49].push(["...", "..."]) if specs.size > 49
        specs = specs.unshift(["Gem Name", "Latest Stable Release"])
        print_table(specs, :indent => 4)
      end

      protected

      def fetch_gem_specs
        SafeYAML::OPTIONS[:suppress_warnings] = true
        req = Gem::Requirement.default
        dep = Gem::Deprecate.skip_during do
          Gem::Dependency.new(/kitchen-/i, req)
        end
        fetcher = Gem::SpecFetcher.fetcher

        specs = if fetcher.respond_to?(:find_matching)
          fetch_gem_specs_pre_rubygems_2(fetcher, dep)
        else
          fetch_gem_specs_post_rubygems_2(fetcher, dep)
        end
      end

      def fetch_gem_specs_post_rubygems_2(fetcher, dep)
        specs = fetcher.spec_for_dependency(dep, false)
        specs.first.map { |t| [t.first.name, t.first.version] }
      end

      def fetch_gem_specs_pre_rubygems_2(fetcher, dep)
        specs = fetcher.find_matching(dep, false, false, false)
        specs.map { |t| t.first }.map { |t| t[0, 2] }
      end

      def print_table(*args)
        shell.print_table(*args)
      end
    end
  end
end
