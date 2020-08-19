import getenv from os
import open from io

getvenvpath = ->
	getenv 'VIRTUAL_ENV'

getvenvversion = ->
	fd = open "#{getvenvpath!}/pyvenv.cfg", 'r'
	return unless fd
	for line in fd\lines!
		if version = line\match 'version%s*=%s*(.+)'
			return version

{ :getvenvpath, :getvenvversion }
