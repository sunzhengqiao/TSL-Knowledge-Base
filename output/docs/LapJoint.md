# LapJoint

Creates a lap joint (half-lap) connection between two intersecting timber beams, automatically cutting both members to create an interlocking joint.

## Overview

| Property | Value |
|----------|-------|
| **Script Type** | O-Type (Object) |
| **Version** | 1.4 |
| **Keywords** | Lap, lapjoint, Ueberblattung, Blatt |

## Description

The LapJoint script creates a traditional lap joint (also known as half-lap or "Ueberblattung" in German) between two timber beams that cross each other. This joint type is commonly used in timber frame construction where two beams need to connect while maintaining structural integrity.

The script:
- Automatically detects which beam is the "male" (top) and which is the "female" (bottom) based on geometry
- Creates matching cuts on both beams so they interlock at the crossing point
- Supports gap tolerances for manufacturing precision
- Can limit the maximum cutting depth on the female beam to preserve structural capacity

**Note:** This tool does not support parallel beam connections. The two beams must cross at an angle.

## Properties

### General

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Axis Offset** | Double | 0 mm | Vertical offset of the joint from the beam intersection center. Adjusts which beam sits higher at the connection. Value must be less than 50% of the male beam height. |
| **Max. Female Depth** | Double | 110 mm | Maximum allowable cutting depth on the female beam. The script will automatically adjust the Axis Offset if needed to respect this limit. Set to 0 to disable this constraint. |

### Gaps

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Male** | Double | 0 mm | Side gap tolerance for the male beam cut. Adds clearance to accommodate manufacturing tolerances or allow for easier assembly. |
| **Female** | Double | 0 mm | Side gap tolerance for the female beam cut. Adds clearance to accommodate manufacturing tolerances or allow for easier assembly. |

## Usage Workflow

### Insertion

1. **Launch the script** using one of these methods:
   - Type the command in the AutoCAD command line
   - Select from the hsbCAD tool palette
   - Use the ribbon menu

2. **Configure parameters** (optional):
   - A dialog appears allowing you to set initial property values
   - You can also select from saved catalog presets

3. **Select the male beam**:
   - Click on the beam that will be the upper/male part of the lap joint
   - This beam receives a notch cut on its underside

4. **Select the female beam**:
   - Click on the beam that will be the lower/female part of the lap joint
   - This beam receives a notch cut on its topside

5. **Automatic validation**:
   - The script verifies that the beams intersect properly
   - If beams are parallel or do not intersect, the tool is deleted with an error message

### After Insertion

Once placed, the lap joint can be modified through the AutoCAD Properties Palette (OPM):

- Adjust **Axis Offset** to shift the joint vertically
- Modify **Gap** values for manufacturing tolerances
- Set **Max. Female Depth** to limit cutting depth

The joint automatically recalculates when:
- Either connected beam is moved or resized
- Property values are changed in the Properties Palette
- The grip point is moved to adjust axis offset visually

### Element Assignment

If the primary (male) beam belongs to an Element (wall, floor, or roof assembly), the lap joint is automatically assigned to the same element group. This ensures the joint appears correctly in shop drawings and material lists.

## Context Menu Commands

Right-click on the lap joint to access these commands:

| Command | Description |
|---------|-------------|
| **Swap Sides** | Exchanges the male and female beam roles. Use this if the initial selection order was incorrect or you want to flip which beam has the upper position. |

**Tip:** Double-clicking on the lap joint also triggers the "Swap Sides" function.

## Visual Feedback

During operation, the script displays:
- Colored vectors showing the coordinate system orientation at the joint
- A shaded profile indicating the contact area between the two beams
- Debug geometry (when debug mode is enabled) showing intermediate calculations

## Automatic Adjustments

### Axis Offset Auto-Correction

If the **Max. Female Depth** limit would be exceeded, the script automatically adjusts the **Axis Offset** value to keep the female beam cut within the specified limit. A message appears in the command line when this adjustment occurs.

### Grip Point Adjustment

You can visually adjust the axis offset by moving the joint's grip point. The script interprets vertical movement of the grip point as an axis offset change.

## Error Conditions

The script will delete itself and display an error message if:

- The selected beams are parallel (lap joints require crossing beams)
- The selected beams do not geometrically intersect
- The axis offset is set to 50% or more of the male beam height
- Required beam selections are not made

## Technical Notes

- The script uses envelope bodies for performance when calculating intersections
- Group assignments are automatically propagated from the primary beam
- Dependencies are set on both beam lengths to trigger recalculation when beams change
- The joint supports catalog-based presets for standardized configurations

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.4 | 2022-01-28 | Automatic element assignment when main beam belongs to element |
| 1.3 | 2021-12-16 | Added Max Female Depth property with automatic axis offset adjustment |
| 1.2 | 2021-11-25 | Group assignment functionality added |
| 1.1 | 2021-11-16 | Default orientation swapped |
| 1.0 | 2021-10-22 | Initial release |
