# hsb_WindowFlipSheet.mcr

## Overview
This script automatically regenerates structural sheathing (OSB or Plywood) around window and door openings within selected wall elements. It ensures that sheet layouts respect specified minimum width and height constraints to avoid narrow, unusable material strips.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script modifies 3D Element entities and creates new Sheet objects. |
| Paper Space | No | Not designed for layout views or shop drawings. |
| Shop Drawing | No | Does not generate 2D detailing. |

## Prerequisites
- **Required Entities:** Element objects containing Openings (Windows/Doors) and Beams (Studs/Jacks).
- **Minimum Beam Count:** 1 (Practically requires wall elements with framing).
- **Required Settings:** Element Zones must be configured with the **Distribution Type** set to **"Vertical Sheets"**.

## Usage Steps

### Step 1: Launch Script
Execute the command `TSLINSERT` in the command line.
Browse to and select `hsb_WindowFlipSheet.mcr`.

### Step 2: Configure Properties
Upon insertion, a properties dialog (or the AutoCAD Properties Palette) will appear. Set the following parameters:
- **Zones to Redistribute:** Enter the zone numbers (e.g., `1;2`) where the sheathing is located.
- **Minimum Widths:** Set the horizontal and vertical constraints.

### Step 3: Select Elements
The command line will prompt:
```
Command Line: Select a set of elements
Action: Click on the wall elements you wish to update and press Enter.
```

### Step 4: Execution
The script will process the selected elements:
1. It identifies existing sheets in the specified zones.
2. It calculates new sheet geometries around the openings, respecting jack stud locations and minimum widths.
3. It deletes the old sheets and replaces them with the newly generated ones.
4. The script instance automatically erases itself upon completion.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zones to Redistribute the Sheets | String | 1;2 | Specifies which construction layers (zones) to process. Separate multiple zone numbers with a semicolon (;). Range is 1-10. |
| Enter a minimum width of sheeting for horizontal distribution | Number | 100 | The smallest allowable width (in mm) for a sheathing segment. Prevents creating narrow strips beside windows or corners. |
| Enter a minimum width of sheeting for vertical distribution | Number | 0 | The smallest allowable height (in mm) for a sheathing segment above or below windows. If 0, standard zone heights are used. |

## Right-Click Menu Options
This script does not add specific options to the right-click context menu.

## Settings Files
- **Filename:** Element Zone Configuration (Catalog).
- **Location:** Defined in your hsbCAD Company or Installation path.
- **Purpose:** The script relies on the "Vertical Sheets" distribution setting within the Element's Zone configuration. If the zone is set to "Continuous" or another type, the script will skip that zone.

## Tips
- **Zone Configuration:** Ensure the specific layer (Zone) you want to modify is set to **"Vertical Sheets"** distribution in the Element properties *before* running the script. Zones with other distribution types will be ignored.
- **Combine Openings:** The script includes logic to combine overlapping or nearby openings, ensuring sheathing runs continuously across complex window groups.
- **Preserving Properties:** The script attempts to copy the Material, Name, and BeamCode from existing sheets before deleting them. Ensure your catalog has default values set if you are running this on a new element with no sheets.
- **Re-running:** To update the sheets later (e.g., after moving a window), simply re-insert the script. It will overwrite the previous sheet layout.

## FAQ
- **Q: I ran the script, but nothing happened in my wall.**
  A: Check your Element Zone settings. The script only processes zones where the Distribution Type is explicitly set to **"Vertical Sheets"**.
- **Q: Why are there still narrow strips of sheathing beside my window?**
  A: Increase the value of **Enter a minimum width of sheeting for horizontal distribution** in the properties palette and re-run the script.
- **Q: Does this work on gable walls or roofs?**
  A: This script is designed for standard wall elements with vertical sheeting distribution. Results on complex geometries may vary.