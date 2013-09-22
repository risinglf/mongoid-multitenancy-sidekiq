[![Build Status](https://travis-ci.org/risinglf/mongoid-multitenancy-sidekiq.png?branch=master)](https://travis-ci.org/risinglf/mongoid-multitenancy-sidekiq)

# Mongoid::Multitenancy::Sidekiq

(Inspirated from Apartment::Sidekiq)

Support for Sidekiq with the Mongoid Multitenancy gem.

This gem takes care of storing the current tenant that a job is enqueued within.
It will then switch to that tenant for the duration of the job processing.

## Installation

Add this line to your application's Gemfile:

    gem 'mongoid-multitenancy-sidekiq'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid-multitenancy-sidekiq

## Usage

That's it. There's nothing to do. Each job that is queued will get an additional entry
storing `Tenant id` when it is queued. Then when the server pops it,
it will run job within an `Mongoid::Multitenancy.with_tenant(client_instance)` block.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
