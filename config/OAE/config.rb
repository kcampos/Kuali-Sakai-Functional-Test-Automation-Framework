require 'yaml'

# This class pulls data from the config.yml and directory.yml
# files. It makes that data available in the url, browser, and directory
# class variables.
# The initialization of the class also opens a new browser window, using
# the browser type specified in the config.yml file, and then navigates to
# the URL, also specified in the config.yml file.
class AutoConfig
  
  attr_reader :url, :browser, :directory
  
  def initialize
    
    config = YAML.load_file("#{File.dirname(__FILE__)}/config.yml")
    @directory = YAML.load_file("#{File.dirname(__FILE__)}/directory.yml")
    
    @web_browser  = config['server']['browser']
    @url          = config['server']['url']
    
    @browser = Watir::Browser.new @web_browser
    case(@web_browser)
    when :firefox
      @browser.window.resize_to(1400,900)
    end
    @browser.goto @url
    @browser.button(:id=>"footer_logo_button").wait_until_present
    
  end
  
end