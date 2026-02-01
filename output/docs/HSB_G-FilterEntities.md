# HSB_G-FilterEntities.mcr

## Overview
This script allows you to filter a selection of CAD entities in Model Space based on custom property data. It helps you quickly isolate or exclude specific items (e.g., specific materials, sizes, or naming conventions) from a larger selection set.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary environment for selecting and filtering entities. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Script:** The script `HSB_G-ContentFormat.mcr` must be loaded in the drawing to retrieve property values.
- **Selection:** You must have entities available to select during the script execution.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-FilterEntities.mcr`

### Step 2: Configure Filter Criteria
```
Action: A properties dialog appears automatically upon insertion.
```
1.  **Operation Filter:** Choose **Include** to keep matching items or **Exclude** to remove them.
2.  **Operation Comparison:** Choose **All** (AND logic) if entities must meet every condition, or **Any** (OR logic) if they only need to meet one condition.
3.  **Custom Properties:** Enter up to 4 Property/Value pairs to define your filter.
4.  Click **OK** to confirm settings.

### Step 3: Select Entities
```
Command Line: Select entities to filter
Action: Click the entities or use a window selection in the model, then press Enter.
```
*Result:* The script processes the selection. The filtered set is passed along or reported, and the script instance erases itself.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Operation filter | dropdown | Exclude | Determines if matching entities are kept (**Include**) or removed (**Exclude**). |
| Operation comparison | dropdown | All | Sets the logic for multiple filters: **All** (AND) requires every condition to be true; **Any** (OR) requires at least one to be true. |
| Custom Propertie 1 | text | [Empty] | The name of the property to check (e.g., `Material`, `ElementNumber`). |
| Custom Value 1 | text | [Empty] | The value to match. Use `*` as a wildcard or `;` to separate multiple values. |
| Custom Propertie 2 | text | [Empty] | The name of the second property to check. |
| Custom Value 2 | text | [Empty] | The value to match for the second property. |
| Custom Propertie 3 | text | [Empty] | The name of the third property to check. |
| Custom Value 3 | text | [Empty] | The value to match for the third property. |
| Custom Propertie 4 | text | [Empty] | The name of the fourth property to check. |
| Custom Value 4 | text | [Empty] | The value to match for the fourth property. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific context menu actions. It functions primarily via the Properties Palette during insertion. |

## Settings Files
- **Dependency:** `HSB_G-ContentFormat.mcr`
- **Purpose:** This script is required to read and format the property data from the selected entities.

## Tips
- **Wildcards:** You can use `*` in the Value field to match partial text (e.g., `C24*` will find `C24-GradeA`).
- **Multiple Values:** You can check against several values at once by separating them with a semicolon `;` (e.g., `Wood;Steel`).
- **Finding Property Names:** If you don't know the exact name of a property, check the documentation or output of the `HSB_G-ContentFormat` script.
- **Save Presets:** If you use a filter frequently, save your configured script instance to a Catalog entry. This allows you to run the filter instantly later using an execute key.

## FAQ
- **Q: Why did the script fail or filter nothing?**
  A: Ensure that `HSB_G-ContentFormat.mcr` is loaded in your drawing. Also, verify that the Property Names (e.g., `Material`) actually exist on the entities you selected.
- **Q: What is the difference between 'All' and 'Any'?**
  A: If you set two conditions (e.g., Material="Wood" and Name="Beam*"), **All** will only find entities that are Wood AND start with Beam. **Any** will find entities that are Wood OR start with Beam (or both).
- **Q: Can I filter by properties that aren't standard hsbCAD properties?**
  A: Yes, as long as the property exists on the entity and the `HSB_G-ContentFormat` script can read it, you can reference it (e.g., `(PropertySet.CustomData)`).