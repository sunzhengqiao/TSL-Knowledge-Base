# hsb_DoubleTennonAtBeamEnd.mcr

## Overview
This script generates a double tenon connection where one "male" beam connects to two "female" beams simultaneously. It is designed to create cross-joints with customizable dimensions, tolerances, and tenon shapes for timber framing.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in 3D model environment. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not a drawing generation script. |

## Prerequisites
- **Required Entities:** 3 `GenBeam` entities (1 Male beam and 2 Female beams).
- **Minimum Beam Count:** 3
- **Required Settings:** None specific (defaults are used).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse and select `hsb_DoubleTennonAtBeamEnd.mcr`

### Step 2: Configure Dimensions (Optional)
If a catalog entry is not pre-selected, a Properties dialog will appear automatically.
- **Action:** Review and adjust parameters like Width, Depth, and Length. Click OK to confirm.

### Step 3: Select Male Beam
```
Command Line: Select male beam
Action: Click on the main beam (the one that will have the tenons sticking out).
```

### Step 4: Select Female Beams
```
Command Line: Select female beam(s)
Action: Click on the two beams that will receive the tenons (have the mortises).
```

### Step 5: Completion
- **Action:** The script automatically calculates the geometry, creates the tenon on the male beam, and cuts mortises in the female beams.

## Properties Panel Parameters

After insertion, select the script instance in the model to edit these parameters in the Properties Palette.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Width | Number | 40 | The lateral width of the tenon. |
| Depth | Number | 50 | The vertical thickness (height) of the tenon. |
| Length | Number | 50 | The penetration length of the tenon into the female beams. |
| Offset from axis | Number | 0 | Slides the entire connection geometry forwards or backwards along the beam axis. |
| Tolerance depth | Number | 0 | Extra clearance added to the *height* of the female mortise only (does not change tenon size). |
| Gap on Length | Number | 0 | Extra clearance added to the *length* of the female mortise only (allows for longitudinal movement). |
| Shape | Dropdown | Rectangular | The profile of the tenon corners. Options: Rectangular, Round, Rounded. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No specific context menu items are defined for this script. Use the Properties Palette for edits. |

## Settings Files
- **Filename:** None
- **Location:** N/A
- **Purpose:** N/A

## Tips
- **Tolerance Control:** Use `Tolerance depth` and `Gap on Length` if you need a loose fit for the male tenon inside the female mortises. This ensures the tenon remains standard size while the holes are larger.
- **Moving the Joint:** If you need to move the connection to a different spot along the beam, use the `Offset from axis` property or move the script insertion point (grip edit) rather than re-creating it.
- **Shape Selection:** Select `Rounded` or `Round` shapes if you are using CNC tooling that prefers radiused corners over sharp 90-degree angles.

## FAQ
- **Q: Why are my mortises bigger than my tenon?**
- **A:** You likely have a value greater than 0 in the `Tolerance depth` or `Gap on Length` properties. These parameters are designed to add clearance specifically to the female beams.

- **Q: Can I connect to only one beam?**
- **A:** No, this script is designed specifically for a "Double" connection. It requires exactly one male beam and two female beams to generate the geometry correctly.