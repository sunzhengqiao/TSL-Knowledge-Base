# GE_WDET_CLEANUP_SPECIAL_LUMBERS.mcr

## Overview
Automates the cleanup of wall elements by deleting temporary void filler beams and highlighting borate-treated timber in green. This script runs once upon insertion and removes itself from the drawing immediately after processing.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script targets Wall/Floor Elements in the 3D model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Not applicable for 2D drawing generation. |

## Prerequisites
- **Required entities**: Wall or Floor Elements must exist in the drawing.
- **Minimum beam count**: 0 (The script processes beams inside the selected elements).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse to the script location and select `GE_WDET_CLEANUP_SPECIAL_LUMBERS.mcr`.

### Step 2: Select Elements
```
Command Line: Select Element (s)
Action: Click on the Wall or Floor elements you wish to clean up. You can select multiple elements. Press Enter to confirm selection.
```

### Step 3: Automatic Processing
The script will automatically process the selected elements:
1. It scans every beam within the selected elements.
2. **Cleanup**: Any beam containing "VOID" in its code name is permanently deleted.
3. **Highlighting**: Any beam assigned the grade "BORATE" is recolored to **Green**.
4. The script instance erases itself automatically from the drawing once complete.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script erases itself after execution, leaving no properties to edit. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | The script runs once and deletes itself; no context menu options are available. |

## Settings Files
- **Filename**: None used.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Undo Capability**: If the script deletes the wrong beams, use the standard AutoCAD `UNDO` command immediately to restore the elements.
- **Workflow**: Run this script after importing walls or generating initial layouts to remove temporary construction aid beams (voids) before proceeding to detailing or manufacturing.
- **Visual Check**: The Green color (Index 3) for Borate timber helps visually identify treated wood forCAM output or shop drawings.

## FAQ
- **Q: Why did the script disappear after I ran it?**
  **A:** This is a "utility" script designed to perform a specific task once. It automatically removes its instance from the drawing database to keep your project clean.
- **Q: What happens if I select nothing?**
  **A:** If you cancel the selection or pick no elements, the script will detect this and erase itself without making any changes.
- **Q: How does the script identify which beams to delete?**
  **A:** It looks strictly at the beam's Code (Name). If the text "VOID" appears anywhere in the code, that beam is deleted.