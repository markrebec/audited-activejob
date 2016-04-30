module Audited
  module ActiveJob
    def self.included(base)
      base.send :attr_reader, :audit_user

      base.send :around_perform do |_job, block|
        options = arguments.extract_options!
        @audit_user = options.delete(:audit_user)
        arguments << options unless options.empty?
        
        Audited.audit_class.as_user(audit_user) do
          block.call
        end
      end
    end
  end
end
