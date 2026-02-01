# GE_TRUSS_INFO_REACTION_UPLIFT.mcr

## Overview
A utility tool that extracts and reports the Reaction Magnitude and Maximum Vertical Uplift values for selected timber roof trusses. It is designed to quickly verify structural loads for connection design and compliance.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the model where trusses are located. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Not intended for shop drawing generation. |

## Prerequisites
- **Required Entities**: At least one `TrussEntity` (hsbCAD Truss) present in the model.
- **Component Requirement**: The selected trusses must contain the internal script or component named **"Alpine-BearingReaction"**.
- **Minimum Beams**: 1 Truss Entity.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse and select `GE_TRUSS_INFO_REACTION_UPLIFT.mcr`

### Step 2: Select Trusses
```
Command Line: Select truss(es)
Action: Click on one or multiple roof trusses in the 3D model or 2D plan, then press Enter.
```

### Step 3: View Results
```
Command Line/Log: The script will output the "Reaction Magnitude" and "Max Vertical Uplift" for each valid truss processed.
Action: Check the F2 text history window or the command line prompt to read the reported values.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not use Properties Panel parameters. It runs via command line interaction only. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add custom items to the right-click context menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external settings files. It reads data directly from the selected truss entities.

## Tips
- **Data Availability**: If the report returns no data for a specific truss, ensure the truss was generated or updated with the **Alpine-BearingReaction** calculation component enabled.
- **Self-Deleting**: This script is a "query" tool. It automatically deletes itself from the drawing immediately after running to keep your drawing clean. You do not need to manually erase it.
- **Batch Processing**: You can select multiple trusses in a single window selection to get a report for all of them at once.

## FAQ
- **Q: Why does the report say "Missing Data" or show no values?**
  **A:** The selected truss does not contain the "Alpine-BearingReaction" script/map. You may need to regenerate or update the truss calculation settings to include this component.
- **Q: Where can I see the results if they scrolled off the screen?**
  **A:** Press `F2` in AutoCAD to open the Text Window, where you can scroll up to review previous command line history and reports.
- **Q: Can I modify the uplift values using this script?**
  **A:** No, this script is read-only. It only extracts and displays values calculated by the truss generation process.