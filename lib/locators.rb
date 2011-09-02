#!/usr/bin/env ruby

# 
# == Synopsis
#
# Creates a locator object that contains all locator information for selenium testing.
#
# Author:: Kyle Campos (mailto:kcampos@rsmart.com)
#

class Locators
  
  attr_accessor :locator
  
  def initialize(locator)
    @locator = locator
  end
  
end


class RiceLocators < Locators
  
  attr_accessor :type, :value, :locator
    
  def initialize(locator='', type='name', value='')
    
    @type = type
    @value = value
    super(locator)
    
  end
  
  def locator(locator="#{@type}=#{@value}")
    @locator=locator
  end
  
  def login_username
    self.type = 'name'
    self.value = '__login_user'
    self.locator
  end
  
  def create_travel_request
    self.type  = 'link'
    self.value = 'Create New Sample Application Travel Request (KualiDocumentActionBase)'
    self.locator
  end
  
  def travel_request_description
    self.type  = 'name'
    self.value = 'document.documentHeader.documentDescription'
    self.locator
  end
  
  def travel_request_name
    self.type  = 'name'
    self.value = 'document.traveler'
    self.locator
  end
  
  def travel_request_origin
    self.type  = 'name'
    self.value = 'document.origin'
    self.locator
  end
  
  def travel_request_destination
    self.type  = 'name'
    self.value = 'document.destination'
    self.locator
  end
  
  def travel_request_type
    self.type  = 'name'
    self.value = 'document.requestType'
    self.locator
  end
  
  def travel_request_account
    self.type  = 'name'
    self.value = 'travelAccount.number'
    self.locator
  end
  
  def travel_request_account_add
    self.type  = 'name'
    self.value = 'methodToCall.insertAccount'
    self.locator
  end
  
  def travel_request_submit
    self.type  = 'name'
    self.value = 'methodToCall.route'
    self.locator
  end
  
  def travel_request_notes_show
    self.type  = 'name'
    self.value = 'methodToCall.toggleTab.tabNotesandAttachments'
    self.locator
  end
  
  def travel_request_notes_text
    self.type  = 'name'
    self.value = 'newNote.noteText'
    self.locator
  end
  
  def travel_request_notes_add
    self.type  = 'name'
    self.value = 'methodToCall.insertBONote'
    self.locator
  end
  
  # Test View 1
  
  def test_view_1
    self.type  = 'link'
    self.value = 'Test View 1'
    self.locator
  end
  
  # 4 chars
  def test_view_1_field_1
    self.type  = 'name'
    self.value = 'field1'
    self.locator
  end
  
  # Text - no input
  def test_view_1_field_2
    self.type  = 'id'
    self.value = 'id_7049_attribute_span'
    self.locator
  end
  
  # mm/dd/yyyy
  def test_view_1_field_3
    self.type  = 'name'
    self.value = 'field3'
    self.locator
  end
  
  # Select
  def test_view_1_field_4
    self.type  = 'name'
    self.value = 'field4'
    self.locator
  end
  
  # Text
  def test_view_1_field_6
    self.type  = 'name'
    self.value = 'field6'
    self.locator
  end
  
  # Text
  # name doesn't match label
  def test_view_1_field_8
    self.type  = 'name'
    self.value = 'field7'
    self.locator
  end
  
  # Text
  def test_view_1_field_6
    self.type  = 'name'
    self.value = 'field6'
    self.locator
  end
  
  # Radio
  def test_view_1_field_34(selection)
    self.type  = 'id'
    
    if(selection == 'Yes')
      self.value = 'id_7126_attribute1'
    elsif(selection == 'No')
      self.value = 'id_7126_attribute2'
    elsif(selection == 'Both')
      self.value = 'id_7126_attribute2'
    end
    
    self.locator
  end
  
  # Save
  def test_view_1_save
    self.type  = 'id'
    self.value = 'id_7007'
    self.locator
  end
  
end