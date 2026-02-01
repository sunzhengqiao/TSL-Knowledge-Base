# hsbLayoutDim

## Description

**hsbLayoutDim** is a Paper Space dimensioning tool that automatically generates dimension lines for timber construction elements within viewports. It analyzes the content displayed in a selected viewport and creates dimension chains based on the selected objects (beams, sheets, openings, TSL instances, etc.).

This script is essential for creating fabrication drawings and shop drawings where accurate dimensions of wall, floor, and roof elements are required.

## Script Information

|Property|Value|
|-|-|
|Script Type|O-Type (Object)|
|Version|2.4|
|Keywords|elements, dimensioning, layout|
|Location|Paper Space (attached to viewport)|

## Properties Reference

### Main Settings

|Property|Type|Default|Description|
|-|-|-|-|
|**Objects to dim**|Selection|Beams|Choose what to dimension: Beams, Sheets or Sips, TSL, Logs, Openings, Beam Packs, Rooms, or Bearing Points|
|**Reference Objects**|Selection|Zone 0|Define the reference for the dimension chain. Options: Element outline or Zone -5 to Zone 5|
|**Zone**|Integer|4|The zone index to collect dimension points from|
|**TSL Name**|String|(empty)|Name(s) of TSL scripts to dimension. Separate multiple entries with semicolon (;)|
|**Show size of openings**|Selection|None|Display opening information: None, Size, Elevations, Offsets, or combinations|
|**Show connecting elements**|Yes/No|No|Display connected elements in the dimension chain|

### Dimension Category

|Property|Type|Default|Description|
|-|-|-|-|
|**Show Offsets**|Selection|None|Show sheet/panel offsets relative to frame or element outline|
|**Alignment**|Selection|Horizontal + Vertical|Which dimension directions to display|
|**Delta Dimensioning**|Selection|Parallel|Display mode for individual segment dimensions|
|**Chain Dimensioning**|Selection|Parallel|Display mode for cumulative chain dimensions|
|**Swap Side of Delta and Chain**|Selection|No|Move delta/chain dimensions to opposite side|
|**Extremes Dimensioning**|Selection|None|Display mode for overall length dimensions|
|**Swap Side of Extremes**|Selection|No|Move extreme dimensions to opposite side|

### Sorting Category

|Property|Type|Default|Description|
|-|-|-|-|
|**Collect dimpoints**|Selection|Left|Which side(s) to collect dimension points: Left, Right, Left \& Right, Center, or All|
|**order X-direction**|Selection|left to right|Reading direction for horizontal dimensions|
|**order Y-direction**|Selection|bottom to top|Reading direction for vertical dimensions|

### Range Filter Category

|Property|Type|Default|Description|
|-|-|-|-|
|**X-Start**|Length|0|Start position of X filter range (negative values flip to opposite side)|
|**X-End**|Length|0|End position of X filter range|
|**Y-Start**|Length|0|Start position of Y filter range (negative values flip to opposite side)|
|**Y-End**|Length|0|End position of Y filter range|

### Exclude Property Filter Category

|Property|Type|Default|Description|
|-|-|-|-|
|**Beam type**|String|(empty)|Beam types to exclude from dimensioning (semicolon-separated)|
|**Color**|String|(empty)|Entity colors to exclude from dimensioning (semicolon-separated)|
|**Beamcode**|String|(empty)|Beam codes to exclude from dimensioning (semicolon-separated)|

### Include Property Filter Category

|Property|Type|Default|Description|
|-|-|-|-|
|**Beam Type**|String|(empty)|Only dimension these beam types (semicolon-separated)|
|**Color**|String|(empty)|Only dimension entities with these colors (semicolon-separated)|
|**Beamcode**|String|(empty)|Only dimension beams with these codes (semicolon-separated)|
|**Label**|String|(empty)|Only dimension entities with this label|

### Display Category

|Property|Type|Default|Description|
|-|-|-|-|
|**Dimstyle**|Selection|(drawing styles)|AutoCAD dimension style to use|
|**Autoscale Dimlines**|Yes/No|Yes|Automatically scale dimensions to viewport scale|
|**Autoscale Factor**|Number|1|Additional scale multiplier for dimension text|
|**Description Alias**|String|(empty)|Custom text to display instead of default description|
|**Color**|Integer|171|Color index for dimension lines (0-255)|

## Usage Workflow

### Inserting the Dimension Script

1. Switch to **Paper Space** (Layout tab)
2. Start the TSL insertion command
3. Select **hsbLayoutDim** from the script list
4. Click to place the insertion point (typically near the viewport edge)
5. Select the viewport containing the element to dimension
6. The properties dialog appears - configure your dimension settings
7. Click OK to create the dimension lines

