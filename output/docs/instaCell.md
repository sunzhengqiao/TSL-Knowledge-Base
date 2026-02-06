# instaCell.mcr

## Overview
Inserts and manages installation "cells" (e.g., electrical boxes, switches, service penetrations) that combine visual block representations with physical CNC machining operations (drilling, mortising, cutting).

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary environment for inserting cells and generating machining. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: A host `Element` (Stickframe Wall or Roof) or `GenBeam` is optional but recommended for machining. If no host is selected, the cell acts as a standalone block.
- **Settings Files**: `instaCombination.xml` (Located in Company or Install path).
- **Block Library**: Access to the folder `hsbCompany\Block\insta` (or custom path defined in settings) to read/write block definitions.

## Usage Steps

### Step 1: Launch Script
```
Command Line: TSLINSERT
Action: Select 'instaCell.mcr' from the list of available scripts.
```

### Step 2: Define Placement
```
Command Line: Select Element or [Pick Point]:
Action: Click on a timber beam or wall element to host the cell, or press Enter to place it in free space (Model Space only).
```

### Step 3: Configure Properties
```
Action: Select the inserted instance and open the Properties (OPM) palette.
Details: Enter the Blockname, Category, and Sub Category to load the correct visual block and machining tools.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Blockname | String | Empty | The specific name of the block definition (DWG file) to use (e.g., "Socket_1G"). |
| Category | String | Electra | The main group for organizing blocks (e.g., "Electra", "Plumbing"). Used for folder structure. |
| Sub Category | String | Switches | The subgroup for organizing blocks (e.g., "Switches", "Lights"). Used for sub-folder structure. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Hide Tools | Hides all CNC tools (drills, mortises, cuts) in the model view. |
| Show Tools | Displays all CNC tools associated with the cell. |
| Swap Width <-> Height | Swaps the width and height dimensions for mortise or beamcut tools. |
| Set block definition | Opens a dialog to define or update the current block, saving it to the DWG library. |
| Store hardware in block definition | Clones hardware from this specific instance and saves it into the block definition, making it standard for all instances of this block. |
| Show all Commands for UI Creation | Displays a list of command strings used to create custom tool buttons for this script. |

## Settings Files
- **Filename**: `instaCombination.xml`
- **Location**: `_kPathHsbCompany\TSL\Settings` or `_kPathHsbInstall\Content\General\TSL\Settings\`
- **Purpose**: Controls script settings including display styles, block file paths, and version management.

## Tips
- **Folder Management**: When using the "Set block definition" command, the script automatically creates the Category and Sub Category folders in your block library if they do not exist.
- **Visualizing Machining**: Use the "Show Tools" context menu option to verify that the correct holes or cuts are generated in the host timber.
- **Batch Updates**: If you modify a block definition using the context menu, all existing instances in the model referencing that block name can be updated.
- **Creating UI**: Use "Show all Commands for UI Creation" to get the specific strings needed to add buttons to your toolbars or ribbon for quick insertion of specific cells.

## FAQ
- **Q: Why did I get a notice about version mismatch when inserting?**
  **A:** The script detected that the version of `instaCombination.xml` in your Company folder differs from the default installation version. Review the settings to ensure compatibility.
- **Q: Can I use this without a beam?**
  **A:** Yes, you can pick a point in free space to insert the visual block, but no machining tools will be generated without a host beam or element.
- **Q: How do I add standard screws to this electrical box?**
  **A:** Insert the screws as hardware on the instance, then right-click and select "Store hardware in block definition" to save them as part of the block for future use.