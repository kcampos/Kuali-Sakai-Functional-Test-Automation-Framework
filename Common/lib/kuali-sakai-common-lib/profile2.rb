#================
# Profile2 Pages
#================

module Profile2Nav

  def preferences
    frm.link(:class=>"icon preferences").click
    Profile2Preferences.new @browser
  end

  def privacy
    frm.link(:text=>"Privacy").click
    Profile2Privacy.new @browser
  end

  def my_profile
    frm.link(:text=>"My profile").click
    Profile2.new(@browser)
  end

  def connections
    frm.link(:class=>"icon connections").click
    Profile2Connections.new @browser
  end

  def pictures
    frm.link(:text=>"Pictures").click
    Profile2Pictures.new @browser
  end

  def messages
    frm.link(:text=>"Messages").click
    Profile2Messages.new @browser
  end

  def search_for_connections
    frm.link(:class=>"icon search").click
    Profile2Search.new @browser
  end

end

module Profile2Methods
  include PageObject
  def edit_basic_info
    frm.div(:id=>"mainPanel").span(:text=>"Basic Information").fire_event("onmouseover")
    frm.div(:id=>"mainPanel").link(:href=>/myInfo:editButton/).click
    sleep 0.5
    Profile2.new @browser
  end

  def edit_contact_info
    frm.div(:id=>"mainPanel").span(:text=>"Contact Information").fire_event("onmouseover")
    frm.div(:id=>"mainPanel").link(:href=>/myContact:editButton/).click
    sleep 0.5
    Profile2.new @browser
  end

  def edit_staff_info
    frm.div(:id=>"mainPanel").span(:text=>"Staff Information").fire_event("onmouseover")
    frm.div(:id=>"mainPanel").link(:href=>/myStaff:editButton/).click
    sleep 0.5
    Profile2.new @browser
  end

  def edit_student_info
    frm.div(:id=>"mainPanel").span(:text=>"Student Information").fire_event("onmouseover")
    frm.div(:id=>"mainPanel").link(:href=>/myStudent:editButton/).click
    sleep 0.5
    Profile2.new @browser
  end

  def edit_social_networking
    frm.div(:id=>"mainPanel").span(:text=>"Social Networking").fire_event("onmouseover")
    frm.div(:id=>"mainPanel").link(:href=>/mySocialNetworking:editButton/).click
    sleep 0.5
    Profile2.new @browser
  end

  def edit_personal_info
    frm.div(:id=>"mainPanel").span(:text=>"Personal Information").fire_event("onmouseover")
    frm.div(:id=>"mainPanel").link(:href=>/myInterests:editButton/).click
    sleep 0.5
    Profile2.new @browser
  end

  def change_picture
    frm.div(:id=>"myPhoto").fire_event("onmouseover")
    frm.div(:id=>"myPhoto").link(:class=>"edit-image-button").click
    sleep 0.5
    Profile2.new @browser
  end

  # Enters the specified filename in the file field.
  #
  # Note that the file should be inside the data/sakai-cle-test-api folder.
  # The file or folder name used for the filename variable
  # should not include a preceding slash ("/") character.
  def image_file=(filename)
    frm.file_field(:name=>"picture").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle-test-api/" + filename)
  end

  def upload
    frm.button(:value=>"Upload").click
    sleep 0.5
    Profile2.new @browser
  end

  def personal_summary=(text)
    frm.frame(:id=>"id1a_ifr").send_keys([:command, 'a'], :backspace)
    frm.frame(:id=>"id1a_ifr").send_keys(text)
  end

  def birthday(day, month, year)
    frm.text_field(:name=>"birthdayContainer:birthday").click
    frm.select(:class=>"ui-datepicker-new-year").wait_until_present
    frm.select(:class=>"ui-datepicker-new-year").select(year.to_i)
    frm.select(:class=>"ui-datepicker-new-month").select(month)
    frm.link(:text=>day.to_s).click
  end

  def save_changes
    frm.button(:value=>"Save changes").click
    Profile2.new @browser
  end

  # Returns the number (as a string) displayed next to
  # the "Connections" link in the menu. If there are no
  # connections then returns zero as a string object.
  def connection_requests
    begin
      frm.link(:class=>/icon connections/).span(:class=>"new-items-count").text
    rescue
      return "0"
    end
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:say_something, :id=>"id1", :frame=>frame)
    button(:say_it, :value=>"Say it", :frame=>frame)
    # Basic Information
    text_field(:nickname, :name=>"nicknameContainer:nickname", :frame=>frame)
    # Contact Information
    text_field(:email, :name=>"emailContainer:email", :frame=>frame)
    text_field(:home_page, :name=>"homepageContainer:homepage", :frame=>frame)
    text_field(:work_phone, :name=>"workphoneContainer:workphone", :frame=>frame)
    text_field(:home_phone, :name=>"homephoneContainer:homephone", :frame=>frame)
    text_field(:mobile_phone, :name=>"mobilephoneContainer:mobilephone", :frame=>frame)
    text_field(:facsimile, :name=>"facsimileContainer:facsimile", :frame=>frame)
    # Someday Staff Info fields should go here...

    # Student Information
    text_field(:degree_course, :name=>"courseContainer:course", :frame=>frame)
    text_field(:subjects, :name=>"subjectsContainer:subjects", :frame=>frame)
    # Social Networking

    # Personal Information
    text_area(:favorite_books, :name=>"booksContainer:favouriteBooks", :frame=>frame)
    text_area(:favorite_tv_shows, :name=>"tvContainer:favouriteTvShows", :frame=>frame)
    text_area(:favorite_movies, :name=>"moviesContainer:favouriteMovies", :frame=>frame)
    text_area(:favorite_quotes, :name=>"quotesContainer:favouriteQuotes", :frame=>frame)
  end

