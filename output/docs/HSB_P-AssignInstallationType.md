# HSB_P-AssignInstallationType.mcr

## Overview
Assigns specific electrical installation types (e.g., sockets, switches) to predefined installation points on timber elements directly via the AutoCAD Properties Palette.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used to assign data to Elements or GenBeams in the model. |
| Paper Space | No | Not intended for layout views. |
| Shop Drawing | No | Not intended for manufacturing drawings. |

## Prerequisites
- **Required entities**: An Element or GenBeam that already has installation points defined (the element must contain Map data with `NrOfInstallationPoints` and `Installations`).
- **Minimum beam count**: N/A (Script is attached to existing elements).
- **Required settings files**: `HSB-InstallationTypeCatalogue.xml` (must be present in the `Abbund` folder of your hsbCAD company path).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `HSB_P-AssignInstallationType.mcr` from the file browser.

### Step 2: Select Element
```
Command Line: Select Element/GenBeam:
Action: Click on the timber wall or beam you want to assign electrical types to.
```

### Step 3: Configure Properties
1. With the element selected, open the **Properties Palette** (press `Ctrl+1`).
2. Scroll down to the "Installation type" section.
3. Select the desired electrical symbol from the dropdown lists (e.g., "Socket/Switch", "Light").
4. Only the dropdowns corresponding to actual installation points on the beam will be editable.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| |Installation type| | Text | | Visual separator for the settings group. |
| Installation type 1 | dropdown | |Installation type| 1 | Select the electrical symbol for the first installation point on the element. |
| Installation type 2 | dropdown | |Installation type| 2 | Select the electrical symbol for the second installation point. |
| Installation type 3 | dropdown | |Installation type| 3 | Select the electrical symbol for the third installation point. |
| Installation type 4 | dropdown | |Installation type| 4 | Select the electrical symbol for the fourth installation point. |
| Installation type 5 | dropdown | |Installation type| 5 | Select the electrical symbol for the fifth installation point. |
| Installation type 6 | dropdown | |Installation type| 6 | Select the electrical symbol for the sixth installation point. |
| Installation type 7 | dropdown | |Installation type| 7 | Select the electrical symbol for the seventh installation point. |
| Installation type 8 | dropdown | |Installation type| 8 | Select the electrical symbol for the eighth installation point. |
| Installation type 9 | dropdown | |Installation type| 9 | Select the electrical symbol for the ninth installation point. |
| Installation type 10 | dropdown | |Installation type| 10 | Select the electrical symbol for the tenth installation point. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| ShowDialog | Opens a configuration dialog to modify the installation types (alternative to using the Properties Palette). |

## Settings Files
- **Filename**: `HSB-InstallationTypeCatalogue.xml`
- **Location**: `_kPathHsbCompany\Abbund`
- **Purpose**: This file contains the list of available installation types (e.g., specific electrical symbols). If the dropdown lists are empty, check that this file exists in the correct directory.

## Tips
- **Read-Only Fields**: If a dropdown is grayed out (Read-Only), it means the element does not have an installation point defined at that position. You cannot assign a type to a point that doesn't exist.
- **Data Storage**: This script updates the "Map" data of the element. It does not create visible geometry (lines/arcs) but ensures the correct data is attached for exports or other scripts to use.

## FAQ
- Q: Why are all my dropdowns grayed out?
- A: This usually means the selected element does not have any "Installation Points" assigned to it yet. Ensure the element has the required `NrOfInstallationPoints` data.
- Q: Where do I add new electrical symbols to the list?
- A: You must edit the `HSB-InstallationTypeCatalogue.xml` file located in your company `Abbund` folder. The script does not create new symbols itself; it reads them from this file.