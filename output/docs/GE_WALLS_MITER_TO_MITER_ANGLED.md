# GE_WALLS_MITER_TO_MITER_ANGLED.mcr

## Overview
Automates the connection of two angled walls (e.g., bay windows or chamfered corners) by trimming interfering studs, creating corner filler beams, lapping top plates, and cutting sheathing to fit the miter angle.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be applied to 3D wall elements. |
| Paper Space | No | Not intended for layout or detailing views. |
| Shop Drawing | No | Not intended for generating 2D outputs directly. |

## Prerequisites
- **Required Entities**: 2 `ElementWall` entities that physically touch each other.
- **Geometry**: Walls must meet at an angle (cannot be parallel or perpendicular/90°).
- **Required Settings**: `hsbFramingDefaults.Inventory.dll` (must be present in the hsbCAD install path).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse and select `GE_WALLS_MITER_TO_MITER_ANGLED.mcr`

### Step 2: Select Walls
```
Command Line: |Select 2 angled elements|
Action: Click on the first wall, then click on the second wall that forms the angled corner.
```

### Step 3: Configure Properties
After selection, the Properties Palette (OPM) will display the script parameters. Adjust the connection type, lapping options, and material properties as needed. The model updates automatically based on these changes.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Connection type | dropdown | Mitered End with Assembly | Determines the geometry of the corner (e.g., Mitered, Squared, Beveled Stud). |
| Lap top plates | dropdown | No | If Yes, the top plates of the two walls will overlap at the corner. |
| Switch lap side | dropdown | No | Toggles which wall's top plate sits on top of the other (vertical ordering). |
| VTP|Lap limits| | number | 3.175mm | The clearance or offset distance applied to top plates during lapping. |
| Sheeting limits | number | 3.175mm | The offset distance from the intersection for cutting the wall sheathing. |
| Apply custom properties to new beams | dropdown | No | If Yes, new corner beams use the specific properties defined below. If No, they inherit properties from the wall. |
| Name | text | SYP #2 2x4 | The stock name for new corner beams (active if Custom Props is Yes). |
| Material | text | SYP | The material species for new corner beams. |
| Grade | text | #2 | The structural grade for new corner beams. |
| Information | text | STUD | Usage classification for new corner beams. |
| Label | text | | Primary label text for new beams. |
| Sublabel | text | | Secondary label text. |
| Sublabel2 | text | | Additional label text. |
| Beam code | text | ;;;;;;;;;;;;; | Semicolon-separated code string for new beams. |
| Beam color | integer | 3 | The AutoCAD color index for new beams. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add custom items to the right-click context menu. Edit parameters via the Properties Palette. |

## Settings Files
- **Filename**: `hsbFramingDefaults.Inventory.dll`
- **Location**: `_kPathHsbInstall` (hsbCAD Installation Directory)
- **Purpose**: Provides access to the lumber inventory database for beam properties.

## Tips
- **Wall Angle**: This script is designed specifically for *angled* connections (miter-to-miter). It will erase itself if applied to standard 90° corners or parallel walls.
- **Top Plate Lapping**: Use the "Switch lap side" option to resolve structural sequencing requirements where one top plate must run continuously over the other.
- **Custom Properties**: Use "Apply custom properties to new beams" if the corner requires a different grade or material than the rest of the wall framing (e.g., a pressure-treated post in a bay window).

## FAQ
- **Q: Why did the script disappear immediately after I selected the walls?**
  A: The script performs validation checks. It will erase itself if the walls are not touching, are parallel, or form a 90° angle.
- **Q: Can I use this for a 90-degree corner?**
  A: No. This script is specifically for angled (mitered) connections.
- **Q: How do I change the gap between the sheathing panels?**
  A: Adjust the "Sheeting limits" parameter in the Properties Panel.
- **Q: The corner studs aren't the same size as the wall studs.**
  A: Check the "Apply custom properties to new beams" setting. If it is set to "Yes", ensure the "Name" and dimensions match your requirements. If set to "No", the script copies properties from existing studs in the wall.