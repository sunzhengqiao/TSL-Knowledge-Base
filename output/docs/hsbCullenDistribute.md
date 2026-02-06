# hsbCullenDistribute.mcr

## Overview
Automates the distribution of structural metal connectors (Cullen brackets) along timber walls, floors, or soleplates based on defined spacing rules or specific quantities.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be run in Model Space to detect walls and beams. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | This is a generation/scripting tool, not a drawing annotation tool. |

## Prerequisites
- **Required Entities**:
  - For types **FAS**, **PC**, **ST-PFS**: Stick frame walls (`ElementWallSF`).
  - For type **GA Cullen**: Sheets or horizontal Beams.
- **Minimum Beam/Entity Count**:
  - For **FAS** and **PC**: At least 2 intersecting walls are required.
- **Required Settings Files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCullenDistribute.mcr`

### Step 2: Configure Distribution Type
Before selecting elements, configure the **Type** property in the Properties Palette (or Dialog):
- **FAS**: Framing Anchor System (Wall intersections).
- **PC**: Panel Connector (Wall intersections).
- **ST-PFS**: Stud-to-Plate Floor joist.
- **GA Cullen**: General Angle bracket (For sheets or horizontal beams).

### Step 3: Select Elements
The prompt depends on the Type selected in Step 2:

*If Type is **FAS**, **PC**, or **ST-PFS**:*
```
Command Line: Select the crossing stick frame walls(s)
Action: Click on the stick frame walls that intersect or require connections. Select at least two walls.
```

*If Type is **GA Cullen**:*
```
Command Line: Select the sheet or horizontal beam of the wall
Action: Click on the specific sheet or beam (e.g., a soleplate) where the brackets should be placed.
```

### Step 4: Define Bracket Edge (GA Cullen Only)
*If Type is **GA Cullen**:*
```
Command Line: Select point that define the edge of the bracket
Action: Click a point on the selected beam/sheet to define the alignment edge for the brackets.
```

### Step 5: Generation
The script automatically calculates positions and inserts the connector instances. The script instance (`hsbCullenDistribute`) will delete itself upon completion.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | dropdown | FAS | Defines the type of connector to distribute. Options: FAS, PC, ST-PFS, GA Cullen. |
| Distance Bottom/Start | number | 0 | Offset distance from the start (bottom) of the element to the center of the first connector (mm). |
| Distance Top/End | number | 0 | Offset distance from the end (top) of the element to the center of the last connector (mm). |
| Distance Between | number | 0 | Center-to-center spacing between connectors. Enter a **negative number** (e.g., -1) to automatically calculate spacing based on "Nr. Parts". |
| Nr. Parts | number | 0 | The total number of connectors to distribute. Used only if "Distance Between" is negative. |
| Swap X-Y | dropdown | No | Swaps the orientation of the connector (flips it upside down). Options: No, Yes. |
| Offset GA | number | 10 | (Soleplate category) Adjusts the position of the bracket relative to the plate edge (mm). |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | No specific context menu options are added by this script. |

## Settings Files
None required.

## Tips
- **Using Fixed Counts**: To distribute a specific number of brackets evenly, set **Distance Between** to `-1` and set **Nr. Parts** to your desired count. The script will calculate the correct spacing automatically.
- **Horizontal Beams Only**: When using the **GA Cullen** type, ensure you select a horizontal beam. If a vertical beam is selected, the script will generate an error and exit.
- **Script Disappears**: It is normal for the script instance to vanish from the drawing after it runs. It has successfully generated the individual connector objects.

## FAQ
- **Q: Why did the script disappear after I finished?**
  **A:** The script is designed to delete itself (`delete instance after generation`) after creating the connector objects. This keeps your drawing clean.
- **Q: How do I space brackets evenly if I know how many I need but not the distance?**
  **A:** Set the **Distance Between** property to a negative value (e.g., -1) and enter the required quantity in **Nr. Parts**.
- **Q: I got an error "at least 2 walls needed". What does this mean?**
  **A:** This error occurs for FAS and PC types if you selected fewer than two walls. These connectors are designed for intersections between multiple walls.