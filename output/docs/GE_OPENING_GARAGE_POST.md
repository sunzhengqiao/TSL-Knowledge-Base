# GE_OPENING_GARAGE_POST

## Overview

| Property | Value |
|----------|-------|
| **Script Name** | GE_OPENING_GARAGE_POST |
| **Type** | O (Object) |
| **Version** | 1.6 |
| **Category** | Opening Framing / Stick Frame |
| **Description** | Places head (full or split), side and mid posts around selected garage opening |
| **Author** | David Rueda (dr@hsb-cad.com) |
| **Last Updated** | 03.nov.2013 |

## Usage Environment

| Environment | Supported |
|-------------|-----------|
| Model Space | Yes |
| Paper Space | No |
| Shop Drawing | No |
| Requires Opening | Yes (OpeningSF type) |
| Requires Element | Yes (ElementWall) |

## Purpose

This TSL script automatically generates framing posts around a garage door opening in a stick-frame wall. It creates:

- **Side Posts** (left and right) - Full-height vertical posts at opening edges that extend from floor to wall top
- **Head Post** (header) - Horizontal beam across the top of the opening
- **Mid Post** - Vertical post centered above the opening, extending from the header to the wall top

The head post can be optionally split at the mid post location for structural reasons.

## Prerequisites

- **Required Entities**:
  - An existing Stickframe Opening (`OpeningSF`)
  - A parent Wall (`ElementWall`) containing the opening
- **Minimum Beam Count**: 0 (This script creates new beams)
- **Required Settings**:
  - Lumber Inventory defaults (configured via `hsbFramingDefaults.Inventory.dll`)

## Usage Workflow

### Step 1: Launch Script
Command: `TSLINSERT` -> Select `GE_OPENING_GARAGE_POST`

### Step 2: Select Garage Opening
- The script prompts: "Select garage opening"
- Click on an existing garage opening (OpeningSF type) in the wall
- The opening must belong to a valid ElementWall

### Step 3: Configure Parameters
- A dialog appears for configuring lumber items and beam properties
- Select lumber specifications for side, mid, and head posts
- Choose whether to split the header at the mid post

### Step 4: Script Execution
- Posts are automatically generated based on opening dimensions
- Beams are placed on the front or back side of the wall as specified
- All posts extend to the full height of the wall

## Properties Panel Parameters

### General Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Side of wall to frame | List | Front | Determines which side of the wall the framing is placed (Front/Back) |

### Side Post Configuration

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Lumber item | List | - | Select lumber specification from inventory (width, height, material, grade) |
| Beam color | Integer | 32 | AutoCAD color index for side posts (0-255) |
| Beam type | List | - | Beam classification type from available beam types |
| Information | String | - | General information text |
| Label | String | - | Primary beam label |
| Sublabel | String | - | Secondary beam label |
| Sublabel2 | String | - | Tertiary beam label |
| Beam code | String | - | Unique beam identification code |

### Mid Post Configuration

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Lumber item | List | - | Select lumber specification from inventory |
| Beam color | Integer | 32 | AutoCAD color index for mid post |
| Beam type | List | - | Beam classification type |
| Information | String | - | General information text |
| Label | String | - | Primary beam label |
| Sublabel | String | - | Secondary beam label |
| Sublabel2 | String | - | Tertiary beam label |
| Beam code | String | - | Unique beam identification code |

### Head Post Configuration

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Lumber item | List | - | Select lumber specification from inventory |
| Beam color | Integer | 32 | AutoCAD color index for head post |
| Beam type | List | - | Beam classification type |
| Split at mid post | List | Yes | Whether to split the header at the mid post location (Yes/No) |
| Information | String | - | General information text |
| Label | String | - | Primary beam label |
| Sublabel | String | - | Secondary beam label |
| Sublabel2 | String | - | Tertiary beam label |
| Beam code | String | - | Unique beam identification code |

### Display Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Text height | Double | 100.4 mm | Height of label text displayed in model space |
| Color | Integer | 2 | Display color for script label |

