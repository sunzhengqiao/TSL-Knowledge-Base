# GE_HDWR_WALL_ANCHOR.mcr

## Overview
This script inserts and configures hold-down anchors (rod tie-downs) for timber frame walls. It automatically handles drilling holes in wall plates, models washers and nuts, and generates accurate BOM data based on the selected hardware type and embedment requirements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script creates 3D geometry (rods, washers) and modifies beam/element data. |
| Paper Space | No | This script does not generate 2D shop drawings or viewports. |
| Shop Drawing | No | Processing happens in the 3D model; output is visible in model space and BOM lists. |

## Prerequisites
- **Required Entities**: A wall **Element** or a specific **GenBeam** (plate) to act as the host.
- **Minimum Beam Count**: 1 (The host plate).
- **Required Settings**: None required (uses internal property settings).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `GE_HDWR_WALL_ANCHOR.mcr` from the script list.

### Step 2: Select Host Entity
Command Line: `Select Element/Beam:`
Action: Click on the wall Element or the specific GenBeam (bottom plate) where the anchor will be placed.

### Step 3: Define Location
Command Line: `Specify insertion point:`
Action: Click in the model to place the anchor. 
*Note: If "Free Placement" is set to "No" in properties, the script may attempt to snap to a valid stud bay automatically.*

### Step 4: Configure Properties
Action: With the anchor selected, open the **Properties Palette** (Ctrl+1) to adjust hardware type, washer sizes, and embedment settings. The 3D model and drill holes will update automatically.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Hardware Type | Dropdown | 1/2" All Thread | Selects the specific hardware catalog item (e.g., All Thread, Wedge Anchor, SSTB, PAB). This determines diameter, drill size, and embedment logic. |
| Embedment | Dropdown | Concrete | Sets the substrate material. "Concrete" typically requires shorter embedment than "Masonry". |
| Drill Plates | Dropdown | Yes | If "Yes", the script creates cylindrical drill holes in the assigned plates. If "No", it only generates the 3D hardware representation. |
| Coupler | Dropdown | In floor | Determines if the rod splice/coupler is located in the floor system or the upper wall section. |
| Coupler at Base | Dropdown | Yes | Forces a coupler at the very bottom of the anchor run. This creates a separate BOM line item for the lower rod segment. |
| Force Nuts | Dropdown | Yes | Ensures nuts and washers are placed on the bottom plate, even if logic might otherwise omit them. |
| Washer Top | Dropdown | Default | Selects the plate washer type for the top (tension) side. Options include specific dimensions or "None". |
| Washer Bot | Dropdown | Default | Selects the plate washer type for the bottom (compression) side. |
| Can Be Moved | Dropdown | Yes | Allows the user to drag the anchor freely. If "No", placement is constrained by stud spacing logic. |
| Distance from Stud | Number | 2" | The minimum edge distance required between the anchor center and the nearest stud. |
| Distance from Rod | Number | 3" | The minimum spacing required between this anchor and adjacent anchors. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Forces the script to re-evaluate geometry, drill holes, and BOM data based on current property values. Useful if manual edits or underlying wall geometry changed. |

## Settings Files
- **Filename**: None specified
- **Location**: N/A
- **Purpose**: This script relies on internal hardcoded arrays and OPM properties; no external XML settings file is required.

## Tips
- **BOM Accuracy**: The script automatically calculates rod lengths. If you change the **Embedment** from Concrete to Masonry, the rod length will increase significantly to meet code requirements.
- **Visualization**: Different hardware types may display differently (e.g., some anchors show as squares, others as circles) to represent the actual hardware profile.
- **Drilling**: If you see the anchor rod but no hole in your plate, check the **Drill Plates** property. If it is set to "No", the hole will not be machined into the timber.
- **Couplers**: Use the **Coupler at Base** option when you need a break in the rod right at the foundation level, often used for ease of installation or specific epoxy requirements.

## FAQ
- **Q: Why is my rod length longer than expected?**
  **A:** Check the **Embedment** property. If it is set to "Masonry", the embedment depth is calculated deeper than standard concrete requirements.
  
- **Q: The hole in the plate disappeared after I changed properties.**
  **A:** You likely toggled **Drill Plates** to "No". Switch it back to "Yes" and Recalculate the script.

- **Q: Can I move the anchor after placing it?**
  **A:** Yes, provided **Can Be Moved** is set to "Yes". You can use grip points to drag it along the wall. If set to "No", you must change the property to "Yes" first to unlock the position.