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

## A Basic Usage Example for CLE:

````ruby
#!/usr/bin/env ruby
require 'sakai-cle-test-api'

# create an instance of the SakaiCLE class, providing your test browser and the URL of
# The Sakai CLE welcome/login page...
sakai = SakaiCLE.new(:chrome, "https://cle-1.qa.rsmart.com/xsl-portal")

# Log in with your test user and password...
workspace = sakai.login("username", "password")
````

For much more extensive examples of using this API, please see the CLE Cucumber directory in this repo.

## Contribute

* Fork the project.
* Additional or bug-fixed Classes, Elements, or Methods should be demonstrated in accompanying tests. Pull requests with out test scripts that use the new code won't be accepted.
* Make sure you provide RDoc comments for any new public method or page class you add. Remember, others will be using this gem.
* Send me a pull request. Bonus points for topic branches.