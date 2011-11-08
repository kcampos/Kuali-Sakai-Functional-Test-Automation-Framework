# 
# == Synopsis
#
# 
# 
# Author: Abe Heward (aheward@rSmart.com)

gems = ["test/unit", "watir-webdriver"]
gems.each { |gem| require gem }
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
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
    @instructor_name = @config.directory['person3']['lastname'] + ", " + @config.directory['person3']['firstname']
    @instructor2 = @config.directory['person4']['id']
    @ipassword2 = @config.directory['person4']['password']
    @instructor2_name = @config.directory['person4']['lastname'] + ", " + @config.directory['person4']['firstname']
    @student = @config.directory["person1"]["id"]
    @spassword = @config.directory["person1"]["password"]
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
    # Test case variables
    @files = [
      "documents/evaluation.xsd",
      "documents/feedback.xsd",
      "documents/genEducation.xsd",
      "documents/reflection.xsd",
    ]
    @folder_name = "data"
    @portfolio_site = "123Port"
    @schema = [ get_filename(@files[0]), get_filename(@files[1]), get_filename(@files[2]), get_filename(@files[3]) ]
    @form_names = ["Evaluation", "Feedback for Matrix", "General Education Evidence", "Reflection for Matrix" ]
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
    @matrix_name = "General Education "
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
    @form_names = [ "Contact Information (#{@portfolio_site})", "Portfolio Properties (#{@portfolio_site})" ]
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
        :instructions=>"Phasellus molestie. Sed in pede. Sed augue. Vestibulum lacus lectus, pulvinar nec, condimentum eu, sodales et, risus. Aenean dolor nisl, tristique at, vulputate nec, blandit in, mi. Fusce elementum ante. Maecenas rhoncus tincidunt sem. Sed leo dolor, faucibus hendrerit, tincidunt nec, elementum in, arcu. Donec et nulla. Vestibulum mauris nunc, consectetuer at, ultricies a, rutrum at, felis. Integer a nulla. Aliquam tincidunt nunc. Curabitur non purus. Nulla vel augue ac magna porttitor pretium.\n\nAenean fringilla enim. Vivamus nisi. Integer eleifend pharetra elit. Nulla scelerisque accumsan lectus. Morbi accumsan dui non velit. Suspendisse consequat mauris vitae neque. Etiam sit amet urna ut eros feugiat imperdiet? Nunc ut dolor. Nulla laoreet, nisi quis egestas condimentum, sapien nulla rutrum quam, quis auctor lorem justo at lectus. Integer in lacus eu nunc molestie pharetra. Curabitur dictum justo non eros. Nullam pellentesque ante rutrum mauris." },
      {:title=>"Assignment 2", :instructions=>"Nullam urna elit; placerat convallis, posuere nec, semper id, diam. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Duis dignissim pulvinar nisl. Nunc interdum vulputate eros. In nec nibh! Suspendisse potenti. Maecenas at felis. Donec velit diam, mattis ut, venenatis vehicula, accumsan et, orci. Sed leo. Curabitur odio quam, accumsan eu, molestie eu, fringilla sagittis, pede. Mauris luctus mi id ligula. Proin elementum volutpat leo. Cras aliquet commodo elit. Praesent auctor consectetuer risus!\n\nDuis euismod felis nec nunc. Ut lectus felis, malesuada consequat, hendrerit at; vestibulum et, enim. Ut nec nulla sed eros bibendum vulputate. Sed tincidunt diam eget lacus. Nulla nisl? Nam condimentum mattis dui! Aenean varius purus eget sem? Nullam odio. Donec condimentum mauris. Cras volutpat tristique lacus. Sed id dui. Mauris purus purus, tristique sed, ornare convallis, consequat a, ipsum. Donec fringilla, metus quis mollis lobortis, magna tellus malesuada augue; laoreet auctor velit lorem vitae neque. Duis augue sem, vehicula sit amet, vulputate vitae, viverra quis; dolor. Donec quis eros vel massa euismod dignissim! Aliquam quam. Nam non dolor."},
      {:title=>"Assignment 3",
        :file=>"documents/resources.doc",
        :student_file=>"documents/Lorem.txt",
        :instructions=>"Fusce mollis massa nec nisi. Aliquam turpis libero, consequat quis, fringilla eget, fermentum ut, velit? Integer velit nisl, placerat non, fringilla at, pellentesque ut, odio? Cras magna ligula, tincidunt ac, iaculis in, hendrerit eu, justo. Vivamus porta. Suspendisse lorem! Donec nec libero in leo lobortis consectetuer. Vivamus quis enim? Proin viverra condimentum purus. Sed commodo.\n\nCurabitur eget velit. Curabitur eleifend libero et nisi aliquet facilisis. Integer ultricies commodo purus. Praesent velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Phasellus pretium. Suspendisse gravida diam. Nulla justo nulla, facilisis ut, sagittis ut, fermentum ac, elit. Morbi accumsan. Maecenas id tellus. Fusce ornare ullamcorper felis. Etiam fringilla. Maecenas in nunc nec sem sollicitudin condimentum? Nullam metus nunc, varius sit amet, consectetuer sed, vestibulum quis, est. Quisque in sapien a justo elementum iaculis?" },
      {:title=>"Assignment 4", :instructions=>"Integer pulvinar facilisis purus. Quisque placerat! Maecenas risus. Nam vitae lacus. Quisque euismod imperdiet ipsum. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam vitae nulla! Duis tincidunt. Nulla id felis. Duis accumsan, est ut volutpat mollis, tellus lorem venenatis justo, eu accumsan lorem neque sit amet ante. Sed dictum. Donec nulla mi, lacinia nec; viverra nec, commodo sed, justo. Praesent fermentum vehicula dui. Sed molestie eleifend leo. Nulla et risus! Nullam ut lacus. Etiam faucibus; eros sit amet tempus consectetuer, urna est hendrerit mi, eget molestie sapien lorem non tellus. In vitae nisl. Vivamus ac lectus id pede viverra placerat.<br /><br />Morbi nec dui eget pede dapibus mollis. Mauris nisl. Donec tempor blandit diam. In hac habitasse platea dictumst. Sed vulputate ornare urna. Nulla sed."},
      {:title=>"Assignment 5", :file=>"documents/resources.txt", :instructions=>"Integer pulvinar facilisis purus. Quisque placerat! Maecenas risus. Nam vitae lacus. Quisque euismod imperdiet ipsum. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam vitae nulla! Duis tincidunt. Nulla id felis. Duis accumsan, est ut volutpat mollis, tellus lorem venenatis justo, eu accumsan lorem neque sit amet ante. Sed dictum. Donec nulla mi, lacinia nec; viverra nec, commodo sed, justo. Praesent fermentum vehicula dui. Sed molestie eleifend leo. Nulla et risus! Nullam ut lacus. Etiam faucibus; eros sit amet tempus consectetuer, urna est hendrerit mi, eget molestie sapien lorem non tellus. In vitae nisl. Vivamus ac lectus id pede viverra placerat.\n\nMorbi nec dui eget pede dapibus mollis. Mauris nisl. Donec tempor blandit diam. In hac habitasse platea dictumst. Sed vulputate ornare urna. Nulla sed." }
    ]
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_build_portfolio_template

    # Log in to Sakai
    workspace = @sakai.login(@instructor, @ipassword)

    resources = workspace.resources

    # Add Files to Repository...
    create_folder = resources.create_subfolders_in "My Workspace"
    create_folder.folder_name=@folder_name
    
    resources = create_folder.create_folders_now

    resources = resources.upload_multiple_files_to_folder(@folder_name, @files)

    home = resources.open_my_site_by_name @portfolio_site

    # Build four Matrix Forms...
    forms = home.forms

    add_form = forms.add
    
    select_schema = add_form.select_schema_file
    
    select_schema = select_schema.show_other_sites
    
    select_schema = select_schema.open_folder "My Workspace"
    select_schema = select_schema.open_folder @folder_name
    select_schema = select_schema.select_file @schema[0]
    
    add_form = select_schema.continue
    add_form.name=@form_names[0]
    add_form.instruction=@form_instructions[0]
    
    forms = add_form.add_form
    
    add_form2 = forms.add
    
    schema = add_form2.select_schema_file
    schema = schema.show_other_sites
    schema = schema.open_folder "My Workspace"
    schema = schema.open_folder @folder_name
    schema = schema.select_file @schema[2]
    
    add_form2 = schema.continue
    add_form2.name=@form_names[2]
    add_form2.instruction=@form_instructions[2]
    
    forms = add_form2.add_form
    
    add_form3 = forms.add
    
    schema = add_form3.select_schema_file
    schema = schema.show_other_sites
    schema = schema.open_folder "My Workspace"
    schema = schema.open_folder @folder_name
    schema = schema.select_file @schema[1]
    
    add_form3 = schema.continue
    add_form3.name=@form_names[1]
    add_form3.instruction=@form_instructions[1]
    
    forms = add_form3.add_form
    
    add_form4 = forms.add
    
    schema = add_form4.select_schema_file
    schema = schema.show_other_sites
    schema = schema.open_folder "My Workspace"
    schema = schema.open_folder @folder_name
    schema = schema.select_file @schema[3]
    
    add_form4 = schema.continue
    add_form4.name=@form_names[3]
    add_form4.instruction=@form_instructions[3]
    
    forms = add_form4.add_form

    # Publish the four forms...
    publish = forms.publish @form_names[0]
    forms = publish.yes
    publish = forms.publish @form_names[1]
    forms = publish.yes
    publish = forms.publish @form_names[2]
    forms = publish.yes
    publish = forms.publish @form_names[3]
    forms = publish.yes

    styles = forms.styles

    # Add Style to site...
    add_style = styles.add
    
    attach = add_style.select_file
    attach = attach.show_other_sites
    attach.open_folder "My Workspace"
    
    upload = attach.upload_files_to_folder @folder_name
    upload.file_to_upload=@style_file
    
    attach = upload.upload_files_now
    attach.open_folder @folder_name
    attach.select_file @style_filename

    add_style = attach.continue
    add_style.name=@style_name
    add_style.description=@style_description
    
    styles = add_style.add_style

    matrices = styles.matrices

    add_matrix = matrices.add
    add_matrix.title=@matrix_name
    
    select = add_matrix.select_style
    
    add_matrix = select.select_style @style_name
    
    column1 = add_matrix.add_column
    column1.name=@column_names[0]
    add_matrix = column1.update
    
    column2 = add_matrix.add_column
    column2.name=@column_names[1]
    add_matrix = column2.update
    
    column3 = add_matrix.add_column
    column3.name=@column_names[2]
    add_matrix = column3.update
    
    row1 = add_matrix.add_row
    row1.name=@row_names[0]
    row1.background_color=@background_colors[0]
    row1.font_color=@font_color
    
    add_matrix = row1.update
    
    row2 = add_matrix.add_row
    row2.name=@row_names[1]
    row2.background_color=@background_colors[1]
    row2.font_color=@font_color
    
    add_matrix = row2.update

    row3 = add_matrix.add_row
    row3.name=@row_names[2]
    row3.background_color=@background_colors[2]
    row3.font_color=@font_color
    
    add_matrix = row3.update
    
    row4 = add_matrix.add_row
    row4.name=@row_names[3]
    row4.background_color=@background_colors[3]
    row4.font_color=@font_color
    
    add_matrix = row4.update
    
    row5 = add_matrix.add_row
    row5.name=@row_names[4]
    row5.background_color=@background_colors[4]
    row5.font_color=@font_color
    
    add_matrix = row5.update
    
    row5 = add_matrix.add_row
    row5.name=@row_names[5]
    row5.background_color=@background_colors[5]
    row5.font_color=@font_color
    
    add_matrix = row5.update

    edit_cells = add_matrix.save_changes
    
    edit = edit_cells.edit(1, 1)
    
    # TEST CASE: Verify the title is correct
    assert_equal edit.title_element.value, "Row: #{@row_names[0]}; Column: #{@column_names[0]}"
    
    edit.uncheck_use_default_reflection_form
    edit.reflection=/#{Regexp.escape(@form_names[3])}/
    edit.uncheck_use_default_feedback_form
    edit.feedback=/#{Regexp.escape(@form_names[1])}/
    edit.uncheck_use_default_evaluation_form
    edit.evaluation=/#{Regexp.escape(@form_names[0])}/
    edit.uncheck_use_default_evaluators
    
    select_eval = edit.select_evaluators
    select_eval.users=@instructor_name
    select_eval.add_users
    
    edit = select_eval.save
    
    edit_cells = edit.save_changes
    
    edit = edit_cells.edit(1, 2)
    
    # TEST CASE: Verify the title is correct
    assert_equal edit.title_element.value, "Row: #{@row_names[0]}; Column: #{@column_names[1]}"
    
    edit.uncheck_use_default_reflection_form
    edit.reflection=/#{Regexp.escape(@form_names[3])}/
    edit.uncheck_use_default_feedback_form
    edit.feedback=/#{Regexp.escape(@form_names[1])}/
    edit.uncheck_use_default_evaluation_form
    edit.evaluation=/#{Regexp.escape(@form_names[0])}/
    edit.uncheck_use_default_evaluators
    
    select_eval = edit.select_evaluators
    select_eval.users=@instructor_name
    select_eval.add_users
    select_eval.users=@instructor2_name
    select_eval.add_users
    
    edit = select_eval.save
    
    edit_cells = edit.save_changes
    
    edit = edit_cells.edit(1, 3)
    
    # TEST CASE: Verify the title is correct
    assert_equal edit.title_element.value, "Row: #{@row_names[0]}; Column: #{@column_names[2]}"
    
    edit.uncheck_use_default_reflection_form
    edit.reflection=/#{Regexp.escape(@form_names[3])}/
    edit.uncheck_use_default_feedback_form
    edit.feedback=/#{Regexp.escape(@form_names[1])}/
    edit.uncheck_use_default_evaluation_form
    edit.evaluation=/#{Regexp.escape(@form_names[0])}/
    edit.uncheck_use_default_evaluators
    
    select_eval = edit.select_evaluators
    select_eval.users=@instructor_name
    select_eval.add_users
    select_eval.roles="Organizer"
    select_eval.add_roles
    
    edit = select_eval.save
    
    edit_cells = edit.save_changes
    
    edit = edit_cells.edit(2, 1)
    
    # TEST CASE: Verify the title is correct
    assert_equal edit.title_element.value, "Row: #{@row_names[1]}; Column: #{@column_names[0]}"
    
    edit.uncheck_use_default_reflection_form
    edit.reflection=/#{Regexp.escape(@form_names[3])}/
    edit.uncheck_use_default_feedback_form
    edit.feedback=/#{Regexp.escape(@form_names[1])}/
    edit.uncheck_use_default_evaluation_form
    edit.evaluation=/#{Regexp.escape(@form_names[0])}/
    edit.uncheck_use_default_evaluators
    
    select_eval = edit.select_evaluators
    select_eval.users=@instructor_name
    select_eval.add_users
    select_eval.roles="Participant"
    select_eval.add_roles
    
    edit = select_eval.save
    
    edit_cells = edit.save_changes
    
    edit = edit_cells.edit(2, 2)
    
    # TEST CASE: Verify the title is correct
    assert_equal edit.title_element.value, "Row: #{@row_names[1]}; Column: #{@column_names[1]}"
    
    edit.uncheck_use_default_reflection_form
    edit.reflection=/#{Regexp.escape(@form_names[3])}/
    edit.uncheck_use_default_feedback_form
    edit.feedback=/#{Regexp.escape(@form_names[1])}/
    edit.uncheck_use_default_evaluation_form
    edit.evaluation=/#{Regexp.escape(@form_names[0])}/
    edit.uncheck_use_default_evaluators
    
    select_eval = edit.select_evaluators
    select_eval.users=@instructor_name
    select_eval.add_users
    select_eval.roles="Evaluator"
    select_eval.add_roles
    
    edit = select_eval.save
    
    edit_cells = edit.save_changes
    
    edit = edit_cells.edit(2, 3)
    
    # TEST CASE: Verify the title is correct
    assert_equal edit.title_element.value, "Row: #{@row_names[1]}; Column: #{@column_names[2]}"
    
    edit.uncheck_use_default_reflection_form
    edit.reflection=/#{Regexp.escape(@form_names[3])}/
    edit.uncheck_use_default_feedback_form
    edit.feedback=/#{Regexp.escape(@form_names[1])}/
    edit.uncheck_use_default_evaluation_form
    edit.evaluation=/#{Regexp.escape(@form_names[0])}/
    edit.uncheck_use_default_evaluators
    
    select_eval = edit.select_evaluators
    select_eval.users=@instructor_name
    select_eval.add_users
    select_eval.roles="Guest"
    select_eval.add_roles
    
    edit = select_eval.save
    
    edit_cells = edit.save_changes
    
    edit = edit_cells.edit(3, 1)
    
    # TEST CASE: Verify the title is correct
    assert_equal edit.title_element.value, "Row: #{@row_names[2]}; Column: #{@column_names[0]}"
    
    edit.uncheck_use_default_reflection_form
    edit.reflection=/#{Regexp.escape(@form_names[3])}/
    edit.uncheck_use_default_feedback_form
    edit.feedback=/#{Regexp.escape(@form_names[1])}/
    edit.uncheck_use_default_evaluation_form
    edit.evaluation=/#{Regexp.escape(@form_names[0])}/
    edit.uncheck_use_default_evaluators
    
    select_eval = edit.select_evaluators
    select_eval.users=@instructor_name
    select_eval.add_users
    
    edit = select_eval.save
    
    edit_cells = edit.save_changes
    
    edit = edit_cells.edit(3, 2)
    
    # TEST CASE: Verify the title is correct
    assert_equal edit.title_element.value, "Row: #{@row_names[2]}; Column: #{@column_names[1]}"
    
    edit.uncheck_use_default_reflection_form
    edit.reflection=/#{Regexp.escape(@form_names[3])}/
    edit.uncheck_use_default_feedback_form
    edit.feedback=/#{Regexp.escape(@form_names[1])}/
    edit.uncheck_use_default_evaluation_form
    edit.evaluation=/#{Regexp.escape(@form_names[0])}/
    edit.uncheck_use_default_evaluators
    
    select_eval = edit.select_evaluators
    select_eval.users=@instructor_name
    select_eval.add_users
    
    edit = select_eval.save
    
    edit_cells = edit.save_changes
    
    edit = edit_cells.edit(3, 3)
    
    # TEST CASE: Verify the title is correct
    assert_equal edit.title_element.value, "Row: #{@row_names[2]}; Column: #{@column_names[2]}"
    
    edit.uncheck_use_default_reflection_form
    edit.reflection=/#{Regexp.escape(@form_names[3])}/
    edit.uncheck_use_default_feedback_form
    edit.feedback=/#{Regexp.escape(@form_names[1])}/
    edit.uncheck_use_default_evaluation_form
    edit.evaluation=/#{Regexp.escape(@form_names[0])}/
    edit.uncheck_use_default_evaluators
    
    select_eval = edit.select_evaluators
    select_eval.users=@instructor_name
    select_eval.add_users
    
    edit = select_eval.save
    
    edit_cells = edit.save_changes
    
    edit = edit_cells.edit(4, 1)
    
    # TEST CASE: Verify the title is correct
    assert_equal edit.title_element.value, "Row: #{@row_names[3]}; Column: #{@column_names[0]}"
    
    edit.uncheck_use_default_reflection_form
    edit.reflection=/#{Regexp.escape(@form_names[3])}/
    edit.uncheck_use_default_feedback_form
    edit.feedback=/#{Regexp.escape(@form_names[1])}/
    edit.uncheck_use_default_evaluation_form
    edit.evaluation=/#{Regexp.escape(@form_names[0])}/
    edit.uncheck_use_default_evaluators
    
    select_eval = edit.select_evaluators
    select_eval.users=@instructor_name
    select_eval.add_users
    
    edit = select_eval.save
    
    edit_cells = edit.save_changes
    
    edit = edit_cells.edit(4, 2)
    
    # TEST CASE: Verify the title is correct
    assert_equal edit.title_element.value, "Row: #{@row_names[3]}; Column: #{@column_names[1]}"
    
    edit.uncheck_use_default_reflection_form
    edit.reflection=/#{Regexp.escape(@form_names[3])}/
    edit.uncheck_use_default_feedback_form
    edit.feedback=/#{Regexp.escape(@form_names[1])}/
    edit.uncheck_use_default_evaluation_form
    edit.evaluation=/#{Regexp.escape(@form_names[0])}/
    edit.uncheck_use_default_evaluators
    
    select_eval = edit.select_evaluators
    select_eval.users=@instructor_name
    select_eval.add_users
    
    edit = select_eval.save
    
    edit_cells = edit.save_changes
    
    edit = edit_cells.edit(4, 3)
    
    # TEST CASE: Verify the title is correct
    assert_equal edit.title_element.value, "Row: #{@row_names[3]}; Column: #{@column_names[2]}"
    
    edit.uncheck_use_default_reflection_form
    edit.reflection=/#{Regexp.escape(@form_names[3])}/
    edit.uncheck_use_default_feedback_form
    edit.feedback=/#{Regexp.escape(@form_names[1])}/
    edit.uncheck_use_default_evaluation_form
    edit.evaluation=/#{Regexp.escape(@form_names[0])}/
    edit.uncheck_use_default_evaluators
    
    select_eval = edit.select_evaluators
    select_eval.users=@instructor_name
    select_eval.add_users
    
    edit = select_eval.save
    
    edit_cells = edit.save_changes
    
    edit = edit_cells.edit(5, 1)
    
    # TEST CASE: Verify the title is correct
    assert_equal edit.title_element.value, "Row: #{@row_names[4]}; Column: #{@column_names[0]}"
    
    edit.uncheck_use_default_reflection_form
    edit.reflection=/#{Regexp.escape(@form_names[3])}/
    edit.uncheck_use_default_feedback_form
    edit.feedback=/#{Regexp.escape(@form_names[1])}/
    edit.uncheck_use_default_evaluation_form
    edit.evaluation=/#{Regexp.escape(@form_names[0])}/
    edit.uncheck_use_default_evaluators
    
    select_eval = edit.select_evaluators
    select_eval.users=@instructor_name
    select_eval.add_users
    
    edit = select_eval.save
    
    edit_cells = edit.save_changes
    
    edit = edit_cells.edit(5, 2)
    
    # TEST CASE: Verify the title is correct
    assert_equal edit.title_element.value, "Row: #{@row_names[4]}; Column: #{@column_names[1]}"
    
    edit.uncheck_use_default_reflection_form
    edit.reflection=/#{Regexp.escape(@form_names[3])}/
    edit.uncheck_use_default_feedback_form
    edit.feedback=/#{Regexp.escape(@form_names[1])}/
    edit.uncheck_use_default_evaluation_form
    edit.evaluation=/#{Regexp.escape(@form_names[0])}/
    edit.uncheck_use_default_evaluators
    
    select_eval = edit.select_evaluators
    select_eval.users=@instructor_name
    select_eval.add_users
    
    edit = select_eval.save
    
    edit_cells = edit.save_changes
    
    edit = edit_cells.edit(5, 3)
    
    # TEST CASE: Verify the title is correct
    assert_equal edit.title_element.value, "Row: #{@row_names[4]}; Column: #{@column_names[2]}"
    
    edit.uncheck_use_default_reflection_form
    edit.reflection=/#{Regexp.escape(@form_names[3])}/
    edit.uncheck_use_default_feedback_form
    edit.feedback=/#{Regexp.escape(@form_names[1])}/
    edit.uncheck_use_default_evaluation_form
    edit.evaluation=/#{Regexp.escape(@form_names[0])}/
    edit.uncheck_use_default_evaluators
    
    select_eval = edit.select_evaluators
    select_eval.users=@instructor_name
    select_eval.add_users
    
    edit = select_eval.save
    
    edit_cells = edit.save_changes
    
    edit = edit_cells.edit(6, 1)
    
    # TEST CASE: Verify the title is correct
    assert_equal edit.title_element.value, "Row: #{@row_names[5]}; Column: #{@column_names[0]}"
    
    edit.uncheck_use_default_reflection_form
    edit.reflection=/#{Regexp.escape(@form_names[3])}/
    edit.uncheck_use_default_feedback_form
    edit.feedback=/#{Regexp.escape(@form_names[1])}/
    edit.uncheck_use_default_evaluation_form
    edit.evaluation=/#{Regexp.escape(@form_names[0])}/
    edit.uncheck_use_default_evaluators
    
    select_eval = edit.select_evaluators
    select_eval.users=@instructor_name
    select_eval.add_users
    
    edit = select_eval.save
    
    edit_cells = edit.save_changes
    
    edit = edit_cells.edit(6, 2)
    
    # TEST CASE: Verify the title is correct
    assert_equal edit.title_element.value, "Row: #{@row_names[5]}; Column: #{@column_names[1]}"
    
    edit.uncheck_use_default_reflection_form
    edit.reflection=/#{Regexp.escape(@form_names[3])}/
    edit.uncheck_use_default_feedback_form
    edit.feedback=/#{Regexp.escape(@form_names[1])}/
    edit.uncheck_use_default_evaluation_form
    edit.evaluation=/#{Regexp.escape(@form_names[0])}/
    edit.uncheck_use_default_evaluators
    
    select_eval = edit.select_evaluators
    select_eval.users=@instructor_name
    select_eval.add_users
    
    edit = select_eval.save
    
    edit_cells = edit.save_changes
    
    edit = edit_cells.edit(6, 3)
    
    # TEST CASE: Verify the title is correct
    assert_equal edit.title_element.value, "Row: #{@row_names[5]}; Column: #{@column_names[0]}"
    
    edit.uncheck_use_default_reflection_form
    edit.reflection=/#{Regexp.escape(@form_names[3])}/
    edit.uncheck_use_default_feedback_form
    edit.feedback=/#{Regexp.escape(@form_names[1])}/
    edit.uncheck_use_default_evaluation_form
    edit.evaluation=/#{Regexp.escape(@form_names[0])}/
    edit.uncheck_use_default_evaluators
    
    select_eval = edit.select_evaluators
    select_eval.users=@instructor_name
    select_eval.add_users
    
    edit = select_eval.save
    
    edit_cells = edit.save_changes
    
    matrices = edit_cells.return_to_list
    
    matrices.preview @matrix_name
    confirm = matrices.publish @matrix_name
    matrices = confirm.continue

    glossary = matrices.glossary

    new_term = glossary.add
    new_term.term=@glossary_terms[0]
    new_term.short_description=@glossary_short_descriptions[0]
    new_term.long_description=@glossary_long_descriptions[0]
    
    glossary = new_term.add_term
    
    new_term = glossary.add
    new_term.term=@glossary_terms[1]
    new_term.short_description=@glossary_short_descriptions[1]
    new_term.long_description=@glossary_long_descriptions[1]
    
    glossary = new_term.add_term
    
    new_term = glossary.add
    new_term.term=@glossary_terms[2]
    new_term.short_description=@glossary_short_descriptions[2]
    new_term.long_description=@glossary_long_descriptions[2]
    
    glossary = new_term.add_term
    
    new_term = glossary.add
    new_term.term=@glossary_terms[3]
    new_term.short_description=@glossary_short_descriptions[3]
    new_term.long_description=@glossary_long_descriptions[3]
    
    glossary = new_term.add_term
    
    new_term = glossary.add
    new_term.term=@glossary_terms[4]
    new_term.short_description=@glossary_short_descriptions[4]
    new_term.long_description=@glossary_long_descriptions[4]
    
    glossary = new_term.add_term
    
    new_term = glossary.add
    new_term.term=@glossary_terms[5]
    new_term.short_description=@glossary_short_descriptions[5]
    new_term.long_description=@glossary_long_descriptions[5]
    
    glossary = new_term.add_term
    
    new_term = glossary.add
    new_term.term=@glossary_terms[6]
    new_term.short_description=@glossary_short_descriptions[6]
    new_term.long_description=@glossary_long_descriptions[6]
    
    glossary = new_term.add_term
    
    new_term = glossary.add
    new_term.term=@glossary_terms[7]
    new_term.short_description=@glossary_short_descriptions[7]
    new_term.long_description=@glossary_long_descriptions[7]
    
    glossary = new_term.add_term
    
    new_term = glossary.add
    new_term.term=@glossary_terms[8]
    new_term.short_description=@glossary_short_descriptions[8]
    new_term.long_description=@glossary_long_descriptions[8]
    
    glossary = new_term.add_term

    resources = glossary.resources
    resources = resources.show_other_sites
    
    resources.open_folder "My Workspace"
    
    resources = resources.upload_multiple_files_to_folder(@folder_name, @files_to_upload)

    forms = resources.forms

    import = forms.import

    attach = import.select_file
    attach.show_other_sites
    attach.open_folder "My Workspace"
    attach.open_folder @folder_name
    attach.select_file @form_zips[0]
    
    import = attach.continue
    
    forms = import.import
    
    publish = forms.publish @form_names[0]
    
    forms = publish.yes
    
    import = forms.import

    attach = import.select_file
    attach.show_other_sites
    attach.open_folder "My Workspace"
    attach.open_folder @folder_name
    attach.select_file @form_zips[1]
    
    import = attach.continue

    forms = import.import

    publish = forms.publish @form_names[1]
    
    forms = publish.yes

    port_temp = forms.portfolio_templates

    add_template = port_temp.add
    add_template.name=@template_name
    add_template.description=@template_description
    
    build = add_template.continue
    
    attach = build.select_file
    
    attach.show_other_sites
    attach.open_folder "My Workspace"
    
    upload = attach.upload_files_to_folder @folder_name
    upload.file_to_upload=@files_to_upload[2]

    attach = upload.upload_files_now
    attach.open_folder @folder_name
    attach.select_file get_filename(@files_to_upload[2])

    build = attach.continue
    build.outline_options_form_type= /#{Regexp.escape(@form_type)}/
    
    content = build.continue
    content.type=@content[0][:type]
    content.name=@content[0][:name]
    content.title=@content[0][:title]
    content.description=@content[0][:description]
    
    content.add_to_list
    content.type=/#{Regexp.escape(@content[1][:type])}/
    content.name=@content[1][:name]
    content.title=@content[1][:title]
    content.description=@content[1][:description]
    
    content.add_to_list
    
    content.type=@content[2][:type]
    content.name=@content[2][:name]
    content.title=@content[2][:title]
    content.description=@content[2][:description]
    content.check_image
    content.add_to_list
    # 
    content.type=@content[3][:type]
    content.name=@content[3][:name]
    content.title=@content[3][:title]
    content.description=@content[3][:description]
    content.check_image
    content.add_to_list
    # 
    content.type=@content[4][:type]
    content.name=@content[4][:name]
    content.title=@content[4][:title]
    content.description=@content[4][:description]
    content.check_image
    content.add_to_list
    # 
    content.type=@content[5][:type]
    content.name=@content[5][:name]
    content.title=@content[5][:title]
    content.description=@content[5][:description]
    content.check_image
    content.add_to_list
    # 
    content.type=@content[6][:type]
    content.name=@content[6][:name]
    content.title=@content[6][:title]
    content.description=@content[6][:description]
    content.check_image
    content.add_to_list
    # 
    content.type=@content[7][:type]
    content.name=@content[7][:name]
    content.title=@content[7][:title]
    content.description=@content[7][:description]
    content.check_image
    content.add_to_list
    # 
    content.type=@content[8][:type]
    content.name=@content[8][:name]
    content.title=@content[8][:title]
    content.description=@content[8][:description]
    content.check_image
    content.add_to_list
    
    supporting_files = content.continue
    supporting_files.name=@supporting_files[0][:name]
    
    attach = supporting_files.select_file
    attach.show_other_sites
    # 
    attach.open_folder "My Workspace"
    attach.open_folder @folder_name
    attach.select_file @supporting_files[0][:file]
    
    supporting_files = attach.continue
    supporting_files.add_to_list
    supporting_files.name=@supporting_files[1][:name]
    
    attach = supporting_files.select_file
    attach.show_other_sites
    attach.open_folder "My Workspace"
    attach.open_folder @folder_name
    attach.select_file @supporting_files[1][:file]
    
    supporting_files = attach.continue
    supporting_files.add_to_list
    supporting_files.name=@supporting_files[2][:name]
    
    attach = supporting_files.select_file
    attach.show_other_sites
    attach.open_folder "My Workspace"
    attach.open_folder @folder_name
    attach.select_file @supporting_files[2][:file]
    supporting_files = attach.continue
    supporting_files.add_to_list
    
    port_temp = supporting_files.finish
    port_temp.publish @template_name

    assignments = port_temp.assignments

    add_assignment = assignments.add
    add_assignment.title=@assignments[0][:title]
    
    preview = add_assignment.preview
    
    assignments = preview.post
  
    # TEST CASE: Verify assignment appears in list
    assert assignments.assignments_titles.include?(@assignments[0][:title])
    
    add_asgn2 = assignments.add
    add_asgn2.instructions=@assignments[1][:instructions]
    add_asgn2.title=@assignments[1][:title]
    add_asgn2.open_hour=last_hour
    add_asgn2.open_meridian="AM"
    add_asgn2.student_submissions="Inline only"
    add_asgn2.grade_scale="Letter grade"
    add_asgn2.check_add_due_date
    
    assignments = add_asgn2.post
    
    # TEST CASE: Verify assignment appears in list
    assert assignments.assignments_titles.include?(@assignments[1][:title])
    
    calendar = assignments.calendar
    calendar.view="List of Events"
    calendar.show="All events"
    
    # TEST CASE: Event appears in list as expected
    assert calendar.events_list.include?("Due #{@assignments[1][:title]}")
    
    assignments = calendar.assignments

    add_assgn3 = assignments.add
    add_assgn3.instructions=@assignments[1][:instructions]
    add_assgn3.title=@assignments[2][:title]
    add_assgn3.open_hour=last_hour
    add_assgn3.open_meridian="AM"
    add_assgn3.student_submissions="Attachments only"
    add_assgn3.grade_scale="Points"
    add_assgn3.max_points="100"
    add_assgn3.check_add_open_announcement
    
    attach = add_assgn3.add_attachments
    attach = attach.upload_local_file @assignments[2][:file]

    add_assgn3 = attach.continue
    
    assignments = add_assgn3.save_draft
    
    # TEST CASE: Assignment saved in draft mode
    assert assignments.assignments_titles.include?("Draft - #{@assignments[2][:title]}")
    
    permissions = assignments.permissions
    permissions.uncheck_organizers_share_drafts
    
    assignments = permissions.save
    
    site_home = assignments.home
    
    # TEST CASE: Verify assignment announcement does not appear
    assert_equal false, site_home.announcements_list.include?("Assignment: Open Date for '#{@assignments[2][:title]}'")
    
    assignments = site_home.assignments

    add_assgn4 = assignments.add
    add_assgn4.title=@assignments[3][:title]
    add_assgn4.due_year=last_year
    add_assgn4.accept_year=last_year
    add_assgn4.post
    
    add_assgn4 = AssignmentAdd.new(@browser) # FIXME
    
    # TEST CASE: Verify alert message appears
    assert_equal add_assgn4.alert_text, "Alert: Assignment due date set to be in the past. Please make a correction or click on the original button again to proceed.\n\nAssignment due date should be set after the open date.\n\nAccept submissions deadline should be set after the open date.\n\nThis assignment has no instructions. Please make a correction or click the original button to proceed."

    add_assgn4.instructions=@assignments[3][:instructions]
    add_assgn4.due_year=current_year
    add_assgn4.accept_year=current_year
    add_assgn4.grade_scale="Pass"
    
    preview = add_assgn4.preview
    preview.show_student_view
    
    assignments = preview.post
    
    # TEST CASE: Verify assignment 4 appears in the list
    assert assignments.assignments_titles.include?(@assignments[3][:title])

    @sakai.logout
    workspace = @sakai.login(@instructor2, @ipassword2)
    
    home = workspace.open_my_site_by_name @portfolio_site

    assignments = home.assignments

    # TEST CASE: Verify assignments appear as expected.
    assert assignments.assignments_titles.include?(@assignments[0][:title])
    assert assignments.assignments_titles.include?(@assignments[1][:title])
    assert assignments.assignments_titles.include?(@assignments[3][:title])
    assert_equal false, assignments.assignments_titles.include?("Draft - #{@assignments[2][:title]}")

    permissions = assignments.permissions
    permissions.check_evaluators_share_drafts
    permissions.check_organizers_share_drafts
    
    assignments = permissions.save
    
    # TEST CASE: Verify the draft shows in the list
    assert assignments.assignments_titles.include?("Draft - #{@assignments[2][:title]}")
    
    assignment3 = assignments.edit_assignment("Draft - #{Regexp.escape(@assignments[2][:title])}")
    assignment3.post
    
    # TEST CASE: Verify the list has updated properly
    assert_equal false, assignments.assignments_titles.include?("Draft - #{@assignments[2][:title]}")
    assert assignments.assignments_titles.include?(@assignments[2][:title])

    home = assignments.home

    # TEST CASE: Verify the announcement appears as expected
    assert home.announcements_list.include?("Assignment: Open Date for '#{@assignments[2][:title]}'")

    assignments = home.assignments
    
    add_assgn5 = assignments.add
    add_assgn5.instructions=@assignments[4][:instructions]
    add_assgn5.title=@assignments[4][:title]
    add_assgn5.grade_scale="Checkmark"
    
    attach = add_assgn5.add_attachments
    attach.upload_local_file @assignments[4][:file]
    
    add_assgn5 = attach.continue
    
    assignments = add_assgn5.save_draft
    
    # TEST CASE: Verify list shows draft
    assert assignments.assignments_titles.include?("Draft - #{@assignments[4][:title]}")

    @sakai.logout

    workspace = @sakai.login(@instructor, @ipassword)
    
    home = workspace.open_my_site_by_name @portfolio_site

    # TEST CASE: Verify Announcements does not include Assignment 5
    assert_equal false, home.announcements_list.include?("Assignment: Open Date for #{@assignments[4][:title]}")

    assignments = home.assignments

    # TEST CASE: Verify list shows expected Assignments
    assert assignments.assignments_titles.include?(@assignments[0][:title])
    assert assignments.assignments_titles.include?(@assignments[1][:title])
    assert assignments.assignments_titles.include?(@assignments[2][:title])
    assert assignments.assignments_titles.include?(@assignments[3][:title])
    assert assignments.assignments_titles.include?("Draft - #{@assignments[4][:title]}")

    assignment1 = assignments.edit_assignment @assignments[0][:title]
    assignment1.instructions=@assignments[0][:instructions]
    assignment1.grade_scale="Letter grade"
    
    assignments = assignment1.post
    assignments = assignments.delete_assignment @assignments[0][:title]

    # TEST CASE: Verify assignnment 1 is deleted but the others remain
    assert_equal false, assignments.assignments_titles.include?(@assignments[0][:title])
    assert assignments.assignments_titles.include?(@assignments[1][:title])
    assert assignments.assignments_titles.include?(@assignments[2][:title])
    assert assignments.assignments_titles.include?(@assignments[3][:title])
    assert assignments.assignments_titles.include?("Draft - #{@assignments[4][:title]}")

    assignments = assignments.duplicate_assignment @assignments[1][:title]

    # TEST CASE: Verify duplication
    assert assignments.assignments_titles.include?("Draft - #{@assignments[1][:title]} - Copy")

    assignment1 = assignments.edit_assignment "Draft - #{@assignments[1][:title]} - Copy"
    assignment1.title=@assignments[0][:title]

    assignments = assignment1.post
  
    # TEST CASE: Verify assignments list
    assert assignments.assignments_titles.include?(@assignments[0][:title])
    assert assignments.assignments_titles.include?(@assignments[1][:title])
    assert assignments.assignments_titles.include?(@assignments[2][:title])
    assert assignments.assignments_titles.include?(@assignments[3][:title])
    assert assignments.assignments_titles.include?("Draft - #{@assignments[4][:title]}")

    reorder = assignments.reorder
    reorder.sort_by_title
    
    assignments = reorder.save
    
    # TEST CASE: Verify the reorder happened
    assert_equal assignments.assignment_list[0], @assignments[0][:title]

    @sakai.logout

    workspace = @sakai.login(@student, @spassword)

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
    assignment3.select_file 
    
    confirm = assignment3.submit

    assignments = confirm.back_to_list
    
    # TEST CASE: Verify assignment has submitted status
    assert_not_equal false, assignments.status_of(@assignments[2][:title])=~/Submitted/

    @sakai.logout

    workspace = @sakai.login(@instructor, @ipassword)
    
    home = workspace.open_my_site_by_name @portfolio_site
    
    assignments = home.assignments
    
    submissions_list = assignments.grade @assignments[0][:title]
    
    grade_assignment = submissions_list.grade "#{@config.directory['person1']['lastname']}, #{@config.directory['person1']['firstname']} (#{@config.directory['person1']['id']})"
    sleep 4 #FIXME
    grade_assignment.instructor_comments=@assignments[0][:instructor_comment1]
    grade_assignment.remove_assignment_text
    grade_assignment.assignment_text=@assignments[0][:instructor_text]    
    attach = grade_assignment.add_attachments

    attach.url=@assignments[0][:url]
    attach.add

    grade_assignment = attach.continue
    grade_assignment.select_default_grade="B+"
    grade_assignment.save_and_dont_release
    
    submissions_list = grade_assignment.return_to_list
    submissions_list.release_grades
    
    grade_assignment = submissions_list.grade "#{@config.directory['person1']['lastname']}, #{@config.directory['person1']['firstname']} (#{@config.directory['person1']['id']})"
    grade_assignment.check_allow_resubmission
    grade_assignment.return_to_list
    
    @sakai.logout

    workspace = @sakai.login(@student, @spassword)
    
    home = workspace.open_my_site_by_name @portfolito_site
    
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
    
    @sakai.logout

    workspace = @sakai.login(@instructor, @ipassword)

    home = workspace.open_my_site_by_name @portfolito_site
    
    assignments = home.assignments
    
    submissions_list = assignments.grade @assignments[0][:title]
    
    # TEST CASE: Verify resubmission status
    assert_not_equal false, submissions_list.submission_status_of("#{@config.directory['person1']['lastname']}, #{@config.directory['person1']['firstname']} (#{@config.directory['person1']['id']})")=~/Re-submitted/

    grade_assignment = submissions_list.grade "#{@config.directory['person1']['lastname']}, #{@config.directory['person1']['firstname']} (#{@config.directory['person1']['id']})"
    grade_assignment.instructor_comments=@assignments[0][:instructor_comment2]
    grade_assignment.select_default_grade="A"
    grade_assignment.save_and_dont_release
    
    submissions_list = grade_assignment.return_to_list
    submissions_list.release_grades
    
    @sakai.logout

    workspace = @sakai.login(@student, @spassword)
    
    home = workspace.open_my_site_by_name @portfolito_site
    
    assignments = home.assignments
    assignment_1 = assignments.open_assignment @assignments[0][:title]
    
    # TEST CASE: Verify instructor's comments are as expected
    assert_equal assignment_1.instructor_comments, @assignments[0][:instructor_comment2]
    
    @sakai.logout
  end
end
