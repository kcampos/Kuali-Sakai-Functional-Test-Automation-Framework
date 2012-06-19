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
  CLEElements.modularize(AddEditEventMethods, :class=>"portletMainIframe")
end

# The page that appears when the Frequency button is clicked on the Add/Edit
# Event page.
class EventFrequency
  include ToolsMenu
  CLEElements.modularize(EventFrequency, :class=>"portletMainIframe")
end

class AddEditFields
  include ToolsMenu
  CLEElements.modularize(AddEditFieldsMethods, :class=>"portletMainIframe")
end

class ImportStepOne
  include ToolsMenu
  CLEElements.modularize(ImportStepOneMethods, :class=>"portletMainIframe")
end

class ImportStepTwo
  include ToolsMenu
  include ImportStepTwoMethods
end

class ImportStepThree
  include ToolsMenu
  CLEElements.modularize(ImportStepThreeMethods, :class=>"portletMainIframe")
end

