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

require_relative '../spec_helper'

require 'kitchen/lazy_hash'

describe Kitchen::LazyHash do

  let(:context) do
    stub(:color => "blue", :metal => "heavy")
  end

  let(:hash) do
    {
      :shed_color => lambda { |c| c.color },
      :barn => "locked",
      :genre => Proc.new { |c| "#{c.metal} metal"}
    }
  end

  describe "#[]" do

    it "returns regular values for keys" do
      Kitchen::LazyHash.new(hash, context)[:barn].must_equal "locked"
    end

    it "invokes call on values that are lambdas" do
      Kitchen::LazyHash.new(hash, context)[:shed_color].must_equal "blue"
    end

    it "invokes call on values that are Procs" do
      Kitchen::LazyHash.new(hash, context)[:genre].must_equal "heavy metal"
    end
  end

  describe "#to_hash" do

    it "invokes any callable values and returns a Hash object" do
      converted = Kitchen::LazyHash.new(hash, context).to_hash

      converted.must_be_instance_of Hash
      converted.fetch(:shed_color).must_equal "blue"
      converted.fetch(:barn).must_equal "locked"
      converted.fetch(:genre).must_equal "heavy metal"
    end
  end
end
