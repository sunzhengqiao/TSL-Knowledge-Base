# hsbCLT-Slot-Distribution

Distributes multiple slots (grooves) across coplanar CLT/Sip panels in a parametric pattern.

---

## Overview

The **hsbCLT-Slot-Distribution** tool creates a series of evenly or fixed-spaced slots across one or more coplanar Cross-Laminated Timber (CLT) or Structural Insulated Panel (Sip) elements. It is designed for situations where a uniform slot pattern is required across panel surfaces, such as service channels, ventilation grooves, or structural connection recesses.

The distribution automatically respects panel boundaries and openings, calculates slot positions based on user-defined parameters, and provides interactive grips for adjusting the distribution range. The tool also publishes dimension points for shop drawing generation.

---

## Environment

| Property | Value |
|----------|-------|
| Script Type | O-Type (Object Tool) |
| Works In | Model Space |
| Requires | Sip panels (one or more coplanar) |
| Version | 1.4 (October 2023) |

---

## Prerequisites

Before using this tool, ensure:

1. One or more **Sip/CLT panels** exist in the drawing
2. All target panels are **coplanar** (lie in the same plane)
3. Panels have clearly defined reference sides for proper slot orientation

---

## Usage

### Inserting the Tool

1. Run the command to insert the script (typically via hsbCAD's TSL insertion method)
2. A dialog appears allowing you to configure slot dimensions and distribution parameters
3. When prompted with **"Select panels"**, click on one or more Sip/CLT panels
4. The tool validates that selected panels are coplanar; non-coplanar panels are automatically excluded
5. Press Enter to confirm the selection
6. The slot distribution is created and can be adjusted via grips or Properties Palette

### Adjusting After Placement

- **Grips**: Two green grips appear at the corners of the distribution range. Drag these to adjust the left/right and top/bottom extents
- **Double-click**: Flips the slot distribution to the opposite panel face
- **Properties Palette**: Modify all parameters in real-time

---

## Parameters

### Geometry

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Width** | Length | 8 mm | Width of each slot (perpendicular to slot direction) |
| **Depth** | Length | 16 mm | Cutting depth of each slot into the panel. Note: The actual cut is applied symmetrically (Depth x 2 total) |

### Alignment

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Face** | Dropdown | Reference Side | Which panel face receives the slots: **Reference Side** or **Opposite Side** |
| **Angle** | Angle | 19.5 deg | Inclination angle of the slot relative to the panel face normal. Must be between -90 and 90 degrees. Use 0 for perpendicular slots |

### Distribution

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Interdistance** | Length | 60 mm | Spacing between consecutive slots |
| **Mode** | Dropdown | Fixed | Distribution mode: **Fixed** (constant spacing, variable quantity) or **Even** (constant quantity, spacing adjusts to fill area) |
| **Rotation** | Angle | 0 deg | Rotates the entire slot pattern around the distribution center |

### Distribution Offsets

These parameters control the boundary offset from the panel edges. Useful for avoiding slots near panel edges or limiting the distribution area.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Left** | Length | 0 mm | Inset distance from the left boundary |
| **Right** | Length | 0 mm | Inset distance from the right boundary |
| **Bottom** | Length | 0 mm | Inset distance from the bottom boundary |
| **Top** | Length | 0 mm | Inset distance from the top boundary |

---

## Context Menu Commands

Right-click on the tool instance to access these commands:

### Primary Commands (Root Level)

| Command | Description |
|---------|-------------|
| **Flip Side** | Switches the slot distribution between Reference Side and Opposite Side |
| **Revert Direction** | Reverses the slot placement direction (only available in Fixed mode) |
| **Add Panels** | Prompts to select additional coplanar panels to include in the distribution |
| **Remove Panels** | Prompts to select panels to remove from the distribution (must keep at least one) |
| **Edit in Place** | Converts the distribution into individual **hsbCLT-Slot** instances for fine-grained control. Note: The distribution tool is deleted after conversion |

### Secondary Commands (Submenu)

| Command | Description |
|---------|-------------|
| **Configure Shopdrawing** | Opens a dialog to configure dimension point output for shop drawings. Options include Format (text pattern), Stereotype (dimension style), and View (XY-View or Section) |
| **Import Settings** | Imports configuration from the company XML settings file |
| **Export Settings** | Exports current configuration to the company XML settings file (prompts for confirmation if overwriting) |

---

## Shop Drawing Configuration

The tool publishes dimension request points for automatic dimensioning in shop drawings. Configure via the **Configure Shopdrawing** context menu:

| Setting | Description |
|---------|-------------|
| **Format** | Text pattern for distribution annotation. Default: `@(Quantity-2)x @(Width) / @(Depth) >@(Angle)` |
| **Stereotype** | Dimension style to apply (from MultiPageStyle). Select `*` for default or `<Disabled>` to suppress |
| **View** | Output view type: **XY-View** (plan view) or **Section** (cross-section view) |

---

## Settings Files

- **Filename**: `hsbCLT-Slot-Distribution.xml`
- **Company Location**: `[Company Path]\TSL\Settings\`
- **Install Location**: `[Install Path]\Content\General\TSL\Settings\`
- **Purpose**: Stores persistent configuration for dimension settings and general options, allowing you to share settings between projects

---

## Tips and Best Practices

1. **Panel Selection**: When adding panels, only panels that are coplanar with the reference panel will be accepted. Panels at different heights or orientations are automatically filtered out.

2. **Fixed vs Even Mode**:
   - Use **Fixed** mode when exact slot spacing is critical (e.g., matching MEP requirements)
   - Use **Even** mode when you need a specific number of slots distributed uniformly

3. **Angled Slots**: The Angle parameter creates inclined slots. The "visible width" on the panel surface increases as the angle increases (Width / cos(Angle)). Avoid values exactly at 90 or -90 degrees.

4. **Grip Editing**: The two corner grips allow you to interactively resize the distribution area. The offset parameters (Left, Right, Top, Bottom) update automatically when you drag grips.

5. **Edit in Place**: Use this feature when you need to modify individual slots differently. Once converted to individual hsbCLT-Slot instances, you cannot revert to the distribution tool.

6. **Openings**: The distribution automatically avoids panel openings. Slots are only created where solid panel material exists.

7. **Settings Persistence**: Export your preferred configuration using "Export Settings" to reuse across projects.

8. **Dimension Output**: Configure shop drawing settings before generating production drawings. The dimension points integrate with the MultiPage shop drawing system.

9. **Depth Calculation**: Remember that the slot depth is applied symmetrically from the cutting plane. The total slot depth is 2x the Depth value you enter.

---

## FAQ

**Q: Can I add panels to an existing slot distribution without starting over?**
A: Yes. Select the script instance in the model, right-click, and choose **Add Panels**. You can then select the new panels to include.

**Q: Why are my slots not cutting through the full panel thickness?**
A: Check the `Depth` property in the Properties Palette. The script calculates total depth as `2 x Depth`. Double your input value if the cut is too shallow.

**Q: What happens if I use "Edit in Place"?**
A: The main hsbCLT-Slot-Distribution script will delete itself and replace the pattern with individual hsbCLT-Slot scripts. You can no longer control the whole pattern as one unit, but you can move or modify specific slots.

**Q: How do I apply the same slot settings to another project?**
A: Configure your slots as desired, right-click the instance, and select **Export Settings**. In the new project, insert the script and select **Import Settings** to load the configuration.

---

## Related Scripts

- **hsbCLT-Slot** - Single slot tool (created when using "Edit in Place")
- **MultipageController** - Shop drawing controller that reads dimension requests from this tool

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.4 | 2023-10-19 | Bugfix on insert |
| 1.3 | 2023-10-17 | Sectional edits improved, distribution rules enhanced, new grips |
| 1.2 | 2022-02-02 | Dimpoints patterns enhanced |
| 1.1 | 2022-02-01 | Dimpoints published, new context command for shop drawing configuration |
| 1.0 | 2022-01-19 | Initial version |
