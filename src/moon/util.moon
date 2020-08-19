shrtpath = (p) ->
	import home from paths
	if home
		if p==home
			return '~'
		len = #home
		if (p\sub 1, len)==home and (p\sub len+1, len+1)=='/'
			return '~'..p\sub len+1
	p

{ :shrtpath }
