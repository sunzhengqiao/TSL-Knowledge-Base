# GE_WALL_SECTION_BLOCKING.mcr

## Overview
Generates timber blocking (fire stops or bridging) between wall studs at specific elevations. This script allows you to define a section of a wall and insert up to four rows of blocking with configurable material sizes and orientations.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script works exclusively in the 3D model. |
| Paper Space | No | Not applicable for drawings/layouts. |
| Shop Drawing | No | This is a model generation script. |

## Prerequisites
- **Required Entities**: One existing `ElementWall` (Wall).
- **Minimum Beam Count**: 0 (Script generates new beams, does not require existing ones).
- **Required Settings**:
  - `hsbFramingDefaults.Inventory.dll` (Standard hsbCAD inventory).
  - `GE_WALL_SECTION_BLOCKING_CUSTOM_PROPS.xml` (Optional, for saving preset configurations).

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT`
**Action**: Browse and select `GE_WALL_SECTION_BLOCKING.mcr`.

### Step 2: Select Wall
```
Command Line: Select Wall
Action: Click on the Wall element in the model where you want to add blocking.
```

### Step 3: Define Section Start
```
Command Line: Select a start Point
Action: Click a point in the model to define the start of the blocking area (usually along the bottom plate).
```

### Step 4: Define Section End
```
Command Line: Select the end Point
Action: Click a point to define the end of the blocking area. A rubber-band line will appear from the start point.
```

### Step 5: Define Wall Side
```
Command Line: Select Side of Wall
Action: Click on the desired face of the wall (Left/Right or Interior/Exterior) to set the coordinate origin.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Blocking 1** | Dropdown | *Empty* | Select the lumber material/size (e.g., 2x4) for the first row of blocking. |
| **Blocking 2** | Dropdown | *Empty* | Select the lumber material/size for the second row. |
| **Blocking 3** | Dropdown | *Empty* | Select the lumber material/size for the third row. |
| **Blocking 4** | Dropdown | *Empty* | Select the lumber material/size for the fourth row. |
| **Minimum block length** | Number | 3 inches | Blocking smaller than this length will not be generated (avoids tiny scraps). |
| **Elevation of block 1** | Number | 36 inches | Height from the bottom plate to place Blocking 1. Set to `0` to disable this row. |
| **Orientation 1** | Dropdown | *Edge* | Rotation of the timber: `Edge` (vertical) or `Flat` (horizontal) relative to the wall face. |
| **Elevation of block 2** | Number | 84 inches | Height from the bottom plate to place Blocking 2. Set to `0` to disable this row. |
| **Orientation 2** | Dropdown | *Edge* | Rotation of the timber: `Edge` (vertical) or `Flat` (horizontal). |
| **Elevation of block 3** | Number | 0 inches | Height from the bottom plate to place Blocking 3. Set to `0` to disable this row. |
| **Orientation 3** | Dropdown | *Edge* | Rotation of the timber: `Edge` (vertical) or `Flat` (horizontal). |
| **Elevation of block 4** | Number | 0 inches | Height from the bottom plate to place Blocking 4. Set to `0` to disable this row. |
| **Orientation 4** | Dropdown | *Edge* | Rotation of the timber: `Edge` (vertical) or `Flat` (horizontal). |
| **DimStyle** | Dropdown | *Current* | Select the dimension style for visual markers (if used by your setup). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Create Blocks** | Forces the script to regenerate the blocking beams based on current properties and wall geometry. |
| **Delete Blocks** | Removes the generated blocking beams but keeps the script instance active on the wall. |

## Settings Files
- **Filename**: `GE_WALL_SECTION_BLOCKING_CUSTOM_PROPS.xml`
- **Location**: `...\Company\Tsl\Catalog\`
- **Purpose**: Stores the last used material types and settings. When enabled, it allows you to load standard configurations automatically without re-selecting materials every time.

## Tips
- **Disabling Rows**: To temporarily turn off a specific row of blocking without losing the settings, set its **Elevation** to `0`.
- **Grip Editing**: After insertion, you can drag the **Start** and **End** grip points to resize the area where blocking is applied. Drag the **Origin** grip to shift the reference side.
- **Wall Splits**: If you split the wall using the CAD Split command, the script will automatically copy itself to the new wall segments, preserving the blocking configuration.
- **Orientation**: Use **Flat** orientation if you need the block to lie flat against the studs (e.g., for nailing wide siding), or **Edge** for standard fire-stopping.

## FAQ
- **Q: Why didn't any blocks generate?**
- **A:** Check the following: Is the **Elevation** set to greater than 0? Is the **Blocking Type** selected? Is the distance between studs larger than the **Minimum block length**?
- **Q: What is the difference between Edge and Flat orientation?**
- **A:** **Edge** stands the timber up (e.g., a 2x4 is 3.5" wide and 1.5" thick on face). **Flat** lays it down (e.g., a 2x4 is 1.5" wide and 3.5" thick on face).
- **Q: Can I use this for curved walls?**
- **A:** This script is designed for linear wall sections. It calculates straight blocking distances between studs.