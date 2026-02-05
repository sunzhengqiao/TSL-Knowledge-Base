# HSB_R-Lifting

## Overview
This script automates the creation of lifting points on timber roof or floor elements. It calculates the optimal position based on the element's center of gravity or user-defined offsets and generates the necessary drilling, symbols, or structural reinforcement blocks.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary environment for inserting the script. |
| Paper Space | No | Not applicable for detail views. |
| Shop Drawing | No | Not applicable for layouts. |

## Prerequisites
- **Required Entities**: An active Element (e.g., Roof or Floor) containing structural GenBeams.
- **Minimum Beams**: At least one structural beam must be present within the element.
- **Required Settings**: (Optional) `HSB_G-FilterGenBeams` if specific beam filtering is required by your project standards.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_R-Lifting.mcr` from the file dialog.

### Step 2: Select Element
```
Command Line: Select Element:
Action: Click on the timber element (roof or floor) you wish to add lifting points to.
```

### Step 3: Configure Properties
```
Action: Press Enter to accept default placement. Immediately open the Properties Palette (Ctrl+1) to adjust the lifting point position, tool type, and dimensions.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Tsl identifier | String | Pos 1 | A unique name to distinguish this instance if multiple lifting points are used on the same element. |
| Position type | Enum | Above center | Determines how the longitudinal position is calculated (e.g., Above center, Fraction of length, Above centroid). |
| Lifting position | Enum | Left, right | Determines the orientation relative to the element width (e.g., on side walls vs. gable ends). |
| Fraction | Number | 0.375 | The percentage of the element's length where the point is placed (only active if Position type is set to Fraction). |
| Y offset from reference point | Number | 500 mm | A fixed distance from the top or bottom reference edge to place the lifting point. |
| Tool | Enum | Symbol | Selects the physical method: Symbol (2D), Double Drill, Double Drill with Blocking, Single Drill, etc. |
| Drill diameter | Number | 24 mm | Diameter of the hole to be drilled. |
| Distance between drills | Number | 200 mm | Spacing between the two parallel holes (for double drill setups). |
| Only add blocking for weights above | Number | 0 kg | Minimum weight required to generate internal structural blocking beams. |
| BmCodeBlock | String | [Empty] | The material code assigned to the generated blocking beam for production lists. |
| Drill insulation | Enum | Yes | If "Yes", drills will also pierce through insulation layers. |
| Thickness blocking sheet | Number | 0 mm | Thickness of any sheet material reinforcement used around the hole. |
| Script name weight | String | HSB-Weight | The name of the script instance used to calculate the element's weight (e.g., "HSB-Weight" or "UNILIN"). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Refreshes the script to update geometry based on changes to the element or properties. |
| Erase | Removes the script instance and all associated entities (drills/blocks) from the element. |

## Settings Files
- **HSB_G-FilterGenBeams**: Catalog entry used to define which structural beams are valid for drilling. This prevents the script from drilling into non-structural or sheathing materials unless specified.
- **Weight Script Links**: Typically connects to `HSB-Weight` or `UNILIN` scripts to pull real-time mass data for the element.

## Tips
- **Multiple Lifting Points**: If you need four lifting points instead of two, insert the script a second time but change the **Tsl identifier** to "Pos 2" to prevent conflicts.
- **Heavy Elements**: For heavy roof elements, select **Tool** as "Double drill with blocking" and set a weight threshold. This will automatically generate solid timber blocking inside the element to prevent crushing.
- **Alignment**: If the script reports "No side rafters found," try adjusting the **Y offset from reference point** or changing the **Lifting position** (e.g., from Left/Right to Top/Bottom) to align with existing structural beams.

## FAQ
- **Q: Why did the script fail to insert?**
  **A:** Ensure you clicked on a valid Element and that no other instance of the script with the same **Tsl identifier** already exists on that element.
- **Q: The holes are not appearing in the insulation.**
  **A:** Check the **Drill insulation** property in the palette. It must be set to "Yes" to penetrate insulation layers.
- **Q: How do I switch from a visual symbol to actual machining holes?**
  **A:** Change the **Tool** property from "Symbol" to "Double Drill" or "Single Drill" in the Properties Palette.