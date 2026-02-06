# hsbInkjet.mcr

## Overview
This script automates the application of inkjet text markings onto timber beams for production identification and positioning. It allows users to place dynamic labels (such as Position Numbers or dimensions) or static text on specific faces of beams in the 3D model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script runs exclusively in 3D Model Space. |
| Paper Space | No | Not supported for layout or drawing views. |
| Shop Drawing | No | Not applicable to 2D generation. |

## Prerequisites
- **Required entities**: At least one Beam or Element.
- **Minimum beam count**: 1
- **Required settings**: None (supports standard catalogs).

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Browse and select `hsbInkjet.mcr` from the script list.

### Step 2: Configuration (if not preset)
**Dialog:** If no catalog entry is found, the configuration dialog appears.
**Action:** Set the desired Text Format, Height, Alignment, and Face. Click OK to proceed.

### Step 3: Select Target
**Command Line:** `Select beams/elements:`
**Action:**
- Click on individual **Beams** to mark them.
- OR click on an **Element** to mark all beams contained within it.
- Press **Enter** to confirm selection.

### Step 4: Generation
**Action:** The script attaches itself to the selected beams. The initial command instance will disappear, and the inkjet markings will be visualized on the beams.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Format | String | @(Posnum) | The text content to print. Supports dynamic attributes (e.g., `@(Length)`, `@(Name)`) and static text. Max 32 characters. |
| Horizontal Alignment | Enum | Center | Horizontal justification of the text block: Left, Center, or Right. |
| Vertical Alignment | Enum | Center | Vertical justification of the text block: Bottom, Center, or Top. |
| Orientation | Enum | X-Axis | Reading direction of the text relative to the beam (e.g., X-Axis, Y-Axis, Perpendicular). |
| Text Height | Double | 60 mm | Physical height of the characters (Range: 20mm - 150mm). |
| Face | Enum | Top | The side of the beam where the marking is applied: Top, Left, Bottom, or Right. |
| Location Offset | Double | 0 mm | Distance from the center of the beam along its length. Positive values move the grip/text towards the beam end. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Set Format Expression | Opens a command-line interface to list available beam variables and add/remove them from the current Format string by index number. |

## Settings Files
- **Filename**: None (Standalone script, though compatible with hsbCAD Catalogs).
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Grip Edit:** Use the grip point (square symbol) on the beam in the 3D model to drag the inkjet mark longitudinally. The *Location Offset* property updates automatically.
- **Batch Processing:** Selecting an Element allows you to apply the inkjet marking to all beams within that element simultaneously.
- **Text Trimming:** If the generated text exceeds 32 characters, the script will automatically trim it and display a message. You may need to abbreviate your Format string.
- **Dynamic Variables:** Use the `Set Format Expression` context menu option to quickly add variables like `@(Length)` or `@(Height)` without typing the syntax manually.

## FAQ
- **Q: Why is my text not showing up?**
  **A:** Check the *Face* property to ensure the mark is applied to a visible side of the beam (e.g., Top vs Bottom). Also, ensure the *Text Height* is not too small for the scale of your beam.

- **Q: Can I combine static text and variables?**
  **A:** Yes. In the *Format* property, you can type static text mixed with variables. Example: `Pos: @(Posnum) L: @(Length)`.

- **Q: What happens if I move the beam?**
  **A:** The inkjet mark is parametric and will move with the beam. If you stretch or modify the beam length, the mark will attempt to maintain its relative offset.