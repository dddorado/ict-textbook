function Meta(meta)
  if not meta.title then
    return nil
  end

  local title = pandoc.utils.stringify(meta.title)
  local clean = title:match("^#%s+(.+)%s+{%.unnumbered}$")

  if clean then
    local parsed = pandoc.read(clean, "markdown")
    meta.title = pandoc.MetaInlines(parsed.blocks[1].content)
    return meta
  end
end

function Image(image)
  if not FORMAT:match("latex") then
    return image
  end

  local _, contents = pandoc.mediabag.fetch(image.src)
  if contents and contents:sub(1, 8) == "\137PNG\r\n\26\n" then
    local width = string.unpack(">I4", contents, 17)
    local height = string.unpack(">I4", contents, 21)
    local max_width = 6.15
    local max_height = 6.40
    local fitted_width = math.min(max_width, max_height * width / height)

    image.attributes.width = string.format("%.3fin", fitted_width)
    image.attributes.height = nil
  end

  return image
end
