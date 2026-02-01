# DimAngular

## Description

This TSL creates angular dimensions for measuring angles between elements in hsbCAD. It supports various reference modes including genbeams, elements, multipages, sections, and shop drawing viewports.

**Version:** 2.7 (15.11.2023)

## Script Type

**O-Type (Object)** - This script creates a standalone dimension object that can be placed in the drawing.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary environment for 3D elements |
| Paper Space | Yes | Supports dimensions within viewports and layout setups |
| Shop Drawing | Yes | Fully supports multipage and section view contexts |

## Prerequisites

- **Required Entities**: GenBeam, Element, MultiPage, Section, ShopDrawView, EntPLine, or MetalPartCollectionEnt
- **Required Settings**: Standard CAD DimStyles must exist in the drawing

## Usage Steps

### Step 1: Launch Script

Command: `TSLINSERT`
Action: Select `DimAngular.mcr` from the file list.

### Step 2: Select Reference Entity

Select one of the following entity types:
- **GenBeam** - Individual timber members
- **Element** - Complete wall, floor, or roof assemblies
- **MultiPage** - Drawing sheet layouts
- **Section** - 2D section views
- **ShopDrawView** - Shop drawing viewports
- **EntPLine** - Polyline entities
- **MetalPartCollectionEnt** - Metal part collections

### Step 3: Configure Dimension

The script will generate the dimension based on the element's geometry. Use the **Properties Palette** to adjust settings as needed.

### Paperspace Insertion

When working in Paper Space:
1. Select a viewport when prompted
2. Pick a point to define the placement:
   - **Inside viewport**: Creates a local instance attached to that viewport
   - **Outside viewport but inside layout**: Creates a setup instance for element-level dimensioning

### MultiPage Insertion

When selecting a MultiPage:
1. If multiple viewports exist, select the desired viewport
2. The dimension will track with the multipage and maintain its relative position

## Properties Panel Parameters

### Behaviour Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Angle Mode | Selection | Adjacent Angles | Defines how angles are calculated. Options: "Adjacent Angles" or "Full Complementary Angle" |
| Snap Mode | Selection | Vertex | Defines the snap mode for angle detection. Options: "Vertex" or "Segment" |
| Suppress 90 degrees | Selection | Yes | When set to "Yes", angles of 90 degrees are suppressed and not displayed |
| Filter | Selection | Default | Filters entities by painter definition. If a painter collection named "Dimension" exists, only painters from this collection are shown |

### Display Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Text | Text | (empty) | Defines the content of the dimension text. Use "<>" or leave empty for default value. Use format variables to customize (e.g., @(Angle:RL0) to show angle without decimals) |
| Dimstyle | Selection | (first available) | The CAD dimension style used to control fonts, arrowheads, and precision |
| Text Height | Length | 0 | Height of the dimension text. Use 0 for "byDimstyle" (uses the dimension style setting) |
| Global Scale Factor | Number | 1 | Scale factor to resize the dimension (affects text, arrows, lines) |
| Color | Integer | -1 | Color of the dimension. Note: Requires the dimstyle to be defined with colors byBlock |
| Leader Linetype | Selection | Disabled | Linetype of a potential leader line |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Set Text Location / Text Location byDimstyle** | Toggle between custom text placement and default dimension style placement |
| **Adjacent Angles / Full Complementary Angle** | Toggles the dimension mode. Switches between measuring the specific angle between beams and the full 360-degree complement. Can also be triggered by double-clicking the script. |
| **Add Similar** | Prompts you to pick a new location in the drawing. Inserts a new instance of the dimension with the current settings at the selected point. |
| **Regenerate Shopdrawing** | (Shop drawing mode only) Forces a regeneration of the current shopdrawing page. Useful if underlying geometry has changed. |
| **Pick Viewport Setup Location** | (Viewport setup mode only) Allows you to interactively pick a new setup location for the viewport dimension. |

## Grip Points

The dimension includes draggable grip points:
- **_Pt0**: Main insertion point - drag to reposition the entire dimension
- **_PtG**: Additional grip points for adjusting dimension appearance and leader lines

## Settings Files

No external settings files (XML) are explicitly required for this script. It utilizes standard CAD DimStyles present in the current drawing.

## Tips

- **Double-Click**: Quickly switch between "Adjacent Angles" and "Full Complementary Angle" by double-clicking the script instance in the drawing.
- **Grip Editing**: Drag the grip points in the drawing to move the dimension vertex location dynamically.
- **Viewport Setup**: When working in PaperSpace, use the "Pick Viewport Setup Location" option to fine-tune the position of dimensions within viewports without breaking the link to the model.
- **Scaling**: If the dimension text or arrows appear too small or large in a viewport, adjust the Global Scale Factor property rather than manually scaling the entity.
- **Arc Length**: Arc length dimensions are only created if a format argument is provided (version 2.7+).

## FAQ

- **Q: How do I measure the larger angle instead of the smaller acute angle?**
  A: Right-click the dimension and select "Full Complementary Angle", or simply double-click the dimension to toggle the mode.

- **Q: Can I use this script in a 2D layout view?**
  A: Yes, the script supports PaperSpace and handles viewports. Ensure you attach it to a valid element that is visible in the layout.

- **Q: Why does my dimension text look different from my standard dimensions?**
  A: Check the Dimstyle property in the Properties Palette. It must match the name of a valid Dimension Style defined in your AutoCAD template.

- **Q: How do I hide 90-degree angles?**
  A: Set the "Suppress 90 degrees" property to "Yes" in the Properties Palette.

- **Q: How do I filter which beams get dimensioned?**
  A: Use the Filter property to select a painter definition. Create a painter collection named "Dimension" with sub-painters to filter specific entity types.
