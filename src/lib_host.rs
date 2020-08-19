use rlua::{Context, Result};

pub fn lib_host(lua: &Context) -> Result<()> {
    let globals = lua.globals();

    let host = lua.create_table()?;
    host.set("hostname", hostname::get().map(|n| n.into_string().ok()).ok())?;
    host.set("username", std::env::var("USER").ok())?;
    host.set("time", lua.load("return os.date('%H:%M')").eval::<rlua::String>()?)?;

    globals.set("host", host)?;
    Ok(())
}
