# hsbCLT-Rabbet

Creates rabbet (rebate) and tenon joints between T-connected CLT (Cross-Laminated Timber) panels. This tool stretches the closest edge(s) of the male panel to a designated plane and applies corresponding cuts to both male and female panels.

## Overview

The hsbCLT-Rabbet script is designed for creating mechanical interlocking connections between CLT panels that meet at T-junctions. It automatically:

- Stretches the male panel edge to create a tenon projection
- Cuts a matching rabbet (groove) in the female panel(s)
- Supports various alignment and gap configurations for manufacturing tolerances
- Handles both mortise joints (for smaller dimensions) and beam cuts (for larger dimensions over 1500 mm)
- Generates visual representation of the joint with optional dimension requests for shop drawings

## Environment

| Property | Value |
|----------|-------|
| Type | O (Object) |
| Script Version | 1.14 |
| Model Space | Yes |
| Paper Space | No |
| Shop Drawing | No |
| Required Panels | Minimum 2 (1 male + 1+ female) |
| Keywords | SIP, Panel, Rabbet |

## Prerequisites

- At least two CLT panels (Sip entities) in the model
- Panels must be non-parallel (forming a T-junction)
- hsbCAD environment with CLT module enabled
- Panels must have valid intersection geometry

## Usage

### Step 1: Launch Script

Command: `TSLINSERT` followed by selecting `hsbCLT-Rabbet.mcr` from the list.

### Step 2: Configuration

- **Catalog Mode**: If a catalog entry name is provided via the execute key, properties load automatically from the saved catalog.
- **Manual Mode**: If no catalog is specified, a Properties Dialog appears for adjusting Width, Depth, Gaps, and other settings.

### Step 3: Select Male Panel

```
Command Line: Select male panel
Action: Click on the panel that will project into the other (the tenon side).
```

**Note**: If the male panel belongs to a wall element that has been split, the script automatically selects the segment closest to the female panel for proper joint creation (Version 1.13+).

### Step 4: Select Female Panel(s)

```
Command Line: Select female panel(s)
Action: Click on one or more receiving panels (the groove/rabbet side). Press Enter to finish selection.
```

### Step 5: Automatic Generation

The script validates the geometry, calculates the toolpath, and generates the rabbet/tenon joint automatically. If tooling fails on the first female panel when multiple are selected, the script automatically swaps the order and retries (Version 1.10+).

## Parameters

### Geometry Category

| Parameter | Label | Default | Unit | Description |
|-----------|-------|---------|------|-------------|
| `dWidth` | (A) Width | 50 | mm | Width of the joint. Set to 0 for automatic 50% of panel thickness. |
| `dDepth` | (B) Depth | 20 | mm | Depth of the rabbet/tenon projection into the female panel. |
| `dGapSide` | (C1) Gap reference side | 0 | mm | Side gap on the reference side for manufacturing tolerance. |
| `dGapSide2` | (C2) Gap opposite side | 0 | mm | Side gap on the opposite side for manufacturing tolerance. Available since Version 1.8. |
| `dGapDepth` | (D) Gap Depth | 0 | mm | Depth gap at the bottom to prevent panels from bottoming out. |

### Tooling Category

| Parameter | Label | Options | Default | Description |
|-----------|-------|---------|---------|-------------|
| `sAlignment` | (E) Alignment | Reference Side, Center, opposite side | Reference Side | Location of the mortise relative to the panel thickness. Determines how the joint is positioned across the panel width. |
| `dOffset` | (F) Offset | - | 50 mm | Offset distance from the reference side for fine positioning of the joint along the panel edge. |
| `sTool` | Tool | Contact, towards bottom, towards top, both Sides | Contact | Vertical extension of the tool when panels have different heights. Controls how the tool extends beyond the contact area. |
| `sToolShape` | Tool Shape | not rounded, round, rounded | not rounded | Corner geometry for CNC compatibility. Automatically set to "not rounded" and becomes read-only when joint height exceeds 1500 mm. |

### Parameter Dependencies

- **Width = 0**: Automatically calculates as 50% of the male panel thickness
- **Tool Shape constraint**: Becomes read-only ("not rounded") when joint height >= 1500 mm (CNC limitation)
- **Gap symmetry for mortises**: When using mortise joints (smaller dimensions), C1 and C2 gaps are forced to be symmetric

