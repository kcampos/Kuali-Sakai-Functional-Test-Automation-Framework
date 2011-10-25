# 
# == Synopsis
#
# 
# 
# Author: Abe Heward (aheward@rSmart.com)

gems = ["test/unit", "watir-webdriver"]
gems.each { |gem| require gem }
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/page_elements.rb", "/../../lib/sakai-CLE/app_functions.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestBuildPortfolioTemplate < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # This test case uses the logins of several users
    @instructor = @config.directory['person3']['id']
    @ipassword = @config.directory['person3']['password']
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_build_portfolio_template
    
    # some code to simplify writing steps in this test case
    def frm
      @browser.frame(:index=>$frame_index)
    end
    
    # Log in to Sakai
    workspace = @sakai.login(@instructor, @ipassword)
    
    resources = workspace.resources
    
    create_folder = resources.create_subfolders_in "My Workspace"
    create_folder.folder_name="data"
    
    resources = create_folder.create_folders_now
    
    upload_files = resources.upload_files_to_folder "data"
    
    files = [
      "documents/evaluation.xsd",
      "documents/feedback.xsd",
      "documents/genEducation.xsd",
      "documents/reflection.xsd"
    ]

    files.each do |file|
      upload_files.file_to_upload=file
     upload_files.add_another_file
    end
    
    resources = upload_files.upload_files_now
    
    home = resources.open_my_site_by_id(@site_id)
    
    forms = home.forms
    # 
    @selenium.click "link=Forms"
    # 
    @selenium.click "link=Add"
    # 
    @selenium.click "link=Select Schema File"
    # 
    @selenium.click "//img[@alt='Show other sites']"
    # 
    @selenium.click "//h3[@title = 'My Workspace']/a[normalize-space(.) = 'My Workspace']/img"
    # 
    @selenium.click "//h4/a[normalize-space(.) = 'data']/img"
    # 
    @selenium.click "//td[normalize-space(.) = 'evaluation.xsd']/../td/div/a[contains(text(),'Select')]"
    # 
    @selenium.click "attachButton"
    # 
    @selenium.type "description-id", "Evaluation"
    @selenium.click "//td[@class='TB_Button_Text']"
    sleep 1
    @selenium.type "//textarea[@class='SourceField']", "Use the Display Name to identify the purpose of your evaluation."
    @selenium.click "//td[@class='TB_Button_Text']"
    @selenium.click "//input[@name='action']"
    # 
    @selenium.click "link=Add"
    # 
    @selenium.click "link=Select Schema File"
    # 
    @selenium.click "//img[@alt='Show other sites']"
    # 
    @selenium.click "//h3[@title = 'My Workspace']/a[normalize-space(.) = 'My Workspace']/img"
    # 
    @selenium.click "//h4/a[normalize-space(.) = 'data']/img"
    # 
    @selenium.click "//td[normalize-space(.) = 'genEducation.xsd']/../td/div/a[contains(text(),'Select')]"
    # 
    @selenium.click "attachButton"
    # 
    @selenium.type "description-id", "General Education Evidence"
    @selenium.click "//td[@class='TB_Button_Text']"
    sleep 1
    @selenium.type "//textarea[@class='SourceField']", "Use the Display Name to identify the specific evidence associated with this cell that you will document with this instance of the General Education Evidence form. Use the other fields in this form to provide information about your evidence to assist the viewer in understanding its context, why you choose it, and your own evaluation of it."
    @selenium.click "//td[@class='TB_Button_Text']"
    @selenium.click "//input[@name='action']"
    # 
    @selenium.click "link=Add"
    # 
    @selenium.click "link=Select Schema File"
    # 
    @selenium.click "//img[@alt='Show other sites']"
    # 
    @selenium.click "//h3[@title = 'My Workspace']/a[normalize-space(.) = 'My Workspace']/img"
    # 
    @selenium.click "//h4/a[normalize-space(.) = 'data']/img"
    # 
    @selenium.click "//td[normalize-space(.) = 'feedback.xsd']/../td/div/a[contains(text(),'Select')]"
    # 
    @selenium.click "attachButton"
    # 
    @selenium.type "description-id", "Feedback for Matrix"
    @selenium.click "//td[@class='TB_Button_Text']"
    sleep 1
    @selenium.type "//textarea[@class='SourceField']", "Use the Display name to identify the purpose of your feedback."
    @selenium.click "//td[@class='TB_Button_Text']"
    @selenium.click "//input[@name='action']"
    # 
    @selenium.click "link=Add"
    # 
    @selenium.click "link=Select Schema File"
    # 
    @selenium.click "//img[@alt='Show other sites']"
    # 
    @selenium.click "//h3[@title = 'My Workspace']/a[normalize-space(.) = 'My Workspace']/img"
    # 
    @selenium.click "//h4/a[normalize-space(.) = 'data']/img"
    # 
    @selenium.click "//td[normalize-space(.) = 'reflection.xsd']/../td/div/a[contains(text(),'Select')]"
    # 
    @selenium.click "attachButton"
    # 
    @selenium.type "description-id", "Reflection for Matrix"
    @selenium.click "//td[@class='TB_Button_Text']"
    sleep 1
    @selenium.type "//textarea[@class='SourceField']", "Reflect upon the evidence you have added to this matrix cell by responding to the following questions."
    @selenium.click "//td[@class='TB_Button_Text']"
    @selenium.click "//input[@name='action']"
    # 
    @selenium.click "link=Logout"
    # 
    
  end
end
