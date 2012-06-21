#================
# Sections Pages for a Site
#================

module SectionsMenu
  include PageObject
  # Clicks the Add Sections button/link and instantiates
  # the AddEditSections Class.
  def add_sections
    frm.link(:text=>"Add Sections").click
    AddEditSections.new(@browser)
  end

  def overview
    frm.link(:text=>"Overview").click
    Sections.new(@browser)
  end

  def student_memberships
    frm.link(:text=>"Student Memberships").click
    StudentMemberships.new(@browser)
  end

  def options
    frm.link(:text=>"Options").click
    SectionsOptions.new(@browser)
  end

end

# Topmost page for Sections in Site Management
module SectionsMethods
  include PageObject
  # Clicks the Edit link for the specified section.
  # Then instantiates the AddEditSections class.
  def edit(title)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(title)}/).link(:text=>/Edit/).click
    AddEditSections.new(@browser)
  end

  def assign_tas(title)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(title)}/).link(:text=>/Assign TAs/).click
    AssignTeachingAssistants.new(@browser)
  end

  def assign_students(title)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(title)}/).link(:text=>/Assign Students/).click
    AssignStudents.new(@browser)
  end

  def check(title)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(title)}/).checkbox(:name=>/remove/).set
  end

  def section_names
    names = []
    frm.table(:class=>/listHier/).rows.each do |row|
      if row.td(:class=>"leftIndent").exist?
        names << row.td(:class=>"leftIndent").div(:index=>0).text
      end
    end
    return names
  end

  def remove_sections
    frm.button(:value=>"Remove Sections").click
    Sections.new(@browser)
  end

  # Returns the text of the Teach Assistant cell for the specified
  # Section.
  def tas_for(title)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(title)}/)[1].text
  end

  #
  def days_for(title)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(title)}/)[2].text
  end

  #
  def time_for(title)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(title)}/)[3].text
  end

  #
  def location_for(title)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(title)}/)[4].text
  end

  #
  def current_size_for(title)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(title)}/)[5].text
  end

  #
  def availability_for(title)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(title)}/)[6].text
  end

  def alert_text
    frm.div(:class=>"validation").text
  end

  def success_text
    frm.div(:class=>"success").text
  end

end

