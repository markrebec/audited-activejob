class TestJob < ActiveJob::Base
  include Audited::ActiveJob
  queue_as :default

  def perform
  end
end
