# hsb_ShowElementWeight

## Overview
This script automatically calculates the total weight of timber construction elements (walls, floors, and roofs) based on their material composition and dimensions. It displays the weight as an annotation label that updates dynamically if the element geometry changes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The label is attached directly to the 3D element. |
| Paper Space | Yes | The label is placed inside a selected viewport on a layout sheet. |
| Shop Drawing | No | This is for model annotation and element reporting. |

## Prerequisites
- **Required Entities:** An existing Element (Wall, Floor, or Roof).
- **Minimum Beam Count:** 0 (Calculates based on all content within the element).
- **Required Settings:** `Materials.xml` must exist in your company folder (`..._kPathHsbCompany\Abbund\`) containing density values for the materials used in your project.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_ShowElementWeight.mcr`

### Step 2: Configure Properties
The Properties Palette will appear automatically upon insertion.
1.  **Insert in:** Choose "Model" to place the label on the 3D object, or "Viewport" to place it on a 2D drawing view.
2.  Set your preferred **Dim Style**, **Rotation**, and **Max Weight** limit.
3.  Close the Properties Palette to proceed.

### Step 3: Select Location (Based on Mode)
**If "Model" mode is selected:**
```
Command Line: Select a set of elements
Action: Click on the desired Wall, Floor, or Roof elements in the drawing. Press Enter to confirm.
```
*The script will attach a weight label to each selected element.*

**If "Viewport" mode is selected:**
```
Command Line: Pick a Point
Action: Click inside the layout where you want the weight text to appear.
```
```
Command Line: Select a viewport
Action: Click on the viewport border that displays the element you wish to label.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Insert in | dropdown | Model | Determines if the label is placed in the 3D Model or a 2D Viewport. |
| Dim Style | dropdown | <Current> | Selects the text style (font, size) for the weight label from the drawing's dimension styles. |
| Rotation | number | 0 | Sets the rotation angle of the text label (in degrees). |
| Max weight | number | 100 | The weight threshold. If the element weight exceeds this value, the text turns red. |
| Prefix | text | | Custom text added before the weight value (e.g., "Total: "). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the weight calculation if the element has been modified. |
| Erase | Removes the script instance and the weight label. |

## Settings Files
- **Filename**: `Materials.xml`
- **Location**: `_kPathHsbCompany\Abbund\`
- **Purpose**: This file maps material names (used in the Element) to density values (kg/m³). The script uses this data to calculate the physical weight of beams, sheets, and structural insulated panels (SIPs).

## Tips
- **Color Warning:** If the weight text appears red, the element exceeds the "Max weight" value set in properties, indicating it may require machinery for lifting.
- **Unit Support:** The script automatically detects the drawing units. It will calculate and display in **kg** for metric drawings or **lb** for imperial drawings.
- **Automatic Updates:** If you add or remove beams from a wall, or resize a panel, run the "Recalculate" option (or update the element) to refresh the displayed weight.
- **Element Splitting:** If you split an element (e.g., a wall) into two parts, the script will automatically handle the split, ensuring the correct weight remains assigned to the original part and removing the reference from the new part.

## FAQ
- **Q: Why does the label show "Material not found"?**
  **A:** The material assigned to a beam or sheet in the element does not exist in the `Materials.xml` file. The script will use a default density if available, or you must add the specific material to the XML file.
- **Q: Why did the script fail to insert?**
  **A:** Ensure the `Materials.xml` file exists in the correct company folder (`Abbund`). The script cannot function without the material density definitions.
- **Q: Can I use this for individual beams?**
  **A:** No, this script is designed to calculate the total weight of an entire Element (like a Wall or Floor assembly) containing multiple beams and sheets.