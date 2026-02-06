# hsb_Hanger.mcr

## Overview
This script inserts structural hanger hardware (such as joist hangers or straps) based on a database configuration. It calculates the correct placement and geometry to connect a supporting beam (female) and a supported beam (male) using a specific hardware model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D structural beams. |
| Paper Space | No | Not intended for 2D drawing views. |
| Shop Drawing | No | Generates 3D model data only. |

## Prerequisites
- **Required Entities**: Structural Beams (GenBeam).
- **Minimum Beam Count**: 2 (One supporting/beam, one supported/joist).
- **Required Settings**:
  - Microsoft SQL Server Compact 4.0 (must be installed).
  - `hsbAcadHangerIntegration.dll` located in the `hsbCAD Install\Utilities.Acad\Hanger\` folder.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_Hanger.mcr`

### Step 2: Configure Hanger (Dialog)
```
Dialog: Hanger Integration
Action: The external .NET dialog opens. Select the Manufacturer, Hanger Type, and specific Model (e.g., "Face Mount", "I-Joist") from the database.
```

### Step 3: Select Beams
```
Command Line: Select Female/Supporting Beam
Action: Click on the main beam (or ledger) that carries the load.

Command Line: Select Male/Supported Beam
Action: Click on the joist or beam being supported.
```

### Step 4: Placement
```
Action: The script automatically calculates the intersection point and inserts the hanger geometry.
```

## Properties Panel Parameters
*Note: This script does not expose parameters directly to the AutoCAD Properties Palette (OPM). Configuration is handled via the insertion dialog described above.*

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **sModel** | String | (From DB) | The specific catalog part number of the hanger selected during insertion. |
| **sType** | String | (From DB) | The generic family of the hanger (e.g., "Face Mount", "Top Flange"). |
| **sDimstyle** | String | (From DB) | The dimension style used for labeling the hanger in drawings. |
| **nDisplayModel** | Integer | 0 | Controls the detail level of the 3D representation (0=Full Model, 1=Detailed, 2=Minimal). |
| **dTolerance** | Double | 0.0 | The search distance (in mm) used to identify duplicate hangers for replacement. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **changeHanger** | Regenerates or updates the hanger instance. It searches for existing hangers within the defined tolerance along the beam, erases the old one, and replaces it with the current configuration. |

## Settings Files
- **Filename**: `hsbAcadHangerIntegration.dll`
- **Location**: `%hsbCAD Install%\Utilities.Acad\Hanger\`
- **Purpose**: Provides the user interface for selecting hangers and communicates with the SQL database to retrieve hardware dimensions and properties.

## Tips
- **Placement Accuracy**: Ensure your structural beams intersect or touch correctly in the model. The script calculates the hanger position based on the beam geometry.
- **Replacing Hangers**: Use the `changeHanger` context menu option to swap an existing hanger for a different size or model without manually deleting the old one.
- **Display Performance**: If your model is heavy, check the `nDisplayModel` setting. Setting it to a simpler representation (like wireframe) can improve regeneration times.

## FAQ
- **Q: Why doesn't the dialog open when I run the script?**
  - A: Check that `hsbAcadHangerIntegration.dll` is present in your `Utilities.Acad\Hanger` folder and that Microsoft SQL Server Compact 4.0 is installed on your machine.
- **Q: Can I edit the hanger size after insertion?**
  - A: You cannot manually edit the dimensions in the Properties palette. Use the `changeHanger` right-click option to select a different model from the database.
- **Q: How do I prevent duplicate hangers?**
  - A: The script uses the `dTolerance` parameter. If a new hanger is inserted very close to an existing one on the same beam, the script will automatically replace the old one.