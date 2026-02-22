# hsbCLT-LapJoint

## Overview

This TSL script creates **lap joints** (half-lap connections) on CLT (Cross Laminated Timber) panels. A lap joint is a woodworking connection where two panels overlap by removing material from each panel at the connection point. This script automates the entire process including splitting panels, calculating common ranges, applying gaps, chamfers, and rounded corners, and generating the necessary CNC machining operations.

**Key Capabilities:**
- Automatically splits single panels at designated lap joint locations
- Joins multiple panels with a common lap joint
- Supports automatic depth calculation (50% of panel thickness)
- Configurable gaps, chamfers, and corner radii for CNC milling
- Automatic surface quality-based gap control via XML settings

## Script Metadata

| Property | Value |
|----------|-------|
| **Type** | O (Object) |
| **Version** | 4.13 (05.12.2024) |
| **Required Entities** | 2+ CLT Panels (Sip) or 1 Wall Element |
| **Grip Points** | 0 (uses reference point _Pt0) |
| **Keywords** | CLT; Lap; Lapjoint; joint; rabbet; Falz |
| **Category** | CLT Panel Connection |

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| **Model Space** | Yes | Primary environment for 3D panel manipulation |
| **Paper Space** | No | |
| **Shop Drawing** | No | |

---

## Usage Guide

### Insertion Methods

This script supports **three different insertion workflows**:

#### Method 1: Insert as Splitting Tool (Single Panel)
Use this method when you want to split one panel and create a lap joint:

1. Launch the script: `TSLINSERT` and select `hsbCLT-LapJoint`
2. Select **one CLT panel**
3. Specify the **first split point** on the panel
4. Specify the **second split point** to define the split line
5. The panel will be split and a lap joint instance is created

**For roof panels:** You will be prompted to choose the projection method:
- **Bottom face** - Projects points to bottom of panel
- **Axis** - Projects to panel center (default)
- **Top face** - Projects to top of panel
- **Not projected** - Uses points as-is

#### Method 2: Insert as Single Tool on One Edge
Use this method to modify one panel edge without splitting:

1. Launch the script and select **one CLT panel**
2. Click two points on the **edge** where you want the lap joint
3. The panel will NOT be split; a lap joint tool is attached to the edge
4. Use **Add Panel(s)** context menu to connect other panels later

#### Method 3: Insert on Multiple Panels
Use this method to connect two or more existing panels:

1. Launch the script
2. Select **all panels** to be joined (select the reference panel first)
3. Click a point **near the edge** where the lap joint should be created
4. The script automatically detects panel edges and creates lap joints at all connections

**Tip:** If panels are already overlapping, the script will detect this and set the direction automatically. Otherwise, you may be prompted to specify the joint direction.

---

## Properties Panel (OPM) Parameters

### Reference Side Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **(A) Width** | Length | 50 mm | Width of the lap joint on the reference (main) panel. This determines how much material is removed from the panel edge. |
| **(B) Depth** | Length | 0 mm | Depth of the cut from the reference side. **0 = Auto** (50% of panel thickness). Enter a specific value for non-centered joints. |
| **(C) Gap** | Length | 3 mm | Gap allowance on the reference side for manufacturing tolerances. Visible as colored fill in the model. |
| **(D) Chamfer** | Length | 0 mm | Chamfer size on the reference side edges. Creates a beveled edge for easier assembly. |

### Opposite Side Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **(E) Gap** | Length | 3 mm | Gap allowance on the opposite (top) side of the joint. |
| **(F) Chamfer** | Length | 0 mm | Chamfer size on the opposite side edges. |

### Center Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **(G) Gap** | Length | 0 mm | Gap at the center of the joint (between the two overlapping surfaces). Used when a small gap is needed in the middle of the connection. |

### Tool Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **(H) Automatic Surface Gap** | Enum | Disabled | When **Enabled**, gap values are automatically set based on surface quality definitions from the XML settings file. The gap properties become read-only. |
| **(I) Tool End Extension** | Length | 30 mm | Additional length extension of the cutting tool beyond the joint edges. Ensures the tool breaks through the panel end face completely. Reduce only if extension beyond panel boundary is not desired. |
| **(J) Radius** | Length | 0 mm | Corner rounding radius for CNC milling. **Positive values** create rounded internal corners. **Negative values** create overshoot tools (dog-bone style for tight corners) - not supported for BTL output. |

