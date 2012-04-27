# Functional test framework for the Kuali and Sakai products

## Description:

Note: Currently this project is limited to Sakai. Kuali development is slated for the future.

Provides a framework for interacting with web sites for Sakai-CLE and Sakai-OAE, using
Ruby and Watir-webdriver--but without needing to know either in detail.

## Requirements:

### Ruby 1.9.2 or higher

### Ruby Gems:
[Watir-Webdriver](http://www.watirwebdriver.com)  
[Page-Object](https://github.com/cheezy/page-object)
    
    
Note that Test-Unit and ci_reporter are required if you're going to be using any of the CLE
test case scripts written by rSmart. For OAE, Rspec is required. If you will be writing
your own test scripts, then feel free to use any test framework gem you prefer.

## A Basic Usage Example for OAE:

````ruby
#!/usr/bin/env ruby
require "watir-webdriver"
require "page-object"
require '../../features/support/env.rb'  # The exact content of these lines will
require '../../lib/sakai-oae'            # depend on the location of your test script
                                         # and the content of Ruby's $LOAD_PATH.

# Create an instance of the AutoConfig class.
# This creates a browser instance, among other things.
# See the RDocs for the AutoConfig class, for more detail
@config = AutoConfig.new

# Create a class instance variable for the AutoConfig's browser variable.
# (highly recommended that you use "@browser" as the variable name)
@browser = @config.browser

# Create an instance of the SakaiOAE class, passing it the @browser object...
@sakai = SakaiOAE.new @browser

# Log in to Sakai OAE with "username" and "password"...
dashboard = @sakai.login("username", "password") # See the SakaiOAE class in the RDocs.

# Go to the course library page for "Econ 101"...
course_library = dashboard.open_course "Econ 101"   # See the RDocs for info on the
                                                    # MyDashboard and Library classes.
                                                    
# Store the contents of the course library in
# an array called "library_contents"...
library_contents = course_library.documents
````

## Contribute

* Fork the project.
* Test drive your feature addition or bug fix. Adding specs is important and I will not accept a pull request that does not have tests.
* Make sure you describe your new feature with a cucumber scenario.
* Make sure you provide RDoc comments for any new public method you add. Remember, others will be using this gem.
* Commit, do not mess with Rakefile, version, or ChangeLog.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.