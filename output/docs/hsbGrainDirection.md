# hsbGrainDirection

## Overview

The **hsbGrainDirection** script displays and controls the grain direction of CLT (Cross-Laminated Timber) and SIP (Structural Insulated Panel) panels in hsbCAD. It provides visual indicators for wood grain orientation, surface quality information, and production type settings. The script automatically assigns property sets, manages nesting face preferences for manufacturing, and supports optional marking drills for production identification.

This tool is essential for CLT and panel production workflows where grain direction affects structural performance, visual appearance, and CNC machine operations.

---

## Usage Environment

| Property | Value |
|----------|-------|
| Script Type | O (Object) |
| Beams Required | 0 |
| Version | 7.14 |
| Keywords | Graindirection, CLT, Sip |
| Space | Model Space |
| Category | Panel / CLT Tools |

---

## Prerequisites

Before using this script, ensure:

1. **Panel entities exist** - You must have one or more SIP or CLT panels in the drawing
2. **Element structure** (optional) - Panels derived from Wall or Roof/Floor elements will have automatic association detection
3. **Settings file** (optional) - For advanced features, create `hsbGrainDirection.xml` in `<Company>\TSL\Settings\`
4. **TypeWriter.xml** (optional) - Required for 3D text display in IFC exports

---

## Step-by-Step Usage Guide

### Inserting the Grain Direction Tool

1. Launch the script via the hsbCAD command line or ribbon menu
2. A **dialog box** appears with default property values
3. Configure the initial settings:
   - **Production Type**: Choose "Transverse" or "Lengthwise"
   - **Association**: Select "Wall", "Roof/Floor", or "Automatic"
   - **Format**: Define the display text format
4. Click **OK** to confirm
5. **Select panels or elements** when prompted:
   - Click directly on SIP/CLT panels, OR
   - Select entire Wall/Roof/Floor elements containing panels
6. Press **Enter** to complete the selection
7. The grain direction symbol and text appear on each selected panel

### Changing the Grain Direction

**Method 1: Rotate 90 Degrees**
1. Select the grain direction instance on a panel
2. Right-click and choose **"Rotate grain direction"**
3. The grain rotates 90 degrees and the production type toggles automatically

**Method 2: Define Custom Direction**
1. Select the grain direction instance
2. Right-click and choose **"Change grain direction"**
3. **Pick the first point** to define the direction origin
4. **Pick the second point** to define the direction
5. A jig preview shows the new grain orientation as you move the cursor
6. Click to confirm the new direction

**Method 3: Double-Click**
- Double-click on the grain direction symbol to rotate it 90 degrees

### Configuring Display Settings

1. Select any grain direction instance
2. Right-click and choose **"Settings"**
3. A settings dialog appears with the following options:

| Category | Setting | Description |
|----------|---------|-------------|
| Display | Suppress Plan View Qualities | List of surface quality names to hide in plan view (semicolon-separated) |
| Solid Display | Graindirection | Show as 3D solid (No/Yes/byBlock) |
| Solid Display | Width | Width of the grain direction outline |
| Solid Display | 3D-Text | Display text as 3D geometry (Disabled/Reference Side/Top Side/Both Sides) |
| Solid Display | 3D-Grain | Display grain symbol as 3D geometry |
| Solid Display | Outline Width | Width for character outlines in 3D text |
| Behaviour | Grain-Axis Relation | Control panel X-axis alignment (Unchanged/X-Axis/Y-Axis) |
| Behaviour | Preferred Nesting Face Floor | Override nesting orientation for floor panels (Disabled/Z-World/Negative Z-World) |
| Behaviour | Association path | Path in extended data for automatic association (format: propSetName/propName) |

4. Click **OK** to apply settings to all grain direction instances in the drawing

---

## Properties Panel Parameters

The following properties are available in the AutoCAD Properties Palette (OPM) when a grain direction instance is selected:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Production Type | Dropdown | Transverse | Defines the orientation of the top layer during production. Options: "Transverse", "Lengthwise". The dimension perpendicular to the grain direction specifies the max production width. (Read-only after insertion) |
| Max. Production Width | Length | 3000 mm | Sets the maximal production width. A warning appears if the panel width exceeds this value. |
| Association | Dropdown | Automatic | Defines whether the panel is associated with a Wall (W) or Floor/Roof (D). Select "Automatic" for panels derived from elements. |
| **Display Category** | | | |
| Format | String | @(PosNum)\P@(SurfaceQuality) | Defines the text content displayed on the panel. Multiple lines separated by `\P`. Supports format expressions like `@(PropertyName)`. |
| Dimstyle | Dropdown | (Available styles) | Dimension style for text appearance |
| Text Height | Length | 60 mm | Height of displayed text in panel views |
| Colors | String | 1;4 | Color indices for the grain symbol. Separate Wall and Floor colors with semicolon. |
| **Display Plan View** | | | |
| Text Height | Length | 60 mm | Text height in plan view (0 = do not display) |

### Format Expression Reference

Use these expressions in the Format property:

| Expression | Description |
|------------|-------------|
| `@(PosNum)` | Panel position number |
| `@(SurfaceQuality)` | Combined surface quality (Top/Bottom) |
| `@(SurfaceQualityTop)` | Top surface quality name |
| `@(SurfaceQualityBottom)` | Bottom/reference surface quality name |
| `@(Weight:RL1)` | Panel weight with rounding (e.g., "89.6 kg") |
| `@(Style)` | Panel style name |
| `@(Name)` | Panel name |
| `@(ExtendedProperties.GrainDirection)` | Grain direction from extended properties |
| `@(Hsb_SequenceChild.Buildingphase)` | Building phase from ErectionSequence TSL |

---

## Right-Click Menu Options

When you select a grain direction instance and right-click, the following context menu commands are available:

### Root Level Commands

| Command | Description |
|---------|-------------|
| **Rotate grain direction** | Rotates the grain 90 degrees and toggles the production type |
| **Change grain direction** | Pick two points to define a custom grain direction |
| **Override Nesting Face => Reference Side** | Set the preferred nesting face to reference side (appears when nesting face is set to top) |
| **Override Nesting Face => Top Side** | Set the preferred nesting face to top side (appears when nesting face is set to reference) |
| **Remove Override Nesting Face** | Remove the manual nesting face override |

### Submenu Commands

| Command | Description |
|---------|-------------|
| **Settings** | Open the settings dialog for display and behavior options |
| **Update Project Path** | Update the project path stored in the property set |
| **Add/Remove Format** | Modify the format expression for displayed text |
| **Add Marking Drill** | Add a marking drill to the panel (if configured in settings) |
| **Remove Marking Drill** | Remove the marking drill from the panel |
| **Set Marking Depth/Alignment** | Configure the depth and side of the marking drill |
| **Import Settings** | Import settings from the XML file |
| **Export Settings** | Export current settings to the XML file |
| **Define Character** | Define custom characters for 3D text display by selecting polylines |

---

## Settings Files

### Main Settings File

**Location**: `<Company>\TSL\Settings\hsbGrainDirection.xml`

**Fallback**: `<Install>\Content\General\TSL\Settings\hsbGrainDirection.xml`

This XML file controls:
- Display options (text orientation, hidden qualities)
- 3D solid display settings
- Grain-axis relationship mapping
- Marking drill configuration
- Nesting face preferences

### TypeWriter Settings File

**Location**: `<Company>\TSL\Settings\TypeWriter.xml`

**Fallback**: `<Install>\Content\General\TSL\Settings\TypeWriter.xml`

Required for 3D text display features. Contains:
- Font definitions
- Character polyline shapes
- Versal height settings

### Marking Drill Configuration

The settings file can include a `MarkingDrill` section with:

| Parameter | Description |
|-----------|-------------|
| Activated | Enable/disable marking drill (0/1) |
| color | Display color for the drill symbol |
| textHeight | Height of description text |
| diameter | Drill diameter |
| depth | Drill depth (negative for opposite side) |
| offset | Offset from panel edge |
| side | Which side of panel (-1 or 1) |
| description | Text label for the drill |
| Condition[] | Conditions that must be met (SurfaceQualityTop, SurfaceQualityBottom, Association) |
| BlockadeTsl[] | TSL scripts that prevent marking drill insertion |

---

## Tips

1. **Production Width Warnings**: If a panel exceeds the maximum production width, a red warning symbol "!" appears. Adjust the production type or panel dimensions accordingly.

2. **Automatic Association**: When using "Automatic" association, the script detects:
   - Panels from ElementWall become "Wall" association
   - Panels from ElementRoof/ElementFloor become "Roof/Floor" association
   - Free panels perpendicular to Z-World become "Wall"
   - Other free panels become "Roof/Floor"

3. **Custom Blocks**: Create blocks named `hsbGrainDirectionWall` and `hsbGrainDirectionFloor` in your drawing to use custom symbols instead of the default arrow.

4. **Format Expressions**: Use `\P` to create multi-line text. For example: `@(PosNum)\P@(SurfaceQualityTop)\P@(SurfaceQualityBottom)`

5. **IFC Export**: Enable "3D-Text" in settings to include grain direction text in IFC exports as 3D geometry.

6. **Nesting Preferences**: For floor panels with identical surface qualities on both faces, set the "Preferred Nesting Face Floor" setting to control which side faces up during CNC nesting.

7. **Execution Order**: The script automatically ensures it executes last among all TSLs attached to a panel, so grain direction display reflects all other modifications.

8. **Property Sets**: The script automatically finds and updates property sets containing a "ProductionType" property.

---

## Frequently Asked Questions

**Q: Why does my grain direction symbol not appear?**

A: Ensure you have selected valid SIP or CLT panels. The script does not attach to regular beams or sheets. Also check that the panel does not already have a grain direction instance attached.

**Q: How do I change the color of the grain direction symbol?**

A: Edit the "Colors" property in the Properties Panel. Use two color indices separated by semicolon (e.g., "1;4") where the first color is for Wall association and the second for Roof/Floor.

**Q: The production type is read-only. How can I change it?**

A: Production type can only be set during insertion. After insertion, use "Rotate grain direction" to toggle between Transverse and Lengthwise.

**Q: My surface quality text is not showing in plan view.**

A: Check the "Text Height" property under "Display Plan View". A value of 0 disables plan view text. Also verify the quality name is not in the "Suppress Plan View Qualities" list in settings.

**Q: How do I export grain direction for IFC?**

A: Open Settings, set "3D-Text" to "Reference Side", "Top Side", or "Both Sides". This creates 3D solid geometry that exports with IFC.

**Q: The marking drill is not appearing. What should I check?**

A: Verify that:
1. The settings file has `MarkingDrill.Activated` set to 1
2. The panel meets all conditions in `MarkingDrill.Condition[]`
3. No blocking TSLs from `BlockadeTsl[]` are attached to the panel

**Q: Can I apply grain direction to multiple panels at once?**

A: Yes. During insertion, select multiple SIP panels or select entire Wall/Roof/Floor elements. The script creates individual instances for each panel.

**Q: What happens when I copy a panel with grain direction?**

A: The grain direction instance is copied along with the panel and maintains its settings.

---

## Related Scripts

- **sd_EntitySymbolDisplay** - Shop drawing entity symbol display (supports grain direction dimension requests)
- **hsbCenterOfGravity** - Calculates panel weight used by grain direction formatting
- **ErectionSequence** - Provides building phase data accessible via format expressions

---

## Version History

| Version | Date | Description |
|---------|------|-------------|
| 7.14 | 06.10.2025 | Acceptance of plan view alignment tolerances |
| 7.13 | 10.09.2025 | Add outer contour area calculation for extended data |
| 7.12 | 11.04.2025 | Fix ExtendedDataAssociation setting; Fix text orientation |
| 7.11 | 10.04.2025 | Add ExtendedDataAssociation parameter in settings |
| 7.10 | 09.04.2025 | Add 3DGrain parameter in settings |
| 7.0 | 08.05.2023 | Allow comma or semicolon separation for color association |
| 6.5 | 25.10.2022 | New preferred nesting face settings for floor panels |
| 5.3 | 05.03.2021 | Settings exposed to context command; 2D/3D display toggle |
