require 'spec_helper'

RSpec.describe Audited::ActiveJob do
  subject { TestJob.new }

  context 'when an audit_user argument is passed to the job' do
    let(:user) { {email: 'mark@markrebec.com'} }

    it 'extracts the audit_user keyword argument' do
      subject.arguments << {audit_user: user}
      subject.extract_audit_user!

      expect(subject.audit_user).to eq(user)
    end

    it 'passes other keyword arguments through' do
      subject.arguments << {audit_user: user, foo: 'bar'}
      subject.extract_audit_user!

      expect(subject.arguments.last).to eq({foo: 'bar'})
    end
  end

  context 'when an audit_user argument is not passed to the job' do
    it 'sets the audit_user to nil' do
      subject.extract_audit_user!

      expect(subject.audit_user).to eq(nil)
    end

    it 'passes all keyword arguments through' do
      subject.arguments << {foo: 'bar'}
      subject.extract_audit_user!

      expect(subject.arguments.last).to eq({foo: 'bar'})
    end
  end

  describe 'around_perform' do
    it 'calls extract_audit_user!' do
      expect_any_instance_of(TestJob).to receive(:extract_audit_user!)
      TestJob.perform_now
    end

    it 'calls Audited.audit_class.as_user with the audit_user' do
      expect(Audited.audit_class).to receive(:as_user).with(nil)
      TestJob.perform_now
    end
  end
end
