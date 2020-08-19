use git2::{Repository, StatusOptions};
use rlua::{Context, Result, Nil};

pub fn lib_git(lua: &Context) -> Result<()> {
    let globals = lua.globals();

    let repo = match Repository::open_from_env() {
        Ok(repo) => repo,
        _ => {
            globals.set("git", Nil)?;
            return Ok(())
        }
    };
    let mut status_opts = StatusOptions::new();
    status_opts.include_ignored(false);
    status_opts.include_untracked(true);
    status_opts.include_unmodified(false);

    let git = lua.create_table()?;
    git.set("path", repo.path().parent().map(|p| p.to_str()))?;
    git.set("changes", repo.statuses(Some(&mut status_opts)).map(|s| s.len()).ok())?;
    if let Ok(branches) = repo.branches(None) {
        if let Some(branch) = branches.filter_map(|b| b.ok()).map(|(b, _)| b).find(|b| b.is_head()) {
            git.set("branch", branch.name().ok())?;
        }
    }

    globals.set("git", git)?;
    Ok(())
}