---

## Right-Click Context Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Flip Alignment** | Swaps which panel is considered "male" (penetrating) vs "female" (receiving). Equivalent to flipping the joint orientation 180 degrees. Also triggered by **double-clicking** the instance. |
| **Swap Depth** | Swaps the depth from the reference side to the opposite side. Only available when depth is NOT set to Auto (0). |
| **Add Panel(s)** | Opens a selection dialog to add additional CLT panels to this lap joint. Useful when you created a lap joint on one panel and want to connect others. |
| **Remove Panel(s)** | Opens a selection dialog to remove panels from this lap joint. Removed panels will have their edges reset to the original position. |
| **Edit in Place** | Enables grip editing mode. Two grips appear at the ends of the joint range, allowing you to visually adjust the joint length. Select again to **Disable Edit in Place**. |
| **Convert to static** | Converts the dynamic TSL instance into static cutting tools (BeamCut, Mortise, Drill) attached directly to the panels. The TSL instance is then erased. Use when you want to freeze the joint geometry. |
| **Reset + Erase** | Resets all female panel edges to their original positions and erases the TSL instance. Use to completely remove the lap joint and restore panels. |
| **export Settings** | Creates a default settings XML file with surface quality gap rules. Only appears when no settings file exists and Automatic Surface Gap is enabled. |

---

## Settings File Configuration

### File Location
- **Filename:** `hsbCLT-LapJoint.xml`
- **Search Paths:**
  1. Company path: `_kPathHsbCompany\TSL\Settings\`
  2. Install path: `_kPathHsbInstall\Content\General\TSL\Settings\`

### Surface Quality Gap Rules

When **Automatic Surface Gap** is enabled, the settings file can define gap values based on surface quality:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
  <lst nm="SurfaceQualityGapRule[]">
    <lst nm="SurfaceQualityGapRule">
      <str nm="SurfaceQuality" vl="A"/>
      <dbl nm="Gap" ut="L" vl="2"/>
      <int nm="Color" vl="1"/>
    </lst>
    <lst nm="SurfaceQualityGapRule">
      <str nm="SurfaceQuality" vl="B"/>
      <dbl nm="Gap" ut="L" vl="3"/>
      <int nm="Color" vl="3"/>
    </lst>
  </lst>
</Hsb_Map>
```

**Properties:**
- **SurfaceQuality** - Must match the surface quality name defined in Style Manager
- **Gap** - Gap value in drawing units
- **Color** - AutoCAD color index for visual representation

### Additional Settings

| Setting | Type | Description |
|---------|------|-------------|
| **MortiseCornerCleanupAsDrill** | Integer (0/1) | When enabled (1), rounded corners are created using drill operations instead of mortise. Provides better CNC compatibility in some cases. |

---

## Visual Indicators

The script draws visual symbols in the model to represent the lap joint:

- **Main outline** - Shows the profile of the lap joint cross-section
- **Filled rectangles** - Indicate gap regions (colored by surface quality or default color)
- **Reference line** - Shows the base direction of the joint
- **Direction arrow** - Visible in plan view, indicates the joint orientation

---

## Technical Details

### Joint Geometry

The lap joint creates the following CNC operations:

1. **Female (Receiving) Cut** - A BeamCut or Mortise on panels where the joint "receives" the male panel
2. **Male (Penetrating) Cut** - A BeamCut or Mortise on panels that extend into the female cut
3. **Chamfers** - Optional 45-degree bevels on edges
4. **Corner Drills** - When Radius > 0 and MortiseCornerCleanupAsDrill is enabled

### Depth Behavior

- **Depth = 0 or negative**: Automatic depth = 50% of panel thickness (centered joint)
- **Depth > 0 and < panel thickness**: Custom depth from reference side
- **Depth >= panel thickness**: Falls back to automatic (50%)

### Version Compatibility

The script includes automatic migration for properties from older versions:
- Versions before 3.2 may have gap properties swapped on flipped instances
- A notice is displayed if migration occurs

---

## Tips and Best Practices

