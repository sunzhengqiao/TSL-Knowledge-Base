# hsb_ProjectSettings.mcr

## Overview
This script connects your CAD model to the external BOMLink database by allowing you to select a specific project. It generates a visual table of project variables in Model Space and stores these settings globally so other scripts can access the correct project data.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be placed in Model Space to function. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: None.
- **Minimum Beam Count**: 0.
- **Required Settings**:
  - `hsbSoft.BomLink.Tsl.dll` (DotNet assembly located at your hsbCAD install path).
  - A valid connection to the BOMLink database.
  - Dimension Styles defined in the current drawing.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_ProjectSettings.mcr` from the list.

### Step 2: Place the Table
```
Command Line: Pick a point
Action: Click anywhere in Model Space to set the insertion point (top-left corner) of the project settings table.
```

### Step 3: Configure Project (Optional)
If the default project is not correct:
1. Select the inserted Project Settings entity.
2. Open the **Properties Palette** (Ctrl+1).
3. Locate the **BOMLink Project** property and select the desired project from the dropdown list.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| BOMLink Project | dropdown | *First available* | Selects the active project context from the BOMLink database. This determines which variables are loaded. |
| Dimension style | dropdown | *Current Style* | Sets the text style (font, height) used for the content inside the generated table. |
| Line color | number | -1 | Sets the color of the table grid and border lines (-1 = ByBlock). |
| Text color: Header | number | -1 | Sets the color of the header row text (-1 = ByBlock). |
| Text color: Content | number | -1 | Sets the color of the variable names and values (-1 = ByBlock). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Update Project Settings | Forces a refresh of the project variables from the BOMLink database. Use this if the database has changed since the script was last updated. |

## Settings Files
*None* (This script relies on the BOMLink DotNet assembly and database connection rather than local XML settings files).

## Tips
- **Single Instance**: This script operates as a singleton. If you insert a second instance into the same model, the script will automatically delete the old one to prevent conflicts.
- **Global Access**: The data loaded by this script is stored in the Project MapX under the key `HSB_PROJECTSETTINGS`. Other scripts in your project can read this data to automate labels or reports.
- **Visual Updates**: To change the size of the text, simply change the `Dimension style` property in the palette. The table will redraw automatically.

## FAQ
- **Q: Why is my table empty or showing an error?**
  A: Check the AutoCAD command line for specific error messages. This usually indicates a failure to connect to the BOMLink database or an invalid project selection.
- **Q: Can I have multiple project tables for different projects in one drawing?**
  A: No. The script is designed to enforce a single project context per drawing to ensure data consistency. Inserting a new one removes the previous one.