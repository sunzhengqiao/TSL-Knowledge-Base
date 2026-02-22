# GE_PLOT_PLAN_VIEW

## Overview

Creates a 2D plan view of a Timber Frame (TF) wall in layout space with customizable display symbols for different beam types. This script generates simplified 2D representations of wall components, making it easier to create architectural plans and shop drawings.

**Script Type:** Object (O)
**Version:** 1.1
**Author:** David Rueda (dr@hsb-cad.com)
**Last Updated:** March 20, 2013

## Key Features

- Displays walls in 2D plan view from Paper Space viewports or Shop Drawing views
- Customizable visual symbols for different beam types
- Special handling for vertical/horizontal blocking beams
- Automatic detection of view context (Paper Space vs. Shop Drawing Space)
- Support for multiple beam types with individual display options

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is intended for detailing in 2D layouts. |
| Paper Space | Yes | Select a Viewport linked to an Element to generate symbols over the view. |
| Shop Drawing | Yes | Select a ShopDrawView entity within the multipage environment. |

## Supported Display Symbols

| Symbol | Display Type | Description |
|--------|--------------|-------------|
| (blank) | No display | Beam is not shown in the view |
| O | Circle | Hollow circle representing the beam outline |
| / | Forward slash | Diagonal line from bottom-left to top-right |
| \\ | Backward slash | Diagonal line from top-left to bottom-right |
| X | Cross | X-shaped symbol with cross lines |
| S | Shadow | Only shows the shadow/silhouette of the beam |
| - | Center line | Horizontal line through the timber |
| Outline only | Outline | Only the outer boundary of the wall element |

## Beam Types with Customizable Display

