$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))
#$: << File.expand_path(File.dirname(__FILE__) + "/../../lib/")

require 'rspec'
require 'watir-webdriver'
require 'page-object'
PageObject.javascript_framework = :jquery
require  '../../config/OAE/config.rb'
require 'utilities'
require 'sakai-OAE/app_functions'
require 'sakai-OAE/page_elements'
require 'cgi'