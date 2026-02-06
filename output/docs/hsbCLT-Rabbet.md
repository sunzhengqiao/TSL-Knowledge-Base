# hsbCLT-Rabbet.mcr

## Overview
Automates the creation of rabbet and tenon joints for connecting CLT panels (T-connections). It generates the necessary machining cuts and 3D geometry to create a structural interlock between a male and female panel.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for selecting Sip/CLT entities and performing 3D boolean operations. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | This script operates on the 3D model geometry, not 2D drawings. |

## Prerequisites
- **Required Entities**: At least two CLT/Sip panels in the model.
- **Minimum Count**: 2 Panels (1 Male, 1 or more Female).
- **Geometry**: Panels must be non-parallel (forming a T-junction).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-Rabbet.mcr` from the list.

### Step 2: Configuration
- **Catalog Mode**: If a catalog entry was selected, properties load automatically.
- **Manual Mode**: If no catalog is used, a Properties Dialog will appear. Adjust settings (Width, Depth, Gaps) and click OK.

### Step 3: Select Male Panel
```
Command Line: Select male panel
Action: Click on the panel that will insert into the other (the Tenon).
```

### Step 4: Select Female Panels
```
Command Line: Select female panel(s)
Action: Click on the receiving panel(s) (the Groove). Press Enter to finish selection.
```

### Step 5: Validation and Generation
The script checks for valid intersections. If successful, it calculates the toolpath and generates the rabbet geometry.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| dWidth | Number | 50 | Width of the tenon. Set to `0` to automatically use 50% of panel thickness. |
| dDepth | Number | 20 | Depth of the cut into the female panel (penetration depth). |
| dGapSide | Number | 0 | Clearance gap on the reference side of the tenon (allows for tolerances). |
| dGapSide2 | Number | 0 | Clearance gap on the opposite side of the tenon. |
| dGapDepth | Number | 0 | Gap at the bottom of the groove to prevent the panels from bottoming out. |
| sAlignment | Dropdown | Reference Side | Positions the joint: **Reference Side**, **Center**, or **Opposite Side**. |
| dOffset | Number | 50 | Manual offset distance from the reference side to fine-tune position. |
| sTool | Dropdown | Contact | Vertical tool extension: **Contact**, **towards bottom**, **towards top**, or **both sides**. |
| sToolShape | Dropdown | not rounded | Corner geometry: **not rounded**, **round**, or **rounded**. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Toggle Alignment | Double-click the script instance in the model to cycle alignment (Reference -> Center -> Opposite). |
| Update / Recalculate | Recalculates the joint if panels have been moved or parameters changed. |

## Settings Files
- **Catalog**: Standard hsbCAD Catalogs.
- **Purpose**: Allows saving predefined parameter sets (Width, Depth, Gaps) for quick insertion without opening the dialog.

## Tips
- **Automatic Width**: Setting `dWidth` to `0` is a quick way to center the tenon within the panel thickness.
- **Long Joints**: If the joint length exceeds 1500mm, the script automatically forces the Tool Shape to `not rounded` to prevent machining errors.
- **Editing**: You can move or rotate the connected panels using standard AutoCAD commands; the script will update the joint geometry automatically upon recalculation.
- **Asymmetry**: In "Standard" connections (low angle), the script forces `dGapSide2` to equal `dGapSide` to maintain machining symmetry.

## FAQ
- **Q: Why does the script fail with "Panels may not be parallel"?**
  - **A**: This tool is designed for T-connections (intersecting planes). It cannot create a joint between two panels that run exactly parallel to each other.
- **Q: How do I quickly switch the joint to the center of the panel?**
  - **A**: Double-click the script instance in the model to cycle the `sAlignment` property until it reaches "Center".
- **Q: Can I use this on floor panels?**
  - **A**: Yes, provided the geometry represents a valid T-connection between Sip/CLT entities, regardless of orientation (wall or floor).