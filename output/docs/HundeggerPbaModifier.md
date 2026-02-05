# HundeggerPbaModifier.mcr

## Overview
This is an automated background script (MapIO plugin) that modifies CNC export data during the Hundegger PBA generation process. It detects MasterPanels named "special" and assigns them a specific, high-quality machining strategy ("QualityHsbTest") automatically.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script runs in the background during the export phase. |
| Paper Space | No | Not applicable for this export plugin. |
| Shop Drawing | No | This script functions at the MapIO data level, not the drawing layout level. |

## Prerequisites
- **Required Entities**: `MasterPanel` entities (e.g., Wall Panels or Roof Panels).
- **Minimum Beam Count**: N/A (Script processes panels).
- **Required Settings**: Must be executed within a Hundegger PBA export configuration that calls this MapIO script.

## Usage Steps

### Step 1: Prepare Model
- Open your project in hsbCAD.
- Select the `MasterPanel` you wish to export with the special strategy.
- Open the **Properties Palette** (Ctrl+1).
- Change the **Name** property of the panel to exactly: `special`
  - *Note: The script checks for this specific name to trigger the logic.*

### Step 2: Execute Export
- Run the Hundegger Export (PBA generation) as usual.
- The script will automatically activate in the background.
- It scans all panels; any named "special" will have their internal CNC strategy switched to "QualityHsbTest" before the file is written.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| *None* | *N/A* | *N/A* | This script has no user-editable parameters in the Properties Palette. Configuration is handled by naming the entities. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add custom options to the right-click context menu. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: The script relies on hardcoded logic (`strNameTrigger` and `BvxStrategyKey`) defined within the `.mcr` file itself.

## Tips
- **Exact Naming**: Ensure the MasterPanel name is exactly "special" (case-sensitive) without extra spaces, or the script will not recognize it.
- **No Manual Insertion**: You do not need to run `TSLINSERT` on this script in the drawing for it to work. It is triggered automatically by the export manager.
- **Batch Processing**: This script works efficiently in batch exports, allowing you to mark multiple panels as "special" to have them all updated simultaneously during the export run.

## FAQ
- **Q: I changed the name to "special", but the PBA file doesn't look different. Why?**
  - A: Ensure the Hundegger export configuration (in your Company or Project settings) actually includes this script in the MapIO chain. If the script isn't linked to the export process, it won't run.
- **Q: Can I change the trigger name from "special" to something else?**
  - A: Not via the interface. The name "special" is currently hardcoded inside the script. To change it, the script code would need to be edited by a developer.
- **Q: Does this script modify the drawing geometry?**
  - A: No. It only modifies the *data* sent to the CNC machine (the export map), leaving your CAD model geometry unchanged.