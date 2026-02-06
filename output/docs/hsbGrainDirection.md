# hsbGrainDirection

## Overview
This script manages and visualizes wood grain direction, surface quality, and nesting preferences for CLT (Cross Laminated Timber) panels. It provides graphical symbols in the 3D model and writes essential production data (like grain angle) to the panel properties for IFC export and CNC optimization.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be attached to a structural element (GenBeam, Element, or ChildPanel). |
| Paper Space | No | This script operates on 3D model entities only. |
| Shop Drawing | No | This is a modeling script, though it influences data used in drawings. |

## Prerequisites
- **Required Entities**: A GenBeam, Element, or ChildPanel (CLT panel) must exist in the model.
- **Minimum Beam Count**: 1 (The script attaches to a single element).
- **Required Settings**: 
  - XML settings file (`hsbGrainDirection.xml`) located in `company\tsl\settings\` (optional but recommended for default configurations).
  - Block definitions `hsbGrainDirectionWall` or `hsbGrainDirectionFloor` (optional, used if specific symbols are required).

## Usage Steps

### Step 1: Launch Script
```
Command: TSLINSERT
Action: Select hsbGrainDirection.mcr from the file list.
```

### Step 2: Select Element
```
Command Line: Select Element/Beam:
Action: Click on the CLT panel or structural beam in the 3D model to which you want to attach the grain information.
```

### Step 3: Configure Properties
```
Action: Once attached, select the element and open the Properties Palette (Ctrl+1).
Action: Adjust parameters like "GrainDirection" or "PreferredNestingFace" as needed.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| GrainDirection | Double | 0 | The angle of the wood grain relative to the panel's local coordinate system (0-360 degrees). |
| PreferredNestingFace | Integer | 0 | Sets which face (Top or Bottom) should face up during CNC cutting (0=None, 1=Top, 2=Bottom). |
| VersalHeight | Double | 50.0 | The height of capital letters used for custom grain marking characters (in millimeters). |
| AssociationColor | String | Red;Green | Colors used to distinguish grain symbols for Wall vs. Floor panels (e.g., "Red;Green"). |
| 3DGrain | Integer | 0 | If set to 1 (Enabled), projects grain geometry onto the panel surface for 3D visualization and IFC export. |
| TextOffset | Double | 10.0 | The distance from the panel edge to the surface quality text labels (in millimeters). |
| SurfaceQuality | String | N/A | The quality classification of specific panel faces (e.g., Visual, Industrial). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Change Grain Direction | Prompts you to click two points in 3D space to graphically define the grain angle. |
| Set Nesting Face Top | Sets the preferred nesting face to the Top face of the panel. |
| Set Nesting Face Bottom | Sets the preferred nesting face to the Bottom face of the panel. |
| Set Nesting Face None | Removes the specific nesting preference. |
| Import Settings | Loads configuration settings from the `hsbGrainDirection.xml` file. |
| Export Settings | Saves current configuration settings to the `hsbGrainDirection.xml` file. |
| Define Character | Allows you to create custom font characters by selecting Polylines in the World XY plane. |

## Settings Files
- **Filename**: `hsbGrainDirection.xml`
- **Location**: `company\tsl\settings\` or the hsbCAD installation directory.
- **Purpose**: Stores default visual settings (colors, text heights, offsets) so they can be shared across projects or users.

## Tips
- **Define Character**: When defining custom characters, ensure you draw the polylines on the **World XY plane** (flat, Z=0). If the geometry is not flat on this plane, the script will reject it.
- **Auto-Detection**: The script automatically detects if the panel is a Wall or a Floor based on its orientation and applies the correct color from the `AssociationColor` property.
- **Visual Check**: Enable the `3DGrain` property if you need to verify the grain direction in a rendered 3D view or if it needs to appear in IFC exports.

## FAQ
- **Q: Why can't I define a new character?**
- **A:** Ensure the polyline you are trying to use is drawn exactly on the World XY plane. If it is drawn in a 3D view or on a different UCS, move it to Z=0 first.
  
- **Q: How do I show the grain direction in an IFC export?**
- **A:** Set the `3DGrain` property to `1`. This ensures the grain geometry is generated on the panel surface and included in the export.

- **Q: What does the "PreferredNestingFace" do?**
- **A:** It tells the CNC optimization software which side of the panel should face upwards. This is useful for panels where one side must remain pristine (Top) or for handling specific quality requirements.