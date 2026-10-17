# Nexo Death Screen

A clean, modern, NoPixel-inspired death screen for FiveM roleplay servers.

## Features

- Clean, modern death-screen UI.
- NoPixel-inspired visual style.
- Simple installation and configuration.
- Designed for FiveM roleplay servers.

> **Framework compatibility:** Add only the frameworks confirmed to work with your release. Update this section after testing.

## Resource Files

```text
resource-folder/
├── client/
├── html/
├── config.lua
├── fxmanifest.lua
└── README.md
```

- `client/` — client-side scripts.
- `html/` — user interface files.
- `config.lua` — configuration settings.
- `fxmanifest.lua` — FiveM resource manifest.

## Installation

1. Download or clone this repository.
2. Place the resource folder inside your FiveM server's `resources` directory.
3. Open `config.lua` and review the available settings.
4. Add the resource to your `server.cfg`:

   ```cfg
   ensure resource_folder_name
   ```

   Replace `resource_folder_name` with the actual resource folder name.
5. Restart the server or start the resource from the server console.

## Configuration

Configure the resource through `config.lua`. Available options depend on the version you are using. Review the file before starting the resource.

## Framework Support

List the frameworks tested and supported by this release here. Do not claim QBCore, Qbox, ESX, or standalone compatibility unless you have verified it.

## Dependencies

Check `fxmanifest.lua` and the resource code for required dependencies, and list them here before publishing.

## Support

For issues, bug reports, or suggestions, open an issue in this GitHub repository or contact Nexo Studio through its official support channel.

## Credits

Created by **Nexo Studio**.

Please include a `LICENSE` file if you want to specify how others may use, modify, or redistribute this resource.
