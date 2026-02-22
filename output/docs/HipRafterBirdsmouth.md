# Hip Rafter Birdsmouth

**Script Name:** `HipRafterBirdsmouth.mcr`
**Category:** Base/Core - Roof Framing
**Version:** 1.7 (Last updated: December 9, 2016)
**Script Type:** G (General/Automatic Tool Application)

---

## Overview

The Hip Rafter Birdsmouth script creates a traditional timber-framing birdsmouth joint where a hip rafter (diagonal roof member) intersects with two mitred plates (horizontal ridge or purlin beams). This tool automatically calculates and applies the precise cutting geometry needed to seat the hip rafter properly onto the plates, creating a structurally sound connection that is fundamental to traditional roof framing.

**What it does:**
- Creates a birdsmouth notch on a hip rafter where it meets two intersecting plates/purlins
- Automatically handles varying plate heights
- Supports both standard (≥90°) and acute (<90°) angle configurations
- Generates appropriate cutting tools (BeamCut or ParHouse) based on the geometry
- Provides visual display of the connection in AutoCAD

**Application Scenarios:**
- Hip and valley roof framing where diagonal rafters meet ridge beams
- Traditional timber frame hip connections
- Roof purlin-to-hip rafter joints
- Complex roof geometry with varying member heights

---

## Prerequisites

### Required Elements
1. **Two Plates/Purlins** - Horizontal beams that the hip rafter will connect to:
   - Must NOT be parallel to each other
   - Can be at different heights
   - Form the "V" shape that the hip rafter crosses

2. **One Hip Rafter** - Diagonal roof member:
   - Should intersect or approach the two plates
   - Oriented along the angle bisector of the two plates

### Typical Roof Framing Context
```
    Ridge Beam 1
         |  \
         |   \  Hip Rafter (diagonal)
         |    \
    Ridge Beam 2
```

The birdsmouth allows the hip rafter to sit down into the plates for proper load transfer.

---

## User Interface

### Properties (AutoCAD Properties Palette - OPM)

After inserting the script, you can adjust these parameters through the Properties Palette:

#### 1. **Minimal Tooling Y**
- **Type:** Yes/No selection
- **Default:** No
- **Function:** Controls whether the cutting tool extends beyond the beam width in the Y direction
  - **No (Default):** Tool extends 10× the beam width to ensure complete cut-through
  - **Yes:** Tool is precisely sized to beam width only (minimal material removal)
- **When to use Yes:** When you want to preserve maximum material on the hip rafter and ensure precise fit
- **When to use No:** When you want to guarantee the cut goes completely through regardless of slight alignment issues

#### 2. **Minimal Tooling Z**
- **Type:** Yes/No selection
- **Default:** Yes
- **Function:** Controls whether the cutting tool extends beyond the beam depth in the Z (vertical) direction
  - **Yes (Default):** Tool is precisely sized to beam depth only
  - **No:** Tool extends 10× the beam depth for guaranteed cut-through
- **When to use Yes:** Standard setting for clean, minimal cuts
- **When to use No:** When dealing with complex geometries where you need to ensure complete penetration

#### 3. **Relief**
- **Type:** Drop-down selection
- **Default:** "not rounded"
- **Options:**
  1. **not rounded** - Sharp corners (standard machining)
  2. **rounded** - Rounded internal corners (standard router bit radius)
  3. **relief** - Relief cuts at corners (allows square chisel cleanup)
  4. **rounded with small diameter** - Tighter radius for smaller tools
  5. **relief with small diameter** - Smaller relief cuts
  6. **rounded** - (duplicate option)
  7. **relief K1** - Named relief configuration

- **Function:** Only active when plate intersection angle is <90°
- **Purpose:** Specifies how internal corners of the ParHouse cut should be treated
- **Practical Impact:**
  - **Not rounded:** CNC machines can cut sharp internal corners (5-axis or multiple operations)
  - **Rounded:** Standard for 3-axis CNC with router bits (most common)
  - **Relief:** Allows subsequent manual cleanup with chisels in traditional timber framing

