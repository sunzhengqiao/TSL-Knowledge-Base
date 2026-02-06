# hsbEntityTag.mcr

## Overview
This script automatically generates smart tags and labels for timber elements (beams, panels, and hardware) in both 3D models and 2D shop drawings. It displays dynamic data such as quantities, dimensions, and custom properties based on your selection criteria.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used for 3D model tagging or preparing MultiPage views. |
| Paper Space | Yes | Used for creating labels in Shop Drawings and detail views. |
| Shop Drawing | Yes | Fully supported; detects viewports and section contexts. |

## Prerequisites
- **Required Entities**: GenBeam, Element, MasterPanel, MetalPartCollectionEnt, FastenerAssemblyEnt, or MultipageSheet.
- **Minimum Beam Count**: 0 (Can tag single entities or empty sets depending on configuration).
- **Required Settings**: A valid Catalog entry for DimStyle configuration to format the output text correctly.

## Usage Steps

### Step 1: Launch Script
1.  Run the `TSLINSERT` command in AutoCAD.
2.  Select `hsbEntityTag.mcr` from the list of available scripts.

### Step 2: Select Entity (Condition Dependent)
*If the **Key** property is NOT set to "Visible Set of Entities":*
```
Command Line: Select entity
Action: Click on a beam, panel, or element in the drawing to define the reference for the tag.
```

### Step 3: Define Insertion Point
*If the **Key** property is NOT set to "Visible Set of Entities":*
```
Command Line: Insert location
Action: Click in the drawing where you want the tag label to appear.
```

### Step 4: Set Text Size
```
Command Line: Text height <default>:
Action: Type a number (in mm) and press Enter, or press Enter to accept the default size.
```

### Step 5: Apply Filters (Optional)
```
Command Line: [Painter filter]
Action: Click on the "[Painter filter]" keyword in the command line to open a dialog and select specific Painter filters to include in the tag count.
```

### Step 6: Handle XRefs (Conditional)
*If External References or Blocks are detected and the **XRef Selection** property is enabled:*
1.  A dialog titled "Select XRef/Block content" will appear.
2.  Select the desired XRefs or Blocks from the list.
3.  Confirm the selection.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Key | dropdown | Visible Set of Entities | Determines how the script selects entities to tag (e.g., all visible, by filter, by ShowSet, or manual selection). |
| Entity Filter | text | "" | The name of the Painter filter to use if Key is set to "Entity Filter". |
| ShowSet | text | "" | The name of the ShowSet to use if Key is set to "Set of Entities". |
| Placement | dropdown | Default | Strategy for positioning the tag text and leader (e.g., Default, Section-aligned, Centroid). |
| TextHeight | double | 2.5 | The height of the text in the tag (in mm). |
| LeaderStyle | dropdown | Standard | Visual style of the leader line (None, Single, Multi, Dot, Arrow). |
| Shape | dropdown | None | Background shape drawn behind the text (None, Rectangle, Revision Cloud, Triangle). |
| Transparency | int | 0 | Opacity level of the background shape (0 = Solid/Opaque, 100 = Fully Transparent). |
| EqualityFormat | string | "" | Logic for grouping entities (e.g., "Length" to group only beams of the same length). Affects the calculated Quantity. |
| TextOverride | string | "" | Manual text to display instead of automatic data. If empty, the script calculates dynamic data. |
| XRefSelection | int | 0 | Enables (1) or disables (0) the ability to select entities nested within External References or Blocks. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (Standard TSL Context) | Allows standard script recalculation or property editing via the Properties Palette. |

## Settings Files
- **Filename**: Catalog Entry (defined in hsbCAD configuration)
- **Location**: Company or Install path (Varies by setup)
- **Purpose**: Defines the DimStyle and text formatting used to display the tag content (e.g., how dimensions or quantities are formatted).

## Tips
- **Dynamic Quantities**: If you want the tag to count all identical items in a view, leave the **Key** as "Visible Set of Entities" and ensure the **EqualityFormat** matches the criteria you care about (e.g., "Length,Width,Height").
- **Static Labels**: Use the **TextOverride** property to create static notes or stamps without linking them to specific element data.
- **Background Shapes**: Use the **Shape** and **Transparency** properties to make tags stand out against complex drawing backgrounds.

## FAQ
- **Q: My tag shows "Qty: 1" but I see 10 identical beams. Why?**
  - **A**: Check your **EqualityFormat** property. If it is empty, the script might be treating every beam as unique. Add the relevant properties (e.g., "Length") to group identical beams together.
- **Q: How do I tag elements inside an XRef?**
  - **A**: Set the **XRefSelection** property to `1` before inserting the script. You will then be prompted to select which XRef content to include.
- **Q: Can I change the tag position without moving the text manually?**
  - **A**: Yes, change the **Placement** property in the Properties Palette to switch between automatic alignment strategies (e.g., Centroid vs. Section-aligned).