# ToolsMenu contains all possible links that could
# be found in the menu along the left side of the Sakai pages.
#
# This includes both the Administration Workspace and the
# Menus that appear when in the context of a particular Site.
module ToolsMenu

  include PageObject
  # Opens the "My Sites" menu box and then clicks on the link
  # that matches the specified id.
  #
  # Errors out if nothing matches.
  def open_my_site_by_id(id)
    @browser.link(:text, "My Sites").click
    @browser.link(:href, /#{id}/).click
    $frame_index=1
    Home.new(@browser)
  end

  # Opens "My Sites" and then clicks on the matching
  # Site name. Shortens the name used for search so
  # that truncated names are not a problem.
  #
  # Will error out if there are not matching links.
  def open_my_site_by_name(name)
    short_name = name[0..19]
    @browser.link(:text, "My Sites").click
    @browser.link(:text, /#{Regexp.escape(short_name)}/).click
    $frame_index=1
    Home.new(@browser)
  end

  # Clicks the "Account" link in the Adminstration Workspace
  # then instantiates the UserAccount class.
  #
  # Throws an error if the link is not present.
  def account
    @browser.link(:text=>"Account").click
    UserAccount.new(@browser)
  end

  # Clicks the "Aliases" link in the Administration Workspace
  # menu, then instantiates the Aliases class.
  def aliases
    @browser.link(:text=>"Aliases").click
    Aliases.new(@browser)
  end

  # Clicks the link for the Administration Workspace, then
  # instantiates the MyWorkspace class.
  def administration_workspace
    @browser.link(:text, "Administration Workspace").click
    $frame_index=1
    MyWorkspace.new(@browser)
  end

  # Clicks the Announcements link then instantiates
  # the Announcements class.
  def announcements
    @browser.link(:class=>'icon-sakai-announcements').click
    Announcements.new(@browser)
  end

  # Clicks the Assignments link, then instantiates
  # the Assignments class.
  def assignments
    @browser.link(:class=>"icon-sakai-assignment-grades").click
    AssignmentsList.new(@browser)
  end

  def basic_lti
    @browser.link(:class=>"icon-sakai-basiclti").click
    BasicLTI.new(@browser)
  end

  def blogs
    @browser.link(:class=>"icon-sakai-blogwow").click
    Blogs.new(@browser)
  end

  # Clicks the Blogger link in the Site menu and
  # instantiates the Blogger Class.
  def blogger
    @browser.link(:class=>"icon-blogger").click
    Blogger.new(@browser)
  end

  # Clicks the Calendar link, then instantiates
  # the Calendar class.
  def calendar
    @browser.link(:text=>"Calendar").click
    Calendar.new(@browser)
  end

  link(:certification, :text=>"Certification")

  def chat_room
    @browser.link(:class=>"icon-sakai-chat").click
    ChatRoom.new(@browser)
  end

  link(:configuration_viewer, :text=>"Configuration Viewer")
  link(:customizer, :text=>"Customizer")

  # Clicks the "Discussion Forums" link in the menu,
  # then instantiates the JForum page class.
  def discussion_forums
    @browser.link(:class=>"icon-sakai-jforum-tool").click
    JForums.new(@browser)
  end

  def drop_box
    @browser.link(:class=>"icon-sakai-dropbox").click
    DropBox.new(@browser)
  end

  link(:email, :text=>"Email")

  def email_archive
    @browser.link(:class=>"icon-sakai-mailbox").click
    EmailArchive.new(@browser)
  end

  link(:email_template_administration, :text=>"Email Template Administration")

  def evaluation_system
    @browser.link(:class=>"icon-sakai-rsf-evaluation").click
    EvaluationSystem.new(@browser)
  end

  def feedback
    @browser.link(:class=>"icon-sakai-postem").click
    Feedback.new(@browser)
  end

  # Clicks the Forms link that is found in menus for
  # Portfolio sites.
  def forms
    @browser.link(:text=>"Forms", :class=>"icon-sakai-metaobj").click
    Forms.new(@browser)
  end

  # Clicks the Forums link, then instantiates
  # the forums class.
  def forums
    @browser.link(:text=>"Forums").click
    Forums.new(@browser)
  end

  # Clicks the Glossary link, then instantiates the Glossary Class.
  def glossary
    @browser.link(:text=>"Glossary").click
    Glossary.new(@browser)
  end

  # Clicks the "Gradebook" link, then
  # instantiates the Gradebook Class.
  def gradebook
    @browser.link(:text=>"Gradebook").click
    Gradebook.new(@browser)
  end

  def gradebook2
    @browser.link(:text=>"Gradebook2").click
    frm.div(:id=>"borderLayoutContainer").wait_until_present
    Gradebook2.new(@browser)
  end

  link(:help, :text=>"Help")

  # Clicks the Home link, then instantiates the
  # Home class--unless the target page happens to be
  # My Workspace, in which case the MyWorkspace
  # page is instantiated.
  def home
    @browser.link(:text, "Home").click
    if @browser.div(:id=>"siteTitle").text == "My Workspace"
      MyWorkspace.new(@browser)
    else
      Home.new(@browser)
    end
  end

  # Clicks the Job Scheduler link, then
  # instantiates the Job Scheduler class.
  def job_scheduler
    @browser.link(:text=>"Job Scheduler").click
    JobScheduler.new(@browser)
  end

  # Clicks the Lessons link, then instantiates
  # the Lessons class.
  def lessons
    @browser.link(:text=>"Lessons").click
    Lessons.new(@browser)
  end

  link(:lesson_builder, :text=>"Lesson Builder")
  link(:link_tool, :text=>"Link Tool")
  link(:live_virtual_classroom, :text=>"Live Virtual Classroom")

  # Clicks the "Matrices" link, then
  # instantiates the Matrices Class.
  def matrices
    @browser.link(:text=>"Matrices").click
    Matrices.new(@browser)
  end

  def media_gallery
    @browser.link(:class=>"icon-sakai-kaltura").click
    MediaGallery.new(@browser)
  end

  link(:membership, :text=>"Membership")
  link(:memory, :text=>"Memory")

  # Clicks the Messages link, then instantiates the Messages class.
  def messages
    @browser.link(:text=>"Messages").click
    Messages.new(@browser)
  end

  link(:my_sites, :text=>"My Sites")

  # Clicks the "My Workspace" link, sets the
  # $frame_index global variable to 0, then instantiates
  # the MyWorkspace Class.
  def my_workspace
    @browser.link(:text=>"My Workspace").click
    $frame_index=0
    MyWorkspace.new(@browser)
  end

  def news
    @browser.link(:class=>"icon-sakai-news").click
    News.new(@browser)
  end

  link(:online, :text=>"On-Line")
  link(:oauth_providers, :text=>"Oauth Providers")
  link(:oauth_tokens, :text=>"Oauth Tokens")
  link(:openSyllabus, :text=>"OpenSyllabus")

  def podcasts
    @browser.link(:class=>"icon-sakai-podcasts").click
    Podcasts.new(@browser)
  end

  def polls
    @browser.link(:class=>"icon-sakai-poll").click
    Polls.new(@browser)
  end

  def portfolios
    @browser.link(:class=>"icon-osp-presentation").click
    Portfolios.new @browser
  end

  # Clicks the Portfolio Templates link, then
  # instantiates the Portfolio
  def portfolio_templates
    @browser.link(:text=>"Portfolio Templates").click
    PortfolioTemplates.new(@browser)
  end

  link(:preferences, :text=>"Preferences")

  def profile
    @browser.link(:text=>"Profile").click
    Profile.new @browser
  end

  def profile2
    @browser.link(:class=>"icon-sakai-profile2").click
    Profile2.new @browser
  end

  link(:realms, :text=>"Realms")

  # Clicks the Resources link, then instantiates
  # the Resources class.
  def resources
    @browser.link(:text, "Resources").click
    Resources.new(@browser)
  end

  def roster
    @browser.link(:class=>"icon-sakai-site-roster").click
    Roster.new @browser
  end

  link(:rsmart_support, :text=>"rSmart Support")

  # Because "Search" is used in many pages,
  # The Search button found in the Site Management
  # Menu must be given the more explicit name
  #
  def site_management_search
    @browser.link(:class=>"icon-sakai-search").click
  end

  def sections
    @browser.link(:class=>"icon-sakai-sections").click
    Sections.new(@browser)
  end

  link(:site_archive, :text=>"Site Archive")

  # Clicks the Site Editor link, then instantiates
  # the Site Editor class.
  def site_editor
    @browser.link(:text=>"Site Editor").click
    SiteEditor.new(@browser)
  end

  # Clicks the Site Setup link, then instantiates
  # The SiteEditor class.
  def site_setup
    @browser.link(:text=>"Site Setup").click
    SiteSetup.new(@browser)
  end

  link(:site_statistics, :text=>"Site Statistics")

  # Clicks the Sites link, then instantiates
  # the Sites class.
  def sites
    @browser.link(:class=>"icon-sakai-sites").click
    frm.text_field(:id=>"search_site").wait_until_present
    Sites.new(@browser)
  end

  link(:skin_manager, :text=>"Skin Manager")
  link(:super_user, :text=>"Super User")

  def styles
    @browser.link(:text=>"Styles").click
    Styles.new(@browser)
  end

  # Clicks the Syllabus link, then instantiates
  # the Syllabus class.
  def syllabus
    @browser.link(:text=>"Syllabus").click
    Syllabus.new(@browser)
  end

  # Clicks the Tests & Quizzes link, then
  # instantiates the AssessmentsList class.
  def tests_and_quizzes
    # Need this logic to determine whether user
    # is a student or instructor/admin
    @browser.link(:class, "icon-sakai-siteinfo").exist? ? x=0 : x=1
    @browser.link(:text=>"Tests & Quizzes").click
    x==0 ? AssessmentsList.new(@browser) : TakeAssessmentList.new(@browser)
  end

  # Synonym for tests_and_quizzes method.
  def assessments
    tests_and_quizzes
  end

  def user_membership
    @browser.link(:class=>"icon-sakai-usermembership").click
    UserMembership.new(@browser)
  end

  def users
    @browser.link(:class=>"icon-sakai-users").click
    Users.new(@browser)
  end

  def web_content
    @browser.link(:class=>"icon-sakai-iframe").click
    WebContent.new(@browser)
  end

  def wiki
    @browser.link(:class=>"icon-sakai-rwiki").click
    Wikis.new(@browser)
  end

  # The Page Reset button, found on all Site pages
  def reset
    @browser.link(:href=>/tool-reset/).click
    page_title = @browser.div(:class=>"title").text
    case(page_title)
      when "Lessons"
        Lessons.new(@browser)
      when "Syllabus"
        Syllabus.new(@browser)
      when "Portfolios"
        Portfolios.new @browser
      # Add more cases here, as necessary...
    end
  end

  # Clicks the "(Logout)" link in the upper right of the page.
  # Instantiates the Login class.
  def logout
    @browser.link(:text, "Logout").click
    Login.new(@browser)
  end
  alias log_out logout
  alias sign_out logout

  private

  # Shortcut method so you don't have to type out
  # the whole string: @browser.frame(:index=>index)
  def frm
    @browser.frame(identifier)
  end

end
