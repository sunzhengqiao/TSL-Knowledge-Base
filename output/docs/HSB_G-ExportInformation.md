# HSB_G-ExportInformation.mcr

## Overview
Creates a visual delivery information block in the model to manage, verify, and export batches of timber elements (packages/truck loads) to production formats like Prenest or BTL.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for placing the delivery information block. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: None required for insertion, but timber elements must exist in the model to populate the delivery list.
- **Minimum Beam Count**: 0.
- **Required Settings**:
  - Model Map configuration (must have defined Export Groups and Export Shortcuts).
  - Project Map 'Delivery[]' structure enabled to store delivery data.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `HSB_G-ExportInformation.mcr` from the catalog and press Enter.

### Step 2: Specify Insertion Point
```
Command Line: Specify insert
Action: Click anywhere in the Model Space to place the delivery information block.
```

### Step 3: Configure Delivery
After insertion, the block displays default text.
1. Select the inserted block.
2. Open the **Properties** palette (Ctrl+1).
3. Enter a unique **Delivery Name** (e.g., "Truck-01").
4. Select the appropriate **Export Group** or **Shortcut** from the Model Map.
5. (Optional) Modify the **Description** to provide details about the shipment.

### Step 4: Manage Elements
- **To Check Elements**: Use the context menu option "Show current delivery" to isolate the parts belonging to this batch.
- **To Remove Elements**: Use the context menu option "Remove Element From Current Group", select the timber elements in the model or drawing, and confirm to remove them from the list.

### Step 5: Export Data
1. Select the block.
2. In the Properties palette, find the **Export** parameter.
3. Change the value from "No" to **"Yes"**.
4. The script will automatically trigger the `HSB_G-ReplicatorExport` script to generate production files for the current list.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| pGroup | String | [Empty] | Selects a predefined collection of elements (from the ModelMap) to include in the export. |
| pShortcut | String | [Empty] | Selects a specific export configuration preset (e.g., specific machine settings). |
| deliveryName | String | New delivery | The unique ID or name for this delivery batch (e.g., "Stage-1", "Truck-02"). |
| deliveryDescription | String | New description | Additional descriptive text for the delivery notes. |
| onlySelection | Boolean | No | If "No", includes all replications of elements. If "Yes", only includes strictly selected unique elements. |
| export | Boolean | No | Toggle to "Yes" to trigger the production data export immediately. |
| dimStyle | String | Standard | The drafting style (font, arrows) applied to the text in the block. |
| dTextHeight | Number | 100 | The physical height of the text in the block (in mm). Adjust based on drawing scale. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Show current delivery | Hides all other elements in the model and displays only the parts assigned to the current delivery name. |
| Remove Element From Current Group | Prompts you to select elements in the drawing to remove them from the current delivery list. |

## Settings Files
- **Configuration**: Model Map
- **Location**: hsbCAD Project Settings
- **Purpose**: Defines the available Export Groups and Shortcuts used to filter elements and determine export formats.

## Tips
- **Visibility Check**: Use the "Show current delivery" right-click option to verify visually that the correct elements are assigned to the package before exporting.
- **Text Size**: If the text in the information block is too small to read, increase the `dTextHeight` property to 200 or 300.
- **Export Status**: After setting `Export` to "Yes", it will automatically reset to "No" once the process is complete. Check the visual block for the updated "Exported" date.

## FAQ
- Q: Why is my delivery block empty (0 items)?
- A: Ensure the `deliveryName` matches the name used in your Project Map data, or verify that elements exist in the selected `pGroup`.
- Q: How do I undo an export?
- A: You cannot undo the file generation directly, but you can modify the `deliveryName` or adjust the element list and export again.
- Q: What happens if I change the Export Group?
- A: The list of elements in the visual report will update to reflect the elements belonging to the newly selected group.