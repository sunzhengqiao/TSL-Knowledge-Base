# GE_PLOT_A4_LAYOUT

Creates comprehensive dimensions and annotations in wall elevation layouts for shop drawings, including stud positions, sheeting, openings, blocking, and wall information such as nailing offsets, frame weight, and wall description.

## Overview

| Property | Value |
|----------|-------|
| **Script Type** | O-Type (Object) |
| **Version** | 1.61 |
| **Author** | David Rueda (dr@hsb-cad.com) |
| **Last Updated** | October 11, 2013 |
| **Beams Required** | 0 |

## Usage Environment

| Environment | Supported |
|-------------|-----------|
| Paper Space (Viewport) | Yes |
| Shop Drawing (Multipage) | Yes |
| Model Space | No |

This script is designed for wall elevation views in both traditional Paper Space viewports and Shop Drawing multipage environments. It automatically detects and configures itself based on the selected environment.

## Prerequisites

Before using this script, ensure that:

1. **Wall Element Exists**: A valid stick-frame wall element (ElementWallSF) must be present
2. **Viewport or Shop Draw View**: Either a Paper Space viewport or a Shop Drawing view must be available showing the wall elevation
3. **Dimension Styles**: Required dimension styles must be defined in the drawing
4. **Nailing Information** (optional): For nailing display, the "hsb_Apply Naillines to Elements" TSL should be attached to the wall element

## Step-by-Step Usage Guide

### Inserting the Script

1. Start the TSL insertion command in hsbCAD
2. Select "GE_PLOT_A4_LAYOUT.mcr" from the script library
3. A dialog will appear for initial configuration
4. Click in the drawing to **pick the reference point** for the bottom horizontal dimension
5. Select the target:
   - For **Paper Space**: Select the viewport containing the wall elevation
   - For **Shop Drawing**: Select the ShopDrawView entity containing the wall module

### Typical Workflow

1. **Generate Wall Elevation View**: First create a viewport or shop drawing view showing your wall element in elevation
2. **Insert the Script**: Place the script and select the reference point at the bottom of where you want dimensions
3. **Configure Properties**: Use the Properties Panel (OPM) to adjust dimension settings
4. **Review Output**: Check the generated dimensions, annotations, and information text
5. **Adjust as Needed**: Modify properties to show/hide specific dimension types or adjust offsets

## Properties Panel Parameters

### Drawing Space Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Drawing space | Selection | paper space | Choose between "paper space" or "shopdraw multipage" |
| Dim Style | Selection | (drawing styles) | Main dimension style for most annotations |
| Dim Style Studs Only | Selection | (drawing styles) | Dimension style specifically for stud-related text |
| Color | Integer | 1 | Color index for dimension lines and text |

