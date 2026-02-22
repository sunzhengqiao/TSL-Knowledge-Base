# hsb_Vent - Wall Vent Opening Creator

## Overview

**hsb_Vent** is an intelligent script for creating rectangular or round vent openings in timber-framed walls. The script automatically frames the opening by creating header beams (above and below), vertical studs (left and right), and optional battens around the opening. It handles existing studs intelligently by either snapping to them or splitting them, and can mill sheeting material across multiple zones.

**Category**: Stick Frame - Wall Framing
**Type**: O-Type (Object Script)
**Script Version**: 2.35 (November 27, 2025)

---

## Key Features

- **Dual Vent Shapes**: Rectangular or round vent openings
- **Automatic Framing**: Creates header beams (top/bottom) and vertical studs (left/right)
- **Smart Stud Handling**: Snaps to existing studs or creates new framing
- **Batten Support**: Creates battens in specified zones (studs, blocking, or as beams)
- **Sheet Milling**: Mills sheeting across multiple zones with CNC tooling parameters
- **Structural Support**: Optional jacks and bracing above/below opening
- **Flexible Positioning**: Fixed location or snap-to-stud modes
- **Multi-Element Support**: Insert into multiple walls simultaneously
- **Freeze Mode**: Lock geometry for manual beam modifications

---

## Usage Workflow

### 1. Insertion

**Command**: `TSLCONTENT` (see script comments)

**Interactive Prompts**:
1. **Select elements** - Choose one or more wall elements
2. **Select a position** - Click inside the wall to place the vent center point

**Multi-Wall Insertion**:
- When multiple walls are selected, the script creates a vent instance in each wall
- The insertion point must fall within the boundaries of at least one wall
- Only walls that overlap at the insertion point will receive vents

### 2. Automatic Calculation

The script automatically:
- Snaps the insertion point to the wall's X-axis (horizontal alignment)
- Calculates final position based on **Height to underside of top timber** property
- Identifies vertical studs and horizontal beams in the wall
- Determines which beams need to be split
- Creates framing beams around the opening
- Mills sheeting in specified zones
- Creates battens if enabled
- Adds jacks/bracing if requested

### 3. Recalculation

The vent recalculates when:
- Any property is modified in the OPM (Object Properties Manager)
- The parent wall element is modified
- Linked beams are moved or modified

---

## Properties Reference

### Location and Size

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Height to underside of top timber** | Distance | 1250mm / 50" | Vertical position from wall bottom to bottom edge of top header beam |
| **Vent Shape** | Choice | Rectangular | `Rectangular` or `Round` |
| **Width of vent** | Distance | 150mm / 6" | Opening width (rectangular only) |
| **Height of vent** | Distance | 150mm / 6" | Opening height (rectangular only) |
| **Diameter of Vent** | Distance | 150mm / 6" | Opening diameter (round vents only) |
| **Create Vertical Blocks** | Yes/No | Yes | Create vertical studs on left/right sides |
| **Stretch vertical** | Choice | Do not stretch | How vertical studs interact with existing studs:<br>• **Do not stretch**: Fixed position<br>• **Stretch left**: Left stud stretches to existing studs<br>• **Stretch right**: Right stud stretches to existing studs<br>• **Stretch both**: Both studs stretch to existing studs |
| **Snap to existing studs** | Yes/No | Yes | Automatically reposition vent to align with nearest stud |
| **Fixed vent** | Yes/No | No | Lock vent position (disables snap-to-stud) |
| **Freeze vent** | Yes/No | No | Lock all beam creation for manual modification |
| **Delete existing stud** | Yes/No | No | Delete existing stud at vent location if it's NOT at a sheet joint |

**Notes**:
- **Height measurement**: Measured from wall origin to the **bottom edge** of the top header beam
- **Snap to existing studs**: When enabled and vent is not fixed, the script repositions the opening to align with the closest vertical stud
- **Fixed vs. Snap**: Fixed vent stays exactly where placed; non-fixed vent snaps to nearest stud
- **Delete existing stud**: Only deletes studs that are NOT at sheet joints (preserves structural integrity)

### Battens

