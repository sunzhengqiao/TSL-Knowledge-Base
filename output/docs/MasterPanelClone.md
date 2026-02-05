# MasterPanelClone.mcr

## Overview
Creates a static geometric clone (solid body) of a selected MasterPanel, placed at a user-defined location, with a customizable text label displaying panel properties.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script creates 3D solid geometry and operates only here. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities:** Existing "MasterPanel" entities must be present in the drawing.
- **Minimum Beam Count:** 1
- **Required Settings:** None

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Browse and select `MasterPanelClone.mcr`.

### Step 2: Configure Properties (Dialog)
**Action:** If the script is not run from a pre-configured catalog entry, a configuration dialog appears. Set the desired Color, Text Height, and Format string, then click OK.

### Step 3: Select Entities
**Command Line:** `Select entities`
**Action:** Click on one or more existing MasterPanel entities in the model that you wish to clone. Press Enter to confirm selection.

### Step 4: Define Location
**Command Line:** `Pick insertion point`
**Action:** Click in the Model Space to specify where the cloned panel group should be placed.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Format | Text | @(Number) | Defines the data format string to extract and display properties (e.g., @(Name), @(Length), @(EAN)) from the source MasterPanel. |
| Color | Number | 40 | Sets the AutoCAD Color Index (0-255) for the solid body of the cloned panel. |
| Text Color | Number | 7 | Sets the AutoCAD Color Index (0-255) for the text label. |
| Text Height | Number | 300 (mm) | Defines the physical height of the text label. Set to 0 to use the DimStyle default height. |
| DimStyle | Dropdown | *(Sorted List)* | Specifies the Dimension Style to apply to the text label (controls font and default height). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific custom commands to the right-click context menu. |

## Settings Files
- **Filename:** None
- **Location:** N/A
- **Purpose:** N/A

## Tips
- **Moving the Clone:** You can use the grip points to move the cloned panel to a new location. The text label moves with it.
- **Dynamic Labels:** Change the "Format" property in the Properties Palette to instantly update the label text without re-inserting the script (e.g., switch from `@(Number)` to `@(Length)`).
- **Text Styling:** If you want the text height to match your standard dimension settings automatically, set "Text Height" to `0` and ensure the correct "DimStyle" is selected.

## FAQ
- **Q: What happens if I delete the original MasterPanel that was cloned?**
  - A: The script detects the missing reference during a recalculation, displays the error "invalid masterpanel reference", and automatically erases the clone instance to prevent data corruption.
- **Q: Why did the clone skip one of the panels I selected?**
  - A: The script checks if a MasterPanel is already referenced by another existing clone. If a duplicate is found, a warning "Masterpanel [Number] already cloned" is issued, and that specific panel is skipped during the insertion process.