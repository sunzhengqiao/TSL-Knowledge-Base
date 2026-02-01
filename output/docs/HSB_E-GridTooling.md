# HSB_E-GridTooling.mcr

## Overview
This script automatically applies linear machining operations (drills, mill slots, or saw cuts) across an element based on a user-defined grid of planes. It is designed to efficiently create evenly spaced holes for services or slots for framing connections across multiple studs or joists within a wall or floor element.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be inserted into the 3D model and attached to an Element. |
| Paper Space | No | This script does not function in layout views. |
| Shop Drawing | No | This script modifies production data, not drawing views. |

## Prerequisites
- **Required Entities:** An `Element` (containing `GenBeams`) must exist in the model.
- **Minimum Beam Count:** 0 (The script filters existing beams; it does not create them).
- **Required Settings:** None specific to external files, though machine catalogs should be available if specific tool indices are needed.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse and select `HSB_E-GridTooling.mcr`.

### Step 2: Configure Initial Settings
If running from the TSL Insert command (and not a predefined catalog entry), a properties dialog may appear.
1.  Select the **Tool type** (e.g., Frame drill, Mill line).
2.  Set the **Zone index** to target the correct layer of the element.
3.  Click OK to proceed.

### Step 3: Select Elements
```
Command Line: Select elements
Action: Click on the Element(s) in the model you wish to apply the grid tooling to. Press Enter to confirm selection.
```

### Step 4: Adjust Grid and Parameters
1.  Select the newly created script instance (look for the symbol/visuals on the element).
2.  Open the **Properties Palette** (Ctrl+1).
3.  Modify the **Horizontal positions** or **Vertical positions** to define the grid offsets (in mm), or drag the grid lines directly in the model.
4.  Use the **Filter beams with beamcode** property to restrict tooling to specific studs (e.g., "STUD").

## Properties Panel Parameters

### Selection
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter type | dropdown | Include | Determines if the Beam Code list acts as a whitelist (Include) or blacklist (Exclude). |
| Filter beams with beamcode | text | | List of beam codes to target (e.g., "STUD;JST"). Supports wildcards (*). |

### Position
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Horizontal positions | text | | Semicolon-separated list of Y-axis offsets (perpendicular to element length). |
| Vertical positions | text | 500 | Semicolon-separated list of X-axis offsets (perpendicular to element width). |

### Tooling
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Tool type | dropdown | Frame drill | Select operation: Frame drill, Mill line, Saw line, or Marker line. |
| Zone index | dropdown | 1 | The specific material layer of the element to machine (1-10). |
| Tool index | number | 1 | Reference number for the specific tool in the machine library. |
| Diameter | number | 18 | Diameter of the drill bit (only used for Frame drill). |
| Depth | number | 0 | Depth of the mill or saw cut. 0 defaults to full zone thickness. |
| Extra depth | number | 0 | Additional depth added to the base cut depth. |
| Tool side | dropdown | Left | Side of the path profile the tool applies to (Left or Right). |
| Turning direction | dropdown | Against course | Rotation/feed direction relative to timber grain. |
| Overshoot | dropdown | Yes | Extends the tool path slightly beyond the intersection for clean edges. |

### Visualisation
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Color | number | 4 | CAD color index for the grid lines and symbols. |
| Symbol size | number | 40 | Size of the helper symbol drawn in the model. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add custom context menu items. Use standard Properties or Grips to edit. |

## Settings Files
- **Filename**: N/A
- **Location**: N/A
- **Purpose**: This script does not rely on external XML settings files. It uses the `_LastInserted` catalog to remember settings between uses.

## Tips
- **Dynamic Adjustment:** You can drag the square **Grip Points** on the grid lines in the model view to move them. The "Horizontal positions" and "Vertical positions" properties will automatically update with the new offsets.
- **Through-Cuts:** Leave the **Depth** set to `0` to automatically calculate the correct depth based on the thickness of the material zone you selected.
- **Filtering:** If you only want to drill the top plates of a wall and not the studs, set the **Filter type** to "Exclude" and enter the stud beam code (e.g., "STUD") in the **Filter beams with beamcode** field.
- **Grid Setup:** Enter positions as a semicolon-separated string (e.g., `500; 1000; 1500`) to create multiple lines at once.

## FAQ
- **Q: Why don't I see any holes generated?**
- **A:** Check if your **Filter beams with beamcode** matches the actual beams in the element. If using "Include", ensure the beam codes match exactly. Also, verify that your Grid Position offsets actually intersect with the beams in the element.
- **Q: Can I use this for a single hole?**
- **A:** Yes. Simply enter a single value in the Horizontal or Vertical positions property.
- **Q: What happens if I change the Tool Type?**
- **A:** Switching from "Frame drill" to "Mill line" changes the target entity from the individual Beams to the Element Zone. Ensure your Zone Index is correct for Mill/Saw operations.