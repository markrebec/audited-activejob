# ActiveJob::Audited

[![Code Climate](https://codeclimate.com/github/markrebec/activejob-audited.png)](https://codeclimate.com/github/markrebec/activejob-audited)
[![Gem Version](https://badge.fury.io/rb/activejob-audited.png)](http://badge.fury.io/rb/activejob-audited)
[![Dependency Status](https://gemnasium.com/markrebec/activejob-audited.png)](https://gemnasium.com/markrebec/activejob-audited)

`ActiveJob::Audited` ties together [activejob](https://github.com/rails/activejob) and [audited](https://github.com/collectiveidea/audited) to allow passing an optional `current_user` through to your `ActiveJob` classes. It also wraps the execution of your `MyJob#perform` method with `Audited.audit_class.as_user`, which automatically associates any audits generated in your jobs to the `current_user` you pass through (usually the user who triggered the job, if there is one).

In cases where you do not pass a `current_user` argument to `MyJob.perform_now` or `MyJob.perform_later` (i.e. jobs queued up by automated processes) everything will behave as usual, and any generated audits will not have a user associated with them.

## Getting Started

Just add the gem to your `Gemfile` and run `bundle install`:

    gem 'activejob-audited'

## Usage

#### current_user

First, the gem provides a `current_user` method to any jobs that include the `ActiveJob::Audited` mixin, which you can use however you like within your jobs. You can populate this when queueing up your job by passing a `current_user: user` keyword argument. **Note: You do not need to modify your job's `MyJob#perform` method to accept this extra argument.**

```ruby
class MyJob < ActiveJob::Base
  include ActiveJob::Audited
  queue_as :default

  def perform
    Rails.logger.info "Executed MyJob for #{current_user.try(:email) || 'unknown'}"
  end
end

# without a user
MyJob.perform_later
# writes "Executed MyJob for unknown" to the rails log

# with a user
MyJob.perform_later current_user: User.find_by(email: 'mark@markrebec.com')
# writes "Executed MyJob for mark@markrebec.com" to the rails log

# if you're in a controller or some other context where you already have a current_user
# you'll probably just want to pass that through.
MyJob.perform_later current_user: current_user
```

#### Audits

Any job that includes the `ActiveJob::Audited` mixin will also have it's `MyJob#perform` method wrapped with `Audited.audit_class.as_user(current_user)` in an `around_perform` block. This ensures that any audits generated during your job execution will be associated with the provided user.

```ruby
class MyModel < ActiveRecord::Base
  audited

  # ...
end

class MyJob < ActiveJob::Base
  include ActiveJob::Audited
  queue_as :default

  def perform(my_model)
    my_model.update(foo: 'bar')
  end
end

# creates all audits without an associated user
MyJob.perform_later MyModel.find(1)

# associates all created audits with the provided user
MyJob.perform_later MyModel.find(1), current_user: User.find(1)
```

## Contributing
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
