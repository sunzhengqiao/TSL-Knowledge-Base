# hsbViewCoordinateDimension.mcr

## Overview
This script automatically generates coordinate dimensions (labels) for TSL components (connectors, addons) within 2D production drawings. It displays elevation or position data relative to a reference zone or element, with options for custom formatting and alignment.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Works with ShopDrawViews or Section2d entities. |
| Paper Space | Yes | Works with Layout Viewports. |
| Shop Drawing | Yes | Designed for detailing views. |

## Prerequisites
- **Required Entities**: A valid view context is required. This can be a `ShopDrawView` or `Section2d` in Model Space, or a `Viewport` in a Layout tab.
- **Minimum Beam Count**: 0 (It scans attached TSLs on existing elements).
- **Required Settings**: Optional `hsbViewCoordinateDimension.xml` for advanced filter rules.

## Usage Steps

### Step 1: Launch Script
Execute the command `TSLINSERT` (or `hsbTslInsert`) and select `hsbViewCoordinateDimension.mcr` from the catalog.

### Step 2: Select View Context
The script prompts for input based on your current workspace:

**If in a Layout Tab (Paper Space):**
```
Command Line: |Select a viewport|
Action: Click on the viewport border where you want to generate dimensions.
```

**If in Model Space:**
```
Command Line: |Select Section2d|
Action: 
1. The script attempts to automatically detect a ShopDrawView. 
2. If none is found, click on a Section2d entity to define the view.
```

### Step 3: Configure Properties
Once inserted, select the script instance and open the **Properties Palette** (Ctrl+1) to adjust labels, references, and filters.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Format** | Text | Empty | Defines the text content. Use `@(X)`, `@(Y)`, or `@(Z)` to display coordinates (e.g., "Level: @(Z)"). Separate multiple lines with `\P`. |
| **Filter Rule** | Dropdown | \|<Disabled>\| | Specifies a filter rule to limit which TSLs are dimensioned. Rules are loaded from the external XML settings file. |
| **Reference** | Dropdown | \|byElement\| | Sets the zero point for the dimension. Choose "byElement" or a specific "Zone" (-5 to 5). If the zone is invalid, it falls back to Zone 0 or the element outline. |
| **Alignment** | Dropdown | \|Horizontal Local\| | Defines orientation. "Local" rotates with the view; "Global" stays fixed to world coordinates. Options include Horizontal/Vertical variants. |
| **Text Height** | Number | 0 | Defines the text size. Set to `0` to use the height defined by the Dimstyle. |
| **Dimstyle** | Dropdown | Sorted DimStyles | Selects the CAD dimension style to control arrows, color, and font. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Export Default Settings** | Writes the current configuration map to an XML file (`hsbViewCoordinateDimension.xml`) located in your company settings folder. |

## Settings Files
- **Filename**: `hsbViewCoordinateDimension.xml`
- **Location**: `<company>\TSL\Settings` or `<install>\Content\General\TSL\Settings`
- **Purpose**: Stores custom filter rules. Allows you to define complex logic to include or exclude specific TSLs based on their properties or names.

## Tips
- **Snapping**: If using "Local" alignment and the dimension point is not on a solid body, the script will automatically snap the dimension leader to the nearest reference zone outline. This keeps drawings clean.
- **Formatting**: You can combine static text with attributes. For example, enter `Elev: @(Z) mm` in the **Format** field to display "Elev: 2400 mm".
- **Global vs Local**: Use **Global** alignment if you want text to remain perfectly horizontal regardless of the view angle (common for elevation labels). Use **Local** for text aligned with specific structural members.

## FAQ
- **Q: My dimensions are showing 0.00. How do I fix this?**
  A: Check your **Reference** property. If it is set to a Zone that does not exist in the current view, the value may calculate incorrectly. Try setting it to `|byElement|` or `|Zone| 0`.

- **Q: Can I dimension only specific connectors (e.g., only screws)?**
  A: Yes. Create a filter rule in the `hsbViewCoordinateDimension.xml` settings file (or export defaults and edit it), then select that rule in the **Filter Rule** property.

- **Q: The text is too small to read.**
  A: Set the **Text Height** property to a specific value (e.g., `2.5`) instead of `0`. Ensure your units (mm/inches) match your drawing standards.