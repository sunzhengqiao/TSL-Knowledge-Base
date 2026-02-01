# GE_ElementDims.mcr

## Overview
Automatically generates elevation dimensions for timber elements within a specific zone in Paper Space. It allows users to create organized, per-zone dimension sets for wall panels or floor layouts in 2D drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed exclusively for detailing in Layouts. |
| Paper Space | Yes | Must be inserted in an active hsbCAD Layout viewport. |
| Shop Drawing | N/A | Used for manual detailing in Layouts, not automatic shop drawing generation. |

## Prerequisites
- **Required Entities**: An active hsbCAD enabled viewport in a Layout tab.
- **Minimum Beam Count**: 0 (Dimensions existing visible elements).
- **Required Settings**: Elements must have valid Zone assignments if `Zone to Dimension` is set to a non-zero value.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_ElementDims.mcr`
*Note: Ensure you are in a Layout tab and double-click inside the viewport to make it active before running the script.*

### Step 2: Configure Properties
Since there are no command line prompts, the script inserts immediately. Open the **Properties Palette (Ctrl+1)** to configure the dimension settings.

1.  Select the script entity in the drawing.
2.  In the Properties Palette, set the **Zone to Dimension**.
3.  Adjust the **Dimstyle** and **Dimension Format** as required.
4.  The script will automatically update and draw dimensions based on these settings.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone to Dimension | Integer | 0 | Filters which elements are dimensioned. Set `0` for all zones (if allowed) or specific integers (e.g., 1, 2, -1) to target specific wall/floor assemblies. |
| Dimstyle | Dropdown | _DimStyles | Selects the AutoCAD dimension style to control text font, arrows, and general appearance. |
| Dimension Format | Dropdown | Decimal mm | Selects the unit display format. Options: **Decimal mm**, **Fractional Ft-In**, **Inches Fractional**. |
| Text Height Override | Number | 0 | Manually sets the dimension text height. Enter `0` to use the height defined in the selected Dimstyle. |
| Text Height Padding | Number | 1 | Adjusts the spacing/margin around the dimension text. |
| Line Color | Integer | 7 | Sets the AutoCAD color index (ACI) for dimension lines and extension lines. |
| Text Color | Integer | 4 | Sets the color for the dimension text. |
| Dimension Value Precision | Integer | 1 | Sets the number of decimal places (for mm) or precision level for fractional units. |
| Dimension Point Resolution | Number | 1 | Controls the snapping/tolerance for dimension points. Increase this value if dimensions are overlapping or cluttering. |
| Limit Extension Lines | Dropdown | No | **Yes**: Shortens extension lines to a fixed offset. **No**: Extension lines extend dynamically until they hit other geometry (Ordinate style). |
| Extension Line Offset | Number | [Value] | The gap between the geometry and the start of the extension line. |

*Note: Additional directional properties (Up, Down, Left, Right) for offsets and specific dimension types may appear depending on script configuration.*

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Refreshes the dimensions based on changes to the model or properties. |

## Settings Files
None specific to this script. It relies on standard AutoCAD Dimstyles available in the current drawing.

## Tips
- **Cluttered Dimensions?**: If multiple dimension texts overlap, increase the **Dimension Point Resolution** value. This forces the script to cluster points further apart.
- **Viewport Context**: This script calculates dimensions based on the *current view* of the active viewport. If you change the view direction (e.g., from Front to Side), the dimensions will update accordingly.
- **Dynamic Extensions**: Use **Limit Extension Lines** set to "No" for cleaner drawings where dimension lines should stop exactly at intersecting timber elements, rather than floating in space.

## FAQ
- **Q: I inserted the script, but nothing happened.**
  - A: Ensure you are inside an active hsbCAD viewport in a Layout tab. The script does not work in Model Space.
- **Q: How do I switch between Metric (mm) and Imperial (Ft-In)?**
  - A: Change the **Dimension Format** property in the Properties Palette to "Fractional Ft-In" or "Inches Fractional".
- **Q: The dimensions are showing the wrong length.**
  - A: Check the **Dimension Value Precision** and ensure the **Dimstyle** selected matches your drawing units (e.g., metric dimstyle for metric drawings).
- **Q: My console reports "iSafe exceeded 1,000".**
  - A: This means the overlap resolution loop got stuck trying to fit too many dimensions in one spot. Increase the **Dimension Point Resolution** to simplify the geometry or reduce the number of elements being dimensioned.