---

## Operation Steps

### Step 1: Launch the Script
```
Command: HipRafterBirdsmouth
(or select from toolbar/menu)
```

### Step 2: Select the Two Plates
**Prompt:** "Select plates"

1. Click the first plate/purlin beam
2. Click the second plate/purlin beam
3. Press **Enter** to confirm

**Validation:**
- The script will verify that you selected at least 2 beams
- The script will verify that the beams are NOT parallel (they must form an angle)
- If validation fails, you'll see: "Invalid selection" and the script will cancel

**Tips:**
- Select the two beams in any order
- The beams can be at different heights - the script will automatically handle this
- Make sure the beams actually intersect or are close to intersecting when projected

### Step 3: Select the Hip Rafter
**Prompt:** "Select hip rafter"

1. Click the diagonal hip rafter beam that will receive the birdsmouth cut
2. The script executes immediately after selection

**Result:**
- The cutting tools are applied to the hip rafter
- A circular display marker appears at the connection point
- The birdsmouth joint geometry is visualized in the model

---

## Technical Behavior

### Automatic Geometry Calculation

The script performs sophisticated geometric analysis:

1. **Angle Detection:**
   - Measures the angle between the two plates
   - If angle ≥ 90°: Uses standard BeamCut tools
   - If angle < 90°: Uses ParHouse (parallel housed joint) tool

2. **Height Compensation:**
   - Automatically detects if the two plates are at different heights
   - Adjusts the reference point to align with the highest plate
   - Ensures the birdsmouth sits at the correct vertical position

3. **Tool Sizing:**
   - Calculates appropriate tool dimensions based on beam sizes
   - Applies the "Minimal Tooling" multipliers (1× or 10×) based on user settings
   - Ensures complete material removal for proper joint fit

4. **Direction Orientation:**
   - Determines which direction the cut should face based on hip rafter orientation
   - Uses dot product calculations to ensure the cut aligns toward the ridge (upward)

### Cut Types Generated

#### For Angles ≥ 90° (Standard Configuration)
The script creates **two BeamCut tools**:
- **BeamCut 1:** Aligned with Plate 1 direction
- **BeamCut 2:** Aligned with Plate 2 direction
- Both cuts intersect at the mitre line to create the V-shaped birdsmouth

#### For Angles < 90° (Acute Configuration)
The script creates **ParHouse tools** (parallel housed joints):
- More complex geometry needed for acute angles
- If "Minimal Tooling Y" or "Z" is Yes: Creates 2 ParHouse tools (one for each direction)
- If both Minimal Tooling settings are No: Creates 1 combined ParHouse tool
- Relief settings control corner treatment

### Visual Display

After execution, you'll see:
- **Circular marker** at the connection point (indicates the birdsmouth location)
- **Contact face visualization** showing where beams meet (color 9 - gray)
- The actual cutting tools are applied to the hip rafter geometry

---

## Practical Examples

### Example 1: Standard Hip Roof Ridge Connection (90° Configuration)

**Scenario:**
- Ridge Beam 1: 2×12 (38×286mm) running North-South
- Ridge Beam 2: 2×12 (38×286mm) running East-West
- Hip Rafter: 2×12 (38×286mm) running diagonally at 45°
- Ridge beams meet at same height

**Setup:**
1. Model your roof with the two ridge beams meeting at 90°
2. Position the hip rafter diagonally
3. Run HipRafterBirdsmouth script

**Selection:**
- Select Ridge Beam 1
- Select Ridge Beam 2
- Press Enter
- Select Hip Rafter

**Property Settings:**
- Minimal Tooling Y: No (for guaranteed cut-through)
- Minimal Tooling Z: Yes (standard)
- Relief: not rounded (standard CNC machining)