Battens are secondary framing members created in a specified zone around the vent opening.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Zone** | Choice | None | Element zone for batten creation:<br>Zones -5 to -1 (exterior), None, or 1 to 5 (interior) |
| **Batten** | Choice | No | Batten creation mode:<br>• **No**: No battens created<br>• **Studs**: Create as studs<br>• **Blocking**: Create as blocking<br>• **As beam**: Create as beam entities<br>• **As beam solid for roundings vent**: Special mode for round vents (creates solid beams around opening) |
| **Tolerance** | Distance | 0mm | Tolerance for blocking batten positioning (applies to blocking mode only) |
| **Bottom** | Painter | Disabled | Painter definition for splitting bottom batten (see Sheet Painters below) |
| **Top** | Painter | Disabled | Painter definition for splitting top batten (see Sheet Painters below) |

**Batten Behavior**:
- **"As beam" mode**: Creates 4 surrounding beams in the zone **before** the batten zone (e.g., if batten zone is -2, beams are created in zone -1)
- **"As beam solid for roundings vent"**: Creates additional solid beams in the batten zone itself for round vents
- **Stretch options**: Battens respect the "Stretch vertical" setting

**Sheet Painters** (Bottom/Top properties):
- Used to split service battens at top/bottom of vent
- Supports painter definitions of type "Sheet"
- Can be organized in a "Socket\\" collection for automatic filtering
- If collection exists, only painters in that collection are available
- Auto-creates example painters: `batten-B`, `batten-C`, `batten-E` if none exist
- Select `<Disabled>` to prevent splitting

### Beam Properties

These properties control the appearance and attributes of created beams (headers and vertical studs).

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Name** | Text | VENT | Beam name for vent framing beams |
| **Material** | Text | (empty) | Material specification |
| **Grade** | Text | (empty) | Timber grade |
| **Information** | Text | VENT | Information field |
| **Label** | Text | (empty) | Primary label |
| **Sublabel** | Text | (empty) | Secondary label |
| **Sublabel 2** | Text | (empty) | Tertiary label |
| **Create Vent as a Module** | Yes/No | No | Group all vent beams into a named module |

**Module Naming**:
- If any existing beam in the vent has a module name, that name is reused
- Otherwise, module name is `"Vent" + [vent instance handle]`

### Jacks and Bracing

Structural support members above and/or below the opening.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Bracing** | Choice | None | Create horizontal bracing:<br>• **None**: No bracing<br>• **Top**: Above opening<br>• **Bottom**: Below opening<br>• **Both**: Top and bottom |
| **Jacks** | Choice | None | Create vertical jacks:<br>• **None**: No jacks<br>• **Top**: Above opening (jack over opening)<br>• **Bottom**: Below opening (jack under opening)<br>• **Both**: Top and bottom |

**Behavior**:
- **Bracing**: Horizontal beam spanning from left stud to right stud in the space above/below the opening
- **Jacks**: Two vertical support beams (left and right) in the space above/below opening
- Requires sufficient space between header beams and adjacent horizontal beams
- If space is insufficient, script will report error and terminate

### Tooling

Controls CNC milling of sheeting material.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Create Milling** | Yes/No | Yes | Enable CNC milling of sheets |
| **Zones to Mill** | Text | "1;2;10;" | Semicolon-separated zone numbers (1-10, mapped to real zones 1-5 and -1 to -5) |
| **Tooling index** | Integer | 0 | Tool index for CNC machine |
| **Turning direction** | Choice | Against course | `Against course` or `With course` |
| **Overshoot** | Yes/No | No | Allow tool overshoot |
| **Vacuum** | Yes/No | No | Enable vacuum during milling |
| **Set Beams as NO Nail** | Yes/No | No | If Yes, sets beam code to prevent nailing; if No, allows nailing |

**Zone Mapping**:
- Input zones 1-5 map to positive zones 1-5
- Input zones 6-10 map to negative zones -1 to -5
- Example: "1;2;10;" mills zones 1, 2, and -5

**Milling Behavior**:
- For rectangular vents: Mills rectangular opening
- For round vents: Mills circular opening
- **"As beam" batten mode**: Mills larger rectangular area to accommodate surrounding beams

### Display

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Format Label** | Text | "Vent" | Text format displayed in front and top views (supports format variables) |
| **Dimension style** | Choice | (Drawing default) | Dimension style for text display |
| **Display Representation** | Text | (empty) | Display representation filter |

**Format Variables**:
- Use Add/Remove Format context menu command to select available variables
- Format syntax: `@(VariableName)`
- Example: `@(Width) x @(Height)` displays "150 x 150"
- Use `\P` for line breaks in multi-line formats

