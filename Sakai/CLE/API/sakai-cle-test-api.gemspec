spec = Gem::Specification.new do |s|
  s.name = 'sakai-cle-test-api'
  s.version = '0.0.7'
  s.summary = %q{Sakai-CLE functional testing API for the rSmart Collaborative Learning Environment}
  s.description = %q{The Sakai-OAE gem provides an API for interacting with pages and page elements in rSmart's deployment of the Sakai Collaborative Learning Environment.}
  s.files = Dir.glob("**/**/**")
  s.test_files = Dir.glob("test/*test_rb")
  s.authors = ["Abraham Heward"]
  s.email = %w{"aheward@rsmart.com"}
  s.homepage = 'https://github.com/aheward/Kuali-Sakai-Functional-Test-Automation-Framework/tree/master/Sakai/CLE/API'
  s.add_dependency 'page-object', '>= 0.6.6'
  s.add_dependency 'watir-webdriver', '>= 0.5.5'
  s.add_dependency 'selenium-webdriver', '>= 2.21.2'
  s.add_dependency 'kuali-sakai-common-lib', '= 0.0.7'
  s.required_ruby_version = '>= 1.9.2'
end