## Context Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Forces the script to regenerate beams based on current geometry and properties |

**Note**: The script automatically recalculates when any property is changed, so manual recalculation is rarely needed.

## Technical Details

### Dependencies

- **hsbFramingDefaults.Inventory.dll** - Used for accessing lumber item catalog
- **OpeningSF** - Must be a valid stick-frame opening
- **ElementWall** - The wall element containing the opening

### Post Dimensions

The script retrieves lumber dimensions (width and height) from the inventory system. Each post type (side, mid, head) can have different lumber specifications. The dimensions are automatically applied when you select a lumber item.

### Split Header Behavior

When "Split at mid post" is set to **Yes**:
- The head post is split at the mid post location into two separate beams
- The mid post extends up to contact the opening top
- A cut operation is applied to the mid post at the opening top level

When "Split at mid post" is set to **No**:
- The head post remains as one continuous beam
- The mid post extends up to contact the bottom of the head post

## Tips and Best Practices

1. **Opening Selection**: Ensure the garage opening is already created in the wall before running this script. Use the standard hsbCAD opening tools first.

2. **Lumber Inventory**: Make sure your lumber inventory is properly configured in the hsbFramingDefaults system. Missing or incomplete lumber data (name, material, grade, width, height) will cause the script to fail with an error message.

3. **Wall Side Selection**: Choose "Front" or "Back" based on which side of the wall needs the garage post framing. This affects the Z-offset position of all generated beams.

4. **Header Splitting**: For wide garage openings, splitting the header at the mid post provides better structural support and allows for easier transportation and installation.

5. **Color Codes**: Use standard AutoCAD color indices (0-255). Invalid values outside this range will default to color 32.

6. **Automatic Recalculation**: The script automatically recalculates when any property changes. There is no need to manually trigger a recalculation after modifying parameters.

7. **Wall Association**: The generated posts are automatically associated with the parent wall element and will update if the wall geometry changes.

8. **Material Management**: The material and grade for posts are controlled by the Lumber Inventory defaults, not by individual script properties. Update the inventory defaults to change wood species or grades.

## Error Messages

| Message | Cause | Solution |
|---------|-------|----------|
| "not a valid SFOpening" | Selected entity is not a valid OpeningSF | Select a proper garage opening created with stick-frame tools |
| "Could not find a valid wall element related to this opening" | Opening is not associated with a wall | Ensure opening is in a stick-frame wall element |
| "Data incomplete, check values on inventory for selected lumber item" | Lumber inventory missing required data (Name, Material, Grade, Width, or Height) | Configure lumber items completely in Defaults Editor |

## FAQ

**Q: Why does the script not appear to do anything when I insert it?**
A: Ensure you are selecting a valid Stickframe Opening (`OpeningSF`). Standard generic openings may not be recognized.

**Q: How do I change the wood material for the posts?**
A: The material is controlled by your global `hsbFramingDefaults` settings. Select a different Lumber item from the dropdown, or update the inventory defaults.

**Q: What happens if I delete the opening?**
A: The script relies on the geometry of the opening. If the opening is deleted, the script instance may error and require deletion and re-insertion.

**Q: Can I have different lumber sizes for side posts vs. the header?**
A: Yes, each post type (side, mid, head) has its own independent lumber item selection.

## Revision History

| Version | Date | Changes |
|---------|------|---------|
| 1.6 | 03.nov.2013 | Added Stickframe path to mapIn when calling dll |
| 1.5 | 25.apr.2013 | Beam material and grade taken directly from defaults editor; removed beam name prop |
| 1.4 | 22.jun.2012 | Thumbnail updated |
| 1.3 | 20.jun.2012 | Added split header option; automatic recalculation on property change; default color handling; description and thumbnail added |
| 1.2 | 02.may.2012 | Bugfix on opening selection and filtering; stopped exporting GARAGEPOSTFILE.dxx |
| 1.1 | 02.ago.2011 | Changed beam configuration; framing placed on outsider group |
| 1.0 | 27.jul.2011 | Initial release |
