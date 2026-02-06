# Simpson StrongTie Anchor.mcr

## Overview
Automates the insertion and configuration of Simpson StrongTie hold-down anchors (HD/HTT/AH series) on wall elements. It generates 3D geometry for visualization, BOM data for listing, and automatic CNC cutouts for sheathing/sheeting layers.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model on structural wall elements. |
| Paper Space | No | |
| Shop Drawing | No | This script creates physical geometry and tooling, not 2D annotations. |

## Prerequisites
- **Required Entities**: A `GenBeam` or `Wall Element` must exist in the model to attach the anchor to.
- **Minimum Beams**: 1
- **Required Settings Files**:
  - `Simpson StrongTie Anchor.xml` (Located in `hsbCompany/TSL/Settings` or `hsbInstall`).
  - *Note*: If the XML is missing, the script will load a default "HTT5" configuration.

## Usage Steps

### Step 1: Launch Script
Command: Type `TSLINSERT` in the command line or use the hsbCAD script browser, then select `Simpson StrongTie Anchor.mcr`.

### Step 2: Select Wall Element
```
Command Line: Select GenBeam/Element:
Action: Click on the desired wall beam or timber element in the 3D model where the anchor should be placed.
```

### Step 3: Configure Anchor (Optional)
Once inserted, the anchor will appear at the selected location. Select the anchor and open the **Properties Palette** (Ctrl+1) to select the specific Simpson StrongTie model (e.g., HTT5, HDA11) and adjust dimensions.

### Step 4: Adjust Tooling (Optional)
If the anchor passes through sheathing layers, configure the Tooling properties in the palette to generate automatic milling or sawing operations for the fabrication drawings.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Model (sModel) | Dropdown | HTT5 | Selects the specific Simpson StrongTie product family and dimensions (e.g., HTT5, HTT14). |
| Side (nSide) | Enum | Icon Side | Sets the side of the wall for the anchor (Left/Right). "Icon Side" calculates it based on insertion direction. |
| Flip Mounting Side | Boolean | No | Mirrors the anchor geometry relative to the insertion point (rotates 180 degrees). |
| Tooling Zones | String | Empty | Defines the CNC operation for sheeting layers (e.g., "Milling", "Saw"). |
| Tooling Widths | String | 0 | Defines the width of the cutout in the sheathing (mm). |
| Tooling Heights | String | 0 | Defines the height/length of the cutout in the sheathing (mm). |
| Tooling Indexes | Integer | 1 | Specifies the CNC tool number to use for the operation. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Mounting Side | Mirrors the anchor geometry instantly without changing properties. |
| Left Side / Right Side | Forces the anchor to the specific side of the wall beam. |
| Icon Side / Opposite Side | Resets the side to depend on the insertion geometry or flips to the opposite side. |
| Export Xml | Exports the current configuration map to the XML file (useful for backing up custom settings). |

## Settings Files
- **Filename**: `Simpson StrongTie Anchor.xml`
- **Location**: `hsbCompany/TSL/Settings` or `hsbInstall`
- **Purpose**: Defines the catalog of available Simpson StrongTie models, including their physical dimensions (Length A, Width B, Height C) and hole positions. If this file is missing, the script creates a default entry for the HTT5 model.

## Tips
- **Moving the Anchor**: Select the anchor in the model and drag the blue square **Grip Point** to slide it along the wall to the exact position required.
- **Tooling Setup**: Ensure your wall element has sheeting layers defined in Zones 1-5. If the "Tooling Zones" property is empty, no cutouts will be generated in the CNC data.
- **Side Logic**: If you change the "Side" property from Left to Right, the script automatically updates the tooling zones to match the new anchor position.

## FAQ
- **Q: I see an error "wrong definition of the xml file 1001".**
  **A:** The script cannot find or read the `Simpson StrongTie Anchor.xml` file. Ensure it exists in your company settings folder or allow the script to generate a default one.
- **Q: The anchor is visible in 3D, but there is no cutout in my sheathing.**
  **A:** Check the Properties Palette under "Tooling Zones". You must enter a value (e.g., "Saw" or "Milling") and define a Width/Height greater than 0 for the cutout to be generated.
- **Q: How do I switch from an HTT series to an HDA series?**
  **A:** Select the anchor, open the Properties Palette (Ctrl+1), and use the dropdown next to "Model" to select the desired family.