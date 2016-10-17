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

    gem 'lydia'

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
Create a ruby file, for example hello_world.rb, require 'lydia' and using the routing functions without creating an application object.

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
        body = 'Hello world!'
        [200, { 'Content-Type' => 'text/html', 'Content-Length' => body.length.to_s }, [body]]
      end
    end

#### HTTP verbs
Supports standard HTTP verbs: HEAD GET PATCH PUT POST DELETE OPTIONS.

#### Query parameters

    # matches /querystring&name=mirko
    get '/querystring' do
      # do something
      # request.params[:name] contains 'mirko'
    end

#### Wildcard

    # matches /wildcard/everything
    get '/wildcard/* ' do
      # do something
    end

#### Named route parameters

    # matches /users/1/comments/3/edit
    get '/users/:id/comments/:comment_id' do
      # do something
      # request.params[:id] contains 1
      # request.params[:comment_id] contains 3
    end

Automatically add to response.params every route params.

#### Regular expressions

    # matches /regexp
    get %r{/regexp$}i do
      # do something
    end

#### Skip to next route
To skip to the next matching route use next_route method.

    get '/next_route' do
      next_route
    end

    get '/next_route' do
      'Hello this is the next route'
    end

#### Halting
To halt the execution raising an Halt error use halt method, by default the standard halt page is displayed but it's possible to pass a custom response as halt parameter.

    get '/halt' do
      halt
    end

    get '/custom_halt' do
      halt 'Custom halt'
    end

### Return types
Lydia supports various returns types other that the standard rack response object. The supported type are:

#### Rack::Response or Lydia::Response
Using the standard rack response the framework does nothing other than pass the response to rack. If response finish method was not called the framework will.

#### String
Returning a string is intended as the response body, the headers and a 200 status are automatically added.

#### Array of 2 or 3 elements
Returning an array of 2 elements means that the first is the status and the second the body.
Returning an array of 3 elements means that the first is the status, the second the headers, and the third the body.

#### Fixnum
Returning a fixnum is intended as the response code. Useful to return a response code without a body.

#### Hash
An hash is intended as a json, json content type is automatically added.

#### Object that responds to :each
Returning a generic object is admitted accorind rack specifications if responds to :each method.

### Filters

#### Before and after Filters
Before and after filters are available as in the following example:

    before do
      # do something
    end

    after do
      # do something
    end

#### Redirects
To define a redirect use the following syntax:

    redirect '/from_route', to: '/to_route'

### Templates

Extensive templates support using [tilt](https://github.com/rtomayko/tilt/)
To render a template simply use the render function:

    get '/render_erb' do
      render 'template.erb', nil, message: 'template'
    end

### Helpers

#### Redirect
It's possible to redirect the page using the redirect helper:

    get '/test' do
      redirect('/new_url')
    end

#### Params
It's possible to read request parameters using params helper:

    get '/test' do
      params['my_param']
    end

#### Content type
It's possible to force the response return type using content_type helper:

    get '/test'
      content_type 'application/json'
      'body'
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add your tests, run rspec and ensure that all tests pass and code coverage is 100%
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
