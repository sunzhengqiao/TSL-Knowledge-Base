# hsbCLT-QC.mcr

## Overview
Generates CNC milling operations to cut quality control (QC) test samples from CLT master panels. It is used during production planning to extract material samples for glue bond verification or density testing, optionally holding them in place with bridges to prevent them from falling into the machine bed.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script targets MasterPanel entities in the 3D model. |
| Paper Space | No | Not designed for 2D layouts. |
| Shop Drawing | No | Not intended for generating views or dimensions. |

## Prerequisites
- **Required Entities**: `MasterPanel` (CLT Panel)
- **Minimum Beam Count**: 1 (One MasterPanel)
- **Required Settings Files**: `hsbCLT-QC.xml` (Recommended for automatic tool assignment)

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-QC.mcr` from the list.

### Step 2: Select Masterpanel
```
Command Line: Select masterpanels
Action: Click on the CLT MasterPanel entity in your drawing where you want to generate the test sample(s).
```

### Step 3: Configure Properties
After selection, the script attaches to the panel. Open the **Properties Palette** (Ctrl+1) to adjust the size, quantity, and tooling settings for the test pieces.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Quantity** | number | 2 | Specifies the number of test samples to generate. If greater than 1, the script automatically distributes them across the panel. |
| **Length** | number | 100 | Defines the size of the test piece along the panel's grain direction (in mm). |
| **Width** | number | 100 | Defines the size of the test piece perpendicular to the grain direction (in mm). |
| **Offset** | number | 0 | Adds an additional clearance distance from the masterpanel edge. This only applies to outer edges and is ignored within openings. |
| **Bridge Thickness** | number | 10 | The width of the uncut material tabs holding the piece to the panel. Prevents the piece from falling loose during machining. |
| **Bridge Mode** | dropdown | None | Strategy for retaining the test piece: **None** (cut free), **Simple** (one bridge per side), or **Duplex** (two bridges per side for nesting). |
| **Tool Diameter** | number | 10 | The diameter of the milling cutter used for the operation (in mm). |
| **Tool Index** | number | -1 | The CNC tool number. Set to **-1** for automatic assignment based on the settings file and panel thickness. |
| **Debug** | number | 0 | Set to **1** to visualize the calculation steps and geometry without generating final tooling. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Stretch Masterpanel** | Automatically resizes the parent MasterPanel to fit the bounding box of all generated QC test pieces. Also triggered by double-clicking the script. |
| **Import Settings** | Loads tool configuration mappings (Thickness, Diameter, Index) from the `hsbCLT-QC.xml` file. |
| **Export Settings** | Saves the current tool configuration mappings to the `hsbCLT-QC.xml` file. |

## Settings Files
- **Filename**: `hsbCLT-QC.xml`
- **Location**: 
  - `_kPathHsbCompany\TSL\Settings`
  - `_kPathHsbInstall\Content\General\TSL\Settings`
- **Purpose**: Stores tool configurations mapping Thickness and Diameter to specific Tool Indices. This allows the script to automatically select the correct CNC tool when `Tool Index` is set to -1.

## Tips
- **Auto-Distribution**: If you need multiple samples (e.g., for statistical testing), set the **Quantity** property to the desired number (e.g., 4 or 6). The script will automatically calculate the best positions to nest them on the panel.
- **Prevent Falling Parts**: For small or light test pieces, always use **Bridge Mode: Simple** or **Duplex**. If the piece is cut completely loose, it may shift or get damaged by the CNC spindle.
- **Nesting Panels**: If you plan to nest two master panels face-to-face on the CNC machine, use **Bridge Mode: Duplex**. The double bridges ensure the panels do not collide when stacked.
- **Verify Size**: Change the **Debug** property to `1` to see the exact contour and placement before committing to production data.

## FAQ
- **Q: Why did my test piece disappear?**
  - A: Check the **Offset** property. If the offset is too large or the placement is near an opening, the geometry might be invalid or moved outside the panel bounds.
  
- **Q: How do I change which CNC tool is used?**
  - A: You can manually enter a specific **Tool Index** in the properties, or ensure `hsbCLT-QC.xml` contains the correct mapping for your panel thickness and set **Tool Index** to `-1`.

- **Q: Can I use this on openings inside the panel?**
  - A: The script calculates placement based on available space. The **Offset** property only applies to outer edges, not inner edges of cut-outs.

- **Q: What happens if I set "Quantity" to 1?**
  - A: The script generates a single test piece at the insertion point. If you set it higher than 1, the script distributes multiple instances and deletes the original one.