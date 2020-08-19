SOURCES_MOON = wildcard 'src/moon/*.moon'
SOURCES_LUA  = patsubst SOURCES_MOON, 'src/moon/%.moon', 'src/lua/%.lua'
AMALGAM      = 'src/amalgam.lua'

target 'src/lua/%.lua', in: 'src/moon/%.moon', out: 'src/lua/%.lua', fn: =>
	-moonc '-o', @outfile, @infile
target 'amalgam', out: AMALGAM, from: SOURCES_LUA, fn: =>
	code = {}
	foreach @ins, =>
		modname = @\match('lua/(.-)%.lua')\gsub '/', '.'
		print "adding module #{@} as #{modname}"
		insert code, "package.preload['#{modname}'] = function()\n"
		insert code, "local chunk, err = load([=====["
		fd = io.open @, 'r'
		insert code, fd\read '*a'
		fd\close!
		insert code, "]=====], '#{@}', 't')\n"
		insert code, "if err then error(err) end\n"
		insert code, "return chunk()\n"
		insert code, "end\n"

	insert code, "require 'main'\n"

	fd = io.open @outfile, 'w'
	fd\write concat code, ''
	fd\close!

public target 'debug', deps: 'amalgam', out: 'target/debug/rprompt', fn: =>
	-cargo 'build'
public target 'run', deps: 'amalgam', fn: =>
	-cargo 'run'

public target 'release', deps: 'amalgam', out: 'target/release/rprompt', fn: =>
	-cargo 'build', '--release'

public target 'clean', fn: =>
	-rm '-f', SOURCES_LUA
	-rm '-f', AMALGAM

default target 'rickroll', fn: =>
	#sh '-c', 'curl -s -L http://bit.ly/10hA8iC | bash'
