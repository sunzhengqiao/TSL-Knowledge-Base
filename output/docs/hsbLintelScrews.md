# hsbLintelScrews.mcr

## Overview
This script inserts and configures screw fasteners to connect lintels (headers) to king studs or jamb studs. It generates the 3D screw visualization, adds the hardware to the BOM, and optionally creates CNC drill holes for manufacturing.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D beam entities. |
| Paper Space | No | Not supported for detailing views. |
| Shop Drawing | No | Not supported for 2D drawings. |

## Prerequisites
- **Required Entities**: Two GenBeam entities (a Header/Lintel and a Stud).
- **Minimum Beam Count**: 2
- **Required Settings**: `ScrewCatalog.xml` (Must be located in `TSL\Settings` in your Company or Install folder).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbLintelScrews.mcr` from the list and click OK.

### Step 2: Select Manufacturer
A dialog box will appear titled "Select Manufacturer".
- **Action**: Choose the desired screw manufacturer (e.g., Wurth, Simpson) from the list.
- **Action**: If prompted, select the specific **Family** and **Product** (size) from the subsequent drop-downs.

### Step 3: Select Lintel/Header
```
Command Line: |Select entities|
Action: Click on the horizontal Lintel or Header beam.
```

### Step 4: Select Stud
```
Command Line: |Select entities|
Action: Click on the vertical King Stud or Jamb Stud beam.
```

*(Note: The script will automatically attempt to identify which beam is the lintel and which is the stud based on orientation.)*

### Step 5: Configuration
After insertion, select the script instance and adjust properties in the **Properties Palette** (Ctrl+1) as needed.

---

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Manufacturer** | dropdown | "---" | Selects the screw brand. Populated from `ScrewCatalog.xml`. |
| **Family** | dropdown | "" | Selects the product series (e.g., ASSY 3.0). Updates based on Manufacturer. |
| **Product** | dropdown | "" | Selects the specific screw SKU/size (e.g., 8x160). Updates based on Family. |
| **Angle** | number | 0 | The inclination angle of the screw in degrees (0° is typically perpendicular to the surface). |
| **Quantity** | integer | 1 | The number of screws to place. Screws are distributed automatically based on the Offset. |
| **Offset** | number | 0 | The spacing distance between multiple screws (in mm). |
| **Drill** | dropdown | No | Set to "Yes" to generate CNC drill operations for the screw holes. |
| **Diameter** | number | 0 | The drill hole diameter. **0** = Use screw thread diameter. **>0** = Custom diameter size. |
| **Depth** | number | 0 | The length of the drill operation. **0** = Drill through Stud only. **-1** = Drill full screw length. **>0** = Extend drill by specific mm amount. |

---

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific custom context menu options. Use the Properties Palette to modify settings. |

---

## Settings Files
- **Filename**: `ScrewCatalog.xml`
- **Location**: `_kPathHsbCompany\TSL\Settings` or `_kPathHsbInstall\Content\General\TSL\Settings`
- **Purpose**: This XML file contains the database of available screw manufacturers, families, products, and their geometric dimensions.

---

## Tips
- **Drill Diameter**: Leave the **Diameter** set to `0` to automatically use the screw's correct thread diameter for the drill hole.
- **Drill Depth**: Set **Depth** to `-1` if you want the drill hole to match the exact length of the screw selected in the Product catalog.
- **Multiple Screws**: When increasing **Quantity**:
  - **Even Number**: Screws are distributed symmetrically to the left and right of the center point.
  - **Odd Number**: One screw is placed in the center, and the rest are distributed symmetrically.
- **Updating Catalog**: If the Manufacturer dropdown is empty, check that `ScrewCatalog.xml` exists in your Company settings folder.

---

## FAQ
- **Q: I placed the script, but I don't see any drill holes in my CNC data?**
  **A:** Check the Properties Palette. Ensure the **Drill** property is set to "Yes".

- **Q: How do I drill through both the stud and the lintel?**
  **A:** Set the **Depth** property to a value greater than 0 that ensures the drill passes through the combined thickness of both materials, or set it to -1 (Full Length) if the screw length is sufficient to penetrate both.

- **Q: The screw looks like it is floating or intersecting incorrectly.**
  **A:** Check the **Angle** property. If the beams are not perfectly orthogonal, you may need to adjust the angle slightly to ensure the screw penetrates correctly.