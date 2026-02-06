# hsb_OverwriteTConnection

## Overview
This script automatically detects T-connections between two timber walls and resolves the intersection by either inserting a new timber stud or applying a specific connection script (e.g., for metalwork plates). It is a utility script that processes the selected walls and then removes itself from the drawing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not applicable to 2D generation. |

## Prerequisites
- **Required Entities**: At least two connected wall elements (`ElementWallSF`) in the model.
- **Minimum Requirements**: The walls must form a T-junction or intersection where a connection is needed.
- **Configuration**: Map entries (Execution Keys) should be configured beforehand if you need to filter by specific wall codes or use a specific hardware catalog.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_OverwriteTConnection.mcr` from the list.

### Step 2: Select Walls
```
Command Line: Select 2 Walls Connected
Action: Click on the first wall element, then click on the second connected wall element to form a pair.
```

### Step 3: Automatic Processing
Once two walls are selected, the script automatically validates the connection, calculates the required gaps, and applies the solution (new stud or hardware). The script instance will immediately disappear from the database upon completion.

## Configuration Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Catalog | String | Empty | Specifies the catalog name to be used for the connection hardware (e.g., metal plates). This is used if 'Stud' is set to FALSE. |
| Wall | String | Empty | Filters which wall connections are processed. Only walls matching this code (e.g., 'EXT', 'INT') will trigger the connection update. |
| Stud | Boolean | FALSE | Determines the solution type. If TRUE, the script creates a new timber stud. If FALSE, it runs the 'hsb_Wall to Wall Connection' script to generate hardware. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | This script does not provide persistent right-click menu options as it erases itself after running. |

## Settings Files
- **Type**: Map Entries / Execution Keys
- **Purpose**: These entries allow you to pre-define the 'Catalog', 'Wall', and 'Stud' settings so the script runs with specific parameters without manual input every time.

## Tips
- **Self-Cleaning**: Do not be alarmed if the script icon disappears from the insertion point immediately after running; this is intended behavior. It is a "fire and forget" utility.
- **Gap Requirements**: The script calculates the gap between existing studs. It will only insert a new stud or connection if the gap is larger than the current beam spacing plus 5mm.
- **Wall Codes**: If the script seems to do nothing, check if the 'Wall' parameter is set to a specific code that your selected walls do not match. Leaving it empty usually allows it to process any wall.

## FAQ
- **Q: Why did the script disappear immediately after I selected the walls?**
  - A: The script is designed to process the geometry and then erase itself (`eraseInstance`). It does not remain as a persistent object in the drawing tree.
- **Q: I selected two walls, but no stud or connection was created. Why?**
  - A: Check that the gap between existing studs is large enough (greater than beam spacing + 5mm). Also, verify that the connected walls match the filter code defined in the 'Wall' parameter.
- **Q: Can I use this to add metal plates instead of studs?**
  - A: Yes. Set the 'Stud' parameter to FALSE and ensure the 'Catalog' parameter points to a valid catalog containing your connection details.