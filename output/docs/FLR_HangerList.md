# FLR_HangerList.mcr

## Overview
This script is a database setup utility that populates the hsbCAD environment with a library of standard Simpson/USP joist hanger definitions. It runs automatically upon insertion, loads dimensional and nailing data into the project's internal database, and then removes itself from the drawing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be inserted here to run. |
| Paper Space | No | Not applicable for this utility. |
| Shop Drawing | No | This script does not create geometry or drawings. |

## Prerequisites
- **Required entities**: None.
- **Minimum beam count**: 0.
- **Required settings**: None. This script is self-contained.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the AutoCAD command line.
2. Browse to the location of `FLR_HangerList.mcr` and select it.
3. Click **Open**.

### Step 2: Execute Script
1. Click anywhere in the Model Space to insert the script instance.
2. The script will execute immediately.
3. A popup notice will appear confirming the total number of hanger entries loaded (e.g., "Loaded 60 entries").
4. Click **OK** to close the notice.

### Step 3: Verification
- The script instance will automatically delete itself from the drawing.
- The hanger data is now available for use by other modeling scripts (e.g., joist insertion tools).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not create a persistent object; therefore, there are no properties to edit in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | The script instance is removed immediately after execution, so no right-click menu is available. |

## Settings Files
- **Filename**: None.
- **Location**: N/A.
- **Purpose**: All hanger data (widths, heights, nail patterns, types) is compiled directly inside this script.

## Tips
- **One-Time Use**: You typically only need to run this script once per project or when updating to a new version of the hanger library.
- **Updates**: If you run the script multiple times, it will overwrite the existing hanger database with the definitions contained in this specific version of the script.
- **No Geometry**: Do not expect to see lines or 3D objects after running this. It works entirely in the background to configure other tools.

## FAQ
- **Q: I inserted the script, but it disappeared immediately. Did it fail?**
  - A: No. This is the expected behavior. The script is designed to load data and then delete its own instance to keep the drawing clean.
- **Q: Where can I see the hangers that were loaded?**
  - A: The hangers are now part of the internal database. They will appear as options in other scripts that require joist hanger selection (e.g., floor generation or beam connection tools).
- **Q: Can I edit the hanger sizes?**
  - A: Not through this script. To modify dimensions, you would need to edit the source code of `FLR_HangerList.mcr` or manually adjust the resulting MapObject entries using advanced database tools.