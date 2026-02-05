# NA_WALL_SHOP_DRAWING.mcr

## Overview
Generates detailed 2D shop drawings for wall elements in Paper Space, including top and bottom section views, sheathing schedules, blocking details, and opening tags based on a selected elevation viewport.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script must be run in a Layout tab. |
| Paper Space | Yes | Required for selecting viewports and generating views. |
| Shop Drawing | Yes | Specifically designed for wall construction documentation. |

## Prerequisites
- **Required Entities**: An existing Viewport in Paper Space displaying an Elevation view of a Wall (`ElementWallSF`).
- **Minimum Beam Count**: 0 (Script reads the entire wall element).
- **Required Settings**:
  - Dimension Style: `'Wall Shopdrawing'` (or `'Wall Shopdrawing Italic'` as fallback).
  - Hatch Pattern: `'ANSI31'` (or default pattern defined in properties).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `NA_WALL_SHOP_DRAWING.mcr`

### Step 2: Select Drawing Origin
```
Command Line: Select top left corner of a drawing
Action: Click in the Paper Space layout where you want the top-left corner of the shop drawing block to be placed.
```

### Step 3: Select Elevation Viewport
```
Command Line: Select elevation viewport
Action: Click the border of the viewport that contains the Wall Elevation you wish to detail.
```

### Step 4: Place Hatching Legend
```
Command Line: Select grip point for hatching legend
Action: Click in the Paper Space layout where you want the material legend/key to be located.
```

## Properties Panel Parameters

### Layout & Spacing
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Section line offset Bottom view | number | 1.5" | Vertical gap between the main elevation view and the bottom section view. |
| Section line offset Top view | number | 1.5" | Vertical gap between the main elevation view and the top section view. |
| Top view offset | number | 1.25" | Vertical distance from the elevation viewport to the origin of the top view. |
| Top view dim offset | number | 0.2" | Distance between top view geometry and its dimension lines. |
| Bottom view offset | number | 1.0" | Vertical distance from the elevation viewport to the origin of the bottom view. |
| Bottom view dim offset | number | 0.2" | Distance between bottom view geometry and its dimension lines. |

### Sheathing & Hatching
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter sheets by | dropdown | Front and Back | Determines which sheathing layers are detailed. Options: Front and Back, Use zone index, All zones. |
| Zone index | dropdown | 1 | Specific sheathing layer index to display (only active if "Use zone index" is selected). |
| Draw other sheet zones | dropdown | Yes | Toggles whether to draw/hatch sheathing zones that are not the primary focus. |
| Front hatch pattern | text | ANSI31 | Visual pattern for the front face sheathing. |
| Front hatch angle | number | 180° | Rotation angle of the front hatch pattern. |
| Front hatch scale | number | 0.25 | Density/size of the front hatch pattern. |
| Back hatch pattern | text | ANSI31 | Visual pattern for the back face sheathing. |
| Back hatch angle | number | 90° | Rotation angle of the back hatch pattern. |
| Back hatch scale | number | 0.25 | Density/size of the back hatch pattern. |
| Dash line color | number | 8 | CAD Color Index for dashed lines (sheathing/hidden elements). |

### Blocking
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Blocking measure point | dropdown | Center | Reference point for dimensions (Bottom, Center, Top). |
| Do dimension blocking | dropdown | Yes | Enables or disables dimensioning of blocking members. |
| Line to dimension | dropdown | Yes | Draws a leader line connecting the block to the dimension. |

### Openings & Tags
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show full tag at opening | dropdown | Yes | Displays the full label text directly at the wall opening location. |
| Show KPN | dropdown | Yes | Displays the Assembly Number (KPN) associated with openings. |
| Opening label format | text | (Custom) | String format to define how opening tags are generated. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Move Hatching Legend | Re-opens the point picker to allow you to move the material legend to a new location on the sheet. |
| Set/Remove grip override for all walls | Allows locking or unlocking the position of specific list groups (Opening Tags, Sheathing List, Hardware, etc.) across all walls in the project. |

## Tips
- **Viewport Selection**: Ensure the selected viewport is strictly an "Elevation" view; selecting a Plan or Section view may cause the script to fail or produce incorrect geometry.
- **Zone Filtering**: If you only need to detail the exterior sheathing, set "Filter sheets by" to "Use zone index" and specify the exterior zone index in the "Zone index" property.
- **Dimension Styles**: Verify that the `'Wall Shopdrawing'` dimension style exists in your template; otherwise, the script may fall back to a standard style which might look different than intended.
- **Penetrations**: If your wall contains service penetrations (drills), the script will automatically generate a schedule for them if they exist in the model.

## FAQ
- **Q: Why did the script stop immediately after selecting the viewport?**
  **A:** The script requires the viewport to contain a valid Wall Element. If the viewport is empty or shows a different object type (like a floor or roof), the script will exit.
- **Q: How do I change the hatch pattern for the sheathing?**
  **A:** Select the generated drawing in Paper Space and open the Properties palette. Look for "Front hatch pattern" or "Back hatch pattern" under the Sheathing category to change the style.
- **Q: Can I adjust the spacing between views after insertion?**
  **A:** Yes. Change the "Section line offset" properties in the Properties palette, and the drawing will update automatically.