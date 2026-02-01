# BMF U Shoe

## Overview
This script generates a detailed 3D model of a galvanized steel "U Shoe" connector (BMF series) tailored to specific timber beam widths. It automatically creates the steel hardware geometry (base plate, side plates, and stiffeners) and applies the necessary perpendicular cut to the timber beam.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script generates 3D bodies and beam machining. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This is a modeling script, not a detailing tool. |

## Prerequisites
- **Required Entity:** A single Timber Beam (`GenBeam`) in the model.
- **Beam Width Constraint:** The beam width must exactly match one of the supported sizes: 45, 50, 60, 70, 80, 90, 100, or 120 mm.
- **Minimum Beam Count:** 1

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `BMF U Shoe.mcr`

### Step 2: Select Reference Beam
```
Command Line: Select beam:
Action: Click on the timber beam where you want to insert the U Shoe connection.
```
*Note: The script will automatically detect the beam width. If the width does not match the supported sizes, the insertion will fail with the error "Shoe cannot be used!".*

### Step 3: Configure Properties
After insertion, the shoe is generated immediately. To adjust its position or settings, select the script instance in the model and open the **Properties Palette** (Ctrl+1).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Base Heigh | Number | 0 | The axial offset along the beam. Use this to slide the shoe assembly forwards or backwards from the insertion point. It updates both the shoe position and the beam cut simultaneously. |
| Type of Fixing | Dropdown | Nails | Select the preferred fastener type. Options are **Nails** or **Screws**. This only updates the Article Number and Designation labels for reporting; it does not change the physical geometry. |

## Right-Click Menu Options
There are no custom context menu options for this script. Use the standard AutoCAD/hsbCAD grips to move the insertion point.

## Settings Files
No external settings files are used by this script. All dimensions are hardcoded based on the detected beam width.

## Tips
- **Beam Compatibility:** Before inserting, verify your beam width. If your project uses custom widths not listed in the prerequisites (e.g., 140mm), the script will not run.
- **Positioning:** If you need to move the shoe to a different location along the beam, you can drag the grip point (the insertion coordinate) or adjust the **Base Heigh** property in the palette for precise control.
- **Reporting:** Ensure you select the correct **Type of Fixing** if your BOM or production lists require specific fastener descriptions (e.g., "BMF-290xx-Nails" vs "BMF-290xx-Screws").

## FAQ
- **Q: I get an error "Shoe cannot be used!" when I click the beam. Why?**
  A: The width of the beam you selected does not match one of the predefined hardware sizes (45, 50, 60, 70, 80, 90, 100, or 120mm). Check your beam properties and ensure the width is correct.

- **Q: Does changing the fixing type add holes for nails or screws?**
  A: No. This parameter only changes the text label (Article Number) for the part. It does not alter the 3D geometry of the steel shoe.

- **Q: Can I use this on a beam that is already machined?**
  A: Yes, the script adds its own cut to the beam. However, ensure the new cut does not conflict with existing machining operations.