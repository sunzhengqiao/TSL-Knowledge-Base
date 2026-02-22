# hsbPlateWallSheetCut

## Overview

| Property | Value |
|----------|-------|
| **Script Name** | hsbPlateWallSheetCut |
| **Type** | Object (O) |
| **Version** | 2.1 |
| **Category** | Sheet Cutting / Wall Modifications |
| **Keywords** | rubner, sheet, wall, cut |
| **Author** | marsel.nakuci@hsbcad.com, thorsten.huck@hsbcad.com |

## Description

This TSL creates openings in wall sheets when an intersecting beam (purlin) passes through a wall element. The tool automatically detects the intersection between the beam and the wall, then creates appropriately sized openings in the sheets of the selected zone.

Key capabilities:
- Automatically creates sheet openings where beams/purlins penetrate walls
- Supports multiple zones (interior/exterior layers)
- Configurable opening dimensions via properties or XML settings
- Recursive processing for subsequent zones
- Supports skew beams to wall orientation

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| **Model Space** | Yes | This script operates on 3D model geometry. |
| **Paper Space** | No | Not applicable for 2D drawings or viewports. |
| **Shop Drawing** | No | This is a detailing script, not a drawing generator. |

## Prerequisites

- **Required Entities**: You must have existing Wall entities (`ElementWallSF`) and Beam entities (`GenBeam`) in the model.
- **Minimum Beams**: At least 1 beam intersecting the wall.
- **Required Settings**: None strictly required, but `hsbPlateWallSheetCut.xml` is recommended for default dimensions.

## Usage Workflow

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse and select `hsbPlateWallSheetCut.mcr`.

### Step 2: Select Intersecting Beams
```
Command Line: Select intersecting beams
Action: Click on the beam(s) (e.g., purlins) that pass through the wall. Press Enter to confirm.
```
Select one or more beams (purlins) that intersect with walls. These are the penetrating elements that will create the openings.

### Step 3: Select Wall Elements
```
Command Line: Select walls or entities belonging to a wall
Action: Click on the wall outline, the wall sheeting, or any entity belonging to the specific wall where the cutouts are needed. Press Enter to confirm.
```
Select the wall elements or any entities belonging to wall elements where the openings should be created.

### Step 4: Configure Properties
The properties dialog will appear. Configure the opening dimensions and zone settings (see Properties Panel Parameters below).

### Step 5: Confirm and Generate
Click OK to generate the sheet openings. The TSL will automatically:
- Calculate intersection points
- Apply configured dimensions
- Create openings in intersecting sheets
- Optionally process subsequent zones

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **X1** | Double | 0 | Horizontal offset from beam edge (side 1). Defines additional clearance on one side of the beam. |
| **Y1** | Double | 0 | Vertical clearance added downwards from the beam at the bottom edge. A value of 0 means cut applies through entire Y direction. |
| **X2** | Double | 0 | Horizontal offset from beam edge (side 2). Defines additional clearance on the opposite side of the beam. |
| **Y2** | Double | 0 | Vertical clearance added upwards from the beam at the top edge. A value of 0 means cut applies through entire Y direction. |
| **Y3** | Double | 0 | Additional vertical offset applied to fine-tune the bottom start position of the cut. |
| **Zone** | Integer | 0 | Zone index where cuts are applied. Values: -5 to +5. Zone 0 applies to all zones. Positive values typically represent exterior zones, negative values interior zones. |
| **Subsequent Zones** | String | No | Whether to cut sheets of subsequent zones from the selected zone. Options: "No" or "Yes". When "Yes", the TSL recursively processes adjacent zones. |
| **Offset** | Double | 0 | Additional offset applied to subsequent zone processing. Controls how dimensions change for each zone layer. Creates a stepped effect. |

## Context Menu Options

This script does not add specific custom options to the right-click context menu. Use the standard AutoCAD properties palette to modify parameters.

## Settings Configuration

The script supports XML-based configuration for zone-specific settings. Settings are loaded from:
- Company path: `%hsbCompany%\TSL\Settings\hsbPlateWallSheetCut.xml`
- Installation path: `%hsbInstall%\Content\General\TSL\Settings\hsbPlateWallSheetCut.xml`

### XML Settings Structure

The XML file can define parameters per zone, material, and thickness:

```xml
<Hsb_Map>
  <lst nm="Zone[]">
    <lst nm="Zone">
      <int nm="Index" vl="1"/>
      <int nm="isActive" vl="1"/>
      <lst nm="Material[]">
        <lst nm="Material">
          <str nm="Name" vl="Default"/>
          <lst nm="Thickness[]">
            <lst nm="Thickness">
              <dbl nm="Thickness" vl="20"/>
              <int nm="exposed" vl="1"/>
              <dbl nm="X1" vl="10"/>
              <dbl nm="Y1" vl="0"/>
              <dbl nm="X2" vl="10"/>
              <dbl nm="Y2" vl="0"/>
              <dbl nm="Y3" vl="0"/>
            </lst>
          </lst>
        </lst>
      </lst>
    </lst>
  </lst>
  <unit ut="L" uv="millimeter"/>
</Hsb_Map>
```

