# hsb_A4 Layout

## Overview

`hsb_A4 Layout` is a wall elevation dimensioning tool that reads a stick-frame wall element from a viewport (Paper Space or Shop Drawing view) and automatically generates a comprehensive set of dimensions and annotations directly on the layout. It produces stud location lists, horizontal and vertical dimension chains, opening sizes, blocking heights, sheeting diagonals, nailing information, and overall wall statistics — all scaled and positioned relative to a user-picked reference point.

## Usage Environment

| Space | Supported |
|-------|-----------|
| Model Space | No |
| Paper Space | Yes |
| Shop Drawing View | Yes |

The script operates exclusively in Paper Space or inside a Shop Drawing multipage view. It reads geometry from the linked viewport or shop-draw view and projects all dimension output into that same layout space at the correct viewport scale.

## Prerequisites

- The drawing must contain at least one Paper Space viewport that is linked to a stick-frame wall element (`ElementWallSF`), or alternatively a Shop Drawing view entity that contains such an element.
- The wall element must have been modelled with zone 0 beams present. The script filters all beams to zone 0 before processing.
- If nailing information is required, the script `hsb_Apply Naillines to Elements` must have been applied to the wall element beforehand so that the nailing data is available in the element's attached TSL map.
- A dimension style must exist in the drawing for the script to reference via the `Dim Style` and `Dim Style Studs Only` properties.

## How to Use

### Step 1: Launch the Script

Type `TSLINSERT` at the AutoCAD command line, navigate to and select `hsb_A4 Layout.mcr`. A settings dialog appears first. Review or adjust the properties as needed, then confirm.

### Step 2: Pick the Bottom Reference Point

The command line prompts:

> `Pick a point where the bottom horizontal dim will reference to`

Click a point in Paper Space. This point controls the vertical position of the bottom stud dimension chain and the nailing note. The top text block is offset above this point by the `Offset Top Text From PickPoint in VP Units` value.

### Step 3: Link to a Viewport or Shop Drawing View

- **Paper Space mode**: The command line prompts `Select the viewport from which the element is taken`. Click on the viewport that displays the wall you want to annotate.
- **Shop Drawing mode**: The command line prompts `Select the view entity from which the module is taken`. Click on the shop drawing view entity.

The script then reads all beam, sheet, and opening data from the linked element and draws the full dimension set. The TSL instance is placed and will recalculate automatically if the wall geometry changes.

## Properties Panel (OPM Parameters)

All parameters are visible and editable in the AutoCAD Properties Palette after the script is inserted.

### Display Space

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Drawing space | String (list) | Paper space | Switches between `Paper space` and `Shopdraw multipage` mode. Becomes read-only after insertion. |

### Left Dimension List (Stud Running Positions)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show Left Dimension List | String (list) | None | Controls which edge of each stud is used to compute running distances: `Start`, `End`, `Center`, or `None` (no list). |
| List Spacing | Double | 5 mm | Vertical gap between text rows in the stud position list. |
| X Offset for List | Double | 300 mm | Horizontal offset from the element origin where the position list starts. |
| Y Offset for List | Double | 0 mm | Additional vertical offset for the position list. |
| Number of Items per column | Int | 20 | When the list exceeds this count, it wraps to a new column. |

### Dimension Styles

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dim Style | String (list) | Drawing default | AutoCAD dimension style applied to all dimension lines and text. |
| Dim Style Studs Only | String (list) | Drawing default | Separate dimension style applied specifically to stud reference text and running stud dimensions. |
| Color | Int | 1 (Red) | ACI color index applied to all drawn dimensions and text. |

### Bottom Stud Dimension Chain

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show Bottom Dimension | String (list) | None | Whether and how to show stud positions below the panel: `Start`, `End`, `Center`, or `None`. |
| Bottom Dimension From | String (list) | Left Side | Whether distances in the bottom chain are measured from the left or right side of the element. |
| Show as | String (list) | Line and Text | Display mode: `Line and Text` (individual tick marks with text), `Dimension Line - Running` (cumulative running dimension line), or `Dimension Line - Delta` (incremental delta dimension line). |
| Text location | String (list) | Top | For delta mode: places dimension text on `Top` or `Bottom` of the line. |
| Running Dimension Orientation | String (list) | Parallel | For running mode: `Parallel` (horizontal) or `Perpendicular` (vertical). |
| Offset Running Dimension | Double | 100 mm | Distance below the element baseline where the running dimension line is drawn. |
| Length Running Dimension Lines | Double | 250 mm | Height of the individual stud tick lines in `Line and Text` mode. |
| Offset Bottom Dimension/Text from PickPoint | Double | 0 mm | Additional vertical shift of the bottom dimension chain relative to the picked reference point. |

