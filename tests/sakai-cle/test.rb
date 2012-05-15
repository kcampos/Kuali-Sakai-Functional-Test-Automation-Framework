#
# == Synopsis
#
# 
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
require "test/unit"
require 'sakai-cle-test-api'
require 'yaml'

class TestBuildPortfolioTemplate < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SakaiCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser
    # This test case uses the logins of several users
    @instructor = @directory['person3']['id']
    @ipassword = @directory['person3']['password']
    @instructor_name = @directory['person3']['lastname'] + ", " + @directory['person3']['firstname']
    @instructor2 = @directory['person4']['id']
    @ipassword2 = @directory['person4']['password']
    @instructor2_name = @directory['person4']['lastname'] + ", " + @directory['person4']['firstname']
    @student = @directory["person1"]["id"]
    @spassword = @directory["person1"]["password"]
    @site_name = @directory['site1']['name']
    @site_id = @directory['site1']['id']
    
    # Test case variables
    @files = [
      "documents/evaluation.xsd",
      "documents/feedback.xsd",
      "documents/genEducation.xsd",
      "documents/reflection.xsd",
    ]
    @folder_name = "FFmf9"
    @portfolio_site = "Portofino"
    @schema = [ get_filename(@files[0]), get_filename(@files[1]), get_filename(@files[2]), get_filename(@files[3]) ]
    @form_names = ["Evaluation5bBQCtd4pv", "Feedback for MatrixdXFL4BwA2h", "General Education Evidence24wvwYczXu", "Reflection for MatrixcncbKRy5SC" ]
    @form_instructions = [
      "Use the Display Name to identify the purpose of your evaluation.",
      "Use the Display name to identify the purpose of your feedback.",
      "Use the Display Name to identify the specific evidence associated with this cell that you will document with this instance of the General Education Evidence form. Use the other fields in this form to provide information about your evidence to assist the viewer in understanding its context, why you choose it, and your own evaluation of it.",
      "Reflect upon the evidence you have added to this matrix cell by responding to the following questions."
    ]
    @style_file = "documents/wacky2.css"
    @style_filename = get_filename(@style_file)
    @style_name = "Wacky Style"
    @style_description = "Style for general use."
    @matrix_name = "General Education"
    @column_names = [
      "Level 1",
      "Level 2",
      "Level 3"
    ]
    @row_names = [
    "Written Communication",
    "Critical Thinking",
    "Information Retrieval and Technology",
    "Quantitative Reasoning",
    "Oral Communication",
    "Understanding Self and Community"
    ]
    @font_color = "#000001"
    @background_colors = [ "#B0E65A","#BDD676","#D3E195","#E3F29F","#F0FFA9","#ECFFD3"]
    @glossary_terms = [
      "Critical Thinking",
      "Information Retrieval and Technology",
      "Level 1",
      "Level 2",
      "Level 3",
      "Oral Communication",
      "Quantitative Reasoning",
      "Understanding Self and Community",
      "Written Communication"
    ]
    @glossary_short_descriptions = [
      "Critical thinking, an analytical and creative process, is essential to every content area and discipline. It is an integral part of information retrieval and technology, oral communication, quantitative reasoning, and written communication.",
      "Information retrieval and technology are integral parts of every content area and discipline.",
      "Contribute at least two examples of coursework from a completed, required foundation course, and define and discuss the relevance of your works to at least one of the standards that are listed in the glossary for this cell.",
      "Contribute at least two examples of coursework from two or more additional, completed courses, and define and discuss the relevance of your works to at least three of the standards that are listed in glossary for this cell.",
      "Contribute at least four works from your courses, and define and discuss the relevance of your works to all the standards that are listed in the glossary for this cell.",
      "Oral communication is an integral part of every content area and discipline.",
      "Quantitative reasoning can have applications in all content areas and disciplines.",
      "This institution emphasizes an understanding of one's self and one's relationship to the community, the region, and the world.",
      "Written communication is an integral part of every content area and discipline."
    ]
    @glossary_long_descriptions = [
      "Critical thinking, an analytical and creative process, is essential to every content area and discipline. It is an integral part of information retrieval and technology, oral communication, quantitative reasoning, and written communication. \n1. Identify and state problems, issues, arguments, and questions contained in a body of information. \n2. Identify and analyze assumptions and underlying points of view relating to an issue or problem. \n3. Formulate research questions that require descriptive and explanatory analyses. \n4. Recognize and understand multiple modes of inquiry, including investigative methods based on observation and analysis. \n5. Evaluate a problem, distinguishing between relevant and irrelevant facts, opinions, assumptions, issues, values, and biases through the use of appropriate evidence. \n6. Apply problem-solving techniques and skills, including the rules of logic and logical sequence.\n7. Synthesize information from various sources, drawing appropriate conclusions. \n8. Communicate clearly and concisely the methods and results of logical reasoning. \n9. Reflect upon and evaluate their thought processes, value systems, and world views in comparison to those of others.",
      "Information retrieval and technology are integral parts of every content area and discipline. \n1. Use print and electronic information technology ethically and responsibly. \n2. Demonstrate knowledge of basic vocabulary, concepts, and operations of information retrieval and technology. \n3. Recognize, identify, and define an information need. \n4. Access and retrieve information through print and electronic media, evaluating the accuracy and authenticity of that information. \n5. Create, manage, organize, and communicate information through electronic media. \n6. Recognize changing technologies and make informed choices about their appropriateness and use.",
      "Contribute at least two examples of coursework from a completed, required foundation course, and define and discuss the relevance of your works to at least one of the standards that are listed in the glossary for this cell.",
      "Contribute at least two examples of coursework from two or more additional, completed courses, and define and discuss the relevance of your works to at least three of the standards that are listed in glossary for this cell.",
      "Contribute at least four works from your courses, and define and discuss the relevance of your works to all the standards that are listed in the glossary for this cell.",
      "Oral communication is an integral part of every content area and discipline. \n1. Identify and analyze the audience and purpose of any intended communication. \n2. Gather, evaluate, select, and organize information for the communication. \n3. Use language, techniques, and strategies appropriate to the audience and occasion. \n4. Speak clearly and confidently, using the voice, volume, tone, and articulation appropriate to the audience and occasion. \n5. Summarize, analyze, and evaluate oral communications and ask coherent questions as needed.\n6. Use competent oral expression to initiate and sustain discussions.",
      "Quantitative reasoning can have applications in all content areas and disciplines. \n1. Apply numeric, graphic, and symbolic skills and other forms of quantitative reasoning accurately and appropriately. \n2. Demonstrate mastery of mathematical concepts, skills, and applications, using technology when appropriate. \n3. Communicate clearly and concisely the methods and results of quantitative problem solving.\n4. Formulate and test hypotheses using numerical experimentation. \n5. Define quantitative issues and problems, gather relevant information, analyze that information, and present results. \n6. Assess the validity of statistical conclusions.",
      "This institution emphasizes an understanding of one's self and one's relationship to the community, the region, and the world. \n1. Demonstrate an awareness of the relationship between the environment and one's own fundamental physiological and psychological processes. \n2. Examine critically and appreciate the values and beliefs of one's own culture and those of other cultures separated in time or space from one's own. \n3. Communicate effectively and acknowledge opposing viewpoints. \n4. Use the study of a second language as a window to cultural understanding. \n5. Demonstrate an understanding of ethical, civic and social issues relevant to Hawai'i's and the world's past, present and future.",
      "Written communication is an integral part of every content area and discipline. Use writing to discover and articulate ideas. \n1. Identify and analyze the audience and purpose for any intended communication. \n2. Choose language, style, and organization appropriate to particular purposes and audiences. \n3. Gather information and document sources appropriately. \n4. Express a main idea as a thesis, hypothesis, or other appropriate statement. \n5. Develop a main idea clearly and concisely with appropriate content. \n6. Demonstrate mastery of the conventions of writing, including grammar, spelling, and mechanics. \n7. Demonstrate proficiency in revision and editing. \n8. Develop a personal voice in written communication."
    ]
    @files_to_upload = ["images/banner.gif", "documents/GenEdscript.js", "documents/GenEdmatrixpres.xsl",
                       "documents/GenEdstyle.css", "zips/Contact Information (Site Two) Form.zip",
                       "zips/Portfolio Properties (Site Two) Form.zip" ]
    @form_zips = [
      get_filename(@files_to_upload[4]),
      get_filename(@files_to_upload[5])
    ]
    @formX_names = [ "Contact Information (#{@portfolio_site})", "Portfolio Properties (#{@portfolio_site})" ]
    @template_name = "General Education Matrix Template"
    @template_description = "Use this template to build a presentation of the works and reflections you have provided for a selected level of the General Education assessment matrix."
    @form_type = "Portfolio Properties"

    @content = [
      {:type=>"Matrix", :name=> "GenEdmatrix", :title=> "Matrix",:description=> "Select a matrix to build the presentation on."},
      {:type=>"Contact Information",:name=> "contactInformation",:title=> "Contact information",:description=> "Select the contact information to be displayed in the presentation."},
      {:type=>"Uploaded File",:name=> "introImg",:title=> "Introduction image",:description=> "Select an image to introduce your presentation on the Introduction page (optional)."},
      {:type=>"Uploaded File",:name=> "criterion1Img",:title=> "Written Communication image",:description=> "Select an image to represent the Written Communication standards (optional)."},
      {:type=>"Uploaded File",:name=> "criterion2Img",:title=> "Critical Thinking image",:description=>"Select an image to represent the Critical Thinking standards (optional)." },
      {:type=>"Uploaded File", :name=>"criterion3Img", :title=>"Information Retrieval and Technology image", :description=> "Select an image to represent the Information Retrieval and Technology standards (optional)."},
      {:type=>"Uploaded File", :name=>"criterion4Img", :title=>"Quantitative Reasoning image", :description=> "Select an image to represent the Quantitative Reasoning standards (optional)."},
      {:type=>"Uploaded File", :name=>"criterion5Img", :title=>"Oral Communication image", :description=>"Select an image to represent the Oral Communication standards (optional)." },
      {:type=>"Uploaded File", :name=>"criterion6Img", :title=>"Understanding Self and Community image", :description=>"Select an image to represent the Understanding Self and Community standards (optional)." }
    ]
    
    @supporting_files = [
      {:file=>get_filename(@files_to_upload[0]), :name=>"KCCbanner" },
      {:file=>get_filename(@files_to_upload[1]), :name=>"JavascriptFile" },
      {:file=>get_filename(@files_to_upload[3]), :name=>"CascadingStyleSheet" },
    ]
    
    @assignments = [
      {:title=>"Assignment 1",
        :student_text=>"Etiam nec tellus. Nulla semper volutpat ipsum. Cras lectus magna, convallis eget, molestie ac, pharetra vel, lorem. Etiam massa velit, vulputate ut, malesuada aliquet, pretium vitae, arcu. In ipsum libero, porttitor ac, viverra eu, feugiat et, tortor. Donec vel turpis ac tortor malesuada sollicitudin! Ut et lectus. Mauris sodales. Fusce ultrices euismod metus. Aliquam eu felis eget diam malesuada bibendum. Nunc a orci in augue condimentum blandit. Proin at dolor. Donec velit. Donec ullamcorper eros a ligula. Sed ullamcorper risus nec nisl. Nunc vel justo ut risus interdum faucibus. Sed dictum tempus ipsum! In neque dolor, auctor vel, accumsan pulvinar, feugiat sit amet, urna. Aenean sagittis luctus felis.\n\nAenean elementum pretium urna. Nullam eleifend congue nulla. Suspendisse potenti. Nullam posuere elit. Sed tellus. In facilisis. Nulla aliquet, turpis nec dictum euismod, nisl dui gravida leo, et volutpat odio eros sagittis sapien. Aliquam at purus? Nunc nibh diam; imperdiet ut, sodales ut, venenatis a, leo? Suspendisse pede. Maecenas congue risus et leo! Praesent urna purus, lobortis at; dapibus nec, dictum id, elit. Vivamus gravida odio non tellus. Aliquam non nulla.",
        :instructor_text=>"Etiam nec tellus. Nulla semper volutpat ipsum. {{test text}} Cras lectus magna, convallis eget, molestie ac, pharetra vel, lorem. Etiam massa velit, vulputate ut, malesuada aliquet, pretium vitae, arcu. In ipsum libero, porttitor ac, viverra eu, feugiat et, tortor. Donec vel turpis ac tortor malesuada sollicitudin! Ut et lectus. Mauris sodales. Fusce ultrices euismod metus. Aliquam eu felis eget diam malesuada bibendum. Nunc a orci in augue condimentum blandit. Proin at dolor. Donec velit. Donec ullamcorper eros a ligula. Sed ullamcorper risus nec nisl. Nunc vel justo ut risus interdum faucibus. Sed dictum tempus ipsum! In neque dolor, auctor vel, accumsan pulvinar, feugiat sit amet, urna. Aenean sagittis luctus felis.\n\nAenean elementum pretium urna. Nullam eleifend congue nulla. Suspendisse potenti. Nullam posuere elit. Sed tellus. In facilisis. Nulla aliquet, turpis nec dictum euismod, nisl dui gravida leo, et volutpat odio eros sagittis sapien. Aliquam at purus? Nunc nibh diam; imperdiet ut, sodales ut, venenatis a, leo? Suspendisse pede. Maecenas congue risus et leo! Praesent urna purus, lobortis at; dapibus nec, dictum id, elit. Vivamus gravida odio non tellus. Aliquam non nulla.",
        :instructor_comment1=>"Great job!",
        :instructor_comment2=>"Good job again!",
        :url=>"http://www.rsmart.com",
        :grade_scale=>"Letter grade",
        :instructions=>"Phasellus molestie. Sed in pede. Sed augue. Vestibulum lacus lectus, pulvinar nec, condimentum eu, sodales et, risus. Aenean dolor nisl, tristique at, vulputate nec, blandit in, mi. Fusce elementum ante. Maecenas rhoncus tincidunt sem. Sed leo dolor, faucibus hendrerit, tincidunt nec, elementum in, arcu. Donec et nulla. Vestibulum mauris nunc, consectetuer at, ultricies a, rutrum at, felis. Integer a nulla. Aliquam tincidunt nunc. Curabitur non purus. Nulla vel augue ac magna porttitor pretium.\n\nAenean fringilla enim. Vivamus nisi. Integer eleifend pharetra elit. Nulla scelerisque accumsan lectus. Morbi accumsan dui non velit. Suspendisse consequat mauris vitae neque. Etiam sit amet urna ut eros feugiat imperdiet? Nunc ut dolor. Nulla laoreet, nisi quis egestas condimentum, sapien nulla rutrum quam, quis auctor lorem justo at lectus. Integer in lacus eu nunc molestie pharetra. Curabitur dictum justo non eros. Nullam pellentesque ante rutrum mauris." },
      {:title=>"Assignment 2", :instructions=>"Nullam urna elit; placerat convallis, posuere nec, semper id, diam. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Duis dignissim pulvinar nisl. Nunc interdum vulputate eros. In nec nibh! Suspendisse potenti. Maecenas at felis. Donec velit diam, mattis ut, venenatis vehicula, accumsan et, orci. Sed leo. Curabitur odio quam, accumsan eu, molestie eu, fringilla sagittis, pede. Mauris luctus mi id ligula. Proin elementum volutpat leo. Cras aliquet commodo elit. Praesent auctor consectetuer risus!\n\nDuis euismod felis nec nunc. Ut lectus felis, malesuada consequat, hendrerit at; vestibulum et, enim. Ut nec nulla sed eros bibendum vulputate. Sed tincidunt diam eget lacus. Nulla nisl? Nam condimentum mattis dui! Aenean varius purus eget sem? Nullam odio. Donec condimentum mauris. Cras volutpat tristique lacus. Sed id dui. Mauris purus purus, tristique sed, ornare convallis, consequat a, ipsum. Donec fringilla, metus quis mollis lobortis, magna tellus malesuada augue; laoreet auctor velit lorem vitae neque. Duis augue sem, vehicula sit amet, vulputate vitae, viverra quis; dolor. Donec quis eros vel massa euismod dignissim! Aliquam quam. Nam non dolor."},
      {:title=>"Assignment 3",
        :file=>"documents/resources.doc",
        :student_file=>"documents/Lorem.txt", :open_hour=>last_hour,
        :open_meridian=>"AM", :grade_scale=>"Points", :max_points=>"100",
        :student_submissions=>"Attachments only",
        :instructions=>"Fusce mollis massa nec nisi. Aliquam turpis libero, consequat quis, fringilla eget, fermentum ut, velit? Integer velit nisl, placerat non, fringilla at, pellentesque ut, odio? Cras magna ligula, tincidunt ac, iaculis in, hendrerit eu, justo. Vivamus porta. Suspendisse lorem! Donec nec libero in leo lobortis consectetuer. Vivamus quis enim? Proin viverra condimentum purus. Sed commodo.\n\nCurabitur eget velit. Curabitur eleifend libero et nisi aliquet facilisis. Integer ultricies commodo purus. Praesent velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Phasellus pretium. Suspendisse gravida diam. Nulla justo nulla, facilisis ut, sagittis ut, fermentum ac, elit. Morbi accumsan. Maecenas id tellus. Fusce ornare ullamcorper felis. Etiam fringilla. Maecenas in nunc nec sem sollicitudin condimentum? Nullam metus nunc, varius sit amet, consectetuer sed, vestibulum quis, est. Quisque in sapien a justo elementum iaculis?" },
      {:title=>"Assignment 4",
        :grade_scale=>"Pass",
        :due_year=>current_year,
        :accept_year=>current_year,
        :instructions=>"Integer pulvinar facilisis purus. Quisque placerat! Maecenas risus. Nam vitae lacus. Quisque euismod imperdiet ipsum. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam vitae nulla! Duis tincidunt. Nulla id felis. Duis accumsan, est ut volutpat mollis, tellus lorem venenatis justo, eu accumsan lorem neque sit amet ante. Sed dictum. Donec nulla mi, lacinia nec; viverra nec, commodo sed, justo. Praesent fermentum vehicula dui. Sed molestie eleifend leo. Nulla et risus! Nullam ut lacus. Etiam faucibus; eros sit amet tempus consectetuer, urna est hendrerit mi, eget molestie sapien lorem non tellus. In vitae nisl. Vivamus ac lectus id pede viverra placerat.<br /><br />Morbi nec dui eget pede dapibus mollis. Mauris nisl. Donec tempor blandit diam. In hac habitasse platea dictumst. Sed vulputate ornare urna. Nulla sed."
        },
      {:title=>"Assignment 5", :due_year=>current_year, :accept_year=>current_year, :file=>"documents/resources.txt", :instructions=>"Integer pulvinar facilisis purus. Quisque placerat! Maecenas risus. Nam vitae lacus. Quisque euismod imperdiet ipsum. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam vitae nulla! Duis tincidunt. Nulla id felis. Duis accumsan, est ut volutpat mollis, tellus lorem venenatis justo, eu accumsan lorem neque sit amet ante. Sed dictum. Donec nulla mi, lacinia nec; viverra nec, commodo sed, justo. Praesent fermentum vehicula dui. Sed molestie eleifend leo. Nulla et risus! Nullam ut lacus. Etiam faucibus; eros sit amet tempus consectetuer, urna est hendrerit mi, eget molestie sapien lorem non tellus. In vitae nisl. Vivamus ac lectus id pede viverra placerat.\n\nMorbi nec dui eget pede dapibus mollis. Mauris nisl. Donec tempor blandit diam. In hac habitasse platea dictumst. Sed vulputate ornare urna. Nulla sed." }
    ]
    @grades = [ "B+", "A" ]
    @default_folder = "My Workspace"
    @roles = [ "Organizer", "Participant", "Evaluator", "Guest" ]
    
    # Validation text -- These contain page content that will be used for
    # test asserts.
    @due_date_alert = "Alert: Assignment due date set to be in the past. Please make a correction or click on the original button again to proceed.\n\nAssignment due date should be set after the open date.\n\nAccept submissions deadline should be set after the open date.\n\nThis assignment has no instructions. Please make a correction or click the original button to proceed."
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_build_portfolio_template

    workspace = @sakai.page.login(@student, @spassword)

    home = workspace.open_my_site_by_name @portfolio_site

    assignments = home.assignments

    assignment1 = assignments.open_assignment @assignments[0][:title]
    assignment1.assignment_text=@assignments[0][:student_text]
    assignment1.preview
    
    confirm = assignment1.save_draft
    
    assignments = confirm.back_to_list

    # TEST CASE: assignment shows a draft status
    assert_equal assignments.status_of(@assignments[0][:title]), "Draft - In progress"

    assignment1 = assignments.open_assignment @assignments[0][:title]
    
    confirm = assignment1.submit
    
    assignments = confirm.back_to_list

    # TEST CASE: Verify assignment submission
    assert_not_equal false, assignments.status_of(@assignments[0][:title])=~/Submitted/
    
    assignment3 = assignments.open_assignment @assignments[2][:title]
    assignment3.select_file=@assignments[2][:student_file]
    
    confirm = assignment3.submit

    assignments = confirm.back_to_list
    
    # TEST CASE: Verify assignment has submitted status
    assert_not_equal false, assignments.status_of(@assignments[2][:title])=~/Submitted/

    assignments.logout

    workspace = @sakai.page.login(@instructor, @ipassword)
    
    home = workspace.open_my_site_by_name @portfolio_site
    
    assignments = home.assignments
    
    submissions_list = assignments.grade @assignments[0][:title]
    
    grade_assignment = submissions_list.grade "#{@directory['person1']['lastname']}, #{@directory['person1']['firstname']} (#{@directory['person1']['id']})"
    sleep 4 #FIXME
    grade_assignment.instructor_comments=@assignments[0][:instructor_comment1]
    grade_assignment.remove_assignment_text
    grade_assignment.assignment_text=@assignments[0][:instructor_text]    
    attach = grade_assignment.add_attachments

    attach.url=@assignments[0][:url]
    attach.add

    grade_assignment = attach.continue
    grade_assignment.select_default_grade=@grades[0]
    grade_assignment.save_and_dont_release
    
    submissions_list = grade_assignment.return_to_list
    submissions_list.release_grades
    
    grade_assignment = submissions_list.grade "#{@directory['person1']['lastname']}, #{@directory['person1']['firstname']} (#{@directory['person1']['id']})"
    grade_assignment.check_allow_resubmission
    grade_assignment.return_to_list

    grade_assignment.logout

    workspace = @sakai.page.login(@student, @spassword)
    
    home = workspace.open_my_site_by_name @portfolio_site
    
    assignments = home.assignments
  
    assignment_1 = assignments.open_assignment @assignments[0][:title]
    
    # TEST CASE: Verify attached URL
    assert @browser.frame(:index=>1).link(:text=>@assignments[0][:url]).exist?
    
    assignment_1.remove_assignment_text
    assignment_1.assignment_text=@assignments[0][:student_text]
    
    confirm = assignment_1.resubmit
    
    assignments = confirm.back_to_list

    # TEST CASE: Verify submission status is correct
    assert_not_equal false, assignments.status_of(@assignments[0][:title])=~/Re-submitted/

    assignments.logout

    workspace = @sakai.page.login(@instructor, @ipassword)

    home = workspace.open_my_site_by_name @portfolio_site
    
    assignments = home.assignments
    
    submissions_list = assignments.grade @assignments[0][:title]
    
    # TEST CASE: Verify resubmission status
    assert_not_equal false, submissions_list.submission_status_of("#{@directory['person1']['lastname']}, #{@directory['person1']['firstname']} (#{@directory['person1']['id']})")=~/Re-submitted/

    grade_assignment = submissions_list.grade "#{@directory['person1']['lastname']}, #{@directory['person1']['firstname']} (#{@directory['person1']['id']})"
    grade_assignment.instructor_comments=@assignments[0][:instructor_comment2]
    grade_assignment.select_default_grade=@grades[1]
    grade_assignment.save_and_dont_release
    
    submissions_list = grade_assignment.return_to_list
    submissions_list.release_grades

    submissions_list.logout

    workspace = @sakai.page.login(@student, @spassword)
    
    home = workspace.open_my_site_by_name @portfolio_site
    
    assignments = home.assignments
    assignment_1 = assignments.open_assignment @assignments[0][:title]
    
    # TEST CASE: Verify instructor's comments are as expected
    assert_equal assignment_1.instructor_comments, @assignments[0][:instructor_comment2]

    assignment_1.logout
  end
end
