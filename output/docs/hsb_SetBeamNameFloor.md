# hsb_SetBeamNameFloor.mcr

## Overview
This script automates the naming, coloring, and material assignment of floor and roof beams based on their beam codes (e.g., Joist, Rimboard, Trimmer). It ensures that all structural components within an element adhere to standard naming conventions and have the correct production properties applied automatically.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be applied to an ElementRoof or Floor Element in the 3D model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Not applicable for shop drawing generation. |

## Prerequisites
- **Required Entities**: An existing `ElementRoof` (Floor or Roof) containing `GenBeam` entities.
- **Minimum Beam Count**: 0 (Script can run on empty elements).
- **Required Settings**: None. All settings are managed via the Properties Palette.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the AutoCAD command line.
2.  Browse to the location of `hsb_SetBeamNameFloor.mcr` and select it.
3.  Click **Open**.

### Step 2: Select Element
```
Command Line: Select element:
Action: Click on the Floor or Roof element you wish to process.
```
*Note: You can select multiple elements if required.*

### Step 3: Configure Properties (Optional)
1.  Select the element.
2.  Open the **Properties Palette** (Ctrl+1).
3.  Scroll down to the section labeled "TSL: hsb_SetBeamNameFloor...".
4.  Adjust names, materials, or colors as needed.
5.  Right-click the element and select **TSL | Update** to apply changes.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Global Settings** | | | |
| sJoistMaterial | Dropdown | Other Material | Selects the specific material profile for Joists (Code 'J'). Options: Alpine SpaceJoist, Alpine FloorTrus, or Other Material. |
| sOtherMaterial | String | **Other Type** | The custom material string to use if "Other Material" is selected above. |
| sSetLabel | Yes/No | No | If Yes, sets the SubLabel of all beams to the Element's Group Name. |
| **Joist Settings** | | | |
| sbmName04 | String | Joist | The display name assigned to standard Joists. |
| nColorDef04 | Integer | 32 | The AutoCAD color index for Joists. |
| sbmMaterial04 | String | (Empty) | Material specification for Joists (e.g., C24). |
| sbmGrade04 | String | (Empty) | Structural grade for Joists. |
| sbmInformation04 | String | (Empty) | Additional metadata for Joists. |
| **Rimboard Settings** | | | |
| sbmName00 | String | Rim Board | The display name for perimeter rim boards. |
| sbmMaterial00 | String | (Empty) | Material specification for Rimboards. |
| **Trimmer Settings** | | | |
| sbmName02 | String | Trimmer | The display name for trimmer beams. |
| sbmMaterial02 | String | (Empty) | Material specification for Trimmers. |
| **Blocking Settings** | | | |
| sbmName03 | String | Blocking | The display name for blocking pieces. |
| sbmMaterial03 | String | (Empty) | Material specification for Blocking. |
| **Facing Joist Settings** | | | |
| sbmName01 | String | Facing Joist | The display name for facing joists. |
| sbmMaterial01 | String | (Empty) | Material specification for Facing Joists. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| TSL | Update | Re-runs the script to apply any changes made in the Properties Palette or to update after geometry changes. |
| TSL | Erase | Removes the script instance from the element. Beams will keep their last assigned names/values but will not update automatically thereafter. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external XML settings files. All configuration is stored within the script properties on the element.

## Tips
- **Code 'J' Logic**: If a beam has the code 'J', the script will try to apply the specific Alpine material profile if selected in `sJoistMaterial`. Otherwise, it falls back to the material defined in `sbmMaterial04`.
- **Uncoded Beams**: Beams without a specific code will be named "Joist" if they have a rectangular profile, or named after their profile name if they are custom.
- **Visual Organization**: Use the `nColorDef04` (Joist Color) to visually differentiate standard joists from rim boards or trimmers in the 3D model.

## FAQ
- **Q: Why didn't my beams rename?**
  - A: Ensure the script is attached to the element. Select the element, check the Properties Palette for the TSL instance. If present, right-click and choose **TSL | Update**.
- **Q: Can I use this for walls?**
  - A: No, this script is designed specifically for floor and roof elements (`ElementRoof`).
- **Q: How do I apply a specific material like "C24" to all Joists?**
  - A: Set `sJoistMaterial` to "Other Material", type "C24" into the `sOtherMaterial` field, and run **TSL | Update**.
- **Q: What happens if I delete the script?**
  - A: The element and beams remain in the model, but they will no longer automatically update their names or materials if the element geometry changes or if new beams are added.