### Stud References and Filtering

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show Stud References | String (list) | Yes | Shows labels such as `S` (stud), `J` (jack), `C` (cripple), `JF`/`JB` (junction front/back) below each member. |
| Offset Stud References | Double | 60 mm | Distance below the element where stud reference labels are placed. |
| Include Beam With BeamCode | String | (empty) | Semicolon-separated beam codes to force-include in the bottom dimension chain even if they would otherwise be excluded. |
| Exclude Beam With BeamCode | String | (empty) | Semicolon-separated beam codes to exclude from the bottom dimension chain. |
| Exclude Rotated Studs | String (list) | No | When `Yes`, flat studs (whose depth in the wall direction exceeds their thickness) are removed from the dimension chain unless their beam code is listed in `Include Beam With BeamCode`. |

### Sheet and Diagonal Display

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show Panel Diagonal Dimension | String (list) | No | Draws the longest diagonal of the panel: `Yes` (as a dimension line), `No` (not drawn), or `As Text on Top` (shows the diagonal value as a text note above the panel). |
| Dimensions Include Headbinder | String (list) | No | When `Yes`, the headbinder beam is included when computing the panel outline and the diagonal. |
| Show Diagonal for Sheets | String (list) | No | Draws a dashed diagonal line across each sheet. |
| Sheet Color Diagonal | Int | 5 | ACI color index for the sheet diagonal line. |
| Show Sheet Outline | String (list) | No | Draws the outline of each sheet panel. |
| Sheet Color Outline | Int | 5 | ACI color index for the sheet outline. |
| Sheet Zone | String (list) | All | Restricts sheet display and sheet dimension to a specific zone (1-10) or `All`. |
| Filter sheets by material | String | (empty) | When set, only sheets whose material matches this value are shown and dimensioned. |

### Opening Dimensions

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Horizontal Opening Dimension | String (list) | Center of Opening | Where to place the horizontal opening width dimension: `Center of Opening`, `Below Element`, `Both`, or `None`. |
| Offset Horizontal Opening Dim | Double | 0 mm | Fine-adjustment of the horizontal opening dim line position when placed at centre-of-opening height. |
| Vertical Opening Dimension | String (list) | Center of Opening | Where to place the vertical opening height dimension chain: `Right Side`, `Center of Opening`, `Left Side`, or `None`. |
| Show Cummulative Opening Dimension | String (list) | No | When `Yes`, adds a cumulative (running) dimension alongside the delta dimension for openings. |
| Show Window/Door size | String (list) | Yes | Prints the rough opening width `W:` and height `H:` in the center of each opening, plus the structural opening size in parentheses. |
| Show Window/Door Description | String (list) | None | Prints a text description inside each opening: `None`, `hsbCAD` (hsbCAD opening description), `AutoCAD` (AutoCAD entity description), or `Property Set` (reads from a named property set). |
| Property set name | String | (empty) | Name of the AutoCAD property set to read opening description data from, when `Show Window/Door Description` is set to `Property Set`. |
| Show Window Head/Sill Heights | String (list) | Head Height | Controls display of heights from wall bottom: `None`, `Head Height`, `Sill Height`, or `Both`. |
| Show Header Description | String (list) | From Beam Size | Text shown next to each header beam: `From Details` (uses ElemText), `From Beam Name`, `From Beam Size` (formatted as count/depth x height x length), `No`, or `Header detail description`. |
| Offset Header Description | Double | 50 mm | Vertical offset of the header description text below the header position. |

### Blocking Dimensions

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show Blocking Dim | String (list) | Yes | Shows a vertical dimension chain for all blocking pieces in the wall. |
| Blocking Dimline alignment | String (list) | Right | Places the blocking dimension chain on the `Right` or `Left` side of the element. |
| Blocking Dim Offset From Element (left side only) | Double | 100 mm | When the blocking dim is on the left, this sets the gap between the element edge and the dimension line. |
| Dimension blocking to | String (list) | Top | Selects whether blocking dimensions point to the `Bottom`, `Center`, or `Top` of each blocking piece. |
| Show Vertical Dim Names | String (list) | No | When `Yes`, labels the vertical dimension chains with text: `Blocking`, `Opening`, or `Wall height`. |
| Show Blocking Length | String (list) | No | Prints the length of each blocking piece as a text note next to that piece. |
| Show Jacks Length | String (list) | Yes | Prints the length of each jack stud (under and over openings) next to that member. |

