# hsbCLT-Drill.mcr

## Overview

Creates customizable vertical or angled drill holes (with optional counterbores/sinkholes) through CLT panels or SIP (Structural Insulated Panel) elements. The drill can pass through single or multiple panels and supports various face orientations including reference face, top face, and edge drilling.

| Property | Value |
|----------|-------|
| **Script Type** | Object (O-Type) |
| **Version** | 2.3 (22.11.2024) |
| **Keywords** | CLT, Drill, Rule, Free, Bevel, Angle |
| **Category** | CLT Manufacturing Tools |
| **Minimum Panels Required** | 1 |

### Version History
| Version | Date | Changes |
|---------|------|---------|
| 2.3 | 22.11.2024 | Display objects enabled for showing in hsbView |
| 2.2 | 08.03.2023 | MapRequestDim uses direction vectors aligned with the edge |
| 2.1 | 11.01.2023 | Write mapRequest for DimRequestPoint of _Pt0 |
| 2.0 | 20.10.2020 | Internal naming bugfix (HSB-9338) |
| 1.9 | 07.10.2020 | Image updated, ribbon command added (HSB-7718) |
| 1.8 | 19.06.2020 | Performance increased, depth taken from grip (HSB-7957) |
| 1.7 | 05.06.2020 | Spelling fixed (HSB-7540) |
| 1.6 | 13.05.2020 | Setting depth by grip added, rotation/bevel relation fixed (HSB-7552, HSB-6972) |
| 1.5 | 11.05.2020 | Setting bevel and/or rotation by grip corrected |
| 1.4 | 11.05.2020 | Settings extended to support isActive toggle for each tool definition (HSB-7358) |
| 1.3 | 04.05.2020 | Settings extended to support mismatch colors by face type and diameter (HSB-7477) |
| 1.2 | 29.04.2020 | Initial release |

---

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| **Model Space** | Yes | Operates on 3D model elements (SIP/CLT panels) |
| **Paper Space** | No | Not applicable for 2D drawings |
| **Shop Drawing** | No | Not applicable for shop drawings |

---

## Prerequisites

- **Required Entities**: SIP (Structural Insulated Panel) or CLT panel
- **Minimum Panel Count**: 1
- **Settings File**: `hsbCLT-Drill.xml` located in Company or Install path
- **Supported Element Types**: Sip (CLT panels, SIP panels)

---

## Usage Steps

### Step 1: Launch Script
- **Command:** `TSLINSERT` or use the Ribbon command
- **Action:** Browse and select `hsbCLT-Drill.mcr`
- **Alternative Commands:**
  - Insert with Reference Face as default: `hsb_ScriptInsert "hsbCLT-Drill" "_kRef"`
  - Insert with Top Face as default: `hsb_ScriptInsert "hsbCLT-Drill" "_kTop"`
  - Insert with Edge Face as default: `hsb_ScriptInsert "hsbCLT-Drill" "_kEdge"`

### Step 2: Select Configuration
- **Dialog:** "Select properties or catalog entry"
- **Options:**
  - **Default**: Standard drill configuration
  - **LastInserted**: Uses the last used configuration
  - **Custom catalog entries**: Any predefined drill specifications
- **Action:** Choose a preset to load initial parameters, or define settings manually

### Step 3: Select Panels
- **Command Line:** `Select panels`
- **Action:** Click on one or more CLT/SIP panels where you want to place the drill
- **Note:** Multiple panels can be selected for drills that pass through stacked elements

### Step 4: Specify Insertion Point
- **Command Line:** `Select point`
- **Action:** Click on the face or edge of the selected panel to define the drill start location
- **Additional prompts may appear:**
  - If **Bevel > 0** and **Rotation = 0**: `Specify direction, <Enter> to align with X-Axis`

### Step 5: Adjust Parameters
- **Action:** Once placed, modify the drill using:
  - **Properties Palette** (Ctrl+1): Edit numerical values
  - **Grips** (blue squares): Drag to adjust depth, bevel, rotation, and text position
  - **Context Menu**: Right-click for quick actions

---

## Properties Panel Parameters

### Drill Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Diameter** | Length | 12 mm | The diameter of the main drill hole. Must be greater than 0. |
| **Depth** | Length | 0 mm | Depth of the hole. **0** = through-hole (passes completely through the panel). Any positive value creates a blind hole. |
| **Face** | Selection | Reference Face | The reference plane for drill orientation. Options: `Reference Face`, `Top Face`, or `Edge`. |

### Alignment Parameters

