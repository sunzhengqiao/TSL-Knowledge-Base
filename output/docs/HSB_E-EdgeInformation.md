# HSB_E-EdgeInformation

## Overview
This script annotates the edges of timber elements (walls or roofs) with customizable text labels directly in the 3D model. It is typically used to display construction details, connection types, or notes that are linked to the element's edge properties.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script attaches to elements in the 3D model. |
| Paper Space | No | Not intended for use in Paper Space layouts. |
| Shop Drawing | No | Displays in the model; visibility depends on view settings. |

## Prerequisites
- **Required Entities**: An existing Wall (`ElementWallSF`) or Roof (`ElementRoof`) element.
- **Minimum Beams**: N/A (Script works on Elements, not individual beams).
- **Required Settings**: None required (Standard hsbCAD catalogs for Element Details are used if variables are referenced).

## Usage Steps

### Step 1: Launch Script
```
Command: TSLINSERT
Action: Browse and select HSB_E-EdgeInformation.mcr
```

### Step 2: Configure Settings (Dialog)
```
Dialog: Dynamic Properties Dialog
Action:
1. Enter the primary label text (e.g., "Connection A" or a variable like @(VAR60)).
2. Add optional descriptions in the provided fields.
3. Adjust text size, layer, and offset settings as needed.
4. Click OK to confirm.
```

### Step 3: Select Element
```
Command Line: Select an element
Action: Click on the Wall or Roof element you wish to annotate.
```

### Step 4: Select Edge
```
Command Line: Select edge<optional>
Action: Click on the specific edge line where the label should appear. 
Note: If you press Enter without selecting, the script will attempt to calculate a default position.
```

## Properties Panel Parameters

### Edge Information
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Detail name | Text | @(VAR60) | The main label text. Can be static text or a dynamic variable token (e.g., @(VAR60)) that reads data from the element's edge attributes. |
| Description | Text | (Empty) | Additional descriptive text appearing below the detail name. |
| Extra description | Text | (Empty) | Supplementary text line (3rd line). |
| Extra description 2 | Text | (Empty) | Supplementary text line (4th line). |
| Extra description 3 | Text | (Empty) | Supplementary text line (5th line). |
| Extra description 4 | Text | (Empty) | Supplementary text line (6th line). |

### Position and Style
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Assign to layer | Dropdown | Tooling | Specifies the layer the text entity is assigned to (Options: Tooling, Information, Zone, Element). |
| Zone index | Dropdown | 0 | Determines the zone index for export/filtering purposes (0-9). |
| Offset from edge | Number | 0 | Distance perpendicular from the selected edge line to the text anchor. |
| Horizontal text offset | Number | 0 | Distance along the edge direction to shift the text. |
| Text size | Number | -1 | Height of the text. (-1 typically uses a default or project setting). |
| Color | Number | -1 | Color index of the text (-1 usually defaults to "ByLayer"). |
| Horizontal text alignment | Dropdown | Left | Aligns text relative to the insertion point (Left, Center, Right). |
| Visible on top view only | Dropdown | Yes | If "Yes", the text may be hidden in 3D views depending on display settings. If "No", it is generally visible. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| (Standard TSL Menu) | No specific custom options added by this script. Use the Properties Palette to edit values. |

## Settings Files
- **Filename**: N/A
- **Location**: N/A
- **Purpose**: This script does not use external settings files. It relies on standard Element Construction Details (MapX) for variable resolution.

## Tips
- **Using Variables**: To automatically display edge construction data (e.g., specific notch types or codes defined in your catalogs), use variables like `@(VAR60)`, `@(VAR1)`, etc., in the **Detail name** field.
- **Moving Labels**: After insertion, select the text label in the model. You can drag the **Grip Point** (Text Anchor) to reposition the label freely.
- **Visibility**: If you cannot see the label in 3D views, check the **Visible on top view only** property in the palette and set it to "No".

## FAQ
- **Q: The text shows "@(VAR60)" instead of actual data. Why?**
  A: This means the variable index (60) is either empty or not defined in the selected element's Edge Construction Detail Map. Check the element's edge properties or use static text instead.
- **Q: Can I attach this to a single beam?**
  A: No, this script is designed for Wall or Roof elements only.
- **Q: How do I change the text size after insertion?**
  A: Select the label, open the **Properties Palette** (OPM), and modify the **Text size** value.
- **Q: Why did the script disappear after I selected the element?**
  A: This can happen if the script encounters invalid geometry or no valid edges are found. Ensure you are selecting a valid Wall or Roof element. Check the AutoCAD command line for specific error warnings.