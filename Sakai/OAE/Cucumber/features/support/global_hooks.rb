Before do
  @config = YAML.load_file("#{File.dirname(__FILE__)}/config.yml")
  @sakai = SakaiOAE.new(@config['browser'], @config['url'])
  @directory = YAML.load_file("#{File.dirname(__FILE__)}/directory.yml")
  @browser = @sakai.browser
  @welcome_page = @sakai.page
end

at_exit do
  @sakai.browser.close
end
