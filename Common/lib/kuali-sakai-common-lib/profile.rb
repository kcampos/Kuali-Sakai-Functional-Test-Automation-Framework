module ProfileMethods

  def edit_my_profile
    frm.link(:text=>"Edit my Profile").click
    EditProfile.new(@browser)
  end

  def show_my_profile
    frm.link(:text=>"Show my Profile").click
    Profile.new @browser
  end

  def photo
    source = frm.image(:id=>"profileForm:image1").src
    return source.split("/")[-1]
  end

  def email
    frm.link(:id=>"profileForm:email").text
  end

end

#
module EditProfileMethods
  include PageObject
  def save
    frm.button(:value=>"Save").click
    Profile.new(@browser)
  end

  def picture_file(filename, filepath="")
    frm.file_field(:name=>"editProfileForm:uploadFile.uploadId").set(filepath + filename)
  end

  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
      text_field(:first_name, :id=>"editProfileForm:first_name", :frame=>frame)
      text_field(:last_name, :id=>"editProfileForm:lname", :frame=>frame)
      text_field(:nickname, :id=>"editProfileForm:nickname", :frame=>frame)
      text_field(:position, :id=>"editProfileForm:position", :frame=>frame)
      text_field(:email, :id=>"editProfileForm:email", :frame=>frame)
      radio_button(:upload_new_picture, :value=>"pictureUpload", :frame=>frame)
    end
  end
end