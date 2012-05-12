# Sakai CLE Functional Testing API

## Description:

This is the development project for the Sakai CLE Functional Testing API gem for Ruby.

This API provides a framework for interacting with web sites for Sakai-OAE, using
Ruby and Watir-webdriver--but without needing to know either in detail.

## Requirements:

### Ruby 1.9.2 or higher

### Ruby Gems:
[Watir-Webdriver](http://www.watirwebdriver.com)
[Page-Object](https://github.com/cheezy/page-object)

If you're just going to use the API for testing, then simply install it as you would any other Ruby gem: `gem install sakai-cle-test-api`

This repo is here if you're going to take part in extending the capabilities of the gem.

## A Basic Usage Example for OAE:

````ruby
#!/usr/bin/env ruby
require 'sakai-cle-test-api'

# Stuff goes here!!!
````

## Contribute

* Fork the project.
* Test drive your feature addition or bug fix. Adding specs is important and I will not accept a pull request that does not have tests.
* Make sure you describe your new feature with a cucumber scenario.
* Make sure you provide RDoc comments for any new public method you add. Remember, others will be using this gem.
* Commit, do not mess with Rakefile, version, or ChangeLog.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.