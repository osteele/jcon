# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jcon}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Oliver Steele"]
  s.date = %q{2009-03-22}
  s.description = %q{Test JSON values for conformance with ECMAScript 4.0 types.}
  s.email = %q{steele@osteele.com}
  s.extra_rdoc_files = ["README.rdoc", "TODO", "LICENSE"]
  s.files = ["README.rdoc", "TODO", "LICENSE"]
  s.has_rdoc = true
  s.homepage = %q{http://jcon.rubyforge.org}
  s.rdoc_options = ["--title", "JCON: Test JSON values against a schema", "--main", "README", "--exclude", "spec/.*", "--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{jcon}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Test JSON values against a schema.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
