# GE_BEAM_STRONG_BACK

Places two lumber items in an "L" formation (strongback configuration) along selected beams for structural reinforcement.

## Overview

The GE_BEAM_STRONG_BACK script creates a strongback assembly consisting of two perpendicular lumber members arranged in an "L" shape. This configuration is commonly used to reinforce floor joists and prevent lateral movement, twisting, or bouncing. The script automatically retrieves lumber dimensions from the hsbCAD inventory system and allows users to customize the horizontal and vertical members independently.

**Important:** This is a **generator script** - it creates the beam geometry and then removes itself from the drawing. The resulting strongback beams remain as independent beam objects.

## Script Metadata

| Property | Value |
|----------|-------|
| Type | O (Object) |
| Required Beams | 0 (selects during insertion) |
| Version | 1.3 |
| Author | David Rueda (dr@hsb-cad.com) |
| Last Updated | November 3, 2013 |
| Copyright | hsbSOFT, USA |

### Revision History
| Version | Date | Changes |
|---------|------|---------|
| 1.3 | Nov 3, 2013 | Stickframe path added to mapIn when calling DLL |
| 1.2 | May 15, 2012 | Description added |
| 1.1 | Apr 16, 2012 | Beams chosen from inventory lumber items; option to NOT frame vertical or horizontal beam; thumbnail added |
| 1.0 | Apr 11, 2011 | Initial release |

## Usage Environment

| Property | Value |
|----------|-------|
| Environment | Model Space |
| Requires Beams | Yes (parallel joists/beams - selected during insertion) |
| Execution Mode | Immediate (generator script) |

## Prerequisites

Before using this script:

1. **Parallel Beams Required**: Ensure you have a set of parallel beams (typically floor joists) already created in your model. All selected beams MUST be parallel to each other - non-parallel beams will be automatically filtered out.
2. **Inventory Configured**: Lumber items must be defined in the hsbCAD Framing Defaults inventory system using the Framing Defaults Editor. Each lumber item must have valid Width, Height, Material (Species), and Grade values.
3. **Proper View**: Position your view to easily select the beams and specify the insertion point
4. **Sufficient Space**: The insertion point must allow enough room for both the horizontal and vertical beams to fit within the joist lengths

## Step-by-Step Usage Guide

### Step 1: Launch the Script
Insert the GE_BEAM_STRONG_BACK script from your TSL library or script menu.

### Step 2: Configure Lumber Sizes (Dialog)
A dialog window appears on first insertion, allowing you to pre-select:
- Horizontal beam lumber size
- Vertical beam lumber size
- Flip side option

### Step 3: Select Beams
At the command prompt "Select beam(s)":
- Click on multiple parallel beams (joists) that you want to reinforce with the strongback
- All selected beams must be parallel to each other
- Press Enter when done selecting

### Step 4: Specify Insertion Point
At the command prompt "Insertion reference point":
- Click a point along the beams where you want the strongback to be placed
- This point determines the position along the length of the beams

### Step 5: Verify Results
The script creates the strongback assembly:
- A horizontal member running perpendicular to the joists
- A vertical member forming an "L" shape with the horizontal member
- Both members span from the first selected joist to the last

## Properties Panel Parameters

After insertion, you can modify the strongback through the Properties Panel (OPM):

| Parameter | Type | Index | Description | Options |
|-----------|------|-------|-------------|---------|
| Horizontal beam | PropString | 0 | Lumber size for the horizontal member | List from inventory + "None" |
| Vertical beam | PropString | 1 | Lumber size for the vertical member | List from inventory + "None" |
| Flip side | PropString | 2 | Reverses the orientation of the L-formation | No, Yes |

### Parameter Details

**Horizontal beam / Vertical beam**
- Select from lumber items defined in your inventory
- Each option shows the lumber name/description retrieved from the hsbFramingDefaults.Inventory.dll
- Selecting "None" will omit that member entirely (creates only a single beam instead of an L)
- Dimensions (Width, Height), Material (Species), and Grade are automatically retrieved from inventory
- Default: First item in the inventory list

**Flip side**
- Controls which side of the horizontal beam the vertical member is placed
- Use this to orient the L-formation toward or away from specific elements
- **No** (default): Vertical beam placed on the default side
- **Yes**: Vertical beam placed on the opposite side (L-formation flipped)

## Right-Click Menu Options

This script does not define custom context menu items. Standard hsbCAD object options apply.

**Note:** Since this is a generator script, the script instance is automatically erased after creating the beams. The resulting strongback beams remain as independent beam objects that can be modified individually.

## Settings Files and Dependencies

The script reads lumber inventory data from the hsbCAD Framing Defaults system:

| Setting | Location |
|---------|----------|
| Lumber Inventory | Company Path + Framing Defaults |
| Installation Data | hsbCAD Install Path\Utilities\hsbFramingDefaultsEditor |
| DLL Assembly | hsbFramingDefaults.Inventory.dll |

