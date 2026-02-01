# GenericHanger.mcr

## Overview
Automates the insertion and configuration of structural timber connectors (joist hangers, skewed hangers, and straps) between beams, trusses, and panels. It selects the appropriate hardware based on geometry, handles machining (drilling/cutting), and manages reinforcement/backers.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script specifically designed for 3D structural modeling. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Intended for model generation, not drawing annotation. |

## Prerequisites
- **Required Entities**: At least two intersecting structural entities (`GenBeam`, `GenBeam` (Truss), or `Element`) forming a T-connection.
- **Minimum Beam Count**: 2 (Support beam and Joist/Truss).
- **Required Settings**: Manufacturer definition XML files (e.g., Simpson Strong-Tie) and Map configuration files must be accessible to the script.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Select `GenericHanger.mcr` from the file dialog.

### Step 2: Select Supporting Beam (Female)
```
Command Line: Select beam or truss (Support):
Action: Click on the main carrying beam (e.g., rim beam or ledger) that the hanger will attach to.
```

### Step 3: Select Joist Beam (Male)
```
Command Line: Select beam or truss (Joist):
Action: Click on the beam being supported (e.g., floor joist) that sits into the hanger.
```

### Step 4: Automatic Generation
The script will automatically calculate the geometry, select the best-fitting product from the catalog, and generate the hanger, associated metal parts, and required machining.

### Step 5: Verify and Adjust
1.  Visually inspect the generated hanger in the model.
2.  If the hanger is missing or incorrectly placed, right-click the script instance and select **Show Selection Log** to see error details (e.g., "No valid product found").
3.  Adjust parameters (e.g., Allow Angle Deviation) via the Properties Palette or Right-Click Menu if necessary.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| bAllowAngleDeviation | Boolean | False | If True, allows standard hangers to be used on connections that are not perfectly 90° (within a small tolerance). Prevents placement failures on minor field variances. |
| AllowedAngularDeviation | Number (Double) | 0.0 | Specifies the maximum degree of deviation from 90° allowed when 'bAllowAngleDeviation' is active. |
| sTagMode | Enum | Disabled | Controls how production identifiers (tags) are assigned. Options: Disabled, Set Tag, or Set + Create Tag. Affects BOM and labeling. |
| sSeqColor | String | Empty | Defines a custom color palette (RGB values separated by semicolons) for sequential color-coding of hangers in the model. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| TagSettings | Opens a dialog to configure tagging modes and sequential color settings. |
| Allow Angle Deviation | Toggles the angle tolerance setting on/off. Prompts for confirmation and updates the configuration. |
| Show Selection Log | Displays a report of issues or errors if the hanger could not be generated (only appears if issues exist). |
| Show Command for UI Creation | Generates a LISP command string to create a toolbar button for the current specific product configuration. |
| Export Settings | Saves the current configuration (Manufacturer, Family, Tolerances) to an XML file. |
| Import Settings | Loads a previously saved configuration from an XML file. |

## Settings Files
- **Filename**: `GenericHanger.xml` (or manufacturer-specific XMLs).
- **Location**: Company standard paths or hsbCAD installation directories.
- **Purpose**: Stores map configurations defining which manufacturer catalogs (e.g., StrongTie) to use, tolerances, and default product selections.

## Tips
- **Troubleshooting Missing Hangers**: If the hanger does not appear, use the **Show Selection Log** menu item. The most common cause is that the connection angle is slightly off 90°, and the deviation setting is disabled.
- **Non-Standard Connections**: For connections significantly skewed (not 90°), ensure your selected manufacturer catalog includes "Skewed Hangers" or enable **Allow Angle Deviation** if the variance is small.
- **UI Customization**: Use the **Show Command for UI Creation** option if you frequently use a specific hanger type. You can copy the output to create a dedicated toolbar button.

## FAQ
- **Q: Why does the script fail to insert a hanger on two intersecting beams?**
  **A:** Check the "Show Selection Log". It may be due to the connection angle not matching the catalog (try enabling "Allow Angle Deviation"), insufficient clearance, or missing manufacturer XML files.
- **Q: Can I use this script for connections other than 90 degrees?**
  **A:** Yes, provided the manufacturer catalog supports skewed hangers, or if the deviation is minor (usually ±2-5°). Toggle "Allow Angle Deviation" in the right-click menu to accommodate minor variances.
- **Q: How do I share my hanger setup with a colleague?**
  **A:** Use the **Export Settings** context menu item to save your configuration to an XML file. Your colleague can then use **Import Settings** to load it.