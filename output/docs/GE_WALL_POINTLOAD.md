# GE_WALL_POINTLOAD.mcr

## Overview
Automatically generates a reinforcing stud pack (point load) at a specific location on a wall to support vertical loads, such as from a beam or header landing. It handles collision detection by cutting or shifting existing studs to accommodate the new reinforcement.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates on ElementWall entities and creates physical 3D studs. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This script is for model generation, not drawing creation. |

## Prerequisites
- **Required Entities**: An existing `ElementWall` in the model.
- **Minimum Beam Count**: None.
- **Required Settings**:
    - `hsbFramingDefaults.Inventory.dll`: Must be accessible (usually found in the hsbCAD install utilities) to provide lumber sizes and grades.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_WALL_POINTLOAD.mcr`

### Step 2: Select Wall
```
Command Line: Select a set of Walls
Action: Click on the wall in ModelSpace where you want to add the point load support.
```

### Step 3: Define Location
```
Command Line: Select an insertion point
Action: Click on the wall face at the specific position where the load will be applied.
```

### Step 4: Configure Properties
```
Action: The Dynamic Dialog appears automatically. 
- Select the desired Lumber Item (e.g., 2x4).
- Set the Number of Beams (e.g., 3 studs).
- Adjust display settings (Text or X marker).
- Click OK to generate.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Number of Beams in Point Load | Number | 0 | The quantity of reinforcing studs to generate (usually 1 to 6). |
| Lumber item | Dropdown | *From Defaults* | Select the timber grade and size (e.g., 2x6 S-P-F) from the inventory list. |
| Color for new Beams | Number | 1 | The AutoCAD color index for the generated studs (1 = Red, -1 = ByLayer, etc.). |
| What display to use | Dropdown | Mark Location with an X | Choose between "Identify with Text" (shows count like "3x") or "Mark Location with an X". |
| DimStyle | Dropdown | -1 | Selects the dimension style used for text annotation. |
| Offset text from wall | Number | U(7) | Distance from the wall face to the annotation text. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Re-Create Point Load | Forces a full recalculation. Deletes existing studs created by this instance and regenerates them based on the current properties and location. Useful after moving the insertion grip or changing lumber sizes. |

## Settings Files
- **Filename**: `hsbFramingDefaults.Inventory.dll`
- **Location**: `_kPathHsbInstall\Utilities\hsbFramingDefaultsEditor`
- **Purpose**: Provides the list of available lumber items, including their width, height, material, and grade properties.

## Tips
- **Visual Warnings**: If the script displays the location marker in **Red**, it means the point load is too close to an opening or header, and no studs were created. Move the script grip away from the opening.
- **Existing Studs**: The script automatically detects standard studs in the way. It will either cut them (if deep inside the point load zone) or shift them (if near the edge) to make room.
- **Grip Editing**: After insertion, you can click and drag the script's insertion grip (usually the 'X' or text location) to slide the point load along the wall. It will recalculate automatically.
- **Empty Walls**: If the wall does not have Top or Bottom plates assigned, the script will fail with a "No Plates found" warning.

## FAQ
- **Q: Why didn't the script generate any studs?**
  **A:** The location might be overlapping with a wall opening (header) or the wall might be missing structural plates. Check for a Red warning marker or move the insertion point.
- **Q: What happens if I change the lumber item?**
  **A:** Use the "Re-Create Point Load" right-click option (or modify the property in the palette) to update the dimensions and material of the existing studs.
- **Q: Can I use this for a single stud?**
  **A:** Yes, set the "Number of Beams in Point Load" property to 1.