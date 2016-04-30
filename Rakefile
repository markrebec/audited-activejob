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
  sh "irb -rubygems -I lib -r audited-activejob"
end

task :build do
  puts `gem build audited-activejob.gemspec`
end

task :push do
  require 'active_job/audited/version'
  puts `gem push audited-activejob-#{Audited::ActiveJob::VERSION}.gem`
end

task release: [:build, :push] do
  puts `rm -f audited-activejob*.gem`
end

task :default => :spec
