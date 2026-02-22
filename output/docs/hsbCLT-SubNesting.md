# hsbCLT-SubNesting

Creates a standalone CLT (Cross-Laminated Timber) subnesting panel from a masterpanel, representing the combined outline of all nested child panels with their properties and tooling operations cloned for CNC manufacturing.

---

## Overview

The hsbCLT-SubNesting script generates a new panel entity that represents a "subnesting" view of a CLT masterpanel. This subnesting panel captures the combined boundary of all nested child panels within the masterpanel, including their oversizes, and provides capabilities to clone various tooling operations (drills, cuts, beamcuts, freeprofiles, slots, mortises) from the child panels to the subnesting panel.

Key capabilities:
- Creates a unified contour panel from all nested child panels within a masterpanel
- Clones properties (Name, Label, Sublabel, Sublabel2, Grade, Material, Information) from the masterpanel using format expressions
- Transfers tooling operations (drills, cuts, beamcuts, freeprofiles, slots, mortises) as static tools to the subnesting panel
- Supports shop drawing display with configurable display settings via DimRequest system
- Maintains grain direction and surface quality from the original child panels
- Respects oversize settings from the hsbCLT-MasterPanelManager if attached
- Visualizes child panel contours and openings with configurable colors and linetypes

---

## Environment

| Property | Value |
|----------|-------|
| Script Type | O-Type (Object) |
| Environment | Model Space |
| Beams Required | 0 |
| Version | 2.4 |
| Keywords | Nesting; Subnesting; Masterpanel; CLT; Shopdrawing |

---

## Prerequisites

Before using this script:

1. **Masterpanel with Nested Children**: The target masterpanel must contain at least one nested child panel. If no child panels exist, the script will refuse creation with message: "Creation refused for masterpanel [number] because no child panels could be found."

2. **No Existing Subnesting**: The masterpanel must not already have a subnesting panel attached. If a subnesting already exists for the masterpanel, creation is refused with message: "Creation refused for masterpanel [number] because subnesting panel exists."

3. **Optional - MasterPanelManager**: If an hsbCLT-MasterPanelManager is attached to the masterpanel, its oversize and spacing settings will be respected automatically.

4. **Settings File** (Optional): A settings file (`hsbCLT-SubNesting.xml`) in the company TSL Settings folder can pre-configure default format expressions and display options.

---

## Usage

### Insertion Workflow

1. Run the script via the hsbCAD toolbar or command line
2. When prompted ("Select masterpanels"), select one or more masterpanels
3. Pick an insertion point for the subnesting panel(s)
4. If no settings file exists with a predefined Format, a dialog appears to configure the display format
5. The subnesting panel is created at the specified location

### After Insertion

Once created, the subnesting panel:
- Automatically tracks changes to the parent masterpanel and child panels
- Reference point is set to the lower right corner of the subnesting panel
- Can be repositioned by moving the grip point
- Provides context menu commands for cloning tools and adjusting settings
- Displays child panel contours in a configurable color with optional linetype styling

---

## Parameters

### Properties Palette (OPM)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Format** | String | (varies) | Defines the text and/or attributes displayed on the subnesting. Multiple lines are separated by `\P`. Use format expressions like `@(PosNum)`, `@(Name)`, `@(Style)` to display masterpanel properties. |

### Available Format Variables

The following format variables can be used in the Format property:

| Variable | Description | Source |
|----------|-------------|--------|
| `@(PosNum)` | Position number of the masterpanel | MasterPanel |
| `@(Name)` | Name of the masterpanel | MasterPanel |
| `@(Information)` | Information field of the masterpanel | MasterPanel |
| `@(Style)` | Style of the masterpanel | MasterPanel |
| `@(GrainDirection)` | Displays grain direction symbol (8 blanks placeholder for visual indicator) | First child panel |
| `@(GrainDirectionText)` | Text: "Lengthwise" or "Crosswise" based on grain direction relative to world X-axis | Calculated |
| `@(GrainDirectionTextShort)` | Short text: "Grain LW" or "Grain CW" | Calculated |
| `@(SurfaceQuality)` | Combined surface quality (bottom and top in parentheses) | MasterPanel/Style |
| `@(SurfaceQualityTop)` | Top surface quality | MasterPanel/Style |
| `@(SurfaceQualityBottom)` | Bottom surface quality | MasterPanel/Style |
| `@(SipComponent.Name)` | Name of the first SIP component | SipStyle |
| `@(SipComponent.Material)` | Material of the first SIP component | SipStyle |
| `@(ChildData)` | List of all nested child panels (name:grade format, semicolon-separated) | All child panels |

**Example Format String:**
```
@(PosNum)\P@(Name)\P@(Style)\P@(GrainDirection)
```

---

## Context Menu

### Tool Cloning Commands

These commands clone tooling operations from child panels to the subnesting panel as static tools:

