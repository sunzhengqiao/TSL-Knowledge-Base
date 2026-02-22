# hsbLayoutDim

## Overview

| Property | Value |
|----------|-------|
| **Script Name** | hsbLayoutDim |
| **Type** | Object (O) |
| **Version** | 2.4 |
| **Category** | Shop Drawing / Dimensioning |
| **Purpose** | Creates dimension lines in Paper Space (Layout) for hsbCAD elements |
| **Author** | th@hsbCAD.de, Marsel Nakuci |
| **Last Updated** | 11/08/2025 |

## Usage Environment

| Environment | Supported |
|-------------|-----------|
| **Model Space** | No (reads geometry only) |
| **Paper Space** | Yes |
| **Shop Drawing** | Yes |
| **Required Entities** | Viewport with hsbCAD Element |

## Description

**hsbLayoutDim** is a comprehensive dimensioning tool for Paper Space layouts. It automatically generates dimension lines for various hsbCAD entities displayed through viewports. The script supports multiple dimensioning modes, filtering options, and display configurations, making it essential for creating fabrication drawings.

The script intelligently ensures dimension lines are placed outside the viewport boundary to maintain drawing readability (HSB-24401).

## Usage Workflow

1. **Insert the Script**
   - In Paper Space, run the hsbLayoutDim command
   - Click to set an insertion point
   - Select a viewport containing an hsbCAD element

2. **Configure Dimension Settings**
   - Select the objects to dimension (Beams, Sheets, TSL instances, etc.)
   - Choose the zone for dimensioning
   - Set alignment (Horizontal, Vertical, or Both)
   - Configure dimension style and display options

3. **Adjust Parameters**
   - Use the Properties Palette (OPM) to fine-tune settings
   - Set filter ranges to limit dimensioned areas
   - Configure color and code filters if needed

4. **Grip Point Adjustment**
   - Drag grip points to reposition dimension lines
   - Dimensions automatically update when element geometry changes

## Properties Panel Parameters

### General Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Objects to dim** | String | Beams | Select what to dimension: Beams, Sheets/Sips, TSL, Logs, Openings, Beam Packs, Rooms, or Bearing Points |
| **Reference Objects** | String | Element | Reference point source: Element outline or Zone (-5 to +5) |
| **Zone** | Integer | 0 | Zone index for dimensioning (-5 to +5) |
| **TSL Name** | String | - | Name(s) of TSL scripts to dimension (semicolon-separated) |
| **Show size of openings** | String | None | Opening annotation options: None, Size, Elevations, Offsets, or combinations |
| **Show connecting elements** | String | No | Display dimensions for connected wall elements |

### Dimension Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Show Offsets** | String | None | Display zone offsets relative to frame or element outline |
| **Alignment** | String | Horizontal | Dimension direction: Horizontal, Vertical, or Both |
| **Delta Dimensioning** | String | Parallel | Individual dimension display: Parallel, Perpendicular, or None |
| **Chain Dimensioning** | String | Parallel | Running dimension display: Parallel, Perpendicular, or None |
| **Swap Side of Delta and Chain** | String | No | Reposition delta/chain dimensions (Horizontal, Vertical, Both) |
| **Extremes Dimensioning** | String | None | Overall dimension display mode |
| **Swap Side of Extremes** | String | No | Reposition extreme dimensions |

### Sorting Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Collect dimpoints** | String | Left | Point collection method: Left, Right, Left & Right, Center, or All |
| **order X-direction** | String | left to right | Sorting order for horizontal dimensions |
| **order Y-direction** | String | bottom to top | Sorting order for vertical dimensions |

### Range Filter Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **X-Start** | Double | 0 | Start of X filter range (viewport direction, negative = opposite side) |
| **X-End** | Double | 0 | End of X filter range |
| **Y-Start** | Double | 0 | Start of Y filter range |
| **Y-End** | Double | 0 | End of Y filter range |

### Exclude Property Filter

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Beam type** | String | - | Beam types to exclude (semicolon-separated) |
| **Color** | String | - | Colors to exclude from dimensioning |
| **Beamcode** | String | - | Beam codes to exclude |

### Include Property Filter

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Beam Type** | String | - | Only dimension these beam types (semicolon-separated) |
| **Color** | String | - | Only dimension entities with these colors |
| **Beamcode** | String | - | Only dimension entities with these beam codes |
| **Label** | String | - | Only dimension entities with this label |

### Display Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Dimstyle** | String | - | AutoCAD dimension style to use |
| **Autoscale Dimlines** | String | Yes | Automatically scale dimensions based on viewport scale |
| **Autoscale Factor** | Double | 1 | Additional scale factor for autoscaling |
| **Description Alias** | String | - | Custom label for dimension description |
| **Color** | Integer | 171 | Color index for dimension lines |

## Dimension Object Types

### 1. Beams
- Dimensions timber members (studs, joists, rafters, etc.)
- Supports Left, Right, Center, or combined dimensioning
- Can filter by beam type, color, or code

