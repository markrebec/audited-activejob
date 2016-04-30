$:.push File.expand_path("../lib", __FILE__)
require "active_job/audited/version"

Gem::Specification.new do |s|
  s.name        = "activejob-audited"
  s.version     = ActiveJob::Audited::VERSION
  s.summary     = "Pass a current_user through to your active_jobs and use it in any generated audits"
  s.description = "Pass a current_user through to your active_jobs and use it in any generated audits"
  s.authors     = ["Mark Rebec"]
  s.email       = ["mark@markrebec.com"]
  s.homepage    = "http://github.com/markrebec/activejob-audited"

  s.files       = Dir["lib/**/*"]
  s.test_files  = Dir["spec/**/*"]

  s.add_dependency "activejob"
  s.add_dependency "audited"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
