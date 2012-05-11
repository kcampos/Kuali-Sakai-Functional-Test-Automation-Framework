require 'kuali-sakai-common-lib'
require 'watir-webdriver'
require 'page-object'
require 'cgi'

# Initialize this class at the start of your test cases to
# open the specified test browser at the specified Sakai welcome page URL.
#
# The initialization will return the LoginPage class object as well as
# create the @browser variable used throughout the page classes.
class SakaiCLE
  
  attr_reader :url, :browser
  
  def initialize(web_browser, url)

    @url = url
    @browser = Watir::Browser.new web_browser
    @browser.window.resize_to(1400,900)
    @browser.goto @url
    @browser.button(:id=>"footer_logo_button").wait_until_present

    $frame_index = 0 # TODO - Need to remove this and all dependent code.

    Login.new @browser
  end

end
