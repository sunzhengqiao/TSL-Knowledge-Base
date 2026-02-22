# Rothoblaas Type R Post Base Connector

## Overview

| Property | Value |
|----------|-------|
| **Script Name** | Rothoblaas Typ R.mcr |
| **Version** | 1.4 (17-Apr-2018) |
| **Script Type** | E-Type (Element-based) |
| **Beams Required** | Minimum 1 |
| **Layer Assignment** | Z layer (visible when plotting) |
| **Manufacturer** | Rothoblaas |
| **Product Category** | Post Bases / Column Anchors |

The Rothoblaas Type R script creates adjustable steel post bases (column bases) on one or multiple timber beams. These connectors anchor vertical timber posts to concrete foundations while providing height adjustment capability. The script supports four different Type R variants (R10, R20, R30, R40), each designed for specific load and installation requirements.

## Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Generates 3D hardware geometry and modifies beams |
| Paper Space | No | N/A |
| Shop Drawing | No | Hardware data exports to BOM |

## Prerequisites

- At least one timber beam must exist in the drawing
- For automatic insertion (without point selection): Beams must be vertical
- For manual point selection: Beams can be sloped but not horizontal

---

## Usage

### Step 1: Launch Script

```
Command: TSLINSERT
Select: Rothoblaas Typ R.mcr from the script list
```

Alternatively, use execute keys to preset the type:
- `TSLINSERT Rothoblaas Typ R?R10` - Preset to R10 family
- `TSLINSERT Rothoblaas Typ R?R20` - Preset to R20 family
- `TSLINSERT Rothoblaas Typ R?R30` - Preset to R30 family
- `TSLINSERT Rothoblaas Typ R?R40` - Preset to R40 family

### Step 2: Select Type Family

A dialog appears for selecting the post base type (R10, R20, R30, or R40) if not preset via execute key. Once selected, the type becomes **read-only** - to change the type, delete and re-insert the post base.

### Step 3: Select Beams

```
Command Line: Select Beam(s)
Action: Click on one or multiple beams to equip with post bases.
```

Multiple beam selection is supported for efficient batch insertion.

### Step 4: Select Insertion Point

```
Command Line: Select Point or <Enter> to put post base on bottom end of the beam
```

| Option | Action | Result |
|--------|--------|--------|
| **Press Enter** | Skip point selection | Post base inserts at bottom of each vertical beam |
| **Click a Point** | Select point in drawing | Point projects onto each beam's X-axis for position |

---

## Insertion Methods

### Automatic Mode (Vertical Posts Only)

- Press Enter to skip point selection
- Post bases install at the bottom end of vertical beams
- Post base always points downward
- Non-vertical beams are automatically filtered out with a message

### Manual Point Selection (Sloped Posts)

- Click a point in the drawing
- Works with sloped beams (not horizontal)
- The selected point is projected to the X-axis of each beam
- Allows installing post bases upside-down on top of posts

### Beam Filtering Rules

| Beam Orientation | Automatic Mode | Manual Mode |
|------------------|----------------|-------------|
| Vertical | Accepted | Accepted |
| Sloped | Filtered out | Accepted |
| Horizontal | Filtered out | Filtered out |

---

## Parameters

### Category: Type Selection

| Parameter | Type | Options | Default |
|-----------|------|---------|---------|
| **A - Type** | dropdown | R10, R20, R30, R40 | R10 |
| **B - Size** | dropdown | 1, 2, 3, or 4 (depends on type) | 1 |
| **C - Post base height** | number | Within allowed range | Mid-range |

#### Type Descriptions

| Type | Description | Top Plate | Best For |
|------|-------------|-----------|----------|
| **R10** | Flat top plate | Square plate welded to tube | Simple installations, no leveling needed |
| **R20** | Top plate with threaded rod | Square plate with central rod for leveling | Height adjustment required |
| **R30** | Disc type top plate with threaded rod | Round disc plate with rod | Aesthetic applications |
| **R40** | Uncovered, passing-through threaded rod | Full-length exposed rod | Maximum height adjustment |

#### Size and Height Adjustment Ranges

