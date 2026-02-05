# HSB_I-ShowGroupingInformation.mcr

## Overview
This script generates a visual text report in the ModelSpace that displays the hierarchy and sequence of grouped elements (parent-child relationships) based on HSB_ MapX data. It is typically used to verify that complex grouping logic, such as stacking or assembly orders, has been applied correctly to elements before generating manufacturing data.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The report is generated in the 3D model environment. |
| Paper Space | No | Not supported for layouts. |
| Shop Drawing | No | This is a model visualization tool. |

## Prerequisites
- **Required Entities**: Entities within the current group must possess HSB_ grouping MapX data (specifically keys containing 'CHILD' and 'PARENT').
- **Minimum Beam Count**: 0 (However, grouped elements are required to generate a visible report).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_I-ShowGroupingInformation.mcr`

### Step 2: Select Position
```
Command Line: Select a position
Action: Click anywhere in the ModelSpace to define where the grouping report list will be placed.
```

## Properties Panel Parameters
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| None | N/A | N/A | This script does not expose any editable parameters in the Properties Palette. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | N/A |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Relocating the Report**: You can move the generated text list by selecting the script instance and using the standard AutoCAD **Move** command or dragging the grip point associated with the insertion location.
- **Data Verification**: If the script only draws the "PROJECT GROUPS" header but lists no data, check that your elements actually have the required MapX attributes (keys starting with 'HSB_' and ending with 'CHILD' or 'PARENT').
- **Organization**: The report automatically sorts children by sequence number and then by Parent UID, making it easier to read complex hierarchies.

## FAQ
- **Q: Why does the report only show "PROJECT GROUPS" and nothing else?**
- **A**: The script runs silently if it cannot find valid data. Ensure the elements in the group have the specific HSB_ MapX attributes (containing 'CHILD' and 'PARENT') required for the report.

- **Q: Can I change the text size or formatting of the report?**
- **A**: No, the text size and formatting are hardcoded within the script logic. You can scale the entire report by scaling the script instance if necessary, but individual font properties are not editable via the properties panel.