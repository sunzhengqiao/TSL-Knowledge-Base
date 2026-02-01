# HSB_E-SetZone.mcr

## Overview
This script allows you to batch modify the material thickness of a specific layer (zone) within selected hsbCAD Elements (walls, floors, or roofs). It is useful for updating the depth of sheathing, cladding, or structural layers across multiple elements without needing to redraw or manually edit each element's individual composition.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates directly on 3D Element entities in the model. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required entities**: Element (Wall, Floor, or Roof).
- **Minimum beam count**: 0 (This script works on Elements, not individual Beams).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-SetZone.mcr`

### Step 2: Configure Properties
Upon launching, the **Properties Palette** (OPM) will display the script parameters. Adjust the settings before proceeding to selection.
- **Zone to change**: Select the layer number (1-10) you wish to modify.
- **New thickness**: Enter the desired thickness for that layer.

### Step 3: Select Elements
```
Command Line: Select elements
Action: Click on the Wall, Floor, or Roof elements you wish to update. You can select multiple elements at once. Press Enter to confirm selection.
```

### Step 4: Execution
The script will automatically apply the new thickness to the specified zone for all selected elements and then finish. No persistent object is left in the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone to change | Dropdown (1-10) | 0 | Selects the specific material layer to modify. **1-5** refer to layers on the primary side. **6-10** refer to layers on the secondary side. |
| New thickness | Number | 12 mm | The new thickness (depth) to apply to the selected layer. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add persistent context menu options to the drawing entities. |

## Settings Files
- None

## Tips
- **Zone Indexing**: If you are unsure which number corresponds to the material layer you want to change, you can check the element's standard properties to see the build-up order, or use the script on a test element first.
- **Negative Indices**: Internally, zones 6-10 are handled as "negative" indices (e.g., -1 to -5), representing the secondary side of the element construction.
- **Batch Processing**: You can select as many elements as needed in a single command to ensure consistent changes across a project.

## FAQ
- **Q: What happens if I select "0" for the Zone to change?**
  A: The script may default to the first zone or fail to update depending on internal logic. Always select a value between 1 and 10.
- **Q: Does this script create new geometry?**
  A: No, it modifies the existing geometric properties of the selected Elements. The changes will be reflected immediately in the 3D model and subsequent drawings.
- **Q: Why did the script disappear after running?**
  A: This is a "command" script. It performs the modification and self-destructs (erases its instance) automatically. The changes remain on the Elements.