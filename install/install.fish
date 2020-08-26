cp target/release/rprompt ~/.config/fish/rprompt
function fish_prompt
	set -xl STATUS $status
	command ~/.config/fish/rprompt
end
funcsave fish_prompt
