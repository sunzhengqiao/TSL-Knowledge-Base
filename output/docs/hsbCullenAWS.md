# hsbCullenAWS.mcr

## Overview
This script automates the insertion and distribution of Cullen Acoustic Wall Straps (metal brackets) to reduce impact noise transmission between timber elements. It is typically used to place acoustic straps between top plates or sole plates in separating walls or floating floors to break structural sound paths.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates only in 3D Model Space. |
| Paper Space | No | Not designed for 2D detailing or drawings. |
| Shop Drawing | No | Does not generate shop drawing views. |

## Prerequisites
- **Required Entities**: 
  - **Mode 0**: Two GenBeams (e.g., parallel top plates).
  - **Mode 1**: A single ElementWall containing horizontal beams (top/sole plates).
- **Minimum Beam Count**: 1 ElementWall or 2 GenBeams.
- **Required Settings**: A catalog or configuration defining the geometry for 'Cullen Acoustic Wall Strap' products (e.g., AWS 25, AWS 50).

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Browse and select `hsbCullenAWS.mcr`.
3.  Press **Enter** to insert the script into the drawing.

### Step 2: Select Insertion Mode
The script behavior depends on the `nInsertionMode` property (default usually set to 0 or 1). Check the Properties Palette (Ctrl+1) to verify or change this mode before selecting entities.

*   **If Mode 0 (Two GenBeams)**:
    1.  **Command Line**: `Select GenBeam 1`
    2.  **Action**: Click on the first timber beam (e.g., a top plate).
    3.  **Command Line**: `Select GenBeam 2`
    4.  **Action**: Click on the second parallel timber beam. The script will validate the gap (cavity) matches the product settings.

*   **If Mode 1 (Single ElementWall)**:
    1.  **Command Line**: `Select ElementWall`
    2.  **Action**: Click on the target wall element. The script will automatically detect horizontal beams (top plates) within the wall.

### Step 3: Configure Distribution
Once placed, select the script instance and open the **Properties Palette**.
1.  Select a **Product Code** (e.g., AWS 25) to define the strap size.
2.  Adjust **dOffsetBottom** (start) and **dOffsetTop** (end) to define the layout area.
3.  Set **dOffsetBetween**:
    -   Positive value (e.g., `600`): Fixed spacing in mm.
    -   Negative value (e.g., `-5`): Fixed quantity (5 straps) distributed evenly.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **sProductCode** | String/List | "" | Selects the specific Cullen model (e.g., AWS 25, AWS 50). This defines the geometry and the cavity width required. |
| **dCavity** | Number (mm) | "" | The gap width the strap is designed to span. Usually updated automatically when Product Code changes. |
| **nInsertionMode** | Integer | 0 | **0**: Select two GenBeams manually. **1**: Use ElementWall top plates. |
| **dOffsetBottom** | Number (mm) | 0 | Distance from the start of the selection to the center of the first strap. |
| **dOffsetTop** | Number (mm) | 0 | Distance from the end of the selection to the center of the last strap. |
| **dOffsetBetween** | Number (mm) | 0 | **Positive**: Fixed center-to-center distance. **Negative**: Number of straps to distribute evenly (e.g., -5 for 5 straps). |
| **sDistribution** | Enum | Fixed | **Fixed**: Uses exact spacing from `dOffsetBetween`. **Even**: Divides remaining space evenly between start/end offsets. |
| **nGroupAssignment** | Integer | 0 | **0**: Assign straps to the Element Group. **1**: Assign straps to a specific Layer independent of the wall. |
| **dDistanceX** | Number (mm) | 0 | Spacing in the longitudinal direction (along the wall) if using a grid pattern. |
| **dDistanceY** | Number (mm) | 0 | Spacing in the transverse direction (across the wall) if using a grid pattern. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Recalculate** | Refreshes the script based on current property values or wall geometry changes. |
| **Assign to Element Group** | Changes `nGroupAssignment` to 0, grouping the straps with the parent wall in the model tree. |
| **Assign to Layer** | Changes `nGroupAssignment` to 1, placing the straps on the default layer. |

## Settings Files
- **Filename**: Catalog configuration (often defined in company standards or specific `.catalog` files).
- **Location**: hsbCAD company or installation path.
- **Purpose**: Contains the geometric definitions and valid cavity widths for different "Cullen Acoustic Wall Strap" product codes.

## Tips
- **Fixed Quantity**: To place exactly 10 straps between two points, set `dOffsetBetween` to `-10` and ensure the `sDistribution` allows for the space.
- **Wall Mode**: Using Mode 1 (ElementWall) is faster for framing updates. If you modify the top plates in the wall, the straps will automatically update to the new profile upon recalculation.
- **Validation**: If the script reports "no distribution possible", reduce the `dOffsetBottom` and `dOffsetTop` values, as the available space between them is too small for the specified spacing or quantity.

## FAQ
- **Q: Why does the script say "No horizontal beams found"?**
  **A**: You are likely in Mode 1 (ElementWall), but the selected wall does not have any beams defined as "horizontal" (e.g., top plates). Ensure your wall has valid top plates.
  
- **Q: How do I change the size of the metal strap?**
  **A**: Change the `sProductCode` in the Properties Palette. The `dCavity` and physical 3D body will update to match the new product.

- **Q: My straps are not appearing.**
  **A**: Check the `dCavity` width. If the gap between your selected beams does not match the product's required cavity, the script may prevent generation. Also, ensure `dOffsetBottom` and `dOffsetTop` are not larger than the wall length.