# hsb_AssignEntitiesToLooseGroup

## Overview
This script converts selected beams or sheets into "loose" items within an element, moving them to a specific subgroup for separate delivery or production. It automatically removes associated nailings and handles conflicts with electrical TSLs to ensure correct machining output.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D GenBeam entities. |
| Paper Space | No | Not applicable for 2D views or layouts. |
| Shop Drawing | No | Not intended for shop drawing detailing. |

## Prerequisites
- **Required Entities:** At least one GenBeam (beam or sheet) must exist in the model.
- **Minimum Beam Count:** 1
- **Required Settings:** None (The script relies on internal logic and dependencies like `hsb_ManageLooseGroupEntities`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_AssignEntitiesToLooseGroup.mcr`

### Step 2: Select Entities
```
Command Line: Select beams/sheets to set loose
Action: Click on the beams or sheets you wish to mark as loose, then press Enter.
```

### Step 3: Automatic Processing
Once selected, the script automatically:
1. Moves the items to a "Loose" subgroup within the Element.
2. Applies any Property settings (Name/Color) defined in the Properties Palette.
3. Inserts a management TSL (`hsb_ManageLooseGroupEntities`) on the main element.
4. Erases nail lines located under the selected sheets.
5. Sets intersecting electrical sockets to "No Tool" (display only, no machining).
6. Erases itself from the model upon completion.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| New name for the entity | Text | (Empty) | If a name is entered here, it will overwrite the current catalog name of the selected beam/sheet. This affects the production list and labels. |
| Color to set on the entities | Integer | -1 | Changes the display color of the selected entities. Use `0-255` for specific AutoCAD colors, or leave as `-1` to keep the original color. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific options to the right-click context menu. |

## Settings Files
- **Filename:** N/A
- **Location:** N/A
- **Purpose:** This script does not use external settings files. It interacts directly with element properties and other TSL instances.

## Tips
- **Visual Verification:** Use the "Color to set on the entities" property (e.g., set to Red) before running the script to visually confirm which sheets have been processed as loose.
- **Electrical Sockets:** If you have electrical sockets embedded in the sheets being marked as loose, the script automatically disables the tooling for them ("No Tool") so they won't be cut, but they will remain visible for reference.
- **Nail Removal:** You do not need to manually delete nail lines; the script calculates the projection of the loose sheets and removes any conflicting nail lines automatically.

## FAQ
- **Q: Can I use this script on parts of a wall that are already nailed?**
  - A: Yes. The script will identify and erase the nail lines associated with the selected sheets, converting them from a nailed assembly to a loose pack.
- **Q: Does the script delete the sheets from the model?**
  - A: No. It moves the sheets into a logical subgroup named "Loose" within the element structure. They remain physically visible in the 3D model but are treated differently for production lists and machining.
- **Q: What does the "New name for the entity" property do?**
  - A: It allows you to rename the selected items (e.g., changing a standard sheathing name to "LOOSE SHEETING"). This name update is reflected in your Bills of Materials (BOM) and production labels.