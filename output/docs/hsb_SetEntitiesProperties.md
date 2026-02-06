# hsb_SetEntitiesProperties.mcr

## Overview
A batch utility tool to modify or standardize common attributes (Name, Material, Grade, Labels, etc.) across multiple selected timber beams or sheets in one operation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model elements (GenBeams/Sheets). |
| Paper Space | No | Not applicable for 2D drawings or layouts. |
| Shop Drawing | No | This is an action script for the 3D model, not shop drawing generation. |

## Prerequisites
- **Required Entities**: GenBeam (Beams, Sheets, or Columns).
- **Minimum Beam Count**: 1 (You must select at least one valid element).
- **Required Settings**: None (Script includes internal logic to save last used settings).

## Usage Steps

### Step 1: Launch Script
```
Command: TSLINSERT
Action: Select 'hsb_SetEntitiesProperties.mcr' from the file list and click Open.
```

### Step 2: Configure Properties
```
Interface: Dynamic Dialog
Action: A dialog box appears. Enter the values you wish to apply to the selected elements.
Note: Leave a field empty to keep the existing value of the element for that specific property.
```
*   **Name**: Update the element name.
*   **Material**: Change the material profile.
*   **Color**: Change the display color (Enter -1 to keep current color).
*   **Grade**: Update the structural grade.
*   **Information**: Add specific comments or notes.
*   **Label / Sublabel / Sublabel2**: Update part marks and identifiers.
*   **Beamcode**: Change the functional classification code.

### Step 3: Select Entities
```
Command Line: Select entities
Action: Click on individual beams or use a window selection to choose multiple beams/sheets. Press Enter to confirm selection.
```

### Step 4: Application
```
System Action: The script automatically updates the properties of all selected elements and then removes itself from the drawing.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sName | Text | "" | The logical name or description of the entity. Leave blank to keep existing. |
| sMaterial | Text | "" | The timber material profile to apply. Leave blank to keep existing. |
| nColor | Number | -1 | The visual color index (1-255). Use -1 to keep the existing color. |
| sGrade | Text | "" | The structural strength grade (e.g., C24). Leave blank to keep existing. |
| sInformation | Text | "" | User-defined comments or instructions. Leave blank to keep existing. |
| sLabel | Text | "" | The primary part mark for drawings and production. Leave blank to keep existing. |
| sSublabel | Text | "" | A secondary classification or part mark. Leave blank to keep existing. |
| sSublabel2 | Text | "" | A tertiary classification or part mark. Leave blank to keep existing. |
| sBeamcode | Text | "" | Functional code classifying the element type (e.g., Stud, Plate). Leave blank to keep existing. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | This is an Action Script. It executes once and erases itself; it does not persist in the model to offer right-click context menu options. |

## Settings Files
- **Internal Catalog**: `_LastInserted`
- **Location**: Internal hsbCAD Catalog memory.
- **Purpose**: Remembers the properties used in the last run so they are pre-filled the next time the script is executed.

## Tips
- **Partial Updates**: You do not need to fill in every field. Only fields with data entered will be updated on the selected beams. Fields left empty will preserve the beam's current data.
- **Color Reset**: If you want to reset the visual color of beams to their default layer color, type `0` in the Color field (or check specific hsbCAD behavior for color index 0/ByBlock).
- **Batch Selection**: You can select hundreds of beams at once using a crossing window to update properties for an entire wall or floor assembly in one click.

## FAQ
- **Q: What happens if I leave the Material field blank?**
  - A: The script will ignore the material property, and the selected beams will retain their currently assigned material.
- **Q: Does this script change the physical size of the beam?**
  - A: No, it only changes data attributes (Name, Grade, Labels). However, if you change the *Material* to one with different dimensions, you may need to update the beam geometry separately using standard hsbCAD tools.
- **Q: I ran the script but nothing happened.**
  - A: Ensure you selected at least one valid GenBeam. If no valid beams were selected, the script finishes silently. Also, ensure you actually typed values into the dialog fields; if all fields were empty, the script has nothing to change.