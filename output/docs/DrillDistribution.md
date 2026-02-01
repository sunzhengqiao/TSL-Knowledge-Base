# DrillDistribution.mcr

## Overview
This script automates the creation and distribution of holes, slots, and countersinks along a specific path on structural timber beams. It supports distribution based on beam intersections, polylines, or manually placed grip points.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates exclusively in the 3D model. |
| Paper Space | No | Not applicable. |
| Shop Drawing | Yes/No | While it creates geometry for shop drawings, it is a model-space script. |

## Prerequisites
- **Required Entities:** At least one GenBeam (Structural Timber Beam).
- **Minimum Beam Count:** 1
- **Required Settings:** None (Defaults are used if no settings file is loaded).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `DrillDistribution.mcr`

### Step 2: Select Host Beams
```
Command Line: Select genbeams to be drilled
Action: Click on the timber beam(s) you wish to machine. Press Enter to confirm selection.
```

### Step 3: Define Path
```
Command Line: Select GenBeams or Polylines for path [or press Enter for Grip Points]
Action: 
- Option A: Select intersecting beams or a polyline to define the drill line automatically.
- Option B: Press Enter without selecting anything to use "Grip Point" mode for manual placement.
```

### Step 4: Configure Tool
```
Command Line: (Property Palette opens automatically)
Action: In the Properties Palette, select a Tool Definition (e.g., "M12 Bolt") or manually set Diameter/Depth.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sTool | Dropdown | *Default Entry* | Select a preset tool configuration (e.g., Bolt size, Slot dimensions). |
| sDistributionFormat | String | `@(Quantity-2)x @(Diameter)` | Defines the text label format for shop drawings (e.g., "10x 20mm"). |
| kStereotype | String | `""` | Assigns a classification for filtering in BIM reports or schedules. |
| sDisplayStyle | Enum | Default | Controls how the tool is visualized (Distribution Path, Tool Contour, Tool Axis). |
| nc | Integer | Dynamic | Sets the color of the drill preview graphics. |
| nt | Integer | 0-90 | Sets the transparency percentage of the drill preview (0 = Opaque). |
| sFolder / sFullPath | String | Project Path | File path used to Import or Export XML settings files. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add Genbeams | Adds additional beams to the selection set to be drilled. |
| Remove Genbeams | Removes specific beams from the current selection set. |
| Convert To Polyline | Converts the logical path definition into a static polyline, breaking links to source beams. |
| Convert To Grip Points | Switches the distribution method to manual grip points for individual adjustment. |
| New Tool Definition | Saves the current parameter set (Diameter, Depth, etc.) as a named preset in the tool list. |
| Erase Tool Definition | Deletes the currently selected named preset from the tool list. |
| Import Settings | Loads tool and display configurations from an external XML file. |
| Export Settings | Saves current tool and display configurations to an external XML file. |
| Display Settings | Opens a dialog to quickly adjust Color, Transparency, and visual Style. |
| Configure Shopdrawing | Opens options for dimensioning and labeling the hole pattern in production drawings. |

## Settings Files
- **Filename**: `[User Defined].xml`
- **Location**: Project folder or Company folder (as specified in script properties).
- **Purpose**: Stores Tool Definitions (geometries) and Display Settings (colors/transparency) to ensure consistency across different projects or users.

## Tips
- **Quick Layouts:** If you need a straight row of bolts, simply draw a polyline in the model and select it during the Path Definition step.
- **Grip Editing:** After insertion, use the 3D grips (Blue squares) to stretch the start/end of the drill row or adjust the spacing between holes without re-opening the script.
- **Consistency:** Use "Export Settings" to save your standard bolt configurations and share them with your team to ensure everyone uses the same drill sizes.

## FAQ
- **Q: How do I change the hole size after inserting the script?**
  **A:** Select the script instance in the model, open the Properties Palette (Ctrl+1), and change the `sTool` dropdown or manually enter a new Diameter.
  
- **Q: Can I use this for curved beams?**
  **A:** Yes. If you select a curved polyline or a curved beam as the path element during Step 3, the drills will follow the curve.

- **Q: What happens if I delete the beam used to define the path?**
  **A:** If the script relies on a path beam (not converted to grips), deleting that beam will cause the script to lose its path reference. Use "Convert To Grip Points" or "Convert To Polyline" to make the layout independent of other beams.