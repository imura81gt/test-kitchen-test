# -*- encoding: utf-8 -*-
# stub: retryable 1.3.5 ruby lib

Gem::Specification.new do |s|
  s.name = "retryable"
  s.version = "1.3.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Nikita Fedyashev", "Carlo Zottmann", "Chu Yeow"]
  s.date = "2014-02-01"
  s.description = "Kernel#retryable, allow for retrying of code blocks."
  s.email = "loci.master@gmail.com"
  s.homepage = "http://github.com/nfedyashev/retryable"
  s.rubygems_version = "2.2.2"
  s.summary = "Kernel#retryable, allow for retrying of code blocks."

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.0"])
  end
end
