# f_Package.mcr

## Overview
This script groups selected timber elements (beams, walls, or bodies) into a logical transport or production package. It automatically calculates the total weight, generates a 3D visual bounding box, and applies labels and property data to the contained items.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script processes 3D geometry and attaches properties to entities in Model Space. |
| Paper Space | No | This script does not function in Layouts/Sheet views. |
| Shop Drawing | No | This script is for the 3D model, not 2D manufacturing drawings. |

## Prerequisites
- **Entities**: You must have existing timber elements (Beams, Bodies, or Elements) in the model to package.
- **Property Sets**: A Property Set Definition named "Stacking" must exist in your project to store data on the individual elements.
- **Settings File**: An XML configuration file (usually `f_Package.xml`) must be present in your hsbCAD configuration path to define wrapping materials and default visual settings.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or `TSL`) → Select `f_Package.mcr` from the file list.

### Step 2: Select Elements
```
Command Line: Select entities:
Action: Click on the timber beams, walls, or bodies you want to include in the package. Press Enter to confirm selection.
```

### Step 3: Specify Insertion Point
```
Command Line: Specify insertion point:
Action: Click in the Model Space to place the package script (usually near the grouped items). This point acts as the anchor for the package label.
```

### Step 4: Configure Properties
Action: Once inserted, select the new Package object and open the **Properties Palette** (Ctrl+1). Adjust the Package Number, Wrapping type, or Label Format as needed.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Number | Integer | 1 | The unique ID for this package (e.g., Palette 1). Updates the "Package Number" property on all contained items. |
| Format | String | @(Name) | Determines the text displayed on the label. Use tokens like `@(Name)`, `@(Number)`, or `@(Weight)`. |
| TextHeight | Double | 100 mm | Sets the height of the text characters on the label for visibility. |
| Style | Integer | 0 | Visual style of the label background (0=None, 1=Frame, 2=Filled). |
| Grouping | String | Default | Defines a category for the package, used for filtering or reporting. |
| Wrap | String | None | Select the packaging material (e.g., Foil, Cardboard). Updates the "Package Wrapping" property on items. |
| MaxBedding | Double | 0 kg/m³ | Adds extra weight to the total calculation for packing materials (nails, straps, foil). |
| Color | Integer | 12 | The AutoCAD color index for the 3D bounding box visualizer. |
| TransparencyTruck | Integer | 60 | Sets the opacity of the bounding box (0=Invisible/Transparent, 90=Solid). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the bounding box geometry and total weight if the contained elements have been modified or moved. |
| Select Entities | Re-selects the beams and bodies currently assigned to this package for verification. |

## Settings Files
- **Filename**: `f_Package.xml` (or project-specific XML)
- **Location**: `hsbCompany` or `hsbInstall` directory.
- **Purpose**: Stores default values for the `GripDistanceOnInsert`, `ContourThickness` (visual thickness of wrapping), and the list of available Wrapping materials.

## Tips
- **Weight Accuracy**: The script first checks for an existing `f_Item` weight on individual elements. If not found, it calculates `Volume * Density`. Use `MaxBedding` to add a safety margin for packaging materials.
- **Visualization**: If the bounding box is obscuring your view of the timber, lower the `TransparencyTruck` value (e.g., set to 40 or 50).
- **Data Export**: Ensure your "Stacking" property set is mapped correctly if you intend to export the package data to production lists (e.g., CSV/Presto).

## FAQ
- **Q: Why is my label text empty?**
  **A**: Check the `Format` property. Ensure you have included valid tokens like `@(Name)` or `@(Weight)` inside the string.
- **Q: Why is the calculated weight zero?**
  **A**: Verify that the timber elements inside the package have a Material assigned with a valid Density defined in the catalog.
- **Q: Can I add more items to an existing package?**
  **A**: Currently, you usually need to delete the script and re-run it, or manually edit the script's entity list (if permissions allow), but the standard workflow is to re-select all items.