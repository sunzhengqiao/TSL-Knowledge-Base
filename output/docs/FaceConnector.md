# FaceConnector

Distributes Simpson Strong-Tie TFPC (Timber Frame Panel Closer) connectors along the joint between two stick-frame walls, supporting both parallel and corner wall configurations.

## Overview

The FaceConnector tool automates placement and distribution of face-mounted panel connectors at the intersection of two stick-frame wall elements. It detects whether the selected walls are parallel (opposing) or perpendicular (corner), calculates the common overlap zone, and distributes TFPC hardware along that zone according to user-defined spacing rules.

Key features:
- **Automatic wall relationship detection**: Identifies parallel or corner connections between two walls
- **Configurable distribution**: Fixed or even spacing with adjustable start/end offsets
- **Side selection**: For parallel walls, connectors can be placed on the reference or opposite face
- **Explode to individual instances**: A distributed row can be exploded into separate single-connector instances for individual adjustment
- **Hardware BOM integration**: Automatically generates Bill of Material entries for the TFPC connector, structural screw, and nails
- **Block symbol display**: Renders a 3D block symbol (TFPC) at each connector location with plan-view annotation

| Property | Value |
|----------|-------|
| **Script Type** | O-Type (Object-based tool) |
| **Version** | 1.1 (06.09.2024) |
| **Keywords** | Face, connector, TFPC, Simpson, Wall, SF |
| **Category** | Hardware / Simpson |

## Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary operating environment for placing connectors on 3D wall elements |
| Paper Space | No | Not designed for layout views |
| Shop Drawing | No | Not designed for fabrication drawing details |

## Prerequisites

- Two `ElementWallSF` (stick-frame wall) elements must exist in the model
- Walls must be either parallel or perpendicular to each other (angled walls are not supported)
- Parallel walls must be within 100 mm of each other to be recognized as connected
- Walls must share a common vertical overlap area
- Optional: A TFPC block file (`TFPC.dwg`) in the company block folder (`_kPathHsbCompany\Block`) for enhanced 3D symbol display
- Optional: An XML settings file `FaceConnector.xml` in the TSL Settings folder for custom hardware definitions

## Usage

### Step 1: Launch Script

Command: `TSLINSERT`, then select `FaceConnector` from the list, or use:
```
hsb_ScriptInsert "FaceConnector"
```

### Step 2: Configure Parameters

A dialog appears with distribution and position settings. Configure spacing rules, offsets, and side preference before selecting walls. You can also load a saved catalog preset.

### Step 3: Select Two Walls

```
Command Line: Select 2 parallel SF Walls
```
Select exactly two stick-frame wall elements and press Enter. The script accepts both parallel and corner-connected walls despite the prompt text.

### Step 4: Automatic Processing

The tool performs the following automatically:
1. Detects whether the walls are parallel or in a corner configuration
2. Calculates the common vertical overlap zone between the two walls
3. Distributes connector positions along the overlap zone based on the spacing parameters
4. Places a 3D symbol (box and optional TFPC block) at each connector position
5. Generates hardware BOM entries for all connectors
6. Displays a plan-view text annotation showing the connector count (e.g., "TFPC x 5")

## Parameters

### General

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Connection Type** | Dropdown | Distribution at 2 walls | Defines the connection configuration. Currently supports distribution along two walls. |

### Distribution

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Rule** | Dropdown | Fixed Distribution | **Fixed Distribution**: Places connectors at fixed intervals with one at each end. **Even Distribution**: Adjusts spacing so connectors are evenly spread across the available length. |
| **Start Offset** | Length | 350 mm | Distance from the bottom of the overlap zone to the center of the first connector. |
| **End Offset** | Length | 350 mm | Distance from the top of the overlap zone to the center of the last connector. |
| **Interdistance** | Length | 1000 mm | Center-to-center spacing between adjacent connectors. Positive values define a fixed distance. Negative values define a fixed quantity of connectors (e.g., -3 places exactly 3 connectors). |

