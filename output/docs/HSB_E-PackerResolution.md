# HSB_E-PackerResolution.mcr

## Overview
Automatically calculates and inserts a timber packer (filler piece) between two adjacent studs in a wall element to fill a specific void. This tool is useful for resolving spacing conflicts around openings or ensuring insulation continuity where stud spacing is non-standard.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be run in the 3D model to interact with wall elements. |
| Paper Space | No | Not designed for layout views or shop drawings. |
| Shop Drawing | No | This is a modeling tool only. |

## Prerequisites
- **Required Entities**: A Wall Element containing existing studs/beams.
- **Minimum Beam Count**: The wall must have at least two parallel studs to define a gap.
- **Required Settings**: None. The script uses standard project catalogs for beam types and materials.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-PackerResolution.mcr`

### Step 2: Configuration
If no Execute Key is preset, a **Properties Dialog** will appear automatically.
- **Action**: Adjust the *Minimum Gap* and *Maximum Gap* tolerances, or set the desired *Packer Name* and *Material*. Click OK.

### Step 3: Select Element
```
Command Line: Select element
Action: Click on the Wall Element (or floor) where the gap exists.
```

### Step 4: Specify Point
```
Command Line: Specify point
Action: Click inside the gap between two studs where you want the packer inserted.
```
*The script will automatically detect the nearest studs to the left and right of your click, calculate the distance, and insert the packer. The script instance will then erase itself, leaving only the new timber beam.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Minimum Gap** | Number | 0.1 mm | The smallest void size considered manufacturable. Gaps smaller than this value will trigger an error ("Gap is to small"). |
| **Maximum Gap** | Number | 200.0 mm | The largest void size allowed for a packer. Gaps larger than this typically require a full structural stud. |
| **Packer Name** | Text | Packer | The identifier assigned to the generated beam (e.g., for BOMs and labels). |
| **Packer Material** | Text | *Project Default* | The timber grade or material class for the packer (e.g., C24). |
| **Packer Type** | Dropdown | *Project Default* | The construction class of the beam (Standard, Solid Timber, etc.). |
| **Color** | Number | 32 | The AutoCAD color index used to display the packer in the model. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add custom options to the right-click context menu after insertion. |

## Settings Files
- **Filename**: *None specific*
- **Location**: N/A
- **Purpose**: The script saves user settings to the 'LastInserted' catalog in hsbCAD but does not rely on external XML configuration files.

## Tips
- **Click Precisely**: Ensure you click clearly between two studs. If you click too close to a plate or the end of the wall, the script may not find bounding studs.
- **Self-Cleaning**: The script instance removes itself from the drawing immediately after creating the packer. Do not look for the script origin point afterwards.
- **Editing**: The resulting packer is a standard GenBeam. You can modify its dimensions or properties later using normal AutoCAD grips or the Properties palette.

## FAQ

**Q: Why does the script say "Cannot identify nearest studs"?**
A: This happens if the point you clicked is not between two parallel beams (studs) within the selected element. Ensure you are clicking in a valid gap between vertical studs and not overlapping a plate.

**Q: Why does the script say "Gap is to small"?**
A: The distance between the two studs is less than the *Minimum Gap* setting (default 0.1mm). The studs might be touching or overlapping slightly. Adjust the *Minimum Gap* property or move the studs further apart.

**Q: Can I use this to fill large gaps (e.g., 500mm)?**
A: While technically possible, the *Maximum Gap* setting (default 200mm) is intended to prevent using this tool where a structural stud is required. You can increase the *Maximum Gap* parameter in the Properties Panel if necessary, but ensure structural integrity is maintained.