## Context Menu

Right-click on an existing rabbet joint instance to access additional options:

| Menu Item | Description |
|-----------|-------------|
| Catalog Entries | Lists all saved catalog entries alphabetically. Click an entry to apply its settings immediately. |
| Toggle Alignment | Double-click the instance to cycle between Reference Side and Opposite Side alignment. Center alignment must be set via properties. |

### Double-Click Behavior

When you double-click on a rabbet joint instance:
- If current alignment is **Reference Side** or **Center** → Changes to **Opposite Side**
- If current alignment is **Opposite Side** → Changes to **Reference Side**

## Technical Notes

### Tool Shape Behavior

- When the joint dimension (height) exceeds 1500 mm, the tool shape is automatically forced to "not rounded" and becomes read-only due to CNC machining limitations
- For smaller dimensions, choose between round or rounded corners based on your CNC machine capabilities
- **not rounded**: Straight corners, compatible with all CNC machines
- **round**: Circular corner transition
- **rounded**: Filleted corner transition

### Male vs Female Panel Processing

- **Male Panel**: Edge is stretched outward to create the tenon projection
- **Female Panel(s)**: Receive a BeamCut (for large joints >= 1500mm) or Mortise tool (for smaller dimensions)
- The script applies two BeamCuts to the male panel: one on each side of the joint width

### Tool Extension Options (sTool)

| Option | Use Case |
|--------|----------|
| Contact | Standard T-connections where panels have equal vertical extents |
| towards bottom | Female panel extends below the male panel; tool extends downward |
| towards top | Female panel extends above the male panel; tool extends upward |
| both Sides | Female panel extends in both directions; tool extends both ways |

### Asymmetric Gap Support

Version 1.8+ supports different gap values on the reference side (C1) and opposite side (C2). This allows for:
- Accommodating different tolerance requirements on each side
- Compensating for material variations
- **Important**: For mortise joints (smaller dimensions), the system automatically forces gap values to be symmetric for proper joint geometry

### Panel Splitting Handling (Version 1.13+)

The script automatically detects when a male panel belonging to a wall element has been split:
- Searches all panels within the wall element
- Selects the segment closest to the female panel
- Ensures proper joint creation even on split panels
- Requires `_Map.hasInt("checkMalesForHolzius")` flag to be set

### Gable Wall Support (Version 1.11+)

Special handling for female panels on gable walls with angled geometry:
- Correctly calculates intersection points for non-rectangular panels
- Properly extends tools to cover the full joint length
- Handles cases where gable angle affects joint geometry

### Error Recovery

The script includes several automatic error recovery mechanisms:
- **No body intersection** (HSB-21750): Handles edge cases where panel bodies don't intersect as expected
- **Female SIP swapping** (HSB-21589): When tooling fails with the first female panel, automatically swaps the order of female panels and retries
- **Segment sorting** (HSB-21750): Properly sorts tooling segments along the vertical axis for correct application

### Dimension Requests (Version 1.14+)

When the joint width plus gaps is <= 60mm, the script generates dimension requests for shop drawings:
- Creates a PlaneProfile visualization of the rabbet cut
- Uses the "CLTRabbetPp" stereotype for identification
- Applies hatching pattern "ANSI31" with scale 10
- Color-coded based on panel orientation (5 or 1)
- Includes transparency setting for better visualization

## Tips

1. **Use Catalog Entries**: Save frequently used joint configurations to catalogs for consistent application across projects. Access them quickly via the context menu.

2. **Quick Alignment Toggle**: Double-click on an existing joint to rapidly switch between Reference Side and Opposite Side alignment during design iterations.

3. **Tool Extension Selection**:
   - Use **Contact** for standard T-connections where panels have equal vertical extents
   - Use **towards bottom** when the female panel extends below the male panel
   - Use **towards top** when the female panel extends above the male panel
   - Use **both Sides** when the female panel extends in both vertical directions

4. **Manufacturing Tolerances**: Add small gap values (1-2 mm) on C1, C2, and D parameters to account for manufacturing tolerances and ease of assembly. This prevents binding and allows for material variations.

5. **CNC Compatibility**: Check your machine's capabilities before using "round" or "rounded" tool shapes. Some CNC machines may not support rounded internal corners. The "not rounded" option is universally compatible.

