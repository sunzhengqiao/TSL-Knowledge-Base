# HVAC-Tag.mcr

## Overview
This script inserts a dynamic annotation tag linked to an HVAC system (e.g., ducts). It displays formatted text based on the properties of the referenced HVAC elements and automatically updates if the geometry moves. It includes a flow arrow and an optional guide line.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in 3D model space. |
| Paper Space | No | Not supported for layouts. |
| Shop Drawing | No | Not supported for shop drawings. |

## Prerequisites
- **Required Entities**: An existing HVAC System entity in the model (specifically an entity containing 'HVAC Collection' map data).
- **Required Settings File**: `HVAC.xml` located in your company folder `<company>\TSL\Settings`.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or select from Catalog/Browser) → Select `HVAC-Tag.mcr`

### Step 2: Configure Format (Optional)
Upon launch, the Properties Palette may open automatically. You can pre-configure the **Format** string here, or modify it after insertion.
*   *Action:* Enter the desired text format in the Properties Palette (e.g., `@(Name)`).

### Step 3: Select HVAC System
```
Command Line: Select an HVAC system
Action: Click on the HVAC duct or system object you wish to tag.
```
*   *Note:* If you select an invalid object (not an HVAC system), the script will cancel.

### Step 4: Select Insertion Point
```
Command Line: Select point
Action: Click in the model space to place the tag.
```
*   *Result:* The tag instance is created. The script automatically finds the closest point on the duct, aligns the arrow, and draws the text label.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Format | String | `@(Name)` | Defines the text displayed on the tag. You can use dynamic placeholders for various properties.<br><br>**Syntax Examples:**<br>- `@(Label)`: Shows the Label property.<br>- `@(Label:L2)`: Shows the first 2 characters of the Label.<br>- `@(Width:RL1)`: Shows Width rounded to 1 decimal.<br>- `@(Name) @(Width)`: Combines Name and Width with a space.<br><br>**Modifiers:**<br>- `L`: Left characters (e.g., `:L5`)<br>- `R`: Right characters<br>- `#`: Round number (e.g., `:#0`)<br>- `T`: Token/Split (e.g., `:T1` gets the second word) |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Set Format Expression | Opens an interactive list of available properties in the command line history. Type the index number of the property you want to add or remove from the Format string. |

## Settings Files
- **Filename**: `HVAC.xml`
- **Location**: `<company>\TSL\Settings`
- **Purpose**: Defines default appearance settings, including:
    - Text Height
    - Arrow/Symbol Size
    - Offset behavior (whether the tag snaps to the duct or stays where clicked)
    - Colors and Transparency

## Tips
- **Building Format Strings**: Instead of typing complex syntax manually, use the **Set Format Expression** right-click option. It lists all available data fields (like Flow, Width, Height) and lets you add them by number.
- **Automatic Snapping**: If the tag insertion point "jumps" to the duct centerline after you click, the `SymbolOffset` setting in your XML is enabled.
- **Guide Lines**: If you place the tag far away from the duct, a guide line (leader line) will automatically draw connecting the text to the duct arrow.
- **Moving Tags**: Use the grip point to drag the tag. If you drag it closer to a different duct section, it will automatically snap and update to reference that new section.

## FAQ
- **Q: How do I show the duct width in the tag?**
  A: Select the tag, open the Properties Palette, and change the Format to `@(Width)`.
- **Q: The tag disappeared. What happened?**
  A: The tag relies on the linked HVAC entity. If the original HVAC duct was deleted or erased from the drawing, the tag will also be removed.
- **Q: How do I round the dimensions shown in the text?**
  A: Use the `#` or `RL` modifiers in the Format string. For example, use `@(Width:#0)` to round to the nearest whole number.