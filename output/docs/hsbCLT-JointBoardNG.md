# hsbCLT-JointBoardNG

## Overview

The **hsbCLT-JointBoardNG** tool creates joint boards (splines) between adjacent CLT or SIP panels. A joint board is a narrow timber strip placed at the seam between two panels to bridge the gap and provide a structural connection. This is the next-generation version of the older JointBoard tool, with improved arc detection, real-time jig preview, and support for both joining and splitting workflows.

The tool operates in two modes:

- **Join mode**: Select two or more panels that share a common edge. The tool detects the shared edges automatically and places a joint board at the selected location.
- **Split mode**: Select a single panel. The tool splits it along a user-defined axis and inserts a joint board into the resulting gap.

The joint board can be created as a full hsbCAD timber beam (included in BOM, cut lists, and CNC export) or as a lightweight graphical body for design visualization only. After placement, the board is fully parametric: changing dimensions, alignment, or tolerances in the Properties Panel updates the board geometry and all associated panel cuts instantly.

## Usage Environment

| Attribute | Value |
|-----------|-------|
| Script Type | O (Object) |
| Beams Required | 0 (operates on SIP/CLT panels) |
| Intended Space | Model Space |
| Version | 0.20 |

## Prerequisites

- At least one CLT or SIP panel must exist in the drawing.
- **Join mode**: Two or more panels must share a common parallel edge. Panels must have parallel Z-axes (same thickness direction).
- **Split mode**: One panel is sufficient; the tool will split it and insert the board into the new gap.
- Width and Height must both be greater than zero. If either is zero at insertion, the tool aborts and removes itself.

## How to Use

### Step 1: Launch the Tool

Run `hsb_ScriptInsert "JointBoard"` from the AutoCAD command line, or start it from the hsbCAD tool palette. A dialog appears for initial configuration.

### Step 2: Set Initial Dimensions

In the dialog, set the **Width** and **Height** of the joint board. Both values must be greater than zero. Press OK to continue.

### Step 3: Select Panels

The command line prompts: **"Select panels"**. Click on one or more CLT/SIP panels and press Enter.

- **Two or more panels selected** --> Join mode (automatic shared-edge detection).
- **One panel selected** --> Split mode (you define where to split).

### Step 4a: Join Mode -- Pick the Board Location

If multiple shared edges are detected, the command line shows:

> Select joint board location [All/Reference side/Center/Top side/Higher quality/Lower quality]

A real-time preview highlights which board position your cursor is closest to. Click to place the board. Type a keyword to change face alignment before clicking.

### Step 4b: Split Mode -- Define the Split Axis

The command line shows:

> Select point on split axis [Reference side/Center/Top side/Higher quality/Lower quality/X-Axis/Y-Axis]

Click a first point to define the split location. In plan view, a second point is needed to define the split direction. In sectional views, the split direction is set automatically. Type **X-Axis** or **Y-Axis** to constrain the split direction. Press Enter or pick the second point to confirm.

### Step 5: Adjust Properties

After placement, select the joint board and open the Properties Panel (Ctrl+1) to fine-tune all parameters. Changes take effect immediately.

## Properties Panel (OPM Parameters)

### Geometry

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Width | Length | 100 mm | Width of the joint board spanning across the panel joint. |
| Height | Length | 20 mm | Depth of the joint board measured through the panel thickness direction. |
| Alignment | Dropdown | Reference Side | Which panel face the board aligns to. Options: Reference Side, Center, Opposite Side, Higher Quality, Lower Quality. |

### Gap

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Type | Dropdown | Cut | How the gap between panels is formed. **Cut** creates a straight perpendicular slot. **Relief Cut** creates an angled undercut for easier board insertion. This property is read-only when Gap is greater than 0. |
| Gap | Length | 0 mm | Clearance distance between the male and female panel edges at the joint. |

### Tolerances

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Gap Width | Length | 0 mm | Extra clearance added to each side of the slot in the width direction. |
| Gap Height | Length | 0 mm | Extra clearance at the top and bottom of the slot in the depth direction. |
| Gap Length | Length | 0 mm | Extra length added to each end of the slot beyond the board ends. |

### Chamfer

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Reference Side | Length | 0 mm | Chamfer size on the reference (bottom) face edge of adjacent panels. Set to 0 for no chamfer. |
| Opposite Side | Length | 0 mm | Chamfer size on the opposite (top) face edge of adjacent panels. Set to 0 for no chamfer. |

