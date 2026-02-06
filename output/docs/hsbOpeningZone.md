# hsbOpeningZone.mcr

## Overview
This script creates a rectangular machining opening (mill or saw cut) within a timber wall or floor element. It is designed for creating service holes or recesses and can dynamically resize itself when linked to crossing beams or other TSL instances.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used for creating 3D machining and visual solids. |
| Paper Space | No | Not applicable for 2D drawing generation. |
| Shop Drawing | No | Does not generate 2D views or dimensions directly. |

## Prerequisites
- **Required Entities**: An existing Element (e.g., CLT panel, stud wall) must exist in the model to apply the opening.
- **Minimum Beam Count**: 0 (but requires an Element host).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse to and select `hsbOpeningZone.mcr`.

### Step 2: Configure Properties
A properties dialog may appear upon first insertion. You can configure the initial settings here or modify them later in the Properties Palette.
- **Action**: Review settings for Zone, Width, Height, and Tool type. Click OK to proceed.

### Step 3: Select Element
```
Command Line: Select Element
Action: Click on the timber wall or floor element where you want the opening to appear.
```
- **Note**: If you do not select an element, the script instance will be automatically erased.

### Step 4: Locate Insertion Point
```
Command Line: Specify insertion point
Action: Click inside the element to place the center of the opening.
```
- The opening will be previewed at this location.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| \|Zone\| | dropdown | 5 | Specifies the construction layer (Zone index) within the element to cut. Only sheets matching this index will be machined. Range: -5 to 5. |
| \|Width\| | number | 100mm | The width of the rectangular opening. This becomes read-only if linked to a beam. |
| \|Height\| | number | 200mm | The height of the rectangular opening. This becomes read-only if linked to a beam. |
| \|Tool\| | dropdown | \|Milling\| | Selects the CNC operation type. Choose between Milling (for pockets) or Saw (for through-cuts). |
| \|Tooling Index\| | number | 0 | Specifies the tool number from the CNC machine library to use for this cut. |
| \|Overshoot\| | dropdown | \|No\| | Determines if the tool path should extend beyond the geometry corners (Overcut) to ensure clean cuts. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| \|Link to Entity\| | Prompts you to select a beam or another TSL instance. The opening will then update its size and position based on the selected object. |
| \|Remove Link\| | Prompts you to select a currently linked entity to break the dependency, restoring manual control over size and position. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Dynamic Linking**: If you link the opening to a beam crossing the element, the script automatically calculates the width and height based on the beam's cross-section. This is useful for creating precise recesses for joists or beams.
- **Zone Control**: If working with multi-layer walls (e.g., a stud wall with sheathing), ensure the **Zone** parameter matches the specific layer you wish to cut.
- **Auto-Cleanup**: If you delete the host element or a linked beam, this script instance will automatically erase itself to prevent errors.
- **Visual Feedback**: The opening creates a `SolidSubtract` in the 3D model, allowing you to visually verify the cut location before manufacturing.

## FAQ
- **Q: Why can't I change the Width or Height values?**
  A: The opening is likely linked to a beam or another TSL instance. Use the "Remove Link" context menu option to regain manual control.
- **Q: Why did the opening disappear from my model?**
  A: This happens if the host Element was deleted or if a linked entity (like a beam) was removed. You will need to re-insert the script.
- **Q: What is the difference between Milling and Saw tools?**
  A: Milling typically creates a pocket or recess (does not go all the way through), while Sawing performs a through-cut. Choose based on your construction requirements.