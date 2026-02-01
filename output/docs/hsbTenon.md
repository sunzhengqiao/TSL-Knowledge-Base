# hsbTenon

## Description

The **hsbTenon** script creates traditional timber joinery connections, specifically **mortise** and **housing (tenon)** joints between beams or between a beam and a panel. This tool automates the creation of male (tenon) and female (mortise/pocket) cuts on connected timber members.

The script supports two primary connection types:
- **T-Connection**: A beam intersecting another beam or panel at an angle (typical post-to-beam or rafter-to-purlin joints)
- **End-to-End Connection**: Two beams meeting at their ends (for splicing or joining beams in line)

The tool automatically calculates the appropriate joint geometry based on the beam orientations and applies the corresponding cuts to both the male (tenon) and female (mortise) members.

## Script Type

| Property | Value |
|----------|-------|
| Type | O (Object) |
| Beams Required | 0 (selected during insertion) |
| Version | 1.6 |

## Properties

### Connection Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Connection | String (Dropdown) | T-Connection | Defines the connection type: **T-Connection** or **End-End**. Note: Beam-to-panel connections only support T-Connection. |

### Tool Category

| Property | Type | Default | Unit | Description |
|----------|------|---------|------|-------------|
| Type | String (Dropdown) | Mortise, not round | - | Joint profile type. Options include mortise variants (not round, round, rounded, explicit radius) and housing variants (not round, rounded, relief cut, small relief cut). |
| Offset Length A | Double | 0 | mm | Offset in the length direction (positive direction) from the intersection point. |
| Offset Length B | Double | 0 | mm | Offset in the length direction (negative direction) from the intersection point. |
| Width | Double | 45 | mm | Width of the tenon/mortise in the cross-section. |
| Depth | Double | 28 | mm | Depth of the tenon extending into the female member. |
| Explicit Radius | Double | 0 | mm | Custom corner radius (only applies when Type is set to "Mortise, explicit radius"). |

### Tolerances Category

| Property | Type | Default | Unit | Description |
|----------|------|---------|------|-------------|
| Length | Double | 0 | mm | Gap/tolerance added to the mortise length for assembly clearance. |
| Width | Double | 0 | mm | Gap/tolerance added to the mortise width for assembly clearance. |
| Depth | Double | 0 | mm | Gap/tolerance added to the mortise depth for assembly clearance. |

### Alignment Category

| Property | Type | Default | Unit | Description |
|----------|------|---------|------|-------------|
| X-Offset | Double | 0 | mm | Offset of the joint axis in the length direction. |
| Rotation | Double | 0 | degrees | Rotation angle of the joint around the connection axis. |

## Joint Type Options

### Mortise Types
- **Mortise, not round**: Square-cornered mortise (requires special tooling or hand finishing)
- **Mortise, round**: Circular profile at corners (standard CNC end mill)
- **Mortise, rounded**: Filleted/rounded corners
- **Mortise, explicit radius**: Custom corner radius defined by the Explicit Radius parameter

### Housing Types
- **Housing, not round**: Square-cornered housing joint
- **Housing, rounded**: Housing with rounded corners
- **Housing, relief cut**: Housing with relief cuts for assembly
- **Housing, small relief cut**: Housing with smaller relief cuts

## Usage Workflow

### Standard Insertion (T-Connection)

1. **Start the tool**: Execute the hsbTenon script from the TSL palette or command line.
2. **Configure settings**: A dialog appears allowing you to set the connection type, joint type, dimensions, and tolerances.
3. **Select male beams**: When prompted, select one or more beams that will have the tenon (projecting part) cut on them.
4. **Select female beams or panels**: Select the beams or panels that will receive the mortise (pocket) cut.
5. **Automatic creation**: The tool creates connections at each valid intersection between male and female members.

### End-to-End Connection (Beam Splitting)

1. **Start the tool** and select "End-End" connection type.
2. **Select the beam** to be split.
3. **Pick the split point**: A visual jig appears showing the beam. Click to select where the beam should be split.
4. **Flip direction** (optional): Press the keyword option to flip the direction if needed.
5. **Confirm**: The beam is split and mortise/tenon joints are created at the split location.

### Adjusting an Existing Connection

After placement, you can modify the connection by:
- Selecting the tool instance and editing properties in the Properties Palette (OPM)
- Using context menu commands (right-click on the tool)
- Dragging the grip point for parallel (End-to-End) connections

## Context Menu Commands

Right-click on an hsbTenon instance to access these commands:

| Command | Description |
|---------|-------------|
| **Flip Direction** | Swaps the male and female beams, reversing which member gets the tenon vs. mortise. |
| **Join** | Joins parallel beams back together (only available for End-to-End connections with parallel beams). |
| **Rotate 90** | Rotates the joint orientation by 90 degrees around the connection axis. Also triggered by double-click. |
| **Rotate** | Opens an interactive rotation jig to set a custom rotation angle. You can click a point or enter an angle numerically. |
| **Set vertical alignment** | Resets rotation to 0 degrees (only visible when rotation is non-zero). |
| **Set plump alignment** | Aligns the joint vertically plumb (only visible when applicable). |
| **Set horizontal alignment** | Aligns the joint horizontally (only visible when applicable). |
| **Show Commands** | Displays AutoCAD command strings for creating custom toolbar buttons or ribbon commands for this tool. |

## Technical Notes

- **Automatic recalculation**: The joint automatically updates if either the male or female beam moves or changes size.
- **Panel connections**: When connecting a beam to a panel (Sip), only T-Connection mode is supported.
- **Parallel beams**: For End-to-End connections between parallel beams, the insertion point can be dragged along the beam axis.
- **Zero depth behavior**: Setting Depth to 0 converts the operation to a simple cut (no tenon/mortise created).
- **Tolerances**: The tolerance values are added only to the female (mortise) side to create assembly clearance.

## Visual Feedback

During placement and editing:
- A light blue preview shows the tenon profile at the connection point
- Colored axis lines indicate the joint orientation (Red/Cyan = X-axis, Green/Yellow-green = Y-axis, Blue = Z-axis)
- During rotation, an angle indicator displays the current rotation value

## Tips for Best Results

1. **Verify beam orientations**: The tool determines male/female based on selection order. If the joint appears inverted, use "Flip Direction".
2. **Use tolerances for fabrication**: Add 1-2mm tolerance for CNC-machined joints to ensure proper fit during assembly.
3. **Match tool type to equipment**: Use "round" options for standard CNC equipment; "not round" may require additional hand work.
4. **Check intersection**: Beams must actually intersect or be within range for the tool to create a valid connection.

## Related Scripts

- **DoveTail** - Creates dovetail joints between beams
- **LapJoint** - Creates lap joints and half-lap connections
- **hsbCut** - Simple cutting operations on beams
