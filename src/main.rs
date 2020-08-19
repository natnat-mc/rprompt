extern crate rlua;
extern crate terminfo;
extern crate git2;
extern crate hostname;

use rlua::{Lua, Result};

mod lib_terminfo;
mod lib_paths;
mod lib_git;
mod lib_host;

fn main() -> Result<()> {
    let lua = Lua::new();

    lua.context(|lua| {
        lib_paths::lib_paths(&lua)?;
        lib_terminfo::lib_terminfo(&lua)?;
        lib_git::lib_git(&lua)?;
        lib_host::lib_host(&lua)?;

        lua.load(std::include_str!("amalgam.lua")).exec()?;

        Ok(())
    })
}
