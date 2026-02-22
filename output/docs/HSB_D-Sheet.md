# HSB_D-Sheet

## Overview

HSB_D-Sheet places dimension lines, material labels, and opening indicators on timber sheets shown inside an AutoCAD Paper Space viewport. After selecting a viewport that is linked to an HSB element (wall, floor, or roof panel), the script reads each Sheet object belonging to the element and draws dimensions directly in Paper Space, automatically scaled to match the viewport scale.

The script handles four distinct dimensioning modes:

- Overall perimeter dimensions (total width and height of the sheet group)
- Per-sheet edge dimensions (text labels or continuous dimension chains along each board edge)
- Extreme-point dimensions (overall span of the sheet arrangement in each direction)
- Angle dimensions (arc notation and numeric angle value at non-90-degree corners)

Openings detected in the sheet profiles are highlighted with diagonal crossing lines. Material names and/or sheet sizes can optionally be shown at the center of each sheet.

The script is version 1.22 (last updated 21 July 2023, fix for HSB-19566: dimension read direction correction).

---

## Usage Environment

| Property | Value |
|---|---|
| Script type | O-Type (Object / TslInst) |
| Works in | Paper Space (Layout tab) |
| Beams required | 0 |
| Implicit insert | Yes (`#ImplInsert 1`) |
| DxaOut | Enabled |

This script must be inserted onto a layout tab. It reads a viewport linked to an HSB element and draws all output in Paper Space. It does not operate in Model Space or as part of a shop drawing pipeline.

---

## Prerequisites

- A layout tab with at least one viewport must be active.
- The viewport must be linked to an HSB element (wall panel, floor cassette, or roof element) that contains Sheet objects.
- The element must be visible through that viewport in the drawing.

---

## How to Use

### Step 1 - Start the script

Insert `HSB_D-Sheet.mcr` using `TSLINSERT` or the HSB tool ribbon.

### Step 2 - Select a viewport

```
Command prompt: Selecteer een viewport
```

Click on the viewport frame (or inside the viewport) that shows the sheets you want to dimension. The script reads the element attached to that viewport.

### Step 3 - Select an anchor position

```
Command prompt: Selecteer een positie
```

Click a point in Paper Space where the script instance label will be placed. This label shows the script name and the optional extra description.

### Step 4 - Configure in the Properties Palette

The Properties Palette (OPM) opens automatically if no catalog preset is active. Adjust the parameters described below to control which sheets are included, what is dimensioned, and how the output is positioned and styled.

The script recalculates and redraws every time a property is changed.

### Step 5 - Use right-click menu for element filtering

Right-click the inserted instance on the drawing to access filter actions that restrict dimensioning to specific elements when multiple viewports share the same layout.

---

## Properties Panel (OPM Parameters)

### Selection

| Property | Type | Default | Description |
|---|---|---|---|
| Include / exclude | Dropdown | Include | Sets whether the filter values below select sheets to include or to exclude from dimensioning. |
| Filter beamcode | Text | (empty) | Semicolon-separated list of beam codes. Only sheets whose beam code matches (or does not match, depending on Include/Exclude) are dimensioned. Leave empty to accept all beam codes. |
| Filter material | Text | (empty) | Semicolon-separated list of material names. Filters sheets by the material assigned in hsbCAD. Leave empty to accept all materials. |
| Filter label | Text | (empty) | Semicolon-separated list of label values. Filters sheets by the label property. Leave empty to accept all labels. |

### Dimension Object

| Property | Type | Default | Description |
|---|---|---|---|
| Zone | Dropdown | 1 | Zone number (1-10) to dimension. Only sheets assigned to this manufacturing zone are processed. Zones 6-10 are treated as negative zone indices internally. |
| Dimension perimeter | Dropdown | Yes | When Yes, draws overall outer dimension lines around the full extent of all sheets in the zone: left, right, top, and bottom. |
| Dimension sheet edges | Dropdown | At sheet edges | Controls internal per-sheet dimensioning. **No dimension**: draws nothing. **At sheet edges**: places a text label over each edge showing its length; for angled edges, the text is placed alongside the edge. **Dimension lines**: draws formal dimension chains along all four sides of each sheet (left, right, top, bottom), with extension lines if enabled. |
| Dimension extremes per sheet | Dropdown | Yes | When Yes and **Dimension sheet edges** is set to **At sheet edges**, an additional overall dimension line is drawn showing the full X and Y span of the sheet. Only active when sheet edges are dimensioned with the **At sheet edges** option. |
| Dimension angles | Dropdown | Yes | When Yes, draws an arc and numeric angle value at every corner of a sheet that is not a right angle (90 degrees). |
| Precision (angle) | Dropdown | 0 | Number of decimal places shown for angle values: 0, 0.0, 0.00, 0.000, or 0.0000. Applies only to angle dimensioning. |
| Show material information | Dropdown | No information | Controls a text label placed at the center of each sheet. **No information**: no label. **Material**: shows the material name. **Sheet size**: shows width x height. **Material and sheet size**: shows both. |
| Show crossing in opening | Dropdown | Yes | When Yes, draws two diagonal crossing lines inside each opening detected in the sheet profile, using the Line color and Line type settings. |
| Dimension openings | Dropdown | Yes | When Yes, dimensions the edges of openings within the sheet perimeter. |

### Positioning

