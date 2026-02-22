# hsbCLT-Presorter

## Overview

The **hsbCLT-Presorter** script creates sorted groups of CLT (Cross-Laminated Timber) child panels for nesting operations. It works in conjunction with the **hsbCLT-MasterPanelManager** to organize panels based on configurable sorting criteria such as style, thickness, surface quality, width ranges, and more.

This tool is essential for preparing CLT panels before nesting them onto master panels, allowing you to visually organize and group panels based on production requirements.

| Property | Value |
|----------|-------|
| **Script Type** | Object (O-Type) |
| **Version** | 2.0 |
| **Required Beams** | None |
| **Keywords** | XRef, Nesting, CLT, presorter, sorter, format, formatObject |
| **Primary Author** | Thorsten Huck |

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.0 | 01.10.2024 | Supports painter rules of corresponding folder, appends inverse erection sequence if specified |
| 1.28 | 15.11.2021 | Sequence numbers left padded to support sorting, display bugfix |
| 1.27 | 08.12.2020 | Childpanels not aligned with world X-Axis will be rotated |
| 1.26 | 20.10.2020 | Internal naming bugfix |
| 1.25 | 06.07.2020 | Bugfix prefix on unknown variables |
| 1.24 | 22.05.2020 | Add surface quality to sorting criterias |
| 1.23 | 02.04.2020 | Applied missing functionality of merging, bugfix on grain direction |
| 1.22 | 02.04.2020 | Add Graindirection as automatic sorting criteria, corrected Child and Header positions |
| 1.15 | 24.02.2020 | Added dependency tracking, sorting color support, header descriptions, out of range group, surface quality properties |
| 1.12 | 05.02.2020 | Create separate TSL instance for each grouping |
| 1.5 | 09.12.2019 | Group panels in width ranges |
| 1.0 | 27.07.2016 | Initial release |

## Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D model manipulation of CLT panels |
| Paper Space | No | Not applicable |
| Shop Drawing | No | Not applicable |

## Prerequisites

### Required Scripts
- **hsbCLT-MasterPanelManager** - Must be installed and accessible in one of the search paths

### Settings File
- **Location**: `[Company Path]\TSL\Settings\MasterPanelManagerSettings.xml`
- **Fallback**: `[Install Path]\Content\General\TSL\Settings\MasterPanelManagerSettings.xml`

### External Libraries
- `TslUtilities.dll` (for dialog utilities)

