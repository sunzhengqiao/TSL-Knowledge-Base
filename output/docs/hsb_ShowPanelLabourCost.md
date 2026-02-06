# hsb_ShowPanelLabourCost.mcr

## Overview
This script calculates the estimated labor cost for a wall panel based on its area, number of openings, height, and geometric type (gable, dormer, or standard). It displays the calculated cost as a text label in your Paper Space layout.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for Layouts. |
| Paper Space | Yes | **Primary Environment.** Requires a Viewport containing an hsb Element. |
| Shop Drawing | No | Used for estimation layouts, not manufacturing drawings. |

## Prerequisites
- **Required Entities:** A Viewport on a Layout tab that displays a valid hsbCAD Element (Wall).
- **Minimum Beam Count:** N/A (Works at the Element level).
- **Required Settings:** The Element must have a Code (e.g., "A", "I") that matches the script's "Code External/Internal Walls" lists to calculate a price.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_ShowPanelLabourCost.mcr` from the list.

### Step 2: Select Viewport
```
Command Line: Select the viewport from which the element is taken
Action: Click on the border of the viewport that contains the wall panel you wish to price.
```

### Step 3: Pick Text Location
```
Command Line: Please Pick a Point
Action: Click anywhere in the layout where you want the cost label to appear.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Dimension Style** | dropdown | `_DimStyles` | The visual style (font, size) used for the cost text. |
| **Code External Walls** | text | `A;B;` | Semicolon-separated list of Element Codes (e.g., `A;B;EXT;`) that identify a wall as "External". |
| **Price for External Walls** | number | `2` | Labor rate per m² for standard external walls. |
| **Price for Opening on External Walls** | number | `3` | Fixed labor cost per opening (window/door) in external walls. |
| **Price for Gable External Walls** | number | `2` | Labor rate per m² for external gable walls (detected by angle plates). |
| **Price for Dormer External Walls** | number | `2` | Labor rate per m² for external dormer cheek walls. |
| **Code Internal Walls** | text | `I;F;` | Semicolon-separated list of Element Codes that identify a wall as "Internal". |
| **Price for Internal Walls** | number | `2` | Labor rate per m² for standard internal walls. |
| **Price for Opening on Internal Walls** | number | `3` | Fixed labor cost per opening in internal walls. |
| **Minimun Height** | number | `2000` | Height threshold in mm. Walls shorter than this trigger the "Short Wall" price. |
| **Price Internal Wall when less than minimun height** | number | `3` | Labor rate per m² for internal walls shorter than the Minimum Height. |
| **Price for Gable Internal Walls** | number | `2` | Labor rate per m² for internal gable walls. |
| **Price for Dormer Internal Walls** | number | `2` | Labor rate per m² for internal dormer cheek walls. |

## Right-Click Menu Options
Standard TSL context menu options apply when the label is selected:
- **Recalculate:** Updates the cost if the wall geometry or properties change.
- **Erase:** Removes the label.
- **Properties:** Opens the Properties palette to adjust pricing or codes.

## Settings Files
- **Filename:** None used.
- **Location:** N/A
- **Purpose:** All configuration is handled directly via the Properties Panel.

## Tips
- **Matching Codes:** If the cost shows as 0 or nothing appears, check the **Element Code** in the hsbCAD properties. It must exist in the **Code External Walls** or **Code Internal Walls** lists (e.g., if your wall is code "EXT", add "EXT;" to the list).
- **Dormer Detection:** Dormer walls are automatically detected if the bottom plate is rotated relative to the element vector. Ensure your geometry is constructed correctly for accurate pricing.
- **Gable Detection:** The script looks for "Angle Plates" (Types 54/55) to identify gables.
- **Quick Updates:** You can change the unit rates (e.g., `Price for External Walls`) in the Properties palette, and the text label will automatically update to reflect the new total.

## FAQ
- **Q: Why does my wall have a different price than expected?**
- **A:** Check the **Height**. If an internal wall is shorter than the **Minimum Height** (default 2000mm), the script applies the higher "Short Wall" rate automatically.
- **Q: Can I use this for floors or roofs?**
- **A:** No. This script is designed specifically for Wall Panels (Elements) containing beams (studs/plates). It relies on wall-specific geometry like bottom plates.
- **Q: How do I change the currency symbol?**
- **A:** This script calculates a raw number. To add a currency symbol (like $ or €), you typically modify the **Dimension Style** (`sDimStyle`) used in AutoCAD to include a prefix or suffix.