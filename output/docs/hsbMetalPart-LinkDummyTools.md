# hsbMetalPart-LinkDummyTools

## Overview and Purpose

**hsbMetalPart-LinkDummyTools** is an advanced automation tool that bridges the gap between metal hardware components and timber members in hsbCAD. This script automatically transfers CNC machining operations from steel connectors to the timber beams they attach to, eliminating the need for manual tool definition and ensuring perfect alignment between hardware and timber.

### What It Does

When a steel connector or metal part (MassGroup) is designed, it contains invisible "dummy beams" that define where drills, slots, cuts, and other machining operations should be placed on the actual timber members. This script:

1. **Reads** all machining tool definitions from the dummy beams inside a MetalPart
2. **Clones** those tools (drills, slots, cuts, beam cuts, mortises, houses)
3. **Applies** them automatically to one or more selected GenBeams (timber members)
4. **Maintains** a live connection so that if the MetalPart moves or changes, all machining operations update automatically

This automation is essential in modern timber construction workflows where:
- Metal connectors require precise drilling and cutting patterns
- Manual tool placement is error-prone and time-consuming
- Design changes need to propagate instantly to fabrication data

### Key Benefits

- **Accuracy**: Tools are transferred with exact geometric precision from the connector design
- **Speed**: Hundreds of machining operations can be applied in seconds
- **Consistency**: Same connector type always produces identical tool patterns
- **Dynamic Updates**: If you move the MetalPart, all associated tools recalculate automatically
- **Flexibility**: Works with any combination of GenBeams and MetalParts in your drawing

---

## Technical Specifications

| Property | Value |
|----------|-------|
| **Script Type** | O-Type (Object/Tool script) |
| **Version** | 1.4 (April 10, 2019) |
| **Required Beams** | 0 (uses GenBeam selection) |
| **Environment** | Model Space only |
| **Implicit Insert** | Yes (user-friendly insertion mode) |
| **Keywords** | Metalpart, Steel, Tool, Connection |

---

## Prerequisites

Before using this script, ensure your drawing contains:

### 1. GenBeams (Timber Members)

At least one **GenBeam** entity that will receive the machining operations. This can be:
- Structural beams (posts, headers, joists)
- Wall studs or plates
- Roof rafters or purlins
- Any timber member that connects to metal hardware

### 2. MetalPart (MassGroup with Dummy Beams)

At least one **MetalPart** (MassGroup entity) that:
- Contains one or more dummy beams with **dummy flag = 2**
- Has machining tools already defined on those dummy beams
- Is positioned correctly relative to the timber members

**Important**: The MetalPart must use dummy beams of type 2. This is the standard convention for hsbCAD metal connector libraries. If your MetalPart was created by an official hardware script (Simpson, Hilti, Rothoblaas, etc.), it will already meet this requirement.

### 3. Correct Positioning

The MetalPart should be positioned at its final installation location before running this script. The tool geometry is cloned based on the current position of the MetalPart. If you move the MetalPart after linking, the tools will recalculate automatically (this is a feature, not a bug).

---

## Usage Instructions

### Step 1: Launch the Script

**Method A - Command Line:**
```
Command: TSLINSERT
```
Then browse to and select `hsbMetalPart-LinkDummyTools.mcr` from the script library.

**Method B - Toolbar/Ribbon:**
If your company has configured a toolbar button or ribbon command for this script, click that button.

**Method C - Execute Key (Advanced):**
If you want to bypass the dialog and use a preset, launch with an execute key:
- **ADDCUT**: Automatically enables planar cut transfer
- **NOCUT**: Automatically disables planar cut transfer

Example:
```
Command: (hsb_ScriptInsert "hsbMetalPart-LinkDummyTools.mcr" "ADDCUT")
```

---

### Step 2: Configure Cut Mode (Dialog)

If you launched without an execute key, a dialog appears asking:

**"Should planar end-cuts be transferred?"**

This controls whether simple planar cuts (flat end-cuts on timber members) are included in the transfer.

**Options:**
- **No** (default): Only drills, slots, beam cuts, mortises, and houses are transferred
- **Yes**: All tool types including planar end-cuts are transferred

**When to choose "Yes":**
- The MetalPart requires specific end-cut geometry on the timber
- You want the connector to control the beam end profile
- Example: A post base that requires a specific beam end cut

