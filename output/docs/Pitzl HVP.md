# Pitzl HVP

## Overview
Generates and inserts Pitzl HVP heavy-duty timber connectors, including the 3D metal plate body, necessary timber machining (milling/pockets), and screw hardware data for BOM export.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script creates 3D bodies and applies tooling to beams in the model. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: 2 GenBeams (Main Beam and Secondary Beam).
- **Minimum Beam Count**: 2
- **Required Settings Files**: None (Uses internal article data).

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT`
**Action**: Browse and select `Pitzl HVP.mcr`.

### Step 2: Select Main Beam
```
Command Line: Select main beam
Action: Click on the primary beam (e.g., the beam carrying the load).
```

### Step 3: Select Secondary Beam
```
Command Line: Select secondary beam
Action: Click on the connecting beam (e.g., the joist or purlin meeting the main beam).
```

### Step 4: Select Connector Family (Conditional)
*If you did not use a specific Catalog Entry (Execute Key) to start the script:*
```
Dialog: SelectFromList
Action: Choose the desired connector Family (e.g., 880-Vorgabe, 881-Vorgabe) from the list and click OK.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Article | text | 88006 | The specific Pitzl product code (e.g., 88006, 88107). Determines size and screw pattern. |
| Milling | dropdown | none | Installation method: `none` (surface mounted), `male` (pocket in main beam), `female` (pocket in secondary beam), or `half` (recessed in both). |
| Male mill depth | number | 20 | Depth of the recess into the main beam (used when Milling is set to 'half'). |
| Offset X | number | 0 | Moves the connector along the secondary beam axis. |
| Offset Y | number | 0 | Moves the connector vertically relative to the beam intersection. |
| Offset Z | number | 0 | Moves the connector along the main beam axis. |
| Rot X | number | 0 | Rotates the connector around its local X-axis. |
| Rot Y | number | 0 | Rotates the connector around its local Y-axis. |
| Rot Z | number | 0 | Rotates the connector around its local Z-axis. |
| Round type | number | 2 | Shape of the milling corners (0=Square, 1=Chamfer, 2=Round). |
| Show help | number | 1 | Toggle to show (1) or hide (0) the manufacturer hyperlink in the model. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Create catalog entry | Saves the current connector configuration (Article, Offsets, Milling mode) as a new entry in the catalog for future use. |

## Tips
- **Auto-Correction**: If the beams you selected are too large for the chosen Article number, the script will automatically calculate and switch to the next larger size available. A message will appear in the command line confirming the change.
- **Milling Modes**:
    - Use **Male** to recess the plate into the main beam.
    - Use **Female** to recess the plate into the secondary beam.
    - Use **Half** to recess partially into the main beam (using "Male mill depth") and fully into the secondary beam.
- **Catalog Entries**: If you frequently use specific offsets or sizes, use the "Create catalog entry" context menu option to save that setup. You can then launch the script directly from that entry to skip the selection dialog.

## FAQ
- **Q: Why did the Article number change automatically after I selected it?**
  **A**: The script detected that the beam dimensions were too large for the manually selected article. It automatically upgraded to a larger size to ensure the connector fits physically.
- **Q: How do I make the connector sit flush with the beam surface?**
  **A**: Set the `Milling` property to `male` (for main beam) or `female` (for secondary beam) to create the necessary pocket. Set offsets to 0 to align with the intersection.
- **Q: Can I move the connector after insertion?**
  **A**: Yes, you can use standard AutoCAD Move commands. Alternatively, adjust the `Offset X/Y/Z` properties in the Properties Palette for precise positioning.