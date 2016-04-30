# Audited::ActiveJob

[![Build Status](https://travis-ci.org/markrebec/audited-activejob.png)](https://travis-ci.org/markrebec/audited-activejob)
[![Coverage Status](https://coveralls.io/repos/markrebec/audited-activejob/badge.svg?cache=1)](https://coveralls.io/r/markrebec/audited-activejob)
[![Code Climate](https://codeclimate.com/github/markrebec/audited-activejob.png)](https://codeclimate.com/github/markrebec/audited-activejob)
[![Gem Version](https://badge.fury.io/rb/audited-activejob.png)](http://badge.fury.io/rb/audited-activejob)
[![Dependency Status](https://gemnasium.com/markrebec/audited-activejob.png)](https://gemnasium.com/markrebec/audited-activejob)

`Audited::ActiveJob` ties together [activejob](https://github.com/rails/activejob) and [audited](https://github.com/collectiveidea/audited) to allow passing an optional `audit_user` through to your `ActiveJob` classes. It also wraps the execution of your `MyJob#perform` method with `Audited.audit_class.as_user`, which automatically associates any audits generated in your jobs to the `audit_user` you pass through (usually the user who triggered the job, if there is one).

In cases where you do not pass an `audit_user` argument to `MyJob.perform_now` or `MyJob.perform_later` (i.e. jobs queued up by automated processes) everything will behave as usual, and any generated audits will not have a user associated with them.

## Getting Started

Just add the gem to your `Gemfile` and run `bundle install`:

    gem 'audited-activejob'

## Usage

#### audit_user

First, the gem provides an `audit_user` method to any jobs that include the `Audited::ActiveJob` mixin, which you can use however you like within your jobs. You can populate this when queueing up your job by passing an `audit_user: user` keyword argument. **Note: You do not need to modify your job's `MyJob#perform` method to accept this extra argument.**

```ruby
class MyJob < ActiveJob::Base
  include Audited::ActiveJob
  queue_as :default

  def perform
    Rails.logger.info "Executed MyJob for #{audit_user.try(:email) || 'unknown'}"
  end
end

# without a user
MyJob.perform_later
# writes "Executed MyJob for unknown" to the rails log

# with a user
MyJob.perform_later audit_user: User.find_by(email: 'mark@markrebec.com')
# writes "Executed MyJob for mark@markrebec.com" to the rails log

# if you're in a controller or some other context where you already have a current_user
# you'll probably just want to pass that through.
MyJob.perform_later audit_user: current_user
```

#### Audits

Any job that includes the `Audited::ActiveJob` mixin will also have it's `MyJob#perform` method wrapped with `Audited.audit_class.as_user(audit_user)` in an `around_perform` block. This ensures that any audits generated during your job execution will be associated with the provided user.

```ruby
class MyModel < ActiveRecord::Base
  audited

  # ...
end

class MyJob < ActiveJob::Base
  include Audited::ActiveJob
  queue_as :default

  def perform(my_model)
    my_model.update(foo: 'bar')
  end
end

# creates all audits without an associated user
MyJob.perform_later MyModel.find(1)

# associates all created audits with the provided user
MyJob.perform_later MyModel.find(1), audit_user: User.find(1)
```

## ActiveJob::Users

`audited-activejob` has a loose/optional dependency on [`activejob-users`](https://github.com/markrebec/activejob-users), and if you're using both gems the `audit_user` method will fallback to your existing `job_user` arguments you're already using, so you don't have to make any changes and everything will just work.

```ruby
# associates all created audits with the provided user
MyJob.perform_later MyModel.find(1), job_user: current_user
```

## Contributing
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
