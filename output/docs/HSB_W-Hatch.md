# HSB_W-Hatch.mcr

## Overview
This script automates the creation of a roof hatch (skylight) opening within a knee wall. It supports two modes: creating a rotating hatch assembly with a cover sheet or modifying the existing wall sheeting ("On studs") to form the opening, including automated trimmer beam insertion.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D element creation and modification. |
| Paper Space | No | |
| Shop Drawing | No | This script generates physical construction elements. |

## Prerequisites
- An existing **Element** (Knee Wall) in the model.
- A minimum of **4 Beams** (studs and plates) to frame the opening.
- The script must be run in **3D Model Space**.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_W-Hatch.mcr`

### Step 2: Select Wall
```
Command Line: Select a knee wall
Action: Click on the knee wall element where you want to insert the hatch.
```

### Step 3: Define Location
```
Command Line: Select a position
Action: Click inside the wall bay (between studs and plates) to define the center/bottom location of the hatch.
```

### Step 4: Configure Properties
After selecting the position, the **Properties Palette** (or a dynamic dialog) will appear. Adjust the hatch type, dimensions, and materials as needed. The script will automatically generate the framing and sheeting based on these settings.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Hatch** | | | |
| Type hatch | dropdown | | Selects the construction method: "Rotating" (creates a cover sheet and pivot lath) or "On studs" (splits existing wall sheeting). |
| Gap hatch | number | 2 | Clearance gap between the hatch frame and the surrounding structure (mm). |
| **All hatches** | | | |
| Offset horizontal trimmer from floor | dropdown | \|Yes\| | If "Yes", the bottom trimmer height is calculated based on floor elevation. |
| Flooroffset from wall outline | number | 0 | Vertical distance offset applied to the trimmer position relative to the floor outline (mm). |
| Offset from floor | number | 0 | Fine adjustment for the trimmer height relative to the floor (mm). |
| Zone index sheeting | dropdown | 0 | The construction zone index used to source default material properties. |
| **Rotating hatch** | | | |
| Turning direction | dropdown | | Direction the hatch opens: "\|Left\|" or "\|Right\|". |
| Material hatch | text | | Material code for the hatch sheet (e.g., C24). |
| Name hatch | text | | Specific name identifying the hatch sheet part. |
| Grade hatch | text | | Structural grade of the hatch material. |
| Thickness hatch | number | -1 | Thickness of the hatch sheet. Set to -1 to detect automatically from the sheeting zone. |
| Color hatch | number | 3 | CAD color index for the hatch sheet. |
| Zone index hatch | dropdown | 2 | Construction zone index to which the hatch sheet belongs. |
| **Hatch on studs** | | | |
| Rotate horizontal trimmer | dropdown | \|Yes\| | If "Yes", the bottom trimmer beam is rotated 90 degrees. |
| **Style** | | | |
| Dimension style\| | dropdown | | Dimension style applied to hatch text labels. |
| Line type\| | dropdown | | Line type used for drawing the hatch swing indicator. |
| Color\| | number | -1 | Color for drawing indicators (text and lines). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Set Properties From Zone | Automatically updates the Material, Name, Grade, and Thickness properties based on the element's zone and sheeting data. Useful if the current values are empty or need to match the wall configuration. |

## Settings Files
None required.

## Tips
- **Valid Location is Key:** Ensure you click inside a valid bay bounded by vertical studs and horizontal plates. If the script cannot find these boundaries, it will erase itself and display an error.
- **Switching Types:** You can switch between "Rotating" and "On studs" via the Properties Palette after insertion. The script will either create a new sheet or split the existing ones accordingly.
- **Auto-Detect Thickness:** Leave "Thickness hatch" set to -1 to have the script automatically match the thickness of the existing wall sheeting in the selected zone.
- **Moving the Hatch:** Use the grip edit point to move the hatch to a different location on the wall. The script will recalculate the necessary framing and cuts.

## FAQ
- **Q: Why did the script disappear after I picked a point?**
  **A:** The script requires valid vertical studs on the sides and horizontal plates on the top and bottom of the selected point. If these are missing, the script deletes itself to prevent errors.
  
- **Q: How do I adjust the size of the opening?**
  **A:** The opening size is determined by the position relative to the wall framing. Move the insertion point closer to studs to make it narrower or adjust the "Gap hatch" property to change the clearance.

- **Q: What is the difference between the "Rotating" and "On studs" types?**
  **A:** "Rotating" creates a new physical sheet that acts as a door, complete with a pivot beam. "On studs" simply cuts a hole in the existing wall sheathing and modifies the bottom segment's properties.