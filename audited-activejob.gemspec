$:.push File.expand_path("../lib", __FILE__)
require "audited/active_job/version"

Gem::Specification.new do |s|
  s.name        = "audited-activejob"
  s.version     = Audited::ActiveJob::VERSION
  s.summary     = "Pass a user through to your active_jobs and associate it with any generated audits"
  s.description = "Pass a user through to your active_jobs and associate it with any generated audits"
  s.authors     = ["Mark Rebec"]
  s.email       = ["mark@markrebec.com"]
  s.homepage    = "http://github.com/markrebec/audited-activejob"

  s.files       = Dir["lib/**/*"]
  s.test_files  = Dir["spec/**/*"]

  s.add_dependency "activejob"
  s.add_dependency "audited"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
