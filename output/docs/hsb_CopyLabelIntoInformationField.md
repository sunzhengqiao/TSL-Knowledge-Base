# hsb_CopyLabelIntoInformationField.mcr

## Overview
This utility script copies the current visible label text of selected timber beams into their internal 'Information' property. It is designed to quickly transfer label data into the system field for use in reports, lists, or manufacturing exports.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model elements. |
| Paper Space | No | Not intended for use in Layouts. |
| Shop Drawing | No | Not intended for use within Shop Drawings. |

## Prerequisites
- **Required entities:** GenBeam (Timber Beams)
- **Minimum beam count:** 1
- **Required settings files:** None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
- Navigate to the folder containing `hsb_CopyLabelIntoInformationField.mcr`
- Select the file and click **Open**

### Step 2: Select Beams
```
Command Line: Please select Beams
Action: Click on the desired beams in the model view.
```
- Select one or multiple beams using any standard AutoCAD selection method (click, window, crossing).
- Press **Enter** or **Space** to confirm the selection.

### Step 3: Automatic Processing
- The script will automatically read the **Label** text of each selected beam.
- It will write this text into the **Information** property of the beam.
- The script instance will automatically erase itself from the drawing upon completion.

## Properties Panel Parameters

This script does not expose any parameters to the Properties Palette (OPM).

## Right-Click Menu Options

This script does not add any specific options to the right-click context menu.

## Settings Files
None required.

## Tips
- **Manual Label Edits:** Use this script after you have manually edited beam labels (e.g., adding specific assembly notes or sorting codes) and need that text to appear in data exports or BOMs.
- **Verification:** After running the script, you can verify the change by selecting a beam and checking the 'Information' field in the Properties Palette.
- **Run-Once Utility:** The script erases itself immediately after execution. You do not need to delete it manually.

## FAQ
- **Q: Can I use this on elements other than beams?**
  A: No, the script is designed specifically for GenBeam entities.
- **Q: Does this overwrite existing Information?**
  A: Yes, the content of the 'Information' field will be replaced entirely by the text currently in the 'Label' field.
- **Q: Why did the script disappear after I ran it?**
  A: This is normal behavior. The script is a utility that performs its task and removes itself to keep your drawing clean.