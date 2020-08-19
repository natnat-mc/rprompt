local shrtpath
shrtpath = function(p)
  local home
  home = paths.home
  if home then
    if p == home then
      return '~'
    end
    local len = #home
    if (p:sub(1, len)) == home and (p:sub(len + 1, len + 1)) == '/' then
      return '~' .. p:sub(len + 1)
    end
  end
  return p
end
return {
  shrtpath = shrtpath
}
