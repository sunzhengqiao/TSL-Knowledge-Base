# hsbCullenFAS.mcr

## Overview
Generates the 3D geometry and production data for a Cullen FAS Framing Anchor. This script automates the placement of the bracket and associated nails (18x Annular Ringshank Nails) to connect timber elements (beams).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script creates 3D bodies and hardware data. |
| Paper Space | No | Not designed for 2D layout or detailing views. |
| Shop Drawing | No | Does not generate shop drawing annotations directly. |

## Prerequisites
- **Required Entities**: At least one `GenBeam` (Timber Beam).
- **Minimum Beam Count**: 1 (Supports connections between 1 or 2 beams).
- **Required Settings**: `hsbCullenFAS.xml` (Optional; if missing, the script uses internal defaults).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `hsbCullenFAS.mcr` from the list.

### Step 2: Select Beam(s)
```
Command Line: Select beam(s):
Action: Click the primary beam you wish to attach the bracket to.
```
*(Note: If connecting two beams at an intersection, select the secondary beam as well, or position the script at the intersection point depending on your standard hsbCAD input settings.)*

### Step 3: Configuration & Placement
The script will automatically calculate the insertion point based on the beam geometry.
- If attached to a single beam, it defaults to the favored position (usually the end or edge).
- If attached to two beams, it calculates the intersection.
- The 3D bracket and text label will appear immediately.

### Step 4: Modify Properties (Optional)
Select the inserted instance and open the **Properties Palette** to adjust parameters like Text Height or Group Assignment.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Group Assignment** | dropdown | `<Default>` | Determines the CAD Layer/Group for the instance. `<Default>` assigns it to the same layer as the beam it is attached to. *(Visible in Global Configuration Mode)* |
| **Text Height** | number | `0` | Controls the size of the text label (e.g., "FAS") in the model view. A value of `0` uses the system default text size. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None Detected* | This script does not currently expose custom actions via the right-click context menu. Modify properties via the Properties Palette. |

## Settings Files
- **Filename**: `hsbCullenFAS.xml`
- **Location**: Searches first in `[Company]\TSL\Settings\`, then `[Install]\Content\General\TSL\Settings\`.
- **Purpose**: Stores global settings, default group assignments, and configuration values for the script.

## Tips
- **Quantity Labeling**: When connecting two beams, the script scans for other brackets of the same type between those specific beams. It sums the quantity and displays it (e.g., "FAS x 2"). Only the "first" bracket (lowest handle ID) displays the text to avoid clutter.
- **Hardware Export**: The script automatically exports production data for **1x Framing Anchor** and **18x Annular Ringshank Nails** to the BOM/CNC lists.
- **Text Visibility**: If the text label is too small or large to read in the model view, select the bracket and change the `Text Height` property in the Properties Palette.

## FAQ
- **Q: My bracket is placed on the wrong layer.**
  - A: Select the bracket and change the `Group Assignment` property in the Properties Palette from `<Default>` to the specific layer you require.
- **Q: What does "Text Height 0" mean?**
  - A: It tells the script to use the standard system text size defined in your hsbCAD/AutoCAD settings rather than a custom size.
- **Q: Can I rotate the bracket 180 degrees?**
  - A: Yes, though the specific property depends on the script version loaded. Check the Properties Palette for geometric integer properties (often named `iRotate`) or use the hsbCAD move/rotate commands if the specific property is not exposed in your version.