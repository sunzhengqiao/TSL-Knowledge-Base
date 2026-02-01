# HSB_G-Stack

A TSL script that defines the bounding box of a stack, serving as a placeholder for stack items in hsbCAD. This script is designed to work with logistics and transport planning features.

## Script Information

| Attribute | Value |
|-----------|-------|
| Version | 1.00 |
| Last Modified | 04.04.2019 |
| Author | Anno Sportel (support.nl@hsbcad.com) |
| Script Type | O (Object) |
| Beams Required | 0 |

## Description

This script creates a stack bounding box that acts as a container placeholder for stack items. The stack object is recognized by:
- **MultiElementTools** - For batch operations on multiple elements
- **MapExplorer** - For inspecting and debugging stack data
- **hsbShare** - For data exchange and collaboration

The stack can automatically associate itself with a parent truck (HSB_G-Truck) when placed within the truck's bounding area.

## Script Type Explanation

**Type O (Object)**: This is a standalone object script that does not require any existing beams or elements to function. It creates an independent 3D bounding box that can be placed anywhere in model space.

## User Properties

The following properties are available in the AutoCAD Properties Palette (OPM) after placing the stack:

| Property | Type | Default Value | Description |
|----------|------|---------------|-------------|
| Length | Double | 7200 mm | The length dimension of the stack bounding box |
| Width | Double | 2200 mm | The width dimension of the stack bounding box |
| Height | Double | 2800 mm | The height dimension of the stack bounding box |

**Note**: All dimension properties trigger a recalculation of the stack geometry when changed.

## Usage Workflow

### Step 1: Insert the Stack

1. Load the script `HSB_G-Stack` in hsbCAD
2. If no catalog preset is specified, a dialog will appear for configuration
3. Click to select the insertion point when prompted with "Select a position"

### Step 2: Position the Stack

The stack will be created at the selected point with:
- The origin at the insertion point (`_Pt0`)
- Aligned to the World Coordinate System (WCS) axes
- Default dimensions of 7200 x 2200 x 2800 mm

### Step 3: Adjust Dimensions (Optional)

1. Select the placed stack object
2. Open the Properties Palette (Ctrl+1)
3. Modify Length, Width, or Height as needed
4. The stack geometry will automatically update

### Step 4: Associate with Truck (Automatic)

If the stack is placed within the bounding area of an existing `HSB_G-Truck` object:
- The stack automatically registers itself as a child of that truck
- Parent-child relationship is stored in the `Hsb_TruckChild` metadata
- This enables logistics tracking and transport planning

## Visual Indicators

When the stack is displayed:
- **Color 200**: The stack bounding box body
- **Color 1 (Red)**: X-axis of the entity coordinate system
- **Color 3 (Green)**: Y-axis of the entity coordinate system
- **Color 150**: Z-axis of the entity coordinate system
- **Child Origin Body**: Displayed in Color 1 to indicate the stack's local coordinate system

## Data Structure

The stack stores the following metadata for integration with other hsbCAD systems:

### Hsb_StackingParent
- `MyUID`: Unique handle of this stack instance
- `PtOrg`: Origin point (relative coordinates)
- `VecX`, `VecY`, `VecZ`: Coordinate system vectors (scalable)

### Hsb_TruckChild (when associated with a truck)
- `ParentUID`: Handle of the parent HSB_G-Truck instance

## Related Scripts

| Script | Relationship |
|--------|-------------|
| HSB_G-Truck | Parent container - stacks can be automatically assigned to trucks |

## Catalog Support

The script supports preset configurations through the hsbCAD catalog system:
- If an execute key matches a catalog name, properties are automatically loaded from the catalog
- This enables quick insertion of predefined stack sizes

## Technical Notes

- The stack geometry is cached in the script's `_Map` for performance optimization
- Changing any dimension property clears the cached geometry and triggers recalculation
- The script scans for existing HSB_G-Truck instances in model space to establish parent relationships
- Intersection detection uses the child origin body (a small box at the stack origin) against truck bodies