### Checking

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Show exclusion zone** | Yes/No | No | Display circular exclusion zone around vent |
| **Distance exclusion zone** | Distance | 300mm | Radius of exclusion zone circle from vent center |

**Exclusion Zone**:
- Visualizes clearance area around vent
- Displayed as a circle in front and back views
- Does not affect geometry, only visual reference

---

## Detailed Behavior

### Stud Interaction Modes

The script has three distinct modes for handling vertical studs:

#### 1. Fixed Vent Mode (`Fixed vent = Yes`)
- Vent stays exactly where placed
- Creates new studs at exact left/right positions
- New studs are labeled as "STUD" and typed as Stud
- Does **not** snap to existing studs

#### 2. Snap-to-Stud Mode (`Fixed vent = No`, `Snap to existing studs = Yes`)
- Automatically repositions vent to align with nearest existing stud
- Chooses left or right stud based on which is closer
- Recalculates distances after snapping

#### 3. Stretch Modes (when `Fixed vent = No`)

**"Stretch left"**:
- Left stud stretches to existing wall studs
- Left stud is typed as "Stud", named "STUD"
- Right vertical beam is typed as "Vent", named by **Name** property
- Right beam stretches to the header beams above/below

**"Stretch right"**:
- Right stud stretches to existing wall studs
- Right stud is typed as "Stud", named "STUD"
- Left vertical beam is typed as "Vent", named by **Name** property
- Left beam stretches to the header beams above/below

**"Stretch both"**:
- Both left and right studs stretch to existing wall studs
- Both typed as "Stud", named "STUD"
- Provides maximum integration with existing framing

### Delete Existing Stud Logic

When `Delete existing stud = Yes`:

1. **Script checks if any existing stud intersects with vent opening**
2. **For each intersecting stud**:
   - Checks if stud is located at a **sheet joint** (where two sheets meet)
   - If stud is at sheet joint: **Preserves** the stud (structural requirement)
   - If stud is NOT at sheet joint: **Deletes** the stud
3. **Stores deleted stud information** in script's internal Map
   - Saves position, dimensions, material, labels, etc.
   - If vent is later deleted, the stud is **recreated** with original properties

**Sheet Joint Detection**:
- A stud is at a sheet joint if:
  - It's positioned between two sheets (not fully inside one sheet)
  - Both sheets are close to each other (within tolerance)
  - The stud spans the gap between sheets

### Beam Splitting Logic

**Vertical Beams (Studs)**:
- Any vertical beam intersecting the vent opening is **split** at top and bottom edges
- Split portions stretch to header beams above/below
- Parts that would extend into opening are deleted
- Retains structural connection to top/bottom of wall

**Horizontal Beams (Blocking/Nailers)**:
- Any horizontal beam intersecting the vent opening is **split** at left and right edges
- Split is only performed if beam is not too close to top/bottom wall edge

### Header Beam Creation Logic

**Top Header Beam**:
1. If opening is above wall height (no beam needed): Uses top wall beam
2. If space between opening and nearest beam above ≥ (opening height/2 + beam height + clearance): Creates new header beam
3. Otherwise: Extends to nearest existing beam above (no new beam)

**Bottom Header Beam**:
1. If opening is below wall bottom (no beam needed): Uses bottom wall beam
2. If space between opening and nearest beam below ≥ (opening height/2 + beam height + clearance): Creates new header beam
3. Otherwise: Extends to nearest existing beam below (no new beam)

**Stretching Relationships**:
- Header beams stretch dynamically to left/right studs
- Vertical studs stretch dynamically to header beams (or to existing studs in stretch modes)
- Maintains parametric relationships for future modifications

### Batten Creation Workflow

When **Zone** is set to a valid zone (not "None") and **Batten** is not "No":

#### Mode: "Studs" or "Blocking"

1. **Script collects all existing sheets in the batten zone**
2. **Creates rectangular "modules"** representing top/bottom/left/right battens:
   - Top module: Above opening
   - Bottom module: Below opening
   - Left module: Left of opening (if vertical blocks enabled)
   - Right module: Right of opening (if vertical blocks enabled)
3. **Subtracts existing sheets from modules** to avoid overlap
4. **Creates new sheets** from remaining profiles
5. **Sheet properties**: Inherits color, material from zone; height from zone thickness