### Painter Definitions (Optional)
- **Location**: `TSL\hsbCLT-Presorter\` folder
- Contains advanced sorting rules using format expressions

## Entity Selection

The script accepts selection of the following entity types:

| Entity Type | Description |
|-------------|-------------|
| **MasterPanel** | Parent panels for nesting reference |
| **Sip** | Structural Insulated Panels (source for child panels) |
| **ChildPanel** | Previously created child panels |
| **TslInst (Truck)** | Truck containers with nested packages |
| **TslInst (Package)** | Package containers with nested freight items |
| **TslInst (Freight Item)** | Individual freight items containing panels |

### Recursive Extraction Process

When you select containers, the script automatically extracts nested panels:

```
Truck → Packages → Freight Items → Sip Panels
Package → Freight Items → Sip Panels
Freight Item → Sip Panel
```

This allows you to reorganize panels that have already been assigned to shipping containers or packages.

## Usage

### Step 1: Launch Script
Command: `TSLINSERT` then select `hsbCLT-Presorter.mcr`

### Step 2: Configure Parameters
A dialog appears with sorting and display options. Configure:
- Select a sorting rule
- Choose face alignment preference
- Define description properties to display

### Step 3: Select Panels
When prompted, select one or more supported entity types. The script automatically:
- Extracts all nested panels from containers
- Filters panels already nested in master panels (skipped with warning)
- Applies painter rule filtering if applicable

### Step 4: Pick Insertion Point
Click to specify where the sorted panel groups should be placed in Model Space.

### Step 5: Review Results
The script creates organized groups:
- Panels sorted according to selected rule
- Groups visually separated with offset spacing
- Header text displays sorting criteria values
- Each panel shows its description properties

## Parameters

### Sorting Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Rule** | Dropdown | First available rule | Select the sorting rule to apply. Rules come from XML settings or painter definitions. |
| **Sorting Direction** | Dropdown | Ascending | Choose Ascending or Descending order. **Only applicable for painter-based rules** (hidden for XML rules). |

### Childpanel Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Top Face Alignment** | Dropdown | Unchanged | Controls which surface quality faces up. See Face Alignment section for details. |
| **Description Properties** | Text | `@(Width)` | Define which properties to display on each child panel. Use format expressions. |

### Face Alignment Options

| Option | Behavior |
|--------|----------|
| **Unchanged** | Keep original orientation from source panel |
| **Higher Quality** | Ensures the better surface quality faces up (recommended for visible surfaces) |
| **Lower Quality** | Puts lower quality surface up (for non-visible installations) |

## Sorting Configuration

### XML-Based Rules

Sorting rules are defined in `MasterPanelManagerSettings.xml`:

1. Export settings from any instance of hsbCLT-MasterPanelManager
2. Modify or copy the "Sorting" section
3. Import modified settings via hsbCLT-MasterPanelManager

### Supported Sorting Keywords

| Keyword | Description |
|---------|-------------|
| SubLabel2 | Secondary label field |
| Style | CLT style name (e.g., CLT120, CLT160) |
| Thickness | Panel thickness |
| Package | Package assignment number |
| Quality | Quality grade |
| SurfaceQuality | Combined top/bottom quality |
| SurfaceQualityTop | Top surface quality grade |
| SurfaceQualityBottom | Bottom surface quality grade |
| Length | Panel length |
| Width | Panel width |
| Label | Primary label |
| Sublabel | Secondary label |
| Information | Info field |
| Name | Entity name |
| Element | Element assignment |
| Ranges | Width range grouping |

### Painter Rules (Advanced)

Painter definitions stored in `TSL\hsbCLT-Presorter\` enable advanced sorting:
- Use `?` separator to define sort format and display format separately
- Format: `SortFormat?DisplayFormat`
- Example: `@(Style:PL8;0)_@(Hsb_SequenceChild.InverseSequenceNumber:PL4;0:D;"0000")?@(Style:PL8;0)_@(IsPerpendicularToWorldZ)`

### Built-in Painter Rule

A default rule **"byStyle and Sequence"** is automatically created if not found:
- Sorts by Style name
- Secondary sort by inverse erection sequence number

## Width Range Grouping

Define width ranges in the settings XML to automatically group panels:

```xml
<lst nm="Range[]">
  <lst nm="Small">
    <dbl nm="min" ut="L" vl="0"/>
    <dbl nm="max" ut="L" vl="1500"/>
    <int nm="SetMPWidth" vl="1"/>
  </lst>
  <lst nm="Medium">
    <dbl nm="min" ut="L" vl="1500"/>
    <dbl nm="max" ut="L" vl="2500"/>
    <int nm="SetMPWidth" vl="1"/>
  </lst>