### Left-Side Dimension List

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show Left Dimension List | Selection | None | Display position list: "Start", "End", "Center", or "None" |
| List Spacing | Length | 5mm (0.2") | Vertical spacing between list items |
| X Offset for List | Length | 300mm (12") | Horizontal offset from element for the list |
| Y Offset for List | Length | 0 | Vertical offset adjustment for the list |
| Number of Items per column | Integer | 20 | Maximum items before starting a new column |

### Bottom Dimension Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show Bottom Dimension | Selection | Start | Position reference: "Start", "End", "Center", or "None" |
| Show Element Dimension | Yes/No | Yes | Show the overall element length dimension |
| Show as | Selection | Line and Text | Display mode: "Line and Text" or "Dimension Line" |
| Running Dimension Orientation | Selection | Parallel | "Parallel" or "Perpendicular" dimension lines |
| Offset Bottom Dimension/Text From PickPoint | Length | 0 | Vertical offset for bottom dimensions |
| Offset Running Dimension | Length | 100mm (6") | Offset for running dimension lines |
| Length Running Dimension Lines | Length | 250mm (6") | Length of the extension lines |

### Stud Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Include Beam With BeamCode | String | (empty) | Beam codes to include (semicolon-separated) |
| Exclude Beam With BeamCode | String | (empty) | Beam codes to exclude (semicolon-separated) |
| Exclude Rotated Studs | Yes/No | No | Hide studs that are rotated (flat) |
| Show Stud References | Yes/No | Yes | Display reference letters (S, J, JB, JF, C) under studs |
| Offset Stud References | Length | 60mm (6") | Distance below element for stud reference text |

### Opening Dimension Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Vertical Opening Dimension | Selection | Center of Opening | Position: "Right Side", "Center of Opening", "Left Side", or "None" |
| Horizontal Opening Dimension | Selection | Below Element | Position: "Center of Opening", "Below Element", "Both", or "None" |
| Show Cummulative Opening Dimension | Yes/No | No | Add cumulative dimension line |
| Show Delta Opening Dimension | Yes/No | No | Add delta (incremental) dimension line |
| Offset for cummulative opening dimension | Length | 0 | Offset between delta and cumulative lines |
| Offset Horizontal Opening Dim | Length | 0 | Offset when dimension is at center of opening |
| Show Window/Door Description | Selection | None | Source: "None", "hsbCAD", "AutoCAD", or "Property Set" |
| Property set name | String | (empty) | Name of property set for opening descriptions |
| Show Window/Door size | Yes/No | Yes | Display W: and H: dimensions in opening |
| Show Window Head/Sill Heights | Selection | Head Height | Show: "None", "Head Height", "Sill Height", or "Both" |

### Header Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show Header Description | Selection | From Beam Size | Source: "From Details", "From Beam Name", "From Beam Size", or "No" |
| Offset Header Description | Length | 50mm (2") | Offset for header description text |
| Dimensions Include Headbinder | Yes/No | No | Include headbinder in dimension calculations |

### Blocking Dimension Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show Blocking Dim | Yes/No | Yes | Show vertical blocking dimensions |
| Dimension blocking to | Selection | Top | Reference point: "Bottom", "Center", or "Top" of blocking |
| Blocking Dimline alignment | Selection | Right | Position: "Left" or "Right" side of element |
| Blocking Dim Offset From Element (left side only) | Length | 100mm (4") | Offset when blocking dimension is on left |
| Show Blocking Length | Yes/No | No | Display blocking piece lengths |
| Show Vertical Dim Names | Yes/No | No | Label vertical dimension lines ("Blocking", "Opening", "Wall height") |

### Angle Stud Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show Angle Stud Dim | Selection | Dimension | Display: "None", "Dimension", or "Text" |
| Dimension From | Selection | Long Side | Reference: "Long Side" or "Short Side" |
| Offset Stud Dim Line | Length | 25mm (2") | Offset for angled stud dimensions |
| Dim Angle Top Plate | Yes/No | No | Show dimensions for angled top plates |
| Show Angular Dimensions | Yes/No | No | Display angular dimensions on non-orthogonal edges |

### Sheet/Cladding Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show Diagonal for Sheets | Yes/No | No | Show diagonal lines on sheet outlines |
| Sheet Color Diagonal | Integer | 5 | Color for sheet diagonal lines |
| Show Sheet Outline | Yes/No | No | Display sheet boundary outlines |
| Sheet Color Outline | Integer | 5 | Color for sheet outlines |
| Sheet Zone | Selection | All | Filter sheets by zone: "All" or zones 1-10 |
| Filter sheets by material | String | (empty) | Material filter for sheets (semicolon-separated) |

### Panel Diagonal

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show Panel Diagonal Dimension | Selection | No | Display: "Yes", "No", or "As Text on Top" |

### Flat Stud Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Hatch Flat Studs | Yes/No | No | Apply hatch pattern to flat (junction) studs |
| Hatch pattern | Selection | (patterns) | AutoCAD hatch pattern name |
| Show Flat Studs Description | Yes/No | No | Add "FS to front/rear" descriptions |

### Jack Studs

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show Jacks Length | Yes/No | Yes | Display jack stud lengths beside the beam |

### Wall Information

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show Wall Information | Yes/No | Yes | Display wall definition and beam size |
| Show Frame Weight | Yes/No | Yes | Calculate and display frame weight |
| Timber density (kg/m3) | Number | 450 | Timber density for weight calculation |

### Nailing Information

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show Nailing Information | Yes/No | No | Display cladding nailing schedule |
| Show Nailing Type | Yes/No | No | Include nail type in nailing information |

### Offset Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Offset From Element | Length | 150mm (8") | General offset for dimensions from element edge |
| Offset Between Text Lines | Length | 150mm (8") | Spacing between multiple dimension lines |
| Offset Top Text From PickPoint in VP Units | Length | 150mm (6") | Offset for top-positioned text |

## Stud Reference Letters

The script displays reference letters under each stud to identify stud types:

| Letter | Meaning |
|--------|---------|
| S | Standard Stud |
| J | Jack Stud (under/over openings) |
| C | Cripple Stud |
| JB | Junction stud to back (flat stud) |
| JF | Junction stud to front (flat stud) |

## Right-Click Menu Options

This script does not implement custom context menu items. All configuration is done through the Properties Panel (OPM).

## Settings Files

This script does not use external XML settings files. All configuration is stored in the TSL instance properties.

## Tips and Best Practices

1. **Pick Point Placement**: Place the insertion point at the bottom-left corner of where you want your dimension baseline. All horizontal running dimensions reference this point.

2. **Dimension Style Setup**: Create appropriate dimension styles before using this script. The script applies the selected dimension style's text height, arrow size, and other formatting.

3. **Filtering Beams**: Use the "Include/Exclude Beam With BeamCode" properties to control which beams appear in dimensions. Separate multiple codes with semicolons (e.g., "STUD;JACK;KING").

4. **Sheet Filtering**: To dimension only specific sheet types (e.g., only OSB), use the "Filter sheets by material" property with the exact material name.

5. **Multiple Openings**: When you have multiple openings at the same height, the script can consolidate vertical dimensions to reduce clutter. Choose "Left Side" for vertical opening dimensions to stack them on one side.

6. **Weight Calculation**: The frame weight is calculated using the total beam volume multiplied by the timber density. Adjust the density value if using different timber species.

7. **Reversed Panels**: The script automatically detects if the panel is mirrored in the viewport and adjusts dimension positions accordingly.

8. **Nailing Information**: For nailing information to display correctly, ensure the "hsb_Apply Naillines to Elements" TSL is attached to your wall element with proper nailing settings.

## Frequently Asked Questions

**Q: Why are some studs not showing in the bottom dimension?**
A: Check the "Exclude Rotated Studs" setting. If enabled, flat studs (studs rotated 90 degrees) will be excluded. Also verify the "Exclude Beam With BeamCode" property does not contain the beam code of the missing studs.

**Q: The dimensions appear in the wrong location. How do I fix this?**
A: The insertion point you pick determines the reference for bottom dimensions. Delete the instance, re-insert, and carefully pick the point at your desired baseline location.

**Q: Can I use this script for floor or roof panels?**
A: No, this script is specifically designed for stick-frame wall elements (ElementWallSF). For floors and roofs, use dedicated layout scripts for those element types.

**Q: How do I show cumulative dimensions instead of delta dimensions?**
A: Enable "Show Cummulative Opening Dimension" and optionally enable "Show Delta Opening Dimension" if you want both. Use the "Offset for cummulative opening dimension" to separate the two lines.

**Q: The header description is not showing correctly. What should I check?**
A: Ensure the "Show Header Description" is not set to "No". If using "From Details", verify that ElemText objects with code "WINDOW" and subcode "HEADER" exist in your wall element.

**Q: Why is the frame weight showing as 0?**
A: Verify that beams exist in the element and the "Timber density" value is set correctly. The calculation uses beam volume, so ensure beams have valid geometry.

**Q: Can I change the position of specific dimension lines?**
A: Yes, use the various offset properties to adjust positions. For vertical dimensions, you can switch between "Right Side", "Left Side", or "Center of Opening" placement.

## Version History

- **v1.61** (Oct 2013): Added "Show Element Dimension" property, jack length display with formatting
- **v1.60** (Oct 2013): Running dimensions now offset from insertion point instead of element origin, added "Show Delta Opening Dimension"
- **v1.59** (Apr 2013): Split opening dimension into delta and cumulative, added cumulative offset property
- **v1.58** (Mar 2013): Fixed opening dimension to show rough opening size, applied dimstyle to opening dimensions
- **v1.57** (Mar 2013): Added vertical dimension name labels, blocking dimension options (left/right, bottom/center/top)
- **v1.56** (Mar 2013): Version sync with hsb_A4 Layout
- **v1.0** (Mar 2013): Initial release, copied from hsb_A4 Layout for US content folder standards
