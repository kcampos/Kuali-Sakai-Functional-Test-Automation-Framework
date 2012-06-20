#
class EmailArchive
  include ToolsMenu
  CLEElements.modularize(EmailArchiveMethods, :class=>"portletMainIframe")
end

class EmailArchiveOptions
  include ToolsMenu

end