The script supports customization for the following beam types:

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_PLOT_PLAN_VIEW.mcr`

### Step 2: Configure Properties
1. The **Properties Palette** will open automatically upon insertion.
2. Under **Drawing space**, select either `paper space` or `shopdraw multipage`.
3. Scroll down to the beam type properties (e.g., *Jack Over Opening*, *King Stud*, *TopPlate*).
4. Change the value from `No display` to a desired symbol (e.g., `O`, `X`, `/`, `\`).

### Step 3: Select View Entity
Depending on your selection in Step 2, the command line will prompt for an entity:

**If "paper space" was selected:**
```
Command Line: Select the viewport from which the element is taken
Action: Click on the layout viewport that displays the wall/floor you want to detail.
```

**If "shopdraw multipage" was selected:**
```
Command Line: Select the view entity from which the module is taken
Action: Click on the ShopDrawView frame in the drawing.
```

### Step 4: Generation
The script will automatically project the beams and draw the configured symbols onto the view.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Drawing space** | dropdown | paper space | Determines if the script targets a Layout Viewport or a ShopDrawView. |

### Beam Type Properties (All default to "No display")

1. **Jack Over Opening** - Short studs above window/door openings
2. **Jack Under Opening** - Short studs below window/door openings
3. **Cripple Stud** - Very short studs used for alignment
4. **Transom** - Horizontal member above a door or window
5. **King Stud** - Full-height studs supporting headers
6. **Window Sill** - Horizontal member at the bottom of a window
7. **Angled Top Plate Left** - Angled top plate members (left side)
8. **Angled Top Plate Right** - Angled top plate members (right side)
9. **Top Plate** - Horizontal member at the top of the wall
10. **Bottom Plate** - Horizontal member at the bottom of the wall (sole plate)
11. **Blocking** - Short studs between main studs
12. **Supporting Beam** - Structural beams supporting the wall
13. **Stud** - Standard wall studs
14. **Stud Left** - Specialized studs for left corners
15. **Stud Right** - Specialized studs for right corners
16. **Header** - Horizontal member spanning openings
17. **Brace** - Diagonal structural members
18. **Locating Plate** - Plates for locating components
19. **Packer** - Small spacing pieces
20. **Sole Plate** - Bottom plate supporting the wall
21. **Head Binder/Very Top Plate** - Topmost wall member
22. **Vent** - Ventilation openings

**Symbol Options:**
- `O`: Draws a circle.
- `X`: Draws a cross.
- `/` or `\`: Draws diagonal lines.
- `S`: Shows only the shadow/silhouette of the beam.
- `-`: Draws a center line through the timber.
- ` ` (blank): No display - beam is not shown.
- `Outline only`: Only the outer boundary of the wall element.
- `Center line trough timber`: Draws a center line through the beam.

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Erase** | Removes the script instance and the generated symbols from the drawing. |
| **Properties** | Re-opens the Properties Palette to change beam symbols or settings. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies entirely on Properties Palette inputs and does not use external settings files.

## Special Features

### Blocking Beam Special Treatment
The script includes special logic for blocking beams:
- When a blocking beam is perpendicular to the view direction, it automatically displays with a forward slash (/) symbol
- This helps distinguish blocking from regular studs in the plan view

### Automatic View Detection
The script automatically detects whether it's working in:
- **Paper Space**: Uses viewport coordinate systems
- **Shop Drawing Space**: Uses shop drawing view data

## Technical Details

### Coordinate System Handling
- Transforms coordinates from the element's local coordinate system to the view's coordinate system
- Projects 3D geometry to 2D plane for display
- Maintains proper orientation based on view angle

### Performance Considerations
- Only displays beams that have a valid display setting
- Uses shadow profiles for efficient 2D representation
- Special handling for blocking to improve visual clarity

### Error Handling
- Validates viewport and entity selections
- Checks for valid hsb data in viewports
- Gracefully handles missing view data in shop drawings

## Sample Workflow

1. **Create a Timber Frame Wall** using hsbCAD wall tools
2. **Switch to Paper Space** or create a Shop Drawing
3. **Insert GE_PLOT_PLAN_VIEW** script
4. **Select the appropriate view/viewport**
5. **Customize beam display symbols** in the Properties Palette
6. **Adjust as needed** for different drawing scales and purposes

## Common Use Cases

- **Architectural Plans**: Creating simplified 2D representations of timber walls
- **Shop Drawings**: Generating fabrication views with clear beam identification
- **Detail Views**: Creating close-up views with specific symbol emphasis
- **Multiple Scale Drawings**: Using different symbol combinations for various drawing scales

## Tips
- **Automatic Blocking Overrides**: When working in Paper Space, the script automatically detects horizontal blocking in horizontal views and forces the symbol to be a slash (`/`), overriding the property setting. This ensures clarity in standard framing plans.
- **Initial Setup**: By default, all beam types are set to "No display". You must actively select symbols for the beams you wish to visualize.
- **Visibility**: If you see the text "This tsl need to be customized" in your drawing, it means no symbols were generated. Check your properties to ensure at least one beam type is set to a visible symbol.
- **Use "Shadow" symbol** for complex wall sections to reduce visual clutter
- **Use "Outline only"** for overall wall layout in architectural plans
- **Use "X" or "O" symbols** for stud layouts to show spacing clearly
- **Customize blocking display** to make hidden blocking visible when needed
- **Consider the view angle** when selecting symbols - some symbols work better at certain orientations

## Version History

- **v1.1** (March 20, 2013): Changed property name from "Sill" to "Window Sill" for clarity
- **v1.0** (June 28, 2012): Initial release based on hsb_LayoutPlanSection with added beam type customization

## Dependencies

- Requires hsbCAD with Timber Frame functionality
- Compatible with both Paper Space and Shop Drawing environments
- Uses standard TSL coordinate transformation functions

## FAQ
- **Q: I inserted the script, but I don't see any symbols?**
  A: The default setting for all beam types is "No display". Select the script, open the Properties palette, and change specific beam types (like TopPlate or King Stud) to symbols like 'X' or 'O'.
  
- **Q: Can I use this on a 3D Model Space view?**
  A: No. This script is designed for 2D output in Paper Space layouts or Shop Drawing pages. It flattens the 3D geometry into 2D symbols.