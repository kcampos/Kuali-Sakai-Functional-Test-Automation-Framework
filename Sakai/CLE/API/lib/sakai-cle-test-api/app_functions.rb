#================
# Page Navigation Objects
#================

# This class consolidates the code that can be shared among all the
# File Upload and Attachment pages.
#
# Not every method in this class will be appropriate for every attachment page.
class AttachPageTools
  
  @@classes = { :this=>"Superclassdummy", :parent=>"Superclassdummy" }
  
  # Use this for debugging purposes only...
  def what_is_parent?
    puts @@classes[:parent]
  end
  
  # Returns an array of the displayed folder names.
  def folder_names
    names = []
    frm.table(:class=>/listHier lines/).rows.each do |row|
      next if row.td(:class=>"specialLink").exist? == false
      next if row.td(:class=>"specialLink").link(:title=>"Folder").exist? == false
      names << row.td(:class=>"specialLink").link(:title=>"Folder").text
    end
    return names
  end
  
  # Returns an array of the file names currently listed
  # on the page.
  # 
  # It excludes folder names.
  def file_names
    names = []
    frm.table(:class=>/listHier lines/).rows.each do |row|
      next if row.td(:class=>"specialLink").exist? == false
      next if row.td(:class=>"specialLink").link(:title=>"Folder").exist?
      names << row.td(:class=>"specialLink").link(:href=>/access.content/, :index=>1).text
    end
    return names
  end
  
  # Clicks the Select button next to the specified file.
  def select_file(filename)
    frm.table(:class=>/listHier lines/).row(:text, /#{Regexp.escape(filename)}/).link(:text=>"Select").click
  end

  # Clicks the Remove button.
  def remove
    frm.button(:value=>"Remove").click
  end
  
  # Clicks the remove link for the specified item in the attachment list.
  def remove_item(file_name)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(file_name)}/).link(:href=>/doRemoveitem/).click
  end
  
  # Clicks the Move button.
  def move
    frm.button(:value=>"Move").click
  end
  
  # Clicks the Show Other Sites link.
  def show_other_sites
    frm.link(:text=>"Show other sites").click
  end
  
  # Clicks on the specified folder image, which
  # will open the folder tree and remain on the page.
  def open_folder(foldername)
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(foldername)}/).link(:title=>"Open this folder").click
  end
  
  # Clicks on the specified folder name, which should open
  # the folder contents on a refreshed page.
  def go_to_folder(foldername)
    frm.link(:text=>foldername).click
  end
  
  # Sets the URL field to the specified value.
  def url=(url_string)
    frm.text_field(:id=>"url").set(url_string)
  end
  
  # Clicks the Add button next to the URL field.
  def add
    frm.button(:value=>"Add").click
  end
  
  # Gets the value of the access level cell for the specified
  # file.
  def access_level(filename) 
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(filename)}/)[6].text
  end
  
  def edit_details(name)
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(name)}/).li(:text=>/Action/, :class=>"menuOpen").fire_event("onclick")
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(name)}/).link(:text=>"Edit Details").click
    instantiate_class(:file_details)
  end
  
  # Clicks the Create Folders menu item in the
  # Add menu of the specified folder.
  def create_subfolders_in(folder_name)
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Start Add Menu").fire_event("onfocus")
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Create Folders").click
    instantiate_class(:create_folders)
  end

  # Enters the specified file into the file field name (assuming it's in the
  # data/sakai-cle-test-api folder or a subfolder therein)
  #
  # Does NOT instantiate any class, so use only when no page refresh occurs.
  def upload_file(filename, filepath="")
    frm.file_field(:id=>"upload").set(filepath + filename)
    if frm.div(:class=>"alertMessage").exist?
      sleep 2
      upload_file(filename)
    end
  end

  # Enters the specified file into the file field name (assuming it's in the
  # data/sakai-cle-test-api folder or a subfolder therein)
  #
  # Use this method ONLY for instances where there's a file field on the page
  # with an "upload" id.
  def upload_local_file(filename, filepath="")
    frm.file_field(:id=>"upload").set(filepath + filename)
    if frm.div(:class=>"alertMessage").exist?
      sleep 2
      upload_local_file(filename)
    end
    instantiate_class(:this)
  end

  # Clicks the Add Menu for the specified
  # folder, then selects the Upload Files
  # command in the menu that appears.
  def upload_file_to_folder(folder_name)
    upload_files_to_folder(folder_name)
  end

  # Clicks the Add Menu for the specified
  # folder, then selects the Upload Files
  # command in the menu that appears.
  def upload_files_to_folder(folder_name)
    if frm.li(:text=>/A/, :class=>"menuOpen").exist?
      frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(folder_name)}/).li(:text=>/A/, :class=>"menuOpen").fire_event("onclick")
    else
      frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Start Add Menu").fire_event("onfocus")
    end
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Upload Files").click
    instantiate_class(:upload_files)
  end
  
  # Clicks the "Attach a copy" link for the specified
  # file, then reinstantiates the Class.
  # If an alert box appears, the method will call itself again.
  # Note that this can lead to an infinite loop. Will need to fix later.
  def attach_a_copy(file_name)
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(file_name)}/).link(:href=>/doAttachitem/).click
    if frm.div(:class=>"alertMessage").exist?
      sleep 1
      attach_a_copy(file_name) # TODO - This can loop infinitely
    end
    instantiate_class(:this)
  end
  
  # Clicks the Create Folders menu item in the
  # Add menu of the specified folder.
  def create_subfolders_in(folder_name)
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Start Add Menu").fire_event("onfocus")
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Create Folders").click
    instantiate_class(:create_folders)
  end
  
  # Takes the specified array object containing pointers
  # to local file resources, then uploads those files to
  # the folder specified, checks if they all uploaded properly and
  # if not, re-tries the ones that failed the first time.
  #
  # Finally, it re-instantiates the appropriate page class.
  # Note that it expects all files to be located in the same folder (can be in subfolders of that folder).
  def upload_multiple_files_to_folder(folder, file_array, file_path="")
    
    upload = upload_files_to_folder folder
    
    file_array.each do |file|
      upload.file_to_upload(file, file_path)
      upload.add_another_file
    end
    
    resources = upload.upload_files_now

    file_array.each do |file|
      file =~ /(?<=\/).+/
      # puts $~.to_s # For debugging purposes
      unless resources.file_names.include?($~.to_s)
        upload_files = resources.upload_files_to_folder(folder)
        upload_files.file_to_upload(file, file_path)
        resources = upload_files.upload_files_now
      end
    end
    instantiate_class(:this)
  end

  # Clicks the Continue button then
  # decides which page class to instantiate
  # based on the page that appears. This is going to need to be fixed.
  def continue
    frm.div(:class=>"highlightPanel").span(:id=>"submitnotifxxx").wait_while_present
    frm.button(:value=>"Continue").click
    page_title = @browser.div(:class=>"title").text
    case(page_title)
    when "Lessons"
      instantiate_class(:parent)
    when "Assignments"
      if frm.div(:class=>"portletBody").h3.text=~/In progress/ || frm.div(:class=>"portletBody").h3.text == "Select supporting files"
        instantiate_class(:second)
      elsif frm.div(:class=>"portletBody").h3.text=~/edit/i || frm.div(:class=>"portletBody").h3.text=~/add/i
        instantiate_class(:parent)
      elsif frm.form(:id=>"gradeForm").exist?
        instantiate_class(:third)
      end
    when "Forums"
      if frm.div(:class=>"portletBody").h3.text == "Forum Settings"
        instantiate_class(:second)
      else
        instantiate_class(:parent)
      end
    when "Messages"
      if frm.div(:class=>/breadCrumb/).text =~ /Reply to Message/
        instantiate_class(:second)
      else
        instantiate_class(:parent)
      end
    when "Calendar"
      frm.frame(:id, "description___Frame").td(:id, "xEditingArea").frame(:index=>0).wait_until_present
      instantiate_class(:parent)
    when "Portfolio Templates"
      if frm.div(:class=>"portletBody").h3.text=="Select supporting files"
        instantiate_class(:second)
      else
        instantiate_class(:parent)
      end
    else
      instantiate_class(:parent)
    end  
  end
  
  private
  
  # This is a private method that is only used inside this superclass.
  def instantiate_class(key)
    eval(@@classes[key]).new(@browser)
  end
  
  # This is another private method--a better way to
  # instantiate the @@classes hash variable.
  def set_classes_hash(hash_object)
    @@classes = hash_object
  end
  
end

# Methods to extend the page-object gem...
module PageObject
  module Elements
    class Element
      
      def disabled?
        @element.disabled?
      end
      
    end
  end
end

# Need this to extend Watir to be able to attach to Sakai's non-standard tags...
module Watir 
  class Element
    # attaches to the "headers" tags inside of the assignments table.
    def headers
      @how = :ole_object 
      return @o.headers
    end
    
    # attaches to the "for" tags in "label" tags.
    def for
      @how = :ole_object 
      return @o.for
    end
    
    # attaches to the "summary" tag
    def summary
      @how = :ole_object
      return @o.summary
    end
    
  end 
end