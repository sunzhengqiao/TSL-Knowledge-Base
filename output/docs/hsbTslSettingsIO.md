# hsbTslSettingsIO.mcr

## Overview
Use this script to manage custom TSL settings within your project. It allows you to import standard configurations from XML files, export current project settings to a file, or permanently erase settings from the drawing database.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates in the background via the drawing database. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities:** None (This script manages data only).
- **Minimum Beam Count:** 0.
- **Required Settings:** 
  - A folder named `Settings` containing XML files must exist in either `hsbCompany` or `hsbInstall\Content\General`.
  - The drawing must contain the `hsbTSL` dictionary (usually created automatically by hsbCAD).

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Select `hsbTslSettingsIO.mcr` from the list and click Open.

### Step 2: Configure Properties
A dialog or the Properties Palette will appear automatically. Set the following:
- **Setting**: Select the configuration set you wish to manage (e.g., a specific labeling style or machining default).
- **Mode**: Select the action:
  - `Import`: Load settings from a file into the drawing.
  - `Export`: Save current drawing settings to a file.
  - `Erase`: Remove the settings from the drawing.

### Step 3: Execute
1.  Click **OK** or **Finish** in the dialog.
2.  The script will process the request and then remove itself from the drawing.

### Step 4: Confirm Erase (If Mode is Erase)
If you selected **Erase**, you must confirm the action on the command line:
```
Command Line: Are you sure to erase the settings permanently? [No]/Yes
Action: Type "Yes" and press Enter to confirm, or press Enter to cancel.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Setting | dropdown | First entry found | Selects the specific configuration collection to process. The list combines XML files found on disk and settings currently saved in the drawing. |
| Mode | dropdown | Import | Selects the operation: **Import** (File to Drawing), **Export** (Drawing to File), or **Erase** (Delete from Drawing). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script is transient and removes itself immediately after execution. It does not offer context menu options. |

## Settings Files
- **Filename**: `*.xml`
- **Location**: `hsbCompany\TSL\Settings` or `hsbInstall\Content\General\TSL\Settings`
- **Purpose**: These files store the data definitions. When importing, the script reads these files. When exporting, the script creates or updates these files.

## Tips
- **Standardization:** Use the **Import** mode at the start of a new project to ensure all drawings use the same company-wide TSL settings.
- **Backup:** If you have tweaked settings in a drawing that work perfectly, use **Export** mode to save them to an XML file before sharing them with others.
- **Transience:** The script instance will disappear from your drawing immediately after running. Do not look for it in the model space afterwards.

## FAQ
- **Q: Why do I get an error saying "No import file found" when I try to Import?**
  **A:** This means the selected "Setting" currently exists in the drawing's database but does not have a corresponding XML file on the disk (or the file is missing). You can only **Export** or **Erase** such a setting, not Import it.
  
- **Q: Where should I put my custom XML files so the script can see them?**
  **A:** Place them in the `hsbCompany\TSL\Settings` folder. If they are not there, the script will also check the general installation folder.