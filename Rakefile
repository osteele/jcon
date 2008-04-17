require 'rubygems'
require 'echoe'
require 'spec/rake/spectask'

PKG_VERSION = '0.1'

task :test => :spec

Echoe.new('jcon', PKG_VERSION) do |p|
  p.summary       = "Test JSON values against a schema."
  p.url           = 'http://jcon.rubyforge.org'
  p.description    = <<-EOF
    Test JSON values for conformance with ECMAScript 4.0 types.
  EOF
  p.author         = 'Oliver Steele'
  p.email          = 'steele@osteele.com'
  p.ignore_pattern = /^(.git|.*#.*#)$/
  p.test_pattern   = 'test/*_test.rb'
  p.rdoc_pattern   = /^(lib|bin|tasks|ext)|^README|^CHANGES|^TODO|^LICENSE$/
  p.eval = proc do |s|
    s.rdoc_options <<
      '--title' << "JCON: #{s.summary.sub(/.$/,'')}" <<
      '--main' << 'README' <<
      '--exclude' << 'spec/.*'
    s.extra_rdoc_files = ['README', 'TODO', 'LICENSE']
  end
end

desc "Really a replacement for echoe's 'install', which bombs on my machine"
task :reinstall => [:clean, :package, :uninstall] do
  system "sudo gem install pkg/*.gem"
end

desc "Run all specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/*_spec.rb']
  if ENV['RCOV']
    t.rcov = true
    t.rcov_opts = ['--exclude', 'spec\/spec']
  end
end
