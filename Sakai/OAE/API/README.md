# Sakai OAE Functional Testing API

## Description:

This is the development project for the Sakai OAE Functional Testing API gem for Ruby.

This API provides a framework for interacting with web sites for Sakai-OAE, using
Ruby and Watir-webdriver--but without needing to know either in detail.

## Requirements:

### Ruby 1.9.2 or higher

### Ruby Gems:
[Watir-Webdriver](http://www.watirwebdriver.com)
[Page-Object](https://github.com/cheezy/page-object)

If you're just going to use the API for testing, then simply install it as you would any other Ruby gem: `gem install sakai-oae-test-api`

This repo is here if you're going to take part in extending the API's capabilities--e.g., adding page elements, custom methods, or new page classes.

## A Basic Usage Example for OAE:

````ruby
#!/usr/bin/env ruby
require 'sakai-oae-test-api'

# Create an instance of the SakaiOAE class, specifying your test browser
# and the URL of your test site's OAE welcome page.
sakai = SakaiOAE.new(:firefox, "https://nightly.academic.rsmart.com/")

# Log in to Sakai OAE with "username" and "password"...
dashboard = sakai.login("username", "password") # See the LoginPage class and the HeaderFooterBar module in the RDocs.

# Go to the course library page for "Econ 101"...
course_library = dashboard.open_course "Econ 101"   # See the RDocs for info on the
                                                    # MyDashboard and Library classes.

# Store the contents of the course library in
# an array called "library_contents"...
library_contents = course_library.documents
````

For much more extensive usage examples, please see the OAE Cucumber directory in this repo.

## Contribute

* Fork the project.
* Test drive your feature addition or bug fix. Adding specs is important and I will not accept a pull request that does not have tests.
* Make sure you describe your new feature with a cucumber scenario.
* Make sure you provide RDoc comments for any new public method you add. Remember, others will be using this gem.
* Commit, do not mess with Rakefile, version, or ChangeLog.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

