# Functional Automation testing for Kuali and Sakai

## Description:

Note: Currently this project is limited to Sakai. Kuali development is slated for the future.

This repository contains the following projects:

- APIs for the rSmart versions of Sakai's Open Academic Environment (OAE) and Collaborative Learning Environment (CLE)
- Cucumber features and step definitions for testing OAE and CLE

## APIs

The APIs are written in Ruby 1.9.2 using the Watir-webdriver and Page Object gems and can themselves be installed locally as Ruby gems with the command:

`gem install sakai-cle-test-api`

or

`gem install sakai-oae-test-api`

Installing the gems will also install all necessary dependencies.

## Cucumber projects

You are of course welcome to use the APIs on their own to write your own test scripts using whatever framework you prefer. However, if you're interested in getting a fast start and either learning the API by example or leveraging work we've already done, you're welcome to grab our Cucumber projects.

Obviously, at the moment the Cucumber projects are in their infancy. Our legacy test cases are available in the `tests` folder.

## Contribute

* Fork the project.
* Additional or bug-fixed Classes, Elements, or Methods should be demonstrated in accompanying tests. Pull requests that do not include test scripts that use the new code won't be accepted.
* Make sure you provide RDoc comments for any new public method or page class you add. Remember, others will be using this gem.
* Send me a pull request. Bonus points for topic branches.