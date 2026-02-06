# hsb_Vent

## Overview
This script creates ventilation openings (rectangular or round) in timber frame walls or roofs. It automatically cuts the exterior sheeting and generates the necessary surrounding timber framing members (cripple studs/jacks) to maintain structural integrity.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates on 3D Elements (Walls/Roofs). |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: An existing hsbCAD Element (Wall or Roof) containing Sheets (cladding).
- **Minimum Beams**: 0 (though existing studs are used for snapping).
- **Required Settings**: TslUtilities.dll must be loaded (standard hsbCAD environment).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or `hsb_ScriptInsert`)
Action: Select the `hsb_Vent.mcr` file from the file browser.

### Step 2: Select Element
```
Command Line: Select Element:
Action: Click on the Wall or Roof element where you want to place the vent.
```

### Step 3: Specify Location
```
Command Line: Specify insertion point:
Action: Click on the face of the element to define the position of the vent.
```

### Step 4: Configure Properties
Action: Press `Enter` or `Esc` to finish insertion. Select the script instance and adjust parameters in the **Properties Palette** (OPM) to define size, shape, and framing behavior.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Display** | | | |
| Format Label | text | Vent | Defines the format of the description label (for production lists). |
| Dimension style | dropdown | *Current* | Selects the CAD dimensioning style for the vent. |
| Display Representation | text | | Controls the visibility/display of the vent in different views. |
| **Location and size** | | | |
| Height to underside of top timber | number | 1250 mm | The vertical elevation of the vent relative to the element base. |
| Vent Shape | dropdown | Rectangular | Choose between **Rectangular** or **Round**. |
| Width of vent | number | 150 mm | Horizontal width (used for Rectangular vents). |
| Height of vent | number | 150 mm | Vertical height (used for Rectangular vents). |
| Diameter of Vent | number | 150 mm | Diameter size (used for Round vents). |
| Create Vertical Blocks | dropdown | Yes | If **Yes**, creates vertical timber members (studs) around the vent. |
| Stretch vertical | dropdown | Do not stretch | Determines if vertical beams stretch to top/bottom plates (Do not stretch, Stretch left, Stretch right, Stretch both). |
| Snap to existing studs | dropdown | Yes | If **Yes**, the vent position snaps to align with nearby existing studs. |
| Fixed vent | dropdown | No | If **Yes**, locks the horizontal position so it does not snap to studs or move automatically. |
| Freeze vent | dropdown | No | If **Yes**, stops automatic regeneration of beams, allowing manual editing. |
| Delete existing stud | dropdown | No | If **Yes**, deletes an existing stud that collides with the vent opening. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add/Remove Format | Adds or removes the format label/mark from the model. |
| Select tool | Selects the tool/script instance (useful for finding specific objects in a complex model). |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not use external XML settings files.

## Tips
- **Positioning**: If the vent keeps jumping to a location you didn't click, set **Fixed vent** to **Yes**. This overrides the automatic stud snapping feature.
- **Manual Editing**: If you need to manually modify the generated cripple studs (e.g., adding specific notches or cuts), set **Freeze vent** to **Yes**. This prevents the script from overwriting your manual changes during the next recalculation.
- **Round Vents**: When switching to **Round** vents, the Width and Height parameters are ignored, and the Diameter parameter is used instead.

## FAQ
- **Q: Why is there no hole in my sheeting?**
  - A: Ensure the script is inserted into an Element that has Sheets assigned to it. The script cuts the Sheet based on the calculated profile.
- **Q: The vent is cutting through an existing stud. What should I do?**
  - A: You can set **Delete existing stud** to **Yes** to remove the interfering stud automatically. Alternatively, set **Fixed vent** to **No** and **Snap to existing studs** to **Yes** so the vent moves to a clear bay.
- **Q: How do I create a rectangular vent that is taller than it is wide?**
  - A: Set **Vent Shape** to **Rectangular**, then adjust the **Width of vent** and **Height of vent** values independently in the properties panel.