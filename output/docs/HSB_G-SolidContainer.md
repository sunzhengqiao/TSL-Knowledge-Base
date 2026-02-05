# HSB_G-SolidContainer.mcr

## Overview
This script performs a visual quality control check by comparing the current geometry of a timber beam (GenBeam) against a reference solid stored in the hsbCAD Map. It is used to visualize clashes, gaps, or volume differences between the actual timber model and an imported design state (e.g., from an architectural model).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script only operates in the 3D Model environment. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Does not generate 2D drawing views. |

## Prerequisites
- **Required Entities**: At least one `GenBeam` (Timber Beam) must be present in the model.
- **Minimum Beam Count**: 1.
- **Required Settings**: The script requires a Map entry attached to the element (or globally) with the key `RealSolid` containing a valid 3D Body object. Without this reference data, the script cannot perform the comparison.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: In the file dialog, select `HSB_G-SolidContainer.mcr` and click Open.

### Step 2: Select Beams
```
Command Line: Select genBeam(s)
Action: Click on the timber beam(s) you wish to compare against the reference solid. Press Enter to confirm selection.
```
*Note: Upon selection, the script attaches to the beam and performs an initial calculation based on default properties.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| View | dropdown | Difference | Determines what is visualized: <br>• **Nothing**: Hides the comparison body.<br>• **Imported body**: Shows the reference solid only.<br>• **Difference**: Shows the volume discrepancy (gaps or clashes) between the beam and the reference. |
| Color | dropdown | Yellow | Sets the display color of the visualized solid (Imported body or Difference). |
| Offset | number | 300 | Sets the distance (in mm) the visualized body is shifted away from the beam to prevent visual overlap. |
| Offset Direction (GenBeam) | dropdown | Z | Specifies the axis direction (relative to the beam's local coordinate system) to apply the Offset. Options include X, -X, Y, -Y, Z, -Z. |
| Text Height | number | 200 | Defines the height of the text annotation displayed in the model. |
| Text Offset | number | 350 | Defines the distance from the beam's reference point where the text label is positioned. |
| Custom Text | text | - | Defines the text content displayed next to the beam. Supports formatted variables like `@(Posnum)`, `@(Length)`, or `@(Volume)`. If left empty, it defaults to the Position Number. |
| Show Import Error | dropdown | No | If the imported reference solid is invalid, set to **Yes** to display wireframe face loops for debugging purposes. |
| Group | dropdown | - | Assigns the script instance to a specific CAD group for organizational control. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add custom items to the right-click context menu. All modifications are made via the Properties Palette. |

## Settings Files
- **Map Key**: `RealSolid`
- **Location**: Internal hsbCAD Element Map
- **Purpose**: Stores the reference 3D Body geometry (usually imported from an external CAD file) used for the comparison. This data must be populated by an import script or process before running this script.

## Tips
- **Visual Clarity**: If the visualized body overlaps perfectly with your beam (Z-fighting), increase the **Offset** value or change the **Offset Direction** (e.g., set to Z to shift it vertically above the beam).
- **Finding Errors**: Set **View** to `Difference`. If you see colored geometry appear, it indicates areas where the timber beam does not match the reference solid (either too much material or too little).
- **Data Labels**: Use the **Custom Text** property to display dynamic data. For example, entering `Vol: @(Volume)` will display the text "Vol: " followed by the actual calculated volume of the discrepancy.
- **Data Integrity**: If the script reports errors, ensure the import process successfully created a valid solid in the Map and not just a collection of surfaces. Enable **Show Import Error** to diagnose bad data.

## FAQ
- **Q: I ran the script, but I don't see any new geometry.**
  A: Check the **View** property in the Properties Palette. If it is set to "Nothing", change it to "Imported body" or "Difference". Also, verify that the `RealSolid` Map entry actually contains data.
- **Q: Why does the text show "-1"?**
  A: The script defaults to showing the Position Number. If the beam has not been assigned a position number yet, it may display -1 or an empty string. You can change the **Custom Text** property to show other data like `@(Length)`.
- **Q: What does the "Difference" view actually show?**
  A: It performs a Boolean operation. It shows the volume that exists in the Reference Solid but *not* in the Timber Beam (missing material) AND the volume that exists in the Timber Beam but *not* in the Reference Solid (extra material).