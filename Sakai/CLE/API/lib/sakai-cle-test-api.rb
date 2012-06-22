require 'cgi'
require 'kuali-sakai-common-lib'
require 'sakai-cle-test-api/utilities'
require 'sakai-cle-test-api/tools_menu'
require 'sakai-cle-test-api/admin_page_elements'


# Initialize this class at the start of your test cases to
# open the specified test browser at the specified Sakai welcome page URL.
#
# The initialization will return the LoginPage class object as well as
# create the @browser variable used throughout the page classes
class SakaiCLE

  #include PageObject
  #include ToolsMenu

  attr_reader :browser

  def initialize(web_browser, url)
    @browser = Watir::Browser.new web_browser
    @browser.window.resize_to(1400,900)
    @browser.goto url
    $frame_index = 0 # TODO - Need to remove this and all dependent code.
  end

  # Returns the class containing the welcome page's page elements.
  def page
    Login.new @browser
  end

end
