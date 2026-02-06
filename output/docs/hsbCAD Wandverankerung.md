# Wandverankerung (Wall Anchoring)

## Overview
This script generates wall anchoring angles (steel brackets) and automatically creates the necessary timber cutouts, millings, and sheet material clearances to accommodate them. It supports various manufacturer types (e.g., Simpson, BMF) and handles CNC output definitions.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in 3D model space. |
| Paper Space | No | Cannot be inserted into Layouts. |
| Shop Drawing | No | Not a shop drawing generation script. |

## Prerequisites
- **Required Entities**: A single timber Wall Element (e.g., an outer wall).
- **Minimum Beam Count**: N/A (Requires an Element, not individual beams).
- **Required Settings**: None. (Manufacturer geometry is built-in).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Wandverankerung.mcr` from the file list.

### Step 2: Select Wall Element
```
Command Line: Select Element:
Action: Click on the timber wall element where the anchor will be applied.
```

### Step 3: Define Insertion Point
```
Command Line: Give point on element:
Action: Click a specific point on the face or surface of the selected element.
```
*Note: The script calculates the anchor orientation based on the local coordinate system of the element at this point.*

### Step 4: Configure Anchor (Optional)
After insertion, select the newly created anchor and open the **Properties Palette** (Ctrl+1) to adjust the type, dimensions, and layer visibility as needed.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Type** (sType) | Dropdown | Z1 | Select the manufacturer and model of the anchor (e.g., Simpson HTT22, BMF 90 R). This sets the geometry size. |
| **Layer** (sLayer) | Dropdown | I-Layer | Sets the CAD layer for visibility control (Plan, Section, Elevation, or 3D). |
| **Depth** (dDepth) | Number | 4 mm | The distance the metal bracket is recessed into the timber element relative to the surface. |
| **Width Milling** (dWidth) | Number | 0 mm | Width of the timber cutout. Set to `0` to automatically use the bracket's actual width. |
| **Offset** (dOffset) | Number | 0 mm | Vertical offset of the anchor relative to the element's origin. |
| **Lower Milling-Line** (sMill) | Yes/No | No | **Yes**: Creates a fully enclosed pocket (closed bottom). **No**: Creates an open slot. |
| **Show Text** (sNY) | Yes/No | Yes | Toggles the visibility of the anchor annotation label. |
| **Tool Zone [1-5]** | Dropdown | Saw/Mill | Selects the CNC operation for each construction zone (Saw, Mill, or None). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Refresh** | Recalculates the geometry based on current properties or if the wall element has moved. |
| **Delete** | Removes the anchor and associated operations from the element. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A.
- **Purpose**: All anchor dimensions and geometric rules are internal to the script.

## Tips
- **Auto-Sizing**: Keep the **Width Milling** property set to `0` to ensure the cutout always matches the width of the selected steel bracket type exactly.
- **Moving Anchors**: Use the **Grip Point** (usually visible at the insertion point) to drag the anchor along the wall. The timber cutouts will update automatically.
- **Element Updates**: Since the anchor is assigned to the element group, copying or moving the parent wall element will automatically move the anchor with it.
- **CNC Optimization**: Use the **Tool Zone** properties to switch between Sawing (faster) and Milling (for complex shapes) for specific cladding layers.

## FAQ
- **Q: Why is there no cutout in my cladding/boarding?**
- A: Check that the relevant **Zone [1-5]** properties have a height defined in your element construction, and ensure the **Tool** for that zone is not set to "None".

- **Q: How do I switch between a simple slot and a pocket?**
- A: Toggle the **Lower Milling-Line** property. "No" creates a slot (open), while "Yes" closes the bottom of the cutout to make a pocket.

- **Q: Can I use this for floor connections?**
- A: Yes, provided you select a timber element (wall or floor) and define the insertion point on the correct face. The script is orientation-agnostic based on the element's local axes.