# GE_BEAM_INFO_GET_DETAILS.mcr

## Overview
This script is a diagnostic tool that allows you to select a structural timber beam and instantly view a detailed report of its properties, including dimensions, volume, material codes, and logical states, in a pop-up window.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the only environment where the script functions. |
| Paper Space | No | The script will not work in layout views. |
| Shop Drawing | No | Not designed for shop drawing contexts. |

## Prerequisites
- **Required Entities**: At least one valid `GenBeam` (Timber Beam) must exist in the model.
- **Minimum Beam Count**: 1 (Must be selected by the user).
- **Required Settings Files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse to the location of `GE_BEAM_INFO_GET_DETAILS.mcr`, select it, and click **Open**.

### Step 2: Select Beam
```
Command Line: Select beam
Action: Click on the specific timber beam in the Model Space that you wish to inspect.
```

### Step 3: View Information
Action: A "Notice" window will appear on screen displaying the beam's technical details.
-   Review the data (e.g., Length, Height, Width, Volume, Material Grade, Position Number).
-   Click **OK** or close the window to finish.

## Properties Panel Parameters
This script does not expose parameters to the Properties Panel (OPM). It functions solely via command-line input and output dialogs.

## Right-Click Menu Options
This script does not add custom options to the entity Right-Click menu.

## Settings Files
No external settings files are required for this script.

## Tips
- **Self-Cleaning**: The script entity automatically deletes itself from the drawing after displaying the information. You do not need to manually erase it.
- **Verification**: Use this script to quickly verify volume calculations for billing or to check internal system codes (e.g., `IsDummy`, `IsCutStraight`) that are not always visible in the standard properties palette.
- **Unit Independence**: The script handles internal units automatically, ensuring dimensions are displayed correctly regardless of your drawing's global unit settings.

## FAQ
- **Q: Why can't I find the script object in my drawing after I use it?**
  - **A**: This is a "query" script designed to run once and disappear. It executes the command, shows the report, and then uses `eraseEntity` to remove itself to keep your drawing clean.
- **Q: I get a message saying "No beam selected".**
  - **A**: Ensure you have clicked directly on a valid timber beam (GenBeam) during the selection prompt. If you press Esc or click in empty space, the script will cancel.