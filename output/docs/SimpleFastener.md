# SimpleFastener.mcr

## Overview

**SimpleFastener** creates drills and screw fasteners in intersecting timber beams (GenBeams). It provides an interactive 3D rotation system for precise placement and includes tools to manage fastener assembly definitions and select hardware from a database.

| Property | Value |
|-----------|-------|
| **Script Type** | O (Object) |
| **Category** | Hardware/Fastener |
| **Version** | 1.3 (28.10.2025) |
| **Author** | Thorsten Huck |
| **Required Beams** | 1 minimum (designed for intersecting beams) |
| **AutoCAD Command** | `TSLINSERT` → select `SimpleFastener` |

### Key Features
- Interactive rotation jig with angle snapping (1deg, 5deg, 10deg, 22.5deg, 45deg)
- Automatic fastener length calculation based on material thickness
- Sink hole (countersink) support
- Two export modes: Fastener Entity or Hardware Component
- Style-based fastener management for quick reuse

---

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| **Model Space** | Yes | Primary workspace for 3D modeling |
| **Paper Space** | No | |
| **Shop Drawing** | No | |

---

## Prerequisites

### Required Entities
- At least one **GenBeam** (structural timber beam)
- Secondary beams can be added during insertion

### Required Dependencies
- **FastenerManager.dll** - Located in `_kPathHsbInstall\Utilities\FastenerManager\`
- **TslUtilities.dll** - Located in `_kPathHsbInstall\Utilities\DialogService\`
- **Fastener Database** - Configured via the FastenerManager (supports .mdb or .xlsx formats)

---

## Usage Steps

### Step 1: Launch the Script
Run the command:
```
TSLINSERT
```
Select `SimpleFastener` from the script list, or use:
```
hsb_ScriptInsert "SimpleFastener"
```

### Step 2: Select Primary Beam
Click on the timber beam where you want to place the fastener.

### Step 3: Select Secondary Entities (Optional)
**Prompt:** `Select secondary entities`

You can select:
- Additional **GenBeams** (intersecting beams)
- **TslInst** (other TSL instances)
- **MetalPartCollectionEnt** (metal hardware collections)

Press Enter to skip if no additional entities are needed.

### Step 4: Select Face (In Non-Orthographic Views)
If you are in a 3D perspective view, you will see highlighted faces on the beam.

**Prompt:** `Select face [Flip face]`

- Click on the desired face where the fastener will enter
- Type **Flip face** and press Enter to toggle between front/back faces
- The selected face will be highlighted in yellow

### Step 5: Position the Fastener
**Prompt:** `Pick point [X-Axis/Y-Axis/Perimeter/Offset/FlipSide]`

- **Pick point**: Click to place the fastener at the cursor location
- **X-Axis**: Align with the beam's local X-axis
- **Y-Axis**: Align with the beam's local Y-axis
- **Perimeter**: Snap to the perimeter of the face
- **Offset**: Specify an offset distance from a reference point
- **FlipSide** (orthogonal views only): Switch to the opposite face

### Step 6: Select Rotation Axis
Three colored circles will appear representing rotation axes:
- **Red circle (X-axis)**: Rotate in the Y-Z plane
- **Green circle (Y-axis)**: Rotate in the X-Z plane
- **Purple circle (Z-axis)**: Rotate in the X-Y plane

Click on the circle corresponding to your desired rotation axis.

### Step 7: Set Rotation Angle
**Prompt:** `Pick point to rotate [Angle/Basepoint/ReferenceLine]`

Move your cursor to dynamically rotate the fastener. The rotation system uses adaptive angle snapping based on cursor distance:

| Cursor Distance | Snap Increment |
|-----------------|----------------|
| Close (< 0.5x diameter) | 45 degrees |
| Medium (0.5x - 1x diameter) | 22.5 degrees |
| Normal (1x - 1.5x diameter) | 10 degrees |
| Far (1.5x - 2x diameter) | 5 degrees |
| Very Far (> 2x diameter) | 1 degree (full precision) |

**Keyword Options:**
- **Angle**: Type a specific numerical angle value
- **Basepoint**: Select a new rotation center point
- **ReferenceLine**: Align the fastener to an existing line in the drawing

### Step 8: Configure Fastener Style
The script displays a dialog to configure:
- **Fastener Style**: Select from existing fastener definitions or create new
- **Length**: Automatic (0) or specify a fixed length
- **Mode**: Fastener Entity or Hardware Component

---

## Properties Panel (OPM)

### Geometry Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Diameter** | Length | 0 | The main diameter of the drill/fastener. Set to 0 to use the diameter from the selected Fastener Style. |
| **Additional Diameter** | Length | 0 | Extra clearance added to the main diameter for looser fits. |
| **Length** | Length | 0 (Auto) | The fastener length. Set to 0 for automatic calculation based on material thickness, or select from available lengths. |

### Sink Hole Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Diameter Sink** | Length | 0 | Diameter of the countersink/sink hole. Only active when creating new fastener styles. |
| **Depth Sink** | Length | 0 | Depth of the countersink/sink hole. Only active when creating new fastener styles. |

### Fastener Category

| Property | Type | Options | Description |
|----------|------|---------|-------------|
| **Fastener Style** | String | List of styles + `<Disabled>` + `<Add New>` | Select a predefined fastener configuration. Choose `<Add New>` to create a new style via the FastenerManager dialog. |
| **Mode** | String | Fastener Entity / Hardware Component | Determines export format: **Fastener Entity** creates a visible 3D fastener; **Hardware Component** creates non-graphical hardware for BOM export. |
| **Penetration Depth** | Length | 0 | Required thread engagement depth in the last beam. Used to validate fastener selection. |

### Display Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Format** | String | `@(ArticleNumber)` | Format string for the tag display. Supports placeholders like `@(ArticleNumber)`, `@(Length)`, `@(Diameter)`, etc. |
| **Text Height** | Length | 5 (0 = by DimStyle) | Height of the tag text. Set to 0 to use the current dimension style's text height. |

---

## Right-Click Menu Options

Right-click on the SimpleFastener instance to access these options:

| Menu Item | Description |
|-----------|-------------|
| **Add/Edit Fastener (Double Click)** | Opens the FastenerManager dialog to select or create fastener definitions. Also triggered by double-clicking the instance. |
| **Add Genbeams** | Add additional intersecting beams to the fastener's scope. |
| **Remove Genbeams** | Remove selected beams from the fastener's scope (only available when multiple beams are referenced). |
| **Rotate** | Re-open the rotation jig to adjust the fastener orientation. |
| **Flip Face** | Rotate the fastener 180 degrees around its local Y-axis. Useful for reversing the direction without re-inserting. |
| **Show StyleManager** | Opens the hsbCAD Style Manager to create or modify fastener assembly definitions. |
| **Load Graphical Ruleset** | Import a graphical ruleset file for custom fastener display representation. |
| **Change Database** | Opens the FastenerManager database dialog to switch to a different fastener database file. |

---

## How It Works

### Drill Creation Logic

1. **Primary Beam Detection**: The script identifies the first (primary) beam and determines entry/exit points
2. **Intersection Analysis**: Calculates all beam intersections along the fastener axis
3. **Drill Generation**: Creates cylindrical drills with the specified diameter
4. **Sink Hole**: If configured, adds a stepped countersink at the entry point

### Automatic Length Selection

When **Length = 0** (automatic mode), the script:
1. Collects all available fastener lengths from the selected style
2. Validates each length against:
   - Total material thickness
   - Thread start position
   - Required penetration depth
3. Selects the longest valid fastener

### Grip Point for Tag

A circular grip point is automatically added when the fastener has a valid tag format. Drag this grip to reposition the text label.

---

## Tips and Best Practices

### Precise Alignment
- Use the **ReferenceLine** option during rotation to align the fastener with an existing edge or construction line
- Snap to object endpoints for accurate positioning

### Efficient Workflow
- Create frequently-used fastener configurations as **Styles** to avoid re-selecting parameters
- Use **Double-Click** on an instance to quickly modify the fastener selection

### Grid Snapping
- The rotation jig automatically adjusts snap precision based on cursor distance
- Move cursor closer to the center for coarse snapping (45deg)
- Move cursor farther away for fine precision (1deg)

### Troubleshooting Orientation
- If the fastener faces the wrong direction, use **Flip Face** instead of re-inserting
- For complex angles, use the **ReferenceLine** option to align to existing geometry

---

## Troubleshooting

### "No screws available to select"
**Cause:** The Fastener Database is not configured or is empty.
**Solution:** Right-click the instance and select **Change Database** to configure the database path.

### "No referenced genbeam found"
**Cause:** The primary beam reference was lost (beam deleted).
**Solution:** Delete the invalid SimpleFastener instance and create a new one.

### Fastener length is always 0
**Cause:** No valid fastener lengths match the material thickness and penetration requirements.
**Solution:** Check that the selected style has articles with appropriate lengths for your application.

### Penetration depth shows red indicator
**Cause:** The selected fastener cannot achieve the required penetration depth (thread engagement).
**Solution:** Either select a longer fastener or reduce the penetration depth requirement.

### Tag text not visible
**Cause:** The Format property may be empty or invalid.
**Solution:** Set Format to `@(ArticleNumber)` or another valid format string.

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.3 | 28.10.2025 | Fastener article data entries now ordered by length |
| 1.2 | 21.10.2025 | Automatic replacement of invalid characters in style names (comma, slash, backslash) |
| 1.1 | 20.05.2025 | Accepting filter as input when creating styles |
| 1.0 | 19.05.2025 | Improved report layout |
| 0.44 | 11.04.2025 | Commas refused in style names |
| 0.43 | 08.04.2025 | Improved copy behavior |
| 0.42 | 17.03.2025 | Support for simple wireframe and thread display |
| 0.41 | 12.02.2025 | Adopted to new property control behavior |
| 0.40 | 06.12.2024 | Fixed drill depth on tilted drills |
| 0.39 | 29.11.2024 | Drill added to primary beam if no secondary found |

---

## Related Scripts

| Script | Description |
|--------|-------------|
| **FastenerEditor** | Advanced fastener configuration and management |
| **FastenerInspector** | Inspect fastener properties and validate connections |
| **GA.mcr** | Generic angle bracket system with similar insertion workflow |
| **Hilti-*.mcr** | Manufacturer-specific fastener scripts (Hilti products) |
| **Simpson-*.mcr** | Manufacturer-specific fastener scripts (Simpson products) |

---

## Settings Files

| File | Location | Purpose |
|------|----------|---------|
| **TslUtilities.dll** | `_kPathHsbInstall\Utilities\DialogService\` | User interface dialogs (selection lists, input boxes) |
| **FastenerManager.dll** | `_kPathHsbInstall\Utilities\FastenerManager\` | Database connection and fastener filtering |
| **Fastener Database** | User-configured | Contains technical data (dimensions, materials, codes) |

---

## Technical Notes

### Coordinate System
The fastener uses a local coordinate system where:
- **Z-axis**: Points along the drill direction (into the material)
- **X/Y axes**: Aligned with the beam's local axes or specified by rotation

### Validation Checks
- Thread start must be before the penetration point
- Fastener end must be within or past the last beam
- Penetration depth is validated against thread availability

### Hardware Export
When **Mode = Hardware Component**:
- Creates non-graphical hardware for BOM/export purposes
- Displays a simplified wireframe representation with thread indicator
- Does not create a FastenerAssemblyEnt entity
