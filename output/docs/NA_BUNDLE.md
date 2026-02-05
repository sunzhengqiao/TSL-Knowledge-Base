# NA_BUNDLE.mcr

## Overview
This script creates a visual representation and logistics report for shipping bundles (truck loads) of wall panels. It organizes panels, calculates total weights and dimensions, and generates shipping labels with customizable data fields.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script collects wall panel entities (TslInst) and draws the bundle layout in the 3D model. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: Wall panels (TslInst) that have been previously generated and contain map entries for 'mpStackChildPanel'.
- **Minimum Beam Count**: 0 (Operates on Panel instances).
- **Required Settings**:
    - `moProfInv.map`: Profile inventory mapping.
    - `mpNameList`: Naming conventions.
    - `mpSheathing`: Sheathing material data.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `NA_BUNDLE.mcr`

### Step 2: Configure Bundle Properties
```
Interface: Properties Palette (OPM)
Action: Set the Set Number, Truck Number, and dimensions (Width/Height) to match your shipping constraints.
```

### Step 3: Insert Bundle
```
Command Line: Select an insertion point
Action: Click in the Model Space where you want the bundle visualization and label to appear.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Shipment** | | | |
| Set Number | Number | 1 | Identifier for the specific shipment set (if multiple deliveries are required). |
| Truck Number | Number | 1 | Identifier for the specific truck or trailer ID. |
| **Trailer Properties** | | | |
| Wall Justification | Dropdown | Left | Aligns panels to the Left, Center, or Right within the truck width. |
| Max Width | Number | 6000.0 | Maximum available width of the truck bed (usually in mm). |
| Max Height | Number | 1500.0 | Maximum allowable stack height (usually in mm). |
| Automatic Behavior | Dropdown | Apply Justification | Controls how panels are organized: 'None' (calc only), 'Apply Justification', or 'Fully Automatic' (pack trailer). |
| **Dimensions** | | | |
| Show Dimension | Dropdown | Yes | Toggles visibility of the bundle width and height dimensions. |
| DimStyle | Dropdown | System Default | Selects the CAD dimension style for the drawn dimensions. |
| Dim Offset | Number | 600.0 | Distance from the bundle geometry to the dimension lines. |
| **Display Properties** | | | |
| Show Bundle Prefix | Dropdown | Yes | Toggles the visibility of the user-defined prefix. |
| Bundle Prefix | Text | | Prefix text for the Bundle ID (e.g., "TRLR-"). |
| Custom Text | Text | | Free text for labels (e.g., "Site A" or "Urgent"). |
| Info Top Left | Dropdown | Project Name | Selects data to display in the top-left label (e.g., Weight, Qty, Project Name). |
| Info Top Right | Dropdown | Bundle Number | Selects data to display in the top-right label. |
| Info Btm Left | Dropdown | | Selects data to display in the bottom-left label. |
| Info Btm Right | Dropdown | | Selects data to display in the bottom-right label. |
| Info Side Left | Dropdown | | Selects data to display on the left side label. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the bundle visualization if underlying panels have been modified or properties changed. |

## Settings Files
- **Filenames**: `moProfInv.map`, `mpNameList`, `mpSheathing`
- **Location**: Company or Install path (defined in hsbCAD configuration).
- **Purpose**: These files provide the necessary material lists, profile mappings, and naming logic required to calculate weights and dimensions correctly.

## Tips
- Ensure your wall panels are created and visible in the Model Space before inserting the bundle.
- If panels are not moving as expected, check the **Automatic Behavior** property. If it is set to "None", the script will only calculate statistics without moving the panels.
- Use the **Fully Automatic** mode to let the script attempt to pack panels efficiently within the defined Max Width and Height.

## FAQ
- Q: What units are used for Width and Height?
  A: The script typically uses millimeters (internal standard), so a width of 6000 represents 6 meters.
- Q: Can I label the bundle with specific project information?
  A: Yes. Use the "Display Properties" (e.g., Info Top Left) dropdowns to select "Project Name", "Project Number", "Weight", or other data fields to display on the bundle tag.
- Q: Why are my panels not aligning?
  A: Ensure that the **Wall Justification** is set to the desired side (Left/Center/Right) and that **Automatic Behavior** is not set to "None".