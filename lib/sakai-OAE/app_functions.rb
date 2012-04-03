#!/usr/bin/env ruby
# 
# == Synopsis
#
# This file contains custom methods used throughout the Sakai test scripts

#require 'watir-webdriver'
require 'page-object'
PageObject.javascript_framework = :jquery
#require 'date'

class SakaiOAE
  
  include PageObject
  
  def initialize(browser)
    @browser = browser
  end
  
  def login(username, password)
    @browser.div(:id=>"topnavigation_user_options_login_wrapper").fire_event("onmouseover")
    @browser.text_field(:id=>"topnavigation_user_options_login_fields_username").set username
    @browser.text_field(:name=>"topnav_login_password").set password
    @browser.button(:id=>"topnavigation_user_options_login_button_login").click
    sleep 3
    if @browser.button(:id=>"emailverify_continue_button").present?
      @browser.button(:id=>"emailverify_continue_button").click
    end
    @browser.wait_for_ajax(2)
    MyDashboard.new @browser
  end
  
  alias sign_in login
  alias log_in login
  
  def sign_out
    @browser.link(:id=>"topnavigation_user_options_name").fire_event("onmouseover")
    @browser.link(:id=>"subnavigation_logout_link").click
    sleep 1 # FIXME
    @browser.wait_for_ajax(2)#.div(:text=>"Recent activity").wait_until_present
    LoginPage.new @browser
  end
  
  alias logout sign_out
  alias log_out sign_out
  
end

