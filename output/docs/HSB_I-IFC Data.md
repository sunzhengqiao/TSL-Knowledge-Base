# HSB_I-IFC Data.mcr

## Overview
This script attaches structural metadata (Element ID, Floor, House, and Zone) to selected timber entities as IFC Property Sets. It is used to prepare hsbCAD models for BIM export by embedding necessary project hierarchy information directly into the components.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the model where your timber components are located. |
| Paper Space | No | Not applicable for layout or drawing views. |
| Shop Drawing | No | Not applicable for shop drawing generation. |

## Prerequisites
- **Required Entities**: You must have at least one entity (Beam, Wall, or Element) in the model.
- **Data Preparation**: Entities should be assigned to an **Element** (with a production number) and belong to a **Group** (with House/Floor hierarchy) before running the script for best results.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Select `HSB_I-IFC Data.mcr` from the file dialog.

### Step 2: Select Entities
```
Command Line: Select one or more entity
Action: Click on the beams, walls, or assemblies you want to export data for. Press Enter to confirm selection.
```

### Step 3: Completion
The script will automatically process the selection, attach the property data, and then remove itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script runs as a one-time command and does not create a persistent object with editable properties. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not remain in the model to offer right-click menu options. |

## Settings Files
- **None**: This script operates entirely on existing project data and does not require external settings files.

## Tips
- **Check Group Structure**: Ensure your Groups are named consistently (e.g., `HouseName.FloorName`) so the script can correctly identify the "House" and "Floor" data.
- **Re-running**: You can run this script multiple times on the same entities if you update their Element Numbers or Group assignments. It will update the existing IFC properties.
- **Verification**: To verify the data was attached, select an entity and look at the Extended Data or Property Sets in the AutoCAD Properties palette (depending on your hsbCAD/IFC configuration viewer).

## FAQ
- **Q: The script disappeared after I ran it. Is that normal?**
  - A: Yes. This is a "utility" script designed to perform a task and delete itself (`eraseInstance`) so it does not clutter your model.
- **Q: Why does the IFC data show "-" for Floor or House?**
  - A: The script extracts this information from the entity's Group name. If the entity is not assigned to a Group, or the Group name does not follow the expected hierarchy, it will default to "-".
- **Q: Can I use this to manually type in IFC data?**
  - A: No. This script acts as a bridge between your internal hsbCAD Element/Group data and the IFC export format. Edit the Element or Group properties in hsbCAD, then run this script to update the IFC tags.