| Parameter | Type | Default | Valid Range | Description |
|-----------|------|---------|-------------|-------------|
| **Bevel** | Angle | 0° | -90° to 90° | The tilt angle of the drill axis relative to the perpendicular of the selected face. Positive values tilt in one direction, negative in the opposite. |
| **Rotation** | Angle | 0° | -90° to 90° (Edge mode) | Rotates the drill axis direction within the plane of the face. Only applicable when drilling from an edge. |

### Edge-Specific Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Axis Offset** | Length | 0 mm | Distance from the insertion point along the panel's Z-axis. Used for edge drilling to offset the drill start point from the edge boundary. Only applicable in Edge mode. |
| **Snap to Axis** | Yes/No | Yes | When enabled, the insertion point snaps to the calculated axis defined by the offset. Only available in Edge mode. |

### Sinkhole (Counterbore) Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Diameter Start** | Length | 0 mm | Diameter of the counterbore at the entry side. Must be greater than the main drill diameter to create a sinkhole. |
| **Depth Start** | Length | 0 mm | Depth of the counterbore at the entry side. Set to 0 for automatic depth calculation based on geometry. |
| **Diameter End** | Length | 0 mm | Diameter of the counterbore at the exit side. Only available for through-holes (Depth = 0). |
| **Depth End** | Length | 0 mm | Depth of the counterbore at the exit side. Only available for through-holes. Set to 0 for automatic depth. |

### Display Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Format** | String | @(Radius) | Template string for the text label. Supports variables like `@(Radius)`, `@(Diameter)`, etc. |
| **Text Height** | Length | 0 mm | Height of the label text. **0** = uses the dimension style default. |

---

## Face Modes Explained

The drill behavior changes based on the selected face mode:

### Reference Face Mode (Default)
- Drill starts from the bottom/reference face of the panel
- Bevel tilts the drill relative to the panel's normal direction
- Most common mode for vertical through-holes

### Top Face Mode
- Drill starts from the top face of the panel
- Drill direction is inverted compared to Reference Face mode
- Useful for drilling from the top of inclined panels

### Edge Mode
- Drill starts from an edge of the panel
- **Axis Offset** becomes active for positioning along the edge
- **Rotation** parameter becomes fully active (-90° to 90°)
- Drill axis is automatically aligned perpendicular to the nearest edge
- Both Bevel and Rotation affect the drill direction

---

## Right-Click Context Menu Options

| Menu Item | Description | Availability |
|-----------|-------------|--------------|
| **Flip Side** | Reverses the drill direction. Switches between Reference Face and Top Face modes, and rotates the drill 180°. | Reference/Top Face modes only |
| **Set Bevel** | Opens a point picker to visually set the bevel angle by clicking a point. | All modes |
| **Set Rotation** | Opens a point picker to visually set the rotation angle by clicking a point. | Edge mode |
| **Set Depth** | Opens a point picker to visually set the depth by clicking an endpoint. | All modes |
| **Add Panels** | Opens a selection dialog to add more panels to the drill operation. | All modes |
| **Remove Panels** | Opens a selection dialog to remove panels from the drill operation. Only available when multiple panels are assigned. | 2+ panels |
| **Purge Panels** | Automatically removes any panels that no longer intersect with the drill path. | All modes |
| **Add/Remove Format** | Opens a numbered list to add or remove text format tokens (Radius, Diameter, etc.) from the on-screen label. | All modes |
| **Activate Tool Rules** | Enables automatic tool rules from the XML settings file (color coding, validation). | When tool rules exist |
| **Disable Tool Rules** | Disables automatic tool rules validation. | When tool rules exist |

---

## Settings File Configuration

### File Location
- **Primary:** `_kPathHsbCompany\TSL\Settings\hsbCLT-Drill.xml`
- **Fallback:** `_kPathHsbInstall\Content\General\TSL\Settings\hsbCLT-Drill.xml`

### Configuration Features

The settings file (`hsbCLT-Drill.xml`) supports:

