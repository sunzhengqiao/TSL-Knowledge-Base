# Rothoblaas WHT

## Overview
This script inserts and configures Rothoblaas WHT hold-down anchors (shear wall tension anchors) onto timber beams, panels, or StickFrame Walls. It automatically manages the 3D geometry, drilling positions, and non-nail zones based on the selected hardware model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates within the 3D model. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Does not generate shop drawings directly. |

## Prerequisites
- **Required Entities**: A `GenBeam`, `Element`, or `StickFrame Wall` must exist in the model to host the anchor.
- **Minimum Beam Count**: 1 (you must select a timber element to attach the fixture).
- **Required Settings**: `FixtureDefinition.xml` (Expected in `hsbCompany\TSL\Settings` or `hsbInstall\Content\General\TSL\Settings`). If missing, the script will use hardcoded defaults.

## Usage Steps

### Step 1: Launch Script
```
Command Line: TSLINSERT
Action: Select "Rothoblaas WHT.mcr" from the list of available scripts.
```

### Step 2: Select Host Element
```
Command Line: Select beam/element/wall:
Action: Click on the timber beam, wall panel, or StickFrame Wall where you want to place the WHT anchor.
```

### Step 3: Configure Properties
```
Action: Press `Esc` to finish selection, then select the inserted script instance.
Action: Open the Properties Palette (Ctrl+1).
Action: Change the "Article" property to select the specific WHT model (e.g., WHT340).
Action: Adjust Scale X/Y/Z if necessary to stretch the fixture geometry.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Article | String | "" | The specific product code (e.g., WHT340, WHT440) defining the geometry and drilling. |
| Manufacturer | String | "" | The name of the hardware supplier (e.g., Rothoblaas). |
| Description | String | "" | A detailed text description of the fixture. |
| Category | String | "" | Functional group for the fixture (e.g., HoldDown). |
| Model | String | "" | The specific model designation or variant. |
| Scale X | Double | 0 | Scaling factor for width (0 implies default dimensions). |
| Scale Y | Double | 0 | Scaling factor for thickness/depth. |
| Scale Z | Double | 0 | Scaling factor for height. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add Fixing | Opens a dialog to define a new custom fixture article and geometry, adding it to the settings file. |
| Add Fixture to Rothoblaas WHT | Opens a dialog to select an existing fixture from the general list to make available in this specific script. |
| Delete Fixing | Opens a dialog to select and remove an article from the script's available fixtures. |
| Export Settings | Prompts to save the current fixture configuration to `FixtureDefinition.xml` (useful for backups). |

## Settings Files
- **Filename**: `FixtureDefinition.xml`
- **Location**: `hsbCompany\TSL\Settings` or `hsbInstall\Content\General\TSL\Settings`
- **Purpose**: Stores custom definitions of fixture articles, including their geometry dimensions, machining data, and manufacturer info.

## Tips
- **Scaling**: If the standard dimensions of a WHT model do not match your specific requirement, use the `Scale X`, `Scale Y`, and `Scale Z` properties to stretch the 3D body and drilling pattern without creating a new fixture definition.
- **Custom Fixtures**: Use the "Add Fixing" context menu option to create definitions for non-standard or modified anchors that you use frequently.
- **Backup**: Before making bulk changes to fixtures, use "Export Settings" to ensure your configurations can be restored or shared with colleagues.

## FAQ
- **Q: How do I switch between different WHT sizes (e.g., from WHT340 to WHT540)?**
  - A: Select the inserted anchor in the model, open the Properties Palette (Ctrl+1), and type the new model code (e.g., "WHT540") into the "Article" field.
- **Q: What happens if the XML settings file is missing?**
  - A: The script will fall back to a built-in list of standard Rothoblaas WHT models (WHT340, WHT440, etc.) with default dimensions.
- **Q: Can I use this on walls other than StickFrame Walls?**
  - A: Yes, the script supports standard `GenBeam` entities and timber `Elements` (panels) in addition to StickFrame Walls.