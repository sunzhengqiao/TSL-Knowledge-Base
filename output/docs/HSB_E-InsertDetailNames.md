# HSB_E-InsertDetailNames

## Overview
This script automates the placement of detail text labels (annotations) on Element edges, openings, and supporting structures. It reads specific construction variables from the selected Roofs or Floors and generates the appropriate text markers using a satellite script.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates entirely within the 3D model to generate annotation entities. |
| Paper Space | No | Not designed for 2D layout or drawing views. |
| Shop Drawing | No | This is a model detailing tool. |

## Prerequisites
- **Required Entities**: Element (Roof, Floor, or Wall).
- **Minimum Beam Count**: 0 (This script operates at the Element level).
- **Required Settings**:
  - The satellite script `HSB_E-DetailName` must be present in your TSL folder.
  - Catalog definitions must exist for both `HSB_E-InsertDetailNames` and `HSB_E-DetailName`.
  - Elements must have valid DSP (Design Specific Parameter) data assigned to their edges or openings.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-InsertDetailNames.mcr`

### Step 2: Configure Properties (Optional)
**Action**: 
- If you select a **Catalog Entry** from the right-click menu during insertion, the settings are pre-loaded.
- If you insert the script directly without a preset, the **Properties Palette** will open. Configure the following:
  - **Roof/Floor Category**: Set the `Variable index` (default 60) to match the DSP slot holding your detail names.
  - **Catalog Options**: Select the visual style catalogs for Edges, Openings, and Supporting details.
  - **Position Category**: Set an offset if text needs to be moved away from the element.

### Step 3: Select Elements
```
Command Line: Select one or more elements
Action: Click on the desired Roofs or Floors in the 3D model and press Enter.
```

### Step 4: Execution
**Action**: 
- The script will scan the selected elements.
- It erases any old detail labels.
- It calculates positions for edges, openings (dormers/skylights), and supports.
- It places new `HSB_E-DetailName` scripts at these locations.
- **Note**: The `HSB_E-InsertDetailNames` script will automatically erase itself after running, leaving only the new detail labels behind.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Variable index** (`nVarIndex`) | Integer | 60 | The index of the DSP variable slot that contains the detail name to be displayed. |
| **Catalog edge details** (`sCatEdgeDetails`) | Dropdown | - | Selects the visual style catalog for labels placed on element outlines. |
| **Catalog opening details** (`sCatOpeningDetails`) | Dropdown | - | Selects the visual style catalog for labels placed on roof openings (dormers, skylights). |
| **Catalog supporting details** (`sCatSupportingDetails`) | Dropdown | - | Selects the visual style catalog for labels placed on supports (knee walls, plates). |
| **Default detail name** (`defaultDetailName`) | String | "" | A fallback text used if the specific variable cannot be found or is empty. |
| **Offset detail** (`dOffsetDetail`) | Double | 0 | Distance (mm) to move the text label away from the edge or object along the normal vector. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Catalog Entries** | Allows you to insert the script with a specific configuration preset (e.g., "Standard Edge Labels"). This bypasses the manual property entry step. |

## Settings Files
- **Catalog Definitions**: `HSB_E-InsertDetailNames` and `HSB_E-DetailName`
- **Location**: Defined in your hsbCAD configuration path.
- **Purpose**: These store the visual presets (font, layer, size) for the generated labels and the configuration settings for the insertion script.

## Tips
- **Script Disappears**: It is normal for the `HSB_E-InsertDetailNames` script to vanish from the element list after insertion. It is a "one-time run" script that leaves the `HSB_E-DetailName` instances behind as the persistent labels.
- **Offsetting**: If your labels are clipping into the beams or geometry, increase the `Offset detail` value to push the text outward.
- **DSP Data**: Ensure your Element construction details actually have data in the variable index specified (default is 60). If the labels are blank, check the DSP string in the Element properties.

## FAQ
- **Q: The script disappeared after I ran it. Did it fail?**
  - **A:** No. The script is designed to run once, generate the labels, and then erase itself to keep the element clean. The labels you see are separate "satellite" scripts.
- **Q: Why are some labels blank?**
  - **A:** The script looks for a specific variable index (default 60). If that slot is empty in your Element's construction details, the label will be blank unless you have filled in the `Default detail name` property.
- **Q: Does this work on Walls?**
  - **A:** Currently, the logic for Wall elements is not implemented. It is designed for Roofs and Floors.