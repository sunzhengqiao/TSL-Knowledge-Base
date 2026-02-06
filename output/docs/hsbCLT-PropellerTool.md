# hsbCLT-PropellerTool.mcr

## Overview
This script generates a specialized "Propeller Surface Tool" machining operation on CLT (Cross Laminated Timber) panels. It defines the tool path using two polylines, automatically projecting them onto the panel's surface if they are not drawn parallel to the XY-plane.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script is designed for 3D modeling in Model Space. |
| Paper Space | No | Not supported in Layouts. |
| Shop Drawing | No | This is a modeling/CAM definition script. |

## Prerequisites
- **Required Entities**: 
  - An Element (CLT Panel).
  - Two Polylines (to define the tool shape/path).
- **Minimum Beam Count**: 0
- **Required Settings**: 
  - `hsbCLT-Freeprofile.xml` (Must be located in the Company or hsbCAD Install path).

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` → Select `hsbCLT-PropellerTool.mcr`

### Step 2: Select Element
```
Command Line: Select Element:
Action: Click on the CLT panel element you wish to apply the tool to.
```

### Step 3: Define Geometry
```
Command Line: Select defining polyline / [Cancel]:
Action: Select the first polyline that defines the primary boundary of the tool.

Command Line: Select second polyline / [Ok]:
Action: Select the second polyline (often used for bevels or secondary offsets) or press Enter if a single polyline definition is sufficient.
```
*Note: If the selected polylines are not parallel to the panel's XY-plane, the script will automatically project them onto the panel's upper or lower surface.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sDimStyle | Dropdown | First in list | The dimension style used for annotating measurements in the model. |
| dTextHeight | Double | U(50) | The height of text labels displayed for visualization (in mm). |
| ncDefining | Integer (Color) | Red (205,32,39) | Color used to visualize the primary defining polyline. |
| ncBevel | Integer (Color) | Green (0,158,0) | Color used to visualize the secondary polyline or bevel definition. |
| nt | Integer | 50 | Transparency level of the tool visualization overlay (0-100). |
| dDiameter | Double | 0 (Read from Settings) | The diameter of the milling cutter (in mm). |
| dLength | Double | 0 (Read from Settings) | The cutting length of the tool (in mm). |
| nToolIndex | Integer | 2 | The unique identifier number for the tool in the CNC machine magazine. |
| sToolName | String | Name of Tool | Human-readable name for the tool configuration (e.g., "20mm Vertical Mill"). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Edit Display Settings | Opens a dialog to change visualization preferences such as colors, text height, and transparency. |
| Edit Tool Definition | Allows you to modify the properties (Diameter, Length, Index, Name) of an existing tool selected from the catalog. |
| Add Tool Definition | Opens a dialog to create a new tool profile and add it to the tool catalog. |
| Remove Tool Definition | Removes a tool from the catalog. (Only available if more than one tool exists). |
| Import Settings | Loads tool definitions from an external XML file into the current drawing. |
| Export Settings | Saves the current tool catalog and settings to an XML file for backup or sharing. |

## Settings Files
- **Filename**: `hsbCLT-Freeprofile.xml`
- **Location**: Company folder or hsbCAD installation path.
- **Purpose**: Stores the library of tool definitions (Diameter, Length, ToolIndex, Name) and global display settings. This file allows the tool catalog to be shared across different projects or users.

## Tips
- **Visualization**: Use high-contrast colors for `ncDefining` and `ncBevel` if your polylines overlap or are complex; this makes it easier to distinguish the primary path from secondary bevels.
- **Tool Management**: Use the "Export Settings" feature to back up your customized tool catalog after defining specific cutters required for your workshop.
- **Projection**: You do not need to manually flatten your polylines onto the panel face. Draw them in a convenient work plane (e.g., XY-plane), and the script will project them to the panel surface automatically.

## FAQ
- **Q: Why does the tool disappear or look very faint?**
  - A: Check the `nt` (Transparency) property. If it is set to a high value (close to 100), the tool will be nearly invisible. Lower the value to make it opaque.
  
- **Q: Can I use a single polyline instead of two?**
  - A: Yes. You can select the first polyline and then press Enter (or select "Ok") when prompted for the second polyline to use a single definition.

- **Q: How do I ensure the CNC machine uses the correct cutter?**
  - A: Verify that the `nToolIndex` in the script properties matches the physical position of the tool in your CNC machine's tool changer magazine. You can manage this via "Edit Tool Definition".