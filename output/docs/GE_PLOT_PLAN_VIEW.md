# GE_PLOT_PLAN_VIEW.mcr

## Overview
This script generates 2D architectural symbols (such as circles, crosses, or hatching) for timber frame members within plan views or shop drawings. It replaces standard 3D projections with specific 2D representations based on the beam type (e.g., Jack Stud, King Stud, Top Plate).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is intended for detailing in 2D layouts. |
| Paper Space | Yes | Select a Viewport linked to an Element to generate symbols over the view. |
| Shop Drawing | Yes | Select a ShopDrawView entity within the multipage environment. |

## Prerequisites
- **Required Entities**: A Layout Viewport (linked to an hsbCAD Element) OR a ShopDrawView entity.
- **Minimum Beam Count**: 0 (The script processes whatever beams exist in the selected Element).
- **Required Settings**: None required, but beam types must be assigned in the model for the script to identify them correctly.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_PLOT_PLAN_VIEW.mcr`

### Step 2: Configure Properties
1. The **Properties Palette** will open automatically upon insertion.
2. Under **Drawing space**, select either `paper space` or `shopdraw multipage`.
3. Scroll down to the beam type properties (e.g., *Jack Over Opening*, *King Stud*, *TopPlate*).
4. Change the value from `No display` to a desired symbol (e.g., `O`, `X`, `/`, `\`).

### Step 3: Select View Entity
Depending on your selection in Step 2, the command line will prompt for an entity:

**If "paper space" was selected:**
```
Command Line: Select the viewport from which the element is taken
Action: Click on the layout viewport that displays the wall/floor you want to detail.
```

**If "shopdraw multipage" was selected:**
```
Command Line: Select the view entity from which the module is taken
Action: Click on the ShopDrawView frame in the drawing.
```

### Step 4: Generation
The script will automatically project the beams and draw the configured symbols onto the view.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Drawing space** | dropdown | paper space | Determines if the script targets a Layout Viewport or a ShopDrawView. |
| **Jack Over Opening** | dropdown | No display | Symbol style for jack studs located above openings. |
| **Jack Under Opening** | dropdown | No display | Symbol style for jack studs located below openings. |
| **Cripple Stud** | dropdown | No display | Symbol style for cripple studs. |
| **Transom** | dropdown | No display | Symbol style for transom beams. |
| **King Stud** | dropdown | No display | Symbol style for king studs. |
| **Window Sill** | dropdown | No display | Symbol style for window sill beams. |
| **Angled TopPlate Left** | dropdown | No display | Symbol style for left-angled top plates. |
| **Angled TopPlate Right** | dropdown | No display | Symbol style for right-angled top plates. |
| **TopPlate** | dropdown | No display | Symbol style for standard top plates. |
| **Bottom Plate** | dropdown | No display | Symbol style for bottom plates. |
| **Blocking** | dropdown | No display | Symbol style for blocking members. |

**Symbol Options:**
- `O`: Draws a circle.
- `X`: Draws a cross.
- `/` or `\`: Draws diagonal lines.
- `Outline only`: Hides internal lines, keeping only the contour.
- `Center line trough timber`: Draws a center line through the beam.

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Erase** | Removes the script instance and the generated symbols from the drawing. |
| **Properties** | Re-opens the Properties Palette to change beam symbols or settings. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies entirely on Properties Palette inputs and does not use external settings files.

## Tips
- **Automatic Blocking Overrides**: When working in Paper Space, the script automatically detects horizontal blocking in horizontal views and forces the symbol to be a slash (`/`), overriding the property setting. This ensures clarity in standard framing plans.
- **Initial Setup**: By default, all beam types are set to "No display". You must actively select symbols for the beams you wish to visualize.
- **Visibility**: If you see the text "This tsl need to be customized" in your drawing, it means no symbols were generated. Check your properties to ensure at least one beam type is set to a visible symbol.

## FAQ
- **Q: I inserted the script, but I don't see any symbols?**
  A: The default setting for all beam types is "No display". Select the script, open the Properties palette, and change specific beam types (like TopPlate or King Stud) to symbols like 'X' or 'O'.
  
- **Q: Can I use this on a 3D Model Space view?**
  A: No. This script is designed for 2D output in Paper Space layouts or Shop Drawing pages. It flattens the 3D geometry into 2D symbols.