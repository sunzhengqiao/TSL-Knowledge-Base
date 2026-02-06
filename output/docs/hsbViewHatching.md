# hsbViewHatching.mcr

## Overview
Automates the application of 2D hatching patterns to timber sections and manufacturing views in both Model and Paper Space. It manages material representations, insulation patterns, and cross-section hatching based on mapping rules or specific user overrides.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Supports model sections and dynamic views. |
| Paper Space | Yes | Supports viewports within layouts. |
| Shop Drawing | Yes | Designed for production drawings and detailing. |

## Prerequisites
- **Required Entities**: GenBeam, Element, Wall, Maselement, Collection, or FastenerEntities.
- **Minimum Beam Count**: 0 (Can operate on single entities or groups).
- **Required Settings**:
  - `hsbViewHatching.xml` (Configuration file for mapping).
  - Hatch patterns must be loaded in the current AutoCAD drawing (e.g., ANSI31, SOLID).
  - Painter configuration (if using Painter-based mapping).

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line or open the hsbCAD TSL Browser.
2.  Select `hsbViewHatching.mcr` from the list.

### Step 2: Select Viewport or Entities
```
Command Line: Select Viewport / Entities:
Action: Click on a Viewport frame in Paper Space OR select timber elements (Beams/Walls) in Model Space.
```
*Note: The script detects the current space automatically. In Paper Space, it typically applies to the contents of the selected viewport. In Model Space, it applies to the selected geometry.*

### Step 3: Configuration
The script will automatically apply hatching based on the default properties or the XML mapping rules.
*   To modify the appearance, select the inserted TSL instance and open the **Properties Palette** (Ctrl+1).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **sPattern** | String | ANSI31 | The name of the hatch pattern (e.g., ANSI31, SOLID, INSULAT). Must match a loaded pattern in AutoCAD. |
| **dScale** | Double | 10.0 | The base scale factor for the hatch pattern. |
| **dScaleMin** | Double | 25.0 | The minimum allowed scale to prevent the pattern from becoming a solid blob. The calculated scale will never go below this value. |
| **bStatic** | Integer | 0 | **Scaling Mode**: 0 = Dynamic (Adjusts to viewport size), 1 = Static (Fixed scale). |
| **dAngle** | Double | 0.0 | Rotation angle of the hatch pattern in degrees. |
| **nColor** | Integer | 1 | **Hatch Color**: Enter 0-255 for ACI colors. Enter -2 to use the Entity's own color. |
| **nTransparency** | Integer | 0 | Transparency percentage (0 = Opaque, 100 = Fully Transparent). |
| **nSolidHatch** | Integer | 0 | **Background Fill**: 1 = Enable solid background fill, 0 = Pattern only. |
| **nSolidColor** | Integer | 0 | Color of the solid background fill (if enabled). 0 = ByBlock. |
| **nSolidTransparency** | Integer | 0 | Transparency percentage specifically for the solid background fill. |
| **bContour** | Integer | 0 | **Outline Border**: 1 = Draw a thick outline around the hatched area, 0 = No outline. |
| **dContourThickness** | Double | 0.0 | Width of the outline border (in mm). |
| **nColorContour** | Integer | 0 | Color of the outline border. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Modify hatch** | Re-opens the input dialog or focuses the Properties Palette to allow changing Pattern, Scale, and visual settings. |
| **Add hatch** | Allows you to apply the hatching script to additional entities or viewports using a selection jig. |
| **Delete hatch** | Removes the TSL instance and cleans up any generated hatching geometry. |
| **Import Settings** | Imports hatch configuration mappings from an external XML file. |
| **Export Settings** | Exports the current hatch configuration mappings to an XML file. |

## Settings Files
- **Filename**: `hsbViewHatching.xml`
- **Location**: hsbCAD Company or Installation directory.
- **Purpose**: Defines how "Painter" styles or Material names are mapped to specific hatch settings (Pattern, Angle, Color). This allows automatic hatching based on the timber material or wall style without manual input for every element.

## Tips
- **Dynamic Scaling**: Keep `bStatic` set to 0 (Dynamic) for production drawings. This ensures that if you zoom in or out of a viewport, or change the view scale, the hatching density remains visually consistent.
- **Entity Colors**: Setting `nColor` to -2 is a quick way to make the hatch color match the 3D element color, ensuring visual consistency between 3D views and 2D sections.
- **Solid Fills**: Use `nSolidHatch` with a background color and high transparency to create a "tinted" effect for elements like glass or specific insulation zones.
- **Performance**: On very large layouts, using solid hatches (`SOLID` pattern) is generally faster to render than complex patterns at very small scales.

## FAQ
- **Q: Why does my hatch look like a solid block even though I selected a pattern?**
  - **A**: Your `dScale` might be too small for the current view scale, or it is being clamped by `dScaleMin`. Try increasing the `dScale` value or adjusting `dScaleMin`.
- **Q: How do I apply different hatch patterns to different walls automatically?**
  - **A**: Use the **Painter** tool in hsbCAD to assign different styles to your walls, and configure the `hsbViewHatching.xml` file to map those Painter names to specific hatch patterns.
- **Q: Can I use this in a model space section view?**
  - **A**: Yes, the script supports multipage models and standard model space sections. It will detect the section plane and apply the hatch to the cut geometry.