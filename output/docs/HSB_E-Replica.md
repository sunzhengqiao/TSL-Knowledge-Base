# HSB_E-Replica.mcr

## Overview
This script maintains a synchronized "Replica" of a master element (Main Element). It handles the geometric copying and mirroring logic, ensuring that changes made to the Main Element are automatically propagated to this element, while displaying the connection status visually in the 3D model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on Elements within the 3D model. |
| Paper Space | No | Not intended for 2D layouts or drawings. |
| Shop Drawing | No | Does not generate manufacturing views. |

## Prerequisites
- **Required Entities:** 
  - A "Main Element" with the `HSB_E-Replicator` script applied.
  - A target "Replica Element" to which this script is applied.
- **Minimum beam count:** 0 (Dependent on the content of the Main Element).
- **Required settings:** 
  - The script relies on Map data (`Hsb_production` / `Hsb_replicator`) created by the Main Element.

## Usage Steps

### Step 1: Automatic Application
**Command:** N/A
**Action:** This script is typically applied automatically when you use the `HSB_E-Replicator` tool on a Main Element to generate copies. 
*Note: Attempting to insert this script manually via the command line will display a warning that it cannot be inserted manually.*

### Step 2: Verify Status
**Action:** Select the Replica element in the model. You should see a visual label (text) on the element envelope indicating the number of the Main Element it is linked to.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension style | dropdown | | Selects the visual style (arrows, text font) for the labels drawn in the model to indicate the replication link. |
| Text height | number | 100 | Sets the height (in mm) of the text label displaying the Main Element number and mirror status. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate All | Forces the Main Element to refresh and update all connected Replica elements. |
| Delete Construction | Placeholder option for construction cleanup. |
| Make element unique and delete tsl | Breaks the link to the Main Element. The script will erase itself, and the element will become a standalone, unique element that no longer updates automatically. |
| Select new main element | Removes the current script instance, allowing you to link this element to a different Main Element. |
| Mirror | Toggles the mirror status. If active, the replica geometry is mirrored (e.g., converting a left wall to a right wall) relative to the Main Element. |
| Recalc | Triggers a refresh of the replication logic specifically for this element. |

## Settings Files
This script does not use external XML settings files. It stores configuration data directly in the Element's Map properties.

## Tips
- **Breaking the Link:** If you need to modify a specific wall without affecting the others, right-click the Replica element and select **Make element unique and delete tsl**.
- **Mirroring:** Use the **Mirror** context menu option to quickly create opposite hand walls (e.g., Left vs. Right Gable) that stay synchronized with the master design.
- **Visibility:** If the text labels are too small to read in the 3D model, increase the **Text height** property in the Properties Palette.

## FAQ
- **Q: Why does the script disappear when I insert it?**
  - A: This script is designed for automated management only. It must be applied via the `HSB_E-Replicator` script running on the Main Element.
- **Q: How do I stop the replica from updating when I change the master?**
  - A: Select the replica, right-click, and choose **Make element unique and delete tsl**. This converts it into a standard, independent element.