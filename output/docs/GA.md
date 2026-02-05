# GA.mcr

## Overview
Inserts a configurable metal angle bracket for single or double timber connections, automatically generating the necessary 3D representation and material milling (cutouts) for a flush installation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in 3D to modify beams and generate hardware bodies. |
| Paper Space | No | Not designed for 2D detailing or views. |
| Shop Drawing | No | Does not generate shop drawing views directly. |

## Prerequisites
- **Required Entities**: At least one `GenBeam` (Timber Beam).
- **Minimum Beam Count**: 1 (Supports 2 beams for connections).
- **Required Settings**: `GenericAngle.xml` (Located in Company folder or default Install folder).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GA.mcr` from the list.

### Step 2: Select Beams and Insert
```
Command Line: Select beams:
Action: Click on the primary beam. If connecting two beams, click the second intersecting beam.
```
```
Command Line: Specify insertion point:
Action: Click near the end or intersection of the beam where the bracket should be placed.
```

### Step 3: Configure Bracket
1.  Select the inserted script object (it may be represented by a grip point or the bracket body).
2.  Open the **Properties Palette** (Ctrl+1).
3.  Select the desired **Family** (e.g., Simpson AA).
4.  Select the specific **Product** code (e.g., AA60280).
5.  Adjust dimensions or milling settings if necessary.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sFamily | String | AA | The manufacturer series or family of the angle bracket. |
| sProduct | String | AA60280 | The specific product code defining dimensions and fasteners. |
| Manufacturer | String | (From XML) | The supplier/brand name for BOM export. |
| bRotate180 | Boolean | 0 (No) | Rotates the bracket 180 degrees relative to the beam face. |
| bSwapLegs | Boolean | 0 (No) | Swaps which leg attaches to the primary vs. secondary beam (swaps width/depth usage). |
| iMillingType | Integer | 1 | Type of material removal: 0=None, 1=Rectangular Pocket, 2=One Side, 3=Both Sides. |
| dTolerance | Double (mm) | 1.0 | Extra clearance added to the milling pocket for fit. |
| dB | Double (mm) | (Product) | Horizontal width of the bracket (Leg 1). |
| dA | Double (mm) | (Product) | Horizontal depth of the bracket (Leg 2). |
| dC | Double (mm) | (Product) | Vertical height of the bracket. |
| dt | Double (mm) | (Product) | Thickness of the steel material. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Swap Legs | Toggles the `bSwapLegs` property, switching the orientation of the bracket legs. |
| Rotate 180 | Toggles the `bRotate180` property, flipping the bracket orientation. |
| Update | Forces a recalculation of the script geometry. |

## Settings Files
- **Filename**: `GenericAngle.xml`
- **Location**: `_kPathHsbCompany\TSL\Settings` (or fallback to `_kPathHsbInstall\Content\General\TSL\Settings`)
- **Purpose**: Defines the catalog of available brackets, including dimensions (dA, dB, dC, dt), default part numbers, and associated fastener (nail/screw) configurations.

## Tips
- **Moving the Bracket**: Select the script and drag the **Grip Point** (blue square) to move the bracket along the beam.
- **Connecting Two Beams**: If you select two beams, the script attempts to place the bracket at their intersection. Double-clicking the object can swap the primary and secondary beam roles.
- **Face Selection (Single Beam)**: When inserting on a single beam, the bracket attaches to the face nearest to your click point.
- **Tolerance Adjustment**: If the timber swells or for easier assembly, increase the `dTolerance` value to create a slightly larger pocket in the wood.

## FAQ
- **Q: Why is the bracket not cutting into the wood?**
  A: Check the `iMillingType` property. If it is set to `0`, no cuts are generated. Set it to `1` (Rectangular Pocket) for standard inset applications.
- **Q: How do I switch to a different manufacturer?**
  A: Change the `sFamily` property in the dropdown menu. The `sProduct` list will update automatically to show available codes for that family.
- **Q: The bracket is facing the wrong way.**
  A: Use the Right-Click menu option **Rotate 180** or toggle the **bSwapLegs** property to flip the orientation.