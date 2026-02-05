# HSB_G-NailingInformation.mcr

## Overview
This script generates a material take-off report for nail quantities used in the current drawing. It calculates the total number of nails required, grouped by the nail tool index, and displays the summary directly in the command line.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script analyzes entities in the 3D model. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This script analyzes the model, not drawing views. |

## Prerequisites
- **Required entities**: Elements (timber components) containing nail information.
- **Minimum beam count**: 0.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-NailingInformation.mcr`

### Step 2: Automatic Execution
```
Command Line: [Calculates total nails...]
Action: The script runs immediately upon insertion. No further user input is required.
```

### Step 3: View Results
```
Command Line: Press F2 to open the Text Window
Action: Review the generated list of Tool Indices and the total rounded-up quantity of nails for each index.
```
*Note: The script instance will automatically remove itself from the drawing after generating the report.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script has no user-editable properties. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | No context menu options are configured for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Check the Command Line**: The output is displayed in the AutoCAD command line history. If the list is long, press **F2** to open the full Text Window.
- **Nail Calculation Logic**: The script calculates the quantity based on `(Path Length / Spacing)` and rounds the result up to the nearest whole number for reporting.
- **Self-Cleaning**: Do not be alarmed if the script entity disappears immediately; this is intentional behavior to keep your drawing clean.

## FAQ
- **Q: Where is the report saved?**
  - A: The report is not saved to a file. It is output directly to the AutoCAD command line console.
- **Q: Why did the block disappear after I inserted it?**
  - A: The script is designed to calculate data and then delete itself (`eraseInstance`) automatically to prevent cluttering the drawing.
- **Q: Does it count nails in Shop Drawings?**
  - A: No, it only scans for nail data within the Model Space Elements.