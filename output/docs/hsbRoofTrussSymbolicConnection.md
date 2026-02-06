# hsbRoofTrussSymbolicConnection.mcr

## Overview
This script creates a visual symbol and establishes a logical link between two roof trusses. It is typically used to indicate where a truss sits on or is supported by another truss (e.g., in truss girder systems) without generating physical machining or hardware.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be used in the 3D model. |
| Paper Space | No | Not applicable for layouts. |
| Shop Drawing | No | Does not generate 2D drawing details. |

## Prerequisites
- **Required Entities**: Two existing roof trusses (`TrussEntity`).
- **Minimum Beam Count**: 0 (It operates on Truss Entities, not standard beams).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbRoofTrussSymbolicConnection.mcr`

### Step 2: Select the Carried Truss
```
Command Line: Select carried truss
Action: Click on the truss that is being supported (the top truss).
```

### Step 3: Select the Carrier Truss
```
Command Line: Select carrier truss
Action: Click on the truss providing the support (the bottom or girder truss).
```

### Step 4: Verify Creation
The script will automatically draw the symbolic connection:
- **Blue Rings**: Placed on the carried truss.
- **Green Rings**: Placed on the carrier truss.
- **Red Line**: Connects the two trusses.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Symbol size (`pSymbolSize`) | Number | 120 mm | Defines the diameter of the circular symbols used to mark the connection point. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are provided. |

## Settings Files
- No external settings files are required for this script.

## Tips
- **Automatic Updates**: If you move or modify the geometry of either truss, the connection symbol and line will update automatically to maintain the link.
- **Visual Clarity**: You can adjust the `Symbol size` in the properties palette if the default rings are too small or too large for your model scale.
- **Deletion**: If you delete one of the connected trusses, the script will detect the missing entity and delete itself automatically.
- **Color Coding**: Remember the color codes for troubleshooting: Blue = Host (Carried), Green = Carrier (Support), Red = Connection Path.

## FAQ
- **Q: The script vanished immediately after I selected the trusses. Why?**
  **A:** This usually happens if the selected objects were not valid TrussEntities or if the selection was interrupted. The script requires exactly two valid roof trusses to function. Simply re-run the command and ensure you click on valid truss objects.

- **Q: Does this script cut holes or add bolts to the trusses?**
  **A:** No. This script is purely symbolic. It creates a visual representation and a logical data link for the model, but it does not generate any physical machining or CNC data.

- **Q: Can I change the colors of the symbols?**
  **A:** No, the colors are hardcoded into the script (Blue/Green/Red) to maintain consistency in the model display.