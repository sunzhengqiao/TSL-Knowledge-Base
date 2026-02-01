# GE_BEAM_INFO_GET_PANHAND.mcr

## Overview
This is a diagnostic tool that inspects selected timber beams to identify the entity type acting as their "panhand" (reference contour or profile guide). It is useful for verifying why a beam might be processing incorrectly regarding its shape or machining.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the Model Space. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required entities**: Existing `GenBeam` (timber beam) entities in the model.
- **Minimum beam count**: At least 1 beam must be selected.
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: Type `TSLINSERT` in the command line.
Action: Select `GE_BEAM_INFO_GET_PANHAND.mcr` from the file list and click **Open**.

### Step 2: Select Beams
```
Command Line: select a set beams
Action: Click on the beams you wish to analyze in the drawing area. You can select multiple beams. Press Enter or Spacebar to confirm your selection.
```

### Step 3: View Results
Action: The script automatically processes the selection and displays a report. The report lists the **Handle**, **Type**, and **Panhand Status** (e.g., the entity type name or "EMPTY" if missing) for each selected beam.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose editable properties in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add items to the right-click context menu. |

## Settings Files
- **Filename**: N/A
- **Location**: N/A
- **Purpose**: No external settings files are used.

## Tips
- **Self-Cleaning Script**: This script is designed to run once and automatically erase itself from the drawing after displaying the report. You do not need to delete it manually.
- **Troubleshooting**: If the report shows "EMPTY" for the Panhand status, it means the selected beam does not have a valid reference contour assigned to it.

## FAQ
- **Q: Why did the script disappear immediately after running?**
  - **A:** The script is designed as a one-time diagnostic tool. It automatically deletes itself (`eraseInstance`) after generating the report to keep your drawing clean.
- **Q: What does "Panhand" mean in this context?**
  - **A:** In hsbCAD, the Panhand usually refers to the reference contour or profile guide that defines the beam's cross-section or shape.
- **Q: Can I save the output?**
  - **A:** The output is shown in a text dialog. You can manually copy and paste the text from the dialog into a text editor or Excel if needed.