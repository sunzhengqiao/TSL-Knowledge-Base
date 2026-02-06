# hsbCLT-MasterPanelManager

## Overview
This script serves as a configuration manager for CLT (Cross Laminated Timber) Master Panels. It allows you to define visual styles for master panels using external DWG files and manage the import/export of global project settings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary environment for managing master panels and styles. |
| Paper Space | Yes | Contains logic for handling plot viewports and settings. |
| Shop Drawing | No | This is a model management script, not a detailing script. |

## Prerequisites
- **Required Entities**: CLT Panels (GenBeam or Element entities) in the model.
- **Minimum Beams**: 0 (Can be inserted as a standalone configuration entity).
- **Required Settings**: A valid DWG file containing Masterpanel Styles located in the Company folder structure.

## Usage Steps

### Step 1: Insert the Script
Command: `TSLINSERT`
Action: Browse to the script location and select `hsbCLT-MasterPanelManager.mcr`.

### Step 2: Place in Model
Command Line: `Insert point:`
Action: Click anywhere in the Model Space to place the script instance. The specific location is not critical as it manages global settings and styles rather than geometry at a specific point.

### Step 3: Configure Visual Styles
Action: Right-click the script instance and select **Select Masterstyle Dwg**.
- The script scans subfolders of your Company folder for `*.dwg` files.
- A dialog titled "Selection Masterpanel-Style DWG" will appear.
- Select the desired drawing file from the list and click OK.
- The script updates the internal settings to use this style for Master Panels.

### Step 4: Save Configuration (Optional)
Action: Right-click the script instance and select **Export Settings**.
- If the file `hsbCLT-MasterPanelManager.xml` already exists, the command line will ask: `Are you sure to overwrite existing settings? [No/Yes]`.
- Type `Yes` to overwrite or `No` to cancel.

## Properties Panel Parameters
This script does not expose user-editable parameters directly in the Properties Palette (OPM). All configuration is handled via the Right-Click Context Menu.

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Select Masterstyle Dwg** | Opens a file selection dialog to choose a DWG file from the Company folder that defines the visual style (layers, hatching) for Master Panels. |
| **Import Settings** | Loads configuration settings from the standard `hsbCLT-MasterPanelManager.xml` file. |
| **Export Settings** | Saves the current configuration settings to `hsbCLT-MasterPanelManager.xml`. Includes a safety check to prevent accidental overwrites. |

## Settings Files
- **Filename**: `hsbCLT-MasterPanelManager.xml`
- **Location**: Searches in `_kPathHsbCompany` or `_kPathHsbInstall\Company`.
- **Purpose**: Persists global configuration settings, such as the file path to the active Masterpanel Style DWG, allowing settings to be shared or reloaded.

## Tips
- **File Location**: Ensure your Masterpanel Style DWG files are stored in subfolders within your Company folder path; otherwise, the "Select Masterstyle Dwg" function will not find them.
- **Standardization**: Use the Export/Import functions to distribute consistent Master Panel settings (e.g., specific hatching or layer colors) across your project team.
- **Recovery**: If a style file is missing or moved, use "Select Masterstyle Dwg" to re-link the correct drawing file.

## FAQ
- Q: I see a notice "No drawings with masterpanel styles could be found." What do I do?
- A: This means the script did not find any valid DWG files in your Company subfolders. Check that your style DWGs exist in the correct directory structure defined in your hsbCAD configuration.
- Q: Can I undo an settings export?
- A: No, but the system prompts you to confirm before overwriting an existing file. Always select "No" if you are unsure to preserve your previous configuration.