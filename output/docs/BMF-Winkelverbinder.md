# BMF-Winkelverbinder.mcr

## Overview
This script inserts standardized metal angle connectors (L-brackets) from BMF and Simpson Strong-Tie catalogs into your 3D model. It generates the physical 3D geometry, assigns material and article codes for production, and manages the integration with the selected timber beam's Element Group for export lists.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script creates 3D Bodies and assigns them to structural beams. |
| Paper Space | No | Not supported for annotation or detailing in 2D layouts. |
| Shop Drawing | No | Geometry is generated in the model; shop drawings view the result. |

## Prerequisites
- **Required Entities**: One `GenBeam` (structural timber beam).
- **Minimum Beam Count**: 1
- **Required Settings**: None (Catalog data is embedded in the script).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `BMF-Winkelverbinder.mcr`

### Step 2: Select Structural Beam
```
Command Line: Select beam:
Action: Click on the timber beam where you want to attach the angle connector.
```

### Step 3: Configure Connector
A dialog box will appear.
```
Action: 
1. Select the 'Type' from the dropdown list (e.g., BMF-Zuganker, Simpson models).
2. Set the 'Orient H' (Height direction) and 'Orient L' (Length direction).
   Note: These must be different axes (e.g., Z and X).
3. (Optional) Toggle 'Switch' to Yes to swap leg dimensions.
4. Set Material and Article Number as required.
5. Click OK.
```

### Step 4: Set Insertion Point
```
Command Line: Insertion point:
Action: Click in the 3D model to place the origin of the connector.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | Dropdown | Index 7 (BMF-Zuganker) | Selects the specific commercial connector model. This determines dimensions and the default label. |
| OrientH | Dropdown | Y-Achse | Sets the direction vector for the vertical leg of the bracket (Height). Options: X, Y, Z, -X, -Y, -Z. |
| OrientL | Dropdown | X-Achse | Sets the direction vector for the horizontal leg of the bracket (Length). Options: X, Y, Z, -X, -Y, -Z. |
| Switch | Yes/No | No | If 'Yes', swaps the physical length of the two legs (swaps Height and Length dimensions). Useful for rotating asymmetric brackets. |
| Article | String | Empty | The manufacturer Article Number or Part Number for BOM export. |
| Material | String | Stahl, feuerverzinkt | Defines the material (e.g., Galvanized Steel) for BOM export. |
| Nail | Integer | 0 | Number of fasteners (nails/screws) associated with this connector for the BOM. |
| Layer | Dropdown | I-Layer | Assigns the part to a production layer (I, J, T, or Z) for filtering in exports and CNC. |
| Show description | Yes/No | Yes | Toggles the visibility of the text label (Type/Subtype) in the drawing. |
| X Flag / Y Flag | Number | 200 / 300 | Distance offsets for the text label from the insertion point. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Properties | Opens the AutoCAD Properties palette to edit Type, Orientation, Material, etc. |
| Erase | Removes the connector instance from the drawing. |

## Settings Files
None. The connector dimensions and catalog data are hardcoded within the script.

## Tips
- **Orientation Validation**: The script will delete itself if `OrientH` and `OrientL` are set to the same axis (e.g., both set to Z). Ensure they point in different directions.
- **Swapping Legs**: If you have a 90x60 bracket and need it to fit a 60x90 space, use the **Switch** property instead of calculating new dimensions.
- **Moving Text**: While `X Flag` and `Y Flag` are Read-Only after insertion, you can use the **Grip Point** (displayed near the text) to drag the label to a new location dynamically.
- **Layer Assignment**: Use the **Layer** property to control if the part is treated as Inner (I), Outer (J), Tenon (T), or Construction (Z) hardware in your production lists.

## FAQ
- **Q: Why did the connector disappear immediately after I placed it?**
- **A:** You likely set the Height Orientation (`OrientH`) and Length Orientation (`OrientL`) to the same axis (e.g., both Z). The script requires two different directions to generate the L-shape. Re-insert and choose different axes (e.g., Z and X).

- **Q: How do I rotate the bracket 90 degrees without changing the axis directions?**
- **A:** Set the **Switch** property to 'Yes'. This swaps the Height and Length dimensions, effectively rotating the bracket geometry.

- **Q: Can I update the material after insertion?**
- **A:** Yes. Select the connector, open the Properties palette, and change the **Material** string. This updates the BOM entry without altering the geometry.