| Property | Type | Default | Description |
|---|---|---|---|
| Offset in paperspace units | Dropdown | Yes | When Yes, all offset values are interpreted as Paper Space millimeters and are automatically scaled using the viewport scale factor. When No, offset values are Model Space units. |
| Offset perimeter | Double | 6 | Distance from the sheet outer edge to the perimeter dimension line. |
| Offset sheet edges | Double | 1 | Distance from each sheet edge to its dimension text or dimension line. |
| Offset extremes per sheet | Double | 6 | Distance from the sheet to the extreme overall dimension line. |
| Offset angles | Double | 5 | Distance from the corner vertex to the angle arc and text. |
| X-offset information | Double | 0 | Horizontal offset applied to the material/size label relative to the sheet center. |
| Y-offset information | Double | 0 | Vertical offset applied to the material/size label relative to the sheet center. |

### Style

| Property | Type | Default | Description |
|---|---|---|---|
| Dimension style | Dropdown | (active style) | AutoCAD dimension style applied to all dimension lines and texts. The style is automatically scaled by the inverse viewport scale so dimensions appear at the correct size in Paper Space. |
| Color | Integer | 1 (red) | AutoCAD color index used for all dimension lines, texts, and perimeter dimensions. |
| Line color | Integer | 7 (white) | AutoCAD color index used for the crossing lines drawn inside openings. |
| Line type | Dropdown | (active line type) | Line type applied to the opening crossing lines. |
| Draw extension lines | Dropdown | Yes | When Yes, extension lines are drawn as part of dimension chains (applicable to Dimension lines mode). When No, dimension chains are drawn without extension lines. |

### Name and Description

| Property | Type | Default | Description |
|---|---|---|---|
| Default name color | Integer | -1 (ByLayer) | AutoCAD color index for the script instance name label drawn at the anchor point. -1 means ByLayer. |
| Filter other element color | Integer | 30 (orange) | Color applied to the instance name label when another element is being filtered (the element in the current viewport is not the filtered one). |
| Filter this element color | Integer | 1 (red) | Color applied to the instance name label when the element in the current viewport is the actively filtered element. |
| Dimension style name | Dropdown | (active style) | AutoCAD dimension style used specifically for the instance name and description text label. |
| Extra description | Text | (empty) | Optional text appended to the script name in the instance label: displayed as "HSB_D-Sheet - [Extra description]". |

---

## Right-Click Menu Options

These options appear when you right-click an inserted HSB_D-Sheet instance on the drawing.

| Menu Item | Description |
|---|---|
| Filter this element | Adds the element visible in the current viewport to the internal filter list. When a filter is active, the instance only dimensions sheets belonging to that element. The instance name label changes color to indicate an active filter. |
| (separator) | Visual separator. |
| Remove filter for this element | Removes the element in the current viewport from the filter list, restoring dimensioning for that element. |
| Remove filter for all elements | Clears all element filters, restoring full dimensioning for all elements. |

When an active filter is in effect, the instance label shows the text "Active filter" in a smaller font below the script name. The label color distinguishes between the filtered element (red, color 1) and other elements (orange, color 30).

---

## Dimension Logic Details

### Perimeter dimensioning

Draws up to four outer dimension lines (left, right, top, bottom) that span the full group of valid sheets in the selected zone. For a single angled sheet (not aligned with the element axes), the perimeter is dimensioned along the sheet's own X and Y axes rather than the world axes.

### Sheet edge dimensioning - At sheet edges mode

For each sheet, every non-angled edge segment has a text label placed perpendicular to the edge at the configured offset. Angled edges (diagonal, neither horizontal nor vertical relative to the element) also receive a text label placed alongside the angled edge. Extreme dimension lines are drawn only when the edge text does not already cover the full sheet span.

### Sheet edge dimensioning - Dimension lines mode

For axis-aligned sheets, four dimension chains are drawn along the left, right, top, and bottom sides. Redundant points (already dimensioned on the opposite side) are suppressed. For a single angled sheet, every edge receives an individual formal dimension line.

### Angle dimensioning

At each corner where the interior angle deviates from 90 degrees, an arc is drawn (radius proportional to the current dimension text height) and the angle value is shown as a number with the selected decimal precision.

### Opening visualization

After processing all sheets, the script shrinks and re-expands the combined zone profile to detect openings. Each detected opening is represented by two diagonal crossing lines drawn from corner to corner of the opening's bounding box.

### Viewport scale

All dimension styles are applied with a scale factor equal to the inverse of the viewport scale (`1 / dVpScale`), so the annotation appears at the intended printed size regardless of the viewport zoom level.

---

## Tips and Notes

- **Single insertion per session**: If the script detects that more than one insert cycle has occurred (for example, if you accidentally insert it twice), it automatically erases the new instance. To change settings, select the existing instance and modify the OPM properties; do not try to re-insert.
- **Viewport must be linked to an element**: If the selected viewport has no associated HSB element, the script erases itself immediately. Always verify that the viewport is properly linked to an HSB element before inserting.
- **Zone filtering**: Use the Zone property to target a specific manufacturing zone when the element has sheets distributed across multiple zones.
- **Combined filters**: Beam code, material, and label filters are combined using OR logic within each filter field (multiple semicolon-separated values), and the Include/Exclude toggle applies to the combined result.
- **Extension lines toggle**: Turning off Draw extension lines produces cleaner output when sheets are tightly packed and extension lines would overlap the sheet geometry.
- **Paperspace unit offsets**: Enable Offset in paperspace units to specify offsets in printed millimeters. This is the recommended setting for consistent output across drawings with different viewport scales.
- **Label color feedback**: If the instance name turns orange, another element in the drawing has been filtered. If it turns red, the element in this viewport is the filtered element. Use the right-click menu to manage filters.
- **Dutch prompts**: The insertion prompts ("Selecteer een viewport", "Selecteer een positie") are in Dutch, which is the native language of the hsbCAD development team. They translate to "Select a viewport" and "Select a position".
