# -*- encoding: utf-8 -*-
# stub: celluloid-io 0.16.0.pre2 ruby lib

Gem::Specification.new do |s|
  s.name = "celluloid-io"
  s.version = "0.16.0.pre2"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Tony Arcieri"]
  s.date = "2014-06-23"
  s.description = "Evented IO for Celluloid actors"
  s.email = ["tony.arcieri@gmail.com"]
  s.homepage = "http://github.com/celluloid/celluloid-io"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Celluloid::IO allows you to monitor multiple IO objects within a Celluloid actor"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<celluloid>, [">= 0.16.0.pre"])
      s.add_runtime_dependency(%q<nio4r>, [">= 1.0.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<benchmark_suite>, [">= 0"])
      s.add_development_dependency(%q<guard-rspec>, [">= 0"])
      s.add_development_dependency(%q<rb-fsevent>, ["~> 0.9.1"])
    else
      s.add_dependency(%q<celluloid>, [">= 0.16.0.pre"])
      s.add_dependency(%q<nio4r>, [">= 1.0.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<benchmark_suite>, [">= 0"])
      s.add_dependency(%q<guard-rspec>, [">= 0"])
      s.add_dependency(%q<rb-fsevent>, ["~> 0.9.1"])
    end
  else
    s.add_dependency(%q<celluloid>, [">= 0.16.0.pre"])
    s.add_dependency(%q<nio4r>, [">= 1.0.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<benchmark_suite>, [">= 0"])
    s.add_dependency(%q<guard-rspec>, [">= 0"])
    s.add_dependency(%q<rb-fsevent>, ["~> 0.9.1"])
  end
end
