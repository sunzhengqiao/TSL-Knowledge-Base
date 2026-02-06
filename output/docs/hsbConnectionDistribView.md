# hsbConnectionDistribView

## Overview
This script allows users to define, visualize, and calculate the distribution of mechanical connectors (such as screws, nails, or plates) along a connection between two timber panels or beams. It supports normal, parallel, and arbitrary joint angles and generates the corresponding hardware components for production lists.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in the 3D model to create hardware components. |
| Paper Space | No | Not designed for 2D drawing views. |
| Shop Drawing | No | Does not process Shop Drawing layouts. |

## Prerequisites
- **Required Entities**: Two structural elements (GenBeam or Element) to form the connection.
- **Minimum Beam Count**: 2 (or two Elements).
- **Required Settings Files**: `hsbExcel2Xml.xml` located in the `hsbCompany\TSL\Settings` folder.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT`
**Action**: Select `hsbConnectionDistribView.mcr` from the list and click OK.

### Step 2: Select First Element
```
Command Line: Select Element/Beam 1:
Action: Click on the first timber beam or wall element.
```

### Step 3: Select Second Element
```
Command Line: Select Element/Beam 2:
Action: Click on the second timber beam or wall element that connects to the first.
```

### Step 4: Define Start Point
```
Command Line: Specify start point of distribution:
Action: Click on the intersection or surface where the connector distribution should begin.
```

### Step 5: Define End Point
```
Command Line: Specify end point of distribution:
Action: Click on the intersection or surface where the connector distribution should end.
```

### Step 6: Configure Properties
After insertion, select the script instance and open the **Properties Palette** (Ctrl+1) to define the hardware manufacturer, model, and spacing logic.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Loaded Project** | String | Value from XML | The project name associated with the connection (read-only from settings). |
| **Manufacturer** | Dropdown | --- | Select the hardware vendor (e.g., Simpson, Mitek). This filters the Model list. |
| **Model** | Dropdown | *Empty* | Select the product series (e.g., specific hanger type). This filters the Article list. |
| **Article** | Dropdown | *Empty* | Select the exact product SKU or part number. |
| **CD-Ref** | Dropdown | *From XML* | Connection Design Reference code identifying the joint type. |
| **CD-Ref Number** | Integer | 0 | An index or variant number for the specific CD-Ref. |
| **Distance Bottom** | Double (mm) | 0 | Margin distance from the start (bottom/left) of the connection to the first connector. |
| **Distance Top** | Double (mm) | 0 | Margin distance from the end (top/right) of the connection to the last connector. |
| **Distance between / Nr.** | Double | 5 (mm) | **Spacing Logic**: <br>• **Positive Value**: Fixed spacing between connectors (mm). <br>• **Negative Value**: Fixed quantity of connectors (e.g., enter -5 to place 5 items). |
| **Distance between Result** | Double (mm) | 0 | Read-only. Shows the calculated center-to-center spacing. |
| **NrResult** | Integer | 0 | Read-only. Shows the total calculated number of connectors. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *Recalculate* | Updates the connector distribution based on current property values or geometry changes. |

## Settings Files
- **Filename**: `hsbExcel2Xml.xml`
- **Location**: `hsbCompany\TSL\Settings`
- **Purpose**: This file contains the catalog of Manufacturers, Models, Articles, and CD-Ref codes. Without this file, the dropdowns will be empty, and the script cannot function.

## Tips
- **Quick Spacing Adjustment**: To get an evenly distributed number of screws, simply enter a negative number in the **Distance between / Nr.** property (e.g., type `-10` to get 10 screws evenly spaced).
- **Margin Control**: Increase **Distance Bottom** or **Distance Top** if you need to keep screws away from the edges of the timber.
- **Visual Updates**: The script provides grip points at the start and end of the connection. Drag these grips in the model to adjust the length of the distribution area visually.
- **Selection Logic**: You can mix Element types (e.g., select a Wall Element and a Beam Element); the script will calculate the intersection.

## FAQ
- **Q: Why are the Manufacturer, Model, and Article dropdowns empty?**
  **A**: The script cannot find the `hsbExcel2Xml.xml` file, or the file is empty/corrupt. Ensure the file exists in your company settings folder.
- **Q: I changed the spacing, but the connectors didn't move.**
  **A**: Select the script instance and right-click -> **Recalculate**, or simply click in the **Distance between / Nr.** field and press Enter to force a refresh.
- **Q: Can I use this for non-rectangular connections?**
  **A**: Yes, the script supports normal, parallel, and arbitrary connection angles defined by the two selected elements and the points you pick.