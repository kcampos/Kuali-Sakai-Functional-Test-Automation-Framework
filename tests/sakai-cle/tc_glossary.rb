# 
# == Synopsis
#
# This is the Sakai-CLE test case template file. Use it as the starting
# point for a new test case.
#
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
require "test/unit"
require 'sakai-cle-test-api'
require 'yaml'

class TestGlossary < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    config = AutoConfig.new
    @browser = config.browser
    # This is an admin user test case
    @user_name = config.directory['admin']['username']
    @password = config.directory['admin']['password']
    
    # Test case variables
    @portfolio_site = "PortfolioAdmin"
    @glossary_file1 = "documents/test_glossary_terms1.xml"
    @glossary_file2 = "documents/test_glossary_terms2.xml"
    @terms = [
      "Associate",
      "Association",
      "Arbitration",
      "Breach of Contract",
      "Marketing Communications",
      "Goal"
    ]
    @short_description = "A goal to reach for"
    @description = "An objective that may be related to activities that a student is expected to perform. A goal may contain zero or more subgoals."
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_glossary
    
    # Log in to Sakai
    workspace = @sakai.page.login(@user_name, @password)
    
    # Go to test site
    home = workspace.open_my_site_by_name @portfolio_site
    
    # Go to glossary page
    glossary = home.glossary

    # Import a file
    import = glossary.import
    
    attach = import.select_file
    
    upload = attach.upload_file_to_folder @portfolio_site
    upload.file_to_upload=@glossary_file1

    attach = upload.upload_files_now

    import = attach.continue

    glossary = import.import

    # TEST CASE: Verify terms imported
    assert glossary.terms.include?(@terms[0])
    assert glossary.terms.include?(@terms[1])
    
    import = glossary.import
    
    attach = import.select_file
    
    upload = attach.upload_file_to_folder @portfolio_site
    upload.file_to_upload=@glossary_file2

    attach = upload.upload_files_now

    import = attach.continue

    glossary = import.import
    
    # TEST CASE: Verify original terms are present
    assert glossary.terms.include?(@terms[0])
    assert glossary.terms.include?(@terms[1])
    
    # TEST CASE: Verify additional terms imported
    assert glossary.terms.include?(@terms[2])
    assert glossary.terms.include?(@terms[3])
    assert glossary.terms.include?(@terms[4])
    
    add_term = glossary.add
    add_term.long_description=@description
    add_term.term=@terms[5]
    add_term.short_description=@short_description
    
    glossary = add_term.add_term
    
    #TEST CASE: Verify presence of all terms on page
    assert glossary.terms.include?(@terms[0])
    assert glossary.terms.include?(@terms[1])
    assert glossary.terms.include?(@terms[2])
    assert glossary.terms.include?(@terms[3])
    assert glossary.terms.include?(@terms[4])
    assert glossary.terms.include?(@terms[5])
    
    glossary.delete(@terms[5])
    
    # TEST CASE: Verify successful delete
    assert_equal false, glossary.terms.include?(@terms[5])
    
    # TEST CASE: Verify other terms are still present
    assert glossary.terms.include?(@terms[0])
    assert glossary.terms.include?(@terms[1])
    assert glossary.terms.include?(@terms[2])
    assert glossary.terms.include?(@terms[3])
    assert glossary.terms.include?(@terms[4])
    
  end
  
end
