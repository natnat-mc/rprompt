import insert, concat from table
import getenv from os
import char from string

blocks = {}
output = {}
linesent = false

addblock = (text, data={}) ->
	data.text = text
	insert blocks, data

has256color = terminfo and terminfo.maxcolors==256 and not getenv 'NOCOLOR'
esc = char 0x1b

endline = ->
	if linesent
		insert output, '\n'
	linesent = true
	for i, block in ipairs blocks
		if i!=1
			insert output, ' '
		if has256color and block.color
			insert output, "#{esc}[38;5;#{block.color}m"
		insert output, block.text
	blocks = {}

shrtpath = (p) ->
	import home from paths
	if home
		if p==home
			return '~'
		len = #home
		if (p\sub 1, len)==home and (p\sub len+1, len+1)=='/'
			return '~'..p\sub len+1
	p


do
	status = getenv 'STATUS'
	if status=='0'
		addblock '0', color: '046'
	elseif status
		addblock status, color: '196'
	if host.time
		addblock host.time, color: '088'
	if host.username
		addblock host.username, color: '089'
	if host.hostname
		addblock host.hostname, color: '090'
	if paths.cwd
		addblock (shrtpath paths.cwd), color: '091'

if git
	endline!
	if git.changes==0
		addblock 'clean', color: '046'
	elseif git.changes==1
		addblock '1 change', color: '165'
	elseif git.changes
		addblock git.changes..' changes', color: '165'
	if git.path
		addblock (shrtpath git.path), color: '164'
	do
		addblock git.branch or '[no branch]', color: '163'

addblock '~>', color: '201'
endline!
insert output, ' '
if has256color
	insert output, "#{esc}[0m"
io.write concat output, ''
