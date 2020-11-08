var 'SOURCES_RUST', _.wildcard 'src/**.rs'
var 'SOURCES_MOON', _.wildcard 'src/moon/**.moon'
var 'SOURCES_LUA', _.patsubst SOURCES_MOON, 'src/moon/%.moon', 'src/lua/%.lua'
var 'AMALGAM', 'src/amalgam.lua'

with public target 'debug'
	\produces 'target/debug/rprompt'
	\depends SOURCES_RUST, AMALGAM
	\fn => _.cmd 'cargo', 'build'

with default public target 'release'
	\produces 'target/release/rprompt'
	\depends SOURCES_RUST, AMALGAM
	\fn => _.cmd 'cargo', 'build', '--release'

with public target 'install'
	\after 'release'
	\fn => _.cmd (os.getenv 'SHELL'), "install/install.#{(os.getenv 'SHELL')\match '([^/]+)$'}"

with public target 'clean'
	\fn => _.cmd 'rm', '-f', SOURCES_LUA, AMALGAM

with target SOURCES_LUA, pattern: 'src/lua/%.lua'
	\depends 'src/moon/%.moon'
	\produces 'src/lua/%.lua'
	\fn => _.moonc @infile, @outfile

with target AMALGAM
	\depends SOURCES_LUA
	\produces AMALGAM
	\fn =>
		code = {}
		write = (v) -> table.insert code, v
		_.foreach @infiles, =>
			modname = @match('lua/(.-)%.lua')\gsub '/', '.'
			write "package.preload['#{modname}'] = function()\n"
			write "local chunk, err = load([=====["
			write _.readfile @
			write "]=====], '#{@}', 't')\n"
			write "if err then error(err) end\n"
			write "return chunk()\n"
			write "end\n"
		write "require 'main'\n"
		_.writefile @outfile, table.concat code, ''
