# hsb_NesterCaller.mcr

## Overview
This script optimizes the placement of selected sheet elements (e.g., OSB or Plywood panels) within a defined material boundary (polyline) to minimize waste and calculate efficient cutting layouts.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary operating space. Select Sheet entities and boundary polylines here. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Entities:**
  - `Sheet`: The timber sheets or panels you want to arrange.
  - `EntPLine`: A closed polyline representing the raw material board or boundary to nest within.
- **Hardware:** hsbCAD Hardware Dongle must be connected.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_NesterCaller.mcr`

### Step 2: Select Sheets
```
Command Line: Select a set of sheets to be nested
Action: Click on the Sheet entities in your model that you wish to nest, then press Enter.
```

### Step 3: Execute Nesting
```
Action: Select the script instance in the model (the TSL icon), right-click, and choose "Nest in EntPLine".
```

### Step 4: Select Material Boundary
```
Action: Click on the EntPLine (Polyline) that represents the board size or boundary you want to nest the sheets into.
```

### Step 5: Review Results
```
Action: Check the command line for the calculation results.
- If successful, it will report coordinates and efficiency.
- If failed, it may report "Not possible to nest" or "No dongle present".
```

### Step 6: Apply Layout (If Satisfied)
```
Action: Select the script instance, open the Properties Palette (Ctrl+1), and change "Accept nester result" to 1. 
Then right-click the script again and select "Nest in EntPLine" to physically move the sheets.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Accept nester result | Number | 0 | **Safety Switch**. <br>0 = Preview Mode (Calculates layout but does not move geometry).<br>1 = Apply Mode (Physically moves and rotates sheets to the nested positions). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Nest in EntPLine | Initiates the nesting calculation. Prompts you to select a polyline boundary, calculates the optimal layout, and applies transformations if the "Accept nester result" property is set to 1. |

## Settings Files
- None specific to this script.

## Tips
- **Always Preview First:** Leave the "Accept nester result" property at `0` initially. This allows you to verify that the parts actually fit inside your boundary before permanently moving them.
- **Check Spacing:** The script uses a default 2mm spacing between parts. Ensure your boundary accounts for this kerf/space.
- **Dongle Required:** If the command line returns "No dongle present", check your USB security dongle connection.

## FAQ
- **Q: I ran the script, but my sheets didn't move. Why?**
  **A:** The "Accept nester result" property is likely set to `0` (Preview). Change it to `1` in the Properties Palette and run the nesting command again to move the parts.
- **Q: It says "Not possible to nest".**
  **A:** The combined area of your selected sheets (plus spacing) is likely larger than the selected EntPLine boundary, or the shapes cannot fit geometrically. Try a larger boundary or fewer sheets.
- **Q: What does "No dongle present" mean?**
  **A:** The nesting algorithm requires a specific hardware security key (dongle) to function. Ensure it is plugged into your computer.