# Mine

## Introduction

A framework for visiting, and collecting data from, a series of web-pages.
The HTTP requests it makes are virtually indistinguishable from an regular
web browsing session. Also, it dramatically reduces the amount of code you
need to write to scrape a site.

It's designed to compile lists of things like products, services,
business details, events, reviews, images, etc..

I has, just about, every feature you may need when data mining.
Among other things, it is rerunnable, supports rotating proxy access,
is error tolerant (it retries unresponsive sites),
follows redirects &amp; keeps cookies by default,
logs activity extensively, does not need constant monitoring,
and has helpers to extract &amp; reformat data.

It can be be used as a library, (from the console, command-line, etc.),
but that isn't really what it's for.

## Basic Functions

Used as a framework, it supports two basic operations that automate
the collection of a series of related web pages.

* Follows a list of links that are expicitly given ahead of execution.

* Pages through a succesion of pages, (starting from a given base URL).
  It advances by searching for, and following, a link buried within the HTML.
  perhaps identified by having text like *Next Page*.

There are variations on how exactly each of these two are initiated,
extended and filtered.
But they are the two primary means of collection within this framework.

As they cycle through the pages, this facility writes the pages'
data to the local file system, where they are indexed for later
retrieval, at which time, snippets of data can be read.
It stores the raw (payload data) received from the site, alongside
details of the HTTP exchanges.

Although by no means mandatory, the usual workflow is to

* Retrieve the external data and store it locally,
* Extract sections of text from this locally stored data.

This avoids constantly hitting the site
when gradually building up data sets using, say, CSS selectors.

In most cases, you'll be extracting data from HTML,
so Nokigiri support is built in.
Though, you can use Regular Expressions - if you've the patience!
Having said that, they are useful in some cases.

If you're dealing with JSON, you'll have to parse it yourself.
But if you're receiving all your data as JSON, this facility may
not be that suitable.

## Features

Since page scraping is prone to failure - sooner rather than
later - error recovery is a necessity.

Failures occur for two main reasons:

* Because a particular site is unresponsive, e.g. it is simply down

* Because you're excluded e.g. making too many requests too quickly

To mitigate against the former, the retrieval is re-runnable, that is,
it will resume execution at the stage it was at when it last failed.

To mitigate against the latter, there is (almost transparent) support
for rotating proxy access. As it runs, it obtains fresh IP addresses
from a number of (free) proxy providers - currently there are three.

Also, you can specify the number of requests
you want the proxy to be used for.
Once the limit's exceeded, that particular IP address is discarded,
and a new one is fetched from another provider.

> Proxy servers trick the host into thinking
> that your requests come from elsewhere.

In the event of a failure, it will recover from an exception,
and will re-attempt the very last request.

But the likelihood is that if it bridles once, it'll do so again.
In this case, it can be configured to remove the offending URL from
the working list and carry on with the rest.

You can configure the number of times failures must occur before
it grinds to a complete halt. There are several parameters that let
you fine-tune this behaviour.

> Be aware that page scraping is a game of *cat and mouse*.
> Most sites with useful data are able to detect suspicious activity,
> in which case they'll decline your request.
> They do this in many ways (404, 403 Forbidden, multiple redirects etc.),
> making it difficult to impossible to fathom out why you're being blocked.
> Sometimes you should just surrender early, and avoid fighting a losing battle.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mine' #, path: '../path/to/mine'
```

And then execute:

    $ bundle

Or use it from within the gem itself.

## Creating a scraping application

Scraping with this facility is easier done than said!

One way is to create an application under the module:
Mine::Apps::{MyApp} and write a class called *Runner*, that inherits
from the supplied class: *Mine::App::RunnerBase*.

Another way is to run a Ruby script from the command line directly.
Unlike the preceding, the main class needs to
inherit from *Mine::App::RunnerBaseCL*.

The former is better for big jobs, the latter for quick results.

The main classes for retrieving external data (web-pages) are:

* Mine::App::FollowerTask
* Mine::App::PagerTask
* Mine::App::ReducerTask

The main extraction classes are:

* Mine::App::ExtractTask
* Mine::App::SearchTask

There is also a separate data directory that will be set up.
By default it's *tmp/mine-ds/apps/{myapp}/*,
though this location can be easily changed.

This directory tree is used as a working areas for storing
the retrieved, and extracted, data.
You usually access these files through the API.
You can put config files under this directory tree,
but they're better put under *config/{app_name}/*.

It'd take a book chapter, or two, to explain all of the the *ins and outs*.
So for now, I'm afraid you'll have to dig into the source code
to find your way round.

Also, the code's still a bit experimental,
though, so far, it has proved resilient.
The core objects are tested well, but,
the testing of the higher level objects is not fully comprehensive.

> Setting up an environment for HTTP testing,
> with a proxy server &amp; provider,
> external website stubs, simulating 404's, timeouts, etc.,
> is just too much for now!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub
at https://github.com/srycyk/mine.

If you have any queries, please mail me at stephen.rycyk@gmail.com

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

