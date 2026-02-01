# HSB_D-Sheet

## Overview
This script automatically generates dimension lines, material labels, and geometric data for timber sheets on 2D drawings (layouts). It is used to annotate floor cassettes, wall panels, or roof sheets shown in a viewport, ensuring sizes are correct relative to the sheet's coordinate system.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed specifically for layouts. |
| Paper Space | Yes | The script must be inserted onto a layout tab containing a viewport. |
| Shop Drawing | N/A | This is an interactive script for detailing layouts, not an automated shop drawing generator. |

## Prerequisites
- **Required Entities**: A Viewport in Paper Space that is linked to a Sheet element (or Element).
- **Minimum Beam Count**: 0.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_D-Sheet.mcr`

### Step 2: Select Viewport
```
Command Line: Selecteer een viewport
Action: Click on the viewport border or inside the viewport that displays the sheets you want to dimension.
```

### Step 3: Select Position
```
Command Line: Selecteer een positie
Action: Click a point in the Paper Space (layout) where you want the script instance anchor to be placed.
```

### Step 4: Configure Properties
After selecting the position, the Properties Palette will open. Adjust the filters and dimension settings to match your detailing requirements.

## Properties Panel Parameters

### Selection
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Include/exclude | dropdown | No | Determines if the filters below are used to Include specific sheets in the dimensioning or Exclude them. |
| Filter beamcode | text | [Empty] | Filter sheets by their BeamCode (e.g., 'FLR', 'WALL'). Leave empty to accept all codes. |
| Filter material | text | [Empty] | Filter sheets by their material name (e.g., 'C24'). |
| Filter label | text | [Empty] | Filter sheets by their assigned label property. |

### Dimension Object
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone | dropdown | 1 | Selects the manufacturing zone number (1-10) to dimension. Only sheets belonging to this zone will be processed. |
| Dimension perimeter | dropdown | Yes | If Yes, draws overall dimension lines indicating the total length and width of the sheet. |
| Dimension sheet edges | dropdown | At sheet edges | Sets the style for internal dimensions. <br>• *No dimension*: No internal dims.<br>• *At sheet edges*: Places dimensions at the specific edges of boards.<br>• *Dimension lines*: Creates continuous dimension chains. |
| Dimension extremes per sheet | dropdown | Yes | If Yes, dimensions the extreme outer points (min/max) of the sheet configuration. Only works if 'Dimension sheet edges' is set to 'At sheet edges'. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Filter Elements | Allows you to manually filter specific elements. If an element is filtered, the instance name changes color to indicate it is being filtered out. |

## Settings Files
- **Filename**: None specified.
- **Location**: N/A
- **Purpose**: This script operates via standard Properties Palette settings.

## Tips
- **Self-Destruct Mechanism**: If you attempt to insert the script again on the same viewport (Cycle > 1), the instance will erase itself. To update dimensions, select the existing instance and modify its properties in the palette.
- **Viewport Linking**: Ensure the viewport you select is actually linked to the 3D model; otherwise, the script cannot detect the sheets to dimension.
- **Color Change**: If the text of the script instance changes color, check if elements have been manually filtered via the right-click menu.

## FAQ
- **Q: Why did the script disappear after I tried to insert it again?**
  A: The script is designed to run only once per insertion cycle. If you insert it again in the same session, it deletes the previous instance and exits to prevent duplicates. Use the Properties palette to modify the existing one.
- **Q: Can I use this to dimension individual beams?**
  A: No, this script is designed specifically for "Sheets" (e.g., cassettes, panels), not single timber beams.
- **Q: What does "Selecteer een viewport" mean?**
  A: This is Dutch for "Select a viewport". The script prompts you to click on the viewport frame in your layout that displays the model you wish to dimension.