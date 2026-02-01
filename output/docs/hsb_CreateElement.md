# hsb_CreateElement.mcr

## Overview
Wraps selected beams and sheets into a single manufacturing Element (e.g., a roof or floor panel). It calculates the combined outer contour of the selection, assigns a Component Name, and updates the project tree structure.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D entities (GenBeams, Sheets). |
| Paper Space | No | Not applicable for paper space. |
| Shop Drawing | No | This is a model preparation/organization tool. |

## Prerequisites
- **Floor Group**: A valid Floor Group must be set as current in the hsbCAD explorer before running the script.
- **Entities**: At least one beam, sheet, or collection entity must be available to be selected.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or via Toolbar) → Select `hsb_CreateElement.mcr`.

### Step 2: Verify Group Context
**Action**: Ensure the correct Floor Group is active in your hsbCAD tree.
*   If no Floor Group is current, the script will report: "Make a floor group current" and exit.

### Step 3: Configure Properties
**Action**: The Properties palette will appear. You must define the element details before proceeding.
- **Component Name**: Enter a unique ID (e.g., `EL-01`). *This field is mandatory.*
- **SubType**: Enter the category (e.g., `FlatRoof`).
- **DimStyle/Color**: Adjust visual settings for the 3D label if desired.

### Step 4: Select Entities
```
Command Line: Select a set of beams and sheets
Action: Click the structural members (beams, sheets) that belong to this panel. Press Enter to confirm selection.
```

### Step 5: Define Orientation (Conditional)
If the selected entities do not contain a clear coordinate system (e.g., only Sheets were selected, or a generic Collection), you will be prompted to define the plane manually:
```
Command Line: |Get origin point|
Action: Click a point to set the start (0,0,0) of the element.
```
```
Command Line: |Get secound point for x-directionof the element|
Action: Click a second point to define the X-axis direction and slope of the element.
```

### Step 6: Completion
The script automatically calculates the shadow contour, creates the `ElementRoof` entity, assigns the selected members to the new element group, and draws a 3D label. The script instance then erases itself.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Component Name** | text | (empty) | The unique name for the element (e.g., ' Roof-A'). Updates Group Name Part 2. This is mandatory. |
| **SubType** (sNotes) | text | (empty) | The specific type or category of the element (e.g., 'Gable', 'Floor'). Used for filtering in lists. |
| **DimStyle** | dropdown | Current | Determines the text size and appearance of the 3D label in the model. |
| **Color** (nColor) | number | 171 | The color index (0-255) used for the element label/marker. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script uses standard OPM (Object Properties Model) editing. Select the created Element and use the Properties palette to modify names or styles. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies entirely on standard drawing entities and user input; no external settings files are required.

## Tips
- **Naming**: Always fill in the **Component Name**. If left empty, the script will display an error and delete itself.
- **Selection Speed**: You can window select multiple beams and sheets at once.
- **Automatic Orientation**: If you select at least one **GenBeam**, the script will automatically use that beam's coordinate system. You only need to click points if you are selecting Sheets or Collections without a dominant beam direction.
- **Label Visibility**: If the 3D label is too small or large, change the **DimStyle** property in the palette and re-trigger the calculation (if applicable) or modify the text style settings in AutoCAD.

## FAQ
- **Q: Why did the script disappear immediately after I selected the objects?**
  A: This is normal behavior. This is an "Insert-and-Forget" script. Its job is to create the Element and update the database, after which it removes itself from the drawing. The result is the new Element Group in your tree.
- **Q: I got an error "Make a floor group current". What do I do?**
  A: Go to your hsbCAD Project Manager/Tree, right-click on the relevant **Floor** (or Story) level, and select "Set Current" or "Make Active". Then run the script again.
- **Q: How do I change the name of the element later?**
  A: Select the ElementRoof object in the model (or the group in the tree), open the Properties palette (Ctrl+1), and change the **Component Name** value.
- **Q: The script failed to create an element.**
  A: Ensure your selected entities actually form a valid 3D contour with an area larger than 10mm². If the selected items are disjointed or overlapping incorrectly, the contour calculation might fail.