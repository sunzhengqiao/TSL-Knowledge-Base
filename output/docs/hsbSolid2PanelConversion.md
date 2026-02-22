# hsbSolid2PanelConversion

## Overview

**hsbSolid2PanelConversion** is a specialized TSL tool that converts 3D solid objects (ACIS solids or imported geometry) into native hsbCAD Panels with full CLT (Cross-Laminated Timber) support. This is particularly useful when working with imported IFC/STEP geometry or when you need to convert AutoCAD solids into manufacturable panel definitions with proper tooling, drills, and edge treatments.

The script intelligently analyzes the source geometry to detect:
- Complex features like holes, housings, and countersinks
- Edge cuts and compound angles
- Material properties and grain direction
- Through-openings vs. drills based on configurable thresholds

**Script Type:** O-Type (Object-based)
**Version:** 7.8
**Environment:** Model Space

## Prerequisites

Before using this tool, ensure:

- You have one or more 3D solid objects in your drawing (ACIS solids, imported geometry, or existing beams)
- Panel styles are configured in hsbCAD that match the thickness of your solids
- The solid geometry represents valid panel shapes (rectangular or complex CLT profiles)

## Usage

### Step 1: Launch the Script

Run the `TSLINSERT` command and select `hsbSolid2PanelConversion.mcr` from the catalog, or use the command line with the script name.

### Step 2: Configure Settings

A dialog appears with conversion options:
- Select the **Panel Style** (or leave on "Auto" for automatic detection based on thickness)
- Choose the **Mode** (Full Conversion or Basic Conversion)

### Step 3: Select Source Geometry

When prompted with "Select solids":
- Click on the 3D solids or beams you want to convert
- You can select multiple objects at once
- Small cylindrical objects with 2 grip points are automatically detected as drills and associated with the nearest panel

### Step 4: Review the Conversion Preview

The script creates a preview panel for each solid:
- A grain direction indicator arrow is displayed on each panel
- The coordinate system alignment is shown
- Detected tools (cuts, drills, housings) are applied to the preview

### Step 5: Adjust Orientation (if needed)

Use the context menu commands to adjust:
- Rotate grain direction by 90 degrees
- Flip the reference side (top/bottom)
- Switch Y-Z axis orientation

### Step 6: Accept or Discard

- **Accept Conversion**: Finalizes the panel and removes temporary geometry
- **Discard Conversion**: Cancels and removes all conversion objects

## Parameters

### Properties Panel (OPM)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Panel Style** | Dropdown | Auto | Specifies the panel style for the conversion. When set to "Auto", the script automatically matches styles based on solid thickness. If multiple styles match the thickness, manual selection is required. |
| **Mode** | Dropdown | Full Conversion | Determines the conversion method: **Full Conversion** attempts to convert all tools (drills, cuts, housings); **Basic Conversion** converts only the bounding box with basic beam cuts. |
| **Color** | Integer | 152 | Sets the display color for the converted panel. |

### Automatic Style Detection

The script automatically filters available panel styles based on the solid's thickness:
- If exactly one style matches, it is selected automatically
- If multiple styles match (ambiguous), you must manually select one
- If no style matches the thickness, an error message is displayed and the conversion cannot proceed

## Right-Click Menu Options

| Menu Command | Description |
|--------------|-------------|
| **Rotate 90 Degrees** | Rotates the grain direction by 90 degrees around the panel normal |
| **Flip Reference Side** | Swaps the reference face of the panel (top/bottom orientation) |
| **Switch Y-Z Axis** | Swaps the Y and Z axes for orientation adjustment when thickness appears on wrong axis |
| **Accept Conversion** | Finalizes the conversion and creates the permanent panel entity |
| **Discard Conversion** | Cancels the conversion and removes all temporary geometry |
| **Delete conversion attempt** | Removes failed conversion attempts (appears when no matching style found) |
| **Create Group from Text** | (Debug mode only) Creates a group from selected text and assigns entities |

### Double-Click Behavior

Double-clicking on the conversion instance flips the reference side (same as "Flip Reference Side" command).

## Supported Conversions

### Tool Types Converted

The script recognizes and converts the following tool types from the source solid:

| Tool Category | Types Supported |
|---------------|-----------------|
| **Cuts** | End cuts, compound cuts, beveled cuts |
| **Double Cuts** | Japanese hip cuts, birdsmouth combinations |
| **Beam Cuts** | Simple housings, through housings, lap joints, tilted house cuts |
| **Drills** | Cylindrical openings (configurable diameter threshold) |
| **Free Profiles** | Curved contours, arc segments (v7.5+) |
| **Openings** | Rectangular and shaped through-openings |

### Edge Treatment Types

- Tilted house cuts (_kABCHouseTilted)
- Open diagonal seat cuts (_kABCOpenDiagonalSeatCut)
- Rising birdsmouth (_kABCRisingBirdsmouth)
- 5-Axis birdsmouth (_kABC5AxisBirdsmouth)
- Lap joints (_kABCLapJoint)
- Rising seat cuts (_kABCRisingSeatCut)
- Valley birdsmouth (_kABCValleyBirdsmouth)
- Japanese hip cuts (_kABCJapaneseHipCut)

## Metadata Support

