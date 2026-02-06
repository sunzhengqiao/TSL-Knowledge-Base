# SIP-MPM

## Overview
This script automates the grouping and nesting of individual Structural Insulated Panels (SIPs) into larger Master Panels. It calculates optimal layouts based on defined stock sizes and sorting rules to prepare panels for manufacturing or CNC cutting.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script processes Sip entities in the 3D model. |
| Paper Space | No | Not intended for layout views or shop drawings. |
| Shop Drawing | No | Does not generate 2D drawings directly. |

## Prerequisites
- **Required Entities**: `Sip` entities must exist in the drawing.
- **Required Settings**: `SIP-MPM.xml` (Optional, but recommended for managing stock sizes).

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` (or insert via the hsbCAD toolbar)
**Action**: Select `SIP-MPM.mcr` from the file list and click **Open**.

### Step 2: Automatic Processing
**Action**: Upon insertion, the script automatically scans the Model Space for all available `Sip` entities. It filters out panels that are already grouped (ChildPanels) and proceeds to nest the remaining panels into Master Panels based on the current settings.

### Step 3: Review Results
**Action**: The script generates the nested layout in Model Space. Verify that the Sips are correctly grouped into the Master Panels and that the labels are visible.

## Properties Panel Parameters
*Note: This script does not expose direct user-editable properties in the AutoCAD Properties Palette. Configuration is handled via the Settings File and Right-Click Menu.*

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | No OPM properties exposed. |

## Right-Click Menu Options
Right-click the script instance in the drawing to access the following options:

| Menu Item | Description |
|-----------|-------------|
| **Add Stock Sizes** | Prompts the user to select existing MasterPanels. <br> **Command Line**: `Select master panels` <br> *Action*: Select panels in the drawing to extract their dimensions (Style, Length, Width) and add them to the internal stock list. |
| **Clone Stock Sizes** | Copies the stock size definitions from the first style entry in the configuration to all other MasterPanel styles found in the catalog. |
| **Import Settings** | Reloads the Style and Stock Size configuration from the external `SIP-MPM.xml` file. |
| **Export Settings** | Saves the current in-memory Style and Stock Size configuration to the `SIP-MPM.xml` file. <br> **Command Line**: `Are you sure to overwrite existing settings? [No]/[Yes]` (Only if file exists). <br> *Action*: Type `Y` to overwrite or `N` to cancel. |

## Settings Files
- **Filename**: `SIP-MPM.xml`
- **Location**: `_kPathHsbCompany\SIP\` (Your company hsbCAD folder).
- **Purpose**: Stores the mapping between MasterPanel Styles and their specific Stock Size dimensions (Length/Width).

## Tips
- **Update Stock Sizes**: Use the **Add Stock Sizes** context menu option to quickly populate your stock list by selecting representative MasterPanels from an existing project.
- **Backup Config**: Use **Export Settings** frequently to save your optimized stock configurations to the XML file.
- **Sorting**: The script uses a "Painter Definition" to sort panels before nesting. Ensure your panels have consistent properties (like Length or Width) for the best nesting efficiency.

## FAQ
- **Q: Why are some panels not being nested by the script?**
  **A**: The script filters out Sips that already have an associated ChildPanel. Also, ensure the panel dimensions do not exceed the maximum Stock Sizes defined in your settings.

- **Q: How do I change the sheet material sizes used for nesting?**
  **A**: Use the **Add Stock Sizes** option to select a panel with the desired dimensions, or manually edit the `SIP-MPM.xml` file and use **Import Settings**.

- **Q: Can I undo the nesting process?**
  **A**: Yes, you can use the standard AutoCAD `UNDO` command to revert the script execution, which will remove the generated MasterPanels and ChildPanels.