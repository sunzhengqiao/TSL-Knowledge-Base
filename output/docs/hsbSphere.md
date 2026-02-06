# hsbSphere.mcr

## Overview
This script applies a spherical or revolution milling operation (end rounding) to timber beams at a user-defined location. It automatically generates both the 3D spherical machining contour and a perpendicular saw cut at the insertion point.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script is designed for use in the 3D model environment. |
| Paper Space | No | Not supported for layout or detailing views. |
| Shop Drawing | No | Not intended for generating 2D shop drawings directly. |

## Prerequisites
- **Required Entities**: At least one `GenBeam` must exist in the model.
- **Minimum Beam Count**: 1.
- **Required Settings**:
  - Company folder must contain a valid **revolution shape definition**.
  - **hsbSetting->Hundegger 2** configuration must be set up to map the script shapes to the correct machine tool indices.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `hsbSphere.mcr` from the file list.

### Step 2: Configure Properties (Optional)
Action: A dialog or the Properties Palette may appear upon launch. You can set the **Revolution Mill** shape now or modify it later.
- Select "Shape 1" or "Shape 2" depending on the desired tooling profile.

### Step 3: Select Beam(s)
```
Command Line: Select Beam(s)
Action: Click on the timber beam(s) in the model you wish to apply the sphere to. Press Enter to confirm selection.
```

### Step 4: Select Insertion Point
```
Command Line: [Select Point]
Action: Click on the beam where the center of the spherical cut should be located. This determines where the perpendicular cut and revolution mill will be applied.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Revolution Mill | dropdown | Shape 1 | Selects the specific CNC tooling configuration (Revolution Mill) to apply. This maps to a tool index defined in the Hundegger 2 settings (hsbSetting->Hundegger 2), determining the exact contour or radius of the spherical cut. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Grip Edit | Select the script entity and drag the grip to move the location of the sphere/cut along the beam. |
| Properties | Opens the Properties Palette to change the Revolution Mill shape (e.g., switch from Shape 1 to Shape 2). |
| Delete | Removes the script and associated machining from the beam. |

## Settings Files
- **Revolution Shape Definition**
  - **Location**: Company Folder (defined in your hsbCAD configuration).
  - **Purpose**: Provides the geometric definition for the revolution contour used to generate the 3D milling graphics and CNC path.
- **hsbSetting (Hundegger 2)**
  - **Purpose**: Maps the script properties ("Shape 1", "Shape 2") to specific tool indices on the Hundegger machine.

## Tips
- **Post-Insertion Editing**: You can easily move the sphere after insertion. Select the script entity in the model, click the grip point, and slide it to the new location along the beam.
- **CNC Output**: Ensure that the "Revolution Mill" selection corresponds correctly to your Hundegger machine settings to ensure the correct tool is called during manufacturing.
- **Dual Operation**: The script not only creates the spherical mill but also automatically applies a perpendicular Cut at the insertion point, trimming the beam end cleanly.

## FAQ
- Q: Why do I not see the cut in the 3D model?
  A: Ensure that your display style (Visual Style) is set to show 3D solids or machining operations (e.g., "Realistic" or "Shaded" with machining visibility turned on).
- Q: Can I use this on curved beams?
  A: The script is designed for standard GenBeams. While it may technically attach to other entities, it is optimized for linear timber elements.
- Q: What happens if I select "Shape 2" but it isn't defined in my settings?
  A: The script may default to a generic shape or produce an error in the CNC output. Verify your Hundegger 2 settings in the hsbCAD configuration.