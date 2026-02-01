# hsb_DrawXonWindow.mcr

## Overview
This script creates a visual annotation on window or door openings consisting of a crossing "X" shape and a text label reading "PL Above Opening". It is used to communicate detailing instructions, such as plasterboard requirements, directly on the 3D model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates directly on Opening entities within the 3D model. |
| Paper Space | No | Script does not support 2D layout views or sheets. |
| Shop Drawing | No | This is not a shop drawing generation script. |

## Prerequisites
- **Required Entities:** A valid hsbCAD **Opening** (Window or Door).
- **Minimum Beam Count:** 0.
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Navigate to the script location, select `hsb_DrawXonWindow.mcr`, and click **Open**.

### Step 2: Select an Opening
```
Command Line: Select an Opening
Action: Click on the desired window or door opening object in the Model Space.
```
*Note: The script will automatically calculate the geometry and draw the "X" and text upon completion of the selection.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Enter a Dimstyle | Dropdown | Current Active Dimstyle | Selects the Dimension Style (font, size, color) to be applied to the "PL Above Opening" text label. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are added by this script. |

## Settings Files
- **Filename:** None required.
- **Location:** N/A
- **Purpose:** N/A

## Tips
- **Adjusting Text Appearance:** To change the font or size of the label, select the inserted script instance, open the **Properties** palette (Ctrl+1), and choose a different style from the "Enter a Dimstyle" dropdown.
- **Avoiding Duplicates:** If you accidentally insert this script twice on the same opening, the script will automatically detect the duplicate and erase the newest instance to keep your model clean.

## FAQ
- **Q: Can I change the text "PL Above Opening" to something else?**
  - A: No, the text string is hardcoded within the script.
- **Q: Why did the script disappear after I inserted it?**
  - A: This happens if you insert the script on an opening that already has this script attached. The script automatically deletes duplicate instances.
- **Q: Does this work on custom drawn openings?**
  - A: As long as the entity is recognized as a valid hsbCAD Opening object, the script will function correctly.