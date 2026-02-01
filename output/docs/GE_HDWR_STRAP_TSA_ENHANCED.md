# GE_HDWR_STRAP_TSA_ENHANCED.mcr

## Overview
This script inserts a metal flat strap (Simpson Strong-Tie MSTA style or custom CS16) onto beams or trusses. It supports automatic blocking generation within wall elements and manages display representations for engineering outputs.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script creates 3D geometry and hardware components. |
| Paper Space | No | Not supported for layout generation. |
| Shop Drawing | No | Intended for 3D model detailing and BOM generation. |

## Prerequisites
- **Required Entities:** At least one Beam or TrussEntity must be present to serve as the anchor.
- **Minimum Beam Count:** 1.
- **Required Settings Files:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_HDWR_STRAP_TSA_ENHANCED.mcr` from the list.

### Step 2: Select Anchor Member
```
Command Line: Select a Beam or a Truss
Action: Click on a beam or truss in the model where you want the strap to connect.
```

### Step 3: Specify Strap Length
```
Command Line: Strap Length
Action: Enter a numeric value (in inches).
Note: If you enter a standard size (9, 12, 15, 18, 21, 24, 30, 36), standard mode is used. Any other number automatically enables "Custom Mode".
```

### Step 4: Position Strap
```
Command Line: Select insertion Point (Center of Strap)
Action: Click in the model to place the center point of the strap along the beam.
```

### Step 5: Attach to Wall (Optional)
```
Command Line: Select an Entities or Elements to attach Display to (Optional)
Action: Select a Wall or Element if you want to generate blocking inside the wall and link the display to the wall structure. Press Enter to skip if placing on a standalone beam.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Number of Beams** | Text | 1 Selected | Displays the count of currently selected reference beams (Read-only). |
| **MSTA Length** | Dropdown | 9 | Selects the standard stock length (in inches) for the strap. Options: 9, 12, 15, 18, 21, 24, 30, 36. |
| **Face** | Dropdown | 1 | Selects which side of the beam the strap attaches to (1-4). *Note: This becomes locked if a wall element is attached.* |
| **Face Offset** | Number | 0.4375 | Sets the distance (standoff) from the beam face to the centerline of the strap (in inches). |
| **Lateral Offset** | Number | 0 | Slides the strap along the width of the beam face (in inches). |
| **CS16 PROPERTIES** | Text | [Space] | Visual separator only. |
| **Force to a CS16** | Dropdown | Yes | Toggles Custom Mode. Select "No" to use standard MSTA lengths, or "Yes" to define a custom length below. |
| **Length if CS16** | Number | 36 | Defines the custom strap length (in inches) when "Force to a CS16" is set to "Yes". |
| **Strap Item** | Text | Strap | The material code or item name for reports (e.g., MSTA-24). Read-only. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Set Reference Beam** | Prompts you to select a new beam or truss. This updates the anchor point and orientation if the original member was deleted or moved. |
| **Add wall(s) to the display** | Allows you to select additional Walls or Elements to attach the strap to. Useful for adding the strap to multiple wall layers or updating the host after design changes. |
| **Create blocking** | Manually triggers the generation of wood blocking pieces inside the associated wall element. This is required to fill the void behind the strap for nailing. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: All parameters are stored within the script instance properties.

## Tips
- **Custom Lengths:** If you need a length not found in the standard dropdown (e.g., 14 inches), simply type that value during the command line insertion. The script will automatically switch to "Custom Mode" and populate the "Length if CS16" field.
- **Wall Association:** When attaching to a wall, the script automatically detects which side the wall is on and flips the "Face" property to match. This prevents the strap from being embedded backward in the wall.
- **Blocking Generation:** Blocking is not created automatically upon every move to save processing time. Use the "Create blocking" right-click option after finalizing the strap position to generate the wood pieces.

## FAQ
- **Q: Why can't I change the "Face" number (1-4)?**
- **A:** You likely have a Wall or Element attached to the strap. The script locks this property to ensure the strap always faces the correct side of the wall volume. Detach the wall or edit the selection to unlock it.
- **Q: How do I switch from a standard size (e.g., 24") to a custom size?**
- **A:** Set "Force to a CS16" to "Yes" in the properties palette, then type your desired length in the "Length if CS16" field.
- **Q: My strap disappeared after I deleted the beam.**
- **A:** The script requires a valid reference beam. Use the right-click option "Set Reference Beam" to select a new beam and restore the geometry.