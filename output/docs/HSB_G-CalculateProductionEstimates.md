# HSB_G-CalculateProductionEstimates.mcr

## Overview
This script calculates production time estimates for timber elements based on their geometric shape and area. It generates a visual table displaying the estimated time for each element and stores this data within the drawing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Collects all elements in the model. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: Elements (e.g., roofs, walls) must exist in the Model Space.
- **Settings Files**: `ProductionRateConfigurations.xml` (The script will attempt to create a default file if one does not exist).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or `TSL` catalog) → Select `HSB_G-CalculateProductionEstimates.mcr`.

### Step 2: Select Configuration
A dialog appears upon insertion.
```
Dialog: TSL Properties
Action: Select a "Production rate configuration" from the dropdown list (e.g., "Default").
```

### Step 3: Place Table
```
Command Line: Select a position
Action: Click anywhere in the Model Space to place the generated table.
```
*The script will now scan all elements, calculate estimates, and draw the table.*

## Properties Panel Parameters

| Parameter | Type | Options | Description |
|-----------|------|---------|-------------|
| Production rate configuration | dropdown | (Loaded from XML) | Selects the specific set of calculation rates to apply to the elements. Changing this triggers an immediate recalculation. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Reload production rate configurations | Refreshes the list of configurations from the XML file on disk. Use this if you have manually updated the XML file. |

## Settings Files
- **Filename**: `ProductionRateConfigurations.xml`
- **Location**: `_kPathHsbCompany\Tsl\Settings` (Your Company Folder)
- **Purpose**: Defines the production rates (time per unit area) for different element shapes such as Rectangle, Triangle, Hip, Valley, and Internal Valley.

## Tips
- **Auto-Configuration**: If the XML file is missing, the script will try to create a default file with standard rates automatically.
- **Geometry Detection**: The script analyzes the 2D envelope of elements. Ensure your elements have valid, closed outlines.
- **Data Persistence**: Even if you delete the script instance (the table), the calculated production data remains stored in the individual elements.
- **Moving the Table**: You can move the generated table by using the grip edit on the insertion point selected in Step 3.

## FAQ
- **Q: Why did the script delete itself immediately after insertion?**
  A: This usually happens if you are trying to insert a second instance, or if the required folder structure could not be created. Check the command line for specific error messages regarding the XML file path.
- **Q: The table shows "Unknown shape" for some elements.**
  A: The script could not match the element's geometry to a defined shape in the XML. You may need to update the XML configuration to include the detected shape name or check the element's geometry.
- **Q: How do I update the rates?**
  A: Open the `ProductionRateConfigurations.xml` file in a text editor, modify the values, save the file, and then use the Right-Click menu option "Reload production rate configurations" on the script instance.