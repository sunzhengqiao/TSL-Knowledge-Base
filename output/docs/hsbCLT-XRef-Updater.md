# hsbCLT-XRef-Updater

## Overview

The **hsbCLT-XRef-Updater** is a utility script for managing the relationship between CLT (Cross-Laminated Timber) MasterPanels and their nested ChildPanels, particularly when working with external references (XRefs). This tool tracks and updates the association metadata between master and child panels, ensuring that nesting information remains synchronized across your drawing and any referenced files.

When placed in your drawing, this script:
- Scans for all MasterPanels that contain nested ChildPanels
- Displays a visual list showing the parent-child relationships
- Provides commands to update or clear the nesting metadata stored on panel entities

This is especially useful when panels are located in external reference files, as the script can lock and modify XRef databases to keep association data current.

## Script Metadata

| Property | Value |
|----------|-------|
| **Type** | O (Object) |
| **Beams Required** | 0 |
| **Grip Points** | 0 |
| **Major Version** | 1 |
| **Minor Version** | 0 |
| **Keywords** | xRef, Nesting, CLT, MPN |
| **Author** | thorsten.huck@hsbcad.com |
| **Created** | August 8, 2019 |

## Environment

| Property | Value |
|----------|-------|
| **Environment** | Model Space |
| **Insertion Mode** | Click to place |
| **Required Entities** | MasterPanel, ChildPanel, Sip |

## Prerequisites

Before using this script, ensure:

1. **CLT Panels Exist**: Your drawing must contain MasterPanel entities with nested ChildPanels
2. **XRef Access**: If panels are in external references, ensure those files are not locked by other users
3. **Nesting Configured**: MasterPanels should already have ChildPanels nested within them using standard hsbCAD nesting workflows

## Usage

### Inserting the Script

1. Run the command to insert the script (or use the LISP command shown below)
2. Click a point in the drawing to place the association list display
3. The script displays a visual report showing all MasterPanels and their nested ChildPanels

**LISP Commands:**
```lisp
; Insert the XRef Updater
(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-XRef-Updater")) TSLCONTENT

; Trigger update by nestings
(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Update by nestings|") (_TM "|Select xRef-Updater|"))) TSLCONTENT

; Update panels directly
(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Update panels|") (_TM "|Select xRef-Updater|"))) TSLCONTENT
```

### Visual Display

After placement, the script shows:
- **Header**: "Masterpanel Association List"
- **Instruction**: "(Doubleclick or context menu to trigger update process)"
- **Panel List**: Each MasterPanel with its number, followed by nested panels showing position number, name, and XRef name

## Parameters

This script has no user-configurable OPM properties. All operations are triggered through the context menu or by double-clicking the instance.

## Context Menu

Right-click the placed XRef-Updater instance to access these context menu options:

| Menu Option | Description |
|-------------|-------------|
| **Update by nestings** | Prompts you to select MasterPanels and/or ChildPanels to update. Press Enter without selecting to update all panels in the drawing. Writes association metadata (name, number, path, filename) to each ChildPanel's Sip entity. |
| **Update panels** | Prompts you to select Sip panels directly. Clears the MasterPanel association metadata from selected panels. Useful for removing stale nesting data from panels that are no longer part of a nesting arrangement. |

## Workflows

### Update by Nestings Workflow

This workflow writes MasterPanel association data to all nested ChildPanels.

**Steps:**
1. Double-click the XRef-Updater instance **OR** select "Update by nestings" from context menu
2. When prompted, select the MasterPanels or ChildPanels you want to update
3. Press Enter without selecting to update all panels in the drawing
4. The script writes the following metadata to each nested ChildPanel's Sip entity:

| Metadata Key | Value Source |
|--------------|--------------|
| **Information** | MasterPanel's information property |
| **Name** | MasterPanel's name |
| **Number** | MasterPanel's number |
| **FullPathName** | Current drawing path (`_kPathDwg`) |
| **FileName** | Current drawing name (`dwgName()`) |

**Behavior Notes:**
- ChildPanels that are selected but not actually nested in any MasterPanel will have their association data cleared automatically
- For panels in XRefs, the script uses `XrefLocker` to safely modify the external reference database

### Update Panels Workflow

This workflow removes MasterPanel association data from panels.

**Steps:**
1. Select "Update panels" from context menu
2. When prompted, select Sip panels to clear their association data
3. Press Enter without selecting to process all Sip panels
4. The script removes MasterPanel metadata from panels that meet ALL of these conditions:
   - Reference the current drawing path (`_kPathDwg`)
   - Match the current drawing filename (`dwgName()`)
   - Are no longer validly nested in any MasterPanel

**Validation Logic:**
The script checks if each selected panel's Sip entity is still part of a valid MasterPanel's nested children. If the panel is found in any MasterPanel's nested children, the metadata is retained. Otherwise, the "Masterpanel" submap is removed.

## Technical Details

### Data Storage

Association data is stored on each Sip entity using the `subMapX` mechanism with the key `"Masterpanel"`.

### XRef Handling

The script uses the `XrefLocker` class to safely modify panels in external references:

```c
XrefLocker locker;
int nLockErr = locker.lockDatabaseOf(ent);
ent.setSubMapX(sMapKey, m);  // or ent.removeSubMapX(sMapKey);
```

This prevents file corruption when updating XRef data.

### Display Formatting

- **Text Height**: 100mm (scaled by `U()` function for unit conversion)
- **Line Spacing**: 1.2x text height
- **Colors**: Main text in color 1 (red), instruction text in color 14
- **Sorting**: MasterPanels are sorted alphabetically by their number property

## Tips

1. **XRef Handling**: The script automatically uses `XrefLocker` to safely modify panels in external references. This prevents file corruption when updating XRef data.

2. **Orphaned Children**: When running "Update by nestings", any ChildPanels that are selected but not actually nested in a MasterPanel will have their association data cleared automatically.

3. **Display Location**: Place the script in a convenient location in your drawing - it serves as both a visual reference and an interactive tool. The display updates each time the script recalculates.

4. **Batch Updates**: Press Enter at the selection prompt to process all panels in the drawing at once, rather than selecting individual panels.

5. **Debugging**: If you need to troubleshoot, the script supports the `hsbTSLDebugController`. Enable debugging to see detailed messages about which panels are being processed.

6. **Drawing Path Validation**: The "Update panels" function only clears metadata for panels that reference the current drawing. Panels referencing other drawings are left unchanged.

7. **Alphabetical Ordering**: MasterPanels are automatically sorted alphabetically by number in the display list for easier navigation.

8. **Double-Click Shortcut**: You can double-click the XRef-Updater instance as an alternative to selecting "Update by nestings" from the context menu.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| **No panels displayed** | Ensure your drawing contains MasterPanels with nested ChildPanels. MasterPanels without children are not shown. |
| **XRef update fails** | Check that the XRef file is not locked by another user. The `XrefLocker` will report lock errors. |
| **Association data not updating** | Verify that you're selecting the correct panels. Use debug mode to see which panels are being processed. |
| **Panel list shows unexpected panels** | The script displays all ChildPanels nested in MasterPanels. Check your nesting configuration. |

## Related Scripts

| Script | Purpose |
|--------|---------|
| **hsbCLT-MasterPanelManager** | Creates and manages MasterPanel entities |
| **hsbCLT-Presorter** | Presorts panels for nesting |
| **hsbCLT-SubNesting** | Handles sub-nesting operations for CLT panels |

---

*Last updated: Documentation generated from script analysis*
