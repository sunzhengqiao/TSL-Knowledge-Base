# hsb_DrawFoundationLine.mcr

## Overview
This script automates the creation of 2D foundation lines by deriving geometry from your selected wall elements. It applies specific offset distances to External, Internal, and Party walls based on their assigned codes, helping you quickly generate concrete or footing layouts.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script is designed for use in the 3D model. |
| Paper Space | No | Not supported for layout generation. |
| Shop Drawing | No | Not supported for manufacturing drawings. |

## Prerequisites
- **Required entities**: `ElementWall` entities must exist in the model.
- **Minimum beam count**: 0 (This script operates on walls).
- **Required settings**: None specific, though standard hsbCAD wall properties are used for classification.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse to and select `hsb_DrawFoundationLine.mcr`

### Step 2: Configure Properties (Initial Run)
```
Action: The Properties Palette will automatically open upon insertion.
Action: Configure Wall Codes and Offsets before selecting walls (see Properties Panel below).
```

### Step 3: Select Walls
```
Command Line: Please select Walls
Action: Click on individual walls or use a window selection to choose the walls you want to generate foundation lines for.
Action: Press Enter to confirm selection.
```
*Once selected, the script will process the geometry and draw the foundation lines.*

## Properties Panel Parameters

### General Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show in Disp Rep | text | "" | The display representation name (e.g., 'Presentation') where these lines will be visible. |
| Line Type | dropdown | _LineTypes | The CAD line style (e.g., Continuous, Dashed) to use for the foundation lines. |
| Dim style | dropdown | _DimStyles | The dimension style to assign to the foundation lines. |
| Color Foundation Lines | number | 3 | The CAD color index (1-255) for the drawn lines. |

### External Walls
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Code External Walls | text | "A;B;" | The wall codes (separated by `;`) that define an External wall. |
| Offset Front External Walls | number | 300 | The offset distance (mm) from the Front face of external walls. |
| Offset Back External Walls | number | 250 | The offset distance (mm) from the Back face of external walls. |

### Internal Walls
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Code Internal Walls | text | "D;E;" | The wall codes (separated by `;`) that define an Internal wall. |
| Offset Front Internal Walls | number | 300 | The offset distance (mm) from the Front face of internal walls. |
| Offset Back Internal Walls | number | 250 | The offset distance (mm) from the Back face of internal walls. |

### Party Walls (Other)
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Offset Front Party Walls | number | 300 | The offset distance (mm) from the Front face of walls that do not match the External or Internal codes. |
| Offset Back Party Walls | number | 250 | The offset distance (mm) from the Back face of walls that do not match the External or Internal codes. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | This script does not add specific items to the right-click context menu. Use the standard Properties palette to modify parameters. |

## Settings Files
- **None**: This script does not require external settings files.

## Tips
- **Code Separators**: Always use a semicolon `;` to separate multiple wall codes (e.g., `A;B;EXT;`).
- **Classification**: Any wall code *not* listed in the External or Internal lists will be treated as a "Party Wall" and use the Party offset settings.
- **Updating Geometry**: If you move your walls after drawing the foundation lines, select the script entity and choose **Recalculate** (or use the `TSLUPDATE` command) to update the foundation positions.
- **Visibility**: If the lines disappear, check the **Show in Disp Rep** property to ensure it matches your current view mode (e.g., if you are in "Drafting" mode, the property must be set to "Drafting").

## FAQ
- **Q: My foundation lines are not drawing where I expect.**
  A: Check that the Wall Codes in your ElementWall properties match exactly with the **Code External Walls** or **Code Internal Walls** fields in the script properties (including semicolons).
- **Q: How do I change the width of the foundation line?**
  A: The total width is calculated by the sum of the Front and Back offsets. Adjust **Offset Front** and **Offset Back** values in the Properties panel.
- **Q: What defines the "Front" vs "Back" of a wall?**
  A: This is determined by the wall's local coordinate system/creation direction in hsbCAD. If offsets appear reversed, try swapping the Front and Back values.