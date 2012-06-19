#================
# Blog Pages - NOT "Blogger"
#================

#
module BlogsMethods

  # Returns an array containing the list of Bloggers
  # in the "All the blogs" table.
  def blogger_list
    bloggers = []
    frm.table(:class=>"listHier lines").rows.each do |row|
      bloggers << row[1].text
    end
    bloggers.delete_at(0)
    return bloggers
  end

  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
    end
  end
end