# Mine

## Introduction

A framework for visiting, and collecting data from, a series of web-pages.
The HTTP requests it makes are virtually indistinguishable from a regular
web browsing session. Also, it dramatically reduces the amount of code you
need to write to scrape a site, and has an OO API throughout.

It's designed to compile lists of things like products, services,
business details, events, reviews, images, etc..

It has, just about, every feature you may need for data mining.
Among other things, it is rerunnable, supports rotating proxy access,
is error tolerant (it retries unresponsive sites),
follows redirects, keeps cookies by default,
logs activity extensively, does not need constant monitoring,
has templates for building URL lists,
and has helpers to extract &amp; reformat data.

It can be be used as a library, (from the console, command-line, etc.),
but it's more useful for performing a succession of web page retrievals.

## Basic Functions

It supports two basic operations that automate the collection of
a number of related web pages.

* Follows a list of links that are expicitly given ahead of execution.

* Traverses through a set of (numbered) pages, (starting from a base URL).
  It advances by searching for, and following, a link buried within the HTML.
  Perhaps identified by having associated text like *Next Page*.

There are variations on how exactly each of these two are initiated,
extended and filtered.
But they are the two primary means of collection within this framework.

As the facility cycles through the fetched pages, it writes the retrieved
data to the local file system, where it's indexed it for scanning later on.
During the scanning phase, data items can be extracted
and built up into a series of records,
which are then, maybe, written to a CSV file.

The raw (payload data) received from a site in kept in one file,
alongside another file which gives details of the HTTP exchanges.

Although by no means mandatory, the usual workflow is to

* Retrieve the external data and store it locally,
* Extract sections of text from this locally stored data.

This avoids constantly hitting the same site
when gradually building up data sets using, say, CSS, or XPath, selectors.

In most cases, you'll be extracting data from HTML,
so Nokigiri support is built in.
But, if need be, you can also use Regular Expressions.

If you're dealing with JSON, you'll have to parse it yourself.
But if you're receiving all your data as JSON, this facility may
not be suitable.

## Features

Since page scraping is prone to failure - sooner rather than
later - error recovery is a necessity.

Failures occur for two main reasons:

* Because a particular site is unresponsive, e.g. it is simply down

* Because you're excluded e.g. have made too many requests too quickly

To mitigate against the former, a retrieval operation can be instructed
to retry in the event of a failure.

To mitigate against the latter, there is (almost transparent) support
for rotating proxy access. As it runs, it obtains fresh IP addresses
from a number of (free) proxy providers - currently there are three.

You can specify the number of requests you want a proxy to be used for.
Once this limit's exceeded, the current proxy address is discarded,
and a new one is fetched from the next available proxy provider.

> Proxy servers trick the host into thinking
> that your requests come from elsewhere.

If a failure occurs, it will recover from an exception,
and re-attempt the request, but this won't go on indefinitely.

The likelihood is that if it fails once, it'll do the same again.
So if the fetching of a particular page is not necessary,
the framework can be configured to remove the offending URL from
the working list and carry on with the rest.

You can specify the number of times that failures must occur before
it will grind to a complete halt. There are several parameters that let
you specify this sort of behaviour.

> Be aware that page scraping is a game of *cat and mouse*.
> Most sites with useful data are able to detect suspicious activity,
> in which case they'll decline your request.
> They do this in many ways (404, 403 Forbidden, multiple redirects etc.),
> making it difficult to impossible to fathom out why you're being blocked.
> for some sites, you should just surrender early, and avoid a long battle.

## Installation

Download the source:

    $ git fetch https://github.com/srycyk/mine

Add this line to your application's Gemfile:

```ruby
gem 'mine', path: './path/to/mine'
```

And then execute:

    $ bundle

Alternatively, you can use it from within the gem's working directory,
or, from this same directory, create your own copy of the gem file:

    $ rake build

## Creating a scraping application

Scraping with this facility is easier done than said!

One way is to create an application (or gem) under the module:
Mine::Apps::{MyApp} and write a class called *Runner*, that inherits
from the supplied class: *Mine::App::RunnerBase*.

Another way is to run a Ruby script from the command line directly.
In this case the main class needs to inherit from *Mine::App::RunnerBaseCL*.

The former is better for larger jobs, the latter for quick results.

The main classes for retrieving external data (web-pages) are:

* Mine::App::FollowerTask
* Mine::App::PagerTask
* Mine::App::ReducerTask

The main extraction classes are:

* Mine::App::ExtractTask
* Mine::App::SearchTask

There is a data directory that will be set up,
under the working directory's root.
By default it's *./tmp/mine-ds/apps/{myapp}/*,
though this location can be easily changed.

This directory tree is used for storing the retrieved, and extracted, data.
You usually access these files through the API, e.g. *Mine::Storage::List*.

You can put config files under this directory tree,
but they're more convenient if put under *./config/{app_name}/*.

It'd take a book chapter, or two, to explain all of the the *ins and outs*.
So for now, you'll just have to dig into the source code
if you want to find your way around.

The code has, so far, it has proved resilient, and has made hundreds
of consecutive requests on several sites that take measures to ban bots.

The core objects are tested in the suites, but,
the testing of the higher level objects is not fully comprehensive.

> Setting up an environment for thorough HTTP testing,
> with a proxy server &amp; provider,
> external website stubs, simulating 404's, timeouts, etc.,
> is far too much effort!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub
at https://github.com/srycyk/mine.

If you have any queries, please mail me at stephen.rycyk@gmail.com

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

