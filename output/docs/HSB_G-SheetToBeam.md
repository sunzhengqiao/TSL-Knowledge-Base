# HSB_G-SheetToBeam

**Script ID:** HSB_G-SheetToBeam
**Version:** 3.07
**Type:** Object (O-Type)
**Category:** General Tools (G)
**Author:** Robert Pol (support.nl@hsbcad.com)

## Overview

The `HSB_G-SheetToBeam` script converts sheet elements (panels) into timber beams in hsbCAD. This tool is designed to transform 2D sheet entities into 3D timber beams while preserving important properties like material, grade, and beam code. The script intelligently determines the optimal orientation for the new beam based on the sheet's envelope geometry.

## Purpose

This script is particularly useful for:
- Converting panel-based designs into timber framing elements
- Maintaining property consistency during the conversion process
- Ensuring proper alignment of beams within existing elements
- Automated conversion of sheets to beams for structural modeling

## Prerequisites

- No beams required (`#NumBeamsReq 0`)
- Works with existing elements containing sheets
- Compatible with hsbCAD's timber construction environment

## User Properties (OPM)

The script provides these user-configurable properties in the AutoCAD Properties Palette:

### Selection Category
| Property | Description | Default | Options |
|----------|-------------|---------|---------|
| **Zone to convert** | Filter sheets by zone | "--" | "--", 10, 9, 8, 7, 6, 0, 1, 2, 3, 4, 5 |
| **Filter definition for GenBeams** | Advanced filtering for GenBeams | "" | Catalog-based filters |

### Override Properties Category
| Property | Description | Default |
|----------|-------------|---------|
| **Name** | Name for the new beam | "" |
| **hsbCAD Material** | Material override | "" |
| **Grade** | Grade override | "" |
| **Information** | Information field | "" |
| **Label** | Label for the beam | "" |
| **Sublabel** | Sublabel for the beam | "" |
| **Sublabel 2** | Second sublabel | "" |
| **Beam code** | Custom beam code | "" |
| **Color** | Color override | -1 (inherit) |

## Usage Instructions

### Method 1: Using Elements
1. Select one or more elements containing sheets
2. The script will automatically extract all sheets from the selected elements
3. Configure properties in the Properties Palette if needed
4. Sheets are converted to beams automatically

### Method 2: Manual Sheet Selection
1. Right-click during insertion to select individual sheets
2. Select the sheets you want to convert
3. Sheets are converted to beams immediately

### Method 3: Catalog Integration
- Can be called from other scripts using catalog keys
- Properties can be pre-set from master-to-satellite relationships

## Technical Details

### Conversion Process
1. **Envelope Analysis**: The script analyzes the sheet's envelope polygon to determine optimal beam orientation
2. **Vector Calculation**: Calculates the best X-axis direction for the new beam by analyzing segment lengths and area optimization
3. **Coordinate System**: Creates a new coordinate system based on the optimal orientation
4. **Property Transfer**: Copies all relevant properties from the original sheet to the new beam:
   - Material and grade
   - Name and labels
   - Beam code and information
   - Layer assignment
   - Color settings

### Filtering Options
- **Zone Filtering**: Filter sheets by zone number
- **GenBeam Filter**: Use advanced filters via `HSB_G-FilterGenBeams`
- **Combined Filters**: Zone and custom filters can be used together

## Version History

- **3.07** (29.01.2020): Added sequence number support - Robert Pol
- **3.06** (26.08.2019): Improved filtering capabilities - Robert Pol
- **3.05** (18.07.2019): Added GenBeamFilter - Robert Pol
- **3.04** (08.01.2019): Added area tolerance - Robert Pol
- **3.03** (17.01.2018): Improved insertion based on element - Robert Pol
- **3.02** (13.12.2017): Fixed alignment based on element - Robert Pol
- **3.01** (23.11.2017): Added individual sheet selection - Robert Pol
- **3.00** (18-04-2017): Added categories, improved insert - AS
- **2.05** (13-06-2016): Fixed name setting - EtH
- **2.04** (29.03.2016): Removed temporary sheet creation - AS
- **2.03** (16.03.2015): Preserve beamcode conversion - AS
- **2.02** (02.10.2014): Added color option - AS
- **2.01** (07.03.2013): Add property override options - AS
- **2.00** (06.03.2013): Updated for localizer - AS
- **1.00** (14.06.2010): Pilot version - AS

## Integration Notes

- Works with `HSB_G-FilterGenBeams` for advanced filtering
- Compatible with element-based workflows
- Supports master-to-satellite catalog relationships
- Preserves all timber construction properties during conversion

## Error Handling

The script includes safeguards for:
- Invalid selections
- Failed filtering operations
- Missing dependencies
- Manual insertion modes

## Tips for Use

1. Use zone filtering to convert specific areas of your model
2. Override properties to standardize beam attributes after conversion
3. The script automatically aligns beams with element coordinate systems
4. Batch processing is supported for multiple elements at once