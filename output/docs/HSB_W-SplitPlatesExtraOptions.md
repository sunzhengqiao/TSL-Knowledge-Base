# HSB_W-SplitPlatesExtraOptions.mcr

## Overview
Automatically splits wall plates (top, bottom, and sill) into manageable lengths based on maximum length constraints while avoiding studs and opening modules to maintain structural integrity. It also handles the creation of splice blocks (scabs) and the labeling of the split segments.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary working environment. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | Not applicable. |

## Prerequisites
- **Required Entities:** ElementWallSF (Wall objects).
- **Minimum Beam Count:** 1 (The wall must contain plates/beams to split).
- **Required Settings:** None (uses default internal properties or hsbCAD Catalogs).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_W-SplitPlatesExtraOptions.mcr`

### Step 2: Select Wall Elements
```
Command Line: Select element(s)
Action: Click on the Wall elements (ElementWallSF) in the model that you wish to process.
```

### Step 3: Configure Properties
```
Action: After selection, the script attaches to the walls. Open the Properties Palette (Ctrl+1) to adjust splitting parameters.
```

### Step 4: Preview and Adjust
```
Action: With Preview mode set to "Yes", the wall plates will display calculated split points (often shown as grips or regions).
Action: Drag the blue grip points to manually adjust split locations if needed, or change properties like Maximum Length.
```

### Step 5: Finalize
```
Action: Set "Preview mode" to "No" in the Properties Palette or select "Reset Plates And Delete" from the right-click menu to commit the changes and remove the script instance.
```

## Properties Panel Parameters

### General
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Maximum length | number | 4800 mm | The maximum allowed length for a single plate piece before a split is forced. |
| Opening module dimensions greater than | number | 605 mm | Threshold to identify 'large' openings. Splits near openings larger than this use specific spacing rules. |
| Split distance to opening module | number | 269 mm | Minimum clearance distance between a split cut and the edge of a large opening module. |
| Split distance to small module | number | 119 mm | Minimum clearance distance between a split cut and a small obstruction or module. |
| Split distance to stud | number | 119 mm | Minimum clearance distance between a split cut and a wall stud. |
| Side of Stud Clear Space | dropdown | both | Defines which side of a stud the clearance restriction applies (both, left, or right). |

### Additional options
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Split Location | dropdown | Opposite | Determines if splits are aligned ("Same") or staggered ("Opposite") between top and bottom plates. |
| Split on stud | dropdown | No | If "Yes", allows external plates to be split directly over a stud location. |
| Create splice blocks | dropdown | Yes | If "Yes", generates timber blocks at the split joints to reconnect the plates. |
| Set BeamCode | dropdown | Left to Right | Assigns a sequential suffix (A, B, C...) to the split plates based on position. |
| Write BeamCode suffix to Label | dropdown | No | Appends the sequential suffix to the visible label on the plate. |

### Reset & Debug
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Reset plates | dropdown | No | If "Yes", restores plates to their original, un-split lengths. |
| Preview mode | dropdown | Yes | Keeps the script active for adjustments. Set to "No" to apply changes and delete the script. |
| Show non split regions | dropdown | Yes | Visualizes the valid regions where splits can occur (exclusion zones). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| ../Split Plates | Triggers a recalculation of split points based on current properties. Can also be triggered by double-clicking the script instance. |
| ../Reset Plates | Restores the plates to their original lengths but keeps the script active for re-editing. |
| ../Reset Plates And Delete | Restores plates to original lengths and removes the script instance from the model. |
| ../Delete | Removes the script instance, committing any current split geometry. |

## Settings Files
- **Catalogs**: The script attempts to load properties from a Catalog Entry if provided during launch, or defaults to the `_LastInserted` catalog configuration.
- **Location**: Standard hsbCAD Catalog paths.

## Tips
- **Interactive Editing**: Keep "Preview mode" set to "Yes" initially. This allows you to see the "Show non split regions" (green/red indicators) and drag the blue split grips to fine-tune positions manually.
- **Staggering Splits**: Use the "Split Location" property set to "Opposite" to stagger top and bottom plate joints. This generally improves the structural racking strength of the wall.
- **Avoiding Studs**: If the script refuses to split a specific long section, check "Show non split regions". It may be that the "Split distance to stud" is too large for the spacing between studs in that wall, leaving no valid gap to cut.

## FAQ
- **Q: How do I split a plate directly over a stud?**
- **A:** Change the property "Split on stud" to "Yes". This overrides the standard clearance distance.
- **Q: Why did my plates disappear?**
- **A:** You likely have "Reset plates" set to "Yes". Change it back to "No" to restore the split geometry.
- **Q: Can I undo the splits?**
- **A:** Yes, right-click the script instance and select "../Reset Plates". If the script has already been deleted ("Preview mode" was No), you will need to use the standard AutoCAD Undo command.