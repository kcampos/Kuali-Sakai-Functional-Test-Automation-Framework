spec = Gem::Specification.new do |s|
  s.name = 'sakai-oae-test-api'
  s.version = '0.0.3'
  s.summary = %q{Sakai-OAE functional testing API for rSmart Academic}
  s.description = %q{The Sakai-OAE gem provides an API for interacting with the web pages and page elements in rSmart's deployment of the Sakai Open Academic Environment.}
  s.files = Dir.glob("**/**/**")
  s.test_files = Dir.glob("test/*test_rb")
  s.authors = ["Abraham Heward"]
  s.email = %w{'aheward@rsmart.com'}
  s.homepage = 'https://github.com/aheward/Kuali-Sakai-Functional-Test-Automation-Framework/tree/master/Sakai/OAE/API'
  s.add_dependency 'page-object', '>= 0.6.6'
  s.add_dependency 'watir-webdriver', '>= 0.5.5'
  s.add_dependency 'selenium-webdriver', '>= 2.21.2'
  s.add_dependency 'kuali-sakai-common-lib', '>= 0.0.1'
  s.required_ruby_version = '>= 1.9.2'
end