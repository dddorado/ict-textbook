local excluded = {
  ["chapter overview"] = true,
  ["learning objectives"] = true,
  ["key concepts"] = true,
  ["core discussion"] = true,
  ["philippine and southeast asian examples"] = true,
  ["hands-on activity"] = true,
  ["ethical and professional issue"] = true,
  ["review questions"] = true,
  ["mini case"] = true,
  ["further reading and tools"] = true,
  ["closing synthesis"] = true,
  ["expected output"] = true,
  ["assessment rubric"] = true,
  ["tools"] = true,
  ["steps"] = true
}

local function latex_escape(text)
  local replacements = {
    ["\\"] = "\\textbackslash{}",
    ["{"] = "\\{",
    ["}"] = "\\}",
    ["#"] = "\\#",
    ["$"] = "\\$",
    ["%"] = "\\%",
    ["&"] = "\\&",
    ["_"] = "\\_",
    ["^"] = "\\textasciicircum{}",
    ["~"] = "\\textasciitilde{}"
  }
  return (text:gsub("[\\{}#$%%&_^~]", replacements))
end

function Header(header)
  if not FORMAT:match("latex") or header.level ~= 3 then
    return nil
  end

  local text = pandoc.utils.stringify(header.content)
  local normalized = text:lower():gsub("^%s+", ""):gsub("%s+$", "")
  if text == "" or excluded[normalized] then
    return nil
  end

  return {
    header,
    pandoc.RawBlock("latex", "\\index{" .. latex_escape(text) .. "}")
  }
end
