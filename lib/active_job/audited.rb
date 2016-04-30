module ActiveJob
  module Audited
    def self.included(base)
      base.send :attr_reader, :current_user

      base.send :around_perform do |job, block|
        options = arguments.extract_options!
        @current_user = options.delete(:current_user)
        arguments << options unless options.empty?
        
        if current_user.nil?
          block.call
        else
          ::Audited.audit_class.as_user(current_user) do
            block.call
          end
        end
      end
    end
  end
end
