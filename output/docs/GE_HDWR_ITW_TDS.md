# GE_HDWR_ITW_TDS - Tie Down System for Multi-Storey Buildings

## Overview

| Property | Value |
|----------|-------|
| **Script Name** | GE_HDWR_ITW_TDS |
| **Type** | Object (O) |
| **Version** | 1.6 |
| **Category** | Hardware / Tie Down System |
| **Author** | David Rueda (dr@hsb-cad.com) |
| **Last Updated** | November 3, 2013 |

## Description

The **GE_HDWR_ITW_TDS** script applies a complete Tie Down System (TDS) to multi-storey timber buildings. It automatically generates all necessary components for vertical load transfer across multiple floor levels, including threaded rods, nuts, square blocks, washers, couplers, studs, and optional floor system blocking with straps.

This system is essential for ensuring structural continuity in multi-storey timber frame construction, providing resistance against uplift forces.

## Usage Environment

| Environment | Supported |
|-------------|-----------|
| Model Space | Yes |
| Paper Space | No |
| Requires Framed Walls | Yes |
| Element Type | ElementWall (Stick Frame) |

## System Components

The Tie Down System generates the following components:

| Component | Description |
|-----------|-------------|
| **Rods** | Threaded steel rods running vertically through all levels |
| **Nuts** | Hexagonal nuts at rod terminations and connections |
| **Square Blocks** | Steel bearing plates for load distribution |
| **Washers** | Square washers at top termination |
| **Couplers** | Threaded couplers for rod splicing at each level |
| **Studs** | Additional timber studs at left and right of the system |
| **Blocking** | Optional floor system blocking |
| **Straps** | Optional straps on blocking for floor-to-floor connections |

## Usage Workflow

### Step 1: Prepare Walls
- Ensure all walls are **framed** before inserting the TDS
- Walls must have top plates and bottom plates defined
- The system works with stacked multi-storey walls

### Step 2: Insert the Script
1. Run the GE_HDWR_ITW_TDS command
2. Select the walls that will be part of the tie down system
3. Click to specify the insertion point (position along the wall)

### Step 3: Configure System Parameters
1. Select the **System Type** (rod diameter)
2. Choose **Run Start Options** (foundation type)
3. Choose **Run Termination** (top connection type)
4. Set stud quantities for left and right sides
5. Configure optional blocking and straps

### Step 4: Verify Installation
- The system automatically creates drills through all plates
- Check that rods align properly across all levels
- Verify blocking and straps are positioned correctly

## Properties Panel Parameters

### System Configuration

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **System type** | Selection | 5/8 | Rod diameter specification. Options: 5/8, 1/2, 7/8 (inch) |
| **Stud type** | Selection | - | Lumber item selection from company defaults |
| **Studs at left** | Selection | 2 | Number of studs on left side (0-5) |
| **Studs at right** | Selection | 2 | Number of studs on right side (0-5) |

### Floor System Options

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Floor system blocking** | Yes/No | No | Enable blocking between floor levels |
| **- Straps on blocking** | Yes/No | No | Add straps to blocking for floor connections |

### Connection Options

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Run Start Options** | Selection | Concrete | Foundation connection type: Concrete or Wood beam |
| **Run Termination** | Selection | Top plates | Top connection: Top plates or Compression Bridge |

### Dimensional Parameters

| Parameter | Type | Default (mm) | Default (in) | Description |
|-----------|------|--------------|--------------|-------------|
| **Anchor bolt Embedment** | Double | 200 | 8 | Depth of rod embedment into concrete/wood |
| **Rod Extension** | Double | 75 | 3 | Extension above top plate |
| **First Level Coupler Height** | Double | 300 | 12 | Height of coupler above base at first level |
| **Other Levels Coupler Height** | Double | 300 | 12 | Height of coupler at upper levels |
| **Clear distance between posts** | Double | 150 | 6 | Minimum clear distance between stud posts |

## System Types and Rod Diameters

| System Type | Rod Diameter (mm) | Rod Diameter (in) |
|-------------|-------------------|-------------------|
| 5/8 | 15.875 | 0.625 |
| 1/2 | 12.7 | 0.5 |
| 7/8 | 22.225 | 0.875 |

## Component Dimensions