6. **Automatic Width**: Setting dWidth to 0 automatically uses 50% of the panel thickness, which is often the ideal ratio for structural performance and ease of machining.

7. **Split Panel Detection**: If working with walls that contain split panels, ensure the `checkMalesForHolzius` flag is set in the script's Map to enable automatic closest-panel selection.

8. **Multiple Female Panels**: When selecting multiple female panels, the script will attempt to create cuts in all of them. If tooling fails on the first, it will automatically try the second.

9. **Visual Verification**: The script draws colored visualization elements during execution. Use these to verify joint placement before finalizing.

## Troubleshooting

| Problem | Cause | Solution |
|---------|-------|----------|
| "Panels may not be parallel" error | Panels are parallel or near-parallel | Ensure panels form a proper T-junction at approximately 90 degrees |
| "This tool requires at least two panels" | Only one or no panels selected | Select both male and at least one female panel during insertion |
| "No male segment found" | No valid edge aligned toward the connection | Check panel geometry and edge alignment |
| Tool shape changes unexpectedly | Joint height exceeds 1500mm | This is automatic CNC compatibility behavior; use BeamCut instead |
| Joint appears in wrong location | Incorrect alignment setting | Double-click to toggle alignment, or use Center alignment |
| Gap values become identical | Using mortise joint type | Mortise joints require symmetric gaps for proper geometry |

## FAQ

**Q: Why does the script fail with "Panels may not be parallel"?**

A: This tool is designed exclusively for T-connections where panels meet at an angle. It cannot create joints between parallel panels. Ensure your male and female panels intersect at approximately 90 degrees (perpendicular).

**Q: How do I quickly center the joint within the panel?**

A: Set the Alignment parameter to "Center" in the OPM properties panel. Note that double-click only toggles between Reference Side and Opposite Side.

**Q: Can I apply this to floor or roof panels?**

A: Yes, the script works with any Sip/CLT entities regardless of their orientation (wall, floor, or roof), as long as they form a valid T-connection with proper geometry.

**Q: Why did the tool shape change to "not rounded" automatically?**

A: When the joint height (vertical dimension) exceeds 1500 mm, the script automatically switches to "not rounded" tool shape due to CNC machining limitations. This is intentional behavior to ensure CNC compatibility. The property becomes read-only in this case.

**Q: Can I select multiple female panels?**

A: Yes, you can select multiple female panels during the insertion process. The script will create appropriate cuts in all selected panels. If tooling fails on the first panel, it will attempt to swap the order and retry.

**Q: What is the difference between C1 and C2 gap values?**

A: C1 (Gap reference side) applies to the side determined by the alignment reference. C2 (Gap opposite side) applies to the opposite edge. They allow for asymmetric tolerances. Note that for mortise joints, these are forced to be equal.

**Q: Why is my joint not visible after creation?**

A: Check that panels have valid intersection geometry. The script creates visualization elements in the model color. Use the Display settings to verify visibility.

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.14 | 29.01.2025 | Added tool maprequest for dimension visualization on shop drawings |
| 1.13 | 07.08.2024 | Check male panel if panel at a wall gets split; auto-select closest segment |
| 1.12 | 26.03.2024 | Handle case when no body intersection found; fix tooling for female gable walls |
| 1.11 | 26.03.2024 | Fix tooling for female gable walls with angled geometry |
| 1.10 | 08.03.2024 | Swap female SIPs when tooling fails for improved error recovery |
| 1.9 | 07.03.2024 | Improve report messages with script name identification |
| 1.8 | 03.06.2022 | New property to define asymmetric side offset (C2 gap) |
| 1.7 | 24.02.2021 | Tool shape only set to read-only if size > 1500mm |
| 1.6 | 23.02.2021 | BeamCut exported if tool shape is set to not round; improved male mortise topology |
| 1.4 | 27.07.2015 | Double-click event toggles alignment; catalog entries accessible through context menu |
| 1.0 | 20.07.2015 | Initial release |

## Related Scripts

- **hsbCLT-T-Connector**: Alternative T-connection method for CLT panels
- **hsbCLT-Slot**: Creates slot connections between panels
- **hsbCLT-Pocket**: Creates pocket joints in CLT panels
- **T-Connection**: General T-connection tool for beams
