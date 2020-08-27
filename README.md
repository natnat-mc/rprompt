# rprompt
A smol prompt in rust + moonscript

## Building and installing
- To build this prompt, simply use `cargo build --release`, this will build as `target/release/rprompt`
- To rebuild the moonscript code, you'll need [`moonbuild`](https://github.com/natnat-mc/moonbuild) and `moonbuild release` or `moonbuild debug` should work
- To install, you need to set it as your shell's prompt command (see the `install/` directory, *sourcing* these with your shell)

## What does it do?
- tell you who you are and what machine you're on
- tell you what happened (last command status)
- tell you which shell you're currently using, if it's not your `$SHELL`
- tell you where you are (current directory)
- tell you what you are doing (git repo, branch and local copy status)
- tell you what venv you're using (venv root and python version)
- color itself if terminal supports 256color

## What to add next?
- `nvm`, `luaver` and similar envs
- command execution time
- possibility to enable or disable features at moonscript compile time
- maybe even a small config file that gets compiled in the binary
