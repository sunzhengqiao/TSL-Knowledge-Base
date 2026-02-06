# SetElementVisibility

## Overview
A utility script to bulk manage the visibility of hsbCAD element groups in the model. It filters elements by storey (floor level) and structural type (e.g., roof, walls) to hide or show them instantly.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be run in Model Space where hsbCAD Elements exist. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required entities**: hsbCAD Elements (Walls, Roofs) existing in the Model Space.
- **Minimum beam count**: 0.
- **Required settings**: None.
- **Note**: Elements should be organized in Groups using standard hsbCAD naming conventions (House, Storey/Floor, Part) for the Storey filter to function correctly.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or insert via Catalog/Tool Palette) → Select `SetElementVisibility.mcr`

### Step 2: Configure Options
```
Dialog / Properties Palette: SetElementVisibility options appear.
Action: The script automatically scans the drawing to identify existing Storeys.
```

### Step 3: Select Parameters
1.  **Storey**: Select the specific floor level (e.g., "GF", "1F") from the dropdown, or leave as "Select All" to target the entire model.
2.  **Element Filter**: Choose the specific type of construction to modify (e.g., "Walls (exterior)", "Roof", "Floor/Ceiling").
3.  **Set Visibility**:
    *   Choose **On** to make elements visible.
    *   Choose **Off** to hide elements.
    *   Choose **toggle state** to invert the current visibility of the matched elements.

### Step 4: Apply Changes
Action: Click OK in the dialog or close the Properties Palette. The view regenerates, and the script instance automatically deletes itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Storey** | dropdown | Select All | Selects the specific floor level to process. The list is generated dynamically from the Group names in the current model. |
| **Element Filter** | dropdown | Select All | Filters elements by structural type. Options include Floor/Ceiling, Roof, or specific Wall types (Interior/Exterior). |
| **Set Visibility** | dropdown | toggle state | Determines the action to perform. Options are "toggle state" (inverts current state), "On", or "Off". |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are defined for this script. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Isolating Floors**: Use the "Storey" dropdown combined with "Set Visibility: On" to quickly display only the ground floor while hiding upper levels.
- **Presentation**: Use the "toggle state" option to quickly flip the visibility of a specific category (like Roofs) without checking if they are currently on or off.
- **Script Behavior**: The script automatically erases itself after running. If you need to make changes again, simply re-insert the script.

## FAQ
- **Q: Why is "Select All" the only option in the Storey list?**
  **A**: This usually means the script could not find standard Group names in the model. Ensure your elements are grouped using the standard hsbCAD convention (House, Storey, Part).

- **Q: Where did the script go after I clicked OK?**
  **A**: The script is designed to erase itself immediately after applying the visibility changes to keep your drawing clean. Re-insert it to perform another operation.