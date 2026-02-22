# T-Connection

Creates T-connection joints between timber beams, automatically stretching male beams to meet female beams and optionally creating mortise cuts in the female beam.

## Overview

The T-Connection tool establishes perpendicular connections between timber members where one beam (the "male" beam) terminates at a right angle against another beam (the "female" beam). This is a fundamental joint type in timber frame construction used for studs into plates, purlins into rafters, and similar perpendicular connections.

Key features:
- **Automatic beam stretching**: Male beams are automatically extended to meet the female beam surface
- **Beam pack support**: Multiple parallel male beams are automatically grouped and connected as a pack
- **Mortise cutting**: When a depth/distance is specified, the tool creates corresponding cuts in the female beam
- **Painter filtering**: Beams can be filtered using PainterDefinition rules for selective connection
- **Element mode**: Can process all beams within an Element automatically
- **Dynamic recalculation**: Connections update automatically when linked beams move

| Property | Value |
|----------|-------|
| **Script Type** | O-Type (Object-based tool) |
| **Version** | 1.5 (30.08.2023) |
| **Keywords** | T, T-connection, beampack, pack |
| **Category** | Framing Connections |

## Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary operating environment |
| Paper Space | No | Not designed for 2D layout views |
| Shop Drawing | No | Does not generate shop drawing details |

## Prerequisites

- At least two beams must be selected: one male beam and one female beam
- The male and female beams must NOT be parallel (they must form a T-junction)
- Beams should be positioned such that extending the male beam axis intersects the female beam body
- No specific settings files required (uses standard Painter catalogs)

## Usage

### Step 1: Launch Script
Command: `TSLINSERT` then select `T-Connection` from the list, or use:
```
hsb_ScriptInsert "T-Connection"
```

### Step 2: Configure Parameters
A dialog appears for setting connection properties:
- **Depth/Distance**: Mortise depth (0 = flush butt joint)
- **Side Gap**: Clearance around mortise
- **Tool Alignment**: Cut orientation reference
- **Painter filters**: Optional beam type filters

### Step 3: Select Male Beam(s)
```
Command Line: Select male beam(s) or element(s)
```
Click on the beam(s) that will be extended to meet the main beam (e.g., studs, purlins). You can also select an entire Wall/Floor/Roof Element.

**Note**: If you select an Element, the script automatically finds all T-connections within it and skips Step 4.

### Step 4: Select Female Beams (Beam Mode Only)
```
Command Line: Select female beams
```
Click on the main beam(s) that will receive the connection (e.g., top plate, rafter, header).

### Step 5: Automatic Processing
The tool creates individual T-Connection instances for each valid beam pair or beam pack. The male beams are stretched to meet the female beams, and mortise cuts are applied if the Depth parameter is set.

### Operation Modes

| Mode | Trigger | Behavior |
|------|---------|----------|
| **Beam Mode** | Select individual beams | Manual male-female pairing |
| **Element Mode** | Select an Element | Auto-detect all T-connections within |
| **Beam Pack Mode** | Select multiple parallel beams | Group parallel beams as single connection unit |

## Parameters

### Primary Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Depth / Distance** | Length | 0 | The embedding depth of the male beam into the female beam. When set to 0, the male beam ends flush with the female beam surface. Positive values create a mortise pocket in the female beam. |
| **Side Gap** | Length | 0 | Gap/clearance between the male beam profile and the mortise edges in the female beam. Useful for assembly tolerances (e.g., 1-2mm). |
| **Tool Alignment** | Selection | Female beam | Determines which beam's coordinate system controls the cut orientation. |

#### Tool Alignment Options

| Option | Behavior |
|--------|----------|
| **Female beam** | The mortise cut aligns with the female beam's local axes and cuts across the full width. Best for standard perpendicular connections. |
| **Male beam** | The mortise cut follows the male beam's orientation and matches its width exactly. Useful when male beams are angled or when you need a tight-fitting slot. |

### Painter Filters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Male beams** | Painter Selection | Disabled | Filter for male beam selection using PainterDefinition rules. When set, only beams matching the painter criteria are processed. |
| **Female beams** | Painter Selection | Disabled | Filter for female beam selection using PainterDefinition rules. Defines which beams can act as the receiving member. |

### Hidden Properties (Catalog/Debug Mode)

| Parameter | Description |
|-----------|-------------|
| PainterMaleStream | Internal storage for male beam painter configuration (managed via catalogs) |
| PainterFemaleStream | Internal storage for female beam painter configuration (managed via catalogs) |

## Context Menu

Right-click on a T-Connection instance to access these commands:

| Menu Item | Description |
|-----------|-------------|
| **Add Beams In Pack** | Add additional beams to an existing beam pack. Prompts for beam selection. |
| **Add Female Beams** | Add additional female beams to the connection. Useful when multiple female beams should receive the same male beam. |
| **Reset + Erase** | Remove the T-Connection instance and convert dynamic cuts to static geometry. Also triggered by double-clicking the instance. |

## Visual Indicators

When a T-Connection is active, visual indicators display in the model:

