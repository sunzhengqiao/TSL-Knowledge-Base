# VisualizeOriginalBody

## Overview

VisualizeOriginalBody displays the original 3D geometry of entities imported from external sources (e.g., IFC, STEP, or custom importers). It retrieves the unmodified body stored in the entity's "HsbImportData" MapX during import and renders it for comparison with the current processed geometry. This script is useful for verifying import accuracy, troubleshooting geometry issues, and visualizing invalid bodies that failed processing.

## Usage Environment

| Environment | Supported |
|------------|-----------|
| **Model Space** | Yes (overlays original geometry on imported entities) |
| **Paper Space** | No |
| **Script Type** | Object (Type O) - Diagnostic visualization tool |
| **User Interaction** | Low (select entity, adjust display) |

## Prerequisites

- **Imported Entity** with "HsbImportData" MapX stored during import
  - The MapX must contain a `Body` key with the original geometry
  - Typically created by:
    - IFC import workflows
    - STEP/SAT file imports
    - Custom bodyImporter scripts
- **Entity Types**: Works with any entity that stores original body data (GenBeams, Beams, Sheets, TslInsts, etc.)

## Usage Steps

1. **Start Script**: Run VisualizeOriginalBody command
2. **Select Entity**: Click on an imported entity that contains original body data
3. **Automatic Display**: The original body appears overlaid in **red** (color 2)
4. **Adjust Visualization** (optional):
   - Change **Visual style invalid body** property for invalid bodies
   - Adjust **Offset** and **Offset Direction** to separate original from current geometry
5. **Compare**: Visually compare the red original body with the entity's current processed geometry

### Converting to Permanent Body Importer

If you need to preserve the original body permanently:
1. Right-click → **Convert to body importer**
2. The script converts itself into a `bodyImporter` TSL instance
3. The new instance stores the body independently of the source entity

## Properties Panel Parameters

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Visual style invalid body** | Dropdown | "Solid" | Rendering mode for invalid bodies: "Wireframe", "Shell", or "Solid" |
| **Offset** | Double | 0mm | Distance to move the original body for comparison visibility |
| **Offset Direction** | Dropdown | "Z" | Direction for offset: "X", "-X", "Y", "-Y", "Z", "-Z" (relative to entity coordinate system) |

## Right-Click Menu

| Command | Function |
|---------|----------|
| **Convert to body importer** | Converts this visualization instance into a permanent `bodyImporter` TSL that stores the body independently |

## Settings Files

This script does not use external XML settings files. Original body data is read from the entity's "HsbImportData" MapX submap.

### Expected MapX Structure

The source entity must have this MapX structure:
```
EntityMapX
└── HsbImportData
    └── Body (Body type)
```

For invalid bodies (ACIS failure), the structure is:
```
EntityMapX
└── HsbImportData
    └── Body (PlaneProfile[] list representing face loops)
```

## Tips

- **Color Coding**: Original bodies always display in **red** (color 2) for easy identification
- **Layer Assignment**: The visualization script inherits the source entity's layer name
- **Invalid Bodies**: If import created an invalid ACIS body, the script renders face loops as PlaneProfiles:
  - **Wireframe**: Shows only edges
  - **Shell**: Shows surface outlines
  - **Solid**: Fills the profiles (may not represent true 3D volume)
- **Offset Usage**: Use **Offset** with **Offset Direction** to visually separate original from modified geometry:
  - Example: Offset = 100mm, Direction = "Z" moves original body 100mm up
  - Useful for side-by-side comparison
- **Coordinate System**: All offset directions are relative to the **entity's local coordinate system**, not World
- **Text Label**: Script displays its name at the entity origin for identification

## FAQ

### What does "No original body found for entity" mean?

The selected entity does not have "HsbImportData" stored in its MapX. This occurs when:
- Entity was not created through an import process
- Import script did not preserve original geometry
- MapX was deleted or corrupted
- Entity was created natively in hsbCAD

### Why is my body showing as wireframe/shell instead of solid?

The original import process created an invalid ACIS body (geometry failed validation). The script extracts face loops as PlaneProfiles and renders them. Change **Visual style invalid body** to:
- **Solid**: Fill the face loops (best for visualization)
- **Shell**: Show only surface boundaries
- **Wireframe**: Show only edges (debugging)

### Can I edit the original body?

No. VisualizeOriginalBody is read-only. To work with the original geometry:
1. Right-click → **Convert to body importer**
2. The resulting `bodyImporter` instance can be further processed

### What is the difference between this and bodyImporter?

- **VisualizeOriginalBody**: Temporary diagnostic tool, reads from source entity's MapX
- **bodyImporter**: Permanent entity that stores and manages the body independently

Convert when you need persistent storage.

### Why doesn't the offset work?

Check:
1. **Offset** value is non-zero
2. **Offset Direction** is correct for your viewing angle
3. Entity coordinate system matches your expectation (entity may be rotated)

### Can I use this on entities from Revit/Archicad/Tekla imports?

Yes, if the import workflow preserved original bodies in the "HsbImportData" MapX. Check with your import script documentation.

### How do I know if my entity has import data?

Method 1 (Visual):
- Insert VisualizeOriginalBody on the entity
- If script shows "No original body found", entity lacks data

Method 2 (TSL):
```c
Entity ent = getEntity();
Map importMap = ent.subMapX("HsbImportData");
if (importMap.length() > 0) {
    // Has import data
}
```

### What does "Invalid Body" in the label mean?

The text label at the entity origin displays "Invalid Body" when the stored geometry is represented as PlaneProfile face loops instead of a valid ACIS solid body. This typically indicates:
- Import geometry had ACIS modeling errors
- Non-manifold surfaces
- Self-intersecting faces
- Extremely complex geometry that exceeded ACIS limits

### Can I compare multiple import sources?

Yes. Insert one VisualizeOriginalBody instance per source entity. Use the **Offset** feature to separate overlapping bodies for visual clarity.

### Why does "Convert to body importer" erase the current script?

The conversion process:
1. Creates a new `bodyImporter` TSL instance
2. Copies the original body data to the new instance's Map
3. Erases the VisualizeOriginalBody instance (no longer needed)

This prevents duplication and clarifies that the body is now permanently stored.

### How does this help troubleshoot import issues?

Common use cases:
1. **Geometry Loss**: Compare red original vs. processed geometry to identify missing features
2. **Orientation Errors**: Check if original body is rotated/positioned correctly
3. **Scaling Issues**: Verify original dimensions match expected values
4. **Processing Failures**: For invalid bodies, examine face loop structure to diagnose failure cause
5. **Validation**: Confirm import preserved all source geometry before deletion of source files

### Can I change the visualization color from red?

Not directly in this script. The color is hardcoded to color index 2 (red) for consistency. To change:
1. Convert to bodyImporter
2. Modify the bodyImporter script's Display color property
