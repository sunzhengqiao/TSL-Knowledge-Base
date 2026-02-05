# HSB_R-CenterRafter.mcr

## Overview
Automates the connection of a center rafter between two intersecting roof planes (e.g., butterfly or M-shaped roofs). It calculates and applies the necessary compound miter cuts to the center rafter and trims intersecting common rafters to fit flush against it.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required. Script operates on 3D beams and roof elements. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | Not applicable. |

## Prerequisites
- **Required Entities:** An existing `ElementRoof` containing the rafters.
- **Minimum Beams:** 2 (The center rafter to be adjusted and a reference rafter from an intersecting roof plane).
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Browse to and select `HSB_R-CenterRafter.mcr`.

### Step 2: Configure Properties (Optional)
**Dialog:** Properties Palette
**Action:** If not using a catalog entry, a properties dialog may appear.
- Review the **Beamcode to stretch to center rafter**.
- The default is usually `HRL*`. Ensure this matches the code of the perpendicular rafters you wish to cut.

### Step 3: Select Rafter to Adjust
```
Command Line: |Select the rafter to adjust.|
Action: Click on the beam that will act as the center rafter (the vertical/valley beam).
```

### Step 4: Select Reference Rafter
```
Command Line: |Select a rafter as a reference in a connecting roof plane.|
Action: Click on a rafter from the *other* roof slope that intersects the center rafter.
```

### Step 5: Execution
**Action:** The script will automatically calculate the intersection geometry, apply cuts to the center rafter, trim the perpendicular rafters, and split the roof sheathing. The script instance will then delete itself.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Center Rafter | Text/Label | N/A | Visual separator for the property group. |
| Beamcode to stretch to center rafter | Text | HRL* | The naming filter used to find perpendicular beams (e.g., common rafters) that need to be trimmed against the center rafter. Supports wildcards (e.g., RL*, PURLIN*). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add persistent context menu items as it deletes itself after running. |

## Settings Files
- **Filename:** None
- **Location:** N/A
- **Purpose:** This script relies on internal property definitions and does not require external settings files.

## Tips
- **Slope Requirement:** Ensure the "Reference rafter" is from a roof plane with a *different* slope than the center rafter. If they are parallel, the script will fail with a roof plane warning.
- **Fire-and-Forget:** The script instance erases itself immediately after execution. You cannot double-click the result to re-run the script. To make changes, you must undo or manually edit the resulting cuts.
- **Sheathing Zone:** The script specifically splits roof sheathing in "Zone -2". Ensure your roof sheets are correctly assigned if you expect the sheets to be split.

## FAQ
- **Q: I received the error "Select a rafter as reference from a connected roof plane."**
  **A:** This means the two rafters you selected are parallel (on the same slope). You must select a reference rafter from an opposing or intersecting roof slope (e.g., the other side of the valley).
- **Q: The script ran, but my common rafters weren't cut.**
  **A:** Check the `sBmCodeToCut` property. The rafters you want to cut must have a Beam Code that matches the filter (default is `HRL*`).
- **Q: Can I modify the connection later?**
  **A:** No. Because the script erases itself, the cuts become standard static geometry. Use native CAD editing tools to modify the beams afterward.