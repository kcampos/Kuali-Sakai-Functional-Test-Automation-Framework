require '../../config/OAE/config'
require 'sakai-OAE/page_classes'
require 'utilities'

# The class to instantiate at the start of most test cases. Provides
# methods for signing in and signing out of OAE
class SakaiOAE

  def initialize(browser)
    @browser = browser
  end

  # Logs in with the specified username and password variables.
  # Returns the MyDashboard class object.
  def login(username, password)
    @browser.div(:id=>"topnavigation_user_options_login_wrapper").fire_event("onmouseover")
    @browser.text_field(:id=>"topnavigation_user_options_login_fields_username").set username
    @browser.text_field(:name=>"topnav_login_password").set password
    @browser.button(:id=>"topnavigation_user_options_login_button_login").click
    sleep 3
    if @browser.button(:id=>"emailverify_continue_button").present?
      @browser.button(:id=>"emailverify_continue_button").click
    end
    @browser.wait_for_ajax(2)
    MyDashboard.new @browser
  end
  alias sign_in login
  alias log_in login

  # Signs out of OAE and returns the LoginPage class object.
  def sign_out
    @browser.link(:id=>"topnavigation_user_options_name").fire_event("onmouseover")
    @browser.link(:id=>"subnavigation_logout_link").click
    @browser.link(:text=>"Explore").wait_until_present
    @browser.wait_for_ajax(2)#.div(:text=>"Recent activity").wait_until_present
    LoginPage.new @browser
  end
  alias logout sign_out
  alias log_out sign_out

end
