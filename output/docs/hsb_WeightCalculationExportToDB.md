# hsb_WeightCalculationExportToDB.mcr

## Overview
This script calculates the total weight of construction elements (walls or floors) by analyzing their specific material compositions and applying a default density for standard timber. It automatically attaches the calculated total weight (in Kg) to the element as a data attribute named "PANELWEIGHT" for use in production reports or databases.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run on Elements in the model. |
| Paper Space | No | Not applicable for layouts. |
| Shop Drawing | No | This is a model-level calculation tool. |

## Prerequisites
- **Required entities**: One or more hsbCAD Elements (e.g., Walls, Floors).
- **Minimum beam count**: 0 (Elements can be empty or contain any number of beams/sheets).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_WeightCalculationExportToDB.mcr` from the file dialog.

### Step 2: Select Elements
```
Command Line: Select a set of elements
Action: Click on the desired Walls or Floors in the 3D model or plan view and press Enter.
```
*Note: You can select multiple elements in a single operation.*

### Step 3: Configure Weight Properties
After selection, the script attaches to the elements. Select one of the processed elements and open the **Properties Palette** (Ctrl+1).
1.  Locate the "TSL" or "Script" section in the properties.
2.  Adjust the **Weight for Standard Beams** value if the default timber density does not match your material.
3.  The element will automatically regenerate to update the weight calculation.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Weight for Standard Beams (Kg/m3) | number | 450 | The density (Kg/m³) used to calculate the weight of any beam that does not match the specific internal profile list (e.g., standard timber studs). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are added by this script. |

## Settings Files
None.

## Tips
- **Batch Processing:** You can select numerous elements at once during the insertion prompt; the script will attach to all of them individually.
- **Automatic Updates:** If you modify the geometry of the element (e.g., add sheets or change beam lengths), the script automatically recalculates the weight when the element regenerates.
- **Data Access:** The calculated weight is stored in an invisible data attribute named "PANELWEIGHT". Ensure your production export lists or data reports are configured to read this attribute to see the values.

## FAQ
- **Q: How does the script calculate weight for different materials?**
  A: The script contains an internal list of specific sheet materials and beam profiles. If a match is found, it uses a predefined factor. If no match is found (e.g., custom timber sizes), it calculates weight based on the volume of the beam multiplied by the "Weight for Standard Beams" property.
- **Q: Where can I see the resulting weight?**
  A: The result is not a visual 3D object. It is written to the element's data. You will see the value when exporting data to production databases (CAM) or if you run a listing/report that includes Element Attributes.
- **Q: What happens if I run the script on an element twice?**
  A: The script includes a self-cleaning mechanism that detects and removes duplicate instances of itself on the same element, ensuring only one weight calculation remains active.