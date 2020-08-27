import getenv from os
import addblock, endline, flush from require 'blocks'
import shrtpath from require 'util'
import getvenvpath, getvenvversion from require 'venv'

do
	status = getenv 'STATUS'
	defaultshell = getenv 'SHELL'
	defaultshell = defaultshell\match '/([^/]+)$' if defaultshell
	currentshell = getenv 'CURRENTSHELL'

	if status=='0'
		addblock '0', color: '046'
	elseif status
		addblock status, color: '196'
	if currentshell and currentshell!=defaultshell
		addblock currentshell, color: '069'
	if host.time
		addblock host.time, color: '088'
	if host.username
		addblock host.username, color: '089'
	if host.hostname
		addblock host.hostname, color: '090'
	if paths.cwd
		addblock (shrtpath paths.cwd), color: '091'

if venv = getvenvpath!
	endline!
	addblock (shrtpath venv), color: '129'
	if version = getvenvversion!
		addblock version, color: '128'

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
flush!
