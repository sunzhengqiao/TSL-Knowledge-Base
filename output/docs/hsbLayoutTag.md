# hsbLayoutTag.mcr

## Overview
This script creates collision-free tags and labels in PaperSpace that display properties of structural elements located in ModelSpace (such as beams, panels, and sheets). It automatically calculates label positions to avoid overlapping existing drawing details.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Partial | The script reads entities from ModelSpace but is inserted and managed in PaperSpace. |
| Paper Space | Yes | The script must be inserted on a Layout containing a Viewport. |
| Shop Drawing | Yes | Intended for creating part lists and dimension tags on production drawings. |

## Prerequisites
- **Required Entities**: A Viewport existing in the current PaperSpace Layout.
- **Minimum Beam Count**: 0 (can be used with Panels, Sheets, or generic entities).
- **Required Settings**: None required.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbLayoutTag.mcr` from the list.

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport frame in the layout that displays the model elements you want to tag.
```

### Step 3: Pick Origin Point
```
Command Line: Pick a point outside of paperspace
Action: Click a location in the PaperSpace to define the script's origin/insertion point.
```

### Step 4: Select Entities to Tag
After insertion, the script waits for you to define what to label.
```
Action: Right-click the script instance and navigate to "Select..." options (e.g., Select Beam(s), Select Panel(s)).
The script will temporarily switch to ModelSpace. Select your entities and press Enter.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Format** | Text | `@(Posnum) @(SolidLength)` | Defines the text displayed on the tag. Use tokens like `@(Width)`, `@(Length)`, or `@(Label)` to pull entity properties. Flags like `:RL1` can be added to round numbers (e.g., `@(Width:RL1)` for 1 decimal). |
| **Dimstyle** | Dropdown | `_DimStyles.sorted()` | Selects the CAD Dimension Style to control font, color, and layer settings for the tag. |
| **Text Height** | Number | `0` | Sets the height of the text. A value of `0` uses the height defined in the selected Dimstyle. |
| **Orientation** | Dropdown | `byEntity` | Controls the rotation of the tag. <br>• `byEntity`: Rotates to match the element's angle.<br>• `Horizontal`: Forces horizontal alignment.<br>• `Vertical`: Forces vertical alignment. |
| **Style** | Dropdown | `Text only` | Determines the visual appearance of the tag. Options include: `Text only`, `Text + Leader`, `Border`, `Border+Leader`, `Filled Frame`, or `Filled Frame+Leader`. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add Viewport** | Allows you to link an additional viewport to the script instance if one was missed during insertion. |
| **Select Entities** | Switches to ModelSpace to select any generic entities (Lines, Arcs, etc.). |
| **Select Beam(s)** | Switches to ModelSpace to select structural beams. (Also triggered by double-clicking the script). |
| **Select Panel(s)** | Switches to ModelSpace to select structural panels (Sip entities). |
| **Select Sheets** | Prompts for a zone string (e.g., "1;2"), switches to ModelSpace, and selects sheets matching those zones. |
| **Select TSL's** | Switches to ModelSpace to select other TSL script instances (Element entities). |
| **Remove selection** | Clears all currently selected entities from the script. |
| **Clear Shadow** | Clears the internal "collision map," allowing tags to be placed in areas that were previously occupied. |
| **Set Format...** | Opens a searchable list of available entity properties to help build the Format string correctly. |

## Settings Files
- **Filename**: None used by this script.

## Tips
- **Finding Properties**: If you don't know the exact name of a property (e.g., is it `Length` or `SolidLength`?), use the **Set Format...** context menu option. It lists all available properties for the selected element type.
- **Collision Detection**: If tags appear far away or seem "stuck," try using the **Clear Shadow** command. This resets the area the script considers "occupied."
- **Standard Text**: Set **Text Height** to `0` and define the size in your **Dimstyle** to ensure all annotations in your drawing update consistently when styles change.

## FAQ
- **Q: Can I tag walls and panels at the same time?**
  - A: No, you must run the specific context command for each type (e.g., run "Select Beam(s)" for walls, then "Select Panel(s)" for panels) one after another. The script will combine them into the layout.
- **Q: My tags are overlapping each other.**
  - A: The script tries to avoid collisions, but if you manually move the script instance or drastically change text sizes, overlaps might occur. Use **Clear Shadow** and trigger a recalculation (save/reload or toggle a property) to force a re-layout.
- **Q: What does the "RL1" flag do in the Format?**
  - A: It rounds the number to 1 decimal place according to your local Windows settings (e.g., a length of 1200.45 becomes 1200.5 or 1200,5 depending on region).