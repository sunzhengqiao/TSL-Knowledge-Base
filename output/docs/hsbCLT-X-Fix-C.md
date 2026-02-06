# hsbCLT-X-Fix-C.mcr

## Overview
Automates the layout, machining, and detailing of Greenethic X-Fix-C shear connectors along common edges of Cross Laminated Timber (CLT) panels. It generates the necessary 3D milling pockets, attaches hardware data for BOMs, and creates shop drawing annotations.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Generates 3D geometry, pockets, and hardware attachments. |
| Paper Space | No | Script is for 3D modeling only. |
| Shop Drawing | No | Generates data used by shop drawings but must be run in Model Space. |

## Prerequisites
- **Required entities**: CLT Panels (Element or GenBeam).
- **Minimum beam count**: 2 (to define a common edge/joint).
- **Required settings files**: `hsbCLT-X-Fix-C.xml` (Configuration), `TslUtilities.dll`.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-X-Fix-C.mcr`

### Step 2: Select CLT Panels
```
Command Line: Select beams/elements:
Action: Select the two CLT panels that share the common edge where you want to install the connectors.
```

### Step 3: Configure Settings (if prompted)
```
Command Line: |Settings Update| {nameSettings}
Action: If a newer settings file is detected, a dialog will appear. Choose "|Update to new settings|" to use the latest configurations or "|Keep current settings|" to maintain your current parameters.
```

### Step 4: Adjust Parameters
Action: With the script instance selected, modify parameters (Type, Quantity, Spacing) in the AutoCAD Properties Palette to fit your engineering requirements.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sType | String | X-Fix-C (from Settings) | The specific model of the connector (e.g., X-Fix-C 90, X-Fix-C 120). Determines geometry and load capacity. |
| nQty | Integer | Calculated | The number of connectors to distribute along the edge. |
| dInter | Double | Calculated | Center-to-center spacing between connectors (mm). |
| dDepth | Double | Type Dependent | Vertical depth of the pocket milled into the panel (mm). |
| dDoveDepth | Double | Type Dependent | Depth of the dovetail undercut required to lock the mechanism (mm). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Import Settings** | Loads configuration parameters from `hsbCLT-X-Fix-C.xml`, overwriting current instance values. |
| **Export Settings** | Saves the current instance configuration to `hsbCLT-X-Fix-C.xml` for future use. Prompts for overwrite confirmation if the file exists. |
| **Edit in Place** | Isolates a single connector for graphical editing without recalculating the full distribution. |
| **Add/Remove Panels** | Updates the selection set of CLT panels associated with the connector joint. |
| **Flip Alignment** | Reverses the orientation/direction of the connectors along the selected edge. |

## Settings Files
- **Filename**: `hsbCLT-X-Fix-C.xml`
- **Location**: Searches in `_kPathHsbCompany\TSL\Settings` or `_kPathHsbInstall\Content\General\TSL\Settings\`
- **Purpose**: Stores configuration for X-Fix-C tool types, geometric dimensions (depths, dovetails), and default spacing rules.

## Tips
- Use **Edit in Place** to visually adjust a specific connector position without affecting the calculated distribution of the others.
- If the milling pockets look incorrect, check the **sType** parameter to ensure it matches the physical hardware being used.
- The script automatically cleans up old hardware instances attached to the panel before adding new ones, ensuring your BOM remains accurate.

## FAQ
- **Q: How do I change the spacing between connectors?**
  A: Select the script instance and change the `dInter` property in the Properties Palette. The quantity (`nQty`) may update automatically based on the edge length.
- **Q: What happens if I import settings?**
  A: The script will overwrite the current parameters of the selected instance with the values found in the `hsbCLT-X-Fix-C.xml` file.
- **Q: Can I use this on non-CLT elements?**
  A: This script is designed for CLT panels (Element/GenBeam). Using it on standard timber may result in incorrect machining depths.