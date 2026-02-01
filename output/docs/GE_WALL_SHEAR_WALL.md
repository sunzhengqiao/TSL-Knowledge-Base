# GE_WALL_SHEAR_WALL

## Overview
Inserts a shear wall definition onto a wall segment to control structural framing (such as nailing patterns, sheathing, and hardware) and generates visual annotations (tags and dimensions) for drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D Wall Elements. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required entities:** A Wall Element must exist in the model.
- **Minimum beam count:** 0
- **Required settings:** `hsbFramingDefaults.Shearwalls.dll` (located in `\\Utilities\\hsbFramingDefaultsEditor`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_WALL_SHEAR_WALL.mcr`

### Step 2: Select Wall
```
Command Line: Select wall
Action: Click on the Wall Element in the model where you want to apply the shear wall definition.
```

### Step 3: Define Start Point
```
Command Line: Select start point
Action: Click a point on the wall to mark the start of the shear wall segment (usually at a corner or opening).
```

### Step 4: Define End Point
```
Command Line: Select end point
Action: Click a point on the wall to mark the end of the shear wall segment.
```

### Step 5: Configure Style
```
Action: The "Shearwall Style Editor" dialog appears automatically. Select a predefined engineering style from the list and configure parameters if necessary. Click OK to confirm or Cancel to abort.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| SHEAR WALL STYLE | Text | | The engineering catalog entry defining structural properties. Can be changed via right-click menu. |
| SYMBOL | Text | | Symbol identifier text. |
| Note | Text | | User-defined text annotation displayed near the shear wall tag. |
| Symbol color | Dropdown | Cyan | Display color of the shear wall symbol and text. |
| Tag shape | Dropdown | Diamond | Shape of the marker: Triangle, Diamond, or None. |
| Offset from wall/hatch depth | Number | 25 | Distance from the wall face to the annotation/hatch. |
| Display start and end points | Dropdown | No | Toggles visibility of the segment start and end point markers. |
| Display | Dropdown | Dashed line | Visual style: Hatch, Dashed line, or None. |
| Dimension style | Dropdown | | AutoCAD dimension style applied to the symbol text. |
| DIMENSION | Text | | Dimension label text. |
| Dimension type | Dropdown | Tag string | Controls length display: Tag string, Dimension line, or None. |
| Round down options | Dropdown | Nearest cm | Rounding rule if 'Dimension line' is used. |
| Dimension style | Dropdown | | AutoCAD dimension style applied to the dimension line. |
| Dimension color | Dropdown | Cyan | Color of the dimension line or tag text. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Change style | Opens the Shearwall Style Editor dialog. Selecting a new style updates the structural data and resets visual properties (colors, shapes, offsets) to the new style's defaults. |

## Settings Files
- **Filename**: `hsbFramingDefaults.Shearwalls.dll`
- **Location**: `\\Utilities\\hsbFramingDefaultsEditor`
- **Purpose**: Provides the Shearwall Style Editor interface and the database of engineering styles (nailing, sheathing, hardware).

## Tips
- **Moving Walls**: If you move or stretch the Wall Element using standard AutoCAD grips, the shear wall instance and annotations will move with it automatically.
- **Style Overrides**: If you manually change properties (like Color or Shape) in the Properties Palette, avoid using the "Change style" right-click option afterward, as it will reset your manual changes to the style's default values.
- **Framing Application**: This script sets the *directives* for the wall. You must run the wall framing generation process separately to see the physical changes (studs, nailing, etc.) in the model.

## FAQ
- **Q: Why did my custom tag color disappear after I updated the style?**
  - **A:** Using the "Change style" context menu item reloads all display parameters from the selected style definition. You will need to manually adjust the color again in the Properties Palette if you wish to deviate from the style default.
- **Q: Does this script actually cut holes or add studs to my wall?**
  - **A:** No. It attaches a construction map (`ElementShearwallInsertDirective`) to the wall. The hsb Framing engine reads this map during the framing generation process to determine the correct materials and hardware.
- **Q: What happens if I cancel the Style Editor dialog during insertion?**
  - **A:** The script detects the cancellation and erases the instance immediately. No geometry or properties will be created.