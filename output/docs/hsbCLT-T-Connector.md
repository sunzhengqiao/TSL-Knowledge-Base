# hsbCLT-T-Connector.mcr

## Overview
This script generates a T-shaped steel connector plate designed for CLT (Cross Laminated Timber) panels. It creates the steel plate geometry, machines a slot into the timber to embed the plate, and applies a pattern of fastener holes through both the plate and the wood.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model on Sip entities. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | This is a model generation script, not a 2D detailing tool. |

## Prerequisites
- **Required Entities**: At least one CLT Panel (Sip entity).
- **Minimum Beam Count**: 1 Panel (Primary).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-T-Connector.mcr` from the list.

### Step 2: Configure Properties
```
Dialog Box: hsbCLT-T-Connector
Action: If no catalog key is preset, a dialog appears. Adjust dimensions (Length, Width, Height, etc.) and click OK.
```

### Step 3: Select Male CLT Panel
```
Command Line: Select male CLT Panel
Action: Click on the CLT panel that will host the T-connector (the panel receiving the slot).
```

### Step 4: Select Female CLT Panel
```
Command Line: Select female CLT Panel (optional)
Action: Click the adjacent CLT panel if you want the script to automatically stretch the male panel edge to meet the female panel. Press Enter to skip this step.
```

### Step 5: Define Insertion Point
```
Command Line: 
Action: Click on or near the edge of the Male CLT Panel where you want the connector to be placed. The script will snap to the nearest edge.
```

## Properties Panel Parameters

### Geometry
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Length | Number | 300 | The horizontal length of the connector plate flange. |
| Width | Number | 100 | The vertical height of the connector plate flange. |
| Height | Number | 215 | The depth of the connector web (the part inserted into the wood). |
| Thickness | Number | 10 | The material thickness of the steel plate. |

### Location
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Edge Offset | Number | 40 | Distance from the edge of the panel to the start of the connector. |
| Center Offset | Number | 0 | Vertical offset relative to the center of the panel thickness. |

### Tolerances
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| GapX | Number | 10 | Horizontal clearance for the slot (Length + 2*GapX). |
| GapY | Number | 1 | Vertical clearance for the slot. |
| GapZ | Number | 1 | Thickness clearance for the slot (Thickness + 2*GapZ). |

### Drill Pattern
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Diameter | Number | 14 | Diameter of the fastener holes. |
| Rows | Number | 5 | Number of fastener holes in the vertical direction. |
| Row Offset | Number | 42 | Spacing between rows of fasteners. |
| Columns | Number | 5 | Number of fastener holes in the horizontal direction. |
| Column Offset | Number | 42 | Spacing between columns of fasteners. |
| PatternMode | Dropdown | \|1 Pattern\| | Selects between a single pattern or a mirrored double pattern. |
| PatternOffsetX | Number | 0 | Horizontal shift of the drill pattern origin. |
| PatternOffsetY | Number | 0 | Vertical shift of the drill pattern origin. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the connector geometry and machining based on current properties or entity movements. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script uses standard properties and does not require an external settings file.

## Tips
- **Automatic Stretching**: If you select a Female Panel in Step 4 that is perpendicular to the Male Panel, the script will automatically shorten (stretch) the Male Panel edge to meet the Female Panel, minus the specified Edge Offset.
- **Grip Editing**: You can select the inserted connector and drag the insertion point grip to a different edge. The connector will automatically re-orient to the new edge.
- **Double Pattern**: When using "2 Patterns" mode, the script automatically calculates the necessary horizontal offset (`PatternOffsetX`) to prevent the two drill grids from overlapping each other.

## FAQ
- **Q: Why did my connector disappear?**
  - **A:** The script may have failed to find a valid edge near your insertion point. Ensure you click close to the edge of the CLT panel.
- **Q: Can I use this to connect two walls?**
  - **A:** Yes, by selecting the second wall as the "Female Panel", the script will adjust the length of the first wall to create a tight connection.
- **Q: How do I change the hole spacing after insertion?**
  - **A:** Select the connector, open the Properties palette (Ctrl+1), and modify the "Row Offset" or "Column Offset" values under the Drill Pattern section.