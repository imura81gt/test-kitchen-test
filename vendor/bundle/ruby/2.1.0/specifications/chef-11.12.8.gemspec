# -*- encoding: utf-8 -*-
# stub: chef 11.12.8 ruby lib

Gem::Specification.new do |s|
  s.name = "chef"
  s.version = "11.12.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Adam Jacob"]
  s.date = "2014-06-06"
  s.description = "A systems integration framework, built to bring the benefits of configuration management to your entire infrastructure."
  s.email = "adam@opscode.com"
  s.executables = ["chef-client", "chef-solo", "knife", "chef-shell", "shef", "chef-apply", "chef-service-manager"]
  s.extra_rdoc_files = ["README.md", "CONTRIBUTING.md", "LICENSE"]
  s.files = ["CONTRIBUTING.md", "LICENSE", "README.md", "bin/chef-apply", "bin/chef-client", "bin/chef-service-manager", "bin/chef-shell", "bin/chef-solo", "bin/knife", "bin/shef"]
  s.homepage = "http://wiki.opscode.com/display/chef"
  s.rubygems_version = "2.2.2"
  s.summary = "A systems integration framework, built to bring the benefits of configuration management to your entire infrastructure."

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mixlib-config>, ["~> 2.0"])
      s.add_runtime_dependency(%q<mixlib-cli>, ["~> 1.4"])
      s.add_runtime_dependency(%q<mixlib-log>, ["~> 1.3"])
      s.add_runtime_dependency(%q<mixlib-authentication>, ["~> 1.3"])
      s.add_runtime_dependency(%q<mixlib-shellout>, ["~> 1.4"])
      s.add_runtime_dependency(%q<ohai>, ["~> 7.0.4"])
      s.add_runtime_dependency(%q<rest-client>, ["< 1.7.0", ">= 1.0.4"])
      s.add_runtime_dependency(%q<mime-types>, ["~> 1.16"])
      s.add_runtime_dependency(%q<json>, ["<= 1.8.1", ">= 1.4.4"])
      s.add_runtime_dependency(%q<yajl-ruby>, ["~> 1.1"])
      s.add_runtime_dependency(%q<net-ssh>, ["~> 2.6"])
      s.add_runtime_dependency(%q<net-ssh-multi>, ["~> 1.1"])
      s.add_runtime_dependency(%q<highline>, [">= 1.6.9", "~> 1.6"])
      s.add_runtime_dependency(%q<erubis>, ["~> 2.7"])
      s.add_runtime_dependency(%q<diff-lcs>, [">= 1.2.4", "~> 1.2"])
      s.add_runtime_dependency(%q<chef-zero>, ["< 2.1", ">= 2.0.2"])
      s.add_runtime_dependency(%q<pry>, ["~> 0.9"])
      s.add_development_dependency(%q<rake>, ["~> 10.1.0"])
      s.add_development_dependency(%q<rack>, [">= 0"])
      s.add_development_dependency(%q<rspec_junit_formatter>, [">= 0"])
      s.add_development_dependency(%q<rspec-core>, ["~> 2.14.0"])
      s.add_development_dependency(%q<rspec-expectations>, ["~> 2.14.0"])
      s.add_development_dependency(%q<rspec-mocks>, ["~> 2.14.0"])
    else
      s.add_dependency(%q<mixlib-config>, ["~> 2.0"])
      s.add_dependency(%q<mixlib-cli>, ["~> 1.4"])
      s.add_dependency(%q<mixlib-log>, ["~> 1.3"])
      s.add_dependency(%q<mixlib-authentication>, ["~> 1.3"])
      s.add_dependency(%q<mixlib-shellout>, ["~> 1.4"])
      s.add_dependency(%q<ohai>, ["~> 7.0.4"])
      s.add_dependency(%q<rest-client>, ["< 1.7.0", ">= 1.0.4"])
      s.add_dependency(%q<mime-types>, ["~> 1.16"])
      s.add_dependency(%q<json>, ["<= 1.8.1", ">= 1.4.4"])
      s.add_dependency(%q<yajl-ruby>, ["~> 1.1"])
      s.add_dependency(%q<net-ssh>, ["~> 2.6"])
      s.add_dependency(%q<net-ssh-multi>, ["~> 1.1"])
      s.add_dependency(%q<highline>, [">= 1.6.9", "~> 1.6"])
      s.add_dependency(%q<erubis>, ["~> 2.7"])
      s.add_dependency(%q<diff-lcs>, [">= 1.2.4", "~> 1.2"])
      s.add_dependency(%q<chef-zero>, ["< 2.1", ">= 2.0.2"])
      s.add_dependency(%q<pry>, ["~> 0.9"])
      s.add_dependency(%q<rake>, ["~> 10.1.0"])
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<rspec_junit_formatter>, [">= 0"])
      s.add_dependency(%q<rspec-core>, ["~> 2.14.0"])
      s.add_dependency(%q<rspec-expectations>, ["~> 2.14.0"])
      s.add_dependency(%q<rspec-mocks>, ["~> 2.14.0"])
    end
  else
    s.add_dependency(%q<mixlib-config>, ["~> 2.0"])
    s.add_dependency(%q<mixlib-cli>, ["~> 1.4"])
    s.add_dependency(%q<mixlib-log>, ["~> 1.3"])
    s.add_dependency(%q<mixlib-authentication>, ["~> 1.3"])
    s.add_dependency(%q<mixlib-shellout>, ["~> 1.4"])
    s.add_dependency(%q<ohai>, ["~> 7.0.4"])
    s.add_dependency(%q<rest-client>, ["< 1.7.0", ">= 1.0.4"])
    s.add_dependency(%q<mime-types>, ["~> 1.16"])
    s.add_dependency(%q<json>, ["<= 1.8.1", ">= 1.4.4"])
    s.add_dependency(%q<yajl-ruby>, ["~> 1.1"])
    s.add_dependency(%q<net-ssh>, ["~> 2.6"])
    s.add_dependency(%q<net-ssh-multi>, ["~> 1.1"])
    s.add_dependency(%q<highline>, [">= 1.6.9", "~> 1.6"])
    s.add_dependency(%q<erubis>, ["~> 2.7"])
    s.add_dependency(%q<diff-lcs>, [">= 1.2.4", "~> 1.2"])
    s.add_dependency(%q<chef-zero>, ["< 2.1", ">= 2.0.2"])
    s.add_dependency(%q<pry>, ["~> 0.9"])
    s.add_dependency(%q<rake>, ["~> 10.1.0"])
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<rspec_junit_formatter>, [">= 0"])
    s.add_dependency(%q<rspec-core>, ["~> 2.14.0"])
    s.add_dependency(%q<rspec-expectations>, ["~> 2.14.0"])
    s.add_dependency(%q<rspec-mocks>, ["~> 2.14.0"])
  end
end