| Command | Description | Filter Options |
|---------|-------------|----------------|
| **Clone all tools** | Clones all supported tool types at once | No filters - clones all drills, beamcuts, freeprofiles, cuts, slots, mortises |
| **Clone Drills** | Opens dialog to filter and clone drill operations | Diameter (range or list), Alignment (Perpendicular/Beveled/All), Face (Bottom/Top/Through/Edge/All) |
| **Clone Beamcuts** | Opens dialog to filter and clone beamcut operations | Alignment (Perpendicular/Beveled/All), Face (Bottom/Top/Through/Edge/All) |
| **Clone Freeprofiles** | Opens dialog to filter and clone freeprofile operations | Tool name (Any/specific), Face (Bottom/Top/Edge/All) |
| **Clone Cuts** | Opens dialog to filter and clone beveled cut operations | Tool name (Any/specific), Alignment (Beveled only) |
| **Clone Slots** | Opens dialog to filter and clone slot operations | Tool name (Any/specific) |
| **Clone Mortises** | Opens dialog to filter and clone mortise operations | Alignment (All), Rounding Type (Not round/Round/Rounded/Explicit Radius/Any) |

### Filter Dialog Details

#### Clone Drills Dialog
| Parameter | Options | Description |
|-----------|---------|-------------|
| Diameter | Empty, single value, list, or range | Filter drills by diameter. Empty = all diameters |
| Alignment | All, Perpendicular, Beveled | Filter by drill alignment angle |
| Face | All, Bottom, Top, Through, Edge | Filter by which face the drill enters |

#### Clone Freeprofiles Dialog
Available tools are automatically detected from child panels, including:
- hsbCLT-TongueGroove (grouped under single entry)
- hsbCLT-X-Fix variants (grouped under "hsbCLT-X-Fix")

### Tool Removal Commands

| Command | Description | Visibility |
|---------|-------------|------------|
| **Remove All Tools** | Removes all static tools from the subnesting panel | Always visible |
| **Remove Drills** | Removes all static drill tools | Only if drills exist |
| **Remove Beamcuts** | Removes all static beamcut tools | Only if beamcuts exist |
| **Remove Freeprofiles** | Removes all static freeprofile and solid subtraction tools | Always visible |
| **Remove Cuts** | Removes all static cut tools | Only if cuts exist |
| **Remove Slots** | Removes all static slot tools | Always visible |
| **Remove Mortises** | Removes all static mortise tools | Always visible |

### Settings Commands

| Command | Description |
|---------|-------------|
| **Display settings** | Opens dialog to configure display properties |
| **Property Cloning Settings** | Opens dialog to configure how masterpanel properties are cloned to subnesting panel |
| **Import Settings** | Imports settings from the XML configuration file (only visible if file exists) |
| **Export Settings** | Exports current settings to the XML configuration file |
| **Export Default Settings** | Exports default settings (only shown if no settings file exists) |

---

## Display Settings

Configure via the "Display settings" context command:

### General Display

| Setting | Default | Description |
|---------|---------|-------------|
| DimStyle | First available | Dimension style for text display |
| Text Height | 100mm | Height of displayed text |
| Color | 3 (Green) | Color for main text display and grain direction symbol |

### Child Contour Display

| Setting | Default | Description |
|---------|---------|-------------|
| Color | 253 | Color for child panel outer contours |
| Color Openings | 171 | Color for opening contours within child panels |
| LineType | CONTINUOUS | Line type for child contours |
| LineType Scale | 1 | Scale factor for non-continuous line types |

---

## Property Cloning Settings

Configure via the "Property Cloning Settings" context command to define how properties are mapped from the masterpanel to the subnesting panel:

| Property | Default Format | Description |
|----------|----------------|-------------|
| Name | `@(Information)_@(Name)` | Derived from masterpanel information and name (leading underscore removed if present) |
| Label | `@(Posnum)` | Position number |
| Sublabel | (empty) | Not cloned by default |
| Sublabel2 | (empty) | Not cloned by default |
| Grade | (empty) | Not cloned by default |
| Material | (empty) | Not cloned by default |
| Information | (empty) | Not cloned by default |

---

## Child Panel Oversize Behavior

### Standard Oversize
Child panels use the oversize value from the attached hsbCLT-MasterPanelManager if available.

### Sublabel2 Override (v2.0+)
Individual child panels can override the default oversize by specifying a value in their Sublabel2 field:

| Sublabel2 Format | Behavior |
|------------------|----------|
| Empty or "HU" | Uses MasterPanelManager default oversize |
| `Route;20` | Uses 20mm oversize (semicolon-separated, last value is offset) |
| Other text | Uses MasterPanelManager default oversize |

This allows fine-grained control over nesting gaps for specific panels.

---

## Visual Indicators

### Contour Validation
The script automatically validates the subnesting panel shape against the calculated contour:
- **Green areas**: Contour regions that differ from the panel shape
- **Red areas**: Panel regions that differ from the calculated contour
- These differences auto-correct on the next recalculation

