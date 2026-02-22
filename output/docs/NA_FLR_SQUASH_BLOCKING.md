# NA_FLR_SQUASH_BLOCKING

## Script Overview

**Purpose**: Creates squash blocking between floor joists using intelligent blocking placement with customizable sizes, orientations, and installation methods.

**Category**: Floor Framing - FLR_*
**Version**: 1.5 (September 13, 2019)
**Type**: Object Script (O-Type)

---

## Features

- **Automatic blocking detection** between floor joists
- **Multiple blocking types**: Single blocks, Upper blocking, Lower blocking, Upper & Lower blocking
- **Flexible orientations**: X-axis or Y-axis aligned
- **Various lumber sizes**: 2x4, 2x6, 2x8, 2x10, 2x12
- **Two insertion methods**: Single block or Multiple blocks
- **Truss support**: Automatically detects and works with truss entities
- **Smart spacing**: Blocks distributed evenly between joists

---

## User Properties (OPM)

| Property | Type | Options | Default | Description |
|----------|------|---------|---------|-------------|
| **Size** | String | 2x4, 2x6, 2x8, 2x10, 2x12 | 2x4 | Lumber size for blocking |
| **Blocking orientation** | String | X-axis, Y-axis | X-axis | Direction blocking faces |
| **Number of Blocks** | Integer | 1-6 | 2 | Number of blocking pieces to insert |
| **Insertion method** | String | One block, Multiple blocks | Multiple blocks | How to place blocking |
| **Blocking type** | String | (blank), Upper blocking, Lower blocking, Upper & Lower | (blank) | Special blocking configurations |

---

## How to Use

### 1. Script Placement
1. Select the script from the TSL menu or command line
2. Select the floor element (joist system)
3. Click to select a reference point (typically near the first joist)
4. Select direction point to indicate blocking orientation

### 2. Parameter Selection
- **Size**: Choose lumber dimensions (2x4 to 2x12)
- **Orientation**: Choose X-axis or Y-axis alignment
- **Number of Blocks**: Set quantity (1-6 pieces)
- **Insertion Method**:
  - "One block": Places single blocking element
  - "Multiple blocks": Distributes multiple blocks evenly
- **Blocking Type** (when selected):
  - Automatically sets orientation to X-axis
  - Forces number of blocks to 1
  - Uses Multiple blocks method

### 3. Special Features
- **Truss Support**: Automatically detects and works with truss entities in the floor system
- **Auto-Spacing**: When using Multiple blocks, spacing is automatically calculated between joists
- **Release to Drawing**: After placement, blocking is committed as regular beams to the drawing

---

## Technical Details

### Blocking Dimensions
- **2x4**: 1.5" × 3.5"
- **2x6**: 1.5" × 5.5"
- **2x8**: 1.5" × 7.25"
- **2x10**: 1.5" × 9.25"
- **2x12**: 1.5" × 11.25"

### Behavior Notes
- Blocking is created perpendicular to selected direction
- First selection point becomes reference location
- Second selection point determines orientation
- Script intelligently detects joist spacing for proper blocking placement
- Blocking entities are automatically assigned to the floor element group
- Uses 6-inch minimum joist length detection

### Version History
- **V1.5** (09/13/2019): Standardized sorting method
- **V1.4** (07/30/2019): Added truss support
- **V1.3** (12/12/2018): Added Upper, Lower, and Up&Low blocking options
- **V1.2** (12/05/2018): Fixed blocking sizes
- **V1.1** (11/06/2018): Fixed multiple method behavior
- **V1.0** (08/13/2018): Initial release with custom trigger release

---

## Common Use Cases

1. **Standard Floor Blocking**: Add vertical blocking between floor joists for structural stability
2. **Truss Floor Systems**: Automatically place blocking around truss members
3. **Special Configurations**: Use Upper/Lower blocking for specific structural requirements
4. **Quick Blocking**: Use "One block" method for single blocking needs
5. **Even Distribution**: Use "Multiple blocks" for evenly spaced blocking patterns

---

## Tips

- Select reference point near the center of the area needing blocking
- Use direction point to align with joist direction for proper orientation
- Larger lumber sizes (2x8, 2x10, 2x12) provide more structural capacity
- Blocking is color-matched to the floor system
- After placement, blocking becomes regular beams that can be edited normally

---

## Error Messages

- "Less then 2 joist between selected boundaries": Occurs when trying to use special blocking types (Upper/Lower) without sufficient joist spacing