# GE_FLOOR_MARKING.mcr

## Overview
This script automates the placement of floor assembly markings on beams. It generates layout marks for assemblers, including T-connection references, beam end cut angles, and specific indicators for squash blocks.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model elements. |
| Paper Space | No | |
| Shop Drawing | No | Marks are applied to the model for downstream processing. |

## Prerequisites
- **Required Entities**: Floor Elements (specifically of type `ElementRoof`).
- **Minimum Beams**: There are no strict minimums, but the element must contain beams to generate marks.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_FLOOR_MARKING.mcr`

### Step 2: Select Floor Elements
```
Command Line: \nSelect a set of elements
Action: Click on the floor elements (Roof Elements) you wish to mark and press Enter.
```
*The script will automatically attach itself to the selected elements and process all beams within them.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script has no user-editable properties in the Properties Palette. All markings are calculated automatically based on beam geometry and catalog properties. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Standard TSL Options | Use standard commands like `Erase` to remove the script instance if needed. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Automatic Cleaning**: If you run the script on an element that already has marking instances, the script will automatically remove duplicates before adding new marks.
- **Angle Markings**: Look for angle indicators near beam ends. The script uses a `/` for positive angles and a `\` for negative angles to indicate the slope direction.
- **Squash Blocks**: The script automatically detects "Squash Blocks" (vertical blocking packs) and marks an `SB` on any joist intersecting them.
- **Floor Area**: The script updates the Element's `SubType` property with the calculated floor area (in square feet).

## FAQ
- **Q: How are Minimizer or Trimmer beams identified?**
  **A:** The script automatically identifies these beams based on their internal HSB catalog ID and applies specific short-form labels (e.g., 'B', 'S', 'C') rather than standard layout marks.

- **Q: What does the "SB" mark mean?**
  **A:** The "SB" mark indicates the location of a Squash Block. This is placed on joists where they intersect with vertical blocking packs.

- **Q: Can I edit the specific text used for the labels?**
  **A:** No, the text is derived directly from the Element Number and Beam SubLabels in the project properties.