# hsb_DrawPosNum&DimSpaceStud.mcr

## Overview
This script automates the annotation of shop drawings in Paper Space by placing Position Numbers, drawing outlines for Nail Plates, and generating dimension lines for width and height. It reads geometry from a selected Shop Drawing view containing Space Stud assemblies.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for production drawings. |
| Paper Space | Yes | Must be used on a layout containing a ShopDrawView. |
| Shop Drawing | Yes | Requires a valid ShopDrawView entity to function. |

## Prerequisites
- **Required Entities**: A valid **ShopDrawView** entity in Paper Space.
- **Assembly Content**: The selected view must contain at least one of the following assembly types:
  - `hsb_SpaceStudAssembly`
  - `GC-SpaceStudAssembly`
  - `Lowfield-SpaceStudAssembly`
- **Minimum Beam Count**: None.
- **Required Settings**: None (Uses standard CAD dimension styles).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_DrawPosNum&DimSpaceStud.mcr`

### Step 2: Pick Text Location
```
Command Line: Pick a point
Action: Click in the Paper Space layout where you want the Position Number text to appear.
```

### Step 3: Select Shop Drawing View
```
Command Line: |Select the view entity from which the information is taken|
Action: Click on the border (frame) of the Shop Drawing View that contains the Space Stud assembly you wish to annotate.
```

### Step 4: Automatic Generation
The script will automatically calculate the bounding box of the assembly, detect any nail plates, and draw the dimensions and text in Paper Space.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dim Style PosNom | dropdown | (Current) | Selects the Dimension Style to use for the Position Number text formatting. |
| Text Height | number | U(40) | Sets the height of the Position Number text. |
| Dim Style Dimensions | dropdown | (Current) | Selects the Dimension Style to use for the measurement lines (width/height). |
| Offset dim Lines | number | U(100) | Sets the distance between the wall geometry and the dimension lines. |
| Color | number | 3 | Sets the color index for the text and nail plate outlines. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are defined for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Moving Text**: If the Position Number lands in a bad spot, simply select the script instance and use the grip point to drag the text to a new location.
- **View Updates**: If you modify the 3D model (e.g., change wall height or width), refresh your Shop Drawing View. The script will automatically update the dimensions and nail plate positions upon the next regeneration.
- **Layer Management**: The created entities (text and dimensions) will inherit the color property defined in the script, but layer control depends on your current CAD standards.

## FAQ
- **Q: I inserted the script, but no dimensions or text appeared.**
  **A:** Ensure that the Shop Drawing View you selected actually contains one of the supported Space Stud assemblies. If the view is empty or contains standard beams only, the script has nothing to dimension.
- **Q: Can I use this on regular walls or roofs?**
  **A:** No, this script is specifically designed to detect `hsb_SpaceStudAssembly`, `GC-SpaceStudAssembly`, or `Lowfield-SpaceStudAssembly` entities. It will ignore other element types.
- **Q: How do I change the arrow style of the dimensions?**
  **A:** You cannot change the arrow style directly inside this script's properties. Instead, change the "Dim Style Dimensions" property to point to a different Dimension Style in your drawing template that has your preferred arrow settings.