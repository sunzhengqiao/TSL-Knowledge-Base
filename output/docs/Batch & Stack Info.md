# Batch & Stack Info

## Overview
This script generates a visual schedule in Model Space that organizes Elements by their assigned Batch and Stacking groups. It is used to verify production planning and logistics by displaying Batch names, Stack headers, and Element numbers in a structured list.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script collects data from all Elements in Model Space and draws the report there. |
| Paper Space | No | Not designed for Paper Space usage. |
| Shop Drawing | No | Does not process shop drawing layouts or views. |

## Prerequisites
- **Required Entities**: Elements must exist in the Model Space.
- **Minimum Beam Count**: 0 (The script will run but may produce an empty list if no elements exist).
- **Required Settings**: Elements must possess valid Batch and Stacking data in their properties (specifically `subMapX` attributes starting with 'HSB_...CHILD').

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Batch & Stack Info.mcr` from the file list.

### Step 2: Select Insertion Point
```
Command Line: |Select a position|
Action: Click anywhere in the Model Space to set the top-left anchor point for the report.
```
*After clicking, the script will calculate and draw the Batch/Stack hierarchy immediately.*

## Properties Panel Parameters

This script has no user-editable properties in the Properties Palette (OPM).

## Right-Click Menu Options

This script has no custom context menu options.

## Settings Files

None required.

## Tips
- **Moving the Report**: Select the script object in the drawing and drag the grip point (the original insertion point) to a new location. The list will automatically redraw at the new position.
- **Updating the List**: If you modify Batch or Stack assignments on your elements, simply run a regeneration command (e.g., `TSL REGEN` or modify the script instance properties) to refresh the visual list.
- **Data Validation**: The script checks data integrity. If you see a warning on the command line stating an element is "part of a stack but not in a batch," check the properties of that specific element.

## FAQ

- **Q: Why does my list look empty or incomplete?**
- **A**: Ensure your elements have valid Batch names assigned in their data. Elements without a Batch assignment will be skipped by the report.

- **Q: How do I change the size of the text?**
- **A**: The text size is determined by the script's internal logic. Currently, there are no exposed parameters to change the font size via the Properties Panel.

- **Q: Can I use this in a Layout (Paper Space)?**
- **A**: No, this script only reads elements from Model Space and draws the report there.