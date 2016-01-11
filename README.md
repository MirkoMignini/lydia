[![Build Status](https://travis-ci.org/MirkoMignini/lydia.svg)](https://travis-ci.org/MirkoMignini/lydia)
[![Coverage Status](https://coveralls.io/repos/MirkoMignini/lydia/badge.svg?branch=master&service=github)](https://coveralls.io/github/MirkoMignini/lydia?branch=master)
[![Code Climate](https://codeclimate.com/github/MirkoMignini/lydia/badges/gpa.svg)](https://codeclimate.com/github/MirkoMignini/lydia)
[![Gem Version](https://badge.fury.io/rb/lydia.svg)](https://badge.fury.io/rb/lydia)
[![Dependency Status](https://gemnasium.com/MirkoMignini/lydia.svg)](https://gemnasium.com/MirkoMignini/lydia)
[![security](https://hakiri.io/github/MirkoMignini/lydia/master.svg)](https://hakiri.io/github/MirkoMignini/lydia/master)

# Lydia

Lightweight, fast and easy to use small ruby web framework.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lydia'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lydia

## Another ruby web framework? WTF?

This project is not intended to become a top notch framework or the new rails, it's just an experiment. 
The goals of this project are:

* [Rack](https://github.com/rack/rack/) based.
* Modular (Router, Application...).
* A powerful router that works stand alone too.
* Easy templates support using [Tilt](https://github.com/rtomayko/tilt).
* Well written, easy to read and to understand code.
* Less lines of code as possible (but no [code golf](https://en.wikipedia.org/wiki/Code_golf)).
* [Don't repeat yourself](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself).
* [100% test code coverage](https://coveralls.io/github/MirkoMignini/lydia?branch=master).
* [Continuos integration](https://travis-ci.org/MirkoMignini/lydia).
* Highest codeclimate score and [0 issues](https://codeclimate.com/github/MirkoMignini/lydia/issues).

## Usage

### First example
Create a ruby file, fior example hello_world.rb, require 'lydia' and using the routing functions without creating an application object.

    require 'lydia'
    
    get '/' do
      'Hello world!'
    end

Just run it to start a webrick server that responds hello world to root.
    
    $ ruby hello_world.rb 

### Application
If preferred it's possible to create an application object and run using rackup command, in this case don't require lydia but lydia/application to avoid the server auto start. For example a minimal config.ru file can be:

    require 'lydia/application'
    
    class App < Lydia::Application
      get '/' do
        'Hello world!'
      end
    end
    
    run App.new
    
Start the server using rackup command:

    $ rackup
    
### Router

#### Stand alone router
If needed the router can be used stand alone, for example if best performances are needed, or used via the application class, slower but with a lot of more features.
Stand alone example, note that the return type must be in rack standard format, an array of three that is status, header, body (as array):

    require 'lydia/router'
    
    class App < Lydia::Router
      get '/' do
        body = 'Hellow world!' 
        [200, { 'Content-Type' => 'text/html', 'Content-Length' => body.length.to_s }, [body]]
      end
    end

#### HTTP verbs

#### Parameters

#### Wildcards

#### Named route parameters

#### Regular expressions

#### Not found routes and errors

#### Skip to next route

#### Halting

### Return types

### Filters

### Templates

### Helpers

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add your tests, run rspec and ensure that all tests pass and code coverage is 100%
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

