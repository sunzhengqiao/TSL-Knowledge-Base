# WetGuard

## Overview

WetGuard is a waterproofing tape distribution tool for structural insulated panels (SIPs) and wall panels. It automatically calculates and visualizes tape coverage areas along panel edges, manages overlaps between adjacent strips, and generates hardware component lists for bill of materials. The tool supports custom article definitions and flexible display options for both model and shop drawing views.

## Usage Environment

| Item | Details |
|------|---------|
| **Script Type** | O-Type (Object/Tool) |
| **Execution Space** | Model Space |
| **Required Entities** | SIP panels, wall panels, or elements with panel edges |
| **Output** | Visual coverage areas, hardware components for BOM, optional shop drawing annotations |

## Prerequisites

- WetGuard.xml settings file with article definitions
- Valid SIP or panel entities with detectable edges
- Understanding of panel edge types (bottom, top, vertical, horizontal)

## Usage Steps

1. **Launch the Tool**
   - Execute the WetGuard command
   - If no articles are defined, you'll be prompted to create them

2. **Configure Article Definitions** (First-time setup)
   - Click "Define Articles" in the dialog
   - For each tape type:
     - Enter article number
     - Enter manufacturer name
     - Enter model/description
     - Set tape width (ScaleY)
     - Choose display color
     - Set transparency level (0-100)
   - Save settings when complete

3. **Select Panels**
   - Choose panels or SIP elements for tape application
   - The tool analyzes all panel edges and detects adjacent panels

4. **Review Coverage**
   - View tape coverage areas displayed as colored zones
   - Check overlap regions between adjacent strips
   - Verify that openings above minimum area are excluded

5. **Configure Display**
   - Right-click → Display Settings to adjust:
     - Model view display mode (Coverage, Overlap, or None)
     - Shop drawing display mode
     - Overlap amount
     - Minimum opening area threshold

## Properties Panel Parameters

The main properties are accessed through the Display Settings dialog (right-click menu):

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Model Display** | Choice | Coverage | How tape appears in 3D model: "Coverage" (full area), "Overlap" (only overlap zones), "None" (hidden) |
| **Shopdrawing Display** | Choice | Coverage | How tape appears in shop drawings |
| **Overlap** | Length | 150 mm | Overlap distance where two tape strips meet |
| **Minimal Opening Area** | Area | 0 mm² | Openings equal to or larger than this value are subtracted from coverage |

## Right-Click Menu

| Command | Description |
|---------|-------------|
| **Display Settings** | Open dialog to configure display modes, overlap, and opening threshold |
| **Revert Distribution** | Reset tape distribution to recalculate coverage |
| **Define Articles** | Add, edit, or remove waterproofing tape article definitions |

## Settings Files

| File | Purpose | Location |
|------|---------|----------|
| **WetGuard.xml** | Stores article definitions, display preferences, and calculation parameters | `[Company]\TSL\Settings\WetGuard.xml` or `[Install]\Content\General\TSL\Settings\WetGuard.xml` |

### WetGuard.xml Structure

The XML file contains article definitions in this format:

```xml
<Hsb_Map>
  <lst nm="Article[]">
    <lst nm="Article">
      <str nm="articleNumber" vl="WG-150-EPDM"/>
      <str nm="manufacturer" vl="BuildTech"/>
      <str nm="model" vl="EPDM Waterproof Tape"/>
      <dbl nm="ScaleY" ut="L" vl="150.0"/>
      <int nm="color" vl="4"/>
      <int nm="transparency" vl="60"/>
    </lst>
  </lst>
  <lst nm="GeneralMapObject">
    <int nm="Version" vl="1"/>
  </lst>
</Hsb_Map>
```

## Tips

- **Article Setup**: Before first use, define at least one tape article with:
  - Unique article number (for BOM tracking)
  - Manufacturer and model (for ordering)
  - Width (ScaleY) matching your actual tape width
  - Color and transparency for clear visualization

- **Automatic Overlap Calculation**: The tool automatically detects where panels meet and creates overlap zones. The overlap parameter controls how much extra tape is shown at joints.

- **Opening Exclusions**: Set "Minimal Opening Area" to automatically exclude window/door openings from tape coverage calculations. This gives more accurate BOM quantities.

- **Display Modes**:
  - **Coverage**: Shows full tape area coverage (most common for visualization)
  - **Overlap**: Shows only the overlapping regions (useful for verifying joint details)
  - **None**: Hides visual representation but still tracks hardware components

- **Color Coding**: Use different colors for different tape types (e.g., blue for EPDM, green for butyl) to distinguish them visually in complex assemblies.

- **Hardware Components**: The tool automatically generates HardWrComp objects with:
  - Total tape length (cumulated across all instances)
  - Article number for BOM
  - Link to source panel entity

- **DataLink Support**: Panels with DataLink references are fully supported, allowing the tool to work with externally referenced panel libraries.

- **Edge Detection**: The tool analyzes SipEdge objects to determine:
  - Edge direction and normal vectors
  - Adjacent panels for overlap calculation
  - Edge type (horizontal/vertical) for proper orientation

## FAQ

**Q: Why don't I see any tape coverage on my panels?**
A: Verify that:
  - At least one article is defined in WetGuard.xml
  - Model Display is set to "Coverage" or "Overlap" (not "None")
  - Your entities are valid SIP or panel types with edges
  - Color and transparency settings make the tape visible against your background

**Q: How do I add a new tape product?**
A: Right-click the tool → Define Articles → Add new entry with article number, manufacturer, model, width, color, and transparency.

**Q: The tape length in my BOM seems too long. Why?**
A: Check:
  - Overlap setting may be adding extra length at each joint
  - Multiple tool instances may be counting the same panel edges
  - Minimum Opening Area threshold may not be excluding small openings

**Q: Can I use different tape widths on the same panel?**
A: Yes. Insert multiple WetGuard tool instances, each configured with a different article definition.

**Q: What's the difference between Model and Shopdrawing display?**
A:
  - Model: How the tape appears in the 3D construction model
  - Shopdrawing: How it appears in fabrication drawings (Paper Space layouts)
  - You can show tape in one view but hide it in the other

**Q: How is overlap calculated?**
A: When two panels share an edge, the tool extends tape from each panel toward the joint by the Overlap distance. The visual overlap zone shows where tapes from both panels meet.

**Q: Can I change tape color after placement?**
A: Yes. Edit the article definition (Define Articles), modify the color value, and the tool will update automatically on recalculation.

**Q: What happens if I change the overlap value?**
A: The coverage areas and BOM quantities recalculate immediately to reflect the new overlap distance.

**Q: Why are some openings excluded from coverage?**
A: Any opening with area ≥ Minimal Opening Area is subtracted from the tape coverage. This prevents counting tape over large windows/doors.

**Q: How do I remove all tape from a panel?**
A: Either:
  - Delete the WetGuard tool instance
  - Set Model Display to "None" (keeps tool but hides visualization)

**Q: Can the tool work with external panel references?**
A: Yes. Version 1.2+ supports DataLink references, allowing panels from external libraries or databases.
