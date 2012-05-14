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
sakai = SakaiOAE.new(:firefox, "https://academic.rsmart.com/")

# define the LoginPage class object, which allows you to interact with elements
# on the login page. This is available via the SakaiOAE class, "page" method...
login_page = sakai.page

# Define the browser object using SakaiOAE's 'browser' method. This is Ruby/Watir's
# representation of the test browser itself and is used by every page class in the
# Sakai-OAE-test-api, so it *must* be explicitly defined here as "@browser"...
@browser = sakai.browser

# The above code is all necessary for proper setup and usage of the API. Below, we
# present a short and simple example of how you can use the API to interact with
# the Open Academic Environment...
dash = login_page.login("username", "password")

# There are two ways to invoke page classes. The first way, hinted at in the code
# above, will be explained below. The second way uses the "on_page" method,
# and is most useful when you are going to stay on the given page for a while. It
# requires that you know the name of the relevant page class..
on_page MyDashboard do |page|
  page.add_content
  page.upload_file=("filename.doc", "Full/Path/To/File")
  page.file_title="Title"
  page.file_description="This is a file description."
  page.tags_and_categories="document"
  page.add
  page.done_add_collected
end

# So, back to the first way, which is most useful when you're doing lots of quick
# navigating around the site, not staying on a given page for too long.
# You'll notice by looking at the available methods in the page classes that those
# methods involving navigating to new pages will return the target page's page class.
# So, for example, going from My Dashboard to Explore Content (notice we're using
# the "dash" object defined earlier, here...
explore = dash.explore_content

# Now we can use the "explore" object to interact with the "Explore Content" page...
explore.search_for="Title"

# A bit of verification code (use your own favorite test framework, here, if
# writing Ruby conditionals isn't too your liking)...
if explore.results.include?("Title")
  puts "Passed"
else
  puts "Failed"

# Enjoy!
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

