# Remove Project Group Data

## Overview
This script is a maintenance tool used to clean up specific project grouping metadata from selected structural elements. It removes internal data tags that start with "HSB_" and end with "Child" and updates any visualization scripts to reflect these changes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the 3D model. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | Not intended for shop drawing generation. |

## Prerequisites
- **Required entities**: Structural Elements (Walls, Floors, or Roofs).
- **Minimum beam count**: 0 (The script can run without selections, though no data will be removed).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Remove Project Group Data.mcr`

### Step 2: Select Elements
```
Command Line: Select elements
Action: Click on the Walls, Floors, or Roofs from which you want to remove the grouping data. Press Enter when finished.
```

### Step 3: Processing
The script will automatically process the selected elements, delete the specific grouping metadata, refresh grouping visualizations (such as "HSB_I-ShowGroupingInformation" or "Batch & Stack Info"), and then delete its own instance from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script has no editable properties in the Properties Palette. It runs immediately upon insertion and selection. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add custom options to the right-click context menu. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Automatic Cleanup**: You do not need to manually delete the script instance after use; it removes itself from the drawing automatically after finishing the task.
- **Visual Updates**: If you have scripts active that show grouping information (like "Batch & Stack Info"), they will automatically refresh to show that the data has been removed.
- **Safe to Use**: This script only removes internal metadata tags (keys formatted as `HSB_...CHILD`). It does not delete or modify the physical geometry of your elements.

## FAQ
- **Q: What exactly does this script delete?**
  A: It deletes specific internal property keys that start with "HSB_" and end with "CHILD" (case-insensitive) within the element's data. It does not affect the element's dimensions or material.
- **Q: Why did the script disappear after I used it?**
  A: This is a "single-use" utility script. It is designed to execute its cleaning function and then automatically erase itself to keep your drawing clean.
- **Q: Can I undo the changes?**
  A: Yes, you can use the standard AutoCAD `UNDO` command to restore the metadata and the script instance if you ran it by mistake.