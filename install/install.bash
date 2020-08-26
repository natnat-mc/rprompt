cp target/release/rprompt ~/.bash_rprompt
export PROMPT_COMMAND='PS1="`STATUS=$? ~/.bash_rprompt`"'
cat >> ~/.bashrc <<EOF
export PROMPT_COMMAND='PS1="\`STATUS=\$? ~/.bash_rprompt\`"'
EOF
