cp target/release/rprompt ~/.zsh_rprompt
precmd() {
	PS1="`STATUS=$? ~/.zsh_rprompt`"
}
cat >> ~/.zshrc <<EOF
precmd() {
	PS1="\`STATUS=\$? ~/.zsh_rprompt\`"
}
EOF
