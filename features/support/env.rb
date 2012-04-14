$:.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))
#$: << File.expand_path(File.dirname(__FILE__) + "/../../lib/")

require 'rspec'
require 'watir-webdriver'
require 'page-object'
require 'cgi'
PageObject.javascript_framework = :jquery
