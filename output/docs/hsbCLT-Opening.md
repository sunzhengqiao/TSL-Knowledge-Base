# hsbCLT-Opening

## Description

The hsbCLT-Opening script is designed for Cross-Laminated Timber (CLT) panel machining. It replaces openings in CLT panels (SIP elements) with surrounding tooling operations. This tool automatically detects windows, doors, and edge cutouts in panels and converts them into CNC-ready machining operations.

The script supports multiple strategies for handling openings, including midpoint tools, corner tools, direct openings, extrusions, housing tools, and mortise tools. It is particularly useful for preparing CLT panels for manufacturing by defining how openings should be machined.

## Script Information

| Property | Value |
|----------|-------|
| **Script Type** | O (Object) |
| **Version** | 2.9 |
| **Last Updated** | 30/04/2025 |
| **Beams Required** | 0 |

## Properties

### General Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Strategy** | String (Dropdown) | Midpoint Tool | Defines the strategy of the tool. Options: Midpoint Tool, Corner Tool, Opening, Extrusion, Housing Tool, Mortise Tool |
| **Filter by Area** | String | (empty) | Filters shapes matching a condition. Specify area in m2 (metric) or drawing units (imperial) with leading logical condition (e.g., <=0.7) |

### Tooling Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Radius** | Double | 0 | Defines the radius of a potential opening. Negative values create cleanup radius corners, positive values round corners |
| **Offset X** | Double | 200mm | Defines the X offset of the tool. For Midpoint strategy: offset from corner. For Corner strategy: length from corner |
| **Offset Y** | Double | 0 | Defines the Y offset of the tool. For Midpoint strategy: offset from corner. For Corner strategy: length from corner |
| **Width** | Double | 8mm | Defines the width of the tool. Slot if width <= 20mm, otherwise beam cut |
| **Depth** | Double | 0 | Defines the depth of the tool. 0 = complete through cut |
| **Face** | String (Dropdown) | Reference Side | Defines which face the tool is applied to. Options: Reference Side, Opposite Side |

### Edge Opening Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Length Edge Cut** | Double | 0 | Defines the length of the cut on the edge. Only applicable for tools on the bounding edge of a panel |
| **Reinforcement Width** | Double | 200mm | Defines the width of the supporting part. Only applicable for tools on the bounding edge of a panel |

### Display Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Format** | String | (empty) | Defines the format variable and/or static text for display. Example: @(Area:CU;m:RL3)m2 displays area in m2 rounded to 3 decimal digits |

## Strategy Options

| Strategy | Description | Use Case |
|----------|-------------|----------|
| **Midpoint Tool** | Creates tools at the midpoint of opening edges | Standard rectangular openings |
| **Corner Tool** | Creates tools at the corners of openings | Corner-specific machining |
| **Opening** | Keeps the opening as-is without additional tools | Simple through-holes |
| **Extrusion** | Converts openings into extrusion tools (pockets) | Pocket machining |
| **Housing Tool** | Creates housing/rebate machining | Rebate joints |
| **Mortise Tool** | Creates mortise machining | Mortise joints |

## Usage Workflow

### Inserting the Tool

1. **Launch the command** by typing the insert command or clicking the toolbar button
2. **Configure properties** in the dialog that appears (Strategy, Radius, Offsets, etc.)
3. **Select CLT panels** when prompted - click on one or more SIP/CLT panels
4. **Pick openings** by clicking inside individual openings, or use keywords:
   - Press **Enter** or type **Shapes** to apply to all detected openings
   - Type **Openings** to apply only to window-type openings
   - Type **Cutouts** to apply only to door/edge cutouts
   - Type **Polylines** to select existing polylines as opening shapes
   - Type **setArea** to filter openings by area size

### Selection Preview

During insertion, the tool provides visual feedback:
- **Dark green**: Midpoint Tool strategy
- **Orange**: Corner Tool strategy
- **Dark yellow**: Opening strategy
- **Purple**: Extrusion strategy
- **Green**: Housing Tool strategy
- **Yellow**: Mortise Tool strategy

Openings under the cursor are highlighted in dark yellow outline.

### After Insertion

Once inserted, the tool:
- Automatically detects and classifies openings (windows vs. doors/edge cutouts)
- Associates with the parent CLT panel and element
- Applies the selected machining strategy
- Updates automatically when the panel geometry changes

## Context Menu Commands

Right-click on an inserted hsbCLT-Opening tool to access these commands:

| Command | Description |
|---------|-------------|
| **Flip Side** | Toggles between Reference Side and Opposite Side (also triggered by double-click) |
| **Clone Tool** | Creates a copy of the tool with the option to modify parameters |
| **Edit Shape** | Creates an editable polyline of the opening shape for manual modification |
| **Reset + Erase** | Restores the original opening in the panel and removes the tool |
| **Configure Display** | Opens settings for annotation, linework, and dimension options |
| **Add Tool Dimpoints to Shopdrawing** | Adds dimension reference points for shop drawings |
| **Remove Tool Dimpoints from Shopdrawing** | Removes dimension reference points from shop drawings |
| **Show all Commands for UI Creation** | Displays all available LISP commands for creating toolbar buttons |

## Settings and Configuration

The tool uses XML configuration files located at:
- **Company settings**: `[Company Path]\TSL\Settings\hsbCLT-Opening.xml`
- **Installation defaults**: `[Install Path]\Content\General\TSL\Settings\hsbCLT-Opening.xml`

### Display Configuration

Use the **Configure Display** command to customize:

**Annotation Settings:**
- DimStyle selection
- Text height (0 = by DimStyle, negative = do not show in model)
- Text color

**Linework Settings:**
- Line color
- Transparency
- Linetype
- Linetype scale

**Dimension Settings:**
- Stereotype assignment
- Enable/disable automatic dimensioning in shop drawings

## Integration with Shop Drawings

The hsbCLT-Opening tool integrates with the shop drawing system (sd_Opening). When dimension points are added:
- Opening corners and reference points appear in shop drawings
- Dimension requests are published for automated dimensioning
- Custom stereotypes can be assigned for drawing layer control

## Tips for Timber Designers

1. **Use area filtering** when working with panels that have many small openings (like service holes) mixed with large openings (windows/doors). Example: `>=0.5` to only process openings larger than 0.5 m2.

2. **Negative radius values** create "cleanup" corners useful for CNC machining where internal corners need relief cuts.

3. **The Reinforcement Width** property is useful for door openings where the panel edge needs structural support framing.

4. **Double-click** on the tool to quickly flip between Reference and Opposite sides.

5. **Clone Tool** allows efficient batch configuration - set up one tool correctly, then clone it to other openings with slight modifications.

## Keyboard Shortcuts During Insertion

| Keyword | Action |
|---------|--------|
| P | Select Polylines as opening shapes |
| O | Apply to all Openings only |
| C | Apply to all Cutouts/Doors only |
| S | Apply to all Shapes |
| A | Set Area filter |

## Related Scripts

- `hsbCLT-Freeprofile` - Used for CNC tool definitions
- `sd_Opening` - Shop drawing opening representation
- Other hsbCLT-* scripts for CLT-specific operations
