# HVAC-G

## Overview
This script creates a G-connection (bend) between two ductwork beams. It automatically calculates the geometry based on the intersection of the selected beams and applies the necessary cuts.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for selecting 3D ductwork beams. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | This is a model generation script. |

## Prerequisites
- **Required Entities**: Two ductwork beams (GenBeam objects).
- **Minimum Beam Count**: 2 (Non-parallel).
- **Required Settings**: `HVAC.xml` (Located in the company TSL settings folder).

## Usage Steps

### Step 1: Launch Script
Execute the `TSLINSERT` command in AutoCAD and select `HVAC-G.mcr` from the list.

### Step 2: Select First Beam
```
Command Line: Select 2 ductwork beams
Action: Click on the first ductwork beam you wish to connect.
```

### Step 3: Select Second Beam
```
Command Line: Select second ductwork beam
Action: Click on the second ductwork beam.
```
*Note:* The script will validate your selection:
- If you select the **same beam twice**, the command line will display "refused (Duplicate)". Please select a different beam.
- If the beams are **parallel**, the command line will display "refused (parallel)". Please select beams that form an angle.

## Properties Panel Parameters
This script does not expose specific parameters in the Properties Palette (OPM). It derives its dimensions and configuration from the selected beams and the `HVAC.xml` settings file.

## Right-Click Menu Options
This script does not add custom items to the right-click context menu. Standard hsbCAD options (like Recalculate) apply.

## Settings Files
- **Filename**: `HVAC.xml`
- **Location**: `_kPathHsbCompany\TSL\Settings` (Company TSL folder).
- **Purpose**: Defines default dimensions and configuration settings for the HVAC G-connection generation.

## Tips
- **Dynamic Updates**: The connection is associative. If you use AutoCAD grips to move or rotate the connected beams, the G-connection will automatically update to match the new geometry.
- **Deletion**: If you delete one of the source beams, the G-connection instance will also be deleted automatically.
- **Visual Warnings**: If the script detects that the beams are not in the same plane (which might make a physical connection impossible), it will draw a visual alert or helper lines instead of a solid body.

## FAQ
- **Q: Why does the script say "refused (parallel)"?**
  A: The G-connection tool only works on beams that intersect or form an angle. It cannot connect parallel ducts.
- **Q: Can I adjust the bend radius after insertion?**
  A: The radius is typically determined by the beam properties or the XML settings. Modify the beam's properties or the XML file and recalculate to update the connection.
- **Q: What happens if I change the size of the duct?**
  A: The script listens for changes in the beam data. If you modify the beam size, run a recalculation (or move the beam slightly), and the connection will update to fit the new dimensions.