| Component | Dimension | Value (mm) | Value (in) |
|-----------|-----------|------------|------------|
| Nut | Side Length | 25 | 1.062 |
| Nut | Height | 15 | 0.625 |
| Square Block | Side Length | 75 | 3 |
| Square Block | Height | 20 | 0.75 |
| Square Washer | Side Length | 75 | 3 |
| Square Washer | Height | 15 | 0.625 |
| Coupler | Side Length | 25 | 1.062 |
| Coupler | Height | 75 | 3 |
| Stud | Diameter | 50 | 2 |
| Stud | Height | 50 | 2 |
| Strap | Length | 800 | 32 |
| Strap | Width | 25 | 1 |
| Strap | Depth | 2.5 | 0.09375 |

## Run Start Options

### Concrete Start
- Rod extends below bottom plate into concrete foundation
- Assembly: Bottom Nut -> Square Block -> Top Nut -> Coupler
- Uses anchor bolt embedment depth

### Wood Beam Start
- Rod starts at bottom of bottom plate
- Assembly: Square Block -> Bottom Nut
- Suitable for continuous rod from beam below

## Run Termination Options

### Top Plates
- Rod terminates through top plates
- Square washer and nut at top
- Includes rod extension above

### Compression Bridge
- Alternative termination method
- Used with compression bridge connection details

## Automatic Operations

The script performs these automatic operations:

1. **Wall Detection**: Automatically finds all stacked walls aligned at the insertion point
2. **Drill Generation**: Creates vertical drills through all top and bottom plates
3. **Stud Management**: Erases existing studs that conflict with TDS location
4. **Blocking Modification**: Splits or trims existing blocking to accommodate the system
5. **Transfer Beams**: Creates floor-to-floor transfer beams when blocking is enabled

## Export Data (for Revit)

The system exports the following data for BIM coordination:

| Data Key | Description |
|----------|-------------|
| STORYNUMBER | Total number of stories in system |
| BOTTOMPLATEHEIGHT | Height at bottom plate |
| STARTLEVELCOUPLERHEIGHT | Coupler height at first level |
| RODEMBEDMENT | Anchor embedment depth |
| RODEXTENSION | Extension at top |
| OTHERLEVELSCOUPLERHEIGHT | Coupler heights at upper levels |
| SYSTEM_X_WALLHEIGHT | Wall height for each story |
| SYSTEM_X_FLOORTHICKNESS | Floor thickness for each story |

## Tips and Best Practices

### Before Insertion
1. **Frame all walls first** - The system requires framed walls with plates
2. **Verify wall alignment** - Walls must be vertically aligned for proper rod continuity
3. **Check lumber defaults** - Ensure company lumber defaults are configured

### During Configuration
1. **Minimum clear distance** - Cannot be less than 50mm (3 inches)
2. **Strap placement** - Straps are automatically placed at first and last stud when multiple studs are used
3. **Coupler heights** - Adjust based on accessibility requirements for installation

### Troubleshooting
- **"All walls must be framed"** - Frame the walls using stick frame tools before inserting TDS
- **"Reference element not found"** - Ensure walls intersect at the insertion point
- **"No walls left after filter"** - Check that walls are aligned vertically at the clicked position

### Manual vs. Construction Directive
- **Manual Insertion**: All properties are editable, studs are created
- **Construction Directive**: Properties are read-only, controlled by external system

## Related Scripts

- **GE_HDWR_WALL_HOLD_DOWN** - Single-level hold down
- **GE_HDWR_WALL_ANCHOR** - Wall anchor system
- **GE_HDWR_WALL_ANCHOR_MULTIPLE** - Multiple wall anchors

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.6 | Nov 3, 2013 | David Rueda | Added Stickframe path to mapIn for DLL calls |
| 1.5 | Apr 1, 2013 | David Rueda | Integrated manual/construction directive insertion |
| 1.4 | Apr 1, 2013 | David Rueda | Updated property names, TSL not erased on manual insert |
| 1.3 | Oct 31, 2012 | David Rueda | Set color to white |
| 1.2 | Oct 10, 2012 | David Rueda | Fixed error on insertion with wrong pre-set values |
| 1.1 | Oct 9, 2012 | David Rueda | Export values for Revit consumption |
| 1.0 | Oct 6, 2012 | David Rueda | Initial release |