# Methods in this class currently do not support
# adding multiple instances of sections simultaneously.
# That will be added at some future time.
# The same goes for adding days with different meeting times. This will hopefully
# be supported in the future.
module AddEditSectionsMethods
  include PageObject
  # Clicks the Add Sections button then instantiates the Sections Class,
  # unless there's an Alert message, in which case it will reinstantiate
  # the class.
  def add_sections
    frm.button(:value=>"Add Sections").click
    if frm.div(:class=>"validation").exist?
      AddEditSections.new(@browser)
    else
      Sections.new(@browser)
    end
  end

  def alert_text
    frm.div(:class=>"validation").text
  end

  # The Update button is only available when editing an existing Sections record.
  def update
    frm.button(:value=>"Update").click
    if frm.div(:class=>"validation").exist?
      AddEditSections.new(@browser)
    else
      Sections.new(@browser)
    end
  end

  # This method takes an array object containing strings of the
  # days of the week and then clicks the appropriate checkboxes, based
  # on those strings.
  def check_days(array)
    frm.checkbox(:id=>/SectionsForm:sectionTable:0:meetingsTable:0:monday/).set if array.include?(/mon/i)
    frm.checkbox(:id=>/SectionsForm:sectionTable:0:meetingsTable:0:tuesday/).set if array.include?(/tue/i)
    frm.checkbox(:id=>/SectionsForm:sectionTable:0:meetingsTable:0:wednesday/).set if array.include?(/wed/i)
    frm.checkbox(:id=>/SectionsForm:sectionTable:0:meetingsTable:0:thursday/).set if array.include?(/thu/i)
    frm.checkbox(:id=>/SectionsForm:sectionTable:0:meetingsTable:0:friday/).set if array.include?(/fri/i)
    frm.checkbox(:id=>/SectionsForm:sectionTable:0:meetingsTable:0:saturday/).set if array.include?(/sat/i)
    frm.checkbox(:id=>/SectionsForm:sectionTable:0:meetingsTable:0:sunday/).set if array.include?(/sun/i)
  end

  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
      select_list(:category, :id=>/SectionsForm:category/, :frame=>frame)
      text_field(:name, :id=>/SectionsForm:sectionTable:0:titleInput/, :frame=>frame)
      checkbox(:monday, :id=>/SectionsForm:sectionTable:0:meetingsTable:0:monday/, :frame=>frame)
      checkbox(:tuesday, :id=>/SectionsForm:sectionTable:0:meetingsTable:0:tuesday/, :frame=>frame)
      checkbox(:wednesday, :id=>/SectionsForm:sectionTable:0:meetingsTable:0:wednesday/, :frame=>frame)
      checkbox(:thursday, :id=>/SectionsForm:sectionTable:0:meetingsTable:0:thursday/, :frame=>frame)
      checkbox(:friday, :id=>/SectionsForm:sectionTable:0:meetingsTable:0:friday/, :frame=>frame)
      checkbox(:saturday, :id=>/SectionsForm:sectionTable:0:meetingsTable:0:saturday/, :frame=>frame)
      checkbox(:sunday, :id=>/SectionsForm:sectionTable:0:meetingsTable:0:sunday/, :frame=>frame)
      text_field(:start_time, :id=>/SectionsForm:sectionTable:0:meetingsTable:0:startTime/, :frame=>frame)
      text_field(:end_time, :id=>/SectionsForm:sectionTable:0:meetingsTable:0:endTime/, :frame=>frame)
      text_field(:location, :id=>/SectionsForm:sectionTable:0:meetingsTable:0:location/, :frame=>frame)
      radio_button(:startAM) { |page| page.radio_button_element(:name=>/SectionsForm:sectionTable:0:meetingsTable:0:startTimeAm/, :index=>0, :frame=>frame) }
      radio_button(:startPM) { |page| page.radio_button_element(:name=>/SectionsForm:sectionTable:0:meetingsTable:0:startTimeAm/, :index=>1, :frame=>frame) }
      radio_button(:endAM) { |page| page.radio_button_element(:name=>/SectionsForm:sectionTable:0:meetingsTable:0:endTimeAm/, :index=>0, :frame=>frame) }
      radio_button(:endPM) { |page| page.radio_button_element(:name=>/SectionsForm:sectionTable:0:meetingsTable:0:endTimeAm/, :index=>1, :frame=>frame) }
      radio_button(:unlimited_students) { |page| page.radio_button_element(:name=>/SectionsForm:sectionTable:0:limit/, :index=>0, :frame=>frame) }
      radio_button(:limited_students) { |page| page.radio_button_element(:name=>/SectionsForm:sectionTable:0:limit/, :index=>1, :frame=>frame) }
      text_field(:max_students, :id=>/SectionsForm:sectionTable:0:maxEnrollmentInput/, :frame=>frame)
    end
  end
end

#
module AssignTeachingAssistantsMethods
  include PageObject
  def assign_TAs
    frm.button(:value=>"Assign TAs").click
    Sections.new(@browser)
  end

  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
      select_list(:available_tas, :id=>"memberForm:availableUsers", :frame=>frame)
      select_list(:assigned_tas, :id=>"memberForm:selectedUsers", :frame=>frame)
      button(:assign, :value=>">", :frame=>frame)
      button(:unassign, :value=>"<", :frame=>frame)
      button(:assign_all, :value=>">>", :frame=>frame)
      button(:unassign_all, :value=>"<<", :frame=>frame)
    end
  end
end

#
module AssignStudentsMethods
  include PageObject
  def assign_students
    frm.button(:value=>"Assign students").click
    Sections.new(@browser)
  end

  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
      select_list(:available_students, :id=>"memberForm:availableUsers", :frame=>frame)
      select_list(:assigned_students, :id=>"memberForm:selectedUsers", :frame=>frame)
      button(:assign, :value=>">", :frame=>frame)
      button(:unassign, :value=>"<", :frame=>frame)
      button(:assign_all, :value=>">>", :frame=>frame)
      button(:unassign_all, :value=>"<<", :frame=>frame)
    end
  end
end

# The Options page for Sections.
module SectionsOptionsMethods
  include PageObject
  def update
    frm().button(:value=>"Update").click
    Sections.new(@browser)
  end

  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
      checkbox(:students_can_sign_up, :id=>"optionsForm:selfRegister", :frame=>frame)
      checkbox(:students_can_switch, :id=>"optionsForm:selfSwitch", :frame=>frame)
    end
  end

end