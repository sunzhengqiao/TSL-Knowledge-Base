# HSB_R-RafterBlocking

## Overview
This script automatically generates blocking (noggins) between rafters or between rafters and a supporting element. It is used to prevent rotation of rafters and distribute loads by creating physical timber beams based on a selected roof element.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script generates 3D geometry in the model. |
| Paper Space | No | Not applicable for 2D drawings. |
| Shop Drawing | No | Not applicable for shop drawings. |

## Prerequisites
- **Required Entities**: An Element (e.g., a roof plane or construct) containing rafter beams.
- **Minimum Beam Count**: 1 or more beams within the selected element.
- **Required Settings**: None (uses default internal settings or catalog presets if available).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `HSB_R-RafterBlocking.mcr`.

### Step 2: Select Configuration
Dialog: If a default catalog entry is not configured, a dialog may appear to set initial parameters.
Action: Configure Blocking dimensions, Positioning, and Tooling as needed, then click OK.

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the roof Element or Construct containing the rafters where blocking should be applied. Press Enter to confirm.
```

### Step 4: Adjust Parameters (Optional)
Action: Select the generated script instance (represented by a grip point) and modify parameters in the Properties Palette (OPM) to fine-tune the blocking layout.

## Properties Panel Parameters

### Blocking Information
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Blocking length | Number | 100 mm | Length of the blocking along the rafter. Set to 0 to use the rafter height automatically. |
| Blocking height | Number | 20 mm | Thickness of the blocking (vertical direction). Set to 0 to use the rafter width automatically. |
| Blocking width | Number | 20 mm | Width of the blocking. Set to 0 to use the rafter height automatically. |

### Positioning
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Blocking position | Dropdown | Left side only | Options: Left side only, Left and right side, Right side. Determines where blocks are placed relative to rafters. |
| Blocking reference | Dropdown | Top | Options: Top, Bottom. Calculates the vertical offset from either the top or bottom edge of the rafter. |
| Blocking vertical offset | Number | 500 mm | Distance from the reference edge (Top/Bottom) to the center of the blocking. |
| Alternate blocking | Dropdown | No | Options: Yes, No. If Yes, creates a staggered zigzag pattern. |
| Skip first rafter | Dropdown | No | Options: Yes, No. If Yes, omits the blocking at the very start of the run. |

### Tooling
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Tool type | Dropdown | No tool | Options: No tool, Beamcut. If set to Beamcut, adds a milling operation to the blocking. |
| Tool depth | Number | 5 mm | Depth of the beamcut/milling. |
| Tool offset | Number | 0 mm | Offset position of the tool. |
| Tool diameter | Number | 0 mm | Diameter of the tool used for the cut. |

### Beam Properties
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Color | Number | 52 | AutoCAD color index for the blocking beams. |
| Name | String | Empty | BIM Name attribute. |
| Material | String | Empty | Material specification (e.g., C24). |
| Grade | String | Empty | Timber grade. |
| Label | String | Empty | Primary label for drawings/reports. |
| Beamcode | String | Empty | Classification code for reporting. |

### Filtering
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Rafters - Beam codes | String | Empty | List of beam codes to EXCLUDE from blocking generation. Use this to ignore top plates or trimmers. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the blocking geometry based on current property changes. |
| Show Catalog | Allows selection of a predefined catalog configuration. |
| Erase | Removes the script instance and all generated blocking. |

## Settings Files
- **Filename**: `HSB_R-RafterBlocking.xml` (or similar catalog name)
- **Location**: Company or Install path (Catalog folder)
- **Purpose**: Stores saved configurations (Execute Keys) so users can quickly reload specific blocking settings without re-entering values.

## Tips
- **Automatic Dimensions**: Set Blocking Length, Height, or Width to `0` to automatically match the corresponding dimension of the rafter (e.g., setting Length to 0 makes the block as long as the rafter is deep).
- **Filtering Plates**: If the script is creating blocking on your top plates or ridge beams, add those beam codes to the "Rafters - Beam codes" filter property to exclude them.
- **Staggered Pattern**: Use "Alternate blocking" set to "Yes" with "Blocking position" set to "Left and right side" to create a structural zigzag pattern common in framing.
- **Visualizing**: If blocking is not appearing, check the "Blocking vertical offset" to ensure it is actually intersecting the rafters and not floating above or below them.

## FAQ
- **Q: Why are no blocks showing up?**
  A: Check the "Rafters - Beam codes" filter. You may be excluding all beams. Also, ensure the "Blocking vertical offset" places the blocks within the rafter's geometry.
- **Q: How do I make the blocks fit perfectly between rafters?**
  A: This script generates blocks *next to* rafters (blocking), not necessarily between them. However, ensuring the "Blocking width" matches the space available is key. Use 0 or specific dimensions to control this.
- **Q: Can I use this for floor joists?**
  A: Yes, while named "RafterBlocking," it works on any Element containing beams, such as floor joists or wall studs. Just select the appropriate element.