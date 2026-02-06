# Simpson StrongTie - Adjustable Pitch Connector

## Overview
This script generates a 3D model of a Simpson Strong-Tie VPA (Variable Pitch Anchor) adjustable joist hanger. It connects a male joist (e.g., rafter) to a female supporting beam (e.g., ledger) and automatically adjusts to accommodate pitches between 15 and 45 degrees.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D Body generation |
| Paper Space | No | Not applicable |
| Shop Drawing | No | This is a model generation script |

## Prerequisites
- **Required Entities**: Two GenBeams (one "Male" joist and one "Female" support beam).
- **Minimum Beam Count**: 2
- **Required Settings**: None
- **Geometry Requirements**: The Male and Female beams must be perpendicular and in physical contact.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the AutoCAD command line.
2. Select the file `Simpson StrongTie - Adjustable Pitch Connector.mcr`.

### Step 2: Select Male Beam
```
Command Line: Select male beam
Action: Click on the joist or rafter that sits on top of the support beam.
```

### Step 3: Select Female Beam
```
Command Line: Select female beam
Action: Click on the supporting beam or ledger plate that the joist connects to.
```

### Step 4: Configure Properties
1. Once selected, the script will generate the initial connector.
2. Select the connector to view its properties in the AutoCAD Properties Palette (OPM).
3. Adjust parameters if necessary (e.g., if the beam width is slightly undersized).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Male Tolerance | Number | 0 | Adds a tolerance allowance to the male beam width. Use this if the timber is slightly undersized compared to the nominal hanger size. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None Defined | No custom context menu items are added by this script. |

## Settings Files
- **None**: This script does not rely on external settings files.

## Tips
- **Pitch Limits**: Ensure the angle (pitch) between the joist and the support beam is between **15° and 45°**. Outside this range, the manufacturer recommends against using this connector, and the script may display a validation error.
- **Beam Contact**: The top of the female beam must physically touch the bottom of the male beam. Ensure they are not intersecting or floating apart.
- **Perpendicularity**: The beams must be perpendicular (90°) to each other in plan view.
- **Troubleshooting Fit**: If you see an error "Male beam doesn't fit in hanger," check your actual beam width. If it is just slightly smaller than the standard size (e.g., due to timber planning), increase the **Male Tolerance** property in the Properties Palette.

## FAQ
- **Q: The connector disappeared after I moved the beams. Why?**
  - A: The script performs real-time validation. If the beams are no longer touching, are no longer perpendicular, or the pitch has exceeded 45°, the connector will delete itself to prevent incorrect modeling.
- **Q: How do I fix the error "Male beam doesnt fit in hanger"?**
  - A: This usually happens if your beam width is not an exact match for the standard Simpson Strong-Tie sizes. Increase the **Male Tolerance** value in the Properties Palette to allow a small margin of error.
- **Q: Can I use this for flat roofs (0° pitch)?**
  - A: No, this specific connector (VPA) is designed for adjustable pitches between 15° and 45°. Use a standard face-mount hanger for flat connections.