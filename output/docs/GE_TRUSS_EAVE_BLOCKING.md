# GE_TRUSS_EAVE_BLOCKING

## Overview
Automatically generates timber blocking pieces between roof members (rafters or trusses) and a supporting wall. This script fills the gaps at the roof eave to provide a nailing surface for siding or to close the building envelope.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model to create physical beams. |
| Paper Space | No | Not designed for 2D detailing. |
| Shop Drawing | No | Generates model elements, not drawing views. |

## Prerequisites
- **Required Entities**: 
  - Roof members (Beams or TrussEntities)
  - One ElementWall
- **Minimum Count**: At least 1 roof member and 1 wall.
- **Required Settings**: 
  - `hsbFramingDefaults.Inventory.dll` must be configured with valid lumber items.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_TRUSS_EAVE_BLOCKING.mcr`

### Step 2: Select Roof Members
```
Command Line: Select beams and/or trusses
Action: Click on the rafters, beams, or trusses that run over the wall edge. Press Enter to confirm selection.
```

### Step 3: Select Wall
```
Command Line: Select wall
Action: Click on the wall plate or wall element where the blocking needs to be applied.
```

### Step 4: Configure Properties
```
Action: A dialog or the Properties Palette will appear. Select the desired Lumber Item (e.g., 2x4), set the Color, and define the Minimum Block Length.
```
*Note: The script instance will automatically disappear once the blocking is generated.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Lumber item | Dropdown | (First Available) | Select the material grade and size (e.g., 2x4 SPF) for the blocking pieces. Options are pulled from your Inventory. |
| Blocking color | Number | 32 | Sets the AutoCAD color index for the new beams (e.g., 32 for construction timber). |
| Minimum block length | Number | 75 mm (3") | The shortest length of blocking allowed. If the gap between rafters is smaller than this, no block will be created. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not create persistent smart objects with update menus. Once generated, the blocking becomes standard beams. |

## Settings Files
- **Filename**: `hsbFramingDefaults.Inventory.dll` (referenced)
- **Location**: Defined in your hsbCAD Company/Install path
- **Purpose**: Provides the dimensions (Width/Height), Material, and Grade data for the selected Lumber Item.

## Tips
- **Selection Order**: It does not matter if you select the roof members or the wall first, but you must select both.
- **Trusses vs. Rafters**: You can mix standard rafters and trusses in the same selection. The script calculates the combined volume to find the correct gap.
- **Small Gaps**: If you see missing blocks in tight areas, try lowering the "Minimum block length" property.
- **Re-running**: To modify the blocking after creation, delete the generated beams and run the script again.

## FAQ
- **Q: Why did the script disappear without creating any blocks?**
  - A: Check that the roof members actually overlap the wall line in the Top view. Also, verify that the gap between rafters is larger than the "Minimum block length" setting.
- **Q: I get an error "Data incomplete..."**
  - A: The selected Lumber Item in your inventory might be missing dimension data (Width or Height is 0). Contact your administrator to check the Inventory settings.