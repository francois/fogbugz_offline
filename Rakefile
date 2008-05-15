require 'rubygems'
require 'rake/gempackagetask'

GEM = "fogbugz_offline"
VERSION = "0.0.1"
AUTHOR = "François Beausoleil"
EMAIL = "francois@teksol.info"
HOMEPAGE = "http://github.com/francois/fogbugz_offline/wikis"
SUMMARY = "Take FogBugz with you wherever you go!"

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  
  s.add_dependency "activesupport", "~> 2.0.2"
  s.add_dependency "main", "~> 2.8.0"
  s.add_dependency "open4", "~> 0.9.6"
  s.add_dependency "ferret", "~> 0.11.6"
  
  s.require_path = 'lib'
  s.autorequire = GEM
  s.files = %w(LICENSE README Rakefile TODO) + Dir.glob("{lib,specs}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{VERSION}}
end

require "spec/rake/spectask"
Spec::Rake::SpecTask.new do |t|
  t.warning = false
  t.rcov = false
  t.spec_opts = %w(--color --format specdoc --format html:tmp/specifications.html --loadby mtime --backtrace)
end

task :default => :spec
