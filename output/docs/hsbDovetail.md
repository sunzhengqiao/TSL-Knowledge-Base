# hsbDovetail.mcr

## Overview
Creates integral Dovetail or Butterfly (loose key) timber connections between beams or panels. The script supports T-Connections, End-End joints, and Parallel connections, including options for single or double dovetails.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary environment for creating 3D joints. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: Two GenBeams (timber elements).
- **Minimum Beam Count**: 2
- **Required Settings**: None (Uses internal script properties).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbDovetail.mcr`

### Step 2: Select First Element
```
Command Line: Select first beam:
Action: Click on the primary timber beam (usually the "male" part or the beam you want to cut the tenon into).
```

### Step 3: Select Second Element
```
Command Line: Select second beam:
Action: Click on the secondary timber beam (the "female" part or intersecting beam).
```

### Step 4: Position Joint
```
Command Line: Specify insertion point:
Action: Move your cursor to position the dovetail along the beam intersection. A blue preview (for Dovetail) or tool body (for Butterfly) will follow your cursor. Click to confirm placement.
```
*Note: The script automatically detects if the beams are Parallel or Intersecting and adjusts the connection type accordingly.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Connection | dropdown | T-Connection | Defines the geometric relationship: T-Connection, End-End, or Parallel Connection. |
| Type | dropdown | Dovetail | Selects the joinery method. **Dovetail** creates an integral tenon. **Butterfly** creates a slot for a loose key. (Forced to Butterfly in Parallel mode). |
| X-Width | number | 45 mm | The length of the dovetail tenon or slot along the beam's axis. |
| Z-Depth | number | 28 mm | The depth of the cut perpendicular to the beam face (penetration depth). |
| Additional Depth | number | 0 mm | Extra depth clearance for the mortise in Butterfly connections. |
| Offset | number | 0 mm | Vertical shift of the joint relative to the reference edge (bottom/center). |
| Angle | number | 10 deg | The taper angle of the dovetail sides (slope). Used primarily for Butterfly types. |
| Offset X | number | 0 mm | Horizontal shift of the joint along the beam's length. Only active for Parallel connections. |
| Rotation | number | 0 | Rotates the joint definition (usually swaps wide/narrow ends). Available when Offset is 0. |
| Inter Distance | number | 0 mm | Spacing between two dovetails for a Duplex (double) configuration. Enter 0 for a single dovetail. |
| Height Key | number | 0 mm | Height of the loose butterfly key slot. 0 = Auto calculation. Active only for Butterfly type. |
| Width Key | number | 0 mm | Width (minor axis) of the loose butterfly key slot. 0 = Auto calculation. Active only for Butterfly type. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Rotate | Flips the joint orientation (toggles between 0° and 180°). |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies entirely on Properties Palette parameters and does not require external XML settings files.

## Tips
- **Parallel Connections**: If you select two parallel beams, the script automatically switches to the "Butterfly" type to create a slotted connection for a loose key.
- **Double Dovetails**: To create two tenons side-by-side, set the **Inter Distance** property to a value greater than 0.
- **Adjusting Position**: After insertion, select the joint and drag the visible grip point to slide the dovetail along the beam.
- **Geometry Limits**: If the script fails or deletes itself, check that the beams actually overlap or intersect sufficiently to fit the defined Width.

## FAQ
- **Q: Why is the "Type" property locked or grayed out?**
  A: This usually happens when **Connection** is set to "Parallel Connection". This geometry type forces the "Butterfly" style automatically.
  
- **Q: How do I create a loose key instead of a tenon?**
  A: Change the **Type** property in the Properties Palette to "Butterfly". This changes the toolpath to cut a slot rather than shape the beam end.

- **Q: The script gave an error "Tool will be deleted". Why?**
  A: This typically means the selected beams do not have a common intersection area large enough for the defined **X-Width**, or they are not parallel when a Parallel connection was requested. Move the beams closer together or reduce the X-Width.