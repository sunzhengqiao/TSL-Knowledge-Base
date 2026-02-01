# hsbCLT-Drill

## Description

**hsbCLT-Drill** creates a free drill hole in CLT (Cross-Laminated Timber) panels. The drill can be positioned in relation to one of the panel's main faces (Reference Face or Top Face) or to an edge face. This tool supports drilling through multiple panels simultaneously, making it ideal for connection points that span multiple CLT elements.

The drill can be configured with optional sinkholes (countersinks) on both the entry and exit faces, allowing for recessed bolt heads or washers. Bevel and rotation angles can be applied to create angled drill holes for inclined fastener connections.

## Script Type

| Property | Value |
|----------|-------|
| Type | O (Object) |
| Beams Required | 0 |
| Keywords | CLT, Drill, Rule, Free, Bevel, Angle |
| Version | 2.3 |

## Properties

### Drill Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Diameter** | Double | 12 mm | Defines the diameter of the drill hole |
| **Depth** | Double | 0 mm | Defines the depth of the drill hole. Set to 0 for a complete through-drill |
| **Face** | String | Reference Face | Defines which face the drill is positioned from. Options: "Reference Face", "Top Face", "Edge" |

### Alignment Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Bevel** | Double | 0 | Defines the angle of the drill axis in relation to the selected face. Range: -90 to 90 degrees |
| **Rotation** | Double | 0 | Defines the rotation of the drill axis perpendicular to the selected face. Range: -90 to 90 degrees |

### Alignment Edge Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Axis Offset** | Double | 0 | Defines the axis offset of the insertion point. Only applicable when Face mode is set to "Edge" |
| **Snap to Axis** | String | No | Defines if the insertion point will snap to the axis with the given axis offset. Options: "No", "Yes" |

### Sinkholes Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Diameter Start** | Double | 0 mm | Defines the diameter of the sinkhole (countersink) at the entry face. Must be larger than the main drill diameter to be active |
| **Depth Start** | Double | 0 mm | Defines the depth of the sinkhole at the entry face. Set to 0 for automatic depth calculation |
| **Diameter End** | Double | 0 mm | Defines the diameter of the sinkhole at the exit face. Only available for through-drills |
| **Depth End** | Double | 0 mm | Defines the depth of the sinkhole at the exit face. Only available for through-drills |

### Display Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Format** | String | @(Radius) | Defines the format of the description text displayed with the drill. Use @(PropertyName) syntax for dynamic values |
| **Text Height** | Double | 0 mm | Defines the text height for the display. Set to 0 to use the style default |

## Usage Workflow

### Inserting a New Drill

1. **Launch the Script**: Access hsbCLT-Drill from the hsbCAD ribbon or command line
2. **Configure Properties**: A dialog appears where you can set:
   - Drill diameter and depth
   - Face mode (Reference Face, Top Face, or Edge)
   - Bevel and rotation angles if needed
   - Sinkhole dimensions if required
3. **Select Panels**: Click on one or more CLT panels that the drill will pass through
4. **Pick Insertion Point**: Click to place the drill location on the selected panel face
5. **Set Direction (Optional)**: If a bevel angle is specified without rotation, you will be prompted to pick a direction point to define the drill rotation

### Modifying an Existing Drill

After placement, select the drill instance to modify its properties in the AutoCAD Properties Palette (OPM). Changes to diameter, depth, angles, or sinkhole dimensions will automatically update the drill geometry.

### Face Mode Behavior

- **Reference Face**: Drill enters from the panel's reference (bottom) face
- **Top Face**: Drill enters from the panel's top face
- **Edge**: Drill enters from a panel edge, useful for horizontal connections

## Context Menu Commands

Right-click on a placed drill to access these commands:

| Command | Description |
|---------|-------------|
| **Flip Side** | Switches the drill entry face between Reference Face and Top Face. Only available when not in Edge mode |
| **Set Bevel** | Interactively pick a point to define the bevel angle |
| **Set Rotation** | Interactively pick a point to define the rotation angle |
| **Set Depth** | Interactively pick a point to define the drill depth |
| **Add Panels** | Add additional CLT panels to the drill operation |
| **Remove Panels** | Remove panels from the drill operation (minimum one panel must remain) |
| **Purge Panels** | Automatically remove panels that no longer intersect with the drill |
| **Add/Remove Format** | Interactive dialog to configure the display format text by selecting available properties |
| **Activate Tool Rules** | Enable tool rule matching from settings (matches drill to machine capabilities) |
| **Disable Tool Rules** | Override tool rule matching to allow any configuration |

## Settings Configuration

The script reads configuration from XML settings files located at:
- Company path: `[Company]\TSL\Settings\hsbCLT-Drill.xml`
- Install path: `[Install]\Content\General\TSL\Settings\hsbCLT-Drill.xml`

Settings can define:
- Display colors and transparency for different face modes
- Tool definitions with diameter constraints, inclination limits, and maximum lengths
- Mismatch colors when drill parameters exceed tool capabilities

## Tips for Timber Designers

- **Through-drilling multiple panels**: Select all panels at once during insertion to ensure proper alignment
- **Angled connections**: Use Bevel for tilting the drill in one direction, and Rotation for tilting perpendicular to that
- **Edge drilling for horizontal connections**: Switch to Edge mode when connecting panels horizontally
- **Countersinks**: Set the sinkhole diameter larger than the drill diameter and specify depth, or leave depth at 0 for automatic calculation based on entry angle
- **Tool rule matching**: If your shop drawing shows a mismatch color, check that your drill parameters match available machine tooling in the settings file