**When to choose "No":**
- The timber end-cuts are controlled by other framing operations
- You only want holes and pockets, not profile cuts
- Example: A mid-span beam hanger that only requires bolt holes

**Technical Note:** Even when "Yes" is selected, hip cuts and compound cuts are always excluded because they require additional geometric context that cannot be safely cloned.

---

### Step 3: Select GenBeams

The command line prompts:
```
Select GenBeam(s):
```

**Selection Methods:**
- **Single Click**: Select one GenBeam at a time
- **Window Selection**: Draw a window around multiple GenBeams
- **Crossing Selection**: Draw a crossing window to select partially visible GenBeams
- **Previous Selection**: Type `P` to select the previous selection set

**Selection Tips:**
- You can select as many GenBeams as you want
- All selected GenBeams will receive the same tool pattern from each MetalPart
- Common use case: Select 2-4 beams at a beam-to-beam connection
- Filter your selection - only GenBeam entities are accepted

After selecting all desired GenBeams, press **Enter** to confirm.

---

### Step 4: Select MetalParts

The command line prompts:
```
Select Metalpart(s):
```

**Selection Methods:**
- **Single Click**: Select one MetalPart (MassGroup) at a time
- **Window Selection**: Select multiple MetalParts in one operation
- **Filter**: Only valid MassGroup entities are accepted

**Important Behaviors:**

**Selecting One MetalPart:**
- Creates one linked script instance
- That instance links to all GenBeams selected in Step 3
- Tools from the MetalPart are applied to all those GenBeams

**Selecting Multiple MetalParts:**
- Creates **one independent script instance per MetalPart**
- Each instance links to the same set of GenBeams from Step 3
- Example: If you select 3 MetalParts, you'll get 3 separate instances

After selecting all desired MetalParts, press **Enter** to confirm.

---

### Step 5: Automatic Processing

After selection, the script:

