require 'spec_helper'

describe Berkshelf::Resolver::Graph, :not_supported_on_windows do
  subject { described_class.new }

  describe "#populate" do
    let(:sources) { Berkshelf::Source.new("http://localhost:26210") }

    before do
      berks_dependency("ruby", "1.0.0", dependencies: { "elixir" => ">= 0.1.0" })
      berks_dependency("ruby", "2.0.0")
      berks_dependency("elixir", "1.0.0")
    end

    it "adds each dependency to the graph" do
      subject.populate(sources)
      expect(subject.artifacts).to have(3).items
    end

    it "adds the dependencies of each dependency to the graph" do
      subject.populate(sources)
      expect(subject.artifact("ruby", "1.0.0").dependencies).to have(1).item
    end
  end

  describe "#universe" do
    let(:sources) { Berkshelf::Source.new("http://localhost:26210") }

    before do
      berks_dependency("ruby", "1.0.0")
      berks_dependency("elixir", "1.0.0")
    end

    it "returns an array of APIClient::RemoteCookbook" do
      result = subject.universe(sources)
      expect(result).to be_a(Array)
      result.each { |remote| expect(remote).to be_a(Berkshelf::APIClient::RemoteCookbook) }
    end

    it "contains the entire universe of dependencies" do
      expect(subject.universe(sources)).to have(2).items
    end
  end
end
