# HSB_W-AnchorDistribution.mcr

## Overview
This script automates the calculation and distribution of anchor points (such as wind brackets or hold-downs) on wall elements based on spacing rules. It also supports manual placement modes and generates visual symbols and hardware data for production lists.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates in 3D model space on Wall Elements. |
| Paper Space | No | Not supported for layout/drawing generation. |
| Shop Drawing | No | This is a model-generation script. |

## Prerequisites
- **Required Entities**: A valid Wall Element (`ElementWallSF`) must exist in the model.
- **Minimum Beam Count**: 0 (Uses Wall Elements, not beams).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_W-AnchorDistribution.mcr`

### Step 2: Configure Properties
The script loads the Properties Palette. Before placing anchors, check the following key setting:
- **Select anchor positions manually**: 
  - Set to **No** (Default) for automatic calculation.
  - Set to **Yes** to click specific positions manually.

### Step 3: Select Elements (Automatic Mode)
*If "Select anchor positions manually" is set to No.*
```
Command Line: Select elements [<Enter, for manual mode|>
Action: Click on the wall elements you want to process. Press Enter to finish.
Result: The script automatically places anchors on the selected walls based on spacing properties and erases itself from the cursor.
```

### Step 4: Select Element and Points (Manual Mode)
*If "Select anchor positions manually" is set to Yes.*
```
Command Line: Select an element
Action: Click on the specific wall element to attach the anchors.

Command Line: Select a position
Action: Click on the wall where the first anchor should be located.

Command Line: Select next point
Action: Click for additional anchors. Press Enter to finish placement.
```

## Properties Panel Parameters

### Anchor Distribution
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Select anchor positions manually | dropdown | Yes | If 'Yes', you pick points. If 'No', the script calculates them automatically. |
| Side | dropdown | Top | Which face of the wall to apply anchors to (Top, Bottom, Right, Left). |
| Maximum center spacing | number | 1000 | The maximum distance allowed between anchor centers (mm). |
| Distribute evenly | dropdown | No | If 'Yes', anchors are spaced equally. If 'No', they use max spacing starting from one end. |
| Minimum distance between anchors | number | 300 | Minimum gap required between two anchors. |
| Anchors under door | dropdown | Yes | Determines if anchors are placed in the wall section below door openings. |
| Distance to door | number | 50 | Offset distance from the door opening edge to the nearest anchor (mm). |
| Distance to edge | number | 150 | Offset distance from the wall ends (start/stop) to the first/last anchor (mm). |
| Apply edge anchors | dropdown | Yes | If 'No', the anchors at the very start and end edges are removed. |

### Anchors
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Symbol | text | X | The text character displayed in the model for the anchor. |
| Article number | text | | The hardware code for the BOM/Material List. |
| Subtype | text | | A classification tag used by dimensioning scripts to filter these anchors. |

### Visualization (Inferred)
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show anchors | dropdown | Yes | Toggles the visibility of the anchor symbols in the model. |
| Dimension mode | dropdown | No dimension | Controls display: None, "General spacing", or "All anchor positions". |
| Text height | number | 50 | Size of the anchor symbol text. |
| Text height dimension | number | 30 | Size of the dimension text labels. |
| Offset from element Y | number | 150 | Distance the symbol is offset from the wall surface. |
| Anchor color | number | 1 | AutoCAD color index for the symbol (1 = Red). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Recalculate** | Clears existing points (in auto mode) and re-runs the distribution algorithm based on current wall geometry and properties. |
| **Add anchor** | Enters a point-selection mode. Clicks on the model will add new anchor points to the current list. |
| **Remove anchor** | Enters a point-selection mode. Clicking near existing anchors removes them from the list. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external XML settings files; it uses the Properties Palette for configuration.

## Tips
- **Subtype Usage**: Use the "Subtype" property to group anchors. Dimension scripts can filter by this subtype to create specific labels for different anchor types (e.g., "Wind" vs "HoldDown").
- **Visuals in Drawings**: The script displays anchors in Top View but hides them in Elevation views to keep drawings clean.
- **Quick Adjustments**: You can change the "Side" property (e.g., from Top to Left) to instantly rotate the anchor layout to a different wall face without re-selecting the wall.

## FAQ
- **Q: Why did my anchors disappear after I changed the wall length?**
  - A: The script is linked to the wall geometry. Changing the wall length usually triggers a recalculation. If the spacing logic no longer fits, the positions update automatically.
- **Q: How do I place an anchor exactly in a corner despite the "Distance to edge" setting?**
  - A: Set "Select anchor positions manually" to "Yes", or switch to Manual Mode and click the specific corner point. Alternatively, set "Distance to edge" to 0 and recalculate.
- **Q: Can I use this for curved walls?**
  - A: The script uses the element envelope. While it primarily handles linear distribution, it projects onto the element envelope. It is best suited for straight walls.