### Position

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **SideParallelWalls** | Dropdown | Reference | For parallel walls only. Selects which face of the wall assembly receives the connectors: **Reference** (outer face of first wall) or **Opposite** (inner face). |
| **Offset** | Length | 0 mm | Lateral offset of the connector from the wall edge. Shifts the connector symbol perpendicular to the wall surface. |

### Display

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Text Height** | Length | 0 mm | Height of the plan-view annotation text. Set to 0 to hide the text label. |

## Context Menu

Right-click on a FaceConnector instance to access these commands:

| Menu Item | Availability | Description |
|-----------|-------------|-------------|
| **Swap Walls** | Parallel connections only | Swaps the assignment of the two wall elements. Useful when the connector placement references the wrong wall. |
| **Flip Side** | Parallel connections only | Moves connectors from the reference side to the opposite side of the wall assembly, or vice versa. |
| **Explode distribution** | Distribution mode | Breaks the distributed row into individual single-connector instances. Each instance can then be repositioned or deleted independently. After exploding, the original distribution instance is removed. |

## Hardware Output

Each FaceConnector instance generates the following Bill of Material entries (per connector position):

| Article Number | Description | Quantity | Manufacturer |
|----------------|-------------|----------|--------------|
| TFPC | Timber Frame Panel Closer | 1 | Simpson Strong-Tie |
| SDW22458 | 8.0 x 117 mm SDW structural screw | 1 | -- |
| N3.75x30 | 3.75 x 30 mm square twist nail | 2 | -- |

Quantities are automatically multiplied by the number of distributed connector positions. Custom hardware definitions can be provided via the `FaceConnector.xml` settings file.

## Settings File

| Property | Value |
|----------|-------|
| **Filename** | `FaceConnector.xml` |
| **Company path** | `_kPathHsbCompany\TSL\Settings\` |
| **Install path** | `_kPathHsbInstall\Content\General\TSL\Settings\` |
| **Format** | `<Hsb_Map>` XML with version tracking |

The settings file can override the default hardware definitions (article numbers, quantities, manufacturers) and supports version validation. If the installed version differs from the drawing version, a notice is displayed.

## Tips

- **Parallel vs. Corner**: The script automatically detects the wall relationship. For parallel walls you get side selection and swap options; for corner walls the script identifies which wall is the "male" (end wall) and which is the "female" (through wall).
- **Negative Interdistance**: Enter a negative value in the Interdistance field to specify an exact quantity of connectors instead of a spacing distance (e.g., -4 places exactly 4 connectors).
- **Explode for Fine Control**: Use the "Explode distribution" context menu command to convert a row of connectors into individual instances. This lets you delete specific connectors or reposition them without affecting the others.
- **TFPC Block**: If a `TFPC.dwg` block file is present in the company Block folder, the script renders the manufacturer's 3D symbol. Without it, a simplified box representation is used.
- **Wall Distance Limit**: Parallel walls must be within 100 mm of each other. If you receive a "Walls too far apart" error, move the walls closer or check for unintended gaps.

## Troubleshooting

| Problem | Cause | Solution |
|---------|-------|----------|
| "2 Walls needed" error | Fewer than two walls selected, or selected entities are not `ElementWallSF` | Ensure you select exactly two stick-frame wall elements |
| "Only parallel and corner connected walls supported" | Walls are at an angle other than 0 or 90 degrees | Align walls so they are either parallel or perpendicular |
| "Walls too far apart, connection not possible" | Gap between parallel walls exceeds 100 mm | Move walls closer together or verify wall positions |
| "no common area in height" | Walls do not share any vertical overlap | Ensure walls overlap in the Z direction (e.g., same storey height) |
| "no distribution possible" | Start/end offsets exceed available distribution length | Reduce Start Offset and End Offset values |
| No connectors visible | Distribution parameters produce zero valid positions | Check that Interdistance is not too large relative to the available length |
| Text annotation not showing | Text Height is set to 0 | Set Text Height to a positive value (e.g., 50 mm) |
| Version mismatch notice on insert | Settings file version differs between drawing and installation | Update the settings XML or acknowledge the notice |

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.1 | 06.09.2024 | HSB-20922: Fix when getting pt0Edge at "getWallConnectionType" |
| 1.0 | 26.06.2024 | HSB-20922: Initial release |
