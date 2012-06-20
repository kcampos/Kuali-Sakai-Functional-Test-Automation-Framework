#================
# Email Archive pages
#================

module EmailArchiveMethods

  def options
    frm.link(:text=>"Options").click
    EmailArchiveOptions.new(@browser)
  end

  # Returns an array containing the
  def email_list
  end

  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
      text_field(:search_field, :id=>"search", :frame=>frame)
      button(:search_button, :value=>"Search", :frame=>frame)
    end
  end
end

module EmailArchiveOptionsMethods



end