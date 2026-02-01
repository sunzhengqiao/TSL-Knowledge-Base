# Alpine-ReactionDisplayProperties.mcr

## Overview
This script acts as a global controller for structural reaction annotations. It scans the entire model to update the display settings of all "Alpine-BearingReaction" instances, allowing you to hide minor loads and toggle infill labels simultaneously.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be placed in the Model Space to function correctly. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not intended for manufacturing drawings. |

## Prerequisites
- **Required Entities**: The model must contain instances of the `Alpine-BearingReaction` script.
- **Minimum Beam Count**: None required.
- **Required Settings Files**: None.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Navigate to the script library and select `Alpine-ReactionDisplayProperties.mcr`.
3.  Click a location in the Model Space to insert the script instance.
    *   *Note: Upon insertion, the script will immediately scan the model and apply default settings to all compatible reaction instances.*

### Step 2: Configure Display Settings
1.  Select the script instance you just inserted.
2.  Open the **Properties Palette** (press `Ctrl + 1`).
3.  Locate the **Script Instance** section (usually near the bottom or top depending on your CAD version).
4.  Modify the parameters as needed (see *Properties Panel Parameters* below).
5.  **Trigger Update**: To apply the new settings to existing reaction labels in the model, click a grip point of the script instance, move it slightly, and click again to force a recalculation.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Display Reactions above... (kN) | Number | 0.0 | Sets the visibility threshold. Any reaction load lower than this value (in kN) will be hidden. Useful for cleaning up small loads. |
| Reaction for Infill | Dropdown | No | Determines if reaction labels appear on elements classified as "Infill". Select "Yes" to show them or "No" to hide them. |

## Right-Click Menu Options
This script does not add specific custom items to the right-click context menu. Standard AutoCAD/TSL options apply.

## Settings Files
-   None used.

## Tips
-   **Cleaning Up Drawings**: Set the "Display Reactions above..." value to `1.0` or `5.0` to automatically hide insignificant loads and reduce visual clutter in your structural plans.
-   **Infill Walls**: If you do not need to see load calculations for non-structural infill walls, keep "Reaction for Infill" set to "No".
-   **Placement**: You can place this script instance in an empty corner of the model or on a non-plotting layer. It serves as a settings controller rather than a physical building component.

## FAQ

**Q: I changed the properties in the palette, but the reaction labels in the model haven't updated.**
**A:** The script needs to recalculate to push changes to the other instances. Select the `Alpine-ReactionDisplayProperties` instance, click a grip (blue square), move your mouse slightly, and click to place it again. This forces the script to run and update the model.

**Q: Does this script delete reaction data?**
**A:** No. It only changes the *display* settings (visibility). The calculation data remains intact in the original "Alpine-BearingReaction" instances.

**Q: Can I have multiple instances of this script with different settings?**
**A:** While you can insert multiple instances, they will all scan the same model entities. The last instance to be recalculated will dictate the display settings for the entire model. It is recommended to keep only one instance.