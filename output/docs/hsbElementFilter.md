# hsbElementFilter.mcr

## Overview
This script filters construction elements (such as Walls, Roofs, or Floors) based on specific categories defined in your project database. It allows you to automatically include only specific elements or exclude others, streamlining the selection process for detailing or exporting.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used for interactive selection of elements. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | Not applicable. |

## Prerequisites
- **Required Entities**: Element entities (e.g., walls, roofs, floors) must exist in the drawing.
- **Required Settings**: A valid dictionary named `ElementTypes` must exist in the hsbCAD database containing your project's element category definitions.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbElementFilter.mcr` from the list.

### Step 2: Configure Properties
```
Command Line: 
Action: The "Properties" dialog box appears automatically.
```
- Set **Enabled** to `True` to activate the filter.
- Choose **Operation element filter**:
  - Select `Exclude` to remove elements that match your criteria.
  - Select `Include` to keep *only* elements that match your criteria.
- Select **Filter element types** from the dropdown list (populated from your database settings, e.g., "Ext_Walls").

### Step 3: Select Elements
```
Command Line: Select elements
Action: Click on the elements in your model you wish to process, then press Enter.
```
*Note: If used within a Map (processing script), this step is skipped automatically.*

### Step 4: Execution
```
Command Line: 
Action: The script processes the selection and removes itself from the drawing. The filtered set of elements is passed to the next step.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Enabled | dropdown | True | Activates or deactivates the filter. If False, no filtering occurs. |
| Operation element filter | dropdown | Exclude | Determines the logic: "Exclude" removes matching items; "Include" keeps only matching items. |
| Filter element types | dropdown | None | The specific category to filter by (e.g., Exterior Walls). Options are dynamic based on your project database. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are available for this script. |

## Settings Files
- **Filename**: N/A (Uses internal Database Dictionary)
- **Location**: hsbCAD Database (`ElementTypes` dictionary)
- **Purpose**: Stores the mapping between filter names (e.g., "Ext_Walls") and the actual element codes they represent.

## Tips
- **Database Setup**: If the "Filter element types" dropdown only shows "None", check with your BIM Manager to ensure the `ElementTypes` dictionary is correctly populated in your project database.
- **Map Usage**: When used inside an hsbCAD Map, this script automatically filters the elements coming from the previous step without needing you to manually select anything.
- **Script Behavior**: The script instance erases itself immediately after running to keep your drawing clean. It acts as a transient processor.

## FAQ
- **Q: Why did the script disappear immediately after I inserted it?**
  - A: This is normal behavior. The script performs its filtering function and then self-destructs to avoid cluttering the drawing.
- **Q: I selected "Include" but nothing happened.**
  - A: Ensure that the elements you selected actually match the codes defined in the "Filter element types" category. If the codes do not match, the result of an "Include" operation will be an empty set.
- **Q: Can I use this to filter beams?**
  - A: No, this script is specifically designed for hsbCAD Elements (Walls, Roofs, Floors). It will not function on standard GenBeams.