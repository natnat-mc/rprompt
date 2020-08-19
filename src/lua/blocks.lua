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
local flush
flush = function()
  if #blocks then
    endline()
  end
  insert(output, ' ')
  if has256color then
    insert(output, tostring(esc) .. "[0m")
  end
  return io.write(concat(output, ''))
end
return {
  addblock = addblock,
  endline = endline,
  flush = flush
}
