# HSB_E-FacadeNailing.mcr

## Overview
This script automates the calculation and placement of nail clusters on timber wall elements based on specific construction zones (e.g., studs or sheathing layers). It handles automatic nailing patterns, allows for exclusion zones (no-nail areas) using polylines, and provides tools to manually add or remove individual nails.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Must be inserted on an ElementWallSF. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: An existing Wall Element (`ElementWallSF`) containing construction layers (Zones) and structural members (GenBeams).
- **Minimum beam count**: 0 (Script runs on element validity, though nails require structural members).
- **Required settings**: Standard hsbCAD environment with defined construction zones.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-FacadeNailing.mcr`

### Step 2: Select Element
```
Command Line: Select an element
Action: Click on the desired wall element in the model to which you want to apply nailing.
```

### Step 3: Configure Properties
After insertion, select the script instance in the model and open the **Properties Palette** to configure zones, spacing, and offsets.

## Properties Panel Parameters

### Brander Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Brander zone | dropdown | 1 | Selects the construction zone index for studs/intermediate columns to be nailed. |
| Distance to edge of branders | number | 0 mm | Sets the offset distance from the edge of the stud where the nail is calculated. |

### Facade Zone 1 Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Facade zone 1 (99 = no nail) | dropdown | 2 | Sets the construction layer index for the first facade layer. Set to 99 to disable nailing for this zone. |
| Tool index facade 1 | number | 4 | Assigns the specific nail gun/tool ID from the production database for this zone. |
| Distance to edge of facade 1 | number | 25 mm | Distance from the edge of the sheet/zone to the first row of nails. |
| Distance between facade 1 nails | number | 0 mm | Spacing between nails. **0** places a single nail per stud; >0 creates a pattern. |
| Reference line facade 1 | dropdown | Left (top for horizontal) | Aligns the nailing offset to the Left, Center, or Right (or Top/Bottom for horizontal). |
| Offset from reference line facade 1 | number | 0 mm | Additional shift distance applied from the selected reference line. |
| Change brander size at sheet joint to | number | 0 mm | If non-zero, overrides the stud width calculation specifically at sheet joints. |

### Facade Zone 2 Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Facade zone 2 (99 = no nail) | dropdown | 1 | Sets the construction layer index for the second facade layer. Set to 99 to disable. |
| Tool index facade 2 | number | 5 | Assigns the nail gun/tool ID for the second facade zone. |
| Distance to edge of facade 2 | number | 25 mm | Distance from the edge of the sheet/zone to the first row of nails. |
| Distance between facade 2 nails | number | 0 mm | Spacing between nails (0 = single nail). |
| Reference line facade 2 | dropdown | Left (top for horizontal) | Alignment reference for the nailing offset in Zone 2. |
| Offset from reference line facade 2 | number | 0 mm | Additional shift distance from the reference line in Zone 2. |

## Right-Click Menu Options
Select the script instance in the drawing and right-click to access these custom actions:

| Menu Item | Description |
|-----------|-------------|
| Add no nail area to facade zone 1 (or 2) | Prompts you to select a polyline. The script creates an exclusion zone inside this polyline where no nails will be placed. The nails will update automatically if the polyline is modified. |
| Remove no nail area | Prompts you to select a point inside an existing exclusion area to remove it. |
| Add nail to facade zone 1 (or 2) | Prompts you to click a specific point on the element to manually add a single nail to the designated zone. |
| Remove nail | Prompts you to click near an existing nail to remove it. |

## Settings Files
- **Filename**: None specific (Uses Element Construction Data)
- **Location**: N/A
- **Purpose**: The script relies on the hsbCAD Element's construction setup (Zones) and standard material catalogs rather than an external settings file.

## Tips
- **Exclusion Zones**: Draw closed polylines around areas like openings or vents where nailing should be avoided, then use the "Add no nail area" right-click option.
- **Single Nailing**: For simple connections, leave the "Distance between nails" parameter set to **0** to place exactly one nail per stud/intersection.
- **Manual Override**: Use the right-click "Add nail" option if the automatic calculation misses a specific structural point that requires nailing.
- **Sheet Joints**: Use the "Change brander size at sheet joint to" property to ensure nails are placed correctly where sheathing sheets meet.

## FAQ
- **Q: How do I stop nailing in a specific area, like around a window?**
  - **A:** Draw a polyline around the window in the CAD model. Right-click the script instance, select "Add no nail area," and pick that polyline.
- **Q: What does the "99" value mean in the Facade Zone settings?**
  - **A:** Setting the zone index to **99** effectively turns off nailing for that specific facade zone.
- **Q: The script says "There is no frame behind this nail" when I try to add one manually. Why?**
  - **A:** The point you clicked is outside the valid nailing area (e.g., over an opening or outside the sheet boundary). Ensure you click directly over a structural stud or valid sheet area.