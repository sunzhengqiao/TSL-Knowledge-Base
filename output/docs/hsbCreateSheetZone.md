# hsbCreateSheetZone

## Overview
This script creates a new sheeting layer or modifies an existing one based on a selected reference zone and an optional polyline contour. It is ideal for creating local reinforcement patches (e.g., thicker wet area boards) or adding a new material layer to specific parts of a wall or floor.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the 3D Model Space where Elements exist. |
| Paper Space | No | Not applicable for layouts or drawings. |
| Shop Drawing | No | This is a construction/creation script, not a detailing script. |

## Prerequisites
- **Required Entities**: An existing **Element** (Wall, Floor, or Roof) that has at least one active zone (thickness > 0).
- **Minimum Beam Count**: 0.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `hsbCreateSheetZone.mcr`, then click **Open**.

### Step 2: Select Element
```
Command Line: Select element
Action: Click on the timber Element (Wall/Floor) you wish to modify.
```

### Step 3: Select Contour (Optional)
```
Command Line: Select polyline(s) which describe the contour to be changed (optional)
Action: 
- To modify the ENTIRE zone: Press **Enter** or **Space**.
- To modify a SPECIFIC AREA: Select one or more Polylines that define the boundary, then press **Enter**.
```

### Step 4: Configure Properties
Action: The **TSL Properties** dialog appears automatically.
1.  **Reference Zone**: Select which existing layer acts as the base (e.g., -1 for Exterior Sheathing).
2.  **Position of new sheet**: Choose whether to integrate the change into the existing zone or add it "On Top" (creating a new layer).
3.  Adjust **Thickness**, **Material**, **Grade**, and **Color** as needed.
4.  Click **OK**.

### Step 5: Build Construction
Action: Run `Construct` (or `Generate Construction`) on the element. The script will generate or cut the sheets based on your inputs.

---

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Reference zone | Dropdown | First available | Selects the existing material layer index (e.g., Zone -1, 1) to use as the geometric base. |
| Position of new sheet | Dropdown | Integrated in reference zone | Determines how the new sheets interact with the wall.<br>• **Integrated**: Modifies the existing zone directly.<br>• **On Top of Reference Zone**: Creates a new zone adjacent to the reference zone and shifts other sheets to make room. |
| Thickness | Number | 0 | The thickness of the new sheet material (in millimeters). |
| Name | Text | [Empty] | The logical name for the sheet (e.g., "OSB Patch"). |
| Material | Text | [Empty] | The material code for the sheet (e.g., "OSB/3"). Must exist in your catalog. |
| Grade | Text | [Empty] | The quality grade of the material (e.g., "C24"). |
| Color | Number | 0 | The AutoCAD color index (0-255) used to display the sheet in the model. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add custom context menu items. Use the Properties Palette to modify settings. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies entirely on the Element's existing zones and user input; no external XML settings files are required.

## Tips
- **Partial Modifications**: Draw your polyline on the exact plane of the reference zone to ensure the intersection is calculated correctly.
- **Layering**: Use the **"On Top of Reference Zone"** option when you need to add a specific layer (like a secondary sheathing board) without deleting or cutting the original primary sheeting.
- **Restoring Defaults**: If you delete the Element, the script attempts to restore the original zone settings that existed before the script was applied.
- **Visibility**: Once the construction is built, the script instance itself is resident but hidden; you only see the resulting Sheets.

## FAQ
- **Q: What happens if I do not select a polyline?**
  **A:** The script will apply the new settings to the *entire* area of the selected Reference Zone.
  
- **Q: How do I add a wet area board that is thicker than the rest of the wall?**
  **A:** Select the interior sheathing zone as the Reference, draw a polyline around the wet area, set the new Thickness, and select **"On Top of Reference Zone"**. This pushes the standard boards out and places the thicker board in the specific area.

- **Q: Why did the script disappear after I inserted it?**
  **A:** This is a "Resident" script. It attaches itself to the Element group and remains active even if not visibly selectable. You can modify its settings via the Element's properties.