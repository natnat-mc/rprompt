use rlua::{Context, Result};

pub fn lib_paths(lua: &Context) -> Result<()> { 
    let globals = lua.globals();

    let paths = lua.create_table()?;
    paths.set("home", std::env::var("HOME").ok())?;
    paths.set("cwd", std::env::var("PWD").ok())?;
    globals.set("paths", paths)?;

    Ok(())
}
