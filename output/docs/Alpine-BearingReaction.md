# Alpine-BearingReaction.mcr

## Overview
Visualizes structural engineering load calculations (bearing reactions and uplift forces) directly on truss elements in the 3D model. It creates annotations with direction arrows and text labels to display reaction magnitudes (kN or lbs) at truss bearing points.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D Truss entities. |
| Paper Space | No | Not designed for Paper Space or Layouts. |
| Shop Drawing | No | This is a model-space annotation tool. |

## Prerequisites
- **Required Entities**: Trusses that have been calculated and possess valid engineering data (Map) containing reaction values (RX, RY, RZ, etc.).
- **Minimum Beam Count**: N/A (User selects trusses interactively).
- **Required Settings**: None. However, the trusses must have calculation results available for the script to display values.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse and select `Alpine-BearingReaction.mcr`.

### Step 2: Select Trusses
```
Command Line: Select truss(es)
Action: Click on the trusses you want to annotate or update, then press Enter.
```

### Step 3: Refresh Display
```
Command Line: HSB_RECALC
Action: Select the affected trusses again and press Enter. This triggers the script to read the calculation data and generate the arrows and text labels.
```
*(Note: The script will display a notification reminding you to perform this step after insertion.)*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Display reaction label | dropdown | |Yes| | Toggles the visibility of the reaction force arrow and text label. Set to |No| to hide annotations, or |Yes| to show them. |

## Right-Click Menu Options
*None configured.*

## Settings Files
*None required.*

## Tips
- **Unit Handling**: The script automatically detects your project units. It will display loads in **kN** (Metric) or **lbs** (Imperial) formatted as integers.
- **Uplift Forces**: Pay attention to text colored **Red**; this indicates vertical uplift forces (MaxVerticalUplift), which are critical for connection design.
- **Batch Updates**: If you insert the script again and select existing trusses, it will update the properties (e.g., turning labels on/off) for all instances attached to those trusses.

## FAQ

**Q: Why don't I see any arrows or text after running the script?**
A: The script inserts as an instance but requires a calculation refresh. Select the trusses again and run the command `HSB_RECALC` to generate the graphics.

**Q: Can I hide the reaction labels temporarily?**
A: Yes. Select the truss (or the script instance), open the Properties Palette (Ctrl+1), and change "Display reaction label" to `|No|`. You will need to run `HSB_RECALC` for the change to take effect visually.

**Q: Why are some values not showing?**
A: The script has a built-in threshold (`MinReactionForDisplay`). Very small reaction magnitudes may be hidden automatically to reduce visual clutter.