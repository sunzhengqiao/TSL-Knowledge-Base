# hsbDrill

## Overview

**hsbDrill** is a versatile drilling tool that creates drill patterns along timber beams, panels, or plates. It supports both single drill operations and distributed drill patterns along the X-direction of selected members. The script can automatically connect multiple beams and supports advanced features like slotted holes and sinkholes (counterbores) on both sides of the drill.

| Property | Value |
|----------|-------|
| **Script Type** | O (Object) |
| **Version** | 2.7 |
| **Beams Required** | 0 |

---

## Properties

### General

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Depth** | Double | 0 | Sets the depth of the drill. A value of 0 creates a through-hole. |
| **Diameter** | Double | 18 mm | Sets the diameter of the drill hole. |
| **UCS** | String | -Z | Sets the alignment of the drills in relation to the most aligned beam direction of the current UCS. Options: -Z, -Y, Z, Y |
| **Snap to center line** | String | Yes | Defines if the drills will be placed along the axis of the first selected beam. Options: Yes, No |
| **Axis offset** | Double | 0 mm | Defines the offset from the beam axis. Only active for non-zero entries when "Snap to center line" is set to No. |

### Sinkhole - Reference Side

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Depth** | Double | 0 | Sets the depth of the sink hole on the reference (entry) side. A negative value shortens the drill in the main object if applicable. |
| **Diameter** | Double | 18 mm | Sets the diameter of the counterbore on the reference side. |

### Sinkhole - Opposite Side

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Depth** | Double | 0 | Sets the depth of the counterbore on the opposite (exit) side. Only applicable for through-holes. |
| **Diameter** | Double | 18 mm | Sets the diameter of the counterbore on the opposite side. |

### Slotted Hole

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Length** | Double | 18 mm | Creates a slotted hole if the length exceeds the diameter. |
| **Assignment** | String | none | Defines which objects receive the slotted hole. Options: none, first object, second object, all |

### Distribution (During Insertion Only)

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Mode** | String | Even Distribution | Sets the distribution method. "Even Distribution" spaces drills evenly; "Fixed Distribution" uses exact inter-distance. |
| **Inter distance** | Double | 70 mm | Sets the spacing between drills in the pattern. |
| **Distance from startpoint** | Double | 0 | Sets the offset from the start point of the distribution. |
| **Distance from endpoint** | Double | 0 | Sets the offset from the end point of the distribution. |

---

## Usage Workflow

### Basic Insertion

1. **Start the Script**: Launch hsbDrill from the TSL library or toolbar.

2. **Configure Drill Parameters**: A dialog appears allowing you to set:
   - Drill diameter and depth
   - UCS alignment direction
   - Sinkhole dimensions (if needed)
   - Slotted hole settings (if needed)
   - Distribution mode and spacing

3. **Select Main Beam**: Click on the primary beam, panel, or plate to receive the drill.

4. **Select Additional Beams (Optional)**: Select any additional members that should receive the same drill pattern, or press Enter to skip.

5. **Select Start Point**: Click to set the start point of the drill distribution, or press Enter to use the beam's start point.

6. **Select End Point**: Click to set the end point of the drill distribution, or press Enter to use the beam's end point.

The script will automatically create drill instances along the specified path according to the distribution settings.

### Modifying Drills After Placement

Once placed, individual drill instances can be modified through the Properties Palette (OPM):
- Adjust diameter, depth, and sinkhole parameters
- Change the UCS alignment
- Toggle center line snapping
- Modify slotted hole settings

---

## Context Menu Commands

Right-click on a placed drill instance to access these commands:

| Command | Description |
|---------|-------------|
| **Add entities** | Select additional beams to add to the drill operation |
| **Remove entities** | Select beams to remove from the drill operation |

---

## Special Features

### Slotted Holes
To create slotted holes (elongated holes), set the **Length** property to a value greater than the **Diameter**. Use the **Assignment** property to control which connected beams receive the slotted hole:
- **none**: All beams get round holes
- **first object**: Only the main beam gets slotted holes
- **second object**: Only secondary beams get slotted holes
- **all**: All connected beams get slotted holes

### Sinkholes (Counterbores)
Configure counterbores on either or both sides of the drill:
- Set the **Depth** and **Diameter** for each side
- The sinkhole diameter must be larger than the main drill diameter
- Opposite side sinkholes only apply to through-holes (Depth = 0)
- A negative depth on the reference side shortens the drill in the main object, useful for dowel-type connections

### Distribution Modes
- **Even Distribution**: Drills are spaced evenly between start and end points, always including both endpoints
- **Fixed Distribution**: Drills are placed at exact intervals from the start point

### Element Support
When the selected beam belongs to an Element (wall, floor, or roof), the script automatically detects intersecting beams and can assign the drill tool to them.

---

## Technical Notes

- The script operates in two modes internally: Distribution mode (for initial placement) and Single drill mode (for individual modifications)
- Drills are aligned to the current UCS setting (-Z, -Y, Z, or Y)
- The script validates that connected beams are coplanar with the main beam
- When "Snap to center line" is Yes, drills are automatically positioned along the beam's centerline
- The script supports catalog-based insertion for standardized drill configurations

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.7 | 03.12.2024 | Added property for distance from beam axis |
| 2.6 | 08.01.2019 | Alignment bugfix, intersecting beams detection |
| 2.5 | 10.10.2018 | Alignment fixed |
| 2.4 | 09.10.2018 | Intersecting beams detected on element creation |
| 2.3 | 19.07.2017 | Drill tool enter direction validated |
| 2.2 | 14.03.2015 | Slotted drills suppress overlapping drills |
| 2.1 | 25.11.2015 | Distribution mode supports remote catalog settings |
| 2.0 | 21.04.2015 | New copy and erase method |
