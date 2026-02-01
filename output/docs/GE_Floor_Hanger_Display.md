# GE_Floor_Hanger_Display.mcr

## Overview
This script creates a 3D visual representation of floor joist hangers connecting a joist (Male beam) to a supporting beam or wall (Female beam). It automatically adapts the hanger size to fit the beam dimensions and exports hardware data (Code/Model) for BOMs and production labels.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be used in the 3D model. |
| Paper Space | No | |
| Shop Drawing | No | This script does not generate 2D drawings directly. |

## Prerequisites
- **Required Entities:** Two existing beams (`GenBeam`).
- **Minimum Beam Count:** 2
  1. **Male Beam:** The joist being supported.
  2. **Female Beam:** The supporting beam or wall plate.
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_Floor_Hanger_Display.mcr`

### Step 2: Select Male Beam
```
Command Line: Select Male Beam
Action: Click on the floor joist (the beam that will sit inside the hanger).
```

### Step 3: Select Female Beam
```
Command Line: Select Female Beam
Action: Click on the supporting beam or wall plate that the hanger attaches to.
```

### Step 4: Configure Properties
After selection, the Properties Palette will open automatically.
1. Select the **Hanger Type** from the dropdown (e.g., "Heavy Universal", "Mini Hanger").
2. Enter the **Hanger Code** and **Hanger Model** for BOM reporting.
3. The 3D hanger body will automatically generate based on your inputs.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Hanger Type | dropdown | Heavy Universal | Determines the geometric style of the hanger. Options: Heavy Universal, Mini Hanger, Face Hanger, Top Fix. |
| Hanger Code | text | [Blank] | The specific part code from your supplier (e.g., 'HU46/55'). This appears in BOMs and labels. |
| Hanger Model | text | [Blank] | The manufacturer name or product family. |
| PosNum | number | Instance ID | A read-only system-generated number identifying this specific instance. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Properties | Opens the Properties Palette to modify Hanger Type, Code, or Model. |
| (Standard Options) | Delete, Move, Rotate, etc. |

## Settings Files
- **Filename:** None
- **Location:** N/A
- **Purpose:** This script relies entirely on direct user input and beam geometry; no external XML settings files are required.

## Tips
- **Dynamic Resizing:** If you use grips to stretch or change the size of the Male beam (joist), the hanger will automatically update its width and height to match.
- **Switching Types:** You can change the visual style of the hanger at any time by selecting it and changing the "Hanger Type" dropdown in the Properties Palette.
- **Data Export:** Ensure you fill in the "Hanger Code" and "Hanger Model" fields immediately after insertion to ensure your BOMs and labels are accurate.

## FAQ
- **Q: Why did the hanger change shape after I edited the beam?**
  A: The script is designed to be parametric. If you modify the width or height of the joist (Male beam), the hanger geometry automatically recalculates to fit the new size.
- **Q: Can I use this on a rotated beam?**
  A: Yes. The script checks the orientation of the beams and adjusts the coordinate system so the hanger stands upright relative to the world, regardless of the beam's rotation.
- **Q: How do I get the hanger information on my material list?**
  A: Enter the supplier details in the "Hanger Code" and "Hanger Model" properties. The script writes this data to the BOM Map and Hardware attributes automatically.