| Indicator | Meaning |
|-----------|---------|
| Circle at connection point | Male beam end position (shown when Depth = 0) |
| Cross marks (+) | Mortise extent in X and Y directions |
| Vertical line | Mortise depth indicator |
| Colored axes | Cut orientation (X=red, Y=green, Z=blue) |

## Tips

### Workflow Efficiency
- **Element Mode for Speed**: When working with framed wall or floor assemblies, selecting the Element automatically finds all T-connections, saving time compared to manual selection.

### Joint Configuration
- **Depth/Distance Values**:
  - Value of 0: Creates a simple butt joint where the male beam touches but does not penetrate the female beam
  - Positive values: Creates embedded connections with mortise cuts in the female beam

- **Side Gap for Tolerances**: If parts are fitting too tightly for assembly, increase the Side Gap parameter (e.g., 1-2mm) to add clearance around the mortise.

### Beam Packs
- When multiple parallel beams (such as double studs or king studs) need to connect to the same female beam, they are automatically grouped as a pack and managed by a single instance.
- Use the "Add Beams In Pack" context menu to add beams to an existing pack.

### Filtering
- **Painter Filtering**: Use PainterDefinition filters to limit which beams are considered for male or female roles. This is helpful when you want to exclude certain beam types (like blocking or cripples) from automatic connection.

### Tool Alignment Selection
- **"Female beam" alignment**: The mortise cut aligns with the female beam's local axes and cuts across the full width. Best for standard perpendicular connections.
- **"Male beam" alignment**: The mortise cut follows the male beam's orientation and matches its width exactly. Useful when male beams are angled or when you need a tight-fitting slot.

### Catalog Presets
- Save your preferred settings to the TSL catalog for quick reuse.
- The tool supports loading configurations via the Execute Key for automated workflows.

### Dynamic Behavior
- **Recalculation**: The tool automatically recalculates when linked beams move. Dependencies are tracked so the connection updates dynamically.
- **Copying Support**: T-Connection instances can be copied along with their associated beams. The tool maintains proper beam references after copy operations.

## Troubleshooting

| Problem | Cause | Solution |
|---------|-------|----------|
| Script disappears immediately | Invalid beam geometry | Ensure male beam axis intersects female beam volume; check beams are not parallel |
| Mortise not created | Depth = 0 | Set Depth/Distance to a positive value |
| Cut too tight for assembly | No side gap | Add 1-2mm Side Gap for tolerance |
| Wrong cut orientation | Tool Alignment incorrect | Switch between "Female beam" and "Male beam" alignment |
| Connection not detected | Beams are parallel | T-Connection requires non-parallel beams |
| Instance enters wait state | Element has no valid beams | Ensure beams in element are not in panhand state |

## FAQ

**Q: Why did the script disappear immediately after I placed it?**
A: The script performs an automatic validity check. If the male beam axis does not physically intersect the female beam volume, or if the beams are parallel, the script erases itself. Check your beam alignment and ensure proper positioning.

**Q: How do I make the cut wider than the male beam?**
A: Change the **Tool Alignment** property to "Female beam". This calculates the cut width based on the main beam's dimensions rather than the incoming beam.

**Q: Can I use this on multiple studs at once?**
A: Yes. You can window-select multiple male beams, then select the single female plate. The tool creates separate instances for each connection or groups parallel beams into packs.

**Q: What happens if I double-click the T-Connection?**
A: Double-clicking triggers the "Reset + Erase" action, which converts the dynamic connection into static cuts and removes the TSL instance.

**Q: How do I add more beams to an existing pack?**
A: Right-click on the T-Connection instance and select "Add Beams In Pack", then select the additional beams.

**Q: Can the connection handle angled beams?**
A: Yes, but the beams must not be parallel. The tool uses the "Tool Alignment" setting to determine how to orient the mortise cut for non-perpendicular connections.

## Technical Notes

### Beam Pack Detection
The script uses `Beam().composeBeamPacks()` to automatically group parallel male beams. This allows multiple studs or members to be processed as a single unit with shared female beam connections.

### Intersection Validation
Version 1.5 (HSB-19830) improved the T-connection test to only validate when the male beam axis actually intersects the female beam body, preventing false positive connections.

### Dependency Tracking
The script uses `setDependencyOnEntity()` to maintain references to both male and female beams, ensuring automatic recalculation when either beam is modified.

### Cut Operations
- Uses `Cut` tool for beam stretching (dynamic, recalcuates)
- Uses `BeamCut` tool for mortise creation (can be converted to static via "Reset + Erase")

## Related Scripts

| Script | Purpose |
|--------|---------|
| `hsbBlocking` | Blocking between studs |
| `hsbBracing` | Diagonal bracing connections |
| `hsbBeamCornerConnection` | Corner connections between beams |
| `GA-T` | Generic angle bracket T-connection |

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.5 | 30.08.2023 | HSB-19830: T-connection test only if male axis intersects female beam |
| 1.4 | 15.05.2023 | Property value renamed, debug improved |
| 1.3 | 12.05.2023 | Wait state for beams without panhand state |
| 1.2 | 18.04.2023 | Support copying of beam with TSL instance |
| 1.1 | 21.02.2023 | Use quader for envelope of female beam |
| 1.0 | 22.12.2022 | Initial release |