1. **Display Configuration**
   - Default color and transparency
   - Mismatch color (when drill doesn't match tool rules)
   - Dimension style for text labels
   - Text height overrides

2. **Face-Specific Overrides**
   - Different colors/transparency for Reference, Top, and Edge faces
   - Custom dimension styles per face type

3. **Tool Rules** (Optional Validation)
   - **Face**: Limit tool to specific face modes
   - **Diameter**: Match specific drill diameters
   - **IsInclinable**: Allow/disallow angled drilling
   - **MaxLength**: Maximum drill depth limit
   - **isActive**: Enable/disable specific tool configurations

4. **Mismatch Indicators**
   - When a drill configuration doesn't match any tool rule, the script displays it in a "mismatch" color (default: red) to alert the user

---

## Grip Editing

The script provides interactive grips for visual editing:

| Grip | Function |
|------|----------|
| **Grip 0 (End Point)** | Drag to set drill depth visually. For through-holes, shows the exit point. Also used for setting bevel and rotation angles when dragged. |
| **Grip 1 (Text Position)** | Drag to reposition the text label relative to the drill. |

---

## Tips and Best Practices

### Through Holes
- For standard utility penetrations, leave **Depth** as `0`
- This ensures the hole automatically adapts to panel thickness changes
- The drill will automatically extend through all intersecting panels

### Counterbores (Sinkholes)
- Use **Diameter Start** and **Depth Start** to create recesses for bolt heads or washers
- Set **Depth Start** to `0` for automatic depth calculation based on bevel/rotation geometry
- Counterbore diameter must be larger than the main drill diameter to take effect

### Edge Drilling
- When drilling from an edge, use **Axis Offset** to position the drill along the panel's length
- The **Rotation** parameter controls the drill direction within the edge plane
- Edge drills automatically align perpendicular to the nearest edge boundary

### Multi-Panel Drilling
- Select multiple panels during insertion to create through-holes across stacked elements
- Use **Add Panels** to extend an existing drill to additional panels
- Use **Purge Panels** to clean up panels that no longer intersect the drill path

### Tool Rules
- Configure `hsbCLT-Drill.xml` to validate drill specifications against company standards
- Mismatch colors help identify non-compliant configurations
- Use **Disable Tool Rules** to temporarily bypass validation

### Visual Adjustments
- Drag the end grip to quickly set depth without opening the Properties Palette
- Use **Set Bevel** and **Set Rotation** context menu options for visual angle input
- Drag the text grip to position labels away from cluttered areas

---

## Troubleshooting

### Problem: Drill not going through the panel
**Solution:** Check the **Depth** property in the Properties Palette. It is likely set to a specific value instead of `0` (through).

### Problem: Drill color is red/mismatched
**Solution:** The drill configuration doesn't match any tool rule in the settings file. Either:
- Adjust the parameters to match a valid configuration
- Use **Disable Tool Rules** to override validation

### Problem: Cannot change Rotation in Reference/Top Face mode
**Solution:** Rotation is primarily for Edge mode. In Reference/Top Face modes, use **Bevel** to angle the drill.

### Problem: Sinkhole not appearing
**Solution:** Ensure:
- **Diameter Start/End** is greater than the main **Diameter**
- **Depth Start/End** is greater than 0 (or set to 0 for auto-calculation)
- For **Diameter End**, ensure the drill is a through-hole (**Depth** = 0)

### Problem: "no intersection found with panels" error
**Solution:**
- Verify the insertion point is within the panel boundary
- Check that the drill direction actually intersects the panel geometry
- For edge drilling, ensure the point is on or near the panel edge

### Problem: Rotation angle keeps resetting
**Solution:** In Edge mode, rotation is constrained to -90° to 90°. Values outside this range are automatically normalized.

---

## Related Scripts

| Script | Relationship |
|--------|--------------|
| `hsbCLT-Slot.mcr` | Creates slots instead of circular drills |
| `hsbCLT-Pocket.mcr` | Creates pocket cavities |
| `hsbCLT-Rabbet.mcr` | Creates rabbet/notch cuts |
| `hsbCLT-T-Connector.mcr` | Connection hardware that may require drill holes |
| `hsbCLT-X-Fix-Connector.mcr` | X-Fix connector system |

---

## Technical Notes

### Parameter Validation
- **Diameter**: Must be greater than 0 (script will erase if invalid)
- **Bevel**: Automatically constrained to -90° < value < 90°
- **Rotation**: In Edge mode, constrained to -90° < value < 90°
- **Depth**: 0 = through-hole; positive values = blind hole

### Automatic Features
- Drill direction vector is automatically calculated based on face mode, bevel, and rotation
- Panel intersection is automatically detected for multi-panel operations
- Text position can be adjusted via grip without affecting drill geometry

### Display Behavior
- Reference Face drills: Color 3 (green)
- Top Face drills: Color 152
- Edge drills: Color 72
- Mismatch (invalid configuration): Color 1 (red)

### Map Requests
The script publishes dimension request data (`DimRequestPoint`) for integration with shop drawing dimensioning systems. This allows the drill insertion point to be automatically dimensioned in generated drawings.
