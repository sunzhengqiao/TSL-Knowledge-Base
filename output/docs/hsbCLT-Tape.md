# hsbCLT-Tape.mcr

## Overview
This script automatically applies structural air-tightness tapes (adhesive strips) to the edges of Cross Laminated Timber (CLT) panels. It supports both automatic batch processing for multiple panels and interactive manual placement for specific edges, generating hardware components for production lists and visual symbols for drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary working environment. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Script is run in Model Space, but creates 2D symbols that appear in layouts. |

## Prerequisites
- **Required Entities**: Element (Sip) - CLT Panels.
- **Minimum Beam Count**: 1.
- **Required Settings Files**: `TapeCatalog.xml` (Must be located in `\\Company\TSL\Settings` or `\\Install\Content\General\TSL\Settings`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `hsbCLT-Tape.mcr` from the file list and click Open.

### Step 2: Select CLT Panels
```
Command Line: Select elements:
Action: Click on the CLT panels (Elements) you wish to process.
```
- **Manual Mode**: Select **exactly one** panel. The script will enter interactive mode (Jig) to let you pick specific edges.
- **Automatic Mode**: Select **multiple** panels. The script will immediately calculate and apply tapes to all valid edges of the selected panels.

### Step 3: Define Tape Location (Manual Mode Only)
If you selected a single panel, the following interaction occurs:
```
Command Line: Select edge / [Right-click to finish]:
Action: Move your cursor over the panel edges.
```
- The closest edge to your cursor will highlight dynamically.
- **Left Click**: Apply tape to the highlighted edge.
- Move to the next edge and repeat.
- **Right Click or Enter**: Finish the command and generate the hardware components.

*(Note: If Multiple Panels were selected, this step is skipped as the script processes all edges automatically.)*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| dTapeWidthFrontDefault | Number | 3.0 mm | The visual width of the tape representation in 3D model and 2D drawings (does not affect physical BOM quantity). |
| iTransparencyDefault | Integer | 75 | The opacity of the tape visualization (0 = Solid, 100 = Invisible). Allows underlying layers to be seen. |
| iColorDefault | Integer | 1 | The AutoCAD color index used to draw the tape (e.g., 1 = Red). Helps distinguish sealing areas. |
| TapeCatalog.xml | String | TapeCatalog | The filename of the XML catalog containing available tape products, widths, and Article Numbers. |
| dExtraWidth | Number | (Logic Dependent) | Additional length added to the tape calculation to ensure overlap or handling allowance at ends of the panel edge. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Explode Automatic TSL | Converts a single "Automatic Mode" instance (handling multiple edges) into multiple independent "Manual Mode" instances. This allows you to edit or remove tapes from individual edges later. |
| Recalculate | Re-runs the tape calculation based on current panel geometry or updated XML settings. |

## Settings Files
- **Filename**: `TapeCatalog.xml`
- **Location**: `\\Company\TSL\Settings` or `\\Install\Content\General\TSL\Settings`
- **Purpose**: Defines the database of available tape products. It maps physical widths to Article Numbers and stores display rules (Color/Transparency) for different tape configurations.

## Tips
- **Batch Processing**: Use Automatic Mode (select multiple panels) to quickly apply tapes to an entire floor or wall layout.
- **Visual Clarity**: If you cannot see panel details through the tape, increase the `iTransparencyDefault` value towards 100.
- **Editing**: If you need to remove a tape from just one edge on a large panel, use the "Explode Automatic TSL" right-click option to break the link, then delete the specific Manual TSL instance associated with that edge.
- **Catalog Matching**: The script attempts to find the best fit tape from the catalog based on edge width. If the edge is wider than any single product, it may combine multiple strips (e.g., one 150mm strip + one remainder strip).

## FAQ
- **Q: Why does the script show a "Version Mismatch" warning?**
  - A: The version of the `TapeCatalog.xml` in your Company folder differs from the installation default. Update your Company file to ensure you have the latest tape definitions.
- **Q: Can I move the panel after applying tapes?**
  - A: Yes, the tapes are associated with the panel and will move correctly when the panel is moved or modified.
- **Q: What happens if no tape in the catalog is wide enough for my edge?**
  - A: The script may fail to generate a hardware component for that edge. Edit the `TapeCatalog.xml` to add products with sufficient width.