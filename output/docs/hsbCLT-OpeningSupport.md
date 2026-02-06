# hsbCLT-OpeningSupport.mcr

## Overview
This script automatically generates and visualizes crosspiece supports (lintels or cripples) for openings and doors in CLT/SIP panels. It allows for various insertion modes to reinforce specific opening types or define custom support lines to ensure structural integrity.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D panel entities (Sip) and requires a Model Space environment. |
| Paper Space | No | Not supported for sheet layouts. |
| Shop Drawing | No | Not intended for 2D shop drawing generation. |

## Prerequisites
- **Required entities:** Sip (Structural Insulated Panel or CLT Panel).
- **Minimum beam count:** 0.
- **Required settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-OpeningSupport.mcr`

### Step 2: Configure Properties
Upon insertion, the "Insert TSL" dialog appears. Adjust parameters like **Width**, **Alignment**, and **Opening Mode** (see Parameters below) before clicking OK.

### Step 3: Select Elements
The prompts depend on the selected **Opening Mode**:

**If Mode is "All", "Window", or "Door/Edge":**
```
Command Line: |Select panels|
Action: Select one or more Sip (panels) in the model.
```
*The script will automatically detect and process relevant openings in the selected panels.*

**If Mode is "bySelection":**
```
Command Line: |Select panels|
Action: Select a single Sip entity.
Command Line: |Select opening by a point inside or on the opening|
Action: Click inside the specific opening you wish to support.
```

**If Mode is "byLine":**
```
Command Line: |Select panels|
Action: Select a single Sip entity.
Command Line: |Pick start point of support|
Action: Click to set the start of the support line.
Command Line: |Pick end point of support|
Action: Click to set the end of the support line.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Width | Number | 200 | Defines the width (depth) of the support perpendicular to the supporting direction. |
| Alignment | Dropdown | Automatic | Sets the orientation of the support. Options: **Automatic** (Perpendicular to open direction/longest side), **Horizontal**, or **Vertical**. |
| Offset | Number | 0 | Moves the support position away from the center of the opening or edge, perpendicular to the selected alignment. |
| Opening Mode | Dropdown | All | Filters openings by type or selection method. Options: **All**, **bySelection**, **Window**, **Door/Edge**, **byLine**. |
| MinDimension | Number | 0 | Sets the minimum size threshold for the opening dimension perpendicular to the alignment. Smaller openings are ignored. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Remove Support | Cuts the support shape permanently into the panel geometry as an opening and deletes the script instance. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies entirely on OM (Object Model) properties and does not require external XML settings files.

## Tips
- **Automatic Alignment:** In "Door/Edge" mode, Automatic alignment places the support perpendicular to the door swing direction. In "Window" mode, it places it perpendicular to the longest dimension of the opening.
- **Custom Supports:** Use the **byLine** mode if you need to place a support in a location that is not an existing opening or requires precise manual definition.
- **Finalizing Geometry:** Remember to use the **Remove Support** context menu when you are ready to physically cut the hole into the CLT panel for manufacturing. Until then, the script acts as a visual indicator.

## FAQ
- **Q: Can I change the support size after inserting it?**
  - A: Yes. Select the script instance in the model and modify the **Width** or **Offset** values in the Properties Palette. The geometry will update automatically.
- **Q: What happens if I cancel a point prompt during "byLine" mode?**
  - A: The script will execute `eraseInstance()` and terminate immediately without creating any objects.
- **Q: The script didn't generate a support on my selected opening. Why?**
  - A: Check the **MinDimension** property. If the opening is smaller than the value set here, the script will skip it.