# hsbSimpsonFB.mcr

## Overview
Generates a 3D model and BOM entries for a Simpson Strong-Tie style Face Mount (FB) bracket, typically used to anchor wall studs or columns to floor/foundation to resist uplift and lateral loads.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Generates 3D metal bodies and hardware. |
| Paper Space | No | Not applicable for detailing views. |
| Shop Drawing | No | Not configured for shop drawings. |

## Prerequisites
- **Required Entities**: A single `GenBeam` (e.g., Wall Stud, Beam, or Column).
- **Minimum Beam Count**: 1.
- **Required Settings**: `hsbSimpsonFB.xml` (Located in Company or Install TSL\Settings folder).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbSimpsonFB.mcr` from the list.

### Step 2: Select Host Element
```
Command Line: Select element:
Action: Click on the timber beam, stud, or column where you want to attach the bracket.
```

### Step 3: Define Insertion Point
```
Command Line: Specify insertion point:
Action: Click on the beam to define the origin location (usually the bottom corner or face).
```

### Step 4: Adjust Parameters
1. Select the inserted TSL instance.
2. Open the **Properties Palette** (Ctrl+1).
3. Change the **Product Code**, **Length Overall**, or other dimensions to fit your specific connection requirements.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Group Assignment | dropdown | \|Default\| | Defines the layer for the instance. Select "\|No group assignment\|" to assign manually, or leave as "\|Default\|" to follow the host entity. |
| Product Code | dropdown | FB | Selects the specific bracket model (FB, FB20A, FB20S). This affects width, thickness, and material (Galvanized vs Stainless). |
| Length Overall | number | 80 mm | The total height of the bracket (Vertical height + Bend length). |
| Length Bend | number | 60 mm | The length of the horizontal foot (flange) that sits on the floor/foundation. |
| Offset Below | number | 0 mm | Moves the bracket vertically downwards relative to the insertion point. Useful for fine-tuning alignment with the foundation. |
| Text Height | number | 0 mm | Controls the size of the Product Code label in the 3D model. Set to 0 to hide the text. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the geometry based on changes to the host beam or properties. |
| Erase | Removes the TSL instance and associated 3D bodies. |

## Settings Files
- **Filename**: `hsbSimpsonFB.xml`
- **Location**: `_kPathHsbCompany\TSL\Settings` or `_kPathHsbInstall\Content\General\TSL\Settings`
- **Purpose**: Defines specific dimensions (width, thickness) and material mappings for the different Product Codes (e.g., differences between FB and FB20S). If missing, the script uses internal default values.

## Tips
- **Vertical Geometry**: Ensure the **Length Overall** is greater than the **Length Bend**. If they are equal, the vertical part of the bracket will not generate.
- **Visibility**: Use the **Text Height** property to toggle the product label on or off. Set it to `0` for a clean 3D model view, or increase it (e.g., `10` mm) for clear identification in presentations.
- **Material Selection**: Use the **Product Code** dropdown to switch materials. For example, selecting `FB20S` typically specifies Stainless Steel, while `FB` and `FB20A` are usually Galvanized.

## FAQ
- **Q: Why is my bracket just a flat plate without the vertical part?**
  A: Check your properties. The **Length Overall** must be larger than the **Length Bend**. If `Length Overall` (e.g., 60) equals `Length Bend` (e.g., 60), there is no height left for the vertical face.
- **Q: Can I move the bracket after inserting it?**
  A: Yes. You can use the **Offset Below** property in the palette to move it vertically, or use standard AutoCAD Move commands on the TSL insertion point.
- **Q: What happens if the XML file is missing?**
  A: The script will fall back to internal hardcoded dimensions, but you may lose specific customization or updates intended by your company administrator. Ensure `hsbSimpsonFB.xml` is present in the correct Settings folder.