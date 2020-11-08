package.preload['main'] = function()
local chunk, err = load([=====[local getenv
getenv = os.getenv
local addblock, endline, flush
do
  local _obj_0 = require('blocks')
  addblock, endline, flush = _obj_0.addblock, _obj_0.endline, _obj_0.flush
end
local shrtpath
shrtpath = require('util').shrtpath
local getvenvpath, getvenvversion
do
  local _obj_0 = require('venv')
  getvenvpath, getvenvversion = _obj_0.getvenvpath, _obj_0.getvenvversion
end
do
  local status = getenv('STATUS')
  local defaultshell = getenv('SHELL')
  if defaultshell then
    defaultshell = defaultshell:match('/([^/]+)$')
  end
  local currentshell = getenv('CURRENTSHELL')
  if status == '0' then
    addblock('0', {
      color = '046'
    })
  elseif status then
    addblock(status, {
      color = '196'
    })
  end
  if currentshell and currentshell ~= defaultshell then
    addblock(currentshell, {
      color = '069'
    })
  end
  if getenv('STY') then
    addblock('screen', {
      color = '068'
    })
  end
  if getenv('TMUX') then
    addblock('tmux', {
      color = '067'
    })
  end
  if getenv('NVIM_LISTEN_ADDRESS') then
    addblock('nvim', {
      color = '066'
    })
    do
      local root = getenv('NVIM_ROOT')
      if root then
        addblock("[" .. tostring(root:sub(2)) .. "]", {
          color = '065'
        })
      end
    end
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
do
  local venv = getvenvpath()
  if venv then
    endline()
    addblock((shrtpath(venv)), {
      color = '129'
    })
    do
      local version = getvenvversion()
      if version then
        addblock(version, {
          color = '128'
        })
      end
    end
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
return flush()]=====], 'src/lua/main.lua', 't')
if err then error(err) end
return chunk()
end
package.preload['blocks'] = function()
local chunk, err = load([=====[local insert, concat
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
local currentshell = getenv('CURRENTSHELL')
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
      if currentshell == 'bash' then
        insert(output, "\\[" .. tostring(esc) .. "[38;5;" .. tostring(block.color) .. "m\\]")
      elseif currentshell == 'zsh' then
        insert(output, "%F{" .. tostring(block.color) .. "}")
      else
        insert(output, tostring(esc) .. "[38;5;" .. tostring(block.color) .. "m")
      end
    end
    insert(output, block.text)
  end
  blocks = { }
end
local flush
flush = function()
  if #blocks then
    endline()
  end
  insert(output, ' ')
  if has256color then
    if currentshell == 'bash' then
      insert(output, "\\[" .. tostring(esc) .. "[0m\\]")
    elseif currentshell == 'zsh' then
      insert(output, "%f")
    else
      insert(output, tostring(esc) .. "[0m")
    end
  end
  return io.write(concat(output, ''))
end
return {
  addblock = addblock,
  endline = endline,
  flush = flush
}]=====], 'src/lua/blocks.lua', 't')
if err then error(err) end
return chunk()
end
package.preload['util'] = function()
local chunk, err = load([=====[local shrtpath
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
}]=====], 'src/lua/util.lua', 't')
if err then error(err) end
return chunk()
end
package.preload['venv'] = function()
local chunk, err = load([=====[local getenv
getenv = os.getenv
local open
open = io.open
local getvenvpath
getvenvpath = function()
  return getenv('VIRTUAL_ENV')
end
local getvenvversion
getvenvversion = function()
  local fd = open(tostring(getvenvpath()) .. "/pyvenv.cfg", 'r')
  if not (fd) then
    return 
  end
  for line in fd:lines() do
    do
      local version = line:match('version%s*=%s*(.+)')
      if version then
        return version
      end
    end
  end
end
return {
  getvenvpath = getvenvpath,
  getvenvversion = getvenvversion
}]=====], 'src/lua/venv.lua', 't')
if err then error(err) end
return chunk()
end
require 'main'
