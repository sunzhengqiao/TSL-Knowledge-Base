# hsb_CoverStrip.mcr

## Overview
Automatically generates a horizontal sheet (cover strip) attached to a wall element, spanning the wall's length with a user-defined width and thickness. This is typically used for creating fascia boards, ridge cap coverings, or horizontal capping strips.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script creates physical 3D sheet entities. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: An existing Wall Element (`ElementWall`) in the model.
- **Minimum Beam Count**: 0 (This script operates on Elements, not individual beams).
- **Required Settings**: A Catalog entry is recommended to initialize properties (`_kExecuteKey`), though not strictly mandatory.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_CoverStrip.mcr`

### Step 2: Configure Properties (Optional)
If no default catalog entry is set, a dialog may appear to set initial parameters (Thickness, Height, Material). You can also change these later in the Properties Panel.

### Step 3: Select Element
```
Command Line: Select a set of elements
Action: Click on the Wall element(s) in the drawing where you want to apply the cover strip. Press Enter to confirm selection.
```
*Note: The script will attach itself to the selected element and generate the geometry.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Sheet Thickness | Number | 9 | The material thickness of the cover strip (e.g., thickness of plywood or OSB board). |
| Sheet Height | Number | 140 | The width of the strip measured along the wall's thickness/depth direction (how far the strip covers the wall surface). |
| Sheet Name | Text | [Empty] | A custom name to identify the sheet entity. |
| Sheet Material | Text | [Empty] | The material code to assign to the sheet for reports and lists. |
| Zone to Assign the Sheets | Dropdown | 1 | Assigns the sheet to a specific production group zone (Options 1-10). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None Defined* | This script does not add custom items to the right-click context menu. Use the standard Properties palette to modify parameters. |

## Settings Files
- **Filename**: Catalog Entry (implicit)
- **Location**: hsbCAD Catalog
- **Purpose**: Stores default values for thickness, height, material, and zone so the script can run without prompting the user every time.

## Tips
- **Updating Dimensions**: You can adjust the "Sheet Thickness" or "Sheet Height" at any time by selecting the generated sheet and changing the values in the Properties Panel (AutoCAD OPM). The geometry will update automatically.
- **Replacing Existing Strips**: If you run the script again on a wall that already has a cover strip, the script will automatically detect and erase the old strip before creating the new one. This prevents duplicates on the same wall.

## FAQ
- **Q: I ran the script, but nothing appeared?**
- **A:** Ensure you selected a valid Wall Element. If you selected a beam or an empty space, the script will exit without creating geometry.
- **Q: How do I change the material of the strip?**
- **A:** Select the strip in the model, open the Properties palette (Ctrl+1), and update the "Sheet Material" field.
- **Q: Can I use this on curved walls?**
- **A:** The script calculates the span based on the wall's Min/Max points. It is designed primarily for linear walls, though it will attempt to span the total length of the element geometry.