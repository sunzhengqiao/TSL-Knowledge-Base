# hsb_GlueArea.mcr

## Overview
This script defines a specific path or area on a timber element surface to indicate where adhesive should be applied during manufacturing. It generates visual geometry in the model and exports manufacturing data (such as tool index and zone) for CNC machines or shop drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in 3D model space to project geometry onto element surfaces. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: One existing Timber Element.
- **Minimum Beam Count**: 1.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_GlueArea.mcr` from the list.

### Step 2: Configuration (Manual Launch Only)
If you run this script manually (not from a catalog style), a configuration dialog will appear first.
- Adjust properties like **Zone**, **Tool Index**, and **Display Type** as needed.
- Click OK to proceed.

### Step 3: Select Element
```
Command Line: Select one element
Action: Click on the timber element (beam/panel) you want to apply the glue area to.
```

### Step 4: Pick Start Point
```
Command Line: Pick star point
Action: Click on the element surface to define the start location of the glue path.
```

### Step 5: Pick End Point
```
Command Line: Pick end point
Action: Click on the element surface to define the end location of the glue path.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone to be glued | dropdown | 1 | Selects the specific face or side of the element where the glue area is applied (e.g., Top, Bottom, Left, Right). |
| Tool index | number | 1 | Identifier for the specific glue nozzle or tool head to be used at the CNC workstation. |
| Tool size | number | 50 | The width of the glue strip (in mm). This is visually represented when "Display type" is set to "Area". |
| Line Type | dropdown | System Default | The visual style (linetype) used to draw the glue indication in the CAD model (e.g., Continuous, Dashed). |
| Display type | dropdown | Line | Determines visual representation: **Line** (single centerline) or **Area** (rectangular shape showing width). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Standard TSL Options | The script uses standard context options like Erase, Move, and Rotate. No custom menu items are defined. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external settings files.

## Tips
- **Visualizing Width**: If you need to see the exact width of the glue strip defined in "Tool size," change the "Display type" property to **Area**.
- **Changing Faces**: You can move the glue area to a different side of the beam after insertion by simply changing the "Zone to be glued" dropdown in the Properties Palette. You do not need to re-insert the script.
- **CNC Data**: While changing "Line type" affects how it looks in AutoCAD, it does not change the manufacturing data sent to the machine. Ensure "Tool index" and "Zone" are correct for production.

## FAQ
- **Q: Why does the glue line look like a thin line even though I set a Tool Size of 50mm?**
  - A: Check the **Display type** property. If it is set to "Line", it only draws a centerline. Switch it to "Area" to see the full rectangular width.
- **Q: Can I use this to mark multiple discontinuous glue lines on one beam?**
  - A: No, a single script instance creates one continuous line or rectangle between a start and end point. You must insert the script multiple times for separate segments.
- **Q: What happens if I delete the beam I attached the glue area to?**
  - A: The script includes a validity check. If the associated element is deleted or becomes invalid, the script instance will erase itself automatically.