# HSB-ElementDefinition.mcr

## Overview
This script automatically generates a label in Paper Space displaying the build-up definition (zones/layers) of a construction element (Wall, Floor, or Roof). It reads the configuration from an external XML catalog based on the Element Type and Subtype visible in a selected Viewport.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is intended for annotations on layouts. |
| Paper Space | Yes | The script must be inserted on a Layout tab. |
| Shop Drawing | No | Operates on Layouts/Viewports, not the shop drawing module directly. |

## Prerequisites
- **Entities**: A Layout (Paper Space) containing a Viewport that displays a structural Element (Wall, Floor, or Roof).
- **Settings**: A valid XML catalog file (default: `HSB-ElementDefinitionCatalog.xml`) must exist in the company folder (`hsbCompany\Abbund`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB-ElementDefinition.mcr` from the list.

### Step 2: Select Location
```
Command Line: Select a position
Action: Click anywhere in the Paper Space (Layout) where you want the top-left corner of the label to appear.
```

### Step 3: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport border (or inside the viewport) that displays the element you wish to label.
```

### Step 4: Configure (If applicable)
If not run from a catalog preset, the Properties window will appear automatically. You can adjust the header, visibility options, and style here.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension style | dropdown | _DimStyles | Select the text style to control font and height for the label. |
| Header | text | TITLE | The main title text displayed at the top of the label. |
| Draw entry name | dropdown | Yes | If 'Yes', displays the specific ID/Name of the catalog entry used. |
| Extra description | text | (Empty) | Optional additional text line to appear below the header. |
| Color header | number | 1 | Color index (0-255) for the Header and Extra Description lines. |
| Color content | number | 7 | Color index (0-255) for the Zone/Content description lines. |
| Catalog name | text | HSB-ElementDefinitionCatalog | The filename of the XML catalog to load (without extension). |
| Catalog | text | (Empty) | *Visual separator for the properties palette.* |
| Style | text | (Empty) | *Visual separator for the properties palette.* |
| Definition | text | (Empty) | *Visual separator for the properties palette.* |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | This script uses standard AutoCAD/TSL grips and properties. No custom context menu items are defined. |

## Settings Files
- **Filename**: `[Catalog Name].xml` (Default: `HSB-ElementDefinitionCatalog.xml`)
- **Location**: 
  - Primary: `_kPathHsbCompany\Abbund\`
  - Legacy (Fallback): `_kPathHsbCompany\Content\Dutch\Element\`
- **Purpose**: This XML file contains the database of element definitions. It maps Element Types and Subtypes (e.g., "Ext-240") to text descriptions for Zones 0-10.

## Tips
- **Moving the Label**: Click the label to select it. Use the blue square grip point at the insertion point to drag the entire label to a new location.
- **Updating Content**: If you change the Element Type or Subtype in the model (e.g., change a wall thickness), the script will automatically detect the change and update the label text to match the new XML entry.
- **Missing Definitions**: If the label displays "Definition [Key] not found!", check your XML catalog to ensure the Element Code of the selected viewport exists in the file.

## FAQ
- **Q: Why did the script show a warning about an old file path?**
  - **A:** The script found the required XML file in the legacy folder (`Content\Dutch\Element`) instead of the new standard folder (`Abbund`). It will still work, but you should move the XML file to the new folder to prevent future warnings.
- **Q: Can I change the text size?**
  - **A:** Yes. Select the label and change the **Dimension style** property in the Properties Palette. The text size is derived from the selected dimension style settings.
- **Q: What happens if I delete the viewport?**
  - **A:** The script will detect that the linked viewport is missing and will automatically delete itself to prevent errors.