**Top/Bottom Splitting** (if painter definitions selected):
- If **Bottom** or **Top** painter is not `<Disabled>`:
- Splits the batten sheet at bottom/top using selected painter definition
- Creates separate sheet entities that can be independently controlled

#### Mode: "As beam" or "As beam solid for roundings vent"

1. **Creates beams in the zone BEFORE the batten zone** (not in the batten zone itself)
   - Example: If batten zone is -2, beams are created in zone -1
2. **For rectangular vents**: Creates 4 surrounding beams (left, right, top, bottom)
3. **For round vents**:
   - **"As beam"**: Creates 4 surrounding beams
   - **"As beam solid for roundings vent"**: Creates 4 beams in zone before batten + 4 beams with drill holes in batten zone itself
4. **Beam dimensions**:
   - Width: 2 × (beam height from zone 0) + vent width
   - Height: Batten zone thickness
   - Length: For round vents = width; for rectangular vents = vent height + 2 × beam height

**Batten Zone in "As Beam" Mode**:
- If batten zone contains **sheets**: Converts sheets to beams first, then deletes sheets
- If batten zone contains **beams**: Identifies left/right/top/bottom battens
- **Splitting vertical battens**: If vertical batten needs to be split to accommodate horizontal modules, script splits and saves references

### Milling Behavior

When **Create Milling = Yes**:

1. **For each zone in "Zones to Mill" list**:
   - Gets all sheets in that zone
   - Creates milling tool (rectangular or circular based on vent shape)
2. **Rectangular vents**: Mills rectangular profile matching vent dimensions
3. **Round vents**: Mills circular profile with diameter from **Diameter of Vent** property
   - Diameter is clamped to vent width or height (whichever is smaller)
4. **"As beam" batten mode**: In the zone before batten zone, mills a larger rectangular area to fit surrounding beams
5. **Applies ElemMill tool** to element with specified tooling parameters
6. **Applies SolidSubtract** to all intersecting sheets

### Jacks and Bracing Creation

**Bracing** (horizontal support):
- Created between the opening's header beam and the next beam above/below
- Spans from left stud to right stud
- Typed as `_kBrace`
- Stretches dynamically to left/right studs

**Jacks** (vertical support):
- Created between the opening's header beam and the next beam above/below
- Positioned at the outside faces of left/right studs
- Typed as `_kSFJackOverOpening` (above) or `_kSFJackUnderOpening` (below)
- Stretches dynamically to the two horizontal beams defining the support space

**Error Handling**:
- If no beam exists above the opening for top bracing/jacks: Script terminates with error message
- Script reports: "Bracing not possible"

### Multi-Element Insertion

When inserting on **multiple elements**:

1. **User selects multiple wall elements**
2. **User clicks insertion point**
3. **Script identifies "reference element"**:
   - The element whose min/max boundaries contain the insertion point
4. **Script creates PlaneProfile intersection**:
   - Projects all element outlines onto reference element's plane
   - Intersects profiles to find overlapping region
5. **Filters elements**: Removes elements that don't overlap with reference element
6. **Creates separate vent instance** for each remaining element
   - Each instance is independent
   - All properties are copied from the insertion parameters

---

## Display and Visualization

### Front View (Elevation)
- **Opening outline**: Displayed as rectangle or circle (based on vent shape)
- **Cross indicators**: Two diagonal lines (X) inside opening
- **Format label**: Text below opening showing format string
- **Exclusion zone** (if enabled): Circle around vent center

### Top View (Plan)
- **Opening projection**: Rectangle representing front face of vent
- **Depth indicator**: Lines extending from front to back of wall
- **Cross indicators**: Two diagonal lines (X) in top view
- **Format label**: Text at back edge of wall

### Display Representation
- If **Display Representation** is specified, graphics are filtered to that display rep
- Color: Layer color 3 (yellow in most color schemes)

---

## Format Label System

The **Format Label** property supports dynamic text using format variables.

### Adding/Removing Variables

**Context Menu Command**: "Add/Remove Format"

**Workflow**:
1. Right-click vent in drawing → Context menu → "Add/Remove Format"
2. Script displays list of all available variables with current values
3. Enter index number to toggle variable inclusion
4. Variables are inserted as `@(VariableName)` in the format string
5. Enter -1 to exit

