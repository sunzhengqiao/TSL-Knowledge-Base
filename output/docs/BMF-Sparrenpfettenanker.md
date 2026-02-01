# BMF-Sparrenpfettenanker.mcr

## Overview
This script inserts a BMF brand metal purlin anchor (Sparrenpfettenanker) to connect two beams, typically a rafter and a purlin. It generates the 3D geometry for the metal plate(s) and optionally adds nails to the Bill of Materials (BOM).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in 3D model space to construct geometry. |
| Paper Space | No | Not designed for layout or detailing views. |
| Shop Drawing | No | This is a modeling/connection script. |

## Prerequisites
- **Required Entities**: 2 `GenBeam` elements (e.g., a Rafter and a Purlin).
- **Minimum Beam Count**: 2 Beams must be selected during insertion.
- **Required Settings**: None specific (uses standard material catalogs).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `BMF-Sparrenpfettenanker.mcr` from the list.

### Step 2: Select First Beam
```
Command Line: Select beam:
Action: Click on the first beam (e.g., the purlin).
```

### Step 3: Select Second Beam
```
Command Line: Select beam:
Action: Click on the second beam (e.g., the rafter) that intersects or meets the first beam.
```

### Step 4: Configuration
```
Action: The script will initialize the anchor at the intersection. Use the Properties Palette (Ctrl+1) to adjust dimensions, materials, and nail configurations as required.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sType | dropdown | 170 BMF-Sparrenpfettenanker | Selects the product model and size. This updates the physical dimensions of the plate. |
| sOneSide | dropdown | No | If "Yes", applies the anchor to only one side of the connection. |
| sSide | dropdown | Front | Determines which side (Front/Back) the anchor is applied to when "One Side" is active. |
| sSwitch | dropdown | No | Flips the orientation of the anchor plates (Left/Right switch). |
| sFour | dropdown | No | Enables a "Four-sided" configuration, adding anchors to all sides of the connection. |
| dOffsetF | number | 0.0 mm | Vertical offset for the Front anchor plate relative to the beam intersection. |
| dOffsetB | number | 0.0 mm | Vertical offset for the Back anchor plate relative to the beam intersection. |
| sArt1 | text | | Manufacturer Article Number for the anchor plate. |
| sMat1 | text | Stahl, feuerverzinkt | Material specification for the anchor plate (e.g., galvanized steel). |
| nNail | integer | 0 | Total quantity of nails. Set to > 0 to include hardware in the BOM. |
| sMod2 | text | Kammnagel | Model or type of nail/fastener used. |
| sArt2 | text | | Manufacturer Article Number for the nails. |
| sMat2 | text | Stahl, verzinkt | Material specification for the nails. |
| dDia | number | 4.0 mm | Diameter of the nails. |
| dLen2 | number | 40.0 mm | Length of the nails. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Properties | Opens the AutoCAD Properties Palette to edit the parameters listed above. |
| Update/Refresh | Recalculates the script geometry based on current beam positions. |

## Settings Files
- **Filename**: N/A (Internal Script)
- **Location**: N/A
- **Purpose**: This script relies on internal geometry definitions and standard hsbCAD material catalogs rather than external XML settings files.

## Tips
- **Nail Visibility**: Nails will not appear in the BOM or manufacturing data unless the `nNail` property is set to a value greater than 0.
- **Adjusting Position**: If the plate does not sit exactly where you want it relative to the beam intersection, use the `dOffsetF` and `dOffsetB` properties to slide it vertically along the beam.
- **Orientation**: Use the `sSwitch` property if the anchor is installed on the wrong side of the beam (mirroring the geometry).

## FAQ
- **Q: Why are no nails showing up in my list?**
  **A:** Check the `nNail` property in the Properties Palette. It defaults to 0. Increment this number to the required quantity of fasteners.
  
- **Q: Can I use this on non-standard beams?**
  **A:** The script requires two `GenBeam` entities. As long as the beams exist in the model space, the script will attempt to calculate the intersection, though physical fit depends on the specific geometry.

- **Q: How do I create a double-sided connection?**
  **A:** Ensure `sOneSide` is set to "No" and `sFour` is set to "No". This generates the standard configuration (usually one plate on each side).

- **Q: The text label is in the wrong place. How do I move it?**
  **A:** Select the script instance in the model. You should see a grip point (usually a small cross or square) associated with the label. Click and drag this grip to move the text and leader line.