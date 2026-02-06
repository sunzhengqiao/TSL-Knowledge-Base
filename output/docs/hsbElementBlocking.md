# hsbElementBlocking.mcr

## Overview
Automatically generates horizontal blocking beams (noggins or firestops) within timber wall elements. It intelligently adjusts surrounding vertical studs and diagonal bracing to fit the new blocking layout.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D construction entities. |
| Paper Space | No | Not designed for 2D drawing generation. |
| Shop Drawing | No | This is a model generation script. |

## Prerequisites
- **Required Entities**: At least one Timber Element or a group of coplanar GenBeams (studs/plates).
- **Minimum Beam Count**: 0 if an Element is selected; multiple beams if selecting a set manually.
- **Required Settings**: None. Uses internal defaults or Element structural zone data.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line or browse the TSL Catalog.
2.  Select `hsbElementBlocking.mcr` and click OK.

### Step 2: Select Elements or Beams
```
Command Line: Select elements, <Enter> to select a set of beams of one element
Action: 
- Click on a Timber Element to generate blocking inside it.
OR
- Press <Enter> and then window-select a group of beams (studs/plates) that form a wall.
```

### Step 3: Configure Properties
1.  The Property Dialog will appear automatically upon insertion.
2.  Adjust parameters such as **Height**, **Width**, and **Clearance** as needed.
3.  Click OK to generate the blocking.

## Properties Panel Parameters

### Geometry
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Height | Number | 0 | Defines the height of the blocking beam. Set to `0` to use the Element's structural zone height. |
| Width | Number | 0 | Defines the width of the blocking beam. Set to `0` to use the Element's structural zone width. |

### Beam Properties
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Material | Text | (Empty) | Specifies the material code (e.g., C24) for the blocking beams. |
| Grade | Text | (Empty) | Specifies the timber grade (e.g., GL24h). |
| Name | Text | (Empty) | Assigns a specific name label to the blocking entities. |
| Color | Number | 4 | Sets the CAD display color (Index 0-255). |
| Nailing | Dropdown | Disabled | Determines if the blocking acts as a nailing strip (`Enabled`) or purely structural (`Disabled`). |

### Alignment & Layout
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Clearance | Text | 25 | Defines vertical spacing between rows. <br>- **Absolute**: e.g., `400;600` (mm). <br>- **Fraction**: e.g., `1/3;1/3` (Relative to bay height). <br>Separate multiple entries with a semicolon `;`. |
| Bottom Clearance | Text | 25 | (Legacy/Specific) Defines clearance from the bottom rail. See `Clearance` for main spacing logic. |
| Post Filter | Text | (Empty) | Criteria to identify vertical studs that should be stretched to meet the blocking. Use colors or beamtypes separated by semicolons (e.g., `Stud;Post`). |
| Split Filter | Text | (Empty) | Criteria to identify members (e.g., diagonals) that should cut through the blocking rather than stop against it. |
| Alignment | Dropdown | Icon Side | Sets horizontal alignment relative to the wall centerline (`Icon Side`, `Center`, or `Opposite Side`). |
| Staggered | Dropdown | No | If `Yes`, offsets every second row of blocking to allow for continuous nailing or ventilation. |
| Justification | Dropdown | Bottom | When using fractional clearance, determines if the fraction is calculated from the `Top`, `Middle`, or `Bottom` of the opening. |
| Gap | Number | 0 | Sets a clearance tolerance around intersecting diagonal members (mm). Use negative values to exclude intersections. |

### Configuration
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Sequence | Number | 70 | Determines the execution order during element generation. Lower numbers run earlier. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Re-runs the script to apply property changes or adapt to geometry changes in the wall. |
| Show Dialog | Opens the properties dialog to edit blocking parameters. |
| MapIO | Opens the MapIO dialog for advanced input/output mapping. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: This script relies on internal logic and Element properties; no external XML configuration file is mandatory for basic operation.

## Tips
- **Auto-Dimensions**: Leave `Height` and `Width` as `0` to ensure blocking automatically matches the wall's structural zone thickness if the wall design changes.
- **Fractional Spacing**: Use the `Clearance` field with fractions (e.g., `1/2`) to place blocking exactly in the middle of a tall opening, regardless of the opening height.
- **Filtering**: If your studs are not being cut/stretched correctly, check your `Post Filter`. You can filter by beam name (e.g., "Stud") or Color Index.
- **Splitting Diagonals**: If you have diagonal bracing that needs to pass *through* the blocking without notching it heavily, add the bracing type to the `Split Filter`.

## FAQ
- **Q: Why is my blocking appearing in the wrong place vertically?**
- **A: Check the `Clearance` string. Ensure you are using semicolons `;` to separate values if you have multiple rows. If using fractions, verify the `Justification` setting (Top/Middle/Bottom) to see where the reference point is.

- **Q: The blocking is not cutting a hole for my diagonal brace.**
- **A: Add the diagonal beam's Name or Type to the `Split Filter` property. This tells the script to treat that member as a "splitter" that passes through.

- **Q: The studs are not stretching up to touch the blocking.**
- **A: Verify the `Post Filter` property. The studs must match the criteria defined there (e.g., if your filter is "Stud" but the beam is named "VerticalStud", it won't match).

- **Q: How do I offset every other row?**
- **A: Set the `Staggered` property to `Yes`. This is useful for nailing strips so joints don't line up vertically.