# MetalPartInsert.mcr

## Overview
This script allows you to insert pre-defined metal connector assemblies (such as brackets, plates, or hardware) into the 3D model. It provides a library-based workflow to select specific styles from company folders or the current drawing and place them interactively with dynamic rotation controls.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates entirely in 3D Model Space. |
| Paper Space | No | Not designed for 2D layouts or shop drawings. |
| Shop Drawing | No | Not for generating production views directly. |

## Prerequisites
- **Required Entities:** None (Standalone insertion).
- **Minimum Beam Count:** 0.
- **Required Settings:**
  - Valid DWG library files containing `MetalPartCollectionDef` entries located in your company folders (`<company>\subassembly` or `<company>\assemblies`).
  - `TslUtilities.dll` must be installed in the hsbCAD utilities path.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `MetalPartInsert.mcr`

### Step 2: Select Style Drawing (Library)
*If the script finds external DWG libraries in your company folders:*
```
Dialog: Default Style Drawing
Action: Select the source DWG file that contains the catalog of metal parts you wish to use.
```

### Step 3: Select Specific Part Style
```
Dialog: Style Selection
Action: Browse or search the list to select the specific Metal Part Style (e.g., "Column Base Plate", "Simpson H1") to insert.
```

### Step 4: Place the Part
```
Command Line: Pick insertion point [Rotate/Import]
Action: Click in the model to place the selected metal part.
- The part will appear attached to your cursor.
- Press 'R' for Rotate or 'I' for Import before clicking if needed.
```

### Step 5: Adjust Rotation (Optional)
*If you type 'R' (Rotate) or 'Rotate' at the command line:*
```
Command Line: Rotate keyword base point selection
Action: Pick a point in the model to act as the pivot center (typically on the geometry you are attaching to).
```
```
Command Line: Pick point to rotate [Angle/Basepoint/ReferenceLine]
Action: Move your cursor to rotate the part.
- Note: The script uses smart snapping (1°, 5°, 15°, 45°, 90°) depending on how far the cursor is from the pivot point.
```

### Step 6: Finish
```
Action: Continue placing parts or press Enter/Esc to finish.
Note: The script instance removes itself automatically, leaving only the placed metal parts in the model.
```

## Properties Panel Parameters
*Note: This script uses interactive dialogs and command-line inputs for configuration rather than static Properties Palette parameters.*

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Style Drawing Source | Filepath | *Scanned Folders* | Determines the library file used to populate the list of available parts. Set via the "Default Style Drawing" dialog. |
| Metal Part Style | String | *User Selected* | The specific definition of the hardware (geometry/material). Set via the "Style Selection" dialog. |
| Insertion Point | Point | *User Click* | The 3D coordinate where the part origin (0,0,0) is placed. |
| Rotation Angle | Angle | 0.0° | The orientation of the part around its Z-axis. Set dynamically using the "Rotate" keyword. |

## Right-Click Menu Options
*This script does not add specific custom items to the right-click context menu. Standard AutoCAD/hsbCAD commands apply.*

## Settings Files
- **Filename**: `TslUtilities.dll`
- **Location**: `_kPathHsbInstall\Utilities\DialogService\`
- **Purpose**: Required to display the selection dialogs for style drawings and part lists.
- **Filename**: `*.dwg` (Style Drawings)
- **Location**: `<company>\subassembly` or `<company>\assemblies`
- **Purpose**: These files contain the `MetalPartCollectionDef` entities that define the geometry and properties of the metal parts.

## Tips
- **Smart Angle Snapping**: When rotating, move your cursor close to the pivot point for fine adjustments (1°) or further away for large steps (90°).
- **Import Keyword**: Use the `Import` keyword if you want to force the style definition into the current drawing file. This prevents the "missing reference" error if the library DWG is moved or deleted later.
- **Post-Insert Editing**: Once placed, the script deletes itself. To move or rotate the part later, use standard AutoCAD grips or the Properties Palette on the resulting `MetalPartCollectionEnt`.

## FAQ
- **Q: What happens if I select a style that isn't in the current drawing?**
  **A:** The script attempts to automatically import it from the selected Style Drawing. If the import fails, the script will cancel and erase the temporary instance.
- **Q: Can I modify the script parameters after placing the part?**
  **A:** No, because the script instance self-destructs upon placement. You must modify the resulting Metal Part entity using its standard properties.
- **Q: Why don't I see the "Default Style Drawing" dialog?**
  **A:** This only appears if the script finds DWG files in your company subassembly/assemblies folders. If none are found, it defaults to using styles already present in the current drawing.