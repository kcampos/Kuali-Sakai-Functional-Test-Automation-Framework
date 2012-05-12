# Functional Automation testing for Kuali and Sakai

## Description:

Note: Currently this project is limited to Sakai. Kuali development is slated for the future.

This repository contains the following projects:

- APIs for the rSmart versions of Sakai's Open Academic Environment (OAE) and Collaborative Learning Environment (CLE)
- Cucumber features and step definitions for testing OAE and CLE

## APIs

The APIs are written in Ruby 1.9.2 using the Watir-webdriver and Page Object gems and can themselves be installed locally as Ruby gems with the command:

gem install sakai-cle-test-api

or

gem install sakai-oae-test-api

## Cucumber projects

You are of course welcome to use the APIs on their own to write your own test scripts using whatever framework you prefer. However, if you're interested in getting a fast start and either learning the API by example or leveraging work we've already done, you're welcome to grab our Cucumber projects.

## Contribute

* Fork the project.
* Test drive your feature addition or bug fix. Adding specs is important and I will not accept a pull request that does not have tests.
* Make sure you describe your new feature with a cucumber scenario.
* Make sure you provide RDoc comments for any new public method you add. Remember, others will be using this gem.
* Commit, do not mess with Rakefile, version, or ChangeLog.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.