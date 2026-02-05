# HSB_W-DistributeHorizontalSheeting.mcr

## Overview
This script automatically generates horizontal sheeting or siding boards on wall elements. It calculates the layout based on a specified distribution point, ensuring boards fit the wall profile and around openings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment to generate construction entities. |
| Paper Space | No | Not applicable for 2D drawing generation. |
| Shop Drawing | No | This is a model generation script, not a detailing script. |

## Prerequisites
- **Required Entities**: Wall elements (`ElementWallSF`).
- **Required Context**: A valid TSL instance named `HSB_G-DistributionPoint` must exist in the same Floor Group.
- **Required Settings**: The target Zone on the wall must have its "Distribution" property set to "Horizontal Lap Siding".

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_W-DistributeHorizontalSheeting.mcr`

### Step 2: Configure Properties
```
Command Line: None (Dialog Box)
Action: The "Properties" dialog appears automatically (if not run from a catalog).
       - Set the 'Distribution number' to match your Distribution Point instance.
       - Set 'Zone index' to the wall layer you want to sheet.
       - Adjust sheet dimensions (Width, Length, Thickness).
       - Click OK to proceed.
```

### Step 3: Select Elements
```
Command Line: Select elements
Action: Click on the Wall Element(s) you wish to apply the sheeting to.
       Press Enter to confirm selection.
```

### Step 4: Generation
```
Action: The script attaches to the wall and generates the sheets.
       If the Distribution Point is found, the sheets are aligned starting from that reference height.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Sequence number | number | 0 | Determines the execution order of this script during "Generate Construction". |
| Distribution number | number | 0 | The ID of the `HSB_G-DistributionPoint` to use as the start reference. |
| Zone index | number | 2 | The specific construction layer (Zone) of the wall to receive the sheeting. |
| Maximum sheet length | number | 6000 | The maximum length of a single board before it is jointed (in mm). |
| Sheet width | number | 240 | The exposed face width of the sheeting board (in mm). |
| Sheet thickness | number | 0 | Thickness of the material. Set to 0 to use the Zone's default thickness. |
| Gap in length direction | number | 0 | Horizontal gap between the ends of boards (in mm). |
| Gap in width direction | number | 0 | Vertical gap or overlap between rows of boards (in mm). |
| Sheet color | number | 1 | The display color index for the generated sheets. |
| Sheet material | text | [Empty] | Material name for reports/BOM. Leave empty to use Zone material. |
| Beam code first sheet above distribution point | text | [Empty] | A specific identifier assigned to the first row of sheets above the distribution point. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the sheeting layout if the wall geometry or properties change. |
| Erase | Removes the script instance and the associated generated sheets. |

## Settings Files
- **Filename**: None specific.
- **Location**: N/A
- **Purpose**: This script relies primarily on Element Zone settings and the `HSB_G-DistributionPoint` instance rather than external settings files.

## Tips
- **Reference Height**: To change where the sheeting starts vertically, move the `HSB_G-DistributionPoint` entity in the model rather than editing script properties.
- **Zone Configuration**: Ensure the Zone properties (Material, Thickness) are correctly set on the wall before running this script, especially if you set script dimensions to 0 to inherit values.
- **Openings**: The script automatically trims sheets around wall openings.

## FAQ
- **Q: I get an error "Distribution point with number X cannot be found!".**
  A: Ensure you have inserted the `HSB_G-DistributionPoint` TSL into the same Floor Group and that its "Number" property matches the "Distribution number" in this script.
- **Q: The script warns "The distribution of selected zone is not set to horizontal lap siding".**
  A: Select the wall, go to Properties, find the Zone specified by "Zone index", and change the "Distribution" setting to "Horizontal Lap Siding".
- **Q: How do I create a reveal (shadow gap) between rows?**
  A: Set the "Gap in width direction" property to your desired reveal size.
- **Q: Can I change the sheet material later?**
  A: Yes, select the generated sheeting or the script instance in the model and update the "Sheet material" property in the Properties Palette, then Recalculate.