# Hilti-Verankerung

## Overview
Automates the detailing, drilling, and Bill of Materials (BOM) generation for Hilti wood-to-wood connectors (such as the HCW series). It is used to anchor wall studs or plates to floor beams with precise geometric and hardware data.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D construction and machining. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: A `GenBeam` (e.g., wall stud) or an `Element` (e.g., top/bottom plate).
- **Minimum Beam Count**: 1.
- **Required Settings**: HILTI Catalog files (containing HCW, HCWL, Custom types) must be present in the hsbCAD catalog path.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Hilti-Verankerung.mcr`

### Step 2: Select Reference Entity
```
Command Line: Select element:
Action: Click on the wall stud (GenBeam) or plate (Element) where the Hilti connection is needed.
```

### Step 3: Configure Position
```
Action: Use the AutoCAD Properties Palette (Ctrl+1) to adjust offsets or use grips to move the connector along the beam.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| nVersion | Integer | 0 (Custom) | Selects the Hilti connector profile (0: Custom, 1: HCW, 2: HCWL, 3: HCW-P, 4: Holzdolle, 5: HCWL-K). |
| nFastener | Integer | 0 | Selects the specific screw or rod type from the catalog (if applicable to the version). |
| dOffsetAxisZ | Double | 0 mm | Longitudinal position of the connector along the beam's length. |
| dEdgeOffsetX | Double | 0 mm | Lateral distance from the beam's edge to the center of the connector. |
| bBaufritz | Boolean | False | Enables "Baufritz" prefabrication logic (unlocks Holzdolle/HCWL-K and modifies drilling rules). |
| bExposed | Boolean | True | Toggles between internal/external wall logic (filters catalog entries: 'aw' vs 'zw'). |
| Rotation | Double | 0 deg | The angle of the connector relative to the beam's coordinate system. |
| Diameter | Double | 42 mm | The diameter of the drill hole (only editable if nVersion is 0). |
| Depth | Double | 100 mm | The depth of the drill hole (only editable if nVersion is 0). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| |Hilti Export| | Exports all Hilti-Verankerung and Hilti-Stockschraube instances in the model to a `HiltiExport.dxx` file. |
| [Catalog Entries] (Dynamic) | Lists available connectors (e.g., "HCW D42..."). Selecting one updates the instance properties to match that catalog entry. |

## Settings Files
- **Filename**: HILTI Catalog Files (varies by configuration)
- **Location**: `<hsbCAD Catalog Path>`
- **Purpose**: Provides predefined sets of properties (Type, Diameter, Depth, Offsets) for different HILTI connector versions.

## Tips
- **Toggle Visibility**: If you cannot find a specific connector in the Right-Click menu, toggle the `bExposed` property in the Properties palette. This switches between 'aw' (external) and 'zw' (internal) catalog filters.
- **Baufritz Mode**: If working with Baufritz prefabricated walls, ensure `bBaufritz` is set to `True` to access special connector types like "Holzdolle" and to suppress standard edge distance warnings.
- **Custom Holes**: If you need a non-standard hole size, set `nVersion` to `0` (Custom). This allows manual editing of `Diameter` and `Depth` but will not generate Hardware BOM entries automatically.

## FAQ
- Q: Why are no hardware items appearing in my BOM?
- A: Check if `nVersion` is set to `0` (Custom). Custom holes do not generate automatic BOM entries. Select a specific catalog version (e.g., 1, 2, 3) to generate hardware.
- Q: How do I send data to Hilti design software?
- A: Right-click on any instance of this script and select `|Hilti Export|`. This creates a `.dxx` file in your drawing folder containing all relevant geometric and tooling data.