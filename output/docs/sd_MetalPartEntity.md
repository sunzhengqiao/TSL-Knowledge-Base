# sd_MetalPartEntity

## Overview

| Property | Value |
|----------|-------|
| Script Type | O-Type (Object) |
| Version | 1.2 |
| Author | th@hsbCAD.de |
| Last Updated | 2011-03-11 |
| Category | Shop Drawing |
| Required Beams | 0 |
| Implicit Insert | Yes |

The `sd_MetalPartEntity` script is a **shop drawing dimension generator** that processes metal part collections and automatically creates dimension annotations. It analyzes the geometry of metal parts (composed of GenBeams, Beams, and associated tools) and generates comprehensive dimension requests for:

- **Extremes**: Overall bounding dimensions
- **Contours**: Assembly/component dimensions
- **Drills**: Hole locations with optional diameter annotations

This script is designed to be **appended to the ruleset of a multipage style** rather than manually inserted into a drawing. The Shop Drawing Engine executes it automatically when processing metal part collections.

## Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Testing Only | Can be manually inserted for debugging, not production use |
| Paper Space | Yes | Executed automatically by the Shop Drawing Engine |
| Shop Drawing | Yes | **Primary environment** - runs within shop drawing generation workflow |

## Prerequisites

- Must be added to a **multipage style ruleset** for automatic execution
- Requires a valid `MetalPartCollectionEnt` entity to be associated
- Works with:
  - GenBeams and Beams within the metal part collection
  - Perpendicular drills (type `_kADPerpendicular`)
  - Symbol TSL instances (containing "Symbol[]" map)

## Usage Guide

### Standard Workflow (Automatic Execution)

The script is typically executed automatically by the hsbCAD Shop Drawing Engine:

1. **Setup**: Add `sd_MetalPartEntity` to your multipage style ruleset
2. **Configure**: Open the Map I/O dialog to set dimension preferences
3. **Generate**: Run shop drawing generation on metal part collections
4. **Result**: Dimension annotations appear automatically on the generated sheets

### Manual Insertion (Testing/Debugging)

For testing purposes, the script can be manually inserted:

**Command**: `TSLINSERT` then select `sd_MetalPartEntity.mcr`

**Step 1: Select Entity**
```
Command Line: Select Entity:
Action: Click on the Metal Part Collection entity in the drawing
Note: The entity must be a valid CollectionEntity type
```

**Step 2: Specify Insertion Point**
```
Command Line: Specify Insertion Point:
Action: Click in the drawing to place the script entity
```

**Step 3: Configure via Map I/O**
```
Action: Right-click the inserted TSL and configure dimension settings
```

## Properties Panel Parameters

The following parameters are configurable through the **Map I/O dialog** (right-click > Properties when the TSL is selected in a ruleset):

### Dimension Line Offset Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Offset Dimline Contour | Double | 800 mm | Distance of contour/assembly dimension line from the metal part outline. Set to `0` to hide contour dimensions |
| Offset Dimline Extremes | Double | 1400 mm | Distance of overall/extreme dimension line from the metal part. Set to `0` to hide extreme dimensions |
| Offset Dimline Drills | Double | 200 mm | Distance of drill dimension line from the metal part. Set to `0` to hide drill dimensions |

**Recommended Layering Order**: Drills (closest) < Contour < Extremes (farthest)
- Example: Drills=200, Contour=800, Extremes=1400

### Drill Annotation Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Chain Content Drill | Dropdown | Chain Dimension | Controls the text content displayed at each drill dimension point |
| Diameter Units | Dropdown | DWG Unit | Sets the unit for diameter/radius text values |

### Chain Content Drill Options

| Value | Label Format | Description |
|-------|--------------|-------------|
| 0 | Chain Dimension | Standard chain dimension markers only (no diameter shown) |
| 1 | Chain Dimension with Diameter | Chain dimension with diameter value appended (e.g., "<> D12") |
| 2 | Diameter only | Only shows diameter symbol and value (e.g., "D12") |
| 3 | Diameter only at Start | Shows diameter once at the first drill point, then chain markers |

**Important**: When multiple drill diameters are detected in the same view, the script automatically adjusts the content mode:
- Mode 1 (Chain w/Diameter) → Falls back to Mode 0 (Chain only)
- Mode 3 (Diameter at Start) → Falls back to Mode 2 (Diameter only)

This prevents ambiguous labeling when drill holes have different sizes.

### Diameter Unit Options

| Value | Unit | Use Case |
|-------|------|----------|
| 0 | DWG Unit | Use the current drawing's unit setting (default) |
| 1 | m | Meters - for large-scale drawings |
| 2 | cm | Centimeters - common in European documentation |
| 3 | mm | Millimeters - most common for metal fabrication |
| 4 | in | Inches - for imperial/US projects |
| 5 | ft | Feet - for large-scale imperial drawings |

## Dimension Types Generated

The script creates three categories of dimensions using **stereotypes**:

### Extremes (Overall Dimensions)
- **Purpose**: Shows the total bounding box of the metal part
- **Placement**: Furthest from the part (Offset Dimline Extremes)
- **Views**: Generated for all three orthogonal views (X, Y, Z)

### Contour (Assembly Dimensions)
- **Purpose**: Shows positions of individual components within an assembly
- **Condition**: Only generated when >3 assembly points are detected
- **Alignment**: Limited to entities parallel/perpendicular to the collection's coordinate system
- **Placement**: Middle distance (Offset Dimline Contour)

### Drill (Hole Dimensions)
- **Purpose**: Shows locations and optionally diameters of drill holes
- **Filtering**: Only drills perpendicular to each view direction are dimensioned
- **Placement**: Closest to the part (Offset Dimline Drills)

