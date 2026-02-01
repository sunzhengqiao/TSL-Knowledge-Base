# CheckBeamSpacing.mcr

## Overview
This script automatically checks the spacing between vertical studs or rafters in wall and roof elements. It highlights spacing violations using visual markers and colors, and can optionally insert additional beams to ensure the structure meets maximum spacing requirements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used for checking element geometry and inserting new beams. |
| Paper Space | No | Not intended for layout views or annotations. |
| Shop Drawing | No | Does not generate shop drawing details. |

## Prerequisites
- **Required Entities**: At least one `ElementWallSF` (Wall) or `ElementRoof` containing vertical beams.
- **Minimum Beam Count**: Requires at least two vertical beams to calculate the distance between them.
- **Required Settings**: None required for basic functionality, though default properties should be reviewed for specific building codes.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `CheckBeamSpacing.mcr`.

### Step 2: Configuration (If not using Catalog)
```
Command Line: [Dialog appears if no catalog key is found]
Action: Configure the maximum spacing, choose whether to add beams automatically, and set visual warning colors. Click OK to proceed.
```

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the Wall or Roof elements you wish to check. Press Enter to confirm selection.
```

### Step 4: Review Results
The script will process the selected elements.
- **Spacing OK**: If no issues are found, the script instance may erase itself automatically.
- **Spacing Issue**: Beams violating the spacing rule will change color. If enabled, circles and dimensions will appear at the violation locations. If "Automatic add beams" is enabled, new beams will be inserted into the element.

## Properties Panel Parameters

### General
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Sequence number | number | 0 | Determines the order in which this script runs relative to other TSLs during generation. |
| Filter beams with beamcode | text | (Empty) | Enter beam codes (e.g., "Rim", "Post") to exclude specific beams from the spacing check. |

### Dimensions
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Maximum allowed spacing | number | 0 | The maximum distance allowed between beams. Set to 0 to use the spacing defined in the Element's properties. |
| Automatic add beams | dropdown | No | Strategy for fixing spacing violations: "No", "From left", "In center", or "From right". |
| Show circle | dropdown | No | If "Yes", draws a circle at locations where spacing exceeds the maximum. |

### Color
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Color of the wrong beam | number | 1 | The color index used to highlight existing beams that are too far apart. |
| Color of the added beam | number | 3 | The color index used for beams automatically created by this script. |
| Color of the circle | number | 1 | The color index for the circle visual marker. |

### New beam properties
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Color | number | 1 | The permanent color assigned to newly added beams. |
| Beam name | text | (Empty) | The name assigned to newly added beams (e.g., "AddedStud"). |
| Beam type | dropdown | Stud | Classifies the new beam as "Stud" or "Beam". |
| Beam material | text | (Empty) | The material code assigned to newly added beams. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No specific context menu items are added by this script. Use the Properties Palette (OPM) to modify settings. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external XML settings files; it uses script properties and/or Catalog entries.

## Tips
- **Using Defaults**: Keep `Maximum allowed spacing` set to `0` to automatically respect the spacing settings already defined in your Wall or Roof element properties.
- **Ignoring Openings**: Use the `Filter beams with beamcode` property to exclude trimmers or headers around windows/doors so they don't trigger spacing errors for the rest of the wall.
- **Visual Checks**: Enable `Show circle` temporarily to quickly identify problem areas in a large model without modifying the geometry (ensure `Automatic add beams` is set to "No").

## FAQ
- **Q: The script disappeared after I ran it. Did it fail?**
  - A: No. If the script finds no spacing violations (or adds beams and fixes them), it automatically erases its own instance to keep the drawing clean. Check if new beams were added or if your spacing is actually correct.
  
- **Q: How do I remove the red circles and dimensions?**
  - A: Delete the TSL instance from the element, or set the `Show circle` property to "No" and update the script.

- **Q: Can I add beams in the middle of a wide bay automatically?**
  - A: Yes. Set `Automatic add beams` to "In center". The script will calculate the required number of beams and place them in the center of the gap.