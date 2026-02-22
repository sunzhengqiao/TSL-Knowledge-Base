# hsbLayoutTag

## Overview

| Property | Value |
|----------|-------|
| **Script Name** | hsbLayoutTag |
| **Type** | O (Object) |
| **Version** | 1.9 |
| **Category** | Shop Drawing / Tagging |
| **Author** | thorsten.huck@hsbcad.com |
| **Last Updated** | 13 Dec 2018 |

## Description

This TSL creates collision-free tags in Paper Space that reference Model Space entities. Tags are automatically positioned to avoid overlapping with each other, providing clear and readable annotations for shop drawings. The script looks through viewports to display properties of structural elements such as beams, panels, sheets, and other TSL instances.

## Usage Environment

| Environment | Supported | Notes |
|-------------|-----------|-------|
| Model Space | Partial | Entities are read from Model Space but the script is managed in Paper Space |
| Paper Space | Yes | Primary environment - must be inserted on a Layout containing a Viewport |
| Shop Drawing | Yes | Intended for creating part lists and dimension tags on production drawings |

## Prerequisites

- **Required Entities**: A Viewport existing in the current PaperSpace Layout
- **Minimum Beam Count**: 0 (can be used with Panels, Sheets, TSLs, or generic entities)
- **Required Settings**: None required

## Usage Workflow

### Step 1: Launch Script
Run `TSLINSERT` and select `hsbLayoutTag.mcr` from the script list, or enter the command directly.

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport frame that displays the model elements you want to tag.
```

### Step 3: Pick Insertion Point
```
Command Line: Pick a point outside of paperspace
Action: Click a location in Paper Space to define the script's origin/insertion point.
```

### Step 4: Configure Properties
Set the format expression and display options in the dialog or Properties Palette (OPM).

### Step 5: Select Entities to Tag
After insertion, select entities using one of these methods:
- **Double-click** the instance to automatically switch to Model Space and select beams
- **Right-click** to access the context menu with various selection options

## Properties Panel Parameters

### Format Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Format** | String | `@(Posnum) @(SolidLength)` | Defines the composed value format using variable expressions |

### Format Expression Syntax

The Format property supports variable modifiers:

| Modifier | Description | Example |
|----------|-------------|---------|
| `@(Label)` | Basic property reference | `@(Posnum)` |
| `@(Label:L2)` | First N characters from left | `@(Name:L3)` |
| `@(Label:T1)` | Token at index (semicolon delimiter) | `@(Code:T0)` |
| `@(Width:RL1)` | Round with N decimals using local settings | `@(Length:RL2)` |
| `R` | Right: extract characters from right | |
| `L` | Left: extract characters from left | |
| `S` | SubString: extract portion of string | |
| `T` | Tokenizer: split by delimiter | |
| `#` | Round number (trailing zeros removed) | |
| `RL` | Round Local: using regional settings | |

**Format Examples:**
- `@(Label)@(SubLabel)` - Concatenate two properties
- `@(Label:L2)` - First two characters of Label
- `@(Label:T1)` - Second part if value is separated by blanks (e.g., 'EG AW 2' returns 'AW')
- `@(Width:RL1)` - Width rounded to 1 decimal place

### Display Category

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| **Dimstyle** | String | (First available) | List of dimension styles | Defines the dimension style for text appearance |
| **Text Height** | Double | 0 | Any positive value | Text height (0 = use Dimstyle setting) |
| **Orientation** | String | byEntity | byEntity / Horizontal / Vertical | Text orientation relative to entity or viewport |
| **Style** | String | Text only | See options below | Tag visual style |

### Style Options

| Option | Description |
|--------|-------------|
| **Text only** | Plain text tag without frame or leader |
| **Text + Leader** | Text with leader line pointing to entity |
| **Border** | Text with rectangular border |
| **Border+Leader** | Text with border and leader line |
| **Filled Frame** | Text with filled background frame |
| **Filled Frame+Leader** | Text with filled frame and leader line |

## Context Menu Options

Right-click on the hsbLayoutTag instance to access:

| Command | Description |
|---------|-------------|
| **Add Viewport** | Add or change the associated viewport |
| **Select Entities** | Switch to Model Space and select any entity type |
| **Select Beam(s)** | Switch to Model Space and select beams only (default double-click action) |
| **Select Panel(s)** | Switch to Model Space and select SIP panels only |
| **Select Sheets** | Select sheets with optional zone filtering (see below) |
| **Select TSL's** | Select TSL instances by script type (see below) |
| **Remove entities** | Remove selected entities from the tag list |
| **Set Format Expression** | Interactive property selection from available entity variables |
| **Set Leader Offset** | Adjust X and Y offset for leader lines (when Style includes leader) |

## Sheet Zone Filtering

When using **Select Sheets**, specify zones to filter:

- Enter zone numbers separated by semicolons (e.g., `1;2;-1`)
- Zones range from -5 to 5 (excluding 0)
- Press Enter without input to select from all zones

## TSL Selection

When using **Select TSL's**:

1. A numbered list of available TSL script names is displayed in the command line report
2. Enter indices separated by semicolons to filter by script type
3. Press Enter without input to select all TSL types
4. Note: Scripts starting with `sd_` are automatically excluded from the list

## Collision Avoidance Algorithm

The script automatically positions tags to avoid overlapping:

1. Tags are ordered by visible area within the viewport (smaller entities tagged first)
2. Each tag starts at its default location (center of entity shadow)
3. The algorithm attempts positions in a spiral pattern (up to 160 positions)
4. Tags with manually set positions (via grip handles) maintain their fixed location
5. A protected profile tracks occupied areas to prevent overlap

## Tips and Best Practices

1. **Viewport Association**: Always associate the tag with the correct viewport containing your entities
2. **Format Variables**: Use the context menu "Set Format Expression" to see available properties for selected entity types
3. **Leader Style**: Use leader styles when tags need to clearly indicate which entity they reference
4. **Text Height**: Set to 0 to inherit from the dimension style for consistency across drawings
5. **Multiple Selections**: You can add entities in multiple selection operations - they accumulate
6. **Performance**: Large numbers of tagged entities may slow down recalculation; consider splitting across multiple viewports
7. **Zone Filtering**: Use zone filtering when selecting sheets to limit tags to specific layers/zones
8. **Finding Properties**: If unsure of property names, use **Set Format Expression** to list all available properties
9. **Standard Text**: Set **Text Height** to 0 and define size in your **Dimstyle** for consistent annotations

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.9 | 13 Dec 2018 | Removed 'decimals' property; decimal control now via RLxx format flag; property sets supported; new context command for panels |
| 1.8 | 08 Nov 2018 | Bugfix |
| 1.7 | 08 Nov 2018 | Property sets supported |
| 1.6 | 08 Nov 2018 | New context command for panels; format description enhanced |
| 1.5 | 13 Aug 2018 | New context command to add TSLs |
| 1.4 | 04 Jul 2018 | Default double-click selection changed to beams |
| 1.3 | 05 Jun 2018 | Decimal places fixed |
| 1.2 | 30 Apr 2018 | New selection commands to filter beams or sheets |
| 1.1 | 30 Apr 2018 | Bugfix for double detection |
| 1.0 | 26 Apr 2018 | Initial release |

## FAQ

**Q: Can I tag walls and panels at the same time?**
A: Yes, you can run multiple selection commands sequentially (e.g., "Select Beam(s)" then "Select Panel(s)"). The script accumulates all selected entities.

**Q: My tags are overlapping each other.**
A: The script tries to avoid collisions, but if you manually move the script instance or change text sizes drastically, overlaps might occur. Delete and re-insert the script, or use smaller text height.

**Q: What does the "RL1" flag do in the Format?**
A: It rounds the number to 1 decimal place according to your local Windows regional settings (e.g., 1200.45 becomes 1200.5 or 1200,5 depending on your region).

**Q: Why don't some entities show tags?**
A: Entities must have visible geometry within the viewport bounds. Entities with zero volume are automatically excluded.

## Related Scripts

- `hsbLayoutDim` - For dimensioning in layout views
- `hsbEntityTag` - For tagging entities in Model Space
- `sd_*` scripts - Shop drawing utilities
