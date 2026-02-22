# HSB_E-BlockDisplay

## Overview

The BlockDisplay script is a utility tool that allows users to insert and display AutoCAD blocks from a predefined folder (C:\Temp\Blocks). It provides a selection dialog to choose from available blocks and inserts them into the drawing at a specified point.

## Purpose

This script serves as a block insertion utility that:

- Scans a specific folder for AutoCAD drawing files (.dwg)
- Loads these drawings as blocks into the hsbCAD environment
- Provides a user-friendly interface for block selection
- Allows placement of selected blocks in the drawing

## Key Features

### Block Management
- **Dynamic Block Loading**: Automatically loads all .dwg files from C:\Temp\Blocks folder
- **Block Name Management**: Combines system blocks with file system blocks
- **Duplicate Prevention**: Skips blocks that are already loaded

### User Interface
- **Selection Dialog**: Provides a dropdown list of available blocks
- **Interactive Insertion**: Users click to place blocks in the drawing
- **One-Time Insertion**: Special handling for block insertion cycles

## User Properties

| Property | Type | Description | Default |
|----------|------|-------------|---------|
| Block names | String dropdown | List of available blocks for insertion | Dynamic list |

## How to Use

1. **Launch the Script**: Double-click the script to start it
2. **Select Block**: Choose from the dropdown list of available blocks
3. **Pick Insertion Point**: Click in the drawing where you want the block placed
4. **Block Inserted**: The selected block appears at your chosen location

## Technical Details

### File System Integration
- **Search Path**: C:\Temp\Blocks (hardcoded)
- **File Filter**: Only .dwg files are processed
- **Auto-Discovery**: New blocks are automatically detected when added to the folder

### Block Processing
- Files are loaded using the `Block()` constructor with full file paths
- Blocks are drawn using the Display object with color -1 (ByLayer)
- Insertion point is determined by user selection

### Special Behavior
- **Cycle Handling**: If the script is called multiple times in an insertion cycle, it erases the previous instance
- **Dialog Priority**: Shows the selection dialog before asking for insertion point

## Notes

- The script expects .dwg files to be located in C:\Temp\Blocks
- Block names are derived from filenames (without the .dwg extension)
- System blocks are combined with file system blocks for a comprehensive selection
- This is a Type O (Object) script that creates insertable entities

## Version History

- **1.00 (16.07.2019)** - Initial release by Anno Sportel (support.nl@hsbcad.com)

## Prerequisites

- The C:\Temp\Blocks folder must exist
- AutoCAD drawing files (.dwg) must be placed in the specified folder to be available for selection