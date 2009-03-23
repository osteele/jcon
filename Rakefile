require 'rubygems'
require 'spec/rake/spectask'

task :test => :spec

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = 'jcon'
    s.rubyforge_project = 'jcon'
    s.summary       = "Test JSON values against a schema."
    s.homepage       = 'http://jcon.rubyforge.org'
    s.description    = <<-EOF
    Test JSON values for conformance with ECMAScript 4.0 types.
  EOF
    s.author         = 'Oliver Steele'
    s.email          = 'steele@osteele.com'
    s.rdoc_options <<
      '--title' << "JCON: #{s.summary.sub(/.$/,'')}" <<
      '--main' << 'README' <<
      '--exclude' << 'spec/.*'
    s.extra_rdoc_files = ['README.rdoc', 'TODO', 'LICENSE']
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

desc "Run all specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/*_spec.rb']
  if ENV['RCOV']
    t.rcov = true
    t.rcov_opts = ['--exclude', 'spec\/spec']
  end
end