**Result:**
- Two perpendicular BeamCuts are applied to the hip rafter
- Creates a traditional V-shaped birdsmouth notch
- Hip rafter now seats properly into the ridge intersection

---

### Example 2: Unequal Height Purlins (Step Connection)

**Scenario:**
- Upper Purlin: 2×8 at elevation 10,000mm
- Lower Purlin: 2×8 at elevation 9,500mm (500mm lower)
- Hip Rafter: 2×10 connecting across the step

**Setup:**
The script automatically detects the height difference and adjusts the birdsmouth position.

**Selection:**
- Select Upper Purlin
- Select Lower Purlin (order doesn't matter)
- Press Enter
- Select Hip Rafter

**Automatic Behavior:**
- Script finds the highest plate (Upper Purlin)
- Sets the birdsmouth reference point at the upper purlin level
- Creates cuts that allow the hip rafter to bridge the height difference
- The hip rafter will fully contact the upper purlin and partially contact the lower

**Property Recommendations:**
- Minimal Tooling Y: Yes (precise fit for stepped connection)
- Minimal Tooling Z: Yes (control depth precisely)

---

### Example 3: Acute Angle Valley Configuration (<90°)

**Scenario:**
- Valley Purlin 1 and Valley Purlin 2 meet at 60° (acute angle)
- Valley Rafter needs birdsmouth to fit into the acute valley

**Setup:**
When plates meet at <90°, traditional BeamCuts can't create the proper geometry - ParHouse is required.

**Selection:**
- Select Valley Purlin 1
- Select Valley Purlin 2
- Press Enter
- Select Valley Rafter

**Automatic Behavior:**
- Script detects angle < 90°
- Switches to ParHouse cutting tool automatically
- Creates parallel housed joint geometry instead of simple beamcuts

**Property Settings:**
- Relief: **rounded** (Important! Acute angles create tight internal corners)
  - This allows your CNC router bit to properly cut the internal corner
  - Without this, you'd need multiple tool passes or manual finishing

**CNC Manufacturing Note:**
For acute angles with rounded relief:
- Use appropriate router bit diameter (typically 8-12mm)
- The "rounded" setting will apply the router bit radius to internal corners
- This ensures the joint can actually be manufactured on standard 3-axis CNC equipment

---

## Common Issues and Solutions

### Issue 1: "Invalid selection" Error

**Symptoms:**
- Script cancels immediately after selecting beams
- Error message appears in command line

**Causes:**
1. Selected fewer than 2 beams for the plates
2. Selected beams that are parallel to each other

**Solutions:**
- Ensure you select exactly 2 non-parallel beams
- Check that your plate beams actually form an angle (not parallel)
- If beams appear to be at an angle but are flagged as parallel, check your geometry - they may be more parallel than they appear

---

### Issue 2: Birdsmouth Appears at Wrong Height

**Symptoms:**
- The cutting tools are positioned too high or too low on the hip rafter

**Causes:**
- The plates are at significantly different heights
- The hip rafter is not properly positioned relative to the plates

**Solutions:**
- The script automatically uses the highest plate for reference
- Verify your hip rafter actually intersects the plate geometry
- Check that your beam placements are correct in the model
- If intentional step: this is correct behavior (highest plate governs)

---

### Issue 3: Cuts Don't Penetrate Completely

**Symptoms:**
- Birdsmouth appears incomplete
- Material remains that should be removed

**Causes:**
- "Minimal Tooling Y" and/or "Minimal Tooling Z" set to Yes
- Beam alignment is slightly off from ideal

**Solutions:**
- Set Minimal Tooling Y to **No** for 10× extension (guaranteed cut-through)
- Set Minimal Tooling Z to **No** if needed
- This trades precision for reliability - the tools will be oversized to ensure complete cuts

---

### Issue 4: CNC Can't Machine Acute Angle Corners

**Symptoms:**
- CNC machine gives errors for internal corners on acute angle birdsmouths
- Sharp internal corners can't be cut with router bit

**Causes:**
- Relief setting is "not rounded"
- Router bits are round - can't create perfectly sharp internal corners

**Solutions:**
- Change Relief to **"rounded"** or **"rounded with small diameter"**
- This applies router bit radius compensation to internal corners
- For 8mm router bit, use "rounded with small diameter"
- For 12mm router bit, use standard "rounded"

---

## Workflow Integration

### Position in Timber Framing Workflow

**Typical Sequence:**

1. **Model Creation**
   - Model your roof structure with plates/purlins
   - Position hip/valley rafters

2. **Connection Design** ← *HipRafterBirdsmouth is here*
   - Apply HipRafterBirdsmouth to create joints
   - Adjust Minimal Tooling and Relief settings as needed

3. **Hardware Application**
   - Add metal connectors if required (Simpson, etc.)
   - Add bolts/screws for reinforcement

4. **Shop Drawings**
   - Generate fabrication drawings showing birdsmouth cuts
   - CNC export includes the cutting tool geometry

5. **Manufacturing**
   - CNC machines execute the BeamCut/ParHouse operations
   - Manual cleanup if using "relief" settings

---

### Related Tools

**Commonly Used With:**

- **hsbBeamcut** - Manual beamcut tool if you need custom cut geometry
- **hsbHousedBirdsmouth** - Alternative birdsmouth for different configurations
- **Simpson StrongTie** scripts - Add metal hardware to reinforce the birdsmouth
- **HSB_R-*** - Other roof framing tools for ridge beams, rafters
- **hsbCNC** - Export tooling to CNC machines for fabrication

**Before Using:**
- Complete your basic roof frame geometry
- Ensure plates and rafters are properly positioned

**After Using:**
- Add structural hardware if required
- Generate shop drawings with cutting details
- Export to CNC for manufacturing

---

## Manufacturing Considerations

### CNC Machining

**Tool Requirements:**
- **Standard (≥90° angles):** Simple beamcuts - standard saw or CNC sawblade operations
- **Acute (<90° angles):** ParHouse cuts - requires routing or 5-axis milling

**Relief Settings for CNC:**
- **3-axis CNC router:** Use "rounded" relief to match your router bit diameter
- **5-axis CNC mill:** Can use "not rounded" for true sharp corners
- **Manual cutting:** Use "relief" to leave corners for chisel cleanup

### Traditional Hand-Tool Work

If manufacturing manually:

**Relief Setting:** Choose **"relief"** or **"relief with small diameter"**

**Process:**
1. CNC or saw makes the main cuts with relief pockets at corners
2. Carpenter uses chisels to square up the internal corners by hand
3. Allows traditional craftsmanship finish on CNC-prepared work

---

## Technical Notes

### Script Classification
- **Type G (General Tool Application):** Automatically applies tools to beams without user grip points
- **NumBeamsReq: 2** - Requires minimum 2 beams (actually uses 3: 2 plates + 1 rafter)
- **ImplInsert: 1** - Uses implied insertion mode (select objects then apply)

### Version History

- **v1.7 (Dec 2016):** Minimal tooling for <90° angles enabled
- **v1.6 (Jul 2014):** Bugfix for varying plate heights
- **v1.5 (Oct 2013):** Bugfix for alignment; contact face between plates and rafter used for display
- **v1.4 (Jun 2013):** Support for angles smaller than 90°; Relief property added
- **v1.2 (Jun 2013):** New properties to create open beamcuts
- **v1.1 (Jan 2008):** Bugfix and user input improved
- **v1.0 (Mar 2006):** Initial release

### Coordinate System

The script uses:
- **_Pt0T / _Pt0B:** Top and bottom reference points (automatically calculated from plate intersection)
- **_X0, _X1:** Direction vectors along each plate
- **_Z0:** Vertical (up) direction for the joint
- **_Beam[0], _Beam[1]:** The two plates
- **_Beam[2]:** The hip rafter receiving the birdsmouth

---

## Limitations

1. **Requires Non-Parallel Plates:**
   - The two plates must form an angle
   - Parallel plates will trigger "Invalid selection" error
   - If you need parallel configuration, this is not the correct tool

2. **Single Birdsmouth Only:**
   - Creates one birdsmouth per execution
   - For multiple hip rafters, run the script multiple times

3. **Fixed to Plate Geometry:**
   - The birdsmouth automatically aligns to the plates
   - Cannot manually adjust the depth or angle
   - If you need custom depth, use hsbBeamcut manually instead

4. **Ridge Orientation:**
   - The script assumes the hip rafter is oriented toward the ridge (upward)
   - If oriented differently, the cutting direction may need manual adjustment

---

## Tips and Best Practices

### Design Phase

✅ **DO:**
- Model your roof structure accurately before applying birdsmouths
- Ensure beams are positioned at their final locations
- Check that hip rafter actually intersects the plates geometrically

❌ **DON'T:**
- Apply birdsmouths to parallel plates (use different connection method)
- Assume the birdsmouth will "pull" beams into alignment
- Forget to account for material removal - the hip rafter will be cut and shortened

### Property Settings

**For Most Standard Roofs:**
- Minimal Tooling Y: No (safe default)
- Minimal Tooling Z: Yes (standard)
- Relief: not rounded (standard CNC)

**For Precision Work:**
- Minimal Tooling Y: Yes
- Minimal Tooling Z: Yes
- Relief: rounded (if angle <90°)

**For Traditional Timber Framing:**
- Minimal Tooling Y: Yes
- Minimal Tooling Z: Yes
- Relief: relief (allows hand chisel finishing)

### Manufacturing

- **Review the cutting geometry visually** before sending to CNC
- **Check Relief settings** if you have acute angles - CNC may fail without proper rounding
- **Coordinate with shop** on available router bit sizes for Relief diameter settings

---

## Glossary

**Birdsmouth:** A notched joint in a rafter that allows it to sit securely on a horizontal beam (plate). Creates a perpendicular bearing surface for load transfer.

**Hip Rafter:** Diagonal rafter running from the ridge to the corner of a building, forming the "hip" of a hip roof.

**Plate / Purlin:** Horizontal beam in a roof structure. Plates typically run along walls; purlins run between rafters.

**BeamCut:** A cutting tool that removes material from a beam using a planar cut.

**ParHouse (Parallel Housed Joint):** A specialized cutting operation for complex angles, especially <90° configurations.

**Relief:** Manufacturing accommodation for internal corners - either rounded (router bit) or pocketed (chisel cleanup).

**Minimal Tooling:** Setting that controls whether cutting tools are precisely sized (1×) or oversized (10×) for guaranteed penetration.

**Mitre:** The angled line where two plates meet, forming the intersection that the birdsmouth aligns to.

---

## Summary

The Hip Rafter Birdsmouth script is an intelligent automation tool that eliminates the complex geometric calculations traditionally required for traditional roof framing joints. By simply selecting two plates and a hip rafter, the script:

- Automatically calculates the precise birdsmouth geometry
- Handles varying plate heights
- Adapts to both standard and acute angle configurations
- Provides manufacturing-ready cutting tools for CNC or traditional fabrication
- Ensures proper structural load transfer through correct joint seating

**Key Advantages:**
- Eliminates manual geometric layout errors
- Ensures consistent, accurate birdsmouths across entire projects
- Adapts to complex roof geometries automatically
- Integrates directly with CNC manufacturing workflows
- Supports both modern CNC and traditional hand-tool fabrication methods

**When to Use:**
Use this script whenever you have a hip or valley rafter that needs to seat into two intersecting plates or purlins in a roof structure. It's particularly valuable for complex roof geometries with multiple angles or varying member heights, where manual calculation would be time-consuming and error-prone.

---

*This documentation is based on HipRafterBirdsmouth.mcr version 1.7. For the most current version, check the hsbCAD script library.*
