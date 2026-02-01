# hsb_AssignSheetsToElement

## Overview
This script assigns selected production drawing sheets to a specific structural element and categorizes them into a defined "Zone" for better management, filtering, and export processing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates in the 3D model environment to link elements and sheets. |
| Paper Space | No | Not designed for use in layout views. |
| Shop Drawing | No | This is a management tool, not a drawing generator. |

## Prerequisites
- An existing **Element** (e.g., a wall or floor assembly) in the model.
- Existing **Sheet** entities (production drawings) available in the drawing.
- No specific settings files are required.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_AssignSheetsToElement.mcr`

### Step 2: Select Element
```
Command Line: Select an Element
Action: Click on the structural Element (e.g., a wall or floor) to which you want to link the sheets.
```

### Step 3: Select Sheets
```
Command Line: Select a set of sheets
Action: Select one or multiple drawing sheets from the model or drawing list. Press Enter to confirm the selection.
```

*(Note: You may need to set the "Zone" property in the Properties Palette before selecting entities if you wish to change it from the default.)*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone to Assign the Sheets | dropdown | 0 | Select the logical grouping ID (0-10) for the assignment. This is often used to represent floors, phases, or specific construction sections. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script runs as a one-time command and does not persist in the model for editing via the context menu. |

## Settings Files
- **Filename**: N/A
- **Location**: N/A
- **Purpose**: None required for this script.

## Tips
- The script will automatically delete itself from the drawing after execution; you do not need to delete it manually.
- Use the "Zone" parameter strategically to organize your drawings. For example, assign ground floor sheets to "Zone 1" and roof sheets to "Zone 2" to easily filter production lists later.
- Selections are validated silently. If the script closes immediately without result, ensure you actually selected an Element and at least one Sheet.

## FAQ
- **Q: I ran the script, but nothing happened. Why?**
  **A:** The script requires both an Element and at least one Sheet to be selected to function. It performs a silent check and will exit if either selection is missing. Ensure you click an Element and select Sheets before pressing Enter.
- **Q: Can I use this to remove sheets from an element?**
  **A:** No, this script is designed only to assign or update the Zone association. To remove links, you would typically use other hsbCAD management tools or delete the entity links manually.