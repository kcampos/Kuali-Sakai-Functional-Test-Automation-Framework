module Fun

  def self.menu(name, menu_id, link_id, target_class)   
    define_method(name) {
      @browser.link(:id=>menu_id).fire_event("onmouseover")
      @browser.link(:id=>link_id).click
      eval(target_class).new @browser
    }
  end

  menu("my_dashboard", "navigation_you_link", "subnavigation_home_link", "MyDashboard")
  menu("my_messages", "navigation_you_link", "subnavigation_messages_link", "MyMessages")
  menu("my_profile", "navigation_you_link", "subnavigation_profile_link", "MyProfile")
  menu("my_library", "navigation_you_link", "subnavigation_content_link", "MyLibrary")
  menu("my_memberships", "navigation_you_link", "subnavigation_memberships_link", "MyMemberships") 
  menu("my_contacts", "navigation_you_link", "subnavigation_contacts_link", "MyContacts")
  menu("add_content", "navigation_create_and_add_link", "subnavigation_add_content_link", "AddContent")  
  menu("add_contacts", "navigation_create_and_add_link", "subnavigation_add_contacts_link", "AddContacts")  
  menu("create_groups", "navigation_create_and_add_link", "subnavigation_group_link", "CreateGroups")
  menu("create_courses", "navigation_create_and_add_link", "subnavigation_courses_link", "CreateCourses")
  menu("create_research", "navigation_create_and_add_link", "subnavigation_research_link", "CreateResearch")  
  menu("explore_all_categories", "navigation_explore_link_dropdown", "subnavigation_explore_categories_link", "ExploreCategories")

end