end

module Profile2PreferencesMethods
  include PageObject
  def save_settings
    frm.button(:value=>"Save settings").click
    Profile2Preferences.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|

  end
end

#
module Profile2PrivacyMethods
  include PageObject

  in_frame(:class=>"portletMainIframe") do |frame|

    select_list(:profile_image, :name=>"profileImageContainer:profileImage", :frame=>frame)
    select_list(:basic_info, :name=>"basicInfoContainer:basicInfo", :frame=>frame)
    select_list(:contact_info, :name=>"contactInfoContainer:contactInfo", :frame=>frame)
    select_list(:staff_info, :name=>"staffInfoContainer:staffInfo", :frame=>frame)
    select_list(:student_info, :name=>"studentInfoContainer:studentInfo", :frame=>frame)
    select_list(:social_info, :name=>"socialNetworkingInfoContainer:socialNetworkingInfo", :frame=>frame)
    select_list(:personal_info, :name=>"personalInfoContainer:personalInfo", :frame=>frame)
    select_list(:view_connections, :name=>"myFriendsContainer:myFriends", :frame=>frame)
    select_list(:see_status, :name=>"myStatusContainer:myStatus", :frame=>frame)
    select_list(:view_pictures, :name=>"myPicturesContainer:myPictures", :frame=>frame)
    select_list(:send_messages, :name=>"messagesContainer:messages", :frame=>frame)
    select_list(:see_kudos_rating, :name=>"myKudosContainer:myKudos", :frame=>frame)
    checkbox(:show_birth_year, :name=>"birthYearContainer:birthYear", :frame=>frame)
    button(:save_settings, :value=>"Save settings", :frame=>frame)

  end
end

#
module Profile2SearchMethods
  include PageObject
  def search_by_name_or_email
    frm.button(:value=>"Search by name or email").click
    sleep 0.5
    Profile2Search.new(@browser)
  end

  def search_by_common_interest
    frm.button(:value=>"Search by common interest").click
    sleep 0.5
    Profile2Search.new(@browser)
  end

  def add_as_connection(name)
    frm.div(:class=>"search-result", :text=>/#{Regexp.escape(name)}/).link(:class=>"icon connection-add").click
    frm.div(:class=>"modalWindowButtons").wait_until_present
    frm.div(:class=>"modalWindowButtons").button(:value=>"Add connection").click
    frm.div(:class=>"modalWindowButtons").wait_while_present
    sleep 0.5
    Profile2Search.new @browser
  end

  def view(name)
    frm.link(:text=>name).click
    Profile2View.new(@browser)
  end

  # Returns an array containing strings of the names of the users returned
  # in the search.
  def results
    results = []
    frm.div(:class=>"portletBody").spans.each do |span|
      if span.class_name == "search-result-info-name"
        results << span.text
      end
    end
    return results
  end

  def clear_results
    frm.button(:value=>"Clear results").click
    Profile2Search.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:persons_name_or_email, :name=>"searchName", :frame=>frame)
    text_field(:common_interest, :name=>"searchInterest", :frame=>frame)

  end
end

#
module Profile2ConnectionsMethods
  include PageObject
  def confirm_request(name)
    frm.div(:class=>"connection", :text=>name).link(:title=>"Confirm connection request").click
    frm.div(:class=>"modalWindowButtons").wait_until_present
    frm.div(:class=>"modalWindowButtons").button(:value=>"Confirm connection request").click
    frm.div(:class=>"modalWindowButtons").wait_while_present
    sleep 0.5
    Profile2Connections.new @browser
  end

  # Returns an array containing the names of the connected users.
  def connections
    results = []
    frm.div(:class=>"portletBody").spans.each do |span|
      if span.class_name == "connection-info-name"
        results << span.text
      end
    end
    return results
  end

  in_frame(:class=>"portletMainIframe") do |frame|

  end
end

#
module Profile2ViewMethods

  #
  def connection
    frm.div(:class=>"leftPanel").span(:class=>/instruction icon/).text
  end

  #
  def basic_information
    hash = {}
    begin
      frm.div(:class=>"mainSection", :text=>/Basic Information/).table(:class=>"profileContent").rows.each do |row|
        hash.store(row[0].text, row[1].text)
      end
    rescue Watir::Exception::UnknownObjectException

    end
    return hash
  end

  #
  def contact_information
    hash = {}
    begin
      frm.div(:class=>"mainSection", :text=>/Contact Information/).table(:class=>"profileContent").rows.each do |row|
        hash.store(row[0].text, row[1].text)
      end
    rescue Watir::Exception::UnknownObjectException

    end
    return hash
  end

  #
  def staff_information
    hash = {}
    begin
      frm.div(:class=>"mainSection", :text=>/Staff Information/).table(:class=>"profileContent").rows.each do |row|
        hash.store(row[0].text, row[1].text)
      end
    rescue Watir::Exception::UnknownObjectException

    end
    return hash
  end

  #
  def student_information
    hash = {}
    begin
      frm.div(:class=>"mainSection", :text=>/Student Information/).table(:class=>"profileContent").rows.each do |row|
        hash.store(row[0].text, row[1].text)
      end
    rescue Watir::Exception::UnknownObjectException

    end
    return hash
  end

  #
  def personal_information
    hash = {}
    begin
      frm.div(:class=>"mainSection", :text=>/Personal Information/).table(:class=>"profileContent").rows.each do |row|
        hash.store(row[0].text, row[1].text)
      end
    rescue Watir::Exception::UnknownObjectException

    end
    return hash
  end

end