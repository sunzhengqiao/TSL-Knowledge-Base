# HSB_W-StudToPost

Converts selected wall studs into posts with customizable dimensions, positioning, and beam properties. This tool is commonly used in timber frame wall construction when standard studs need to be upgraded to larger posts for structural purposes (e.g., at openings, corners, or load-bearing points).

## Script Type

**Type: O (Object)**

This is an Object-type script that operates on selected beam entities. It does not require pre-selected beams at invocation but prompts the user to select studs during the insertion process. After processing, the script instance is automatically erased (one-time operation tool).

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.00 | 19.02.2018 | Anno Sportel | First revision |
| 1.01 | 20.02.2018 | Anno Sportel | Add option to change post height, position and properties |
| 1.02 | 21.02.2018 | Anno Sportel | Add option to set catalog through map |

## User Properties

### Size and Position

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Width post | Double | 105 mm | Sets the width of the posts. Must be a positive value. |
| Height post | Double | 0 mm | Sets the height of the posts. Setting it to zero will not change the height. |
| Post position | String (List) | Center | Determines the vertical alignment of the post relative to the original stud. Options: Front, Center, Back. |
| Stretch above top plate | String (Yes/No) | No | Specifies whether the post should stretch through the top plate. When enabled, the post will extend through and split the top plate. |

### Beam Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Beam type | String (List) | (from catalog) | Sets the beam type of the post. Uses standard hsbCAD beam types. |
| Name | String | (empty) | Sets the name of the post. |
| hsbCAD Material | String | (empty) | Sets the material field of the post. |
| Grade | String | (empty) | Sets the grade field of the post (e.g., C24, GL24h). |
| Information | String | (empty) | Sets the information field of the post. |
| Label | String | (empty) | Sets the label field of the post. |
| Sublabel | String | (empty) | Sets the sublabel field of the post. |
| Sublabel 2 | String | (empty) | Sets the sublabel 2 field of the post. |
| Beam code | String | (empty) | Sets the beam code field of the post. |
| Color | Integer | -1 | Sets the color of the post. -1 means no color change. |

## Usage Workflow

### Step 1: Launch the Script
Run the HSB_W-StudToPost script from the TSL menu or command line.

### Step 2: Configure Settings (Dialog)
If no execute key or catalog preset is specified, a settings dialog will appear allowing you to configure:
- Post dimensions (width and height)
- Post positioning within the wall thickness
- Whether posts should extend through top plates
- Beam property assignments (type, name, material, grade, etc.)

### Step 3: Select Studs
When prompted with "Select studs to convert", select one or more wall studs that you want to convert to posts. You can use window selection or pick individual studs.

### Step 4: Automatic Conversion
The script will process each selected stud:
1. Resize the stud to the specified post width
2. Adjust the height if specified (non-zero value)
3. Reposition the post based on the selected position option (Front/Center/Back)
4. Apply all beam properties (type, name, material, grade, etc.)
5. If "Stretch above top plate" is enabled:
   - Extend the post through any overlapping top plate
   - Automatically split the top plate around the post

### Step 5: Completion
After all studs are converted, the script instance is automatically erased. The converted posts remain as permanent beam modifications in the model.

## Catalog Support

This script supports catalog presets for quick application of commonly used post configurations:

- **Execute Key**: Launch with a predefined catalog name to skip the dialog
- **Map Parameter**: Pass `"Catalog"` key in the script's Map to apply catalog settings programmatically
- **Last Inserted**: Settings from the most recent insertion are automatically saved as `_LastInserted` for quick reuse

## Technical Notes

### Element Association
- When studs are part of an Element (wall assembly), the script uses the element's coordinate system for proper positioning
- Standalone studs (not in an element) are processed using their local beam coordinate system

### Top Plate Integration
When "Stretch above top plate" is enabled:
- The script searches for top plates (beam type `_kSFTopPlate`) within the same element
- Only top plates that overlap the post position horizontally are affected
- A stretch cut is applied to extend the post through the top plate
- The top plate is split at the post location using `dbSplit()`

### Validation
- Width must be a positive value (script will show warning and cancel if zero or negative)
- At least one beam must be selected (script will show warning if no valid beams)
- Height of 0 means "keep original height" (no height modification)

## Context Menu Commands

This script does not define custom context menu commands. All configuration is done through the initial dialog and OPM properties.

## Related Scripts

- **HSB_W-Stud**: Standard stud generation for walls
- **HSB_W-Post**: Direct post creation
- **HSB_W-TopPlate**: Top plate generation and management
