$config = YAML.load_file("#{File.dirname(__FILE__)}/config.yml")
$sakai = SakaiOAE.new($config['browser'], $config['url'])


Before do
  @browser = $sakai.browser
  @welcome_page = $sakai.page
  @directory = YAML.load_file("#{File.dirname(__FILE__)}/directory.yml")
end

at_exit do
  $sakai.browser.close
end
