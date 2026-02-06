# hsb_SIPsRemoveSoleplateAndHeadbinder.mcr

## Overview
This script removes structural plates (soleplates and headbinders) from selected SIPs (Structural Insulated Panel) elements. It includes a filtering option to preserve specific plates based on their beam codes, allowing for exceptions like pressure-treated sill plates.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model where Elements are located. |
| Paper Space | No | Not applicable for layouts. |
| Shop Drawing | No | This script modifies the model geometry, not drawing views. |

## Prerequisites
- **Required Entities**: SIPs Wall Elements.
- **Minimum Beam Count**: None (Script processes beams contained within the selected elements).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SIPsRemoveSoleplateAndHeadbinder.mcr` from the file list.

### Step 2: Configure Exclusions (Optional)
If the script requires a specific key to run, or immediately after insertion before selection:
1. The Properties Palette may open automatically.
2. Locate the **Exclude Beams with Code** field.
3. Enter the beam codes you wish to **keep**, separated by a semicolon (e.g., `PT_SILL;HELD_PLACE`).
4. *Note: If left empty, all soleplates and headbinders will be removed.*

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the SIPs wall elements from which you want to remove plates. Press Enter to confirm selection.
```

### Step 4: Execution
1. The script will scan the selected elements.
2. It identifies beams of type "Pressure Treated Plate" or "Cap Strip".
3. It erases these beams **unless** their code matches a code entered in the Exclude list.
4. The script instance deletes itself automatically upon completion.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Exclude Beams with Code | Text | (Empty) | Enter beam codes here to prevent them from being deleted. Separate multiple codes with a semicolon (;). If empty, all matching plates are removed. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are defined for this script. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Check Beam Codes**: Before running, use the `List` command or check the Properties of a plate to ensure you use the correct text in the "Exclude Beams with Code" field.
- **Undo**: If you remove the wrong plates, simply use the standard AutoCAD `UNDO` command immediately after running the script.
- **Filtering Logic**: This script specifically looks for beam types "Pressure Treated Plate" and "Cap Strip". It will not affect standard wall studs or other structural members within the element.

## FAQ
- **Q: What happens if I leave the "Exclude Beams with Code" field blank?**
  **A:** The script will remove all soleplates and headbinders found in the selected elements.

- **Q: How do I keep a specific pressure-treated sill plate but remove the rest?**
  **A:** Find the specific beam code of that sill plate, enter it into the "Exclude Beams with Code" property, and then run the script.

- **Q: Can I use wildcards in the filter?**
  **A:** No, the script looks for exact matches of the beam code. Ensure you type the code exactly as it appears in the entity properties.