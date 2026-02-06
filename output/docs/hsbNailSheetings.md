# hsbNailSheetings.mcr

## Overview
This script automates the calculation and placement of nail lines for timber sheeting (such as OSB or plywood) on Elements. It generates a dynamic preview of the nailing pattern based on spacing, zones, and material filters, which can then be converted into permanent physical entities.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in 3D Model Space. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not intended for 2D drawing generation. |

## Prerequisites
- **Required Entities**: An `Element` (e.g., a wall or floor panel) containing `GenBeams` that define the sheeting zones.
- **Minimum Beams**: The Element must contain structural members (GenBeams) in the target zones to calculate nailing geometry.
- **Required Settings**: None strictly required, though a Catalog entry may be used for default settings.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `hsbNailSheetings.mcr` from the file list.

### Step 2: Configure Initial Settings
```
Dialog/Config: The script may prompt with a dialog or load default settings from the Catalog.
Action: Review settings for Zone, Spacing, and Material filters. Click OK to proceed.
```

### Step 3: Select Elements
```
Command Line: Select elements:
Action: Click on the Element(s) (walls/floors) you wish to apply sheeting nailing to. Press Enter to confirm selection.
```

### Step 4: Adjust Preview (Optional)
Once attached, the script displays a preview of the nail lines.
Action: Select the Element and open the **Properties Palette**. Modify parameters like Spacing or Offset to update the preview in real-time.

### Step 5: Generate Physical Nail Lines
Action: Right-click on the Element to open the context menu. Select **Release Naillines**.
Result: The script creates actual "NailLine" entities in the drawing and removes itself from the Element.

## Properties Panel Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| **nZone** | Integer | The specific construction zone (layer index) to apply the nailing to. |
| **Spacing** | Double | The distance between nail rows. |
| **Orientation** | Double/Angle | The direction angle of the nail lines relative to the element. |
| **Module** | Double | The offset/start point for the nailing pattern. |
| **Material Include** | String | List of materials to include. If empty, all materials are considered. |
| **Material Exclude** | String | List of materials to exclude from nailing. |
| **Color Include** | String | Filter to include only specific beam colors. |
| **Color Exclude** | String | Filter to exclude specific beam colors. |
| **Merge Gaps** | Double | Gaps smaller than this value are treated as a continuous nailing surface. |
| **Ignore Holes** | Double | Openings or holes smaller than this value are ignored in the nailing pattern. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Release Naillines** | Converts the calculated preview into permanent NailLine entities and deletes the script instance from the element. |

## Tips
- **Filtering**: Use the Material and Color filters to prevent nails from being calculated on structural studs or specific opening frames, focusing only on the sheeting material.
- **Adjacent Zones**: The script automatically checks adjacent zones (`nZone` +/- 1) to determine clean boundaries and stop nailing lines correctly at edges.
- **Updating**: If you modify the Element (e.g., move an opening), the script automatically recalculates the nailing pattern while in preview mode.
- **Cleanup**: If you re-run the script on an element that already has this script attached, it will detect the duplicate and skip it to prevent errors.

## FAQ
- **Q: I ran the script, but I don't see any nail lines.**
  - **A**: Check your **nZone** property. Ensure the GenBeams in your Element actually exist in that specific zone index. Also, verify that your Material/Color filters are not excluding all beams.
- **Q: How do I undo the nailing?**
  - **A**: You can use the standard AutoCAD `UNDO` command immediately after releasing the naillines. If the script is still attached (preview mode), you can simply delete the script instance or erase the element.
- **Q: Can I change the spacing after I release the naillines?**
  - **A**: No. Once "Release Naillines" is executed, the script is removed and the lines become standard CAD entities. To change spacing, you must re-insert the script or have a saved copy before releasing.