1. **Validates** that each selected entity is a valid MassGroup
2. **Erases** the temporary insertion placeholder (this is normal - don't panic!)
3. **Creates** one new persistent script instance per MetalPart
4. **Links** each instance to:
   - The selected GenBeams (via `_GenBeam[]` array)
   - The associated MetalPart (via `_Entity[]` array)
5. **Scans** the MetalPart for dummy beams (type 2)
6. **Extracts** all tool definitions from those dummy beams
7. **Clones** and **applies** the tools to the linked GenBeams

The new instance(s) will:
- Appear as entities in your drawing (you can select them in the Properties palette)
- Automatically recalculate when the MetalPart or GenBeams change
- Be assigned to the same entity group as the MetalPart for organization

---

## Properties Panel (OPM)

When you select a placed instance of this script in your drawing, the AutoCAD Properties Palette (OPM) displays the following parameter:

### AddCut

**Type:** Dropdown (String)
**Category:** General
**Default Value:** No
**Options:** No / Yes

**Description:**
Controls whether planar end-cuts from the dummy beams are transferred to the GenBeams.

**Behavior:**

| Setting | Effect |
|---------|--------|
| **No** | Only drills, slots, beam cuts, mortises, and houses are applied. Simple planar cuts are skipped. |
| **Yes** | All tool types including planar end-cuts are applied. Hip cuts and compound cuts are still excluded. |

**Runtime Changes:**

You can change this parameter at any time after placement:

1. Select the script instance in the drawing
2. Open the Properties palette (Ctrl+1)
3. Find "AddCut" under the General category
4. Change from "No" to "Yes" or vice versa

**What Happens When You Change It:**

- **From "No" to "Yes"**: The script adds planar cuts dynamically. Future recalculations will include cuts.
- **From "Yes" to "No"**: Previously applied dynamic cuts are converted to **static tools** (non-recalculating) to preserve the geometry. The `cutAdded` flag is set to `false` to prevent future cut application.

This behavior ensures you never lose geometry when toggling the setting.

---

## Tool Types Transferred

The script can detect and clone the following machining tool types from dummy beams:

### 1. Drills

**What They Are:**
Cylindrical holes drilled through timber members for bolts, dowels, or threaded rods.

**Detection Method:**
Uses `AnalysedDrill().filterToolsOfToolType(tools)` to extract all drill operations from the dummy beam.

**Cloning Process:**
- Extracts start point, end point, and radius
- Creates a new `Drill` object with identical geometry
- Applies to all GenBeams whose geometry intersects the drill path

**Visual Feedback:**
A line is drawn from drill start to end point in **color 24** during calculation.

**Use Case Example:**
A Simpson ETB hold-down requires six 5/8" diameter bolts through a post. The MetalPart defines six drill operations, which are automatically transferred to the selected post beam.

---

### 2. Slots

**What They Are:**
Rectangular pockets routed into timber members, often for hidden connectors or tension straps.

**Detection Method:**
Uses `AnalysedSlot().filterToolsOfToolType(tools)` to extract all slot operations.

**Cloning Process:**
- Extracts coordinate system, origin point, and quader (box dimensions)
- Calculates slot depth by intersecting with actual GenBeam face profiles
- Creates a new `Slot` object with identical geometry
- **Depth Correction**: Script ensures slot depth does not exceed the beam face depth to prevent negative-volume errors

**Visual Feedback:**
Slot profile is drawn at the origin plane in **color 124**, with a depth line showing slot extent.

**Use Case Example:**
A Rothoblaas WHT hidden connector requires a 40mm x 60mm slot routed 80mm deep into a CLT panel edge. The slot geometry is precisely cloned from the connector's dummy beam.

---

### 3. Houses (Housing / Lap Joints)

**What They Are:**
Rectangular pockets with optional rounded corners, used for lap joints, housings, or tenon receivers.

**Detection Method:**
Uses `AnalysedHouse().filterToolsOfToolType(tools)` to extract housing operations.

**Cloning Process:**
- Extracts coordinate system, quader dimensions, and round type (corner radius)
- Determines end type (head vs. tenon) from tool subtype
- Creates a new `House` object with matching geometry
- Applies to intersecting GenBeams

**Tool Subtypes Handled:**
- `_kAHHeadPerpendicular`: Female (receiving) end
- `_kAHHeadSimpleAngledTwisted`: Female end, twisted
- `_kAHHeadSimpleBeveled`: Female end, beveled
- All other subtypes: Male (tenon) end

**Visual Feedback:**
Housing profile is drawn at the origin plane in **color 44**, with a depth line.

**Use Case Example:**
A timber-to-timber connection uses a traditional housed joint. The receiving beam gets a 90mm x 140mm housing, automatically sized and positioned by the connector script.

---

### 4. Mortises

**What They Are:**
Rectangular or rounded pockets for mortise-and-tenon joints, often used in traditional timber framing.

**Detection Method:**
Uses `AnalysedMortise().filterToolsOfToolType(tools)` to extract mortise operations.

**Cloning Process:**
- Extracts coordinate system, quader dimensions, and round type
- Determines end type (female vs. tenon) from tool subtype
- If subtype is `_kAMPerpendicular`, sets end type to `_kFemaleSide`
- Creates a new `Mortise` object
- Applies to intersecting GenBeams

**Visual Feedback:**
No explicit visual feedback (mortise is applied internally).

**Use Case Example:**
A post-to-beam connection uses a blind mortise for a steel dowel. The mortise is 25mm x 80mm, positioned automatically by the connector.

---

### 5. Beam Cuts

**What They Are:**
Complex volumetric cuts (seat cuts, bird's mouths, lap joints, etc.) defined by a 3D bounding box.

**Detection Method:**
Uses `AnalysedBeamCut().filterToolsOfToolType(tools)` to extract beam cut operations.

**Cloning Process:**
- Extracts coordinate system and quader dimensions
- **Free Direction Expansion**: If a dimension is flagged as "free" (unbounded), that dimension is doubled to ensure the cut passes completely through the beam
- Creates a `BeamCut` object with expanded geometry
- Uses `envelopeBody()` intersection test (faster than `realBody()`) to determine which GenBeams to apply to
- Only applies to GenBeams whose envelope intersects the cutting volume

**Supported Subtypes (26 types):**
Seat cuts, rising seat cuts, bird's mouths, reversed bird's mouths, lap joints, diagonal seat cuts, Japanese hip cuts, rabbets, dados, 5-axis housings, and more.

**Visual Feedback:**
Beam cut profile is drawn at the coordinate system origin in **color 64**, with a depth line showing cut extent.

**Use Case Example:**
A rafter-to-plate connection uses a compound bird's mouth cut. The seat cut and plumb cut geometry are automatically transferred from the connector to the rafter beam.

---

### 6. Planar Cuts (Conditional)

**What They Are:**
Simple flat end-cuts that trim the beam to a specific profile.

**When Transferred:**
Only when the `AddCut` parameter is set to **"Yes"**.

**Detection Method:**
Uses `AnalysedCut().filterToolsOfToolType(tools)` to extract cut operations.

**Filtering Rules:**
1. **Excluded Subtypes**: Hip cuts (`_kACHip`) and compound cuts (`_kACCompound`) are always skipped
2. **Direction Filter**: The cut normal must align with the vector from MetalPart center (`_Pt0`) to dummy beam center. This ensures only the correct face is cut.

**Cloning Process:**
- Extracts cut origin point and normal vector
- Creates a new `Cut` object
- Applies to all linked GenBeams
- Dynamic vs. Static behavior based on AddCut toggle state

**Visual Feedback:**
A small circle (10mm radius) is drawn at the cut origin in the calculated debug color.

**Use Case Example:**
A post base connector requires a 90-degree square end cut on the bottom of the post. When AddCut=Yes, this cut is automatically applied.

---

## Recalculation and Dependencies

### Automatic Updates

The script instance registers a **dependency** on the selected MetalPart using:
```c
setDependencyOnEntity(mgThis);
```

**What This Means:**
- Whenever the MetalPart is modified (moved, rotated, resized), the script **automatically recalculates**
- All tool geometry is re-read from the MetalPart
- Tools are re-applied to the linked GenBeams
- Your timber members always stay synchronized with the hardware

### Entity Group Assignment

The script instance is assigned to the same entity group as the MetalPart:
```c
assignToGroups(mgThis, 'T');
```

**Benefits:**
- Logical grouping keeps related entities together
- If you select the MetalPart group, you'll also select the tool linker instance
- Easier to manage complex assemblies

### Initialization Loops

On database creation, the script runs **2 execution loops**:
```c
if (_bOnDbCreated) setExecutionLoops(2);
```

**Purpose:**
Ensures stable initialization. The first loop may not have complete geometry data; the second loop ensures all dependencies are resolved and tools are correctly applied.

---

## Visual Feedback During Calculation

The script provides temporary visual feedback to help you verify tool placement. This geometry is for **display only** and does not appear on plots:

### Display Elements

| Tool Type | Visual Feedback | Color |
|-----------|-----------------|-------|
| **Planar Cuts** | Small circle at cut origin (10mm radius) | Variable (nDebugColor++) |
| **Slots** | Profile polygon + depth line | 124 (cyan/teal) |
| **Houses** | Profile polygon + depth line | 44 (orange) |
| **Mortises** | (No explicit display) | 54 (yellow) |
| **Beam Cuts** | Profile slice + axis line | 64 (brown) |
| **Drills** | Line from start to end point | 24 (red) |

### Display Layer

All display geometry belongs to the script's internal display layer:
```c
Display dp(-1);
dp.textHeight(U(20));
```

**Layer -1** is a special layer that:
- Shows in Model Space during editing
- Does not plot/print
- Automatically updates during recalculation

---

## Error Handling and Validation

### Missing or Invalid MetalPart

If the selected entity is not a valid MassGroup, the script:
1. Reports an error message to the command line
2. Automatically erases itself
3. Does not leave orphaned geometry

**Command Line Message:**
```
hsbMetalPart-LinkDummyTools: No massgroup found! (ENTITYTYPE) Instance erased.
```

**Why This Happens:**
- You selected a different entity type by mistake
- The MetalPart was deleted after linking
- The entity is corrupted

### No GenBeams Selected

If `_GenBeam.length() < 1`, the script:
1. Silently erases itself
2. Does not create an instance

**Why This Happens:**
- You pressed Enter without selecting any GenBeams in Step 3
- All selected entities were filtered out (not GenBeams)

### No Dummy Beams Found

If the MetalPart does not contain any dummy beams with `bIsDummy() == 2`:
- The script instance will still be created
- No tools will be applied (empty result)
- This is **not an error** - some MetalParts may be purely geometric

**How to Fix:**
Ensure the MetalPart was created by a proper hardware script. Check the MetalPart's internal structure using `HSB_I-ShowEntityInfo` or similar inspection tools.

---

## Advanced Usage Scenarios

### Scenario 1: Multiple Connectors on One Beam

**Situation:**
You have a continuous beam with three Simpson hangers along its length.

**Workflow:**
1. Run the script once
2. Select the single continuous beam (1 GenBeam)
3. Select all three MetalParts (hangers)
4. Result: Three independent script instances are created, each applying its own tool pattern to the same beam

**Why This Works:**
Each instance independently tracks its own MetalPart, so there's no conflict. The beam receives all tools from all three connectors.

---

### Scenario 2: Changing Connector Position After Linking

**Situation:**
You linked a post base to a post, then realized the post needs to move 50mm.

**Workflow:**
1. Move the post (GenBeam) to the new location
2. Move the MetalPart (post base) to match
3. Result: The script instance **automatically recalculates** and re-applies all tools at the new location

**Alternative (if only MetalPart moves):**
If you move just the MetalPart without moving the post:
- The script will recalculate
- Tools will shift to the new MetalPart position
- The post geometry will update accordingly
- This is useful for fine-tuning connector placement

---

### Scenario 3: Toggling AddCut During Design

**Situation:**
You initially thought the connector should control beam end cuts, but later decide to use a different framing strategy.

**Workflow:**
1. Initial placement with AddCut = "Yes"
2. Realize you need different end cuts
3. Select the script instance, change AddCut to "No" in Properties palette
4. Result: Previously applied dynamic cuts are **converted to static tools** and preserved
5. You can now manually adjust or remove those static cuts without affecting other tools

**Why This Matters:**
You don't lose work when changing your mind. The geometry is preserved as static (non-recalculating) tools.

---

### Scenario 4: One Connector, Multiple Beam Types

**Situation:**
A beam hanger connects a floor joist to a header beam. You need to apply tools to both beams.

**Workflow:**
1. Run the script
2. Select both beams (joist and header) in Step 3
3. Select the hanger MetalPart in Step 4
4. Result: One script instance applies tools from the hanger to both beams simultaneously

**Note:**
The script uses intersection tests to determine which tools apply to which beams. A drill that only passes through the joist will only be applied to the joist, even though both beams are linked.

---

## Troubleshooting

### Problem: Instance Disappears Immediately After Selection

**Symptom:**
You select a MetalPart, press Enter, and nothing seems to happen. The script instance vanishes.

**Cause:**
The script **intentionally erases** the temporary insertion placeholder after creating the persistent instances.

**Solution:**
This is normal behavior. The new instance(s) were created successfully. To verify:
1. Select one of the linked GenBeams
2. Check its tool list using the Properties palette or `HSB_I-ShowBeamInfo`
3. You should see new drills, slots, etc.

**Alternative Check:**
Select the MetalPart and look at the Properties palette. You should see the script instance listed in the entity group.

---

### Problem: No Tools Are Applied

**Symptom:**
The script runs without errors, but no machining operations appear on the GenBeams.

**Possible Causes:**

1. **Dummy beam type mismatch**
   - The MetalPart contains beams, but they are not flagged as `bIsDummy() == 2`
   - Solution: Check the MetalPart authoring script; ensure it sets dummy flag to 2

2. **No tools defined on dummy beams**
   - The dummy beams exist but have no drills, slots, or cuts
   - Solution: Verify the MetalPart design; check a known-good connector for comparison

3. **Intersection failure**
   - The GenBeams do not geometrically intersect the tool volumes
   - Solution: Check that the MetalPart is positioned correctly relative to the GenBeams

**Diagnostic Steps:**
1. Use `HSB_D-Element` to visualize the MetalPart's internal structure
2. Check if the MetalPart contains any entities with `.analysedTools()`
3. Temporarily enable debug mode in the script (modify `bDebug` flag)

---

### Problem: Wrong Tools Are Applied

**Symptom:**
Tools are applied, but they're in the wrong location or orientation.

**Possible Causes:**

1. **MetalPart positioned incorrectly**
   - The MetalPart was not at the correct installation point when the script ran
   - Solution: Move the MetalPart to the correct position; the script will recalculate automatically

2. **Dummy beam orientation issue**
   - The dummy beams inside the MetalPart have incorrect orientation
   - Solution: This is a MetalPart authoring issue; contact the connector library maintainer

3. **Coordinate system mismatch**
   - The drawing UCS (User Coordinate System) is not set to World
   - Solution: Type `UCS` → `W` (World) to reset UCS before running the script

---

### Problem: AddCut Doesn't Work

**Symptom:**
You set AddCut = "Yes", but no planar cuts are applied.

**Possible Causes:**

1. **No valid cuts in dummy beams**
   - The dummy beams may not have simple planar cuts defined
   - Hip cuts and compound cuts are **always excluded**

2. **Direction filter**
   - The cut normal doesn't align with the MetalPart-to-dummy-beam vector
   - This is by design to prevent applying cuts to the wrong face

**Solution:**
Check the MetalPart definition. Not all connectors require planar cuts.

---

### Problem: Script Crashes or Freezes

**Symptom:**
AutoCAD becomes unresponsive when the script runs.

**Possible Causes:**

1. **Very complex MetalPart**
   - MetalPart contains hundreds of dummy beams or tools
   - Solution: The script uses `envelopeBody()` for performance; check if the MetalPart design is reasonable

2. **Corrupted entity**
   - One of the selected entities is corrupted
   - Solution: Use `AUDIT` command to repair the drawing

3. **Infinite loop bug**
   - Rare edge case in dependency tracking
   - Solution: Report to hsbCAD support with the specific drawing file

---

## Performance Considerations

### For Large Assemblies

If you're working with:
- More than 10 MetalParts in one operation
- MetalParts with 50+ dummy beams each
- Complex roof or floor framing with hundreds of connectors

**Recommendations:**
1. Process connectors in batches (10-20 at a time)
2. Use object groups to organize linked instances
3. Consider using a dedicated layer for tool linker instances
4. Freeze/isolate layers you're not working on to reduce display overhead

### Envelope vs. Real Body

The script uses `envelopeBody()` for BeamCut intersection tests instead of `realBody()`:

```c
Body bd = _GenBeam[g].envelopeBody();
if (bd.intersectWith(bdTest)) { ... }
```

**Why:**
- `envelopeBody()` is a simplified bounding box (faster)
- `realBody()` is the exact ACIS solid (slower)
- For intersection tests, envelope is sufficient and significantly faster

**Trade-off:**
In rare cases, envelope testing may apply a beam cut to a beam that's *close* but not *exactly* intersecting. In practice, this is negligible for real-world connector geometry.

---

## Related Scripts and Workflows

### Upstream (Hardware Authoring)

These scripts create the MetalParts that this script consumes:

| Script Family | Purpose |
|---------------|---------|
| **Simpson StrongTie Anchor** | Creates Simpson connector MetalParts |
| **Hilti-P2P** | Creates Hilti post-to-post connections |
| **Rothoblaas WHT** | Creates Rothoblaas hidden connector MetalParts |
| **Generic Angle (GA)** | Creates generic angle bracket MetalParts |
| **BMF Balkenschuh** | Creates BMF beam hanger MetalParts |

All of these scripts follow the convention of using dummy beams with `bIsDummy() == 2` to define tool geometry.

---

### Downstream (Manufacturing and Reporting)

After using this script, the GenBeams now have complete tool definitions. These tools can be used by:

| Script | Purpose |
|--------|---------|
| **hsbCNC** | Exports tooling to CNC machine formats |
| **HSB_G-BillOfMaterial** | Generates material lists including hardware |
| **sd_BeamAssembly** | Creates shop drawings showing all machining operations |
| **HSB_E-ElementTable** | Produces element schedules with tool counts |
| **FastenerEditor** | Allows manual editing of fastener placement |

---

### Complementary Tools

| Script | When to Use |
|--------|-------------|
| **hsbMetalPlate** | When you need to add custom metal plates not in the library |
| **FastenerEditor** | When you need to manually adjust individual bolt positions |
| **HSB_G-EntityInformation** | To inspect what tools are applied to a GenBeam |
| **HSB_D-Element** | To visualize the internal structure of a MetalPart |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| **1.4** | April 10, 2019 | Bugfix: Dependency tracking corrected |
| **1.3** | April 10, 2019 | Bugfix: Dependencies (details not specified) |
| **1.2** | May 10, 2014 | Added support for House (housing) tools; Enhanced symbol display |
| **1.1** | Feb 28, 2014 | Corrected slot depth calculation |
| **1.0** | (Original) | Initial release |

---

## FAQ

### Q: Can I link the same GenBeam to multiple MetalParts?

**A:** Yes. Run the script multiple times, selecting the same GenBeam(s) each time but different MetalParts. Each MetalPart creates an independent instance, and all instances can apply tools to the same GenBeam.

---

### Q: What happens if I delete the MetalPart after linking?

**A:** On the next recalculation, the script instance will detect that the MetalPart is missing, report an error message, and erase itself to prevent orphaned tool data.

---

### Q: Can I manually edit the tools after they're applied?

**A:** The tools applied by this script are dynamic (recalculating). If you want to manually edit them:
1. Use **FastenerEditor** or similar tools to convert them to static tools
2. Or, delete the script instance to "freeze" the current tool state
3. Then edit individual tools using standard hsbCAD tool editing commands

---

### Q: Does this work with SIP panels or CLT panels?

**A:** The script is designed for **GenBeam** entities only. For SIP or CLT panel tooling, use:
- **hsbCLT-Drill**, **hsbCLT-Slot**, etc. for CLT panels
- **hsb_SIP-*** scripts for SIP panels

However, if your SIP or CLT structure uses GenBeams as edge beams or posts, those GenBeams can receive tools from this script.

---

### Q: Why do I see colored lines and shapes during recalculation?

**A:** That's the visual feedback system showing you where tools are being placed. These are temporary display objects that:
- Help you verify correct tool placement
- Do not plot or print
- Disappear/update when the script recalculates
- Use different colors for different tool types (see Visual Feedback section)

---

### Q: Can I use this with non-hsbCAD metal parts?

**A:** Only if the non-hsbCAD part:
1. Is a valid AutoCAD MassGroup (SOLID3D or BODY)
2. Contains beams with the correct dummy flag (2)
3. Has tools defined on those beams

Most third-party metal parts do not meet these criteria, so this script is primarily for hsbCAD-authored hardware libraries.

---

### Q: How do I check if tools were applied successfully?

**Method 1 - Visual:**
- Select a GenBeam
- Look for the colored visual feedback lines/shapes

**Method 2 - Properties:**
- Select a GenBeam
- Open Properties palette
- Expand the "Tools" section
- You should see new drill, slot, cut entries

**Method 3 - Reporting:**
- Run **HSB_I-ShowElementInfo** or **HSB_G-EntityInformation**
- Review the tool count and details

---

## Technical Notes for Advanced Users

### Internal Map Variables

The script uses `_Map` to store persistent state:

| Key | Type | Purpose |
|-----|------|---------|
| `"cutAdded"` | Integer (boolean) | Tracks whether cuts have been applied; used to handle AddCut toggle behavior |

---

### Coordinate System Handling

All tool geometry is cloned in **World Coordinate System (WCS)**:
```c
Vector3d vUcsX = _XW;
Vector3d vUcsY = _YW;
```

This ensures consistency regardless of the current UCS when the script is launched.

---

### Tool Application Methods

Different tool types use different application methods:

| Method | When Used |
|--------|-----------|
| `tool.addMeToGenBeamsIntersect(_GenBeam)` | Drills, slots, houses, mortises |
| `_GenBeam[g].addTool(tool, 2)` | Cuts (dynamic mode) |
| `_GenBeam[g].addToolStatic(tool, 1)` | Cuts (when toggling AddCut off) |
| `_GenBeam[g].addTool(tool)` | Beam cuts (with explicit intersection test) |

**Mode 2 vs. Mode 1:**
- Mode 2: Dynamic (recalculating) tool
- Mode 1: Static (frozen) tool

---

### Debugging

To enable verbose debugging, modify the script header:
```c
int bDebug=_bOnDebug;  // Change to: int bDebug=true;
```

Or use the **hsbTSLDebugController** system (if configured) to enable debugging without modifying the script.

---

## Conclusion

**hsbMetalPart-LinkDummyTools** is an essential automation tool in the hsbCAD timber construction workflow. By automatically transferring machining operations from metal connectors to timber members, it:

- Saves hours of manual work
- Eliminates human error in tool placement
- Ensures perfect alignment between hardware and timber
- Maintains live connections for design flexibility

Master this tool, and you'll significantly accelerate your timber framing projects while improving accuracy and consistency.

---

**Document Version:** 2.0
**Script Version:** 1.4 (April 10, 2019)
**Author:** thorsten.huck@hsbcad.com
**Last Updated:** 2026-02-20
