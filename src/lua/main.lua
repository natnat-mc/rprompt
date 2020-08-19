local insert, concat
do
  local _obj_0 = table
  insert, concat = _obj_0.insert, _obj_0.concat
end
local getenv
getenv = os.getenv
local char
char = string.char
local blocks = { }
local output = { }
local linesent = false
local addblock
addblock = function(text, data)
  if data == nil then
    data = { }
  end
  data.text = text
  return insert(blocks, data)
end
local has256color = terminfo and terminfo.maxcolors == 256 and not getenv('NOCOLOR')
local esc = char(0x1b)
local endline
endline = function()
  if linesent then
    insert(output, '\n')
  end
  linesent = true
  for i, block in ipairs(blocks) do
    if i ~= 1 then
      insert(output, ' ')
    end
    if has256color and block.color then
      insert(output, tostring(esc) .. "[38;5;" .. tostring(block.color) .. "m")
    end
    insert(output, block.text)
  end
  blocks = { }
end
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
do
  local status = getenv('STATUS')
  if status == '0' then
    addblock('0', {
      color = '046'
    })
  elseif status then
    addblock(status, {
      color = '196'
    })
  end
  if host.time then
    addblock(host.time, {
      color = '088'
    })
  end
  if host.username then
    addblock(host.username, {
      color = '089'
    })
  end
  if host.hostname then
    addblock(host.hostname, {
      color = '090'
    })
  end
  if paths.cwd then
    addblock((shrtpath(paths.cwd)), {
      color = '091'
    })
  end
end
if git then
  endline()
  if git.changes == 0 then
    addblock('clean', {
      color = '046'
    })
  elseif git.changes == 1 then
    addblock('1 change', {
      color = '165'
    })
  elseif git.changes then
    addblock(git.changes .. ' changes', {
      color = '165'
    })
  end
  if git.path then
    addblock((shrtpath(git.path)), {
      color = '164'
    })
  end
  do
    addblock(git.branch or '[no branch]', {
      color = '163'
    })
  end
end
addblock('~>', {
  color = '201'
})
endline()
insert(output, ' ')
if has256color then
  insert(output, tostring(esc) .. "[0m")
end
return io.write(concat(output, ''))
