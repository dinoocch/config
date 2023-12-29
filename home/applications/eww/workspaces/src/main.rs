use hyprland::data::*;
use hyprland::prelude::*;
use hyprland::shared::HResult;

fn main() -> HResult<()> {
    let monitors = Monitors::get()?.to_vec();
    println!("{monitors:#?}");

    let workspaces = Workspaces::get()?.to_vec();
    println!("{workspaces:#?}");
    //
    // let clients = Clients::get()?.to_vec();
    // println!("{clients:#?}");
    //
    // let active_window = Client::get_active()?;
    // println!("{active_window:#?}");
    //
    // let layers = Layers::get()?;
    // println!("{layers:#?}");
    //
    // let devices = Devices::get()?;
    // println!("{devices:#?}");
    //
    // let version = Version::get()?;
    // println!("{version:#?}");
    //
    // let cursor_pos = CursorPosition::get()?;
    // println!("{cursor_pos:#?}");
    Ok(())

}

fn show_message() {

}
