# -*- encoding: utf-8 -*-
# stub: mixlib-shellout 1.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "mixlib-shellout"
  s.version = "1.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Opscode"]
  s.date = "2014-04-08"
  s.description = "Run external commands on Unix or Windows"
  s.email = "info@opscode.com"
  s.extra_rdoc_files = ["README.md", "LICENSE"]
  s.files = ["LICENSE", "README.md"]
  s.homepage = "http://wiki.opscode.com/"
  s.rubygems_version = "2.2.2"
  s.summary = "Run external commands on Unix or Windows"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.0"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.0"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.0"])
  end
end
