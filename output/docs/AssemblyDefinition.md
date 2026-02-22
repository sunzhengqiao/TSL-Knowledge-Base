# AssemblyDefinition

## Overview

Groups a selection of timber elements (GenBeams, Elements, BlockRefs, MetalPartCollections) into a single logical assembly unit for production, logistics, and shop drawings. It automatically calculates dimensions, weight, center of gravity, and manages position numbering for the grouped parts.

| Property | Value |
|----------|-------|
| **Script Type** | Object (O-Type) |
| **Category** | Production / Assembly Management |
| **Required Beams** | 0 (Flexible - any number of entities) |
| **Version** | 4.0 |
| **Last Updated** | 24.04.2025 |
| **Minimum hsbCAD** | 27.3.4 (recommended for proper data cleanup) |

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model entities. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | While it provides data for shop drawings, it is inserted in the model. |

## Supported Entity Types

| Entity Type | Description |
|-------------|-------------|
| GenBeam / Beam | Standard timber members (straight or curved) |
| Element | Complete walls, floors, or roofs |
| MetalPartCollectionEnt | Metal hardware/connectors |
| BlockRef | Block references containing 3D geometry |
| MassGroup | Groups of entities (creates assembly automatically) |

## Usage Steps

### Step 1: Launch Script
```
Command: hsb_ScriptInsert
Action: Select "AssemblyDefinition" from the script list
```
A dialog appears with creation options.

### Step 2: Select Creation Strategy

Choose how the assembly should be created:

| Strategy | Description |
|----------|-------------|
| **<Default>** | Manual selection - you select the entities to group |
| **byContact** | Automatic - entities that touch or intersect each other are grouped together |

### Step 3: Select Filter (Optional)

