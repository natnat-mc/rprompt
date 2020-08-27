local getenv
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
return flush()
