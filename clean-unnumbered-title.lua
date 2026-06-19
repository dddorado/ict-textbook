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