If you have defined **Painter Definitions** in the `Assembly\` collection, you can filter which entities are accepted:

| Option | Behavior |
|--------|----------|
| \<Disabled\> | Accept all selected entities |
| Painter Name | Only entities matching the painter filter rules are included |

### Step 4: Select Entities
```
Command Line: Select entities
Action: Click or window-select the timber parts (beams, panels, hardware) to include
```

**Important Notes:**
- Entities already assigned to another assembly will be rejected
- If you select a MassGroup, the script automatically creates an assembly containing all its nested entities
- If using `byContact` strategy, the script automatically detects touching/intersecting parts and creates multiple assemblies

### Step 5: Verify Assembly
The assembly symbol (a small box with axis indicators) appears at the center of gravity. The assembly name is displayed above it.

## Properties Panel Parameters

### Creation Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Strategy** | String | \<Default\> | Method to gather components: `<Default>` for manual selection, `byContact` for automatic grouping of touching parts |
| **Filter** | String | \<Disabled\> | Painter definition to filter entities. Uses `Assembly\` collection if available |
| **Prefix** | String | (empty) | Format expression for assembly name prefix. Used to create incremental indices for similar assemblies |
| **Start PosNum Assembly** | Integer | 1 | First potential position number for this assembly. If occupied, next available is used |
| **Apply PosNums** | String | \<Disabled\> | Set to `Automatic` to automatically assign position numbers to nested GenBeams |
| **Start PosNum** | Integer | 1 | First position number for items. Only visible when Apply PosNums = Automatic |

### General Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Format** | String | Assembly @(PosNum) | Naming template using format variables. Examples: `@(PosNum)`, `Wall-@(PosNum)`, `@(Ref_Material)` |
| **Material** | String | (empty) | Optional material classification |
| **Grade** | String | (empty) | Optional grade classification |
| **Quality** | String | (empty) | Optional quality classification |
| **Information** | String | (empty) | Free text field for production notes |
| **Weight** | Double | 0.0 | **(Read Only)** Total weight calculated from all entities |

### Display Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Scale** | Double | 1.0 | Visual scale factor for the assembly axis symbol |

## Format Variables

The **Format** and **Prefix** properties support dynamic variables:

| Variable | Returns |
|----------|---------|
| `@(PosNum)` | Assembly position number |
| `@(PrefixIndex)` | Incremental index within prefix group |
| `@(Length)` | Bounding box length (X-axis) |
| `@(Width)` | Bounding box width (Y-axis) |
| `@(Height)` | Bounding box height (Z-axis) |
| `@(Weight)` | Total assembly weight |
| `@(Ref_Material)` | Material from largest entity |
| `@(Ref_Grade)` | Grade from largest entity |
| `@(Ref_Quality)` | Quality from largest entity |
| `@(_kModelSpaceIndex)` | Model space index |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add Entities** | Opens selection to add new beams/elements. If selected items belong to another assembly, you can choose to reassign them |
| **Remove Entities** | Select items to remove from assembly. If all items removed, assembly is deleted |
| **Highlight Entities** / **Don't highlight Entities** | Toggle highlighting of all assembly members in red |
| **Flip X-Axis** | Reverse the assembly's local X-axis direction |
| **Flip Y-Axis** | Reverse the assembly's local Y-axis direction |
| **Flip Z-Axis** | Reverse the assembly's local Z-axis direction |
| **Swap XY-Axis** | Swap X and Y axes (rotates coordinate system) |
| **Swap YZ-Axis** | Swap Y and Z axes |
| **Swap XZ-Axis** | Swap X and Z axes |
| **Rotate X-Axis** | Enter custom rotation angle around X-axis |
| **Reset Index** | Clear the prefix index and recalculate |
| **Swap Indices** | Interactive jig to swap index with another assembly of same prefix |

## DataLink Reference

Each entity in the assembly receives a **DataLink** reference in its SubMapX. This allows other scripts and reports to reference the parent assembly:

```
@(DataLink.AssemblyDefinition.Name:D)     // Returns assembly name
@(DataLink.AssemblyDefinition.Information:D)  // Returns assembly information
```

## Automatic Position Numbering

### How Assemblies Get Position Numbers

Position numbers are assigned based on a **comparison key** that considers:
- Bounding dimensions (Length, Width, Height)
- Material, Grade, Quality, Information properties
- Prefix
- Profile geometry (shadow profiles in X, Y, Z directions)
- Position numbers of contained GenBeams
- MetalPart and BlockRef definitions and positions

Identical assemblies receive the **same position number**. When an assembly changes, it gets a new position number.

### Prefix-Based Indexing

When using the **Prefix** property:
1. Assemblies with the same prefix are grouped together
2. Each unique assembly within a prefix group gets an incrementing **PrefixIndex**
3. Example: Prefix `Floor1-` creates `Floor1-1`, `Floor1-2`, `Floor1-3`, etc.
4. **Unique assemblies** (no duplicates with same prefix) do not show a prefix index (HSB-23933)

## Visual Indicators

### Assembly Symbol
- A **3D box** is drawn at the center of gravity
- **Colored axis lines** indicate the local coordinate system:
  - **Red (1)** = X-axis
  - **Green (3)** = Y-axis
  - **Blue (150)** = Z-axis
- The **assembly name** is displayed as text above the symbol

### Invalid Position Number Warning
If any GenBeam in the assembly has an invalid position number (< 1), the assembly symbol displays in **red** to indicate a problem.

## byContact Strategy Details

When using `byContact` strategy:
1. All entities are analyzed for physical contact
2. Contact detection includes:
   - **Coplanar faces** with opposite normals within tolerance
   - **Solid intersections** (overlapping bodies)
3. Connected entities form **groups** using depth-first search
4. A **separate assembly** is created for each group
5. The original script instance is erased after creating the group assemblies

## Tips

### Production Workflow
- **Organize by Floor**: Use `Prefix` with floor identifiers (e.g., `F01-`, `F02-`) to group assemblies by level
- **Automatic Numbering**: Enable `Apply PosNums = Automatic` to ensure all nested beams have position numbers
- **Filter by Type**: Create Painter Definitions in `Assembly\` folder to quickly group entities by type

### Troubleshooting
- **Red Symbol**: Check that all GenBeams have valid position numbers
- **Wrong Orientation**: Use the Flip/Swap axis commands to correct the local coordinate system
- **Missing Entities**: Entities already in another assembly cannot be added; remove them first or choose "Reassign"

### Performance
- For large projects, use the `byContact` strategy with a filter to batch-create assemblies
- The script uses `envelopeBody()` for performance in complex geometry scenarios

## Related Scripts

| Script | Relationship |
|--------|--------------|
| **hsbCenterOfGravity** | Called internally to calculate total weight |
| **PainterDefinition** | Used for filtering entities during creation |
| **studassembly** | Legacy script - can be converted using the "Legacy Assemblies" filter |

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 4.0 | 24.04.2025 | Index suppressed when only a single, unique definition is found |
| 3.9 | 24.01.2025 | Bugfix: avoid infinite loop on creation |
| 3.8 | 22.01.2025 | Purging DataLink submapX entry on erase (requires 27.3.4+) |
| 3.7 | 16.12.2024 | Prefix variables purged if no valid prefix index can be collected |
| 3.6 | 16.12.2024 | byContact accepts intersecting solids; prefix property fix on insert |
| 3.5 | 11.12.2024 | Bugfix: showDialog with no existing painter definitions |
| 3.4 | 05.12.2024 | New byContact strategy for automatic grouping |
| 3.0 | 16.09.2024 | Improved subindices; new Swap Indices command |
| 2.9 | 01.08.2024 | Child entities reference assembly via DataLink SubMapX |
| 2.8 | 21.06.2024 | 2D Blocks no longer contribute to the solid |
| 2.7 | 19.06.2024 | New Prefix property for prefix-based indexing |
| 2.6 | 31.05.2024 | Highlight Entities command added |
| 2.0 | 22.11.2023 | Automatic numbering of assembled GenBeams |
| 1.8 | 12.09.2023 | Read-only Weight property; base point set to center of gravity |
| 1.0 | 03.03.2023 | Initial version |

## FAQ

**Q: Why is my assembly weight 0.0?**
> A: The assembly may have no entities assigned, or entities without valid geometry. Use "Add Entities" to select timber parts.

**Q: How do I rename the assembly without changing numbering?**
> A: Modify the `Format` property. Use static text (e.g., "RoofTruss") or variables like `@(PosNum)`.

**Q: What happens if I delete a beam that is part of an assembly?**
> A: The script automatically detects missing entities on recalculation and updates dimensions and weight.

**Q: Can I move an entity from one assembly to another?**
> A: Yes. Use "Add Entities" on the target assembly and select the entity. You'll be prompted to reassign it.

**Q: Why do some assemblies show a suffix number and others don't?**
> A: The PrefixIndex is only shown when there are multiple unique assemblies with the same prefix. A single unique assembly displays without an index (Version 4.0+).

**Q: How does byContact detect connections?**
> A: It analyzes face-to-face contact (opposing coplanar faces) and solid intersections (overlapping 3D geometry). Minimum contact area is 9mm2.