### Flat Studs

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Hatch Flat Studs | String (list) | No | Applies a hatch pattern to flat studs (studs wider than the wall thickness). |
| Hatch pattern | String (list) | Drawing default | The AutoCAD hatch pattern to use for flat stud hatching. |
| Show Flat Studs Description | String (list) | No | Draws a text label next to each flat stud indicating `FS to front`, `FS to rear`, or `FS to front & rear`. |

### Angle Plates and Top Plates

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show Angle Stud Dim | String (list) | Dimension | For studs connected to angled top/bottom plates: `None`, `Dimension` (draws a dimension line), or `Text` (shows the cut length in parentheses). |
| Dimension From | String (list) | Long Side | Whether the angled stud dimension is measured from the `Long Side` or `Short Side`. |
| Offset Stud Dim Line | Double | 25 mm | Lateral offset of the angle stud dimension line. |
| Dim Angle Top Plate | String (list) | No | When `Yes`, draws a delta dimension along the angled top plate members. |
| Show Angular Dimensions | String (list) | No | When `Yes`, draws angular (oblique) dimension lines for any non-orthogonal edges in the panel outline. |

### Wall Information and Nailing

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show Wall Information | String (list) | Yes | Prints a text line above the panel showing the wall definition, beam depth, and wall width (e.g., `EW1 140x38`). |
| Timber density (kg/m3) | Double | 450 | Density value used to compute the estimated timber frame weight. |
| Show Frame Weight | String (list) | Yes | Appends the calculated frame weight in kg to the wall information text. |
| Show Nailing Information | String (list) | No | Reads nailing data from the attached `hsb_Apply Naillines to Elements` TSL and prints perimeter and intermediate spacing. |
| Show Nailing Type | String (list) | No | When `Yes`, also prints the nail type name from the nailing data. |

### Offsets

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Offset From Element | Double | 150 mm | Base gap between the element edge and the first vertical dimension line. |
| Offset Between Text Lines | Double | 150 mm | Spacing between successive dimension lines (e.g., opening dim and wall height dim). |
| Offset Top Text From PickPoint in VP Units | Double | 150 mm | How far above the picked reference point the wall information text is placed (in viewport paper-space units). |

## Typical Workflow

1. Model the stick-frame wall in Model Space and apply sheeting, openings, and (optionally) naillines with `hsb_Apply Naillines to Elements`.
2. Set up a Paper Space layout with a viewport showing the wall in elevation.
3. Insert `hsb_A4 Layout` via `TSLINSERT`.
4. In the settings dialog, configure the dimension style, which elements to show (blocking, diagonal, nailing, etc.), and the display offsets.
5. Pick a point below the viewport to anchor the bottom dimension chain, then click the viewport.
6. The script draws all annotation immediately.
7. If the wall geometry changes later (e.g., a stud is moved, an opening is resized), the TSL instance automatically recalculates and all dimensions update in place.

## Tips and Notes

- The script works exclusively on `ElementWallSF` (stick-frame wall) elements. It exits silently if the viewport does not contain a valid stick-frame element.
- All dimensions are drawn in Paper Space, transformed correctly for the current viewport scale. When the viewport scale changes, recalculate the TSL instance to regenerate all annotations at the new scale.
- The `Drawing space` property is set automatically from the type of entity selected (viewport versus shop-draw view) and becomes read-only after insertion.
- Use semicolons to separate multiple beam codes in `Include Beam With BeamCode` and `Exclude Beam With BeamCode` (e.g., `LVL;STEEL`).
- The `Sheet Zone` filter and `Filter sheets by material` filter are independent. Both can be used simultaneously to narrow the set of sheets that receive outlines and diagonal marks.
- For imperial drawings (inches), the script automatically switches all text formatting to fractional inch notation. Dimension precision adapts accordingly.
- The `Show Left Dimension List` feature lists the running distances of each stud from the element origin as a vertical column of text outside the panel. This is useful for fabrication schedules placed directly on the shop drawing sheet.
- When `Show Vertical Dim Names` is enabled, short text labels (`Blocking`, `Opening`, `Wall height`) are placed at the top of each vertical dimension chain, making complex multi-chain drawings easier to read.
- The diagonal dimension is calculated as the longest distance between any two non-adjacent vertices of the panel convex hull, which correctly handles non-rectangular panels such as gable rakes and hip cuts.
- If the bottom dimension chain and the nailing note overlap each other, increase `Offset Between Text Lines` or reduce the number of active annotation layers.
- Version 1.76 (August 2024) is the current release. The script supports both metric (mm) and imperial (feet-inch-fraction) unit templates without modification.