**Example Variables**:
- `@(Width)` - Vent width
- `@(Height)` - Vent height
- `@(Name)` - Beam name
- `@(Material)` - Material specification
- (Many more available from TslInst properties)

**Multi-line Format**:
- Use `\P` to insert line break
- Example: `"Vent@(Width)\P@(Material)"` displays:
  ```
  Vent150
  Timber
  ```

---

## Internal Data Storage (Map)

The script stores references to created entities in `_Map` for recalculation:

| Map Key | Entity Type | Description |
|---------|-------------|-------------|
| `bmAbove` | Beam | Top header beam |
| `bmBelow` | Beam | Bottom header beam |
| `bmStLeft` | Beam | Left vertical stud |
| `bmStRight` | Beam | Right vertical stud |
| `bmBracingAbove` | Beam | Top bracing beam |
| `bmBracingBelow` | Beam | Bottom bracing beam |
| `bmJackLeftAbove` | Beam | Left jack above opening |
| `bmJackRightAbove` | Beam | Right jack above opening |
| `bmJackLeftBelow` | Beam | Left jack below opening |
| `bmJackRightBelow` | Beam | Right jack below opening |
| `shAbove` | Sheet | Batten sheet above opening |
| `shBelow` | Sheet | Batten sheet below opening |
| `shStLeft` | Sheet | Batten sheet left of opening |
| `shStRight` | Sheet | Batten sheet right of opening |
| `shBlocking` | Sheet | Blocking sheet |
| `BeamsSheeting[]` | Beam array | Beams created in sheet zones ("as beam" mode) |
| `bmToSplit[]` | Beam array | Beams that were split |
| `bmSplitted[]` | Beam array | Returned portions from split beams |
| `bmToSplitBatten` | Beam | Batten beam that was split |
| `bmSplittedBatten` | Beam | Returned portion from split batten |
| `StudDeletedInfo` | Map | Deleted stud's properties (for restoration) |
| `noinsulation` | PLine | Polyline defining no-insulation area |

### Deletion Cleanup (`_bOnDbErase`)

When the vent is deleted:
1. **All created beams/sheets are deleted** (from Map keys above)
2. **Split beams are re-joined** (restores original continuous beams)
3. **Deleted studs are recreated** (if stored in `StudDeletedInfo`)
4. **Battens are re-joined** if they were split

---

## Beam Types and HsbIDs

| Beam | Beam Type | HsbID | Name | Notes |
|------|-----------|-------|------|-------|
| Header beams (top/bottom) | `_kSFVent` | 139 | From **Name** property | Set as Vent |
| Left/right studs (Fixed mode) | `_kStud` | 114 | "STUD" | Set as Stud |
| Left/right studs (Stretch mode) | `_kStud` | 114 | "STUD" | Stretching side |
| Left/right beams (non-stretch side) | `_kSFVent` | 139 | From **Name** property | When one side stretches |
| Bracing | `_kBrace` | - | From **Name** property | Horizontal support |
| Jacks (above) | `_kSFJackOverOpening` | - | From **Name** property | Vertical support above |
| Jacks (below) | `_kSFJackUnderOpening` | - | From **Name** property | Vertical support below |
| Battens ("as beam") | `_kBatten` | - | From batten zone | Beam-based battens |

---

## Common Use Cases

### Basic Rectangular Vent for HVAC Duct

