# Attender

Attend consul cluster and notification with changing consul index.

## Installation

Add this line to your application's Gemfile:

    gem 'attender'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install attender

## Usage
setup test environment (https://github.com/foostan/enforcer#build-test-environment)
```
> bundle exec attender 192.168.33.101
- server-01 service:apache2 # stop apache2 in server-01
- server-01 service:ntp     # stop ntp in server-01
+ server-01 service:apache2 # start apache2 in server-01
+ server-01 service:ntp     # start ntp in server-01
- client-01 serfHealth      # host down client-01
+ client
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/attender/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
