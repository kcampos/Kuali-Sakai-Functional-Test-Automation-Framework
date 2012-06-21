# Top page of the Calendar
# For now it includes all views, though that probably
# means it will have to be re-instantiated every time
# a new view is selected.
class Calendar
  include ToolsMenu
  include CalendarTools
  include CalendarMethods
end

# The page that appears when you click on an event in the Calendar
class EventDetail
  include ToolsMenu
  include CalendarTools
  include EventDetailMethods
end

#
class AddEditEvent
  include ToolsMenu
  include AddEditEventMethods
end

# The page that appears when the Frequency button is clicked on the Add/Edit
# Event page.
class EventFrequency
  include ToolsMenu
  include EventFrequencyMethods
end

class AddEditFields
  include ToolsMenu
  include AddEditFieldsMethods
end

class ImportStepOne
  include ToolsMenu
  include ImportStepOneMethods
end

class ImportStepTwo
  include ToolsMenu
  include ImportStepTwoMethods
end

class ImportStepThree
  include ToolsMenu
  include ImportStepThreeMethods
end

# TODO: Rethink this!!!
class EventAttach < AddFiles

  include ToolsMenu

  def initialize(browser)
    @browser = browser

    @@classes = {
        :this=>"EventAttach",
        :parent=>"AddEditEvent"
    }
  end

end