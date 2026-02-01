# Attach Beam to Wall - Pocket & Point Load

## Overview
Automates the connection of a beam to a wall by creating a receiving pocket in the top-most wall element and calculating point loads (BALK) on the supporting elements below.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required. Script performs 3D geometric calculations on GenBeams and Elements. |
| Paper Space | No | Script does not support 2D layout or shop drawing generation. |
| Shop Drawing | No | Script operates directly on the 3D model entities. |

## Prerequisites
- **Required entities**: 
  - 1 `GenBeam` (e.g., floor joist or rafter).
  - 1 or more `Element` (e.g., top plates, studs, or rim beams).
- **Minimum beam count**: 1
- **Required settings**: None (uses internal script properties).

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` → Select `Attach Beam to Wall - Pocket & Point Load.mcr`

### Step 2: Select Beam
```
Command Line: Select a beam
Action: Click on the beam (e.g., joist/rafter) that you want to insert into the wall.
```

### Step 3: Select Wall Elements
```
Command Line: Select a set of elements
Action: Select the wall elements (top plates and studs) that will support the beam. You can select multiple elements.
Note: The script will automatically identify which element is the "Top" element (highest Z-value) to place the pocket.
```

### Step 4: Configure Properties
**Action**: A dynamic dialog appears on insert. Adjust parameters such as the clearance gap (Space), milling options, and pocket dimensions. Click **OK** to generate.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Space | Number | 0.5 mm | Clearance gap around the beam within the pocket to allow for tolerances and swelling. |
| Tooling index | Number | 0 | CNC machine tool identifier to be used for the milling operation. |
| Milling | Dropdown | Apply milling | Determines if CNC milling data is generated ("Apply milling") or if geometry is visual only ("Do not mill"). |
| Side | Dropdown | Left | Specifies the side of the contour for tool radius compensation (Left/Right). |
| Turning direction | Dropdown | Against course | Milling strategy: "Against course" (Climb Milling) or "With course" (Conventional Milling). |
| Overshoot | Dropdown | No | If "Yes", the milling tool overruns slightly beyond the geometry for cleaner corner cuts. |
| Vacuum | Dropdown | No | If "Yes", activates vacuum hold-down commands for the CNC machine in this area. |
| Text Style | Dropdown | *Empty* | Sets the dimension style for point load labels and annotations. |
| Show in Disp Rep | Text | *Empty* | Filter name controlling which drawing views the script graphics are visible in. |
| Pocket-C parameters | Dropdown | Set width & height based on beam | Switches between automatic sizing based on the selected beam or manual user input. |
| Pocket Height | Number | *Calculated* | Depth/height of the pocket cut. Only editable if "Set width & height manually" is selected. |
| Pocket Width | Number | *Calculated* | Length of the pocket along the wall. Only editable if "Set width & height manually" is selected. |
| Braceheight | Number | 0 | Height of material remaining at the top of the pocket (lip). |

## Right-Click Menu Options
*(No custom menu items defined)*
Standard hsbCAD context menu options apply:
- **Recalculate**: Updates the script geometry based on current property values or beam movement.
- **Delete**: Removes the script instance.

## Settings Files
None. The script uses internal properties and does not rely on external XML settings files.

## Tips
- **Selection Order**: When selecting wall elements, select all relevant members (studs + top plate). The script automatically sorts them and applies the pocket only to the highest one.
- **Adjusting Dimensions**: If the automatic pocket size based on the beam isn't suitable (e.g., you need a deeper seat), change "Pocket-C parameters" to "Set width & height manually" in the Properties Palette.
- **Performance**: During the design phase, set "Milling" to "Do not mill". This skips CNC calculation and keeps the model lighter. Switch it back to "Apply milling" only when preparing for production.

## FAQ
- **Q: How is the number of studs for the point load determined?**
  A: The script calculates the number of studs (Point Load) based on the "Pocket Width" and the stud spacing of the selected elements.
- **Q: I moved the beam, but the pocket didn't move.**
  A: Right-click the script instance (or the wall element) and select "Recalculate". The script updates the intersection point automatically.
- **Q: Can I use this for CLT (Cross Laminated Timber) panels?**
  A: Yes, as long as the target is a valid hsbCAD `Element`. The script will apply the pocket and point load logic regardless of the material type.
- **Q: What does "Turning direction: Against course" mean?**
  A: This refers to Climb Milling, where the cutter rotates against the direction of feed. It often results in a better finish but requires specific machine capabilities. "With course" is Conventional Milling.