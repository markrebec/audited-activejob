require 'rspec/core/rake_task'

task :environment do
  # noop
end

desc 'Run the specs'
RSpec::Core::RakeTask.new do |r|
  r.verbose = false
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r activejob-audited"
end

task :build do
  puts `gem build activejob-audited.gemspec`
end

task :push do
  require 'active_job/audited/version'
  puts `gem push activejob-audited-#{ActiveJob::Audited::VERSION}.gem`
end

task release: [:build, :push] do
  puts `rm -f activejob-audited*.gem`
end

task :default => :spec
