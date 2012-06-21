module SyllabusMethods

  # Clicks the "Create/Edit" button on the page,
  # then instantiates the SyllabusEdit class.
  def create_edit
    frm.link(:text=>"Create/Edit").click
    SyllabusEdit.new(@browser)
  end

  # Clicks the "Add" button, then
  # instantiates the AddEditSyllabusItem Class.
  def add
    frm.link(:text=>"Add").click
    AddEditSyllabusItem.new(@browser)
  end

  def attachments_list
    list = []
    frm.div(:class=>"portletBody").links.each { |link| list << link.text }
    return list
  end

end

module SyllabusEditMethods

  # Clicks the "Add" button, then
  # instantiates the AddEditSyllabusItem Class.
  def add
    frm.link(:text=>"Add").click
    AddEditSyllabusItem.new(@browser)
  end

  def redirect
    frm.link(:text=>"Redirect").click
    SyllabusRedirect.new(@browser)
  end

  # Returns the text of the page header
  def header
    frm.div(:class=>"portletBody").h3.text
  end

  # Clicks the checkbox for the item with the
  # specified title.
  def check_title(title)
    index=syllabus_titles.index(title)
    frm.checkbox(:index=>index).set
  end

  #
  def move_title_up(title)
    #FIXME
  end

  #
  def move_title_down(title)
    #FIXME
  end

  # Clicks the "Update" button and instantiates
  # the DeleteSyllabusItems Class.
  def update
    frm.button(:value=>"Update").click
    DeleteSyllabusItems.new(@browser)
  end

  # Opens the specified item and instantiates the XXXX Class.
  def open_item(title)
    frm.link(:text=>title).click
    Class.new(@browser)
  end

  # Returns an array containing the titles of the syllabus items
  # displayed on the page.
  def syllabus_titles
    titles = []
    s_table = frm.table(:class=>"listHier lines nolines")
    1.upto(s_table.rows.size-1) do |x|
      titles << s_table[x][0].text
    end
    return titles
  end

end

module AddEditSyllabusItemMethods
  include PageObject
  # Clicks the "Post" button and instantiates
  # the Syllabus Class.
  def post
    frm.button(:value=>"Post").click
    SyllabusEdit.new(@browser)
  end

  # Defines the text area of the FCKEditor that appears on the page for
  # the Syllabus content.
  def editor
    frm.frame(:id, /_textarea___Frame/).td(:id, "xEditingArea").frame(:index=>0)
  end

  # Sends the specified string to the FCKEditor text area on the page.
  def content=(text)
    editor.send_keys(text)
  end

  # Clicks the Add attachments button and instantiates the
  # SyllabusAttach class.
  def add_attachments
    frm.button(:value=>"Add attachments").click
    SyllabusAttach.new(@browser)
  end

  # Returns an array of the filenames in the attachments
  # table
  def files_list
    names = []
    frm.table(:class=>"listHier lines nolines").rows.each do |row|
      if row.td(:class=>"item").exist?
        names << row.td(:class=>"item").h4.text
      end
    end
    return names
  end

  # Clicks the preview button and
  # instantiates the SyllabusPreview class
  def preview
    frm.button(:value=>"Preview").click
    SyllabusPreview.new(@browser)
  end

  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
      text_field(:title, :id=>"_id4:title", :frame=>frame)
      radio_button(:only_members_of_this_site) { |page| page.radio_button_element(:name=>/_id\d+:_id\d+/, :value=>"no", :frame=>frame) }
      radio_button(:publicly_viewable) { |page| page.radio_button_element(:name=>/_id\d+:_id\d+/, :value=>"yes", :frame=>frame) }

    end
  end
end

module SyllabusPreviewMethods
  include PageObject
  def edit
    frm.button(:value=>"Edit").click
    AddEditSyllabusItem.new(@browser)
  end

  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
    end
  end
end

module SyllabusRedirectMethods
  include PageObject
  def save
    frm.button(:value=>"Save").click
    SyllabusEdit.new(@browser)
  end

  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
      text_field(:url, :id=>"redirectForm:urlValue", :frame=>frame)
    end
  end
end

module DeleteSyllabusItemsMethods
  # Clicks the Delete button, then
  # instantiates the CreateEditSyllabus Class.
  def delete
    frm.button(:value=>"Delete").click
    CreateEditSyllabus.new(@browser)
  end

end

module CreateEditSyllabusMethods

end