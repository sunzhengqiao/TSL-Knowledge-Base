# HSB_T-MarkSheets

## Overview
This script adds a configurable text label and graphical outline to sheet materials. It is used to identify sheet orientation or location based on the Element's Zone coordinates, helpful for guiding assembly on site or in the factory.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment and attaches marks to Sheet entities. |
| Paper Space | No | This script does not function in Layouts/Viewports. |
| Shop Drawing | No | This is a 3D model annotation tool, not a 2D drawing generator. |

## Prerequisites
- **Required Entities**: A valid `Sheet` entity (e.g., CLT panel, boarding).
- **Minimum Beam Count**: 0 (This script targets Sheets, not beams).
- **Required Settings**: The selected Sheet must be assigned to a valid Element (Wall, Floor, or Roof). Free-standing sheets without an element assignment will cause the script to fail.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or `TSL`) → Browse and select `HSB_T-MarkSheets.mcr`.

### Step 2: Configure Properties (Dialog)
If no preset catalog is active, a dialog box appears.
- **Action**: Enter the desired text (e.g., "Front", "A1"), set the text height, and choose the side.
- **Action**: Click OK to confirm settings.

### Step 3: Select Sheets
```
Command Line: Select sheets
Action: Click on the sheet(s) in the model you wish to mark.
```
- **Action**: Press Enter to confirm selection.

### Step 4: Completion
- The script instance attaches to the selected sheets and draws the mark and text.
- The original "commander" instance removes itself, leaving the annotation on the sheets.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Text | text | "" | The inscription content to be displayed on the sheet surface. If left empty, a default leader line may be shown. |
| Text size | number | U(15) | The height of the text characters and the scale of the graphical box/outline drawn around the text (in mm). |
| Mark view side | dropdown | Yes | Determines which face of the sheet receives the mark. "Yes" places it on the view side; "No" places it on the opposite side. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific custom commands to the right-click context menu. Use the Properties Palette to modify settings. |

## Settings Files
- **Filename**: *None specific*
- **Location**: N/A
- **Purpose**: The script uses the internal `_LastInserted` catalog to remember the last used settings (Text, Size, etc.) for the current session.

## Tips
- **Assembly Marking**: Use this script to mark installation sides (e.g., "Insulation Side") or specific zones (e.g., "Window Zone") directly on large panels.
- **Dynamic Adjustment**: Because the script uses the `U()` function for sizing, the text and box will scale correctly regardless of your drawing unit settings (mm vs inches).
- **Text Visibility**: If you enter text into the "Text" property, the standard leader line for the mark is suppressed, showing only your custom text and box.
- **Moving Sheets**: The mark is attached to the sheet. If you use the standard AutoCAD `MOVE` command on the sheet, the mark moves with it automatically.

## FAQ
- **Q: Why did the mark disappear immediately after selecting the sheet?**
  **A:** The selected sheet might not be assigned to a valid Element (Wall, Floor, or Roof). The script requires the sheet to be part of an element to calculate the correct orientation vector (Zone Z).
- **Q: How do I flip the text to the other side of the sheet?**
  **A:** Select the marked sheet, open the Properties Palette, find the "Mark view side" parameter, and change it from "Yes" to "No".
- **Q: Can I change the text size after insertion?**
  **A:** Yes. Select the sheet with the script, locate "Text size" in the Properties Palette, and modify the value. The graphics will update immediately.