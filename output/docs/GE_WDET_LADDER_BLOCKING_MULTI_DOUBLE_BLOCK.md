# GE_WDET_LADDER_BLOCKING_MULTI_DOUBLE_BLOCK.mcr

## Overview
This script automatically generates "ladder" blocking (horizontal framing) within wall elements. It supports complex configurations including fixed blocking at specific heights, evenly spaced non-fixed blocking, double framing options, and variable orientation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Generates physical 3D beams within a Wall Element. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: Element (specifically `ElementWallSF`).
- **Minimum Beam Count**: 0 (The script generates the blocking beams).
- **Required Settings Files**:
  - `hsbFramingDefaults.Inventory.dll` (Must be present in `Utilities\hsbFramingDefaultsEditor`).

## Usage Steps

> **Note:** This script **cannot be manually inserted** via the command line. It is designed to be generated automatically via the **Defaults Editor** or Construction Directives when processing Wall T-connections.

If you attempt manual insertion, the script will display a warning and exit. To use this script:

1.  Open the **hsbDefaultsEditor**.
2.  Navigate to the appropriate Wall/T-connection construction directive.
3.  Assign this script (`GE_WDET_LADDER_BLOCKING_MULTI_DOUBLE_BLOCK.mcr`) to the desired connection.
4.  Configure the Properties Panel parameters (see below).
5.  **Generate/Update** the drawing to apply the blocking.

*(Note: Although the script contains prompts for Element and Insertion Point selection, the manual insertion logic is blocked to enforce workflow through the Defaults Editor.)*

## Properties Panel Parameters

### General
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Orientation | dropdown | Edge | Sets the rotation of the blocking beam. **Edge** stands perpendicular to the wall; **Flat** lays parallel. |
| Double framing (both sides of wall) | dropdown | No | If **Yes**, duplicates blocking on the opposite side of the wall (only works if Orientation is Flat). |
| Measure to | dropdown | Center of block | Defines if the spacing measurement is taken from the center or the edge of the block. |

### Non-fixed blocking
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Spacing | number | 610.0 | The vertical distance between ladder blocking blocks. |
| Distribution starting point | dropdown | Bottom of wall | Determines where spacing calculations start. Options: Bottom, Top, Middle of wall, or Bottom fixed blocking location. |

### Fixed blocking
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Fixed blocking type | dropdown | None | Type of specific blocking to add. Options: **None**, **Single** (one block), or **Multiple** (repeating vertical pattern). |
| Spacing | number | 1220.0 | Vertical spacing used for "Multiple" fixed blocking. |
| Height of bottom fixed blocking | number | 1220.0 | The height for the first fixed block. |
| Fixed blocking quantity | dropdown | Single | Determines if fixed blocks are single or double (stacked). |

### Blocking info
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Lumber item | dropdown | *Empty* | Select a predefined lumber item from the Inventory. |
| Beam size | dropdown | From inventory | Sets the cross-section size (e.g., 2x4, 2x6). Select "From inventory" to use the Lumber item size. |
| Beam color | number | 2 | The color index for the generated beams. |
| Name | text | *Empty* | Assigns a name to the generated beams. |
| Material | text | *Empty* | Material specification. |
| Grade | text | *Empty* | Lumber grade. |
| Information | text | *Empty* | Additional information field. |
| Label | text | *Empty* | Beam label. |
| Sublabel | text | *Empty* | Beam sublabel. |
| Sublabel2 | text | *Empty* | Beam sublabel 2. |
| Beam code | text | *Empty* | Beam code. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add custom items to the right-click context menu. |

## Settings Files
- **Filename**: `hsbFramingDefaults.Inventory.dll`
- **Location**: `\\Utilities\\hsbFramingDefaultsEditor`
- **Purpose**: Provides the list of Lumber Items available in the "Blocking info" properties.

## Tips
- **Double Framing Logic**: The "Double framing" option creates blocks on both sides of the wall, but this only functions if the **Orientation** is set to **Flat**. If set to Edge, blocks remain on the selected side only.
- **Centering Distribution**: Use "Distribution starting point" set to **Middle of wall** to automatically center the ladder blocking layout vertically between the top and bottom plates.
- **Fixed vs Non-Fixed**: Use "Fixed blocking" for specific requirements like grab bar backing (set to Single at a specific height). Use "Non-fixed" for general structural ladder blocking.

## FAQ
- **Q: Can I insert this script using the TSLINSERT command?**
  - A: No. Attempting to insert it manually will result in an error message stating it "cannot be manually inserted." You must configure it in the Defaults Editor.
- **Q: How do I make the blocking go all the way from floor to ceiling?**
  - A: Ensure "Fixed blocking type" is set to **None**. In "Non-fixed blocking", set "Distribution starting point" to **Bottom of wall** (or Top) and ensure the spacing divides evenly into the wall height.
- **Q: Why didn't my blocks appear on the other side of the wall when I selected "Yes" for Double framing?**
  - A: Check your **Orientation** setting. Double framing only applies when the orientation is **Flat**.