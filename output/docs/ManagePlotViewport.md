# ManagePlotViewport.mcr

## Overview
This script automates the creation, naming, and management of plot viewports in Paper Space layouts. It links viewports to model entities (such as walls or panels) to automatically apply labels and Position Numbers (PosNum) based on specific formatting rules.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Partial | Used to read properties from defining entities (GenBeam, Sip) but viewports are created elsewhere. |
| Paper Space | Yes | Primary workspace for creating and managing PlotViewport entities. |
| Shop Drawing | Yes | Designed for generating production drawings and plotting layouts. |

## Prerequisites
- **Required Entities**: `MultiPage` elements (for batch generation) or existing `PlotViewport` entities (for management).
- **Minimum Beam Count**: 0.
- **Required Settings**: None required internally; relies on standard Layout definitions.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `ManagePlotViewport.mcr`

### Step 2: Select Objects
```
Command Line: Select multipages and plot viewports or <Enter> to insert a single plot viewport
Action:
  - To create multiple viewports: Select MultiPage entities in the drawing.
  - To manage existing viewports: Select existing PlotViewport entities.
  - To create one viewport manually: Press Enter.
```

### Step 3: Define Insertion Point (If <Enter> was pressed)
```
Command Line: [Point Prompt]
Action: Click in the desired Layout (Paper Space) to place the new PlotViewport.
```

### Step 4: Management Mode (If existing Viewports were selected)
```
Action: The script instance will remain attached to the selected viewports. You can now:
  1. Double-click the viewport to re-link it to a different defining entity (e.g., a different wall).
  2. Right-click to access context menu options.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Format | String | @(Name) | Defines the naming convention for the viewport. Uses tokens like `@(Name)`, `@(Number)`, or `Masterpanel.Number` to pull data from the linked model entity. |
| Layout | String | (Current Layout) | Specifies the target Layout tab where the PlotViewport will be created or managed. |
| Horizontal Offset | Double | 0 | Shifts the viewport position horizontally (left/right) from the calculated center point. |
| Vertical Offset | Double | 0 | Shifts the viewport position vertically (up/down) from the calculated center point. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Select defining entity | Prompts you to select a model entity (e.g., a beam or panel). The viewport will update its Name and PosNum to match the selected entity. |

## Settings Files
- None used.

## Tips
- **Batch Generation**: Select multiple MultiPages at once to automatically generate viewports for all of them. The script calculates the required view size based on the MultiPage geometry.
- **Masterpanel Labels**: If your project uses Masterpanels, you can use the Format property `Masterpanel.Number` or `Masterpanel.Name` to label viewports with the parent assembly data rather than the individual part data.
- **Updating Links**: If a viewport label is incorrect or out of date, select the viewport and use the "Select defining entity" context menu option to fix the association.

## FAQ
- **Q: How do I create a single viewport without selecting a MultiPage?**
  A: Run the script and press **Enter** immediately when prompted to select objects. Then click the desired location in your layout.
- **Q: The viewport name isn't updating.**
  A: Ensure the viewport is linked to the correct defining entity. Select the viewport, right-click, and choose "Select defining entity" to re-associate it.
- **Q: Can I use this to organize views of specific walls?**
  A: Yes. Select the viewport in Management Mode and link it to the specific GenBeam or Wall element. The viewport will then adopt that entity's properties.