| Type | Size | Height Range | Base Plate (L x W) | Thread Diameter |
|------|------|--------------|--------------------|-----------------|
| R10 | 1 | 130 - 165 mm | 120 x 120 mm | M16 |
| R10 | 2 | 160 - 205 mm | 160 x 160 mm | M20 |
| R10 | 3 | 190 - 250 mm | 200 x 200 mm | M24 |
| R20 | 1 | 130 - 165 mm | 120 x 120 mm | M16 |
| R20 | 2 | 160 - 205 mm | 160 x 160 mm | M20 |
| R20 | 3 | 190 - 250 mm | 200 x 200 mm | M24 |
| R30 | 1 | 135 - 170 mm | 120 x 120 mm | M16 |
| R30 | 2 | 165 - 210 mm | 160 x 160 mm | M20 |
| R40 | 1 | 40 - 105 mm | 100 x 100 mm | M16 |
| R40 | 2 | 40 - 105 mm | 100 x 100 mm | M20 |
| R40 | 3 | 40 - 156 mm | 160 x 100 mm | M20 |
| R40 | 4 | 40 - 256 mm | 160 x 100 mm | M24 |

### Category: Tooling

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **D - Milled** | dropdown | No | Enable milling of top plate recess into beam end |
| **E - Additional mill depth** | number | 0 mm | Extra depth for milling operation beyond top plate thickness |
| **F - Oversize milling** | number | 2 mm | Clearance tolerance for milled pocket |
| **G - Oversize drill** | number | 2 mm | Clearance tolerance for threaded rod drill hole |

**Milling Options**:
- **No**: Top plate sits against the beam end (no modification to beam)
- **Yes**: A pocket is milled into the beam end to accept the top plate

**Note**: Milling creates either a square pocket (R10, R20, R40) or a circular drill (R30 disc type).

### Category: Mounting

| Parameter | Type | Options | Default |
|-----------|------|---------|---------|
| **H - Anchoring to the ground** | dropdown | See below | Expansion anchor |

**Anchoring Options**:

| Option | Article | Description | Best For |
|--------|---------|-------------|----------|
| Expansion anchor | AB1 | Mechanical expansion bolt | Standard concrete |
| Screw anchor | SKR | Threaded concrete screw | Quick installation |
| Chemical dowel | VINYLPRO | Epoxy-based adhesive | Cracked concrete |
| Chemical dowel | EPOPLUS | High-strength epoxy | Heavy loads, critical applications |

**Note**: Anchor length depends on static requirements and is not specified by the script.

---

## Context Menu Options

Right-click on the post base instance to access:

| Menu Item | Description | Shortcut |
|-----------|-------------|----------|
| **Rotate post base** | Rotates the post base 90 degrees around the beam axis | Double-click |

### Additional Actions

| Action | How to Access |
|--------|---------------|
| **Set to standard height** | Right-click context menu - resets height to middle of allowed range |

---

## Generated Tooling Operations

The script applies the following operations to the beam:

| Operation | Condition | Description |
|-----------|-----------|-------------|
| **Cut** | Always | Cuts the beam at the post base position |
| **Mill** | If "Milled" = Yes | Creates pocket for top plate |
| **Drill** | R20, R30, R40 only | Drills hole for threaded rod |

**R10 Note**: No drill is applied since R10 has a flat top plate without threaded rod.

---

## Hardware Bill of Materials

The script automatically generates hardware component lists including:

| Component | Quantity | Details |
|-----------|----------|---------|
| **Post base unit** | 1 | Article number (e.g., FE500450), dimensions, Rothoblaas manufacturer |
| **Top screws** | 2-16 | HBS+ evo or Screw DISC, depending on type |
| **Bottom anchors** | 4 | Expansion, screw, or chemical anchors |

### Article Numbers

| Type/Size | Article Number |
|-----------|----------------|
| R10/1 | FE500450 |
| R10/2 | FE500455 |
| R10/3 | FE500460 |
| R20/1 | FE500485 |
| R20/2 | FE500490 |
| R20/3 | FE500495 |
| R30/1 | FE501700 |
| R30/2 | FE501705 |
| R40/1 | FE500265 |
| R40/2 | FE500270 |
| R40/3 | FE500280 |
| R40/4 | FE500285 |

### Screw Specifications