### General

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Material | Text | Spruce | Timber material assigned to the joint board (used in BOM and CNC export). |
| Grade | Text | (empty) | Timber grade or quality classification of the joint board. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add Panels** | Prompts to select additional SIP/CLT panels and adds them to the set managed by this joint board. |
| **Flip Side** | Toggles alignment between Reference Side and Opposite Side. Also triggered by double-clicking the board. Only available when Alignment is not Center. |
| **Join + Erase** | Merges all associated panels back into one (undoing any split), then deletes this joint board instance. |
| **Erase** | Deletes the joint board beam (if one exists) and removes the script instance. Only available when a beam has been created. |
| **Settings** | Opens a dialog to configure Create Beam mode, Auto Group path, Dimstyle, Text Height, Color, and Transparency. Changes are saved to the shared settings MapObject and apply to future instances. |
| **Import Settings** | Reloads settings from the XML file on disk. Use this to refresh defaults after another user updates the file. |
| **Export Settings** | Saves current settings to the XML file on disk. Prompts for confirmation before overwriting an existing file. |

## Settings Dialog Properties

These properties are available only through the right-click **Settings** dialog, not in the main Properties Panel.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Create Beam | Yes/No | Yes | When Yes, the board is created as a full hsbCAD beam (appears in BOM, cut lists, CNC). When No, only a graphical solid is created. |
| Auto Group | Text | (empty) | Group path for automatic assignment (e.g., "House\Floor\JointBoard"). Leave empty to inherit the group from the adjacent panel. |
| Dimstyle | Dropdown | (first available) | AutoCAD dimension style for annotation. |
| Text Height | Length | 50 mm | Height of annotation text in the board symbol. |
| Color | Integer | 31 | AutoCAD color index for board and symbol display. |
| Transparency | Integer | 80 | Transparency percentage (0-100) for the filled symbol. Higher values are more transparent. |

## Settings File

| Attribute | Value |
|-----------|-------|
| Filename | `hsbCLT-JointBoard.xml` |
| Company path | `[Company path]\TSL\Settings\hsbCLT-JointBoard.xml` |
| Installation path | `[Install path]\Content\General\TSL\Settings\hsbCLT-JointBoard.xml` |

The company path is checked first. If no file is found there, the installation path is used as fallback. When the drawing is first opened, the tool checks for version mismatches between the stored settings and the XML file on disk and reports a notice if they differ.

## Hardware Components

When **Create Beam** is set to No, the tool automatically generates hardware component entries for each joint board. Each entry includes:

- Article number composed from material, length, width, and height (e.g., "Spruce_500x100x20")
- Material and grade from the Properties Panel
- Group assignment from the Auto Group setting

When Create Beam is Yes, the board is tracked as a standard timber beam instead.

## Tips and Notes

- **Decide beam mode before placing**: The Create Beam setting determines whether the board enters the BOM and CNC workflow. Switching modes after placement causes the board to be regenerated.

- **Split mode for single-panel joints**: When you need a joint inside one large panel (e.g., a factory joint), select only that panel. The tool splits it and inserts the board in one step.

- **Alignment and surface quality**: The Higher Quality and Lower Quality alignment options automatically place the board flush with the better or worse surface quality face, as defined by the panel's hsbCAD surface quality properties.

- **Gap vs. Relief Cut**: Use Cut when panels are butted together with a straight slot. Use Relief Cut when the board must be inserted from above (loose tongue), as the angled undercut eases assembly. The Gap Type property becomes read-only once the Gap value is set above zero.

- **Dragging the board**: You can grip-drag the board along the joint line to reposition it. Adjacent panel edges stretch or re-join automatically. Dragging is disabled when the joint connects to a curved (arc) panel edge to prevent geometry errors.

- **Chamfers for assembly clearance**: Adding small chamfer values (2-3 mm) on both sides helps guide the board into the slot during on-site assembly.

- **Auto Group for large projects**: Set the Auto Group path to match your project hierarchy (e.g., "Building A\Level 2\JointBoards") to keep joint boards organized in the hsbCAD project tree. If only a partial path is given (e.g., "JointBoards"), the tool attempts to derive the house and floor group from the adjacent panel's group assignment.

- **Symbol display**: In plan and section views, the board shows as a filled cross-section symbol with configurable color and transparency. In 3D model view, the full solid geometry is displayed. When beam mode is active, the beam solid replaces the script-generated body.