### 2. Sheets or Sips
- Dimensions sheathing panels and SIPs
- Supports zone-based selection
- Can include/exclude by label

### 3. TSL (Tool Scripts)
- Dimensions custom TSL instances attached to the element
- TSL scripts must publish dimension points via Map keys:
  - `pLayoutDimU`, `pLayoutDimO` (Upper/Outer)
  - `pLayoutDimM` (Middle)
  - `pLayoutDimL`, `pLayoutDimR` (Left/Right)
  - `ptExtraDim0`, `ptExtraDim1`, etc.

### 4. Logs
- Dimensions log building elements
- Detects and centers standard notches
- Optional opening size display

### 5. Openings
- Dimensions window/door openings
- Can show size, sill/head heights, and edge offsets

### 6. Beam Packs
- Groups beams into packs for simplified dimensioning
- Exclude specific beam types from packs

### 7. Rooms
- For walls: dimensions connected wall elements
- For floors/roofs: dimensions underlying wall elements
- Useful for room dimension plans

### 8. Bearing Points
- For floor elements: identifies load-bearing points
- Detects perpendicular beams/steel profiles intersecting the floor

## Context Menu Options

| Option | Description |
|--------|-------------|
| **Add/Ignore points outside viewport** | Toggle whether dimension points outside the viewport boundary are included. When ignored, dimensions remain within the visible viewport area. |

## Tips and Best Practices

### General Usage
1. **Viewport Selection**: Always ensure the viewport contains a valid hsbCAD element before inserting the script
2. **Zone Selection**: Use the appropriate zone index to dimension the correct element layer (Zone 0 = frame, Zones 1-5 = sheeting zones)
3. **Dimension Style**: Select a dimension style that matches your drawing standards before inserting

### Filtering
1. **Color Filtering**: Use consistent entity colors in your model for easy filtering
2. **Multiple Entries**: Separate multiple filter values with semicolons (e.g., "1;2;3")
3. **Include vs Exclude**: Include filters take priority over exclude filters

### Range Filters
1. **Negative Values**: Use negative start values to reference from the opposite element edge
2. **Zero Start**: When start = 0, the range automatically extends to capture edge points
3. **Debug Mode**: Enable debug mode to visualize range filter bodies

### Performance
1. **Large Elements**: For complex elements, use range filters to limit dimensioned areas
2. **Autoscaling**: Keep autoscaling enabled for automatic unit conversion based on viewport scale
3. **Layer Assignment**: Dimensions are automatically assigned to Layer 0 for consistent visibility

### Troubleshooting
1. **Missing Dimensions**: Check if points fall outside the viewport or range filter
2. **Wrong Reference**: Verify the Reference Objects setting matches your intended reference
3. **Debug Mode**: Use `_bOnDbCreated` debug flag to visualize reference points and margin bodies

## FAQ

**Q: Why are no dimensions appearing when I insert the script?**
- A: Ensure the **Zone** you selected actually contains material in your model. If you select Zone 1 but only have a structural frame (Zone 0), nothing will be drawn.

**Q: My dimension text is tiny compared to the viewport.**
- A: Check the **Autoscale Dimlines** property. If it is set to No, the script uses a fixed scale factor that may not match your current zoom level. Set it to Yes.

**Q: Can I dimension specific colored beams only?**
- A: Yes. Use the **Include Property Filter > Color** property to list colors you want to dimension, or use **Exclude Property Filter > Color** to ignore specific entities.

**Q: How do I dimension TSL instances?**
- A: Set **Objects to dim** to "TSL" and enter the script name in **TSL Name**. The TSL must publish dimension points in its Map using keys like `pLayoutDimL`, `pLayoutDimR`, or `ptExtraDim0`.

## Dependencies

- Requires hsbCAD 2009 or later
- Viewport must contain a valid hsbCAD Element
- Element must have the appropriate entities in the selected zone

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.4 | 11/08/2025 | HSB-24401: Ensures dimension lines are outside viewport boundary |
| 2.3 | 02/12/2019 | HSB-5981: Improved dimpoint collection; HSBCAD-568: Reference points bugfix |
| 2.2 | 28/02/2019 | Reference points bugfix |
| 2.1 | 26/07/2018 | Beam dimension mode 'all' displays extreme dimensions |
| 2.0 | 09/02/2018 | Bugfix for aligned beams with end tools |
| 1.80 | 20/09/2016 | Beam collection by beamtype corrected |
| 1.79 | 24/06/2016 | Dimension mode 'all' on SIPs and sheets fixed |
| 1.77 | 23/10/2015 | Margin bodies completely revised |
| 1.76 | 25/03/2015 | Properties categorized in OPM |
| 1.75 | 20/03/2015 | Support for multiple TSL names |

## Related Scripts

- **hsbViewDimension** - Model space dimensioning
- **hsbTslDim** - TSL-based dimensioning
- **hsbViewTag** - Element tagging in viewports
- **GE_PLOT_A4_LAYOUT** - Layout setup for A4 plots
