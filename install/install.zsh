cp target/release/rprompt ~/.zsh_rprompt
precmd() {
	PS1="`STATUS=$? CURRENTSHELL=zsh ~/.zsh_rprompt`"
}
cat >> ~/.zshrc <<EOF
precmd() {
	PS1="\`STATUS=\$? CURRENTSHELL=zsh ~/.zsh_rprompt\`"
}
EOF
