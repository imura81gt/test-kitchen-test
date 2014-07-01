# -*- encoding: utf-8 -*-
# stub: solve 1.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "solve"
  s.version = "1.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jamie Winsor", "Andrew Garson", "Thibaud Guillaume-Gentil"]
  s.date = "2014-04-18"
  s.description = "A Ruby version constraint solver"
  s.email = ["jamie@vialstudios.com", "agarson@riotgames.com", "thibaud@thibaud.me"]
  s.homepage = "https://github.com/berkshelf/solve"
  s.licenses = ["Apache 2.0"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.1")
  s.rubygems_version = "2.2.2"
  s.summary = "A Ruby version constraint solver implementing Semantic Versioning 2.0.0-rc.1"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<semverse>, ["~> 1.1"])
      s.add_runtime_dependency(%q<dep_selector>, ["~> 1.0"])
    else
      s.add_dependency(%q<semverse>, ["~> 1.1"])
      s.add_dependency(%q<dep_selector>, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<semverse>, ["~> 1.1"])
    s.add_dependency(%q<dep_selector>, ["~> 1.0"])
  end
end
