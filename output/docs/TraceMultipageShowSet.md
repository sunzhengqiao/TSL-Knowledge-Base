# TraceMultipageShowSet

## Overview
This script creates a diagnostic report for a selected hsbCAD MultiPage drawing. It lists all entities contained in the DefineSet and ShowSets and draws graphical leader lines connecting the text list to the actual elements in the model views.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for Shop Drawing environments. |
| Paper Space | Yes | The script functions correctly within Paper Space layouts. |
| Shop Drawing | Yes | This is the primary environment intended for use. |

## Prerequisites
- **Required Entities**: A valid hsbCAD MultiPage object (e.g., a wall or floor layout) must exist in the drawing.
- **Minimum beam count**: 0
- **Required settings files**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `TraceMultipageShowSet.mcr`

### Step 2: Select MultiPage Entity
```
Command Line: Select MultiPage:
Action: Click on the MultiPage drawing object you wish to analyze.
```

### Step 3: Specify Insertion Point
```
Command Line: Insertion point:
Action: Click in the drawing (Paper Space) to place the top-left corner of the diagnostic text list.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| _Entity | PropEntity | Empty | The specific MultiPage drawing object to analyze. Change this to switch the report to a different drawing layout. |
| _Pt0 | Point3d | User Clicked | The screen location where the top of the diagnostic text report is placed. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | This script does not add custom context menu items. Standard TSL options (Recalculate, Erase) apply. |

## Settings Files
- **Filename**: None specific
- **Location**: N/A
- **Purpose**: N/A (Uses standard hsbCAD utilities only)

## Tips
- **Audit Tool**: Use this script when you need to understand which specific scripts or entities are generating a particular view or annotation on your production drawings.
- **First View Detail**: Note that graphical leader lines (connectors) are only drawn for entities in the **first view** (View 0). Subsequent views will list the entities textually but will not have the connecting lines drawn to them.
- **Moving the Report**: If the text covers your drawing, simply select the script instance and change the `_Pt0` property in the Properties Palette to move the entire report block.

## FAQ
- **Q: I get an error "invalid selection set" when inserting.**
  A: Ensure you click on a valid hsbCAD MultiPage object during the selection prompt. This script cannot analyze standard AutoCAD entities or individual beams; it requires the parent MultiPage container.

- **Q: Can I update the report if the drawing changes?**
  A: Yes. Select the script instance and click "Recalculate" (or right-click and select Recalculate) to refresh the entity list based on the current state of the MultiPage.

- **Q: Why are there lines pointing to objects in one view but not in others?**
  A: By design, the script only calculates and draws graphical leader lines (extents and connectors) for the first view to maintain performance and drawing clarity. Other views are listed textually.