# Nail Battens.mcr

## Overview
This script automatically calculates and assigns nail patterns for battens attached to timber wall or floor elements. It ensures nails are placed only where the batten physically touches the main structure, adhering to specified spacing and offset rules for production data.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on Elements and GenBeams to generate production nail data. |
| Paper Space | No | This is a CAM/Modeling script, not a detailing script. |
| Shop Drawing | No | Production data is generated in the model, not on drawing views. |

## Prerequisites
- **Required Entities**: One (1) Element (e.g., a wall or floor panel) containing GenBeams.
- **Minimum Beam Count**: The Element must contain GenBeams assigned to specific zones (e.g., battens in one zone, structural beams in another).
- **Required Settings**: None (uses internal variable defaults).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `Nail Battens.mcr`.

### Step 2: Configure Properties (Optional)
If a specific "Execute Key" (preset configuration) is not selected via catalog, a configuration dialog or the Properties Palette may appear automatically upon insertion.
Action: Verify or set the default **Zone Index** and **Tool Index** for your specific project requirements.

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the timber Element (wall/floor) that contains the battens you wish to nail.
```
Action: Press `Enter` to confirm selection. The script will process the element and generate nail clusters (`ElemNailCluster`).

### Step 4: Adjust via Properties Palette (Optional)
Action: Select the script instance in the model. Use the Properties Palette (Ctrl+1) to fine-tune settings like spacing or offsets if the initial result needs adjustment.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone index battens | dropdown | 0 | Specifies the construction layer (Zone) containing the battens to be nailed. Options range from -5 to 5. Only beams in this zone will be processed. |
| Toolindex nailing | number | 1 | The machine identifier (Tool ID) for the nail gun or stapler to be used in production. |
| Maximum nail spacing | number | 400.0 | The maximum allowable distance (mm) between nails along the batten. Nails are distributed evenly but will never exceed this gap. |
| Offset from batten end | number | 100.0 | The clearance distance (mm) from both ends of the batten where no nails will be placed. Prevents splitting near the edges. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are added by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies entirely on the properties defined in the Properties Palette; no external XML settings files are required.

## Tips
- **Zone Setup**: Ensure your Element composition (Layers/Zones) is set up correctly. The script looks for geometric contact between the beams in the "Batten Zone" and the main structure beams (often Zone 0 or the "Brander").
- **Visualization**: If nails are not appearing, check the Element Number in the command line history. It may report "No valid branders found," which implies the battens are not physically touching the main structure beams in the model.
- **Production Data**: The generated objects are `ElemNailCluster` entities. These are visible in hsbCAD production lists but may not have a distinct graphical representation in standard AutoCAD views unless a specific layer style is active.

## FAQ
- **Q: Why did the script erase itself immediately after running?**
  A: This is normal behavior for single-instance scripts. The logic creates a new instance attached to the selected Element and removes the temporary insertion instance. Check the Element you selected; the script should now be listed under its associated TSL instances.
  
- **Q: The nails are too far apart. How do I fix this?**
  A: Select the script instance and lower the **Maximum nail spacing** value in the Properties Palette. The script will automatically redistribute the nails to be closer together.

- **Q: Why are no nails generated on my battens?**
  A: Check the **Zone index battens** property. It must match the exact zone index where your batten beams are defined. Also, ensure the battens are actually intersecting or touching the main structural beams of the element.