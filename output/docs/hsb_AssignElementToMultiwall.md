# hsb_AssignElementToMultiwall.mcr

## Overview
This script groups multiple wall elements into a logical "Multiwall" assembly and labels them with a specific prefix and sequence number (e.g., "HOUSE1-1", "HOUSE1-2"). This aids in production tracking, filtering, and Bill of Materials (BOM) export.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | This is not a detailing script. |

## Prerequisites
- **Required entities**: ElementWall entities (Timber walls).
- **Minimum beam count**: N/A (Script operates on Wall Elements, not beams).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `hsb_AssignElementToMultiwall.mcr`.

### Step 2: Configure Group Properties
```
Dialog: Script Properties
Action: Enter the 'Prefix' (e.g., A, B, MW) and select a 'Dim style' for the text label.
```
*Note: This dialog appears immediately upon insertion.*

### Step 3: Select Walls
```
Command Line: Please select Walls
Action: Click to select one or multiple wall elements in the model, then press Enter.
```
*Note: The script will automatically number the walls in the order you select them (1, 2, 3...).*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| strPrefix | Text | [Empty] | The alphanumeric identifier for the group (e.g., "UNIT1"). This appears as the first part of the label. |
| nSequence | Number | 0 | The index number of the specific wall within the group (e.g., 1, 2). This forms the second part of the label. |
| sDimStyle | Dropdown | [Current] | The text style used to display the 3D label on the wall. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add custom context menu options. Use the Properties Palette to edit settings. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Bulk Numbering**: You can select all walls for a specific house or unit in one go. The script will automatically assign sequence numbers 1, 2, 3, etc., based on the selection order.
- **Updating Labels**: To change the prefix or fix a number, simply select the wall, open the Properties palette (Ctrl+1), and modify the `strPrefix` or `nSequence` fields. The 3D label will update instantly.
- **Overwriting**: If you run the script on walls that already have this assignment, it will automatically remove the old assignment and apply the new one.

## FAQ
- **Q: Can I use this on beams or roof elements?**
  - A: No, this script is designed specifically for `ElementWall` entities.
- **Q: How do I change the text size of the label?**
  - A: Modify the `sDimStyle` property in the Properties Palette to a different dimension style defined in your CAD standard.
- **Q: What happens if I move the wall?**
  - A: The label is calculated relative to the wall's position and will move with it automatically.