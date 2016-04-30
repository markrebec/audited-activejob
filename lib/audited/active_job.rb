module Audited
  module ActiveJob
    def self.included(base)
      base.send :include, ::ActiveJob::Users if defined?(::ActiveJob::Users)

      base.send :around_perform do |_job, block|
        extract_audit_user!

        Audited.audit_class.as_user(audit_user) do
          block.call
        end
      end

      def extract_audit_user!
        options = arguments.extract_options!
        @audit_user = options.delete(:audit_user)
        arguments << options unless options.empty?
      end

      def audit_user
        @audit_user || try(:job_user)
      end
    end
  end
end
