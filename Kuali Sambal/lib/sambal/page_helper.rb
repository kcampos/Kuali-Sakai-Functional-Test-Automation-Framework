module PageHelper

  def visit page_class, &block
    on page_class, true, &block
  end

  def on page_class, visit=false, &block
    page = page_class.new @browser, visit
    block.call page if block
    page
  end

end