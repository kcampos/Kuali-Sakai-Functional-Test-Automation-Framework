# TODO - Write a description
module CalendarFrame

  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  include GlobalMethods

  def calendar_frame
    self.frame(:src=>/sakai2calendar.launch.html/)
  end

end

# Top page of the Calendar
# For now it includes all views, though that probably
# means it will have to be re-instantiated every time
# a new view is selected.
class Calendar
  include CalendarFrame
  include CalendarTools
  include CalendarMethods
end

# The page that appears when you click on an event in the Calendar
class EventDetail
  include CalendarFrame
  include CalendarTools
  include EventDetailMethods
end

#
class AddEditEvent
  include CalendarFrame
  include AddEditEventMethods
end

# The page that appears when the Frequency button is clicked on the Add/Edit
# Event page.
class EventFrequency
  include CalendarFrame
  include EventFrequencyMethods
end

class AddEditFields
  include CalendarFrame
  include AddEditFieldsMethods
end

class ImportStepOne
  include CalendarFrame
  include ImportStepOneMethods
end

class ImportStepTwo
  include CalendarFrame
  include ImportStepTwoMethods
end

class ImportStepThree
  include CalendarFrame
  include ImportStepThreeMethods
end