### Property vs XML Priority

1. If all properties remain at default values (0) and XML file exists, values are read from XML
2. If any property is modified from default, all values are taken from properties panel
3. If no XML file exists and properties are default, default property values are used

## Technical Notes

### Beam-Wall Intersection Rules

- Beams lying in the plane of the wall are excluded (no valid intersection)
- Beams not penetrating sufficiently into the wall are skipped with a warning
- Skew beams (not normal to wall) are supported
- Only beams that actually intersect with the wall zone create openings

### Zone Processing Logic

- Zone 0 with "Subsequent Zones = Yes" creates two TSL instances: Zone -1 (interior) and Zone +1 (exterior)
- Each zone processes its own sheets independently
- Subsequent zone processing increments/decrements zone index and adds offset to dimensions
- The offset is cumulative: each subsequent zone adds the Offset value to the cut dimensions

### Supported Wall Types

- Works with `ElementWallSF` (Stick Frame Wall elements)
- Requires valid zones with defined height and material
- Exposed face orientation (interior/exterior) affects parameter selection from XML settings

## Tips and Best Practices

1. **Use XML Settings for Standards**: Define company-standard opening dimensions in the XML file to ensure consistency across projects

2. **Zone Selection**: Use Zone 0 with "Subsequent Zones = Yes" to automatically process both interior and exterior sheet layers

3. **Offset for Tolerance**: Use the Offset parameter to add progressive tolerance when cutting multiple zone layers

4. **Visual Verification**: After running the script, verify the created openings in 3D view to ensure correct dimensions

5. **Material-Specific Settings**: Configure different opening dimensions for different sheet materials in the XML file

6. **Beam Selection**: Select only beams that actually need to penetrate the wall to avoid unnecessary processing

7. **Y Values of Zero**: Setting Y1 or Y2 to 0 means the cut extends through the entire Y direction of the sheet

8. **Zero Dimensions Check**: If you run the script and see no cutout (or a tiny line), check if your Property values are 0. If they are, the script is looking for the XML file. Either configure the XML file or manually type dimensions in the Properties palette.

## Error Messages

| Message | Cause | Solution |
|---------|-------|----------|
| "no beam was selected" | No intersecting beams were selected | Select at least one beam that penetrates the wall |
| "Could not find any wall" | No valid wall elements found in selection | Ensure selected entities belong to a wall element |
| "no intersecting beam found" | Associated beam is missing or invalid | Re-associate the beam with the TSL instance |
| "no element found" | Associated wall element is missing | Re-associate the wall element with the TSL |
| "not an ElementWall" | Associated element is not a wall type | Use only wall elements with this TSL |
| "selected zone does not exist" | Chosen zone index not defined in wall | Select a valid zone index for the wall |
| "no sheet located in this zone" | Zone exists but contains no sheets | Verify zone has sheet material assigned |
| "Beam lies outside of the wall area" | Beam does not geometrically intersect wall envelope | Ensure beam passes through the wall |
| "Beam does not penetrate enough into the wall" | Beam penetration is too shallow | Extend the beam to fully penetrate the wall |
| "Beam lies in the plane of wall, excluded" | Beam axis is parallel to wall plane | Orient beam perpendicular to wall |

## FAQ

- **Q: Why is my cutout size 0?**
  A: The script properties default to 0, expecting an XML settings file to provide the dimensions. Ensure `hsbPlateWallSheetCut.xml` exists in your settings folder, or manually enter values for X1, Y1, X2, and Y2 in the properties.

- **Q: Can I cut through the entire wall thickness at once?**
  A: Yes. Set **Subsequent Zones** to `|Yes|` and select the starting Zone. The script will propagate the cut through adjacent layers.

- **Q: What does the Offset parameter do?**
  A: It adds (or subtracts) from the cut dimensions for every layer away from the selected Zone. This is useful for creating clearance for tapered insulation or allowing for play in the structure.

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 2.1 | 10 Nov 2020 | marsel.nakuci@hsbcad.com | HSB-9670: Consider all zones when checking penetration |
| 2.0 | 16 Jun 2020 | thorsten.huck@hsbcad.com | HSB-7940: Improved settings reading, enhanced insertion prompt, bugfix for missing zone intersection |
| 1.9 | 20 Nov 2019 | marsel.nakuci@hsbcad.com | HSB-5989: Updated TSL picture, added Y3 parameter |
| 1.7 | 15 Oct 2019 | marsel.nakuci@hsbcad.com | Various modifications |
| 1.6 | 26 Sep 2019 | marsel.nakuci@hsbcad.com | Added offset property |
| 1.0 | 03 May 2019 | marsel.nakuci@hsbcad.com | Initial version |

## Related Scripts

- **hsbPostFloorSheetCutOut**: Similar functionality for floor sheet cutouts
- **hsbSheetDistribution**: Sheet placement and distribution
- **hsbSplitSheets**: Sheet splitting operations
