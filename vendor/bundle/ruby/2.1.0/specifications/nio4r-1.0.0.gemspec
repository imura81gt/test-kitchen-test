# -*- encoding: utf-8 -*-
# stub: nio4r 1.0.0 ruby lib
# stub: ext/nio4r/extconf.rb

Gem::Specification.new do |s|
  s.name = "nio4r"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Tony Arcieri"]
  s.date = "2014-01-15"
  s.description = "New IO for Ruby"
  s.email = ["tony.arcieri@gmail.com"]
  s.extensions = ["ext/nio4r/extconf.rb"]
  s.files = ["ext/nio4r/extconf.rb"]
  s.homepage = "https://github.com/celluloid/nio4r"
  s.rubygems_version = "2.2.2"
  s.summary = "NIO provides a high performance selector API for monitoring IO objects"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake-compiler>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<rake-compiler>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake-compiler>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