## View Generation

The script generates dimensions for **three orthogonal views** based on the metal part collection's local coordinate system:

| View | Direction | Looking Along | Typical Use |
|------|-----------|---------------|-------------|
| Z View | vzView | Z-axis | Top/Bottom view |
| Y View | vyView | Y-axis | Front/Back view |
| X View | vxView | X-axis | Left/Right view |

Each view independently generates:
- Extreme dimensions (overall bounds)
- Contour dimensions (if assembly points exist)
- Drill dimensions (for holes parallel to view direction)

## Technical Processing Flow

```
1. Entity Validation
   └─ Check _Entity.length() > 0
   └─ Cast to MetalPartCollectionEnt
   └─ Verify collection validity

2. Data Collection
   └─ Extract GenBeams from collection definition
   └─ Analyze tools: filter perpendicular drills
   └─ Collect symbol TSL instances

3. View Loop (X, Y, Z)
   └─ Build shadow profile from beam bodies
   └─ Calculate extreme points via PlaneProfile.extentInDir()
   └─ Filter drills parallel to view direction
   └─ Detect multiple diameter groups

4. Dimension Generation
   └─ Create DimRequestPoint for extremes
   └─ Create DimRequestPoint for drills (with content formatting)
   └─ Create DimRequestPoint for contours (if >3 assembly points)
```

## Tips and Best Practices

### Controlling Dimension Visibility
To hide specific dimension types, set their offset to `0`:
- Hide extremes only: Set **Offset Dimline Extremes** = 0
- Hide contour dimensions: Set **Offset Dimline Contour** = 0
- Hide drill dimensions: Set **Offset Dimline Drills** = 0

### Preventing Dimension Overlap
Maintain proper spacing between dimension lines:
```
Recommended Ratios:
- Drills:    Base offset (e.g., 200 mm)
- Contour:   3-4x drill offset (e.g., 800 mm)
- Extremes:  6-7x drill offset (e.g., 1400 mm)
```

### Mixed Diameter Handling
When your metal part has multiple drill sizes:
- The script automatically detects this condition
- Content modes 1 and 3 are automatically converted to prevent confusion
- A message is reported: "Content changed to: [new mode]"

### Assembly Dimension Threshold
Contour/assembly dimensions only appear when there are **more than 3 assembly points**. This prevents unnecessary dimension clutter on simple single-component parts.

### Unit Consistency
For shop drawings intended for fabrication:
- Use **mm** (value 3) for metric drawings
- Use **in** (value 4) for imperial drawings
- Avoid "DWG Unit" if the drawing might be scaled differently than the fabrication standard

## Troubleshooting

### Problem: No dimensions appear

**Possible Causes:**
1. Script not properly attached to the metal part collection entity
2. All offset values set to 0
3. Entity is invalid or empty

**Solutions:**
1. Verify the TSL is in the correct ruleset
2. Check offset settings in Map I/O dialog
3. Run with debug flag to inspect entity contents

### Problem: Drill labels show wrong diameter

**Possible Cause:**
Multiple drill diameters detected - script automatically changed the content mode.

**Solution:**
Check the command line for "Content changed to" messages. Use Mode 0 (Chain Dimension) or Mode 2 (Diameter only) for predictable results with mixed diameters.

### Problem: Some views missing dimensions

**Possible Cause:**
Internal view flags may be disabled.

**Solution:**
The script has internal flags `showViewX`, `showViewY`, `showViewZ` and `showDrillViewX/Y/Z`. These default to `true`. If modified in custom implementations, verify they are enabled.

### Problem: Contour dimensions not appearing

**Possible Cause:**
- Fewer than 4 assembly points detected
- Components not aligned with collection coordinate system

**Solution:**
The assembly dimension logic requires:
1. More than 3 assembly points
2. Components parallel or perpendicular to the coordinate system axes

## Related Scripts

| Script | Relationship | Purpose |
|--------|--------------|---------|
| MetalPartCollectionEnt | Parent Entity | The collection entity this script processes |
| sd_* scripts | Related | Other shop drawing dimension generators |
| DimRequestPoint | API Class | The dimension request objects created by this script |
| DimRequestPLine | API Class | Used for outline visualization in debug mode |

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.2 | 2011-03-11 | th@hsbCAD.de | Bugfix for assembly dimensions alignment; metal part collection now supports GenBeams (not only Beams) |
| 1.1 | 2010-10-25 | th@hsbCAD.de | Assembly dimensions limited to entities parallel/perpendicular to the entity coordinate system |
| 1.0 | 2010-10-19 | th@hsbCAD.de | Initial version |

## API Reference

### Key Methods Used

| Method | Purpose |
|--------|---------|
| `MetalPartCollectionEnt.coordSys()` | Gets the local coordinate system for view generation |
| `MetalPartCollectionDef.genBeam()` | Retrieves GenBeams from the collection |
| `GenBeam.analysedTools()` | Gets analyzed tool array for drill extraction |
| `AnalysedDrill.filterToolsOfToolType()` | Filters tools by perpendicular type |
| `Body.shadowProfile()` | Creates 2D projection for dimension calculation |
| `PlaneProfile.extentInDir()` | Calculates bounding extremes in a direction |
| `DimRequestPoint.setStereotype()` | Categorizes dimension (Extremes/Drill/Contour) |
| `DimRequestPoint.addAllowedView()` | Specifies valid view directions |
| `addDimRequest()` | Submits dimension request to shop drawing engine |

### Stereotypes Used

| Stereotype | Color Convention | Purpose |
|------------|------------------|---------|
| Extremes | Standard | Overall bounding dimensions |
| Contour | Standard | Assembly/component positions |
| Drill | Standard | Hole locations and diameters |
