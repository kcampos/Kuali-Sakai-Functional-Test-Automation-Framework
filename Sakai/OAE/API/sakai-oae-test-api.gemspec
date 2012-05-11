spec = Gem::Specification.new do |s|
  s.name = 'sakai-oae-test-api-test-api'
  s.version = '0.0.1'
  s.summary = %q{Sakai-OAE API for rSmart Academic}
  s.description = %q{The Sakai-OAE gem provides an API for interacting with rSmart's deployment of the Sakai Open Academic Environment.}
  s.files = Dir.glob("**/**/**")
  s.test_files = Dir.glob("test/*test_rb")
  s.authors = ["Abraham Heward"]
  s.email = ["aheward@rsmart.com"]
  s.rubyforge_project = "sakai-oae-test-api-test-api"
  s.add_dependency 'page-object', '>= 0.6.6'
  s.add_dependency 'watir-webdriver', '>= 0.5.5'
  s.add_dependency 'selenium-webdriver', '>= 2.21.2'
  s.add_dependency 'kuali-sakai-common-lib', '>= 0.0.1'
  s.required_ruby_version = '>= 1.9.2'
end