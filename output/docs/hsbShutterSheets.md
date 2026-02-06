# hsbShutterSheets.mcr

## Overview
This script automatically generates shutter boards (infill panels or structural sheathing) above or below wall openings such as windows and doors. It calculates the geometry based on the wall construction, cuts existing sheeting where necessary, and inserts the new sheets aligned with the specified zone.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script inserts and modifies sheet entities in the 3D model. |
| Paper Space | No | This script does not generate 2D shop drawings. |
| Shop Drawing | No | This script operates on the physical model only. |

## Prerequisites
- **Required Entities**: An `Element` (Wall) with a defined construction and an `Opening` (Window/Door).
- **Minimum Beam Count**: 0.
- **Required Settings**: The target wall must have a constructed "Sheet" layer (Zone) with a thickness greater than 0.1mm.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbShutterSheets.mcr` from the catalog or file browser.

### Step 2: Configuration
If no catalog entry is found, a dialog may appear to set initial parameters. Otherwise, proceed to selection.

### Step 3: Select Opening
```
Command Line: Select opening(s)
Action: Click on the window or door opening(s) in the drawing where you want to add shutter sheets.
```

### Step 4: Edit Properties (Optional)
After insertion, select the newly created script instance (or the opening with the attached script) and open the **Properties Palette (OPM)** to fine-tune dimensions, offsets, and alignment.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone | dropdown | 5 | Selects the wall layer (e.g., exterior sheathing) to apply the sheet to. Range is -5 to 5. |
| X-Offset | number | 0 | Extends the width of the shutter sheet equally on both sides relative to the opening width. |
| Y-Offset | number | 0 | Shifts the shutter sheet vertically. Positive moves it away from the opening center; negative pulls it back. |
| max. Height | number | 0 | Limits the vertical height of the sheet. A value of 0 allows it to extend until it hits another obstruction or zone boundary. |
| Lateral offset | number | 0 | Creates a horizontal gap between the sheet edges and the surrounding wall/obstructions. |
| Gap towards opening | number | 0 | Defines the vertical gap between the sheet edge and the opening frame (window/door). |
| Gap opposite opening | number | 0 | Defines the vertical gap at the side furthest from the opening (towards top or bottom plate). |
| Alignment | dropdown | Top | Determines if the sheet is placed relative to the Top (Header) or Bottom (Sill) of the opening. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific custom items to the right-click context menu. Edit parameters via the Properties Palette. |

## Settings Files
- **Filename**: None (Standard script execution).
- **Location**: N/A
- **Purpose**: N/A (Uses internal properties and Map IO).

## Tips
- **Zone Selection**: Ensure the selected Zone has a constructed thickness. If the script erases itself immediately, the Zone thickness is likely 0.
- **Header vs. Sill**: Use the **Alignment** property to toggle between creating a header board (Top) and a sill board (Bottom).
- **Avoiding Collisions**: Use **max. Height** to prevent the shutter sheet from extending too far up or down into intersecting walls or roofs.
- **Distribution**: If the calculated width of the shutter sheet exceeds the maximum width defined in your sheeting material catalogs, the script will automatically distribute the sheet into multiple pieces.

## FAQ
- **Q: The script disappeared after I selected the opening. Why?**
- **A: This usually happens if the selected **Zone** has a thickness of 0mm in the wall construction. Check your wall construction settings or select a different Zone (e.g., 1 or 2) that contains actual sheeting material.

- **Q: The prompt says "waiting for construction". What does this mean?**
- **A: The script has detected the Zone exists but the wall geometry has not been generated/calculated for that specific layer yet. Run the "Generate Single Element" or similar wall construction command to update the wall, and the script will proceed automatically.

- **Q: How do I create a sheet that extends past the window trim?**
- **A: Set a positive value for **X-Offset**. This will widen the shutter sheet beyond the width of the opening.