| Type | Top Screw Type | Quantity | Diameter x Length |
|------|----------------|----------|-------------------|
| R10 | HBS+ evo | 4 | 6x90 / 8x80 / 8x80 |
| R20 | HBS+ evo | 4 | 6x90 / 8x80 / 8x80 |
| R30 | Screw DISC | 8-16 | 6x60 / 6x80 |
| R40 | HBS+ evo | 2-4 | 6x90 / 8x80 |

---

## Tips and Best Practices

### General Tips

1. **Multiple Beam Selection**: Select multiple beams at once to efficiently place post bases on all selected posts in a single operation.

2. **Height Auto-Correction**: If you enter a height outside the valid range, the script automatically corrects it to the nearest valid value and displays a message in the command line.

3. **Catalog Entries**: Save preferred configurations as catalog entries for quick access in future projects.

4. **Type Selection is Locked**: After insertion, the Type (R10/R20/R30/R40) becomes read-only. To change the type, delete and re-insert the post base.

### Installation Tips

5. **Milling for Flush Finish**: Enable the "Milled" option if you want the top plate to sit flush with or recessed into the beam end for a cleaner appearance.

6. **Sloped Posts**: Use the point selection method (click a point instead of pressing Enter) for sloped posts. The projection ensures correct positioning along the beam axis.

7. **Upside-Down Installation**: When selecting a point above a post, the post base installs upside-down, useful for top connections.

8. **Beam Filtering**: The script automatically filters out unsuitable beams - horizontal beams are never allowed, and non-vertical beams require manual point selection.

### Type Selection Tips

9. **R10 for Simplicity**: Use R10 when height adjustment is not required - no drill hole through the beam.

10. **R40 for Maximum Adjustability**: R40 offers the largest height adjustment range (up to 256mm for size 4).

---

## Troubleshooting

| Problem | Cause | Solution |
|---------|-------|----------|
| Some beams didn't receive post bases | Beams were horizontal or non-vertical without point selection | Check command line for filtering messages; use point selection for sloped beams |
| Height value changed automatically | Entered height outside allowed range | Check command line message for corrected value |
| Hole drilled through beam unexpectedly | Using R20, R30, or R40 type | Use R10 for flat plate without through-hole |
| Cannot change type after insertion | Type is read-only after insertion | Delete and re-insert with correct type |
| Post base in wrong position | Used automatic mode on sloped beam | Use manual point selection for precise positioning |

---

## FAQ

**Q: How do I make the top plate flush with the wood?**
A: Select the post base, open the Properties palette, and set "D - Milled" to "Yes". Adjust "E - Additional mill depth" for deeper recess if needed.

**Q: Why is there a hole drilled through my beam?**
A: Types R20, R30, and R40 require a through-drill for the internal threaded rod. Use Type R10 if you want a flat plate without a central through-hole.

**Q: Can I change the anchor type after inserting?**
A: Yes, select the instance and change the "H - Anchoring to the ground" property in the Properties Palette.

**Q: Why did some of my selected beams not receive a post base?**
A: Horizontal beams are not supported. If you skipped point selection, only vertical beams are accepted. Check the command line for filtering messages.

**Q: How do I rotate the post base?**
A: Right-click on the instance and select "Rotate post base" from the context menu, or simply double-click the instance.

**Q: How do I reset the height to default?**
A: Right-click on the instance and select "Set to standard height" - this resets to the middle of the allowed range.

---

## Related Information

- **Manufacturer**: Rothoblaas
- **Product Page**: http://www.rothoblaas.com/products/fastening/brackets-and-plates/pillar-bases/typ-r10-r20
- **Script Location**: TSL/Rothoblaas Typ R.mcr

### Related Scripts

| Script | Purpose |
|--------|---------|
| Rothoblaas Typ F70 | Another Rothoblaas connector type |
| Hilti-Verankerung | Hilti anchoring solutions |
| Generic hangers | General-purpose beam connectors |

---

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 06-Sep-2016 | florian.wuermseer@hsbcad.com | Initial version |
| 1.1 | 08-Aug-2017 | florian.wuermseer@hsbcad.com | Assignment changed to Z layer (visible when plotting) |
| 1.2 | 04-Oct-2017 | thorsten.huck@hsbcad.com | Insert mechanism with catalog entry improved |
| 1.4 | 17-Apr-2018 | thorsten.huck@hsbcad.com | Translation issue fixed |