When the source solid contains conversion metadata (from IFC import or body importer), the script can automatically apply settings to the converted panel.

### Supported Metadata Keys

| Key | Type | Description |
|-----|------|-------------|
| NAME | String | Panel name |
| MATERIAL | String | Material assignment |
| GRADE | String | Material grade |
| LABEL | String | Primary label |
| SUBLABEL | String | Secondary label |
| INFORMATION | String | Additional information field |
| STYLE | String | Preferred panel style name |
| STYLE[] | Array | List of allowed panel styles (creates filtered dropdown) |
| surfaceQualityTop | String | Top surface quality override |
| surfaceQualityBottom | String | Bottom surface quality override |
| ThresholdMaxDrill | Double | Maximum diameter to convert as drill (larger becomes opening) |
| ThresholdCutNormal | Double | Angle threshold for cut normal detection |
| ThresholdEdge | Double | Angle threshold for stretch edge detection |
| ConvertDrills | Int | Toggle drill conversion (1=yes, 0=no) |
| scriptNames | Map | Array of TSL script names to attach to converted panel |

### Automatic Metadata Application

On creation, the script reads metadata from the source solid's MapX and automatically:
- Sets panel name, material, grade, and labels
- Applies surface quality overrides
- Filters available styles to match metadata restrictions
- Attaches additional TSL scripts as defined

## Settings Files

This script does not require external XML settings files. Configuration is handled through:
- OPM properties
- Source solid metadata (MapX)
- hsbCAD panel style definitions

## Tips and Best Practices

1. **Style Configuration**: Ensure your panel styles are configured with correct thicknesses before running the conversion. The script requires an exact thickness match (within 0.1mm tolerance).

2. **Full vs. Basic Mode**:
   - Use **Full Conversion** for solids with complex tool patterns (cuts, housings, drills)
   - Use **Basic Conversion** for simple rectangular panels when you only need the bounding box

3. **Grain Direction**: The grain direction defaults to align with the longest dimension. The X-axis is automatically oriented to align with positive World Coordinate System directions.

4. **Reference Side**: The reference side determines which face is the "bottom" for manufacturing. If your panel appears inverted, use "Flip Reference Side" or double-click to correct.

5. **Drill vs. Opening Threshold**: When working with metadata, set the `ThresholdMaxDrill` value to control which circular openings become drill operations vs. through-openings:
   - Openings below threshold diameter become intelligent drill tools
   - Larger openings remain as panel openings

6. **Imported Geometry**: When converting imported IFC panels, the script preserves metadata from the source including position numbers and material assignments.

7. **Performance Optimization**: For large numbers of solids, the script:
   - Orders processing by volume (smallest first)
   - Uses ACIS modeling for enhanced quality (v6.5+)
   - Logs conversion progress to the command line

8. **Small Beamcut Removal**: The script automatically removes very small beamcuts (up to 100x10x10mm) that may represent grain direction markers from the source CAD system.

9. **Troubleshooting Failed Conversions**: If a solid cannot be converted, check:
   - The thickness matches an available panel style
   - The geometry is valid (not self-intersecting)
   - The solid volume exceeds the minimum threshold (1 cubic mm)
   - The solid is not too thin in both Y and Z directions (minimum 25mm in at least one direction)

## FAQ

**Q: Can I convert a Beam into a Panel?**
A: Yes, you can select a GenBeam. Unlike a 3D Solid, the original GenBeam will remain in the drawing after conversion with its visibility toggled off (unless in debug mode).

**Q: What happens if multiple panel styles match my solid's thickness?**
A: The script highlights these as "ambiguous styles" and requires you to manually select the correct style from the dropdown before conversion can proceed.

**Q: How do I cancel the conversion?**
A: Right-click on the script instance and select "Discard Conversion" before you finalize the process. This removes all temporary geometry.

**Q: Why are some drills missing after conversion?**
A: Ensure `ConvertDrills` is not set to 0 in the metadata. Also check that drill diameters are within the `ThresholdMaxDrill` value if set.

**Q: Can I process multiple solids at once?**
A: Yes, select multiple solids during the selection prompt. Each solid creates its own conversion instance that can be individually adjusted and accepted.

## Related Scripts

- `hsbSip` - Manual panel creation
- `hsbBodyImporter` - Import external solid geometry with metadata
- `hsbCLT-*` - CLT-specific panel tools
- `hsbPanelDrill` - Panel drill tool (applied automatically during conversion)

## Version History

| Version | Date | Description |
|---------|------|-------------|
| 7.8 | 23.11.2022 | Bugfix for seat cut conversion |
| 7.7 | 23.02.2022 | Fix for rising seat cut and Japanese hip cut combinations |
| 7.6 | 21.10.2021 | Fix for rising seat cut and valley birdsmouth combinations |
| 7.5 | 03.02.2021 | Added free profile arc segment support |
| 7.0 | 25.06.2020 | Improved cloning instance handling |
| 6.5 | 08.06.2020 | Enhanced performance using ACIS modeling |
| 5.0 | 07.03.2018 | Added pocket detection |
| 4.0 | 11.03.2015 | Added post-processing through metadata |
| 3.0 | 25.06.2014 | Major cut conversion improvements |
