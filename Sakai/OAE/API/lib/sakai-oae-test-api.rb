require 'kuali-sakai-common-lib'
require 'cgi'

PageObject.javascript_framework = :jquery

require 'sakai-oae-test-api/gem_extensions'
require 'sakai-oae-test-api/global_methods'
require 'sakai-oae-test-api/pop_up_dialogs'
require 'sakai-oae-test-api/toolbars_and_menus'
require 'sakai-oae-test-api/widgets'
require 'sakai-oae-test-api/page_classes'
require 'sakai-oae-test-api/cle_assessments'
require 'sakai-oae-test-api/cle_assignments'
require 'sakai-oae-test-api/cle_forums'
require 'sakai-oae-test-api/cle_gradebook2'

# Initialize this class at the start of your test cases to
# open the specified test browser at the specified Sakai welcome page URL.
#
# The initialization will return the LoginPage class object as well as
# create the @browser variable used throughout the page classes.
class SakaiOAE

  attr_reader :browser

  def initialize(web_browser, url)
    @browser = Watir::Browser.new web_browser
    @browser.window.resize_to(1400,900)
    @browser.goto url
    @browser.button(:id=>"footer_logo_button").wait_until_present
  end

  def page
    LoginPage.new @browser
  end

end