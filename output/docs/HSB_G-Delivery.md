# HSB_G-Delivery

## Overview
Generates and manages delivery lists (packing lists) for construction projects. It groups elements into specific batches, calculates quantities, and updates element data for production and transport scheduling.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script creates a graphical table in the model. |
| Paper Space | No | This script operates within the 3D model environment. |
| Shop Drawing | No | This is a global/project management script, not a detailing tool. |

## Prerequisites
- **Required Entities:**
  - **Groups:** Floor Groups or similar container groups flagged as deliverable.
  - **Elements:** Structural timber elements located within those groups.
- **Minimum Beam Count:** 0
- **Required Settings:**
  - `hsbTslDelivery.dll` (Located in `..\hsbCAD\Utilities\hsbDatabase`)

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-Delivery.mcr` from the list.

### Step 2: Define Location
```
Command Line: Select a point
Action: Click in the Model Space where you want the delivery schedule table to appear.
```

### Step 3: Define Delivery Details
```
Dialog: Dynamic Input
Action: Enter the 'Delivery Name' and 'Delivery Description' (e.g., "Floor 1 - Batch A").
```
*Once confirmed, the script automatically scans the model for Floor Groups and generates the table.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension style | Dropdown | (Current Style) | Selects the text style (font, size) used for the table content. |
| Color table | Number | -1 (ByLayer) | Sets the color of the table grid lines and borders. Use AutoCAD Color Index (e.g., 1-255). |
| Color content | Number | 5 (Blue) | Sets the color of the text inside the table. |
| Hide when amount is '0' | Dropdown | \|No\| | Controls visibility. Select "\|Yes\|" to hide rows where the quantity is zero (e.g., fully delivered items). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Create a new delivery | Opens a dialog to define a new delivery name and description, resetting the list. |
| Edit the current delivery | Allows you to modify the name or description of the existing delivery. |
| Recalculate element list | Updates the list to include new elements added to the floor groups since creation. |
| Remove current project delivery data | Cleans up the specific data associated with this delivery structure. |
| Remove current delivery | Deletes the script instance and resets element quantities to default (1). |

## Settings Files
- **Filename**: `hsbTslDelivery.dll`
- **Location**: `_kPathHsbInstall\Utilities\hsbDatabase`
- **Purpose**: Processes the delivery data structure and handles external database interactions.

## Tips
- **Location Matters:** Place the table in a clear area of Model Space, as it draws lines and text entities directly.
- **One Per Group:** If you try to insert a second delivery script on the same Floor Group, the new script will automatically delete itself to prevent conflicts.
- **Replicated Elements:** The script automatically skips "Replicated" elements (e.g., copies made with specific tools) so they aren't counted twice.
- **Quick Updates:** If you modify the model (add/remove beams), simply right-click the table and choose **Recalculate element list** to update the quantities instantly.
- **Visual Customization:** You can change the table colors or text size via the Properties Palette without deleting the script.

## FAQ

**Q: Why did the script disappear immediately after I inserted it?**
**A:** You likely already have an existing delivery script attached to the same Floor Group. To avoid duplicate records, the new instance self-destructs. Locate the existing table to edit it instead.

**Q: Why are some of my elements missing from the list?**
**A:** The script might be skipping them if they are identified as "Replicated" elements (copies), or if they are not inside a Group recognized as a deliverable container. Check your group structure in the model.

**Q: Can I change the text size of the table?**
**A:** Yes. Select the table, open the Properties palette, and change the **Dimension style** parameter to a text style with your desired height/font.

**Q: What happens if I set "Hide when amount is '0'" to Yes?**
**A:** Any item in the list that has a quantity of zero will not be drawn in the table, making the list shorter and easier to read.