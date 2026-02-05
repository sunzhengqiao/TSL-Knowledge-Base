# HSB_G-SheetToBeam.mcr

## Overview
Converts Sheet entities into structural Beam entities, automatically calculating the best-fitting rectangular bounding box for the new beam geometry. This tool is ideal for converting preliminary design "skins" into structural timber elements for detailing and production.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates in 3D model space only. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not intended for 2D production drawings. |

## Prerequisites
- **Required Entities**: `Sheet` or `Element` entities must exist in the model.
- **Required Settings**: The catalog file `HSB_G-FilterGenBeams` must be present to populate the filter options.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse and select `HSB_G-SheetToBeam.mcr`.

### Step 2: Select Elements or Sheets
```
Command Line: Select one or more elements <Right click to select sheets>
Action: 
- Click on an Element (e.g., a Wall or Roof) to process all Sheets inside it.
- OR Right-click (or Enter) to switch to manual selection.
```

### Step 3: Select Sheets (If applicable)
```
Command Line: Select sheets
Action: Click on individual Sheet entities to convert them. Press Enter to finish selection.
```

### Step 4: Configure Properties
After selection, the Properties Palette (OPM) will appear.
1. **Filtering**: Use "Zone to convert" or "Filter definition" to limit which sheets are processed.
2. **Overrides**: Enter values for Name, Material, Grade, etc., if you want to force specific data on the new beams.
3. Close the Properties Palette to start the conversion.

### Step 5: Review
The script will delete the original Sheets and replace them with new Beam entities. The command line will report the number of converted entities.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Zone to convert** | dropdown | -- | Filters sheets based on a zone index (e.g., Floor 1, Floor 2). Note: This is ignored if a Filter definition is set. |
| **Filter definition for GenBeams** | dropdown | *Dynamic* | Advanced filter based on the `HSB_G-FilterGenBeams` catalog. If set, this overrides the simple Zone filter. |
| **Name** | text | *Empty* | Overrides the Name of the new Beam. Leave empty to inherit the Name from the original Sheet. |
| **hsbCAD Material** | text | *Empty* | Sets the material for the new Beam. Leave empty to inherit from the Sheet. |
| **Grade** | text | *Empty* | Sets the timber grade (e.g., C24). Leave empty to inherit from the Sheet. |
| **Information** | text | *Empty* | Adds custom information text to the new Beam. |
| **Label** | text | *Empty* | Overrides the main part number/Label. Leave empty to inherit. |
| **Sublabel** | text | *Empty* | Overrides the Sublabel. Leave empty to inherit. |
| **Sublabel 2** | text | *Empty* | Overrides the second Sublabel. Leave empty to inherit. |
| **Beam code** | text | *Empty* | Sets the production/machining code for the new Beam. Leave empty to inherit. |
| **Color** | number | -1 | Sets the AutoCAD color index (ACI) for the new Beam. Use -1 to keep the layer color. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific options to the entity right-click menu during normal editing. |

## Settings Files
- **Filename**: `HSB_G-FilterGenBeams`
- **Location**: hsbCAD Company or Install directory (Catalogs).
- **Purpose**: Provides the list of available filter options for the "Filter definition for GenBeams" property, allowing you to filter sheets by size, name, or other criteria.

## Tips
- **Inheritance**: If you want the new beams to look and act exactly like the sheets they replace, leave all "Override properties" fields empty.
- **Geometry Handling**: The script calculates a "best fit" rectangular box. If your source sheets are complex polygons (e.g., L-shapes or T-shapes), they will be converted into a rectangular solid timber that encompasses the original shape.
- **Alignment**: New beams are automatically aligned to the Element's coordinate system to ensure they run in the correct direction relative to the wall or roof.
- **Filtering**: Use the "Filter definition" instead of "Zone" if you need to convert only specific sheets (e.g., only "Cladding" sheets) within a selected Element.

## FAQ
- **Q: What happens to the original Sheet entities?**
  **A:** The original Sheets are deleted from the model and replaced by the new Beams. Ensure you have a backup if you need to retain the Sheet geometry.
- **Q: Why did my beam appear in the wrong direction?**
  **A:** The script aligns the beam based on the Element's local coordinate system. Check the orientation of the parent Element if the beam direction is unexpected.
- **Q: Can I use this to convert curved walls?**
  **A:** This script creates rectangular Beams (linear). It is best suited for straight elements. Curved sheets will likely result in a bounding box that approximates the curve's start and end points, effectively straightening the element.