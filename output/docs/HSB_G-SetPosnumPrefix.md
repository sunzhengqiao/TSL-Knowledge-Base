# HSB_G-SetPosnumPrefix

## Overview
This script automatically assigns specific position number prefixes (e.g., "W" for Wall, "R" for Roof) to all timber beams in your model based on their Material names or Beam Codes. It can also be used to clear this prefix data from the entire model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script processes all `GenBeam` entities in the current 3D model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Not applicable for 2D drawings. |

## Prerequisites
- **Required Entities**: Any number of `GenBeam` (timber beams) in the model.
- **Minimum Beam Count**: 0 (Script will run successfully but report 0 entities processed).
- **Required Settings**: A configuration file named `Posnum.xml` must exist in your company folder (`hsbCompany\Custom\`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-SetPosnumPrefix.mcr`

### Step 2: Select Status Text Position
```
Command Line: |Select a position|
Action: Click anywhere in the Model Space (3D view) to place the script anchor point. 
```
*Note: This point determines where the feedback text (showing the count of processed beams) will appear.*

### Step 3: Automatic Execution
Once placed, the script automatically executes the "Assign" logic immediately. It scans the entire Model Space, matches your beams against the rules in `Posnum.xml`, and writes the prefixes. A text element will appear at your selected point confirming how many entities were processed.

## Properties Panel Parameters
This script does not expose user-editable properties in the AutoCAD Properties Palette. All configuration is handled via the external XML file and the right-click menu.

## Right-Click Menu Options
Select the script instance in the model (usually indicated by the anchor point or text) and right-click to access the following options:

| Menu Item | Description |
|-----------|-------------|
| **Assign posnum prefixes** | Reads the `Posnum.xml` file and updates the position number prefixes for all beams in the model based on their current Material or Beam Code. |
| **Clear data** | Removes all position number prefix data from the `PositionNumber` submap of every beam in the model. |

## Settings Files
- **Filename**: `Posnum.xml`
- **Location**: `_kPathHsbCompany\Custom\` (Usually located in your hsbCAD company directory on the network or local drive).
- **Purpose**: Defines the mapping rules. It contains lists of Material names and Beam Codes that correspond to specific Prefix strings.

## Tips
- **Precedence Rule**: If a beam matches both a Beam Code rule *and* a Material rule in the XML file, the **Material** rule takes precedence.
- **Feedback Text**: You can move the feedback text (showing the count and time) by using the standard AutoCAD grips on the text object.
- **Re-running**: If you change beam properties or update the XML file, simply double-click the script instance or select "Assign posnum prefixes" from the right-click menu to update all beams instantly.
- **Case Sensitivity**: Ensure the spelling and case of Material names and Beam Codes in the XML file exactly match those in your hsbCAD catalog.

## FAQ
- **Q: Why did the script process 0 entities?**
  - A: Ensure you are in Model Space and that there are valid GenBeams. Also, check that the `Posnum.xml` file is correctly located in the `hsbCompany\Custom\` folder.
- **Q: How do I define which prefix applies to which wall?**
  - A: You must manually edit the `Posnum.xml` file. Add entries mapping your specific Material names (e.g., "GL24h") or Beam Codes to the desired prefix string (e.g., "W").
- **Q: Does this script only work on selected beams?**
  - A: No, this script processes **all** GenBeam entities found in the entire Model Space.
- **Q: How do I remove the prefixes?**
  - A: Right-click the script instance and select **Clear data**. This will strip the prefix information from all beams.