# hsbCLT-XRef-Updater

## Overview
This script manages and synchronizes the data links between CLT (Cross Laminated Timber) panel hierarchies (Master/Child panels) and their source drawing files. It provides a visual report of the panel structure and allows you to update or clear the metadata that associates specific panels with the current drawing or Xrefs.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be inserted in Model Space where CLT panels are located. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | Not intended for shop drawing generation. |

## Prerequisites
- **Required Entities**: The drawing must contain existing `MasterPanel`, `ChildPanel`, and `Sip` entities.
- **Minimum Beam Count**: Not applicable (requires specific CLT entities, not beams).
- **Required Settings**: None required.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-XRef-Updater.mcr`

### Step 2: Place Visual Report
```
Command Line: Specify insertion point:
Action: Click in the Model Space to place the script instance.
```
*Note: Upon insertion, the script will generate a visual text list at the clicked location displaying the MasterPanels and their associated Sips found in the model.*

### Step 3: Execute Update
After insertion, the script acts as a tool to modify data links. You must interact with it via the Right-Click menu to perform updates.
```
Action: Select the script instance (the text/lines generated).
Action: Right-click and select the desired option from the context menu (see Right-Click Menu Options below).
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose any editable parameters in the Properties Palette. All configuration is handled via the context menu. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Update by nestings** | **Links panels to the current drawing.**<br>Prompts you to select MasterPanels or ChildPanels. If you press Enter without selecting, it processes all panels in the model. It then updates the internal data of Sip entities nested inside the selected panels to point to the current drawing file. It also cleans up data from "orphaned" panels that are no longer nested. |
| **Update panels** | **Removes links from Sip entities.**<br>Prompts you to select Sip entities. If you press Enter, it processes all Sips. It removes the internal reference to the current drawing from any Sip entities that are not currently nested within a MasterPanel in the model. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A.
- **Purpose**: N/A.

## Tips
- **Visual Verification**: Use the text list generated at the insertion point to verify which MasterPanels and Sips are currently recognized by the script before running an update.
- **Select All**: For both context menu options, simply pressing **Enter** at the selection prompt will apply the action to **all** relevant entities in the Model Space.
- **Orphan Cleanup**: The "Update by nestings" option is particularly useful after deleting panels, as it automatically removes the source drawing link from panels that no longer exist in the hierarchy.
- **Double-Click**: Double-clicking the script instance triggers the same action as selecting "Update by nestings" from the right-click menu.

## FAQ
- **Q: What does the text report show?**
  - A: It displays a sorted list of MasterPanels found in the model and their relationship to ChildPanels/Sips. This is purely for visual verification.
- **Q: Do I need to update every time I open a drawing?**
  - A: Only if the panel hierarchy has changed, or if you have imported new Xrefs and need to establish the link between the panels and the new source drawing.
- **Q: What is the difference between the two update options?**
  - A: "Update by nestings" writes data to link panels to the current file (typically used when finalizing a layout). "Update panels" removes data (typically used for cleanup or resetting references).