# Contains methods that extend the PageObject module to include
# methods that are custom to OAE.
module PageObject
  
  # Monkey patch helper method for links to named objects...
  def name_link(name)
    @browser.link(:text=>/#{Regexp.escape(name)}/i)
  end
  
  # Monkey patch helper method for li elements referring to
  # named items...
  def name_li(name)
    @browser.li(:text=>/#{Regexp.escape(name)}/i)
  end
  
  def method_missing(sym, *args, &block)
    @browser.send sym, *args, &block
  end
  
  module Accessors
    
    # Use this for menus that require floating the mouse
    # over the first link, before you click on the second
    # link...
    def float_menu(name, menu_text, link_text, target_class)   
      define_method(name) {
        self.back_to_top
        self.link(:text=>menu_text).fire_event("onmouseover")
        self.link(:text=>/#{link_text}/).click
        sleep 3
        #wait_for_ajax
        eval(target_class).new @browser
      }
    end
    
    def open_link(name, klass)
      define_method("open_#{name}") do |value|
        self.back_to_top
        self.link(:text=>/#{value}/).click
        sleep 2
        self.wait_for_ajax(2)
        # This code is necessary because of a null style tag
        # that confuses Watir into thinking the buttons aren't really there.
        if self.div(:id=>"joinrequestbuttons_widget").exist?
          @browser.execute_script("$('#joinrequestbuttons_widget').css({display: 'block'})")
        end
        eval(klass).new @browser
      end
    end
    
    # Use this for menu items that are accessed via clicking
    # the div to get to the target menu item.
    def permissions_menu(name, text) #, target_class)
      define_method(name) {
        self.link(:text=>text).fire_event("onmouseover")
        self.link(:text=>text).parent.div(:class=>"lhnavigation_selected_submenu_image").fire_event("onclick")
        self.link(:id=>"lhnavigation_submenu_user_permissions").click
        self.class.class_eval { include ProfilePermissionsPopUp }
      }
    end
    
    # Use this for button objects that cause page navigations and thus
    # require a new Page Object.
    def navigating_button(name, id, class_name=nil)
      define_method(name) { 
          self.button(:id=>id).click
          sleep 0.2
          browser.wait_for_ajax(2)
          sleep 0.2
          unless class_name==nil
            eval(class_name).new @browser
          end
        }
    end
    
    # Use this for links on the page that cause page navigations and
    # thus require a new Page Object.
    def navigating_link(name, link_text, class_name=nil)
      define_method(name) { 
        self.link(:text=>/#{Regexp.escape(link_text)}/).click
        sleep 2 # wait_for_ajax keeps throwing unknown JS errors in Selenium-webdriver
        unless class_name==nil
          eval(class_name).new @browser
        end
      }
    end
    
    # This method is specifically for defining the contents of
    # the Insert button, found on the Document Edit page. See the module
    # DocumentWidget
    def insert_button(name, id, module_name=nil)
      define_method("insert_#{name}") {
        self.button(:id=>"sakaidocs_insert_dropdown_button").click
        sleep 0.1
        self.button(:id=>id).click
        unless module_name==nil
          self.class.class_eval { include eval(module_name) }
          sleep 0.4
        end
        self.wait_for_ajax(2)
      }
    end
    
  end 
end

# Extension of the Utilities module.
# This is included here because it contains methods
# specific to OAE testing only.
module Utilities
  
  # Returns an array containing a randomized list of the specified
  # number of OAE Category strings (The array returned is one string long if no
  # number is specified).
  def random_categories(number=1)
    categories = ["Agriculture", "Animal Sciences", "Food Sciences", "Plant Sciences", "Soil Sciences", "Architecture & Planning", "City, Urban, Community & Regional Planning", "Environmental Design", "Interior Architecture", "Landscape Architecture", "Real Estate Development", "Arts & Music", "Acting", "Art History, Criticism & Conservation", "Arts Management", "Arts, Entertainment, & Media Management", "Ballet", "Brass Instruments", "Ceramic Arts & Ceramics", "Cinematography & Film/Video Production", "Commercial & Advertising Art", "Commercial Photography", "Conducting", "Costume Design", "Crafts/Craft Design, Folk Art & Artisanry", "Dance", "Design & Applied Arts", "Digital Arts", "Directing & Theatrical Production", "Documentary Production", "Drama/Theatre Arts & Stagecraft", "Drawing", "Fashion/Apparel Design", "Fiber, Textile & Weaving Arts", "Film/Cinema/Video Studies", "Fine & Studio Arts Management", "Game & Interactive Media Design", "Graphic Design", "Illustration", "Industrial & Product Design", "Interior Design", "Intermedia/Multimedia", "Jazz/Jazz Studies", "Keyboard Instruments", "Metal & Jewelry Arts", "Music", "Music History, Literature, & Theory", "Music Management & Merchandising", "Music Pedagogy", "Music Performance", "Music Technology", "Music Theory & Composition", "Musical Theatre", "Musicology & Ethnomusicology", "Painting", "Percussion Instruments", "Photography", "Playwriting & Screenwriting", "Printmaking", "Sculpture", "Stringed Instruments", "Technical Theatre/Theatre Design & Technology", "Theatre Literature, History & Criticism", "Theatre/Theatre Arts Management", "Voice & Opera", "Woodwind Instruments", "Business", "Accounting & Related Services", "Business Administration, Management & Operations", "Business Operations Support & Assistant Services", "Busines & Corporate Communications", "Business & Managerial Economics", "Construction Management", "Entrepreneurial & Small Business Operations", "Finance & Financial Management Services", "Hospitality Administration & Management", "Human Resources Management & Services", "Insurance", "International Business", "Management Information Systems & Services", "Management Sciences & Quantitative Methods", "Marketing", "Real Estate", "Sales & Merchandising", "Taxation", "Telecommunications Management", "Communications", "Animation, Interactive Technology, Video Graphics & Special Effects", "Graphic Communications", "Journalism", "Photographic & Film/Video Technology", "Public Relations & Advertising", "Publishing", "Radio & Television Broadcasting Technology", "Recording Arts Technology", "Computers & Information", "Archives/Archival Administration", "Artificial Intelligence", "Children & Youth Library Services", "Computer Programming", "Computer Science", "Human Computer Interaction", "Informatics", "Information Science/Studies", "Information Technology", "Library & Information Science", "Library Science & Administration", "Education", "Adult & Continuing Education", "Bilingual, Multilingual, & Multicultural Education", "Curriculum & Instruction", "Developmental & Remedial English", "Developmental & Remedial Mathematics", "Early Childhood Education", "Educational Administration & Supervision", "Educational Assessment, Evaluation, & Research", "Educational & Instructional Media Design", "Elementary Education", "High School & Secondary Diploma Programs", "International & Comparative Education", "Outdoor Education", "Second Language Learning", "Secondary Education", "Special Education", "Student Counseling & Personnel Services", "Vocational Education", "Engineering & Technology", "Aerospace, Aeronautical & Astronautical Engineering", "Agricultural Engineering", "Architectural Engineering", "Biomedical & Medical Engineering", "Ceramic Sciences & Engineering", "Chemical Engineering", "Civil Engineering", "Computer Engineering", "Electrical, Electronics & Communications Engineering", "Environmental & Environmental Health Engineering", "Geological & Geophysical Engineering", "Industrial Engineering", "Materials Science", "Mechanical Engineering", "Mining & Mineral Engineering", "Nanotechnology", "Naval Architecture & Marine Engineering", "Nuclear Engineering", "Systems Engineering", "History", "American History", "Asian History", "Canadian History", "European History", "Military History", "Science & Technology History", "Languages & Literatures", "African Languages & Literatures", "Albanian Language & Literature", "American Literature", "American Sign Language", "Ancient Near Eastern & Biblical Languages & Literatures", "Ancient/Classical Greek Language & Literature", "Arabic Language & Literature", "Australian, Oceanic, & Pacific Languages & Literatures", "Baltic Languages & Literatures", "Bengali Language & Literature", "Bosnian, Serbian, & Croatian Languages & Literatures", "Bulgarian Language & Literature", "Burmese Language & Literature", "Catalan Language & Literature", "Celtic Languages & Literatures", "Children's & Adolescent Literature", "Chinese Language & Literature", "Classics & Classical Languages & Literatures", "Comparative Literature", "Creative Writing", "Czech Language & Literature", "Danish Language & Literature", "Dutch/Flemish Language & Literature", "East Asian Languages & Literatures", "English Composition", "English Literature", "Filipino/Tagalog Language & Literature", "French Language & Literature", "Germanic Languages & Literatures", "Hebrew Language & Literature", "Hindi Language & Literature", "Hungarian & Magyar Language & Literature", "Indonesian & Malay Languages & Literatures", "Iranian & Persian Languages & Literatures", "Italian Language & Literature", "Japanese Language & Literature", "Khmer & Cambodian Language & Literature", "Korean Language & Literature", "Lao Language & Literature", "Latin Language & Literature", "Linguistics", "Literature", "Middle & Near Eastern & Semitic Languages & Literatures", "Modern Greek Language & Literature", "Mongolian Language & Literature", "Native American Languages & Literatures", "Norwegian Language & Literature", "Polish Language & Literature", "Portuguese Language & Literature", "Punjabi Language & Literature", "Romance Languages & Literatures", "Romanian Language & Literature", "Russian Language & Literature", "Sanskrit & Classical Indian Languages & Literatures", "Scandinavian Languages & Literatures", "Slavic Languages & Literatures", "Slovak Language & Literature", "South Asian Languages & Literatures", "Southeast Asian, Australasian, & Pacific Languages & Literatures", "Spanish Language & Literature", "Speech & Rhetorical Studies", "Swedish Language & Literature", "Tamil Language & Literature", "Technical & Business Writing", "Thai Language & Literature", "Tibetan Language & Literature", "Turkic, Uralic-Altaic, Caucasian, & Central Asian Languages & Literatures", "Turkish Language & Literature", "Ukrainian Language & Literature", "Uralic Languages & Literatures", "Urdu Language & Literature", "Vietnamese Language & Literature", "Law", "Banking, Corporate, Finance, & Securities Law", "Comparative Law", "Energy, Environment, & Natural Resources Law", "Health Law", "Intellectual Property Law", "International Law & Legal Studies", "Law", "Legal Support Services", "Pre-Law Studies", "Tax Law & Taxation", "Lifelong Learning", "Addiction Prevention & Treatment", "Adult & Continuing Education", "Aircraft Piloting", "Art", "Basic Computer Skills", "Birthing & Parenting", "Board, Card & Role-Playing Games", "Career Exploration", "Collecting", "Computer Games & Programming Skills", "Cooking & Other Domestic Skills", "Dancing", "Handicrafts & Model-Making", "Home Maintenance & Improvement", "Music", "Nature Appreciation", "Personal Health", "Pets", "Reading", "Sports & Exercise", "Theater", "Travel", "Workforce Development & Training", "Writing", "Math", "Algebra & Number Theory", "Applied Mathematics", "Geometry & Geometric Analysis", "Statistics", "Topology & Foundations", "Medicine & Health", "Alternative & Complementary Medicine", "Bioethics & Medical Ethics", "Chiropractic", "Clinical & Medical Laboratory Science & Research", "Communication Disorders Sciences", "Dentistry", "Dietetics & Clinical Nutrition", "Energy & Biologically Based Therapies", "Health & Medical Administration", "Health & Medical Assistance", "Health & Medical Preparatory Programs", "Health Diagnostics, Intervention & Treatment", "Health, Physical Education & Fitness", "Medical Illustration & Informatics", "Medicine", "Mental & Social Health", "Movement & Mind-Body Therapies", "Nursing", "Ophthalmics & Optometrics", "Optometry", "Osteopathic Medicine", "Pharmacy & Pharmaceutical Sciences", "Podiatric Medicine", "Public Health", "Rehabilitation & Therapeutics", "Somatic Bodywork", "Veterinary Medicine", "Military & Security", "Air Force ROTC, Air Science & Operations", "Army ROTC, Military Science & Operations", "Corrections", "Criminal Justice", "Crisis, Emergency & Disaster Management", "Critical Incident Response & Special Police Operations", "Critical Infrastructure Protection", "Cyber & Computer Forensics & Counterterrorism", "Financial Forensics & Fraud Investigation", "Fire Protection", "Fire Science & Fire-fighting", "Fire Systems Technology", "Fire & Arson Investigation & Prevention", "Forensic Science & Technology", "Homeland Security", "Intelligence, Command Control & Information Operations", "Maritime Law Enforcement", "Military Economics & Management", "Military Science & Operational Studies", "Military Technologies", "Navy & Marine ROTC, Naval Science & Operations", "Protective Services Operations", "Security Policy & Strategy", "Terrorism & Counterterrorism Operations", "Wildland & Forest Firefighting & Investigation", "Multidisciplinary Studies", "African Studies", "African-American & Black Studies", "American Studies & Civilization", "Asian Studies & Civilization", "Asian-American Studies", "Balkans Studies", "Baltic Studies", "Canadian Studies", "Caribbean Studies", "Chinese Studies", "Classical & Ancient Studies", "Commonwealth Studies", "Cultural Studies, Critical Theory & Analysis", "Deaf Studies", "Disability Studies", "East Asian Studies", "European Studies & Civilization", "Folklore Studies", "French Studies", "Gay & Lesbian Studies", "General Studies", "German Studies", "Hispanic-American, Puerto Rican, & Mexican-American/Chicano Studies", "Historic Preservation & Conservation", "Holocaust & Related Studies", "Housing & Human Environments", "Humanities & Humanistic Studies", "Intercultural, Multicultural & Diversity Studies", "International & Global Studies", "Irish Studies", "Italian Studies", "Japanese Studies", "Korean Studies", "Latin American & Caribbean Studies", "Medieval & Renaissance Studies", "Museology & Museum Studies", "Native American Studies", "Near & Middle Eastern Studies", "Pacific Area & Pacific Rim Studies", "Peace Studies & Conflict Resolution", "Polish Studies", "Russian, Central European, East European & Eurasian Studies", "Scandinavian Studies", "Slavic Studies", "South Asian Studies", "Southeast Asian Studies", "Spanish & Iberian Studies", "Sustainability Studies", "Systems Science & Theory", "Tibetan Studies", "Ukraine Studies", "Ural-Altaic & Central Asian Studies", "Western European Studies", "Women's Studies", "Work & Family Studies", "Natural & Physical Sciences", "Astronomy", "Astrophysics", "Atmospheric Sciences & Meteorology", "Atomic & Molecular Physics", "Biochemistry, Biophysics & Molecular Biology", "Biology", "Biomathematics, Bioinformatics, & Computational Biology", "Biotechnology", "Botany & Plant Biology", "Cellular Biology & Anatomical Sciences", "Chemistry", "Cognitive Science", "Ecology", "Ecology, Evolution, Systematics, & Population Biology", "Genetics", "Geochemistry & Petrology", "Geological & Earth Sciences", "Geophysics & Seismology", "Hydrology & Water Resources Science", "Marine Biology & Biological Oceanography", "Materials Sciences", "Microbiological Sciences & Immunology", "Neurobiology & Neurosciences", "Neuroscience", "Nuclear Physics", "Oceanography", "Optics", "Paleontology", "Pharmacology & Toxicology", "Physics", "Physiology, Pathology & Related Sciences", "Zoology & Animal Biology", "Philosophy & Religion", "Bible & Biblical Studies", "Buddhist Studies", "Christian Studies", "Divinity & Ministry", "Ethics", "Hindu Studies", "Islamic Studies", "Jewish & Judaic Studies", "Lay Ministry", "Logic", "Missionary Studies & Missiology", "Pastoral Counseling & Specialized Ministries", "Philosophy", "Rabbinical Studies", "Religion & Religious Studies", "Religious Education", "Religious & Sacred Music", "Talmudic Studies", "Theological & Ministerial Studies", "Urban Ministry", "Women's Ministry", "Youth Ministry", "Public Policy & Administration", "Community Organization & Advocacy", "Education Policy Analysis", "Fishing & Fisheries", "Forestry", "Health Policy Analysis", "Human Services", "International Policy Analysis", "Public Administration", "Public Policy Analysis", "Social Work", "Wildlife & Wildlands", "Youth Services", "Social Sciences", "Anthropology", "Archeology", "Criminology", "Demography & Population Studies", "Economics", "Geography & Cartography", "International Relations & National Security Studies", "Political Science & Government", "Psychology", "Sociology", "Urban Studies & Affairs", "Trades & Professions", "Air Traffic Control", "Aircraft Powerplant Technology", "Airframe Mechanics & Aircraft Maintenance & Repair", "Airline Flight Attendant", "Airline Pilot & Flight Crew", "Alternative Fuel Vehicle Technology", "Apparel & Textiles", "Automotive Mechanics", "Aviation Management & Operations", "Avionics Maintenance & Repair", "Bicycle Mechanics & Repair", "Blasting & Blaster", "Boilermaking & Boilermaker", "Building & Construction Finishing, Management, & Inspection", "Building & Construction Site Management", "Building, Home & Construction Inspection", "Building & Property Maintenance", "Cabinetmaking & Millwork", "Carpenters", "Carpet, Floor & Tile Worker", "Commercial Fishing", "Computer Numerically Controlled Machinist", "Concrete Finishing", "Construction, Heavy Equipment & Earthmoving Equipment Operation", "Cosmetology", "Culinary Arts", "Diesel Mechanics", "Diver, Professional & Instructor", "Drywall Installation", "Electrical & Electronics Maintenance & Repair", "Electrician", "Engine Machinist", "Flagging & Traffic Control", "Flight Instruction", "Foods, Nutrition & Related Services", "Funeral Service & Mortuary Science", "Furniture Design & Manufacturing", "Glazing", "Gunsmithing", "Heating, Air Conditioning, Ventilation & Refrigeration Maintenance & Repair", "Heavy & Industrial Equipment Maintenance & Repair", "High Performance & Custom Engine Mechanics", "Insulator", "Ironworking", "Locksmithing & Safe Repair", "Machine Tool Technology & Machinist", "Marine Maintenance, Fitter & Ship Repair", "Marine Science & Merchant Marine Officer", "Marine Transportation", "Masonry", "Medium & Heavy Vehicle & Truck Technology", "Metal Building Assembly", "Metal Fabricator", "Mobile Crane Operation", "Motorcycle Maintenance & Repair", "Musical Instrument Fabrication & Repair", "Painting & Wall Covering", "Pipefitting & Sprinkler Fitting", "Plumbing", "Railroad & Railway Transportation", "Recreation Vehicle (RV) Service", "Roofing", "Sheet Metal Technology & Sheetworking", "Shoe, Boot & Leather Repair", "Small Engine Mechanics", "Tool & Die Technology", "Truck/Bus Driver & Commercial Vehicle Operator & Instructor", "Upholstery", "Watchmaking & Jewelrymaking", "Welding", "Well Drilling", "Woodworking"]
    list = []
    number.times do
      categories.shuffle!
      list << categories.pop
    end
    return list
  end
  
end

# Need this to extend Watir to be able to attach to Sakai's non-standard tags...
module Watir
  
  class Browser

    def wait_for_ajax(timeout=5)
      end_time = ::Time.now + timeout
      while self.execute_script("return jQuery.active") > 0
        sleep 0.2
        break if ::Time.now > end_time
      end
      self.wait(timeout + 10)
    end

    def back_to_top
      self.execute_script("javascript:window.scrollTo(0,0)")
    end
    
    alias return_to_top back_to_top
    alias scroll_to_top back_to_top
    
  end
  
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

  end 
end

