#================
# Gradebook2 Pages
#================

#
module Gradebook2Methods
  include PageObject
  # Returns an array of names of Gradebook items
  def gradebook_items
    items = []
    frm.div(:class=>"x-grid3-scroller").spans.each do |span|
      if span.class_name =~ /^x-tree3-node-text/
        items << span.text
      end
    end
    return items
  end

  in_frame(:class=>"portletMainIframe") do |frame|


  end
end