### Configuring Dimensions

#### Step 1: Select Objects to Dimension

Choose what you want to dimension from the "Objects to dim" dropdown:

* **Beams**: Standard timber members in the selected zone
* **Sheets or Sips**: Paneling and structural insulated panels
* **TSL**: Custom TSL instances (requires TSL Name to be specified)
* **Logs**: Log construction members with notch detection
* **Openings**: Window and door openings
* **Beam Packs**: Grouped beam assemblies
* **Rooms**: Connected wall elements (for floor plans)
* **Bearing Points**: Load-bearing supports under floor elements

#### Step 2: Set Reference and Zone

* **Reference Objects**: Determines where the dimension chain starts (element outline or specific zone)
* **Zone**: Select which construction zone to dimension (typically Zone 0 for the main frame)

#### Step 3: Configure Display Options

* Choose **Alignment** (horizontal, vertical, or both)
* Set **Delta Dimensioning** for individual segment measurements
* Set **Chain Dimensioning** for running totals
* Enable **Extremes Dimensioning** to show overall lengths

#### Step 4: Apply Filters (Optional)

Use filters to focus on specific members:

* Include/Exclude by **Color** (useful for distinguishing member types)
* Include/Exclude by **Beam Type** (studs, plates, headers, etc.)
* Include/Exclude by **Beamcode**
* Apply **Range Filters** to dimension only part of an element

### Modifying Dimensions After Insertion

1. Select the hsbLayoutDim instance in Paper Space
2. Open the **Properties Palette** (Ctrl+1)
3. Adjust any property value
4. The dimension lines update automatically when the element is regenerated

## Context Commands

Right-click on the hsbLayoutDim instance to access context menu options:

|Command|Description|
|-|-|
|**Enable dimpoints outside viewport**|Include dimension points that extend beyond the viewport boundary|
|**Disable dimpoints outside viewport**|Exclude dimension points outside the viewport (useful for detail views)|

## Dimension Objects Explained

### Beams

Dimensions the edges of timber beams perpendicular to the dimension direction. Useful for showing stud spacing, plate positions, and header locations.

### Sheets or Sips

Dimensions paneling materials (OSB, plywood, gypsum) and structural insulated panels. Shows panel edges and joints.

### TSL

Dimensions custom TSL instances by name. The TSL must publish dimension points in its Map using the key format `ptExtraDim0`, `ptExtraDim1`, etc.

### Logs

Specifically for log construction. Automatically detects and dimensions standard notch types (saddle notch, dovetail, etc.) at their center points.

### Openings

Dimensions window and door openings. Can optionally display:

* Opening sizes (width x height)
* Elevations (sill and head heights)
* Offsets from reference edges

### Beam Packs

Groups beams into packages and dimensions the package boundaries rather than individual members. Useful for simplified drawings.

### Rooms

For wall elements: dimensions connected wall elements (room layout).
For floor elements: dimensions supporting wall elements below.

### Bearing Points

For floor elements: dimensions load-bearing points from supporting walls and perpendicular structural members.

## Tips and Best Practices

1. **Use Autoscale**: Keep "Autoscale Dimlines" enabled to ensure dimensions are readable at any viewport scale.
2. **Filter by Color**: Assign different colors to different member types, then use color filters to create separate dimension chains for studs, plates, and special members.
3. **Multiple Instances**: Insert multiple hsbLayoutDim instances on the same viewport to show different dimension types (e.g., one for beams, one for openings).
4. **Range Filters**: Use X-Start/X-End and Y-Start/Y-End to dimension only a portion of a large element, useful for detail views.
5. **Reference Zone**: For wall sections, use Zone 0 as reference for the main frame, but set the dimension Zone to match sheeting zones (-1 to -5 or 1 to 5) when dimensioning panels.
6. **Reading Direction**: Set "order X-direction" and "order Y-direction" to match your drawing conventions (typically left-to-right and bottom-to-top).

## Related Scripts

* **Dimline** - Model space dimensioning
* **ModelDimension** - Direct model dimension annotations
* **DimAngular** - Angular dimensions
* **DimRadial** - Radial dimensions for curved elements

## Version History

|Version|Date|Changes|
|-|-|-|
|2.4|2025-08-11|Ensure dimension is outside of viewport|
|2.3|2019-12-02|Improved dimension point collection; bugfix reference points|
|2.2|2019-02-28|Bugfix reference points|
|2.1|2018-07-26|Beam dimension mode 'all' displays extreme dimensions|
|2.0|2018-02-09|Bugfix aligned beams with end tools|



