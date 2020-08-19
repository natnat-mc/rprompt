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

flush = ->
	if #blocks
		endline!
	insert output, ' '
	if has256color
		insert output, "#{esc}[0m"
	io.write concat output, ''

{ :addblock, :endline, :flush }