### Design Workflow
1. **Preview before construction**: Insert the script on panels before generating SIPs/GenBeams. The script draws a preview symbol and automatically executes when construction is generated.
2. **Use Auto Depth for symmetrical joints**: Leave Depth at 0 for perfectly centered half-lap joints.
3. **Add gaps for manufacturing tolerances**: Typical gap values are 2-3mm for CNC-milled joints.

### CNC Compatibility
- **For BTL output**: Use Radius = 0 or positive values only. Negative radius (overshoot) is not supported.
- **For better corner quality**: Enable MortiseCornerCleanupAsDrill in settings when using positive radius values.

### Editing
- **Quick flip**: Double-click the graphical symbol to quickly flip the joint alignment.
- **Length adjustment**: Use Edit in Place mode to visually adjust the joint range with grip points.
- **Move joint**: Grip-edit the reference point (_Pt0) to relocate the entire joint along the edge.

---

## Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| **"requires at least 2 panels"** | The script needs at least 2 panels to create a joint. Add more panels using the context menu. |
| **"no common range"** | The selected panels do not have overlapping regions where a lap joint can be created. Check panel positions and dimensions. |
| **"Two male panels cannot be connected"** | Both panels are configured as "male" (penetrating). Use Flip Alignment on one panel to make it "female". |
| **Panel did not split on insert** | The script may be in preview mode. Generate construction (SIPs) for the panel, and the split will occur automatically. |
| **Joint depth not updating on thickness change** | If using Auto Depth (0), the depth recalculates automatically. If using fixed depth, update the Depth property manually. |

---

## Related Scripts

| Script | Description |
|--------|-------------|
| `hsbCLT-Rabbet` | Creates rabbet/rebate joints on CLT panels |
| `hsbCLT-T-Connector` | Creates T-connection joints between panels |
| `hsbCLT-Slot` | Creates slot connections in CLT panels |
| `hsbCLT-Pocket` | Creates pocket cuts in CLT panels |
| `hsbTSLSettingsIO` | Import/export settings files for TSL scripts |

---

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 4.13 | 05.12.2024 | Marsel Nakuci | HSB-23002: Save graphics in file for render in hsbView |
| 4.12 | 21.10.2024 | Marsel Nakuci | HSB-22813: Fix when applying drills at corners |
| 4.11 | 19.08.2024 | Marsel Nakuci | HSB-22548: Ensure mortise doesn't cut rounds at panel; increased mortise width |
| 4.10 | 13.05.2022 | Marsel Nakuci | HSB-15474: Added "MortiseCornerCleanupAsDrill" flag for corner rounding control |
| 4.9 | 14.09.2021 | Marsel Nakuci | HSB-11596: Fixed bug when joining multiple panels with openings |
| 4.8 | 26.03.2020 | Robert Pol | HSB-7000: Added static tool to male instead of female |
| 4.7 | 20.03.2020 | Thorsten Huck | HSB-7034: Export enabled |
| 4.6 | 03.12.2019 | Thorsten Huck | HSB-6068: Typo fixed |
| 4.5 | 28.11.2019 | Thorsten Huck | HSB-6068: New 'Radius' property for rounded lap joints; negative radius creates overshoot |
| 4.4 | 02.04.2019 | Thorsten Huck | HSBCAD-596: Depth=0 now centers joint and center gap |
| 4.0 | 20.03.2018 | Thorsten Huck | New gap parameter from settings; settings file renamed to 'hsbCLT-LapJoint' |

---

## FAQ

**Q: Can I use this script on walls?**
A: Yes. When no panels are selected, you can press Enter to select a Wall element. The script will split the wall's panels and create lap joints automatically.

**Q: How do I create a stepped lap joint (different depths on each side)?**
A: Set a specific Depth value instead of 0. Then use **Swap Depth** to quickly alternate which side has more material removed.

**Q: Why are my gap properties read-only?**
A: When **Automatic Surface Gap** is Enabled, gaps are controlled by the XML settings file based on surface quality. Disable this option to manually edit gap values.

**Q: What is the difference between Flip Alignment and Flip Direction?**
A: **Flip Alignment** swaps which panel is male vs female. **Flip Direction** (in wall mode) changes which face of the panel the joint is calculated from.

**Q: Can I copy a lap joint to other locations?**
A: Yes. Due to the `setEraseAndCopyWithBeams` behavior, copying a panel with a lap joint will also copy the joint instance. The script automatically merges duplicate instances at the same edge.
