# HVAC-Copy.mcr

## Overview
Duplicates an existing HVAC ductwork system to a new location while preserving geometry, sequence, and internal connections (G-connections). This is useful for replicating complex duct assemblies without manually redrawing them.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Not applicable for generating drawings. |

## Prerequisites
- **Required Entities:** An existing HVAC System (TSL Instance) already present in the model.
- **Minimum Beams:** The source HVAC system must contain at least one generated beam.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HVAC-Copy.mcr` from the list.

### Step 2: Select Source HVAC System
```
Command Line: Select an HVAC system
Action: Click on the existing HVAC TSL instance (the blue bounding box/grips of the HVAC system) that you want to copy.
```

### Step 3: Pick Reference Point
```
Command Line: Pick reference location near the HVAC system
Action: Click a point near the specific segment of the source ductwork you wish to align from.
Note: This point determines the "handle" and orientation of the copy. The script will snap to the closest beam segment.
```

### Step 4: Select New Location
```
Command Line: Select new location
Action: Click the point in the model where you want the new HVAC system to be placed.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose editable parameters in the Properties Palette. All inputs are collected via the command line during insertion. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add specific custom options to the right-click context menu. |

## Settings Files
None required. This script operates independently of external settings files.

## Tips
- **Precise Alignment:** When picking the reference point (Step 3), select a point near the specific duct segment that defines the direction you want to copy. The script uses the closest segment to calculate the rotation.
- **Automatic Connections:** You do not need to manually re-create the bends or connections. The script automatically inserts 'HVAC-G' connectors where beams are orthogonal (90 degrees) to each other.
- **Independent Copy:** Once created, the new HVAC system is fully independent. Modifying the original system will not update the copy.

## FAQ
- **Q: I selected an object but got the error "no valid hvac found". Why?**
  A: You must select the specific HVAC TSL instance (the logical container), not just individual timber beams or lines within the ductwork.
- **Q: Does this script copy the dimensions of the ducts?**
  A: Yes. The new system is an exact geometric duplicate of the source system at the moment of copying.
- **Q: Can I use this to copy systems between different floors?**
  A: Yes, provided you can see/select the source system and pick a 3D point on the target floor in the current view.