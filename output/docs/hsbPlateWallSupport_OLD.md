# hsbPlateWallSupport.mcr

## Overview
This script automates the creation of structural connections between Stud Frame (SF) walls and intersecting main beams (purlins/Pfette). It generates vertical supports within the wall, splits top plates to accommodate beams, and handles sheathing cutouts.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script creates physical beams and geometry in the 3D model. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**:
  - An existing Stud Frame (SF) Wall **Element**.
  - One or more Main Beams (Purlins/Pfette) intersecting the wall.
- **Minimum Beam Count**: 2 (1 Element + 1 Main Beam).
- **Required Settings**:
  - Catalogs for `hsbPlateWallSheetCut` (if sheet cutouts are desired).
  - Catalogs for `T-Connection` (T-Einfräsung) for milling operations.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbPlateWallSupport.mcr`

### Step 2: Select Wall Element
```
Command Line: Select element:
Action: Click on the Stud Frame Wall Element where the connection will be made.
```

### Step 3: Select Main Beams
```
Command Line: Select beams/Pfette:
Action: Select the main beams (purlins) that intersect the wall.
```

### Step 4: Finish Insertion
```
Command Line: 
Action: Press Enter to finish selection. The script will automatically generate the vertical supports, split the top beam, and apply any configured cuts or TSLs.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sType | dropdown | Type 1 | Selects the geometric strategy for the connection (Type 1, 2, 3, or 4). Affects beam placement and splitting logic. |
| dGap | number | 0 | Clearance distance (mm) between the main beam and the new vertical support beams. |
| sCatalog | dropdown | Disabled | Selects a catalog preset for the `hsbPlateWallSheetCut` TSL to automatically cut wall sheets around the connection. |
| sMillingStudPlate | dropdown | [First Available] | Selects the machining catalog for T-Connections (milling) between the new vertical supports and the top plate. |
| sTopOpen | dropdown | No | If set to "Yes", forces a cut or modification in the top beam even if the purlin does not physically touch it. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Reset | Removes the generated vertical support beams and milling, and rejoins the previously split top beams. The TSL instance remains in the drawing. |
| Reset and Delete | Performs a Reset (restores original geometry) and then deletes the TSL instance from the project. |

## Settings Files
- **Catalogs**: `hsbPlateWallSheetCut` and `T-Connection` (or `T-Einfräsung`)
- **Location**: hsbCAD Catalog Database (Company or Install path).
- **Purpose**: Provide the geometric data and machining rules for the vertical supports, milling profiles, and sheet cutouts.

## Tips
- **Modifying Connections**: After insertion, you can change the `sType` or `dGap` in the Properties Palette to adjust the connection geometry without deleting and re-inserting.
- **Cleaning Up**: Use the "Reset" context menu option if you need to temporarily remove the supports but plan to add them back later.
- **Milling Logic**: Ensure the `sMillingStudPlate` catalog matches your material requirements for the stud-to-top-plate connection.
- **Sheet Cutouts**: Remember that sheet cutouts (`hsbPlateWallSheetCut`) are only calculated during the initial insertion. If you need to update sheets after changing geometry, you may need to Reset and re-insert.

## FAQ
- **Q: What happens to the top plate of the wall?**
  A: If the main beam intersects the top plate, the script automatically splits the top beam into two parts to make room for the connection.
- **Q: The script didn't cut my sheets. Why?**
  A: Check the `sCatalog` property. If it is set to "Disabled," the sheet cutout TSL is not executed. Select the appropriate catalog and ensure you are in insertion mode (or reset and re-insert).
- **Q: Can I change the gap size later?**
  A: Yes, simply select the TSL instance, open the Properties palette, and modify the `dGap` value. The vertical supports will update automatically.
- **Q: How do I remove the connection but keep the TSL?**
  A: Right-click the TSL instance and select "Reset". This restores the wall to its original state (joining the top beam) but keeps the script attached for future use.