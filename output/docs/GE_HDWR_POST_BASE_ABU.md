# GE_HDWR_POST_BASE_ABU.mcr

## Overview
Inserts an ABU-style adjustable post base hardware assembly, automatically sizing it to fit selected post/stud dimensions or allowing manual selection for free placement.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D hardware creation and beam modification. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- A **GenBeam** (Post or Stud) must exist in the model.
- The beam must be vertical (X-axis parallel to World Z) for automatic detection.
- Script must be run in Model Space.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_HDWR_POST_BASE_ABU.mcr`

### Step 2: Select Post or Studs
```
Command Line: Select a Post or a set of Studs
Action: Click on a vertical post or select multiple studs.
```
*Note:* If a beam is selected, the script automatically detects its size and sets the hardware properties. If no beam is selected (or invalid selection), skip to Step 3.

### Step 3: Define Insertion Point (If no beam selected)
```
Command Line: Select an insertion point
Action: Click anywhere in Model Space to place the hardware freely.
```
*Note:* The Properties Dialog will appear to allow manual configuration of Type and dimensions.

### Step 4: Configure Properties
Action: Adjust settings in the Dynamic Dialog or Properties Palette (OPM) as needed.
- If a beam was selected, verify the auto-detected "Type".
- Select "Embedment" type (Concrete vs Masonry) to set rod length.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | dropdown | ABU44 | Selects the hardware model size (e.g., ABU44 for 4x4 posts). Auto-locked if a matching beam size is detected. |
| Post Face | dropdown | Default | Sets the orientation of the base plate relative to the post. "Flipped" rotates the plate 90 degrees. |
| Free Rotation | number | 0 | Fine-tunes the rotation angle of the assembly (0-360 degrees). Locked if a standard beam size is auto-detected. |
| Elevation | number | 0 | Vertical offset (Z-height) in inches relative to the insertion point or beam bottom. |
| Embedment | dropdown | Concrete | Selects anchoring condition. "Concrete" uses a 6" rod; "Masony" uses a 12" rod. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | No specific context menu items are defined for this script. |

## Settings Files
*   No external settings files are used by this script.

## Tips
- **Auto-Sizing:** To save time, select the post during insertion. The script will automatically find the smallest fitting hardware (e.g., ABU66 for a 6x6 post) and lock the properties.
- **Beam Cutting:** The script automatically applies a saw cut to the bottom of the selected post to accommodate the base plate.
- **Vertical Requirement:** Ensure your posts are drawn perfectly vertical (X-axis up). The script ignores non-vertical beams.
- **Adhesive:** Changing the Embedment to "Masonry" updates the Bill of Materials (BOM) to include more acrylic adhesive and a longer rod.

## FAQ
- **Q: Why can't I change the "Type" or "Free Rotation" fields?**
- **A:** The script automatically detected the beam size and locked these properties to ensure the hardware fits correctly. To unlock them, you may need to disconnect the script from the beam or modify the beam size.
- **Q: How do I raise the hardware off the floor?**
- **A:** Use the "Elevation" property in the Properties Palette to input the desired height in inches.
- **Q: My post isn't getting cut.**
- **A:** Ensure you selected the beam during insertion (Step 2). If you inserted the hardware freely using a point (Step 3), it does not associate with a beam and therefore cannot cut it.