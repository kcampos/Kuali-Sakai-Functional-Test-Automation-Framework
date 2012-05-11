spec = Gem::Specification.new do |s|
  s.name = 'kuali-sakai-common-lib'
  s.version = '0.0.1'
  s.summary = %q{Modules and methods common to the rSmart testing gems}
  s.description = %q{This gem provides a set of modules and methods that are common to the Kuali and Sakai open source project's rSmart functional testing API gems.\n\nThis gem is not useful except in the context of one of the other rSmart Kuali/Sakai testing API gems.}
  s.files = Dir.glob("**/**/**")
  s.test_files = Dir.glob("test/*test_rb")
  s.authors = ["Abraham Heward"]
  s.email = ["aheward@rsmart.com"]
  #s.rubyforge_project = "kuali-sakai-common-lib"
  s.required_ruby_version = '>= 1.9.2'
end