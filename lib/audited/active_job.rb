module Audited
  module ActiveJob
    def self.included(base)
      base.send :attr_reader, :current_user

      base.send :around_perform do |_job, block|
        options = arguments.extract_options!
        @current_user = options.delete(:current_user)
        arguments << options unless options.empty?
        
        Audited.audit_class.as_user(current_user) do
          block.call
        end
      end
    end
  end
end
