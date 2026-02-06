# hsbCLT-Chamfer.mcr

## Overview
This script applies 45-degree chamfers (bevels) to the edges of CLT or SIP panels. It supports outer contours, inner openings, and custom geometric paths, automatically generating the necessary 3D cuts and CNC milling data for both straight and curved edges.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary environment for selecting panels and generating 3D geometry. |
| Paper Space | No | The script operates on 3D entities and does not generate 2D shop drawings directly. |
| Shop Drawing | No | While it creates CNC data, it is not a drawing layout script. |

## Prerequisites
- **Required Entities**: At least one Sip (Panel) entity.
- **Minimum Beam Count**: 1.
- **Required Settings**: None strictly required; however, Catalog entries can be used to preset chamfer dimensions if the script is executed via a specific command key.

## Usage Steps

### Step 1: Launch Script
```
Command: TSLINSERT
Action: Select hsbCLT-Chamfer.mcr from the file list.
```

### Step 2: Configure Properties
```
Interface: Properties Dialog
Action: Adjust the settings for the chamfer (Mode, Alignment, Size) or select a Catalog entry. Press OK to confirm.
```

### Step 3: Select Panels
```
Command Line: Select panel(s)
Action: Click on one or more Sip (CLT/SIP) panels in the model. Press Enter to finish selection.
```
*(Note: If no panels are selected, the script will automatically close.)*

### Step 4: Define Chamfer Location
The next prompt depends on the **Mode** selected in Step 2:

*   **If Mode is "Contour" or "Contour & Openings"**: The script automatically processes the outer edges (and holes if selected). No further input is usually required unless specific openings need to be picked.
*   **If Mode is "Openings"**:
    ```
    Command Line: Pick point in opening
    Action: Click inside a specific window/door opening. Repeat for multiple openings, or press Enter to select all openings automatically.
    ```
*   **If Mode is "Polyline"**:
    ```
    Command Line: Select polyline(s)
    Action: Select existing 2D polyline entities in the drawing that define the chamfer path.
    ```
*   **If Mode is "Path"**:
    ```
    Command Line: Pick start point
    Action: Click a point on the edge of the panel to start the custom chamfer path.
    Command Line: Select next point
    Action: Click subsequent points to define the path. Press Enter to finish.
    ```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **sMode** | Dropdown | Contour | Determines where the chamfer is applied. Options: Contour (outer edge), Openings (inner holes), Contour & Openings, Feed Direction (CNC path), Polyline (from existing entity), or Path (user drawn). |
| **sAlignment** | Dropdown | Reference Side | Sets the vertical origin of the bevel. Options include Top, Bottom, or Reference Side, determining which face the cut is measured from. |
| **dChamfer** | Number | 4.0 | The width of the chamfer along the face (in mm). Since the cut is 45 degrees, this is also the depth of the cut. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **TSL_ShowChamferPolyline** | Displays the preview polylines used to generate the chamfer geometry. Useful for verifying the path. |
| **TSL_HideChamferPolyline** | Hides the preview polylines to clean up the model view. |
| **Erase Instance** | Removes the script instance. Note: The generated cuts (BeamCuts) on the panels will remain as part of the panel geometry. |
| **Update** | Recalculates the chamfer based on the current properties and panel geometry. |

## Settings Files
- **Filename**: N/A (Uses Catalog Entries)
- **Location**: hsbCAD Catalog
- **Purpose**: If a specific command key is used during insertion, the script loads predefined dimensions (chamfer size, alignment) from a catalog entry, allowing for standardized chamfers without manual parameter entry.

## Tips
- **Corner Cleanup**: The script automatically detects inner corners and performs a boolean subtraction (`SolidSubtract`) to ensure sharp corners where linear chamfers meet.
- **Curved Edges**: For panels with curved edges, the script generates `PropellerSurface` tools. This ensures the CNC machine creates a smooth lofted surface rather than a straight approximation.
- **Visual Verification**: Use the "Show Chamfer Polyline" context menu option to see exactly where the script intends to cut before manufacturing.
- **Full Panel Break**: To bevel all edges of a panel, set the Mode to "Contour & Openings" and ensure the Chamfer size does not exceed half the panel thickness.

## FAQ
- **Q: The script disappeared after I ran it. Did it fail?**
  **A:** If no panels were selected or the selection was cancelled, the script automatically erases itself to prevent empty instances. Select a valid panel and try again.
- **Q: Can I use this to bevel both the top and bottom edges separately?**
  **A:** Yes. You can insert the script twice on the same panel: once with Alignment set to "Top" and once set to "Bottom".
- **Q: What happens if my chamfer size is too big?**
  **A:** If `dChamfer` is larger than half the panel thickness (relative to the alignment), the cut may penetrate completely through the material or intersect with other cuts. Always verify the size against the panel thickness.