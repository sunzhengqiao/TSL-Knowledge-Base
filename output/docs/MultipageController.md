# MultipageController

## Overview

**MultipageController** is a shop drawing optimization tool that automatically purges redundant dimension lines and realigns existing dimension lines on multipage shop drawings. It helps maintain clean, consistent dimensioning across your timber construction documentation.

| Property | Value |
|----------|-------|
| Script Type | O-Type (Object) |
| Version | 1.2 |
| Last Updated | January 21, 2025 |
| Beams Required | 0 |

## Description

This tool streamlines the management of dimension lines in hsbCAD shop drawings. It can:

- **Purge duplicate dimensions**: Automatically remove redundant dimension lines that display the same measurements
- **Realign dimensions**: Organize dimension lines with consistent spacing from the drawing objects and between each other
- **Filter by orientation**: Target specific dimension line orientations (horizontal, vertical, aligned, or by position)

The script supports three operating modes depending on your selection:
1. **Page Mode**: Select multipages to process all dimension lines on those pages
2. **Dimline Mode**: Select individual dimension lines to process only those specific dimensions
3. **Block Space Mode**: Insert in the multipage block definition to automatically apply settings to all newly generated shop drawings

## Properties

### Dimline Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Alignment Filter | String (List) | Any | Filters dimension lines by their orientation. Options: Any, Horizontal, Vertical, Bottom, Top, Left, Right, Aligned |
| Purge Dimlines | String (Yes/No) | Yes | When set to Yes, removes duplicate dimension lines that contain identical measurements |
| Realign Dimlines | String (Yes/No) | Yes | When set to Yes, repositions dimension lines according to the offset settings below |
| Baseline Offset | Double | 0 mm | Distance from the first dimension line to the dimensioned object. Set to 0 to keep unchanged |
| Intermediate Offset | Double | 0 mm | Spacing between consecutive dimension lines when multiple dimensions exist on the same side |

**Note**: The Baseline Offset and Intermediate Offset properties are only visible when "Realign Dimlines" is set to Yes.

## Usage Workflow

### Method 1: Process Existing Multipages

1. **Start the command**
   - Type the command or access MultipageController from the TSL menu

2. **Configure settings in the dialog**
   - Set the **Alignment Filter** to target specific dimension orientations, or leave as "Any" to process all
   - Enable/disable **Purge Dimlines** based on whether you want to remove duplicates
   - Enable/disable **Realign Dimlines** and set offset values if you want consistent spacing

3. **Select objects**
   - Select one or more multipages to process all their dimension lines
   - Alternatively, select individual dimension lines to process only those specific dimensions

4. **Wait for processing**
   - The script will analyze, purge (if enabled), and realign (if enabled) the dimension lines
   - A message will confirm when optimization is complete

### Method 2: Configure for New Shop Drawings (Block Space Mode)

Use this method to automatically apply dimension optimization settings to all future shop drawings generated from a multipage block definition.

1. **Enter the multipage block space**
   - Open the block definition that contains your shop drawing views

2. **Start MultipageController**
   - The script will detect you are in block space

3. **Select shop drawing viewports**
   - Select the viewports you want the optimization to apply to
   - Press Enter without selection to include all viewports

4. **Pick an insertion point**
   - Click to place the controller instance

5. **Automatic application**
   - When new shop drawings are generated, the controller will automatically purge and realign dimension lines according to your settings

## Context Menu Commands

When the MultipageController instance is placed in block space, the following context menu commands are available:

| Command | Description |
|---------|-------------|
| **Add View** | Add additional shop drawing viewports to the optimization scope |
| **Remove View** | Remove a viewport from the optimization scope (available only when multiple views are selected) |

## Alignment Filter Options

| Filter | Description |
|--------|-------------|
| Any | Process all dimension lines regardless of orientation |
| Horizontal | Process only horizontal dimension lines |
| Vertical | Process only vertical dimension lines |
| Bottom | Process horizontal dimension lines positioned below the object |
| Top | Process horizontal dimension lines positioned above the object |
| Left | Process vertical dimension lines positioned to the left of the object |
| Right | Process vertical dimension lines positioned to the right of the object |
| Aligned | Process dimension lines that are neither horizontal nor vertical |

## Technical Notes

- The script automatically erases itself after processing in Page Mode and Dimline Mode
- In Block Space Mode, the controller remains as a persistent instance that triggers during shop drawing generation
- Local dimension lines (flagged as "IsLocal") are excluded from purging operations to prevent removal of intentionally placed local dimensions
- The script works with the **DimLine** TSL script for dimension line operations

## Supported Environments

- **Model Space**: Full functionality with multipage and dimension line selection
- **Block Space**: Configuration mode for automatic application to new shop drawings
- **Paper Space**: Currently not supported (will display a notice message)
