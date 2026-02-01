# hsb-SubAssembly

## Overview
Groups selected timber elements (beams, sheets, and sub-components) into a logical sub-assembly for production management and places a visual identification tag in the 3D model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D model entities (GenBeams, Sheets, TslInsts). |
| Paper Space | No | Not designed for 2D drawing generation. |
| Shop Drawing | No | Does not generate shop drawing views. |

## Prerequisites
- **Required Entities**: At least one GenBeam, Sheet, or TslInst (Script Instance) must be present to serve as the host or group member.
- **Minimum Beam Count**: 1 (Host beam).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or `TSLINST` for grouping multiple entities)
```
Action: Browse and select 'hsb-SubAssembly.mcr'.
```

### Step 2: Select Entities
```
Command Line: Select beam:
Action: Click on the primary GenBeam to host the script.
Note: To group multiple specific elements, use the 'TSLINST' command, select all desired beams/sheets, and then select this script.
```

### Step 3: Set Insertion Point
```
Command Line: Insertion point:
Action: Click in the model space to place the sub-assembly tag.
```

### Step 4: Configure Label (Optional)
```
Action: Select the inserted script instance. Open the Properties (OPM) palette. Enter a custom name in the 'Name Shopdraw Tag' field.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Name Shopdraw Tag | Text | (Empty) | The custom label text displayed on the tag in the 3D model. If left empty, the tag displays "Shopdraw Tag". Use short codes like 'TRUSS-A' for clarity. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalc | Re-scans the associated elements and regenerates the internal unique SubAssembly ID. Use this if the grouped elements have changed. |

## Settings Files
None required. The script relies on internal logic and entity properties.

## Tips
- **Grouping Multiple Elements**: While you can insert the script on a single beam, this script is most powerful when used with the `TSLINST` command. Select all the beams, sheets, and components you want to group, then run `TSLINST` and select `hsb-SubAssembly.mcr`. This ensures all selected items are included in the sub-assembly map.
- **Visual Identification**: The text tag serves as a visual marker in the 3D model. Ensure the insertion point is chosen where it does not clash with other geometry.
- **Unique IDs**: The script automatically generates a unique internal ID based on the handles of the grouped elements. This ID is used for data processing, while the "Name Shopdraw Tag" is for human-readable labeling.

## FAQ
- **Q: Why does my tag show "Shopdraw Tag" instead of my text?**
  - A: Ensure you have entered a value in the "Name Shopdraw Tag" property in the Properties Palette and that the script has been recalculated.
- **Q: Can I move the tag after insertion?**
  - A: Yes. Use standard AutoCAD move commands or grip-edit the script insertion point to relocate the tag without affecting the logical grouping of the timber elements.
- **Q: How do I add more beams to an existing sub-assembly?**
  - A: You typically need to delete the script instance and re-run the insertion (`TSLINST`) selecting the new set of elements, or use the specific hsbCAD map manipulation tools if available in your environment.