**Settings**:
- Vent Shape: `Rectangular`
- Width: `250mm` (10")
- Height: `150mm` (6")
- Create Vertical Blocks: `Yes`
- Snap to existing studs: `Yes`
- Fixed vent: `No`
- Create Milling: `Yes`
- Zones to Mill: `1;2;` (both interior and exterior sheeting)

**Result**: Vent snaps to nearest stud, creates headers and vertical framing, mills interior/exterior OSB.

---

### Fixed Circular Vent for Dryer Exhaust

**Settings**:
- Vent Shape: `Round`
- Diameter: `100mm` (4")
- Fixed vent: `Yes`
- Create Vertical Blocks: `No`
- Create Milling: `Yes`
- Zones to Mill: `1;2;`

**Result**: Circular vent at exact placement, no vertical studs, mills sheeting only.

---

### Large Opening with Structural Support

**Settings**:
- Vent Shape: `Rectangular`
- Width: `600mm` (24")
- Height: `450mm` (18")
- Create Vertical Blocks: `Yes`
- Jacks: `Both`
- Bracing: `Both`
- Create Vent as a Module: `Yes`

**Result**: Large opening with full structural support (jacks and bracing above/below), grouped as a module.

---

### Vent with Battens

**Settings**:
- Vent Shape: `Rectangular`
- Batten Zone: `-2` (exterior batten layer)
- Batten: `As beam solid for roundings vent`
- Create Milling: `Yes`
- Zones to Mill: `1;2;` (sheeting layers)

**Result**: Creates surrounding beams in zone before batten zone, mills sheeting, provides full batten framing.

---

## Troubleshooting

### "Opening has too much overlap with beam"
**Cause**: Vent height overlaps more than 50% of top or bottom wall beam height
**Solution**: Reduce **Height of vent** or adjust **Height to underside of top timber**

### "Beamcode is not valid 1" or "Beamcode is not valid 2"
**Cause**: Script cannot find valid top or bottom beam for header creation
**Solution**: Check wall has proper top/bottom plates; ensure opening is within wall boundaries

### "Bracing not possible"
**Cause**: No beam exists above/below opening to attach bracing
**Solution**: Disable **Bracing** property or adjust vent position to have beams above/below

### Vent position shifts when properties change
**Cause**: **Snap to existing studs** is enabled and nearest stud changed
**Solution**: Set **Fixed vent = Yes** to lock position

### Battens not appearing
**Cause**: **Zone** property set to "None" or selected zone has zero thickness
**Solution**: Set **Zone** to a valid zone (1-5 or -1 to -5); check zone thickness > 0

### Sheeting not milled
**Cause**: **Create Milling = No** or zone not in **Zones to Mill** list
**Solution**: Set **Create Milling = Yes**; add zone to **Zones to Mill** (e.g., "1;2;")

### Deleted stud not restored when vent is deleted
**Cause**: **Delete existing stud = No**
**Solution**: This is expected behavior; stud deletion only works when property is enabled

---

## Technical Notes

### Coordinate System
- **X-axis**: Horizontal (along wall length)
- **Y-axis**: Vertical (wall height)
- **Z-axis**: Depth (wall thickness)

### Calculations
- All measurements use `U()` function for unit conversion (supports mm/inch templates)
- Insertion point snapped to wall X-axis using `Line.closestPointTo()`
- Final position calculated: `_Pt0 + vecY × (height - 0.5 × ventHeight)`

### Performance
- Uses `envelopeBody()` for intersection tests (faster than `realBody()`)
- Beam stretching relationships are dynamic (no fixed dimensions)
- Freeze mode prevents geometry regeneration for large models

### Compatibility
- Works with both metric (mm) and imperial (inch) templates
- Supports all hsbCAD element types (walls, floors, roofs)
- Compatible with multi-zone elements (up to ±5 zones)

---

## Version History (Recent)

- **2.35** (Nov 2025): Handle vertical batten splitting when needed
- **2.34** (Nov 2025): Implement `onDbErase` cleanup for created entities
- **2.33** (Nov 2025): Create beams with zero width in zone before batten
- **2.32** (Nov 2025): Add properties to cut top/bottom service batten
- **2.31** (Nov 2025): Use 4 beams at batten zone for round/rectangular vents
- **2.30** (Oct 2025): Add "As beam solid for rounding vent" option
- **2.29** (Jul 2025): Add "As beam" option at Batten property
- **2.28** (Jun 2025): Error handling when jacks not possible
- **2.27** (Jun 2025): Add properties for bracing and jacks
- **2.26** (Jul 2024): Add locating plate as beam type to avoid
- **2.25** (Feb 2023): Element validation added
- **2.24** (Jan 2022): Support multiple wall insertion
- **2.23** (Nov 2021): Created battens respect existing batten boundaries
- **2.22** (Apr 2021): Exclude beams in sheet zones from consideration
- **2.21** (Mar 2021): Delete existing stud logic with sheet joint detection
- **2.20** (Mar 2021): Add "None" option to batten zone list

---

## Related Scripts

- **hsbBlocking**: Creates blocking between studs
- **hsb_OpeningPackers**: Creates packing around openings
- **hsbSheetDistribution**: Distributes sheeting across zones
- **hsbNailing**: Creates nail patterns for connections

---

## See Also

- Element zones and zone configuration
- Beam types and beam codes
- Module system in hsbCAD
- Sheet painter definitions
- CNC tooling parameters (ElemMill)
