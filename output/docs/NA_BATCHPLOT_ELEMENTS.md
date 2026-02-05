# NA_BATCHPLOT_ELEMENTS

## Overview
Automates the batch creation of PDF shop drawings for selected wall elements by cycling through them on a specified Paper Space layout. This allows users to generate a complete set of fabrication drawings with custom naming conventions without manually plotting each wall.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used to select the wall elements to be plotted. |
| Paper Space | Yes | The script automatically switches to this space to perform the plotting using the specified layout tab. |
| Shop Drawing | Yes | The primary output is PDF files intended for fabrication or documentation. |

## Prerequisites
- **Required entities**: hsbCAD Elements (Walls) must exist in the drawing.
- **Minimum beam count**: 0.
- **Required settings**: At least one Paper Space Layout tab (e.g., a template with a title block) must exist in the drawing.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `NA_BATCHPLOT_ELEMENTS.mcr` from the file browser.

### Step 2: Configure Properties
Upon insertion, the **Properties** palette (OPM) will display the script settings.
- Set the **PDF Name Format** (e.g., `@(ElementNumber)`).
- Select the **Layout Tab Name** from the dropdown (this chooses the border/title block style).
- Set the **Take only walls with openings** filter if needed.

### Step 3: Select Walls
```
Command Line: Select walls to print:
Action: Click on the desired wall elements in Model Space. Press Enter or Space to confirm selection.
```

### Step 4: Automatic Processing
The script will now automatically:
1. Switch to the selected Layout tab.
2. Zoom to each selected wall.
3. Plot the view to a PDF.
4. Save the PDF to the current drawing's folder.

### Step 5: Completion
Once processing is finished, the script instance erases itself from the drawing. Check the folder where your DWG is saved to find the generated PDF files.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| PDF Name Format | Text | `@(ElementNumber)` | Defines the filename for the output PDF. You can use tokens like `@(ElementNumber)`, `@(Name)`, or `@(Length)` to ensure unique names. |
| Layout Tab Name | Dropdown | *First available* | Selects the specific Paper Space Layout tab to use as the drawing frame/template. The list is populated automatically from your drawing's tabs. |
| Take only walls with openings | Dropdown | No | If set to "Yes", the script will skip plotting any wall that does not contain windows or doors. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not install a persistent command instance. It runs once and erases itself. |

## Settings Files
- **Filename**: *None*
- **Location**: *N/A*
- **Purpose**: *N/A* (Script relies on standard drawing Layouts).

## Tips
- **Unique Filenames**: Always use dynamic tokens like `@(ElementNumber)` in the PDF Name Format to prevent files from overwriting each other.
- **Re-running**: Since the script deletes itself after running, simply execute `TSLINSERT` again if you need to plot another batch with different settings.
- **Layout Setup**: Ensure your chosen Layout tab has a viewport setup that is compatible with `Hsb_Lisp_setViewport` (usually a standard hsbCAD viewport configuration).
- **Filtering**: Use the "Take only walls with openings" option to quickly generate drawings only for complex wall panels that require manufacturing details, skipping solid sections.

## FAQ
- **Q: Where are the PDF files saved?**
  A: They are saved in the same directory as the current DWG file.
- **Q: Why did the script object disappear after I ran it?**
  A: This is intended behavior. The script acts as a "command" tool that erases itself (`eraseInstance`) immediately after generating the plots to keep your drawing clean.
- **Q: What happens if two walls have the same Element Number?**
  A: If your naming format relies only on Element Number and they are identical, the second PDF will overwrite the first one. Include additional tokens like `@(Length)` or `@(Name)` to ensure unique filenames.