# -*- encoding: utf-8 -*-
# stub: mixlib-authentication 1.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "mixlib-authentication"
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Opscode, Inc."]
  s.date = "2012-08-06"
  s.description = "Mixes in simple per-request authentication"
  s.email = "info@opscode.com"
  s.extra_rdoc_files = ["README.rdoc", "LICENSE", "NOTICE"]
  s.files = ["LICENSE", "NOTICE", "README.rdoc"]
  s.homepage = "http://www.opscode.com"
  s.rubygems_version = "2.2.2"
  s.summary = "Mixes in simple per-request authentication"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mixlib-log>, [">= 0"])
    else
      s.add_dependency(%q<mixlib-log>, [">= 0"])
    end
  else
    s.add_dependency(%q<mixlib-log>, [">= 0"])
  end
end
