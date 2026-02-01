# hsb_DrawOutline.mcr

## Overview
Generates a 2D CAD outline of selected structural elements (walls, beams, floors, or sheets) with automatic hatching and coloring based on element type codes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script generates geometry in the 3D model, typically on the XY plane. |
| Paper Space | No | |
| Shop Drawing | No | This script is for model layouts, not production drawings. |

## Prerequisites
- **Required Entities**: ElementWall, Beam, ElementRoof, or Sheet (depending on selected mode).
- **Minimum Count**: At least 1 entity must be selected.
- **Required Settings**:
    - hsbCAD Line Types (`_LineTypes`)
    - Hatch Patterns (`_HatchPatterns`)
    - Dimension Styles (`_DimStyles`)

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_DrawOutline.mcr` from the list.

### Step 2: Select Execution Mode
```
Dialog Box/Command Line: Select Mode
Action: Choose the type of element to outline (Walls, Beams, Floors, or Sheets).
```

### Step 3: Select Elements
```
Prompt: Select [Element Type]
Action: Select the desired walls, beams, floors, or sheets from the model view. Press Enter to confirm selection.
```

### Step 4: Insertion
```
Prompt: Specify insertion point
Action: Click in the model to place the script instance. The 2D outline will be generated based on the selected elements.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **sMode** | Enum | Walls | Selects the type of structural element to process (Walls, Beams, Floors, Sheets). |
| **sLineType** | String | _LineTypes | The CAD line type (e.g., Continuous) used for the outline geometry. |
| **Wall Classification (External)** | | | |
| psExtType | String | A;B; | List of wall codes (separated by semicolons) defining External walls. |
| sHatchExt | String | _HatchPatterns | Hatch pattern applied to External walls. |
| nColorExt | Index | 1 | Outline color index for External walls. |
| nColorHatchExternal | Index | 1 | Hatch color index for External walls. |
| **Wall Classification (Party)** | | | |
| psPartyType | String | | List of wall codes defining Party (fire/compartment) walls. |
| sHatchParty | String | _HatchPatterns | Hatch pattern applied to Party walls. |
| nColorParty | Index | 3 | Outline color index for Party walls. |
| nColorHatchParty | Index | 1 | Hatch color index for Party walls. |
| **Wall Classification (Load Bearing)** | | | |
| psLoadBearingType | String | A;B; | List of wall codes defining Load Bearing walls. |
| sHatchLoadBearing | String | _HatchPatterns | Hatch pattern applied to Load Bearing walls. |
| nColorLoadBearing | Index | 4 | Outline color index for Load Bearing walls. |
| nColorHatchBearing | Index | 1 | Hatch color index for Load Bearing walls. |
| **Wall Classification (Internal)** | | | |
| psIntType | String | D;E; | List of wall codes defining Internal (non-load-bearing) walls. |
| sHatchInt | String | _HatchPatterns | Hatch pattern applied to Internal walls. |
| nColorInt | Index | 2 | Outline color index for Internal walls. |
| nColorHatchInternal | Index | 1 | Hatch color index for Internal walls. |
| **Default Settings (Other)** | | | |
| sHatch | String | _HatchPatterns | Default hatch pattern for uncategorized walls. |
| nColor | Index | 3 | Default outline color for uncategorized walls. |
| nColorHatch | Index | 1 | Default hatch color for uncategorized walls. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add/Remove Beams | (Beams Mode) Opens the selection dialog to add or remove beams from the outline set. |
| Add/Remove Sheets | (Sheets Mode) Opens the selection dialog to add or remove sheets from the outline set. |
| Recalculate | Refreshes the geometry if elements have moved or properties have changed. |

## Settings Files
- **LineTypes**: Managed via standard hsbCAD `_LineTypes` catalog.
- **Hatch Patterns**: Managed via standard hsbCAD `_HatchPatterns` catalog.
- **Purpose**: These define the visual styles available in the Properties Panel dropdowns.

## Tips
- **Coding Strategy**: Ensure your Wall Names in the model (e.g., `Wall_Ext_200`) contain the specific codes defined in the properties (e.g., `Ext`) to trigger the correct hatching automatically.
- **Floors Mode**: When using Floors mode, the script merges all selected elements into a single body and labels it with the Element Number at the centroid.
- **Organization**: The script automatically assigns itself to House Level and Floor Level groups for better model organization.

## FAQ
- Q: Why are my walls not hatching?
- A: Check that the **Code** in the wall's properties matches one of the lists in the script properties (e.g., `psExtType`). Ensure the semicolons are used correctly as separators.
- Q: How do I change the color of all external walls at once?
- A: Select the script instance, open the Properties Palette, and change the `nColorExt` value.
- Q: Can I use this for roof plans?
- A: Yes, select "Floors" or "Beams" mode to generate a top-down shadow/profile of roof elements.