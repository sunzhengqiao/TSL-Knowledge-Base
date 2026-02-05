# ObjectClone.mcr

## Overview
This script creates a flattened 2D clone of selected 3D timber elements (GenBeams or Elements) projected onto the XY-world plane. It is primarily used for generating production tags, labels, or preparing geometry for nesting layouts directly within the model space.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script generates 2D geometry and visual links in the 3D model environment. |
| Paper Space | No | Not designed for use in Layouts/Viewports. |
| Shop Drawing | No | Not intended for 2D detailing views. |

## Prerequisites
- **Required Entities**: An existing `GenBeam` or `Element` to clone.
- **Minimum Beam Count**: 0 (Selects existing entities rather than creating new ones).
- **Required Settings**: `ObjectClone.xml` (Auto-loaded from Company or Install path on first use).

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Select `ObjectClone.mcr` from the list.

### Step 2: Select Entity and Location
1.  **Command Line**: Select the timber entity (GenBeam or Element) you wish to clone.
2.  **Command Line**: Specify the insertion point for the 2D clone in the XY-plane.
3.  The script generates the 2D representation and the tag at the specified location.

### Step 3: Positioning (Optional)
1.  Select the newly created clone.
2.  Drag the **Grip** to move the clone.
    *   *Note*: If you drop the clone onto an `ObjectNester` entity, it will automatically group/assign itself to it.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| X-Offset Tag | Number | 0 | Sets the horizontal distance (mm) of the text tag from the clone's top-left corner. |
| X-Offset Mode | Dropdown | Absolute | Determines how X offset is calculated: **Absolute** (fixed mm) or **Relative** (percentage of clone width). |
| Y-Offset Tag | Number | 0 | Sets the vertical distance (mm) of the text tag from the clone's top-left corner. |
| Y-Offset Mode | Dropdown | Absolute | Determines how Y offset is calculated: **Absolute** (fixed mm) or **Relative** (percentage of clone height). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Show / Hide Relation | Toggles the visibility of the connector line between the original 3D timber part and the 2D clone. |
| Settings | Opens a dialog box to quickly configure Tag Offsets and Modes without using the Properties palette. |
| Import Settings | Loads configuration settings from the `ObjectClone.xml` file. |
| Export Settings | Saves the current configuration settings to the `ObjectClone.xml` file (overwrites existing). |

## Settings Files
- **Filename**: `ObjectClone.xml`
- **Location**: Company path (preferred) or hsbCAD Install path.
- **Purpose**: Stores default values for tag positioning (X/Y offsets and modes) to ensure consistency across projects.

## Tips
- **Nesting Integration**: Use the grip to drag and drop clones onto `ObjectNester` objects to automatically organize them for production.
- **Relative Positioning**: If you are cloning parts of varying sizes, set the Offset Modes to **Relative**. This ensures the tag stays in a proportional position (e.g., always 10% from the edge) regardless of the part size.
- **Weight Visibility**: The script supports calculating and displaying the weight of the cloned entity (Version 1.7+).

## FAQ
- **Q: How do I reset the tag position to the default?**
  - **A**: Open the Context Menu, select **Import Settings**, or manually set the X and Y Offset values to `0` in the Properties panel.
- **Q: Why does my tag disappear when I change the size?**
  - **A**: If you are using **Relative** mode, an offset value like `1.0` (100%) or greater might place the text outside the visible boundary of the clone. Try reducing the offset value (e.g., to `0.1` for 10%).
- **Q: Can I use this script in a drawing view?**
  - **A**: No, this script works exclusively in Model Space (`_kModelSpace`).