</lst>
```

An **"Out of range"** group is automatically created to collect panels that don't fit any defined range.

## Description Properties Format Variables

### Standard Panel Properties

| Variable | Description | Example Output |
|----------|-------------|----------------|
| `@(Width)` | Panel width | 2400 |
| `@(Length)` | Panel length | 4800 |
| `@(Thickness)` | Panel thickness | 160 |
| `@(Style)` | CLT style name | CLT160 |
| `@(Name)` | Panel name | Wall-01 |
| `@(Label)` | Panel label | W1 |
| `@(Sublabel)` | Panel sublabel | A |
| `@(SubLabel2)` | Secondary sublabel | Zone1 |
| `@(Package)` | Package number (if assigned to freight) | 1 |
| `@(Information)` | Info field text | - |
| `@(Element)` | Element assignment | E01 |
| `@(Quality)` | Quality grade | A |

### Grain Direction Variables

| Variable | Description | Example Output |
|----------|-------------|----------------|
| `@(GrainDirection)` | Displays grain direction symbol | [symbol] |
| `@(GrainDirectionText)` | Full text description | Lengthwise / Crosswise |
| `@(GrainDirectionTextShort)` | Short text description | Grain LW / Grain CW |

### Surface Quality Variables

| Variable | Description | Example Output |
|----------|-------------|----------------|
| `@(SurfaceQuality)` | Combined quality (Top + Bottom) | A(B) |
| `@(SurfaceQualityTop)` | Top surface quality | A |
| `@(SurfaceQualityBottom)` | Bottom surface quality | B |

### Component Variables

| Variable | Description | Example Output |
|----------|-------------|----------------|
| `@(SipComponent.Name)` | First component name | CLT Layer |
| `@(SipComponent.Material)` | First component material | Spruce |

### Calculated Variables

| Variable | Description | Example Output |
|----------|-------------|----------------|
| `@(Calculate Weight)` | Calculated panel weight in kg | 245.5 kg |
| `@(Hsb_Sequencechild.SequenceNumber)` | Sequence number (left-padded) | 00012 |

### Format Syntax

- Separate multiple entries with semicolons: `@(Width);@(Length)`
- Use `\P` to insert line breaks: `@(Width)\P@(Length)`

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Show Dependencies** | Display trace lines connecting child panels to their source SIP panels. Prompts for specific panels or Enter for all. |
| **Hide Dependencies** | Remove trace lines from view. |
| **Rotate All 90 degrees** | Rotate all child panels in the group by 90 degrees around their centers. |
| **Rotate 90 degrees** | Prompts for panel selection, then rotates selected panels by 90 degrees. |
| **Rotate 180 degrees** | Prompts for panel selection, then rotates selected panels by 180 degrees. |
| **Flip + Rotate Child** | Prompts for panel selection, then flips and rotates selected panels. |
| **Flip Child** | Prompts for panel selection, then flips selected panels (swaps top/bottom surfaces). |

### Double-Click Action
Double-clicking the instance toggles between Show/Hide Dependencies view.

## Automatic Behaviors

### Primary Sorting by Grain Direction
Grain direction is **always used as the first sorting criteria**, regardless of the selected rule. This ensures:
- Lengthwise panels are grouped together
- Crosswise panels are grouped together

### Auto-Rotation for Oversized Panels
Panels are automatically rotated if:
- Width (perpendicular to grain) exceeds maximum master panel width
- Length (parallel to grain) is within maximum master panel width

### Inverse Erection Sequence
The script automatically calculates and assigns inverse erection sequence numbers:
- Calculated per building phase
- Supports production workflows where panels are stacked in reverse installation order
- Stored in `Hsb_SequenceChild.InverseSequenceNumber`

### Multi-Instance Creation
For large quantities with multiple groups:
- Each group creates a separate TSL instance
- Each instance maintains its own header and organization
- Original instance is replaced by group instances

## Tips

### Width Range Optimization
- Define width ranges to automatically group panels by master panel width categories
- Useful for optimizing master panel utilization
- Check the "Out of range" group for panels needing special handling

### Surface Quality Alignment
- Use "Higher Quality" alignment for panels with visible surfaces
- The script compares quality grades and flips panels as needed
- Quality is determined from SipStyle or panel overrides

### Freight Integration
- Select trucks or packages to reorganize already-shipped panels
- Panels already nested in master panels are skipped with a warning message

### Custom Sorting Rules
- Create painter definitions in `TSL\hsbCLT-Presorter\` for project-specific sorting
- Use the `?` separator for different sort and display formats
- Painter rules can include filter expressions

### Settings Customization
- Each sorting rule can specify a display color
- Header text supports all format variables
- Rules can be combined with filter conditions

### Performance
- For large panel sets, consider filtering by painter rules first
- Groups are processed independently for better performance

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Panels not sorting correctly | Verify the **Rule** property matches a rule name in settings file |
| Missing panels after processing | Check console for "already nested" warnings |
| Surface quality not flipping | Ensure quality grades are defined in SipStyle |
| Format variable shows "not found" | Verify variable name matches exactly (case-insensitive) |
| Painter rules not appearing | Check files are in `TSL\hsbCLT-Presorter\` folder with `@(` in format |

## FAQ

**Q: How do I change what information is shown on the group label?**
A: Select the script instance, open Properties (Ctrl+1), and modify the **Description Properties** field using format expressions like `@(Width);@(Length)`.

**Q: Why aren't my panels sorting correctly?**
A: Verify that the **Rule** property matches a rule name defined in your `hsbCLT-MasterPanelManager` settings file. Check for typos in the rule name.

**Q: Can I rotate just one panel instead of the whole group?**
A: Yes, right-click the script instance and select **Rotate 90 degrees** or **Rotate 180 degrees**, then click only the specific panel you wish to modify.

**Q: How do I trace which source panels my child panels came from?**
A: Double-click the Presorter instance or right-click and select **Show Dependencies** to display trace lines connecting child panels to their source SIP panels.

**Q: What is the Sorting Direction option for?**
A: This option only appears for painter-based rules and allows reversing the sort order. It is hidden for XML-based rules which define their own order.

**Q: Why are some panels skipped during processing?**
A: Panels already nested in master panels are skipped. Check the command line for messages indicating which panels were skipped and why.

## Related Scripts

| Script | Relationship |
|--------|--------------|
| **hsbCLT-MasterPanelManager** | Parent script that manages nesting operations and provides settings |
| **hsbCLT-Nest** | Performs actual nesting of child panels onto master panels |
| **hsbCenterOfGravity** | Used internally for weight calculations |
