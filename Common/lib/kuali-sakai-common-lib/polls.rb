module PollsMethods

  def add
    frm.link(:text=>"Add").click
    frm.frame(:id, "newpolldescr::input___Frame").td(:id, "xEditingArea").wait_until_present
    AddEditPoll.new(@browser)
  end

  #
  def edit(poll)

  end

  def questions
    questions = []
    frm.table(:id=>"sortableTable").rows.each do |row|
      questions << row[0].link.text
    end
    return questions
  end

  # Returns an array containing the list of poll questions displayed.
  def list
    list = []
    frm.table(:id=>"sortableTable").rows.each_with_index do |row, index|
      next if index==0
      list << row[0].link(:href=>/voteQuestion/).text
    end
    return list
  end

  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
    end
  end
end

 module AddEditPollMethods

  def additional_instructions=(text)
    frm.frame(:id, "newpolldescr::input___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  def save_and_add_options
    frm.button(:value=>"Save and add options").click
    AddAnOption.new(@browser)
  end

  def save
    frm.button(:value=>"Save").click
    Polls.new(@browser)
  end

  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
      text_field(:question, :id=>"new-poll-text", :frame=>frame)
    end
  end
end

module AddAnOptionMethods

  def answer_option=(text)
    frm.frame(:id, "optText::input___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  def save
    frm.button(:value=>"Save").click
    AddEditPoll.new(@browser)
  end

  def save_and_add_options
    frm.button(:value=>"Save and add options").click
    AddAnOption.new(@browser)
  end

end