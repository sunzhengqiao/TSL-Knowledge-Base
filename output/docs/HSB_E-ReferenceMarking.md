# HSB_E-ReferenceMarking

## Overview
This script automatically adds production reference marks to specific beams within a timber element. It is used to ensure correct positioning during assembly by marking beams based on a selected reference corner and offset.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on Elements and their beams within the 3D model. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: An Element (e.g., Wall, Floor) containing Beams.
- **Required Settings**: The TSL script **HSB_G-FilterGenBeams** must be loaded in the drawing to use the filter functionality effectively.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-ReferenceMarking.mcr` from the catalog.

### Step 2: Configure Properties (If applicable)
If you run the script without selecting a predefined Catalog Entry (Execute Key), a dynamic dialog will appear.
```
Dialog: ShowDynamicDialog
Action: Select the desired filter definition, reference corner, and offsets. Click OK to confirm.
```

### Step 3: Select Element
```
Command Line: Select elements
Action: Click on the Element(s) in the model to which you want to apply the reference marks. Press Enter to confirm selection.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Pos 1 | Text | " " | Unique identifier for this script instance. If another instance with the same ID exists on the element, it will be replaced. |
| Reference corner | Dropdown | \|Bottom left\| | Sets the origin corner of the element used to calculate beam start points and marking direction. |
| Offset marking | Number | 200 | The distance (in mm) from the beam's start point to the center of the reference mark. |
| Distance between marker lines | Number | 15 | The length (in mm) of the mark drawn on the beam. |
| Filter definition beams | Dropdown | *Dynamic* | Select a filter rule (defined in HSB_G-FilterGenBeams) to determine which beams receive the mark. |
| Extra Filter | Dropdown | \|--\| | Additional filter to include only Horizontal (\|X\|), Vertical (\|Y\|), or Both orientations relative to the element. |
| Color | Number | 4 | The color index (1-255) for the visualization symbol in the model. |
| Symbol size | Number | 40 | The graphical size (in mm) of the visualization symbol displayed in the model. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Execute Key | Applies the properties from a specific catalog entry preset to the script instance. |

## Settings Files
- **Catalog Entries**: Stored within the drawing or standard catalog.
- **Purpose**: Stores predefined property sets (Execute Keys) for different marking scenarios (e.g., "Left Wall Standard", "Floor Right").

## Tips
- **Visual vs. Production**: The "Symbol size" and "Color" properties only affect the 3D preview in AutoCAD. The actual physical mark on the beam is determined by the "Offset marking" and "Distance between marker lines".
- **Filtering**: If no marks appear, check if `HSB_G-FilterGenBeams` is loaded and if the selected "Filter definition beams" actually matches the beams in your element.
- **Conflict Management**: Use the "Pos 1" identifier to manage different marking schemes on the same element. Changing this ID allows you to run multiple instances of the script on a single element without conflicts.

## FAQ
- **Q: Why do I see an error "Beams could not be filtered!"?**
- **A:** Ensure that the TSL script `HSB_G-FilterGenBeams` is loaded in your drawing. This script is required to process the beam selection.

- **Q: Can I mark beams that are not rectangular?**
- **A:** Yes, the script calculates the start point based on the element coordinate system. However, filtering depends on the logic provided by the HSB_G-FilterGenBeams catalog.

- **Q: How do I remove the marks?**
- **A:** Right-click the Element, go to the TSL Menu, and select "Remove [Script Name]" or delete the script instance from the element properties.