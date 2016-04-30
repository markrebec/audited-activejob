class AuditModel
  def self.as_user(user)
    # noop
  end
end
Audited.audit_class = AuditModel
