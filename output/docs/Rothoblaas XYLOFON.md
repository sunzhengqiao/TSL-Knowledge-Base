# Rothoblaas XYLOFON.mcr

## Overview
This script inserts Rothoblaas XYLOFON noise absorbers onto panel edges and through-cuts. It is designed to dampen vibration and sound transmission in timber construction projects by applying polyurethane strips to Structural Insulated Panels (SIPs).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script creates 3D geometry and modifies panels in the model. |
| Paper Space | No | Not applicable for 2D drawing layouts. |
| Shop Drawing | No | This is a model detailing script. |

## Prerequisites
- **Required entities**: Sip (Structural Insulated Panel).
- **Minimum beam count**: 1 Panel.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Rothoblaas XYLOFON.mcr`

### Step 2: Select Panel
```
Command Line: Select Panel(s)
Action: Click on the panel(s) where the absorber will be applied. Press Enter to confirm selection.
```

### Step 3: Select Edges
```
Command Line: Select point(s) on edges that get the XYLOFON absorber
Action: Click on the specific edges of the selected panel(s) where the noise absorber strip should be placed. You can select multiple points. Press Enter to finish.
```

### Step 4: Configure Properties
After insertion, select the script instance and open the **Properties Palette** (OPM) to adjust the Type and Position as needed.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | dropdown | XYLOFON 35 | Defines the XYLOFON type (hardness/density). Options include XYLOFON 35, 50, 70, 80, and 90. |
| Absorber Position | dropdown | 100mm reference face | Defines the position and width of the absorber. Options: 100mm reference face, 100mm opposite face, 100mm centered, or full width. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add | Recalculates hardware and stretches edges. This updates the absorber geometry to match current properties or panel changes. |
| Subtract | Recalculates hardware and stretches edges. Used to modify or remove the absorber effect. |

## Settings Files
None

## Tips
- **Double-Click Shortcut**: You can double-click the script instance in the model to trigger the "Add" command, which refreshes the geometry and hardware list.
- **Full Width Option**: Selecting "full width" in the Absorber Position property will cover the entire panel height and automatically switch the article numbering to "Big Sizes".
- **Openings**: The script automatically detects and handles edges around beam cuts (openings), ensuring the absorber fits correctly around windows or doors.
- **Multiple Edges**: During insertion, you can click on multiple edges across the selected panels to apply the absorber to several sides simultaneously.

## FAQ
- **Q: What happens if my panel geometry changes?**
- **A:** Use the "Add" command (or double-click the instance) to recalculate the absorber dimensions and positions to fit the new panel geometry.

- **Q: Can I use this on regular beams?**
- **A:** No, this script is specifically designed for Sip (Structural Insulated Panel) entities.

- **Q: How does the script handle corners?**
- **A:** The script automatically calculates intersections for both convex and concave corners, mitering the absorber material appropriately.

- **Q: Where does the length information appear?**
- **A:** The script generates a hardware component (HardWrComp) that lists the total length and article number in your BOM/Material list.