### DLL Interface Details

The script uses `hsbFramingDefaults.Inventory.dll` with the following interface:
- **Namespace:** `hsbSoft.FramingDefaults.Inventory.Interfaces`
- **Class:** `InventoryAccessInTSL`
- **Function:** `GetLumberItems`

The DLL retrieves available lumber items with their:
- **WIDTH** - Beam width
- **HEIGHT** - Beam height/depth
- **HSB_MATERIAL** - Material species
- **HSB_GRADE** - Lumber grade

### Input Parameters to DLL

The script passes these paths to the DLL:
- `CompanyPath` - hsbCAD company-specific path
- `StickFramePath` - hsbCAD wall detail path
- `InstallationPath` - hsbCAD installation directory

## Technical Details

### Created Beam Properties

When the script creates the strongback beams, it assigns the following properties:

| Property | Value | Description |
|----------|-------|-------------|
| Label | "Strongback" | Beam identifier |
| Type | 87 (JOIST) | Beam classification type |
| Color | 32 | Display color index |

### Beam Orientation Logic

The script calculates beam orientation as follows:
1. Takes the first selected beam as reference for direction vectors
2. Uses `vecD(_ZW)` for the beam's Z-axis direction
3. Uses `vecX()` for the beam's X-axis direction
4. Calculates Y-axis as cross product of Z and X
5. Filters and sorts all selected beams perpendicular to the Y-direction

### Validation Checks

The script performs these validation checks before creating beams:
1. **Beam count**: At least one valid beam must be selected
2. **Perpendicular beams**: Selected beams are filtered for parallelism
3. **Inventory data**: Width and Height must be non-zero for selected lumber
4. **Space availability**: Insertion point must allow room for both beams within joist lengths

## Tips and Best Practices

1. **Select Multiple Joists**: The strongback will span from the first to the last selected joist, so select all joists you want to reinforce in a single operation.

2. **Check Beam Orientation**: All selected beams must be parallel. Non-perpendicular beams will be filtered out automatically.

3. **Verify Space**: The script checks if there is enough room for the strongback at the insertion point. If not, you will receive an error message.

4. **Use "None" Option**: If you only need a single blocking member instead of an L-shaped strongback, set either the horizontal or vertical beam to "None".

5. **Adjust After Insertion**: Use the Properties Panel to change lumber sizes or flip the orientation without re-inserting the script.

6. **Inventory Configuration**: Ensure your lumber inventory is properly configured in the Framing Defaults Editor for the best results.

7. **Insertion Point Position**: Choose an insertion point that is not too close to the ends of the joists to ensure adequate space for the strongback members.

8. **Beam Selection Order**: The order of selection does not matter - beams are automatically sorted by their perpendicular position.

## FAQ

**Q: Why am I getting "Not enough beams selected" error?**
A: You need to select at least one beam. Make sure you are clicking on valid beam objects.

**Q: Why does the script say "Not enough beams are perpendicular"?**
A: The script filters beams that are not parallel to each other. Ensure all selected beams share the same orientation.

**Q: Why do I get "There is no room for these beams at this point"?**
A: The insertion point is too close to the end of the joists. Move the insertion point further toward the center of the beam span.

**Q: Can I create only a horizontal or only a vertical strongback member?**
A: Yes, select "None" for either the Horizontal beam or Vertical beam option to create only one member.

**Q: What type and label are assigned to the created beams?**
A: Both members are assigned the label "Strongback" and beam type 87 (JOIST type), with color 32.

**Q: Where does the lumber list come from?**
A: The lumber options are retrieved from your hsbCAD Framing Defaults inventory. Configure lumber items using the Framing Defaults Editor.

**Q: Why did the script disappear after I picked the point?**
A: This is a "generator" script. Its purpose is to create the beam geometry and then remove itself from the drawing. The resulting strongback beams remain as independent objects.

**Q: I get an error "Data incomplete, check values on inventory".**
A: The lumber item you selected in the properties might be missing Width or Height data in your hsbFramingDefaults. Check your inventory configuration. The error message will display which values are missing (Material, Grade, Width, Height).

## Related Scripts

| Script | Description |
|--------|-------------|
| `hsbBlocking` | Creates blocking between joists |
| `HSB_W-*` | Wall framing scripts |
| `FLR_*` | Floor framing scripts |
| `hsb_ScriptInsert` | Generic script insertion utility |

## Error Messages Reference

| Error Message | Cause | Solution |
|---------------|-------|----------|
| "Not enough beams selected" | No valid beams were selected | Select at least one beam object |
| "Not enough beams are perpendicular" | Selected beams are not parallel to each other | Ensure all selected beams share the same orientation |
| "There is no room for these beams at this point" | Insertion point is too close to joist ends | Move insertion point toward the center of the joist span |
| "Data incomplete, check values on inventory" | Lumber item missing dimensions | Verify Width and Height in Framing Defaults Editor |
