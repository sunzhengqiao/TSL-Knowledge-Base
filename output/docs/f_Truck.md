# f_Truck.mcr

## Overview
Automates the calculation, visualization, and documentation of loading timber packages onto trucks or logistics grids. It optimizes stacking arrangements, calculates axle loads and center of gravity, and generates transport drawings to ensure safety and compliance.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D visualization and spatial calculations. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: Elements, GenBeams, or Bodies representing the timber package to be loaded.
- **Required Settings Files**: An XML configuration file (e.g., `Truck.xml`) containing truck profiles, axle definitions, and design constraints.
- **Minimum Beam Count**: 0 (The script can calculate an empty truck frame).

## Usage Steps

### Step 1: Launch Script
```
Command: TSLINSERT
Action: Select 'f_Truck.mcr' from the file list and click Open.
```

### Step 2: Configure Truck Profile
```
Action: After insertion, select the new f_Truck instance in the model. Open the Properties Palette (Ctrl+1).
Action: Locate the 'sTruckName' property and select a valid truck profile from your XML configuration (e.g., "Truck_24t").
```
*The truck visualization and axle data will load automatically based on this selection.*

### Step 3: Assign and Adjust Load
```
Action: Link your timber package (Elements/Beams) to the truck instance (method depends on specific company workflow tools).
Action: In the Properties Palette, adjust the 'FrontDistance' to shift the load forward or backward along the truck bed.
```
*Watch the 'AxleLoads' and COG visualization update to find the optimal balance.*

### Step 4: Finalize Settings
```
Action: Set 'bIsKlh' to True if loading CLT/KLH panels to use specific orientation logic.
Action: Toggle 'nPackageWrapped' to Yes if the load will be foil-wrapped.
Action: Set 'nApplyLayerSeparation' to Yes if battens are required between layers.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Design** | Integer | 0 | Selects the operation mode (e.g., 0 = Truck View, 1 = Grid View). Determines the visual representation and calculation rules. |
| **sTruckName** | String | "" | The name of the truck configuration to use. Must match a key defined in your XML settings file. |
| **bIsKlh** | Boolean | false | If 'True', activates logic optimized for cross-laminated timber (KLH) panels, including specific coordinate transformations. |
| **FrontDistance** | Double | 0 | The distance from the front of the truck to the start of the load. Use this to optimize axle weight distribution. |
| **RowOffset** | Double | 0 | The vertical distance between stacked rows (layers). Increasing this adds to the total height of the load. |
| **nApplyLayerSeparation** | Integer | 0 | Specifies if separation layers (like battens) are added between timber layers (0 = No, 1 = Yes). |
| **nPackageWrapped** | Integer | 0 | Indicates if the package is weather-protected/wrapped (0 = No, 1 = Yes). Used for documentation. |
| **vecX / vecY / vecZ** | Vector | World | Defines the orientation of the truck in the 3D model. Usually set by the insertion point. |
| **dWeight** | Double | 0 | (Read-only) Displays the total calculated weight of the loaded truck. |
| **ptCOG** | Point3d | 0,0,0 | (Read-only) Displays the calculated Center of Gravity for the load. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Recalculate** | Refreshes the script to update the visualization and load calculations after changing properties or linked entities. |
| **Generate Plot Viewports** | Creates hsbPivotSchedule entities and viewports for detailing the load arrangement in drawings. |
| **Apply Layer Separation** | (KLH Mode) Forces the script to recalculate the stack assuming battens/spacers exist between layers. |

## Settings Files
- **Filename**: `Truck.xml` (or equivalent defined in script).
- **Location**: `hsbCompany` or `hsbInstall` directory.
- **Purpose**: Defines the geometry of available trucks (length, width, axle positions), maximum load limits, and visual block properties.

## Tips
- **Balancing Loads**: If an axle turns red or exceeds the limit in the visualization, increase or decrease the **FrontDistance** to shift the Center of Gravity (COG) over the axles.
- **Height Limits**: Monitor the total height when increasing **RowOffset** or applying layer separation to ensure the load fits under bridges or into transport tunnels.
- **KLH Panels**: Always toggle **bIsKlh** to 'True' for cross-laminated timber to ensure correct orientation and property handling.
- **Visualization**: The script draws a "shadow" of the load on the truck bed. If your timber elements are missing, check that they are correctly assigned to the truck instance.

## FAQ
- **Q: Why do I see an error or no truck appears after insertion?**
- A: Check that the **sTruckName** property matches an entry exactly as written in your configuration XML file. If the file is missing from your `hsbCompany` folder, the script cannot load the geometry.

- **Q: How do I check if my truck is legally loaded?**
- A: Look at the displayed dimensions and the **dWeight** property. The script visualizes the COG; ensure it falls within the safe zone relative to the axles. Use the properties to verify individual axle loads against legal limits.

- **Q: Can I use this for storage planning instead of transport?**
- A: Yes. Change the **Design** parameter to "Grid" mode (if configured in your XML) to visualize an abstract stacking grid without truck axles or chassis limitations.