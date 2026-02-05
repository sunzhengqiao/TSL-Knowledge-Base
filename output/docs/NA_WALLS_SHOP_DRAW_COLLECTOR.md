# NA_WALLS_SHOP_DRAW_COLLECTOR

## Overview
This script automatically extracts and lists the wall (Element) numbers found within specific shop drawing views on your layout. It generates a text block on the sheet to identify which wall panels are detailed in the selected viewports.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is intended for layout sheets. |
| Paper Space | Yes | This is the primary environment for operation. |
| Shop Drawing | Yes | Specifically designed for use during shop drawing generation. |

## Prerequisites
- **Required entities**: `ShopDrawView` entities (Viewports) must exist on the current layout.
- **Minimum beam count**: 0 (Not applicable).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `NA_WALLS_SHOP_DRAW_COLLECTOR.mcr`

### Step 2: Select Shop Draw Views
```
Command Line: Select shop draw views
Action: Click on the shop drawing viewports (ShopDrawViews) that contain the walls you want to list. Press Enter when finished.
```

### Step 3: Select Insertion Point
```
Command Line: Select insertion point
Action: Click on the drawing sheet where you want the top of the wall list to appear. The list will grow downwards from this point.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose any editable properties in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Update Shop Drawing Data | Refreshes the list of wall numbers. Use this if the walls inside the view have changed or if you want to re-scan the data. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- The script will list walls in alphabetical or numerical order.
- If the selected view does not contain any wall elements, the script will display "N/A".
- The text height is fixed at 0.25 inches.
- If you select no views during insertion, the script will automatically delete itself to prevent empty annotations.

## FAQ
- **Q: Why did the script disappear immediately after I inserted it?**
  **A:** The script erases itself if you press Enter without selecting any Shop Draw Views. Please run the command again and ensure you select at least one viewport.
- **Q: Can I change the size of the text?**
  **A:** No, the text height is currently fixed at 0.25 inches.
- **Q: How do I update the list if I add a new wall to the model?**
  **A:** Right-click on the script instance and select "Update Shop Drawing Data" from the context menu.