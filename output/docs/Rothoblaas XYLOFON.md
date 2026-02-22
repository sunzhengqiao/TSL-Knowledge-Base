# Rothoblaas XYLOFON

## Overview

The Rothoblaas XYLOFON script creates acoustic noise-absorbing strips along panel edges for soundproofing applications. XYLOFON is a polyurethane-based sound insulation product manufactured by Rothoblaas, designed to reduce sound transmission between timber structural elements.

This tool attaches XYLOFON absorber strips to panel edges (including edges created by beam cuts) and automatically adjusts the panel geometry to accommodate the absorber thickness. The script supports multiple XYLOFON hardness types and positioning options.

| Property | Value |
|----------|-------|
| Script Type | O-Type (Object) |
| Version | 1.1 |
| Author | florian.wuermseer@hsbcad.com |
| DXA Export | Enabled |
| Implicit Insert | Enabled |

## Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Creates 3D geometry and modifies panels |
| Paper Space | No | Not applicable |
| Shop Drawing | No | This is a model detailing script |

## Prerequisites

- One or more valid SIP (Structural Insulated Panel) entities must exist in the drawing
- Panels should have defined edges (outline or beam cut edges)
- hsbCAD environment with proper unit settings

## Usage

### Initial Insertion

1. Run the script: Command `TSLINSERT` then select `Rothoblaas XYLOFON.mcr`
2. A dialog appears allowing you to select the XYLOFON type and position
3. Select one or more panels when prompted
4. Click points on the panel edges where you want to attach the absorber strips
5. Press Enter to confirm - the script clones itself for each selected panel

### Adding Absorbers to Existing Instance

1. Right-click on an existing XYLOFON instance
2. Select **Add XYLOFON** from the context menu
3. Click points on additional panel edges to attach absorber strips
4. Press Enter to complete

### Removing Absorbers

1. Right-click on an existing XYLOFON instance
2. Select **Remove XYLOFON** to remove absorbers from specific edges (then click on those edges)
3. Or select **Remove XYLOFON from all edges** to clear all attached absorbers (this also deletes the instance)

### Double-Click Behavior

Double-clicking an existing instance triggers the "Add XYLOFON" workflow for quick edge additions.

## Parameters

### Type (OPM Property)

| Option | Description | Color | Hardness Level | Small Size Article | Large Size Article |
|--------|-------------|-------|----------------|-------------------|-------------------|
| XYLOFON 35 | Softest | 7 (White) | Softest | D82411 | D82421 |
| XYLOFON 50 | Medium-soft | 2 (Yellow) | Soft | D82412 | D82422 |
| XYLOFON 70 | Medium | 30 (Orange) | Medium | D82413 | D82423 |
| XYLOFON 80 | Medium-hard | 1 (Red) | Hard | D82414 | D82424 |
| XYLOFON 90 | Hardest | 202 (Magenta) | Hardest | D82415 | D82425 |

The type selection determines the article number for material lists and BOM generation. Choose the appropriate hardness based on structural load requirements and sound insulation specifications.

### Absorber Position (OPM Property)

| Option | Description | Article Size | Visual Position |
|--------|-------------|--------------|-----------------|
| 100mm reference face | 100mm wide strip at the reference (bottom) face | Small | Bottom 100mm of panel thickness |
| 100mm opposite face | 100mm wide strip at the opposite (top) face | Small | Top 100mm of panel thickness |
| 100mm centered | 100mm wide strip centered on panel thickness | Small | Centered within panel thickness |
| full width | Strip covers the full panel height/thickness | Large | Entire panel thickness |

### Fixed Dimensions

| Parameter | Value |
|-----------|-------|
| Absorber Thickness | 10mm |
| Absorber Width (100mm options) | 100mm |

## Context Menu

| Menu Item | Action |
|-----------|--------|
| Add XYLOFON | Add absorber strips to additional panel edges |
| Remove XYLOFON | Remove absorber strips from selected edges |
| Remove XYLOFON from all edges | Remove all absorber strips and delete the instance |

## Workflow Details

### Edge Detection

The script automatically detects three types of edges:

| Edge Type | Code Value | Description | Modification Method |
|-----------|------------|-------------|---------------------|
| Outline edges | 0 | The perimeter edges of the panel | Panel edge stretching |
| Opening edges | 1 | Edges around openings in the panel | Panel edge stretching |
| Beam cut edges | 2 | Edges created by throughout beam cuts (housings, seat cuts) | Additional beam cut applied |

### Panel Modification

When adding absorbers:
- **Outline/opening edges**: The panel edge is stretched inward by the absorber thickness (10mm)
- **Beam cut edges**: A new beam cut is applied to create space for the absorber

When removing absorbers:
- The panel edges are restored to their original positions

### Corner Handling

The script automatically handles:
- **Convex corners**: Absorber strips are cut to meet properly
- **Concave corners**: Absorber strips are extended appropriately
- **Adjacent absorbers**: Strips at connected edges are joined correctly

The script determines corner convexity by analyzing the dot product between edge direction vectors and adjacent edge normal vectors.

### Visual Indicators

