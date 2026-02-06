# hsbPivotSchedule

## Overview
Generates flexible schedule tables (BOMs or lists) that aggregate and display data for timber construction entities like beams, walls, or panels, with support for grouping, totals, and custom formatting.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Lists entities based on model content or selection sets. |
| Paper Space | Yes | Supports ACA and hsbCAD viewports to list elements visible in specific views. |
| Shop Drawing | No | Can list Shopdrawing entities, but is not a generation script itself. |

## Prerequisites
- **Required Entities:** GenBeams, Elements, Sheets, Panels, Walls, Trusses, TslInstances, or Tool Entities must exist in the drawing.
- **Minimum Count:** 0 (The table may be empty if no entities match the filter).
- **Required Settings:** None (uses standard hsbCAD properties).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `hsbPivotSchedule.mcr` from the list and click OK.

### Step 2: Place Schedule
Action: Click a location in your drawing (Model Space or on a Layout) to place the schedule table.

### Step 3: Configure Content
Action: With the schedule selected, open the **Properties Palette (Ctrl+1)**. Adjust the **Type**, **Mode**, and **Format** properties to define what data is shown.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Configuration | Text | - | Name of a saved configuration preset to quickly switch table setups. |
| Type | Dropdown | - | Filters the category of elements to list (e.g., Wall CLT, Masterpanel, Beam, Sheet, Element, Shopdrawing). |
| Mode | Dropdown | - | Choose "for each Instance" to list every item separately, or "as Collection" to group identical items together. |
| Painter | Dropdown | <Disabled> | Apply a specific filter (Painter) from the catalog to select entities based on custom criteria. |
| Header | Text | @(ProjectName) | The title text displayed at the top of the table. Supports variables like `@(Date)`. |
| Group | Text | @(ProjectName) | The property used to group rows in the table (e.g., `@(PosNum)`, `@(Material)`). |
| Value | Text | @(PosNum) | The data displayed in the grid cells (e.g., `@(Length)`, `@(Width)`, `@(Volume)`). |
| Totals | Text | @(Quantity) | The calculation for the summary line (e.g., `@(Quantity)`, `@(Weight)`). |
| Columns | Number | 5 | Sets the maximum number of columns before the list wraps to the next row. Set to 0 for no limit. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add/Remove Format Header | Opens a dialog to quickly modify the Header text format. |
| Add/Remove Format Group | Opens a dialog to modify the Grouping property. |
| Add/Remove Format Value | Opens a dialog to modify the main grid data format. |
| Add/Remove Format Total | Opens a dialog to modify the Totals calculation format. |
| Add Entities | Prompts you to select additional entities from the drawing to include in the existing schedule. |
| Remove Entities | Prompts you to select entities currently in the schedule to remove them. |

## Settings Files
- **Filename:** None specific.
- **Location:** N/A
- **Purpose:** This script relies on the standard hsbCAD database and does not require external XML settings files for basic operation.

## Tips
- **Use Variables:** Use the `@()` syntax to pull dynamic data. For example, use `@(Length)` to display beam lengths or `@(Material)` for material names.
- **Formatting Collection Mode:** When using "as Collection" for the Mode, ensure your "Group" and "Value" fields are set correctly so items aggregate as expected (e.g., Group by `@(PosNum)` to count total pieces per position).
- **Performance:** Calculating `@(Weight)` or `@(Volume)` for large projects can take time. Use these only when necessary.
- **Layout Control:** If your table is too wide for your sheet, lower the "Columns" property to force the table to wrap into multiple vertical sections.

## FAQ
- **Q: Why is my schedule table empty?**
  **A:** Check the **Type** property to ensure it matches the entities in your model (e.g., if you selected "Wall CLT" but only have "Beams", the table will be empty). Also verify the **Painter** is not set to a filter that excludes everything.
- **Q: How do I show multiple data columns (e.g., Length and Width)?**
  **A:** In the **Value** property, you can combine variables with text. For example: `@(Length) x @(Width)`.
- **Q: What does the "0 = no limit" mean for Columns?**
  **A:** It allows the table to grow indefinitely to the right. This is useful for model space but usually requires a manual limit (e.g., 5 or 10) to fit within a title block on Paper Space.