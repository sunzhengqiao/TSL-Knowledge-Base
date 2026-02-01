# GE_WALL_POCKET_ORIGINAL.mcr

## Overview
This script automates the creation of a structural wall pocket (rough opening) in a stud frame wall to receive a beam or lintel. It handles framing generation (king studs, cripples, plates), sheathing gap filling, and the application of CNC milling operations.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be inserted onto a Stick Frame Wall in the 3D model. |
| Paper Space | No | This script does not function in Layout/Sheet views. |
| Shop Drawing | No | This is a model generation script, not a detailing script. |

## Prerequisites
- **Required Entities**: A valid Stick Frame Wall (`ElementWallSF`) must exist in the model.
- **Optional Entities**: You may select an existing Beam to automatically size the pocket, or select a Point to manually place it.
- **Required Settings**: None (uses standard hsbCAD wall and tooling catalogs).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_WALL_POCKET_ORIGINAL.mcr` from the file list.

### Step 2: Select Wall
```
Command Line: Select a Stud Framed Wall
Action: Click on the desired Stick Frame Wall in your drawing where the pocket should be created.
```

### Step 3: Define Reference
```
Command Line: Select a Beam OR press Enter to select a point for the pocket
Action:
Option A: Click on an existing structural beam that passes through the wall.
Option B: Press Enter, then click a point in the model to manually define the pocket location.
```

### Step 4: Configure Parameters
```
Action: The Properties Palette will open automatically. Adjust dimensions, gaps, and CNC settings as needed. The script will update the geometry in real-time.
```

## Properties Panel Parameters

### Location and Size
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Pocket Width (A) | Number | 3 | The horizontal width of the pocket opening. (Read-only if a Beam was selected in Step 3). |
| Elevation of Beam in Wall (B) | Number | 9.25 | The vertical height of the beam bottom (or pocket) relative to the reference. |
| Elevation taken from | Dropdown | Top of Wall | Determines if the elevation is measured down from the Top of Wall or up from the Bottom of Wall. |
| Gap Side | Number | 0 | Horizontal clearance space on the left and right of the beam (for sheathing/tolerances). |
| Gap Bottom | Number | 0 | Vertical clearance space below the beam (for sheathing/tolerances). |

### Extras
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Line Color | Number | -1 | Sets the display color of generated framing members (-1 uses the layer color). |
| Fill gaps with sheathing | Dropdown | Yes | If "Yes", generates solid filler panels (plywood/OSB) in the defined side and bottom gaps. |
| Add plate below beam | Dropdown | No | If "Yes", creates a bottom plate (sill) for the pocket assembly. |
| Plates | Dropdown | to be kept full | Determines how wall plates interact with the pocket. "to be cut" applies CNC cuts to existing plates; "to be kept full" stretches new members to existing plates. |
| King Placement | Dropdown | Normal | Sets the configuration of King studs: "Normal" (both sides), "Left", or "Right". |

### CNC Operations
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zones to mill seperated by ; | Text | | List of specific material layers (zones) to mill (e.g., "1;2"). |
| Tooling index | Number | 0 | The ID of the CNC tool/cutter to use for the operation. |
| Side | Dropdown | Left | The side of the wall from which the machine approaches. |
| Turning direction | Dropdown | Against course | Tool rotation direction relative to the wall ("Against course" or "With course"). |
| Overshoot | Dropdown | No | If "Yes", adds an overcut at corners to ensure a sharp finish. |
| Vacuum | Dropdown | No | If "Yes", activates vacuum hold-down points for the pocket area during machining. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Re-calculate Pocket | Erases the previously generated framing and tooling, then regenerates the pocket based on the current property settings and wall geometry. |

## Settings Files
None required.

## Tips
- **Auto-Sizing**: If you select a Beam during insertion, the script locks the "Pocket Width" to match the beam width. To manually control the width, insert the script using the "Point" option instead.
- **Sheathing Gaps**: Use the `Gap Side` and `Gap Bottom` parameters to account for sheathing thickness or shims. If `Fill gaps with sheathing` is set to "Yes", the script will automatically generate filler panels in these spaces.
- **Plate Management**: If your wall plates are already cut or managed separately, set the `Plates` property to "to be kept full" to prevent the script from adding unwanted cut operations to your main wall plates.

## FAQ
- **Q: Why can't I change the Pocket Width?**
  **A:** You likely selected a Beam during the insertion process. This automatically links the pocket width to the beam geometry. Delete the script instance and re-insert using the Point option to enable manual width control.
- **Q: How do I make the pocket opening rectangular vs. having an open side?**
  **A:** Change the `King Placement` property. "Normal" creates a closed pocket with studs on both sides. "Left" or "Right" leaves one side open (defined by the specific CNC path).
- **Q: My wall moved and the pocket stayed behind. What do I do?**
  **A:** Use the "Re-calculate Pocket" option from the right-click context menu. The script will detect the wall's new location and update the geometry accordingly.