During debug mode, the script displays:
- Edge vectors in color 5
- Edge normal vectors in color 3
- Edge direction vectors in color 1
- Edge type numbers at edge midpoints

## Hardware Output

The script generates hardware components for BOM (Bill of Materials):

| Property | Value |
|----------|-------|
| Category | Absorber |
| Manufacturer | Rothoblaas |
| Material | Polyurethane |
| Article Number | D82411-D82425 (depending on type and width) |

### Hardware Component Properties

| Property | Description |
|----------|-------------|
| DScaleX | Total length of all absorber segments |
| DScaleY | Width (100mm for small, full panel thickness for large) |
| DScaleZ | Thickness (10mm) |

Hardware components are recalculated when:
- Instance is first created (_bOnDbCreated)
- Add XYLOFON trigger is activated
- Remove XYLOFON trigger is activated
- Double-click is performed
- Type or Position properties are changed

## Tips

1. **Catalog Presets**: You can save frequently used configurations to the catalog and recall them using the execute key during insertion. Use `_LastInserted` as fallback if the execute key is not found.

2. **Debug Mode**: Enable debug mode by adding "DEBUGTSL" or the script name "Rothoblaas XYLOFON" (case-insensitive) to the project special string to visualize edge detection and vector directions.

3. **Beam Cut Edges**: The script processes throughout beam cuts. Partial beam cuts are not currently supported (noted as TODO in script).

4. **Hyperlink**: Each instance includes a hyperlink to the Rothoblaas XYLOFON product page (http://www.rothoblaas.com/products/soundproofing/soundproofing-profiles/xylofon) for quick reference.

5. **Color Coding**: Each XYLOFON type is displayed in a distinct color for easy visual identification in the model.

6. **Multiple Panels**: During insertion, you can select multiple panels and apply absorbers to all of them in one operation.

7. **Edge Selection**: Click anywhere on an edge plane to select it - the script finds the closest matching edge automatically using a tolerance of 0.1mm.

8. **Avoid Overlap**: The script prevents adding duplicate absorbers to edges that already have XYLOFON attached and reports a message when attempting to do so.

9. **Insert Cycle Protection**: The script automatically erases itself if the insert cycle count exceeds 1, preventing duplicate instances.

10. **Group Assignment**: The script automatically assigns itself to the 'I' (Isolated) group of the associated SIP entity.

## Error Handling

The script displays error messages and deletes itself in the following cases:

| Condition | Error Message |
|-----------|---------------|
| No valid panel selected | "No valid panel selected - Tool will be deleted" |
| Panel outline vertices not detected | "Panel's outline vertices weren't properly detected - Tool will be deleted" |
| Panel outline not detected | "Panel outline not properly detected - Tool will be deleted" |
| Edge collection failure | "Collection of outline and beamcuts failed - Tool will be deleted" |
| Attempting to add duplicate absorber | "Xylofon absorber is already attached to this edge" |

## Technical Details

### Coordinate System

The script uses the SIP's local coordinate system:
- **vecXSip**: X-axis direction
- **vecYSip**: Y-axis direction
- **vecZSip**: Z-axis (thickness) direction

Reference planes are calculated based on the selected position option.

### Data Persistence

The script stores edge data in its internal Map using the key "mapEdges" containing:
- `plXyloEdges`: PLine geometry of each absorber edge
- `vecXyloEdges`: Z-direction vectors
- `vecXyloEdgeDirects`: Edge direction vectors
- `vecXyloEdgeNormals`: Edge normal vectors
- `vecXyloEdgeNormalPrevs`: Previous edge normal vectors
- `vecXyloEdgeNormalNexts`: Next edge normal vectors
- `nXyloEdgeTypes`: Edge type classification (0, 1, or 2)

### Skipped Beam Cuts

The script intentionally skips beam cuts that were created by other XYLOFON instances to avoid interference and double-processing.

## FAQ

**Q: What happens if my panel geometry changes?**
A: Use the "Add XYLOFON" command (or double-click the instance) to recalculate the absorber dimensions and positions to fit the new panel geometry.

**Q: Can I use this on regular beams?**
A: No, this script is specifically designed for SIP (Structural Insulated Panel) entities only. Regular beams are not supported.

**Q: How does the script handle corners?**
A: The script automatically calculates intersections for both convex and concave corners, mitering the absorber material appropriately.

**Q: Where does the length information appear?**
A: The script generates a hardware component (HardWrComp) that lists the total length and article number in your BOM/Material list.

**Q: What is the difference between small and large article numbers?**
A: Small size articles (D82411-D82415) are for 100mm width options, while large size articles (D82421-D82425) are for full width coverage.

**Q: What beam cut types are supported?**
A: The script supports throughout beam cuts (cuts that go completely through the panel). Partial beam cuts are not currently supported.

**Q: How does the script determine which edge I clicked on?**
A: The script projects your click point onto candidate edge planes and finds the closest matching edge within a small tolerance (0.1mm).

## Related Scripts

- Rothoblaas Typ F70 - Another Rothoblaas sound insulation product
- Rothoblaas Typ R - Rothoblaas acoustic profiles
- Hilti-Verteilung - Hilti fastener distribution
- GenericHanger - Generic hardware connections
