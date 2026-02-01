# GE_BEAM_INFO_GET_SPECIFIC_DETAIL

## Overview
This script extracts and displays specific attribute information (such as Material, Grade, or Layer) for a user-selected group of beams in a text report. It allows you to quickly audit or compare properties across multiple elements without editing them.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates directly on beam entities in the model. |
| Paper Space | No | Not designed for layout views or shop drawings. |
| Shop Drawing | No | Not designed for shop drawing contexts. |

## Prerequisites
- **Required entities**: Generic Beams (`GenBeam`).
- **Minimum beam count**: 1.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_BEAM_INFO_GET_SPECIFIC_DETAIL.mcr`

### Step 2: Select Beams
```
Command Line: select a set of other beams
Action: Click on the beams you wish to analyze. You can select multiple beams using a window or crossing selection. Press Enter to confirm selection.
```

### Step 3: Configure Information Type
After selecting the beams, the script instance is created. You must select the specific data you want to view.
```
Action: Select the script instance (if not already selected) and open the Properties Palette (Ctrl+1). Locate the "Information type" parameter and choose the desired attribute (e.g., Material, Grade, Layer) from the dropdown list.
```

### Step 4: Generate Report
```
Action: The script will automatically process the selection once the property is set. A "Notice" window will appear displaying the Handle, Type, and the requested detail for each selected beam.
```
*(Note: The script instance erases itself automatically after displaying the report.)*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Information type | Dropdown | type | Determines which specific attribute is displayed in the final report. Options include: type, module, grade, profile, material, label, sublabel, sublabel2, beamcode, information, name, posnumandtext, layer, hsbId. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add custom context menu options. It runs primarily via the Properties Palette. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Batch Auditing**: Use this script to quickly verify that a specific group of walls (e.g., exterior walls) all share the same Material Grade or Layer by setting the "Information type" accordingly.
- **Selection Flexibility**: You can use standard AutoCAD selection methods (Window, Crossing, Fence) during the beam selection prompt to grab many elements at once.
- **Data Reference**: The "Handle" provided in the report helps you identify specific beams if you need to investigate them further in the model.

## FAQ
- **Q: The script disappeared after I ran it. Is that normal?**
  - A: Yes. This is a utility script designed to query data and report it. It automatically erases its own instance from the drawing after displaying the information to keep your drawing clean.
- **Q: What happens if I select zero beams?**
  - A: If you do not select any beams and press Enter, the script will detect the empty selection and exit without displaying a report.
- **Q: Can I use this to modify the beam properties?**
  - A: No. This script is read-only. It only extracts and displays existing property values.