### Child Panel Display
When the subnesting panel is visible:
- Outer contours of child panels are drawn in the configured child color
- Opening contours (inner rings) are drawn in the configured opening color
- Line type can be set to non-continuous for visual distinction

### Grain Direction Symbol
If `@(GrainDirection)` is included in the Format property, a diamond-shaped arrow symbol is drawn at the corresponding line position to indicate grain direction.

---

## Shop Drawing Integration

The script outputs DimRequest data for use with shop drawing scripts (e.g., `sd_EntitySymbolDisplay`):

| DimRequest Content | Description |
|-------------------|-------------|
| Text labels | Format string content with resolved variables |
| Grain direction symbol | PLine for grain direction indicator |
| Child contours | PLine rings for outer contours |
| Opening contours | PLine rings for inner openings |

DimRequest properties include:
- AllowedView direction (panel normal)
- AlsoReverseDirection flag
- Color, LineType, LineTypeScale
- Text and textHeight
- Location point and coordinate system vectors

---

## Tips

### Best Practices

1. **Create Subnesting After Design is Complete**: Create the subnesting panel after all child panels are properly nested and positioned within the masterpanel.

2. **Use MasterPanelManager**: Attach an hsbCLT-MasterPanelManager to your masterpanels to automatically handle oversize values for proper nesting gaps.

3. **Clone Tools Selectively**: Rather than using "Clone all tools", use individual cloning commands to filter only the operations needed for manufacturing. This reduces processing time and avoids unnecessary tool clutter.

4. **Diameter Range Syntax for Drills**: When cloning drills, use:
   - Single values: `20` (only 20mm diameter)
   - Multiple values: `20;40` (only 20mm and 40mm)
   - Ranges: `0-20` (all diameters up to 20mm)
   - Empty: All diameters

5. **Sublabel2 for Custom Oversize**: Child panels can have custom oversize values specified in their Sublabel2 field, overriding the MasterPanelManager default.

6. **Pre-configure with Settings File**: Create a settings XML file with your standard Format string to skip the format dialog during insertion.

### Troubleshooting

| Issue | Solution |
|-------|----------|
| Subnesting not created | Verify the masterpanel contains at least one nested child panel and no subnesting already exists |
| Contour shows green/red differences | The subnesting panel shape differs from the calculated contour. This auto-corrects on the next recalculation |
| Tools not cloning | Verify the filter criteria (diameter, alignment, face) match the source tools |
| Grain direction not displayed | Include `@(GrainDirection)` in your Format string to show the grain direction symbol |
| Tongue/Groove not cloning | Tongue/Groove connections are accepted for tool cloning via freeprofiles - use "Clone Freeprofiles" |
| X-Fix connectors missing | X-Fix connectors defined by freeprofile are supported in version 2.4+ |

### Settings File Location

Settings are stored in:
```
[Company Path]\TSL\Settings\hsbCLT-SubNesting.xml
```

The settings file can contain:
- `Format`: Pre-defined format string (skips dialog on insert)
- `Display`: Display configuration map (TextHeight, Color, DimStyle)
- `DisplayChild`: Child contour display configuration (Color, ColorOpening, LineType, LineTypeScale)
- `PropertyCloning`: Property mapping configuration (Name, Label, Sublabel, Sublabel2, Grade, Material, Information)

---

## Related Scripts

| Script | Relationship |
|--------|--------------|
| hsbCLT-MasterPanelManager | Provides oversize and spacing settings respected by subnesting |
| sd_EntitySymbolDisplay | Consumes DimRequest data for shop drawing display |
| hsbCLT-TongueGroove | Freeprofile tool type that can be cloned |
| hsbCLT-X-Fix | X-Fix tool types that can be cloned as freeprofiles |
| hsbTslSettingsIO | General utility for importing customized settings |

---

## Version History

| Version | Date | Description |
|---------|------|-------------|
| 2.4 | 31.07.2023 | X-Fix added if defined by freeprofile |
| 2.3 | 31.07.2023 | New context commands to clone and remove mortises |
| 2.2 | 24.05.2023 | Slots can be cloned, settings accessible via context command |
| 2.1 | 23.05.2023 | Beveled cuts operating on panel edge can be cloned |
| 2.0 | 23.05.2023 | Sublabel-based override of oversize, tongue/groove connections accepted for tool cloning |
| 1.9 | 31.05.2022 | Clone beamcuts, freeprofiles supporting parent TSLs, sequential adding |
| 1.8 | 31.05.2022 | New context commands to clone beamcuts |
| 1.7 | 25.05.2022 | Clone drills as static tool to subnesting |
| 1.6 | 06.07.2021 | Reference changed to lower right corner |
| 1.5 | 26.05.2021 | Transformation subnesting published |
| 1.4 | 11.05.2021 | Name formatting corrected |
| 1.3 | 11.05.2021 | Name and order# written to concatenated string |
| 1.2 | 11.05.2021 | Contour detection enhanced, oversize and openings supported |
| 1.1 | 17.07.2019 | Shop drawing display support |
| 1.0 | 16.07.2019 | Initial release |
