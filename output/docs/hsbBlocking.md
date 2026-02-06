# hsbBlocking.mcr

## Overview
This script creates timber blocking boards (stiffeners) between rafters and structural elements like walls or top plates. It supports roof sheathing, stabilizes rafter spacing, and can optionally generate "Kerve" (notches) in rafters to accommodate specific wall zones.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script creates 3D geometry (GenBeam/Prism) and applies tooling. |
| Paper Space | No | Not designed for 2D layout or detailing views. |
| Shop Drawing | No | This is a model generation script, not a drawing annotation tool. |

## Prerequisites
- **Required Entities**: At least two beams (e.g., a Wall/Top Plate and a Rafter).
- **Minimum Beam Count**: 2
- **Required Settings Files**:
    - `SFSettings.xml` (Optional): Used for storing and loading custom presets via the context menu.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Select `hsbBlocking.mcr` from the list.

### Step 2: Select Reference Beam
```
Command Line: Select GenBeam (Wall/Plate/Rafter)
Action: Click on the first beam (usually the wall, top plate, or reference element).
```

### Step 3: Select Rafter Beam
```
Command Line: Select GenBeam (Rafter/Plate)
Action: Click on the rafter or secondary beam where the blocking will be applied.
```

*Once selected, the script will calculate and insert the blocking based on default properties.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Geometry** | | | |
| A - Thickness | Number | `32 mm` | Defines the thickness (width) of the blocking board. |
| B - Height | Number | `0` (Auto) | Defines the height of the raw blocking board. Set to `0` to automatically calculate the exact height required to fit the gap. |
| **Roofplane offsets** | | | |
| C - Top | Number | `1 mm` | Defines the perpendicular offset (gap) between the top of the blocking and the roof plane. |
| D - Bottom | Number | `0 mm` | Defines the offset from the bottom reference. Use to raise or lower the blocking relative to the wall plate. |
| E - Bottom offset reference | Dropdown | Outside edge of wall | Determines if the bottom offset is measured from the wall's outside edge or the blocking beam's bottom edge. |
| **Element** | | | |
| Kerve | Dropdown | `Disabled` | Defines the "Kerve" (notch) mode. Options include Disabled, Outer Zone, Inner Zone, or specific zone numbers (-5 to 5). **Note:** If set to "Disabled", the script instance will erase itself. |
| **General** | | | |
| Gap X | Number | `0 mm` | Fine-tunes the Kerve notch position along the depth of the wall (perpendicular to the wall surface). |
| Gap Y | Number | `0 mm` | Fine-tunes the Kerve notch position vertically. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Load Settings** | Loads custom settings from the `SFSettings.xml` file into the current instance. If the file is not found, it prompts to erase existing custom settings. |
| **Write Settings** | Saves the current property settings of the script to the `SFSettings.xml` file for future use. |

## Settings Files

- **Filename**: `SFSettings.xml`
- **Location`: `_kPathHsbWallDetail` (Company or hsbCAD install path).
- **Purpose**: Stores and retrieves custom parameter configurations (like thickness, gaps, and Kerve settings) shared between this script and other compatible TSLs (via the MapObject 'hsbStickframe').

## Tips
- **Automatic Sizing**: Leave **B - Height** set to `0` to let the script automatically calculate the exact height needed to fill the gap between the roof plane and the wall/plate.
- **Avoiding Clashes**: Use the **C - Top** and **D - Bottom** offsets to create clearance for insulation layers or roof sheathing.
- **Kerve Warning**: Be careful when setting the **Kerve** property to "Disabled". This will cause the script instance to delete itself from the model.
- **Fine-Tuning**: Use **Gap X** and **Gap Y** to micro-adjust the position of the Kerve notch if the automatic zoning does not align perfectly with your wall details.

## FAQ

- **Q: Why did my blocking disappear when I changed a property?**
  - **A**: You likely set the **Kerve** property to "Disabled". In this script's logic, disabling the Kerve function removes the instance. Change it back to a zone or numeric value before inserting, or re-insert the script.

- **Q: How do I make the blocking fit perfectly between the wall and the rafter?**
  - **A**: Ensure **B - Height** is set to `0` (Automatic). The script will then measure the distance and cut the blocking to the exact size required.

- **Q: Can I save my specific gap settings for future projects?**
  - **A**: Yes. Adjust your parameters in the Properties Palette, right-click the script instance, and select **Write Settings**. You can then load these settings later using **Load Settings**.