# HSB_G-Truck

This TSL script defines the bounding box of a truck and is used as a placeholder for stacks in timber construction logistics planning. It creates a 3D visual representation of a truck's cargo area dimensions to help plan and visualize how prefabricated elements will be loaded.

## Script Information

| Property | Value |
|----------|-------|
| **Version** | 1.00 |
| **Last Modified** | 04.04.2019 |
| **Author** | Anno Sportel (support.nl@hsbcad.com) |
| **Script Type** | O (Object) |

## Script Type Explanation

This is an **O-Type (Object)** script. Object scripts create standalone entities in the drawing that are not directly attached to beams or elements. In this case, the truck placeholder is an independent 3D box that can be positioned anywhere in the model space to represent a truck's cargo area for logistics planning.

## User Properties

The following properties are available in the AutoCAD Properties Palette (OPM) when the truck object is selected:

| Property | Type | Default Value | Description |
|----------|------|---------------|-------------|
| **Length** | PropDouble | 21000 mm | The length of the truck cargo area (along the X-axis). Default represents a standard semi-trailer length. |
| **Width** | PropDouble | 2200 mm | The width of the truck cargo area (along the Y-axis). Default represents standard truck width. |
| **Height** | PropDouble | 3000 mm | The height of the truck cargo area (along the Z-axis). Default represents standard cargo height clearance. |

## Usage Workflow

### Step 1: Insert the Script

1. Start the TSL script `HSB_G-Truck` from the hsbCAD menu or command line
2. If no execute key (catalog preset) is specified, a dialog window will appear allowing you to configure the truck dimensions before placement

### Step 2: Configure Dimensions (Optional)

- If the dialog appears, adjust the truck dimensions as needed for your specific logistics requirements
- The dialog allows you to set custom Length, Width, and Height values

### Step 3: Place the Truck

1. When prompted with "Select a position", click in the drawing to place the truck's origin point
2. The truck bounding box will be created at the selected location, aligned with the World Coordinate System (WCS)

### Step 4: Modify Properties (Optional)

After placement, you can modify the truck dimensions at any time:
1. Select the truck object in the drawing
2. Open the Properties Palette (Ctrl+1 or OPM command)
3. Adjust Length, Width, or Height values as needed
4. The truck geometry will automatically recalculate when these properties change

## Visual Appearance

The truck bounding box is displayed in **Color 3 (Green)** in the drawing, making it easily distinguishable from timber elements and other objects.

## Catalog Support

This script supports catalog presets. If executed with a valid catalog key, the truck dimensions will be automatically loaded from the catalog without showing the configuration dialog. This is useful for standardizing truck dimensions across a project or company.

## Technical Notes

- The truck body is cached in the script's internal Map for performance optimization
- Changing any dimension property triggers a full recalculation of the truck geometry
- The truck is aligned to the World Coordinate System (WCS), regardless of the current User Coordinate System (UCS)
- The origin point (_Pt0) defines the corner of the truck bounding box

## Typical Use Cases

1. **Logistics Planning**: Visualize how prefabricated wall panels, roof trusses, or floor cassettes will fit on transport trucks
2. **Stack Arrangement**: Plan the arrangement of multiple stacks within the truck cargo area
3. **Shipping Documentation**: Create visual representations for shipping and logistics documentation
4. **Clearance Checking**: Verify that assembled elements fit within standard truck dimensions before manufacturing
