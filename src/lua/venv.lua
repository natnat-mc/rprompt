local getenv
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
}
