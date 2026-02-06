# hsbCLT-CreateStockPanels.mcr

## Overview
This script automates the generation of production-ready CLT stock panels from architectural master panels. It optimizes the cutting layout based on a predefined stock size table, minimizing material waste and ensuring panels fit within transportable and manufacturable dimensions.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be inserted into Model Space. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | This is a pre-production/modeling tool, not a detailing script. |

## Prerequisites
- **Required Entities**: At least one GenBeam (Masterpanel) in the model.
- **Minimum Beam Count**: 1 (You select the specific masterpanel upon insertion).
- **Required Settings**:
  - `hsbCLT-CreateStockPanels.xml`: Configuration file (usually found in `Company\TSL\Settings` or `Install\Content\General\TSL\Settings`).
  - **Stock Definitions**: An Excel file containing available panel sizes and priorities, loaded via the right-click menu.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT`
**Action**: Browse and select `hsbCLT-CreateStockPanels.mcr`.

### Step 2: Select Masterpanel
```
Command Line: Select masterpanels
Action: Click on the GenBeam element (architectural masterpanel) you wish to sub-divide into stock panels.
```
*Note: Once selected, the script will attempt to calculate the stock panels immediately. If this is the first run or settings are missing, the script may display an error.*

### Step 3: Import Stock Data (If needed)
If the script reports "No valid shapes detected" or fails to generate panels:
1. Select the script instance in the drawing.
2. Right-click and choose **|Import Stock Sizes|**.
3. Select your predefined Excel file containing the stock dimensions.
4. The script will recalculate automatically.

### Step 4: Update Tool Settings (Optional)
If you need to adjust saw blade diameters (kerf) or gaps:
1. Select the script instance.
2. Right-click and choose **|Import Settings|** to load an XML configuration, or edit the `hsbCLT-CreateStockPanels.xml` file manually.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| *None* | *N/A* | *N/A* | This script does not expose user-editable parameters in the standard AutoCAD Properties Palette. Configuration is handled via Settings files and the Right-Click Context Menu. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| |Import Stock Sizes| | Opens the hsbExcelToMap utility to load stock dimensions, costs, and priorities from an Excel file. Required for the script to function. |
| |Import Settings| | Loads tool configuration (saw diameters, gaps) and other parameters from the XML settings file. |
| |Export Settings| | Saves the current tool configuration (saw diameters, gaps) to the XML settings file for backup or sharing. |

## Settings Files
- **Filename**: `hsbCLT-CreateStockPanels.xml`
- **Location**: `_kPathHsbCompany\TSL\Settings` or `_kPathHsbInstall\Content\General\TSL\Settings`
- **Purpose**: Stores tool data (saw blade diameters, clearance gaps) and general script behavior settings.

- **Filename**: Excel File (User Defined)
- **Location**: Selected by user via |Import Stock Sizes|
- **Purpose**: Defines the "Stock Map" (dXSizes, dYSizes). Contains the dimensions of available raw panels and their priority values (20-30 for standard stock, 30-40 for splitting patterns).

## Tips
- **Stock Values**: In your Excel file, use values between 20-30 for standard stock sizes. Use values >30 if you want the script to treat those dimensions as "split patterns" to be further subdivided.
- **Visualization**: The script generates the resulting stock panels as `Sip` entities. Ensure your layer filters are set to visualize these entities.
- **First Run**: Always run **|Import Stock Sizes|** immediately after inserting the script if you have not done so previously in the project, otherwise the script will likely fail to find valid shapes.

## FAQ
- **Q: Why did the script erase itself immediately after insertion?**
  A: This usually happens if no valid stock shapes are detected. Ensure you have imported the Stock Sizes via the right-click menu and that your selected Masterpanel is large enough to fit at least one stock size defined in your Excel file.

- **Q: How do I change the gap size between cut panels?**
  A: The gap size is defined in the `hsbCLT-CreateStockPanels.xml` file. You can edit this file directly and restart the script, or use **|Import Settings|** if you have a prepared XML file.

- **Q: Does this script cut the original Masterpanel?**
  A: The script generates new `Sip` entities representing the cuts. Depending on the internal setting `bAddOpeningToMaster`, it may also add openings to the source GenBeam, but the primary output is the new stock panels.