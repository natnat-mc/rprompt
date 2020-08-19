use terminfo::{capability as cap};
use rlua::{Context, Result, Nil};

struct Terminfo {
    fullcolor: bool,
    maxcolors: Option<i32>
}

fn get_terminfo() -> Option<Terminfo> {
    let terminfo = match terminfo::Database::from_env() {
        Ok(terminfo) => terminfo,
        _ => return None
    };
    
    let fullcolor = match terminfo.get::<cap::TrueColor>() {
        Some(cap::TrueColor(true)) => true,
        _ => false
    };
    let maxcolors = match terminfo.get::<cap::MaxColors>() {
        Some(cap::MaxColors(n)) => Some(n),
        _ => None
    };

    Some(Terminfo { fullcolor, maxcolors })
}

pub fn lib_terminfo(lua: &Context) -> Result<()> {
    let globals = lua.globals();

    match get_terminfo() {
        Some(Terminfo {fullcolor, maxcolors}) => {
            let terminfo = lua.create_table()?;
            terminfo.set("fullcolor", fullcolor)?;
            terminfo.set("maxcolors", maxcolors)?;
            globals.set("terminfo", terminfo)?;
        },
        None => {
            globals.set("terminfo", Nil)?;
        }
    }

    Ok(())
}
