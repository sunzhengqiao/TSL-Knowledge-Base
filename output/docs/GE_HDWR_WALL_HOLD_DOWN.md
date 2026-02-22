# GE_HDWR_WALL_HOLD_DOWN

## Overview

| Property | Value |
|----------|-------|
| Script Name | GE_HDWR_WALL_HOLD_DOWN |
| Type | Object (O) |
| Version | 3.21 (January 7, 2021) |
| Category | Hardware - Wall Hold-Down Connectors |
| Manufacturer | Simpson Strong-Tie, USP |
| Keywords | Wall, HoldDown, Hardware, Connector, Simpson, USP, Shear, Uplift, Anchor |
| Beams Required | 0 (stud pack selected during insertion) |
| Units | Imperial (inches) |
| Related Scripts | GE_HDWR_WALL_ANCHOR |

GE_HDWR_WALL_HOLD_DOWN is a comprehensive hardware placement tool for structural hold-down connectors in stick-frame wall construction. Hold-down hardware provides critical uplift resistance in shear walls by anchoring vertical studs (posts) to the foundation or floor framing below. This script manages the complete lifecycle of hold-down connectors: from initial placement on stud packs through 3D visualization, fastener scheduling, anchor rod creation, beam stretching, and bill-of-materials export.

The script supports an extensive catalog of Simpson Strong-Tie and USP connector models, each with manufacturer-specified dimensions, fastener types, and fastener quantities. Upon placement, it generates accurate 3D representations of the selected connector, manages stud distribution zones to prevent interference, optionally creates companion anchor rods through the GE_HDWR_WALL_ANCHOR script, and exports complete hardware component data for procurement and scheduling.

**Key Capabilities:**
- **Catalog of 30+ hold-down models** from Simpson Strong-Tie and USP
- **Three installation modes**: Fully Installed, Tacked (temporary), Field Installed
- **Automatic fastener scheduling** based on connector type and installation mode
- **Integrated anchor rod creation** with automatic diameter coordination
- **Intelligent stud management**: Stretches hold-down studs to plates, erases conflicting studs
- **Wall element tracking**: Follows wall splits and modifications
- **BOM export**: Hardware components with manufacturer, model, and fastener details

## Usage Environment

| Environment | Supported | Notes |
|-------------|-----------|-------|
| Model Space | Yes | Primary environment: creates 3D connector geometry, modifies beam data, manages hardware groups |
| Paper Space | No | Not intended for direct Paper Space use |
| Element Required | Yes | Must be associated with a Stick Frame Wall Element |
| DXA Export | Yes | Exports connector type and element number for data extraction |
| Display Representations | Yes | Uses "HoldDown" display representation for filtered views |
| Multi-Placement | Yes | Implicit insertion mode allows multiple placements in single command |

The script operates exclusively in Model Space and requires a valid stick-frame wall element containing vertical studs. The hold-down instance attaches to a stud pack (one or more vertical beams) and derives its coordinate system from the parent wall element. The implicit insertion pattern allows you to place multiple hold-downs in a single command session.

## Prerequisites

### Required Elements
- **Wall Element**: A stick-frame wall element must exist in the drawing. All selected studs must belong to the same wall element. If studs from different elements are selected, the script reports an error and terminates.
- **Vertical Stud Pack**: At least one vertical beam (stud) within the wall element. The script filters beams to find those parallel to the wall's Y-axis (vertical direction). A stud pack can consist of multiple studs grouped together (e.g., doubled or tripled king studs at shear wall ends).

### Functional Requirements
- **Element Construction**: For "Stretch beams" and "Erase intersecting beams" features to function, the wall element must complete its construction or recalculation cycle. These operations execute during element construction events.
- **GE_HDWR_WALL_ANCHOR** (optional): The companion anchor script is required if you use the "Add Anchor" context menu command. It must be available in the TSL script search paths.

### Design Context
Hold-down connectors are typically placed at:
- **Shear wall ends**: High-capacity hold-downs (HDU, HTT, HD series) at each end of a shear wall segment
- **Opening corners**: Medium-capacity hold-downs (DTT, LTT series) at door and window openings
- **Continuous rod systems**: Top-of-wall hold-downs for multi-story construction
- **Foundation anchoring**: Concrete-embedded straps (LSTHD, STHD series) cast into foundation

## Usage Steps

### Step 1: Launch the Script

Run the `TSLINSERT` command in AutoCAD and select **GE_HDWR_WALL_HOLD_DOWN** from the script browser. At first launch, an initial properties dialog appears for configuration review.

**Initial Configuration (First Launch):**
- Review default hold-down type
- Confirm installation option (Fully Installed recommended for initial placement)
- Verify beam color setting
- Set stretch and erase options

### Step 2: Select a Vertical Stud Pack

**Command Line Prompt**: `select a vertical stud pack`

Click on one or more vertical studs that form the hold-down stud pack. These are typically king studs or dedicated hold-down posts at the ends of shear wall segments.

**Selection Rules:**
- Select all studs that comprise the hold-down assembly (single stud, doubled studs, tripled studs)
- All selected studs must belong to the same wall element
- Selected beams must be vertical (parallel to wall Y-axis)
- Invalid selections are filtered out automatically

**Selection Loop Behavior:**
- After each successful selection, the script creates a hold-down instance and immediately prompts for the next stud pack
- You can place multiple hold-downs in sequence
- Press **Escape** or **Enter** without selection to exit the insertion loop
- The script clones itself onto each selected stud pack (implicit insertion pattern)

**Common Selection Scenarios:**
- **Single king stud**: Click one vertical beam
- **Doubled stud pack**: Shift+Click to select both studs, or use window selection
- **Tripled stud pack**: Window selection around all three studs
- **End-of-wall post**: Select the outermost vertical beam(s)

### Step 3: Verify Placement Side

After insertion, select the hold-down instance and open the **Properties Palette** (Ctrl+1). Set the **Side to place connector** property to position the hold-down at the correct corner of the stud pack.

**Side Options:**

| Side Option | Position Description | Use Case |
|-------------|----------------------|----------|
| **Bottom Left** | Bottom of wall, left side of stud pack (looking from outside face) | Left end of shear wall, bottom connection |
| **Bottom Right** | Bottom of wall, right side of stud pack | Right end of shear wall, bottom connection |
| **Top Left** | Top of wall, left side of stud pack | Left end of upper story, continuous rod system |
| **Top Right** | Top of wall, right side of stud pack | Right end of upper story, continuous rod system |

**Orientation Logic:**
- **"Bottom"** options place the hold-down base at the bottom plate (standard foundation/floor connection)
- **"Top"** options flip the hold-down upside-down, placing the base at the top plate (upper story connection)
- **"Left"** and **"Right"** control which side of the stud pack the connector body extends toward
- The orientation affects the offset vector and up vector used for 3D geometry generation

**Visual Verification:**
- The hold-down 3D geometry updates immediately when you change this property
- Check the rod hole location relative to the stud pack
- Verify the connector body does not conflict with adjacent framing

### Step 4: Select the Hold-Down Type

In the Properties Palette, set the **Hold Down Type** dropdown to the desired connector model. The available models are organized by manufacturer and capacity.

**Selection Criteria:**
- **Load capacity**: Match the hold-down to the structural engineer's specifications (typically shown on shear wall schedules)
- **Rod diameter**: Ensure compatibility with anchor rod and foundation design (5/8", 7/8", 1")
- **Physical dimensions**: Verify the connector fits within the available space (width, depth, height)
- **Fastener type**: Some models offer nail vs. SDS screw variants

**Model Naming Convention:**
- Base models: HTT4, HDU8, etc.
- Manufacturer suffix: "SIMPSON", "USP"
- Fastener variants: "NAIL", "SDS", "SDS2.5", "SDS3"

**Automatic Updates:**
When you change the hold-down type, the script automatically updates:
- 3D connector geometry (shape, dimensions)
- Rod diameter (affects anchor rod creation)
- Default fastener type
- Default fastener quantity
- Display representation

### Step 5: Set Installation Options

Choose the **Installation Options** to control fastener scheduling:

| Option | Behavior | Fastener Quantity | Use Case |
|--------|----------|-------------------|----------|
| **Fully Installed** | Full fastener count and manufacturer-specified fastener type | Full (e.g., 18, 26, 30 fasteners) | Shop installation, complete factory attachment |
| **Tacked** | Reduced fastener count for temporary attachment | Typically 2 fasteners | Field erection, temporary hold during assembly |
| **Field Installed** | Zero fasteners in shop | 0 fasteners | Connector ships loose, all fasteners installed on-site |

**Workflow Implications:**
- **Shop Installed (Fully Installed)**: The connector is completely attached to the stud pack in the fabrication shop. Full fastener schedule appears in shop drawings and BOM.
- **Tacked**: The connector is lightly attached with minimal fasteners for shipping and handling. Final fastening occurs during wall erection.
- **Field Installed**: The connector is not pre-attached. It ships separately and is installed entirely on-site after wall positioning.

**Fastener Schedule Update:**
When you change the installation option, the **Fasteners Type** and **Fasteners Quantity** fields update automatically to reflect the manufacturer's specification for that combination. You can override these values manually if your project requires non-standard fastener schedules.

### Step 6: Review and Adjust Fastener Schedule

The script automatically populates fastener specifications based on connector type and installation option. Verify the fastener schedule matches your project requirements.

**Automatic Fastener Selection:**
- Each connector model has manufacturer-specified fastener types (nails, SDS screws, bolts)
- Full installation fastener counts range from 4 to 36 depending on connector size
- Tacked installation typically uses 2 fasteners for temporary hold
- Field installation uses 0 fasteners

**Manual Override (if needed):**
If your project requires non-standard fastener schedules:
1. Change **Installation Options** to the appropriate mode
2. Manually edit **Fasteners Type** to select alternate fastener
3. Manually edit **Fasteners Quantity** to specify custom count
4. The script will add a separate hardware component for the custom fasteners in the BOM

**Common Fastener Types:**
- `0.148 x 1 1/2"` - Standard 10d nail
- `0.250 x 2 1/2" SDS` - Simpson SDS heavy-duty screw
- `0.148 x 3"` - 16d common nail
- `#10 x 2 1/2" SD` - Simpson Strong-Drive screw
- `1.0 x X" Bolt` - Through-bolt (HD12/HD19 models)

**BOM Export Behavior:**
- If you use manufacturer defaults (Fully Installed with default fasteners), the script exports a single hardware component with notes indicating the installation mode and fastener schedule
- If you override fastener type or quantity, the script exports an additional "Nail" hardware component with your custom specification

### Step 7: Add an Anchor Rod (Optional)

Right-click the hold-down instance and select **Add Anchor** from the context menu. This creates a child GE_HDWR_WALL_ANCHOR instance positioned at the rod hole location of the hold-down.

**Automatic Coordination:**
- Anchor rod diameter is automatically passed from the hold-down to the anchor script (5/8", 7/8", 1")
- Anchor rod position is set to the drill centerline of the hold-down
- The anchor instance is tracked by the hold-down for later management

**Anchor Creation Process:**
1. Right-click the hold-down instance
2. Select **Add Anchor** from context menu
3. The anchor script inserts automatically at the correct location
4. The anchor entity reference is stored in the hold-down's Map under "ANCHOR" key
5. The "Drill Plates" property is shared between hold-down and anchor scripts

**When to Add Anchors:**
- **Bottom-of-wall hold-downs**: Always add anchor rod for foundation connection
- **Top-of-wall hold-downs**: Add anchor rod if using continuous rod system through floors
- **Concrete-embedded straps** (LSTHD8, STHD10, STHD14): Do NOT add anchors (these embed directly into concrete without through-bolts)

**Anchor Management:**
- **Release Anchor**: Right-click and select "Release Anchor" to detach the anchor rod from the hold-down. The anchor remains in the drawing as an independent object.
- **Replace Anchor**: Release the existing anchor, delete it, then add a new anchor
- **Modify Anchor**: Select the anchor instance separately and adjust its properties (rod length, embedment, etc.)

**Drill Plates Coordination:**
The "Drill Plates" property (Yes/No) on the hold-down controls whether the associated anchor script drills through the top and bottom plates. Both scripts read this property for coordination.

### Step 8: Regenerate the Wall Element

After placing hold-downs, regenerate the wall element (or allow it to recalculate during normal CAD operations). During element construction, the script executes several automated operations if enabled.

**Automatic Operations During Element Construction:**

1. **Stretch Beams to Plates** (if "Stretch beams" = Yes):
   - Searches for nearest plate beam in each direction along the stud axis
   - Uses dynamic stretching to connect stud ends to top plate, bottom plate, or angled top plates
   - Special handling for supporting beams and jack studs:
     - Supporting beams and jack-under-opening studs stretch only to bottom plates
     - Jack-over-opening studs stretch only to top plates
   - Ensures hold-down studs span full wall height without manual adjustment

2. **Erase Intersecting Beams** (if "Erase intersecting beams" = Yes):
   - Checks all automatically generated studs for intersection with hold-down stud pack
   - Uses a slightly shortened body (0.5 inch inset on each end) to avoid false positives at junctions
   - Erases only regular studs that conflict with the hold-down pack
   - Never erases top plates or bottom plates
   - Prevents doubled studs at hold-down locations after stud distribution runs

3. **Set No-Stud Distribution Range**:
   - Calculates the leftmost and rightmost extent of the hold-down stud pack
   - Calls `el.setRangeNoDistributionStud(ptLeft, ptRight)` to mark this zone
   - The element's stud distribution algorithm skips this zone, preventing additional studs

4. **Mark Sheet Cut Locations**:
   - Identifies vertical beams that touch zone 1 (structural sheathing zone)
   - Calls `el.setSheetCutLocation()` to register cut points
   - Allows sheathing scripts to create proper cutouts around the hold-down connector

**Triggering Regeneration:**
- Automatic: Most modifications to the wall element trigger recalculation
- Manual: Right-click the wall element and select "Recalculate" or "Regenerate Construction"
- Batch: Use element update commands to refresh multiple walls

**Verification After Regeneration:**
- Check that hold-down studs extend to top and bottom plates
- Verify no duplicate studs exist within the hold-down zone
- Confirm sheathing cuts appear correctly around the connector
- Review stud distribution spacing adjacent to the hold-down

### Step 9: Verify Color and Visibility Settings

**Color Coding:**
Use the **Color index for my beams** property to visually distinguish hold-down studs from standard wall studs.

- Default value: 3 (Green)
- Standard ACI color values: 1=Red, 2=Yellow, 3=Green, 4=Cyan, 5=Blue, 6=Magenta, 7=White
- Value of -1: Beams inherit the color of the TSL instance itself

**Display Representations:**
The hold-down geometry appears in the "HoldDown" display representation. You can toggle this representation on/off in hsbCAD display settings to control visibility:
- **Show hold-downs**: Enable "HoldDown" display representation for fabrication views
- **Hide hold-downs**: Disable "HoldDown" display representation for simplified framing views
- **DXA export**: The hold-down is marked for DXA export and appears in data extraction

**Top View Display:**
In plan views, the script draws:
- Rectangular outline of connector body
- Circular rod hole at drill centerline
- Text label showing connector model

### Step 10: Adjust Offsets (if needed)

Fine-tune the connector position using offset properties when default placement does not match detailing requirements.

**Vertical Offset:**
- Shifts the hold-down along the wall Y-axis (stud direction)
- Positive values move upward; negative values move downward
- Measured in current drawing units (inches)
- Use cases: Raise hold-down above bottom plate for plumbing clearance, adjust to specific foundation detail

**Lateral Offset:**
- Shifts the hold-down along the wall Z-axis (wall thickness direction)
- Positive values move toward exterior face; negative values move toward interior face
- Measured in current drawing units (inches)
- Use cases: Align with specific sheathing layer, avoid interior finish conflicts, match exterior siding detail

**Offset Interaction:**
Both offsets are applied relative to the default position calculated from the stud pack geometry. The hold-down recalculates immediately when you change these values.

## Properties Panel Parameters

### Hold Down Type
| Property | Details |
|----------|---------|
| Display Name | Hold Down Type |
| Type | String (dropdown) |
| Default | First item in list (HTT4 SIMPSON) |
| Options | 30+ Simpson Strong-Tie and USP models |
| Description | Selects the hold-down connector model. Changing this value updates dimensions, rod size, fastener type, and fastener quantity automatically. |

**Simpson Strong-Tie HTT Series** (High-Capacity Tension Ties):

| Model | Width | Depth | Height | Rod Ø | Fastener (Full) | Qty (Full) | Qty (Tacked) |
|-------|-------|-------|--------|-------|-----------------|------------|--------------|
| HTT4 SIMPSON | 2-5/8" | 2-1/2" | 12-3/8" | 5/8" | 0.148 x 1-1/2" | 18 | 2 |
| HTT4 NAIL SIMPSON | 2-5/8" | 2-1/2" | 12-3/8" | 5/8" | 0.148 x 1-1/2" | 18 | 2 |
| HTT4 SDS SIMPSON | 2-5/8" | 2-1/2" | 12-3/8" | 5/8" | 0.162 x 2-1/2" | 18 | 2 |
| HTT5 SIMPSON | 2" | 2-1/2" | 16" | 5/8" | 0.148 x 1-1/2" | 26 | 2 |
| HTT5 NAIL SIMPSON | 2" | 2-1/2" | 16" | 5/8" | 0.148 x 1-1/2" | 26 | 2 |
| HTT5 SDS SIMPSON | 2" | 2-1/2" | 16" | 5/8" | 0.162 x 2-1/2" | 26 | 2 |
| HTT5KT SIMPSON | 2" | 2-1/2" | 16" | 5/8" | #10 x 2-1/2" SD | 26 | 2 |

**Simpson Strong-Tie LTT Series** (Light Tension Ties):

| Model | Width | Depth | Height | Rod Ø | Fastener (Full) | Qty (Full) | Qty (Tacked) |
|-------|-------|-------|--------|-------|-----------------|------------|--------------|
| LTT19 SIMPSON | 3-1/8" | 1-3/4" | 19-1/8" | 5/8" | 0.148 x 1-1/2" | 8 | 2 |
| LTT20B SIMPSON | 3-1/8" | 2" | 19-3/4" | 5/8" | 0.148 x 1-1/2" | 10 | 2 |
| LTT20B SDS SIMPSON | 3-1/8" | 2" | 19-3/4" | 5/8" | 0.250 x 1-1/2" SDS | 10 | 2 |
| LTTI31 SIMPSON | 2-3/4" | 3-3/4" | 31" | 5/8" | 0.148 x 1-1/2" | 18 | 2 |

**Simpson Strong-Tie HDQ/HHDQ Series** (Heavy-Duty with SDS):

| Model | Width | Depth | Height | Rod Ø | Fastener (Full) | Qty (Full) | Qty (Tacked) |
|-------|-------|-------|--------|-------|-----------------|------------|--------------|
| HDQ8-SDS3 SIMPSON | 2-1/2" | 2-7/8" | 14" | 7/8" | 0.250 x 3" SDS | 20 | 2 |
| HHDQ11-SDS2.5 SIMPSON | 3-1/2" | 3" | 15-1/8" | 7/8" | 0.250 x 2-1/2" SDS | 24 | 2 |
| HHDQ14-SDS2.5 SIMPSON | 3-1/2" | 3" | 18-3/4" | 7/8" | 0.250 x 2-1/2" SDS | 30 | 2 |

**Simpson Strong-Tie DTT Series** (Deck Tension Ties):

| Model | Width | Depth | Height | Rod Ø | Fastener (Full) | Qty (Full) | Qty (Tacked) |
|-------|-------|-------|--------|-------|-----------------|------------|--------------|
| DTT1Z SIMPSON | 1-7/16" | 1-1/2" | 7-1/8" | 1/2" | 0.148 x 1-1/2" | 6 | 2 |
| DTT2Z SIMPSON | 1-5/8" | 3-1/4" | 6-15/16" | 1/2" | 0.250 x 1-1/2" SDS | 8 | 2 |
| DTT2Z-SDS2.5 SIMPSON | 1-5/8" | 3-1/4" | 6-15/16" | 1/2" | 0.250 x 2-1/2" SDS | 8 | 2 |
| DTT2Z NAIL SIMPSON | 1-5/8" | 3-1/4" | 6-15/16" | 1/2" | 0.148 x 1-1/2" | 8 | 2 |
| DTT2Z SDS SIMPSON | 1-5/8" | 3-1/4" | 6-15/16" | 1/2" | 0.250 x 2-1/2" SDS | 8 | 2 |

**Simpson Strong-Tie HDU Series** (Heavy-Duty Uplift with 1" Rod):

| Model | Width | Depth | Height | Rod Ø | Fastener (Full) | Qty (Full) | Qty (Tacked) |
|-------|-------|-------|--------|-------|-----------------|------------|--------------|
| HDU2-SDS2.5 SIMPSON | 3-1/4" | 3" | 8-11/16" | 1" | 0.250 x 2-1/2" SDS | 6 | 2 |
| HDU4-SDS2.5 SIMPSON | 3-1/4" | 3" | 10-15/16" | 1" | 0.250 x 2-1/2" SDS | 10 | 2 |
| HDU5-SDS2.5 SIMPSON | 3-1/4" | 3" | 13-3/16" | 1" | 0.250 x 2-1/2" SDS | 14 | 2 |
| HDU8-SDS2.5 SIMPSON | 3-1/2" | 3" | 16-5/8" | 1" | 0.250 x 2-1/2" SDS | 20 | 2 |
| HDU11-SDS2.5 SIMPSON | 3-1/2" | 3" | 22-1/4" | 1" | 0.250 x 2-1/2" SDS | 30 | 2 |
| HDU14-SDS2.5 SIMPSON | 3-1/2" | 3" | 25-11/16" | 1" | 0.250 x 2-1/2" SDS | 36 | 2 |

**Simpson Strong-Tie Concrete-Embedded Straps**:

| Model | Width | Depth | Height | Rod Ø | Fastener (Full) | Qty (Full) | Notes |
|-------|-------|-------|--------|-------|-----------------|------------|-------|
| LSTHD8 SIMPSON | 1/4" | 2-3/4" | 18-5/8" | N/A | 0.148 x 3-1/4" | 0 | Cast into concrete, no anchor rod |
| STHD10 SIMPSON | 1/4" | 2-3/4" | 24-5/8" | N/A | 0.148 x 3-1/4" | 0 | Cast into concrete, no anchor rod |
| STHD14 SIMPSON | 1/4" | 2-3/4" | 26-1/8" | N/A | 0.148 x 3-1/4" | 0 | Cast into concrete, no anchor rod |

**Simpson Strong-Tie HD Series** (Heavy-Duty Bolted):

| Model | Width | Depth | Height | Rod Ø | Fastener (Full) | Qty (Full) | Qty (Tacked) | Notes |
|-------|-------|-------|--------|-------|-----------------|------------|--------------|-------|
| HD12 | 4-1/2" | 3-1/2" | 20-5/16" | 1" | 1.0 x X" Bolt | 4 | 2 | Tapered profile, 4 bolt holes |
| HD19 | 4-1/2" | 3-1/2" | 24-1/2" | 1" | 1.0 x X" Bolt | 5 | 2 | Tapered profile, 5 bolt holes |

**USP Models**:

| Model | Width | Depth | Height | Rod Ø | Fastener (Full) | Qty (Full) | Qty (Tacked) |
|-------|-------|-------|--------|-------|-----------------|------------|--------------|
| DTB-TZ USP | 2-1/4" | 1-13/16" | 6" | 1/2" | WS15-EXT | 8 | 2 |
| HTT16 USP | 2" | 2-1/2" | 15-5/8" | 5/8" | 0.148 x 3" | 18 | 2 |
| HTT45 USP | 2" | 2-1/2" | 16" | 5/8" | 0.148 x 3" | 26 | 2 |
| HTT45 SDS USP | 2" | 2-1/2" | 16" | 5/8" | 0.131 x 3" | 26 | 2 |

**Model Selection Guidelines:**
- **Structural capacity**: Match model to engineer's shear wall schedule (kips or kN uplift capacity)
- **Rod diameter compatibility**: Ensure foundation anchor bolt matches hold-down rod hole (5/8", 7/8", 1")
- **Physical clearances**: Check connector width and depth fit within stud pack and wall thickness
- **Fastener preference**: Choose nail vs. SDS variants based on shop equipment and project specifications
- **Installation method**: Select appropriate model for shop vs. field installation workflow

### Side to Place Connector
| Property | Details |
|----------|---------|
| Display Name | Side to place connector |
| Type | String (dropdown) |
| Options | Bottom Left, Bottom Right, Top Left, Top Right |
| Default | Bottom Left |
| Description | Controls which corner of the stud pack the hold-down is placed at, and which direction it faces. "Bottom" places the base at the wall bottom plate; "Top" flips it for top-of-wall applications. "Left" and "Right" control which side of the stud pack the connector body extends toward. |

**Detailed Orientation Behavior:**
- **Bottom Left**: Standard left-end shear wall connection. Connector base at bottom plate, body extends left from stud pack centerline.
- **Bottom Right**: Standard right-end shear wall connection. Connector base at bottom plate, body extends right from stud pack centerline.
- **Top Left**: Upper-story left-end connection. Connector base at top plate (inverted), body extends left. Used in continuous rod systems.
- **Top Right**: Upper-story right-end connection. Connector base at top plate (inverted), body extends right. Used in continuous rod systems.

**Coordinate System Impact:**
The side selection affects the offset vector (`vOff`) and up vector (`vUp`) used in the 3D geometry calculation:
- Left sides: `vOff *= -1` (reverses offset direction)
- Top sides: `vUp *= -1` (inverts vertical direction)
- The Z-axis (`vZ`) is calculated as `vOff.crossProduct(vUp)` to maintain right-handed coordinate system

**Special Handling for Concrete-Embedded Straps:**
For LTTI31, LSTHD8, STHD10, and STHD14 models, the offset vector is changed from `el.vecX()` to `el.vecZ()` (wall thickness direction) because these straps orient perpendicular to standard hold-downs.

### Drill Plates
| Property | Details |
|----------|---------|
| Display Name | Drill Plates |
| Type | String (Yes/No) |
| Options | Yes, No |
| Default | Yes |
| Description | When set to Yes, the associated GE_HDWR_WALL_ANCHOR script will drill through the top and bottom plates for the anchor rod. This property is shared with the anchor script for coordination. |

**Coordination Mechanism:**
This property name is intentionally identical between the hold-down and anchor scripts. When the hold-down creates an anchor instance, the anchor script reads this property from the hold-down instance to determine whether to drill the plates.

**Use Cases:**
- **Yes**: Standard configuration. Anchor rod drills through plates for foundation connection.
- **No**: Special detailing where plates are not drilled (e.g., pocket bolt, plate already pre-drilled, anchor rod installed after wall erection).

### Stretch Beams
| Property | Details |
|----------|---------|
| Display Name | Stretch beams |
| Type | String (Yes/No) |
| Options | Yes, No |
| Default | Yes |
| Description | During element construction, stretches the vertical beams in the hold-down stud pack to meet the generated top and bottom plates. The script searches for the nearest plate beam (top plate, bottom plate, or angled top plate) in each direction along the stud axis and uses dynamic stretching to connect the stud end to that plate. |

**Stretching Logic:**
For each vertical beam in the hold-down stud pack, the script:
1. Filters out the hold-down beams from the element's beam list
2. Searches in both directions (up and down) along the beam axis
3. Finds the nearest plate beam using `filterBeamsHalfLineIntersectSort()`
4. Applies beam type-specific stretching rules:
   - **Regular studs**: Stretch to both top and bottom plates
   - **Supporting beams**: Stretch only to bottom plates (do not extend to top)
   - **Jack studs under openings**: Stretch only to bottom plates
   - **Jack studs over openings**: Stretch only to top plates
5. Uses `stretchDynamicTo()` to maintain dynamic link between stud and plate

**Recognized Plate Types:**
- `_kSFTopPlate` - Standard horizontal top plate
- `_kSFBottomPlate` - Standard horizontal bottom plate
- `_kSFAngledTPLeft` - Angled top plate (left side of gable/hip)
- `_kSFAngledTPRight` - Angled top plate (right side of gable/hip)

**Benefits:**
- Eliminates manual stretching of hold-down studs
- Maintains correct stud length when wall height changes
- Handles complex roof profiles (angled top plates) automatically
- Ensures proper bearing at top and bottom connections

**When to Disable:**
- Pre-fabricated stud packs with fixed length
- Custom stud height requirements (e.g., raised bottom plate details)
- Manual control over stud endpoints required

### Erase Intersecting Beams
| Property | Details |
|----------|---------|
| Display Name | Erase intersecting beams |
| Type | String (Yes/No) |
| Options | Yes, No |
| Default | Yes |
| Description | During element construction, erases any automatically generated studs that physically intersect with the hold-down stud pack beams. The check uses a slightly shortened body (0.5 inch inset on each end) to avoid false positives at beam-to-plate junctions. Top plates and bottom plates are never erased, only regular studs. |

**Intersection Detection:**
For each beam in the hold-down stud pack:
1. Creates a shortened body: `Body(ptCen, vecX, vecY, vecZ, dL-2*dShorten, dW, dH)` where `dShorten = 0.5"`
2. Filters element beams to find intersections: `filterGenBeamsIntersect()`
3. Checks beam type of each intersecting beam
4. Preserves plates: Does not erase top plates, bottom plates, or angled top plates
5. Erases regular studs that conflict

**Why 0.5" Inset?**
The inset prevents false positives at the top and bottom junctions where the hold-down stud connects to plates. Without this inset, the plate beams themselves would be detected as "intersecting" and the script would attempt to erase them (but the plate check prevents this).

**Benefits:**
- Prevents doubled studs at hold-down locations after stud distribution runs
- Cleans up automatically generated studs that conflict with manually placed hold-down assemblies
- Reduces post-generation cleanup work

**Error Reporting:**
If the script detects an intersection with a plate beam, it reports: `"Element [number] of type [code] has intersecting beams."` but does not erase the plate.

**When to Disable:**
- Manual control over all stud placement required
- Complex framing where automatic deletion may remove intentional studs
- Debugging stud distribution issues

### Fasteners Type
| Property | Details |
|----------|---------|
| Display Name | Fasteners Type |
| Type | String (dropdown) |
| Default | Auto-set based on connector type and installation option |
| Description | The nail or screw type used to attach the hold-down to the stud. This value is automatically populated when you change the Hold Down Type or Installation Options. You can override it manually for non-standard fastener schedules. |

**Available Fastener Types:**

| Fastener | Diameter | Length | Type | Typical Use |
|----------|----------|--------|------|-------------|
| 0.148 x 1 1/2" | 0.148" | 1-1/2" | Common nail (10d) | Standard hold-downs, thinner stud packs |
| 0.148 x 3" | 0.148" | 3" | Common nail (16d) | Thicker stud packs, longer penetration |
| 0.148 x 3 1/4" | 0.148" | 3-1/4" | Common nail | Extra-long penetration, concrete straps |
| 0.131 x 3" | 0.131" | 3" | Common nail | USP-specified fastener |
| 0.162 x 2 1/2" | 0.162" | 2-1/2" | Sinker nail | Alternative fastener |
| 0.250 x 1 1/2" SDS | 0.250" | 1-1/2" | Simpson SDS screw | Short screw, compact hold-downs |
| 0.250 x 2 1/2" SDS | 0.250" | 2-1/2" | Simpson SDS screw | Standard SDS, most HDU series |
| 0.250 x 3" SDS | 0.250" | 3" | Simpson SDS screw | Heavy-duty, HDQ series |
| #10 x 2 1/2" SD | #10 | 2-1/2" | Strong-Drive screw | HTT5KT model |
| WS15-EXT | Proprietary | Varies | USP specialty screw | USP DTB-TZ model |
| 1.0 x X" Bolt | 1" | Variable | Through-bolt | HD12/HD19 bolted connections |

**Automatic Selection Logic:**
```
if (Installation Options == "Fully Installed") {
    Fasteners Type = arFastenerType[iFastenerTypeFull[connector_index]]
} else if (Installation Options == "Tacked") {
    Fasteners Type = arFastenerType[iFastenerTypeTacked[connector_index]]
} else { // Field Installed
    Fasteners Type = (not set, quantity = 0)
}
```

**Manual Override:**
If you manually change this property, the script will add a separate hardware component ("Nail") to the BOM with your custom fastener specification. The hold-down component will include notes indicating the custom fastener schedule.

### Fasteners Quantity
| Property | Details |
|----------|---------|
| Display Name | Fasteners Quantity |
| Type | Integer |
| Default | 0 (auto-set based on connector type and installation option) |
| Description | The number of fasteners for the selected installation option. Automatically set when Hold Down Type or Installation Options change. Can be overridden manually. For "Fully Installed," this reflects the full manufacturer specification. For "Tacked," this is typically 2. For "Field Installed," this is 0. |

**Automatic Quantity Selection:**
- **Fully Installed**: Ranges from 4 to 36 fasteners depending on connector model
  - Small models (DTT1Z): 6 fasteners
  - Medium models (HTT4, LTT19, HDU2): 8-18 fasteners
  - Large models (HTT5, HDU8): 20-26 fasteners
  - Extra-large models (HDU11, HDU14): 30-36 fasteners
- **Tacked**: Typically 2 fasteners for all models (temporary erection hold)
- **Field Installed**: 0 fasteners (all installation on-site)

**Manual Override Implications:**
When you manually change the fastener quantity:
1. The script detects that the value differs from the manufacturer default
2. A separate "Nail" hardware component is added to the BOM
3. The hold-down component notes include: `", Fasteners: (qty) type"`
4. The `HOLDDOWN_FASTENERS` map key is set for downstream scripts

**Quality Control:**
Verify that manual fastener quantities meet structural requirements. Reducing fastener count below manufacturer specifications may compromise structural performance.

### Installation Options
| Property | Details |
|----------|---------|
| Display Name | Installation Options |
| Type | String (dropdown) |
| Options | Fully Installed, Tacked, Field Installed |
| Default | Fully Installed |
| Description | Controls the fastener schedule for the hold-down. "Fully Installed" assigns the full manufacturer-specified fastener count and type. "Tacked" assigns a minimal fastener count (typically 2) for temporary erection hold. "Field Installed" sets fastener count to 0, meaning the connector ships loose or is installed entirely on site. |

**Detailed Option Descriptions:**

**Fully Installed:**
- Complete shop installation of the hold-down connector
- Full manufacturer-specified fastener count (6 to 36 depending on model)
- Manufacturer-specified fastener type (nails, SDS screws, or bolts)
- Hold-down is permanently attached to stud pack in fabrication shop
- Wall ships to site with connectors fully fastened
- Hardware component notes: "-Fully Installed, Fasteners: (qty) type"

**Tacked:**
- Temporary shop installation with minimal fasteners
- Typically 2 fasteners (enough to hold connector during shipping and handling)
- Fastener type may differ from full installation (usually lighter-duty fastener)
- Final fastening occurs during wall erection on-site
- Reduces shop labor while maintaining connector positioning
- Hardware component notes: "-Tacked, Fasteners: (qty) type"

**Field Installed:**
- Zero fasteners in shop
- Connector included in hardware schedule but not pre-attached
- Connector ships separately (loose hardware)
- All installation work occurs on-site after wall positioning
- Provides maximum field flexibility for connector placement
- Hardware component notes: "-Field Installed"

**Impact on BOM and Scheduling:**
All three options include the hold-down connector itself in the hardware BOM (quantity = 1). The difference is in the fastener scheduling:
- Fully Installed: Full fastener count appears in shop installation schedule
- Tacked: Minimal fastener count for shop, remaining fasteners in field schedule
- Field Installed: All fasteners in field installation schedule

### Color Index for My Beams
| Property | Details |
|----------|---------|
| Display Name | Color index for my beams |
| Type | Integer |
| Range | -1 to 255 (AutoCAD Color Index) |
| Default | 3 (Green) |
| Description | Sets the AutoCAD color index applied to all beams in the hold-down stud pack. Use standard ACI values (1=Red, 2=Yellow, 3=Green, etc.). A value of -1 means the beams inherit the color of the TSL instance itself. This color helps visually distinguish hold-down studs from regular wall studs in the model. |

**Standard ACI Color Values:**
| Index | Color | Common Use |
|-------|-------|------------|
| 1 | Red | Critical structural members |
| 2 | Yellow | Headers, beams requiring attention |
| 3 | Green | Hold-downs (default), engineered posts |
| 4 | Cyan | Temporary or review items |
| 5 | Blue | Reference geometry |
| 6 | Magenta | Special details |
| 7 | White/Black | Standard framing (depends on background) |
| -1 | ByLayer/ByBlock | Inherit from TSL instance |

**Benefits of Color Coding:**
- **Visual identification**: Quickly locate hold-down posts in complex framing models
- **Quality control**: Verify hold-down placement during design review
- **Coordination**: Communicate special framing to other trades
- **Shop drawings**: Color-coded elements appear distinct in fabrication drawings

**Color Application:**
The script calls `_Beam[b].setColor(pColor)` for each beam in the hold-down stud pack. The color persists with the beam and appears in all views.

### Vertical Offset
| Property | Details |
|----------|---------|
| Display Name | Vertical Offset |
| Type | Double (length) |
| Unit | Current drawing units (inches) |
| Default | 0 |
| Description | Shifts the hold-down connector vertically (along the wall Y-axis / stud direction) from its default position at the base of the stud pack. Positive values move the connector upward; negative values move it downward. |

**Default Position:**
Without vertical offset, the hold-down base is positioned at:
- **Bottom-side placement**: The bottom extent of the stud pack (typically at the bottom plate)
- **Top-side placement**: The top extent of the stud pack (typically at the top plate)

**Offset Application:**
```c
_Pt0 = 0.5*(ptLeft+ptRight) + pVerticalOffset*vUp + pLateralOffset * el.vecZ();
```
The offset is applied along the wall's up vector (`vUp` = `el.vecY()`).

**Common Use Cases:**
- **Raised foundation detail**: Offset upward to clear foundation step or ledge (e.g., +3")
- **Recessed bottom plate**: Offset downward to align with recessed plate detail (e.g., -1")
- **Continuous rod alignment**: Adjust vertical position to align with multi-story rod system
- **Plumbing clearance**: Offset to avoid drain pipes or floor system components
- **Custom detailing**: Match architect's specific hold-down location

**Interaction with Other Features:**
- Anchor rod position updates automatically with vertical offset
- Beam stretching is not affected (studs still stretch to plates)
- Display text and labels move with the offset hold-down

### Lateral Offset
| Property | Details |
|----------|---------|
| Display Name | Lateral Offset |
| Type | Double (length) |
| Unit | Current drawing units (inches) |
| Default | 0 |
| Description | Shifts the hold-down connector laterally (along the wall Z-axis / wall thickness direction) from its default position at the center of the stud pack thickness. Positive values move toward the exterior face; negative values move toward the interior face. |

**Default Position:**
Without lateral offset, the hold-down is centered on the stud pack thickness (projected to the wall's Z-axis centerplane).

**Offset Direction:**
- **Positive values**: Move toward exterior face (outside of building)
- **Negative values**: Move toward interior face (inside of building)
- Direction is relative to `el.vecZ()` (wall thickness vector)

**Common Use Cases:**
- **Exterior sheathing alignment**: Offset to align hold-down face with specific sheathing layer
- **Interior finish clearance**: Offset to avoid conflicts with drywall, paneling, or interior trim
- **Siding detail coordination**: Position hold-down flush with exterior siding plane
- **Multi-layer wall systems**: Align with structural vs. non-structural layers in complex wall assemblies
- **Asymmetric stud packs**: Center hold-down on specific stud when pack includes varied stud sizes

**Typical Offset Values:**
- 2x4 wall (3-1/2" thick): ±0.5" to ±1" for layer alignment
- 2x6 wall (5-1/2" thick): ±1" to ±2" for significant layer shifts
- Doubled stud pack: Offset to center on one stud vs. the pair

**Visual Impact:**
The lateral offset affects both the 3D connector body and the rod hole position. Verify that the offset does not create conflicts with adjacent framing or finishes.

## Right-Click Context Menu

The following commands are available when you right-click on a placed GE_HDWR_WALL_HOLD_DOWN instance.

### Relink to Post
| Menu Item | Details |
|-----------|---------|
| Command | Relink to post |
| Purpose | Re-associates the hold-down with a different stud pack |
| Prompt | `select a vertical stud pack` |
| When to Use | Use this command when the original stud pack has been deleted or when you need to move the hold-down to a different set of studs. |

**Scenarios Requiring Relink:**

**Deleted Stud Pack:**
If the stud pack is erased and the hold-down loses its beam references, the script displays a warning message at the insertion point:
```
GE_HDWR_WALL_HOLD_DOWN must be relinked to stud pack
```
The hold-down remains in the drawing but is not functional until relinked.

**Stud Pack Replacement:**
When you replace studs (e.g., change from single to doubled stud pack), use Relink to update the hold-down association.

**Wall Regeneration:**
After major wall modifications that recreate beams, you may need to relink hold-downs to the new beam entities.

**Relink Procedure:**
1. Right-click the hold-down instance
2. Select "Relink to post" from context menu
3. At the `select a vertical stud pack` prompt, click on the new stud(s)
4. The hold-down updates its beam references and recalculates geometry
5. The hold-down remains in its current position and retains all property values

**Internal Operation:**
The command clears the `_Beam` array (`_Beam.setLength(0)`) and prompts for a new selection using `PrEntity`. The new beams are validated and assigned to `_Beam`.

### Add Anchor
| Menu Item | Details |
|-----------|---------|
| Command | Add Anchor |
| Purpose | Creates a GE_HDWR_WALL_ANCHOR child instance at the rod hole location |
| Script Created | GE_HDWR_WALL_ANCHOR |
| When to Use | After placing a hold-down, use this command to automatically insert an anchor bolt or rod that passes through the bottom plate (or top plate for top-of-wall placement). |

**Automatic Coordination:**
When you execute "Add Anchor", the hold-down script:
1. Identifies the anchor rod location: `arPtSides[1] + vOff*arDx[n]/2` (center of hold-down rod hole)
2. Retrieves the rod diameter from the hold-down specification: `arDRod[n]`
3. Prepares a Map object with connection data:
   - `"HoldDown"` → Entity reference to this hold-down instance
   - `"dRodInsert"` → Rod diameter (5/8", 7/8", 1")
4. Calls `TslInst.dbCreate("GE_HDWR_WALL_ANCHOR", ...)` to create the anchor instance
5. Stores the anchor entity reference in the hold-down's Map: `_Map.setEntity("ANCHOR", tsl)`

**Data Passed to Anchor Script:**
- `lstEnts[0]` → Wall element entity
- `lstEnts[1]` → This hold-down TSL instance (parent)
- `lstPoints[0]` → Anchor insertion point (rod hole centerline)
- `mpHD.setEntity("HoldDown", _ThisInst)` → Parent hold-down reference
- `mpHD.setDouble("dRodInsert", arDRod[n])` → Rod diameter

**Anchor Script Behavior:**
The GE_HDWR_WALL_ANCHOR script receives this data and:
- Positions the anchor rod at the specified point
- Sets the rod diameter to match the hold-down
- Reads the "Drill Plates" property from the hold-down instance
- Creates rod geometry extending through the plate(s)
- Tracks its parent hold-down for coordinated updates

**Availability:**
This command is NOT available for concrete-embedded strap models (LSTHD8, STHD10, STHD14) because these connectors do not use through-bolts. The script checks `if(arIShape[n]!=5)` to conditionally add the context menu command.

**Automatic Execution:**
The "Add Anchor" command is automatically executed once when the hold-down is first created (`_bOnDbCreated && iState==0`). This ensures new hold-downs have anchor rods by default. You can release and remove the anchor if not needed.

### Release Anchor
| Menu Item | Details |
|-----------|---------|
| Command | Release Anchor |
| Purpose | Detaches the associated GE_HDWR_WALL_ANCHOR instance from this hold-down |
| When to Use | Use this command to disconnect the anchor rod from the hold-down. The anchor instance remains in the drawing but is no longer linked to this hold-down. |

**Release Process:**
1. Checks if an anchor entity reference exists: `if(_Map.hasEntity("ANCHOR"))`
2. Retrieves the anchor entity: `Entity ent = _Map.getEntity("ANCHOR")`
3. Casts to TslInst: `TslInst tslRod = (TslInst)ent`
4. Retrieves the anchor's Map: `Map mpRod = tslRod.map()`
5. Removes the hold-down reference from the anchor: `mpRod.removeAt("HoldDown", 0)`
6. Updates the anchor's Map: `tslRod.setMap(mpRod)`
7. Removes the anchor reference from the hold-down: `_Map.removeAt("ANCHOR", 0)`

**Post-Release State:**
- The anchor rod remains in the drawing as an independent object
- The anchor no longer updates when the hold-down changes
- The hold-down can create a new anchor with "Add Anchor" command
- The released anchor can be selected and modified independently

**Use Cases:**
- **Replace anchor type**: Release, delete, then add a different anchor configuration
- **Manual anchor positioning**: Release the auto-positioned anchor and manually place a new one
- **Anchor not needed**: Release and delete the anchor if the hold-down does not require a through-rod
- **Change rod diameter**: Release, modify the hold-down type (which changes rod diameter), then add a new anchor

**Cleanup for Concrete Straps:**
For concrete-embedded strap models (LSTHD8, STHD10, STHD14), if an anchor entity exists (perhaps from a previous hold-down type), the script automatically erases it: `ent.dbErase()` and removes the reference.

## Hardware Group and BOM Export

### Hardware Group Assignment

The script automatically assigns the hold-down instance to a hierarchical deliverable group structure for organization and BOM extraction:

**Group Hierarchy:**
```
X - Hardware
└── X-Hold Down Connectors
    └── [Connector Model Name]
        └── [This hold-down instance]
```

**Level Definitions:**
- **Level 1**: `X - Hardware` (Top-level hardware category)
- **Level 2**: `X-Hold Down Connectors` (Hold-down sub-category)
- **Level 3**: Connector model name (e.g., `HDU8-SDS2.5 SIMPSON`, `HTT5 SIMPSON`)

**Group Creation:**
```c
String strPart1 = "X - Hardware";
String strPart2 = "X-Hold Down Connectors";
String strPart3 = strConnector; // Current connector model
Group gr(strPart1, strPart2, strPart3);
gr.dbCreate();
gr.setBIsDeliverableContainer(TRUE);
gr.addEntity(_ThisInst, TRUE);
```

**Deliverable Container Flag:**
The `setBIsDeliverableContainer(TRUE)` setting marks this group as a deliverable container, indicating that all entities within this group represent shippable hardware components.

**Element Group Assignment:**
If the wall element is valid, the hold-down is also assigned to the element's group with:
- Layer priority: 0 (standard priority)
- Axis: 'Z' (wall thickness direction)

This dual group assignment allows the hold-down to appear in both hardware schedules (via hardware group) and element-specific reports (via element group).

### Hardware Component Export

The script registers hardware components using the `HardWrComp` system for BOM extraction and procurement scheduling.

**Primary Hold-Down Component:**
```c
HardWrComp hwr;
hwr.setName("Holddown");
hwr.setBVisualize(false);
hwr.setDescription("Wall Holdown");
hwr.setManufacturer(strConnector.makeUpper().find("USP", 0) > -1 ? "USP" : "SIMPSON");
hwr.setArticleNumber(String(strConnector));
hwr.setModel(String(strConnector));
hwr.setQuantity(1);
hwr.setCountType("Amount");
hwr.setNotes("-" + String(strInstallation) + " ");
hwr.setGroup(stLevel);
```

**Component Fields:**
- **Name**: "Holddown" (component type identifier)
- **Description**: "Wall Holdown" (readable description)
- **Manufacturer**: Automatically detected from connector name
  - If connector name contains "USP" → Manufacturer = "USP"
  - Otherwise → Manufacturer = "SIMPSON"
- **Article Number**: Full connector model (e.g., "HDU8-SDS2.5 SIMPSON")
- **Model**: Full connector model (same as article number)
- **Quantity**: 1 (one hold-down connector per instance)
- **Count Type**: "Amount" (quantity-based, not length-based)
- **Notes**: Installation mode and fastener schedule
- **Group**: Element level/story (from element group name)

**Fastener Component (Conditional):**
If the user has overridden the default fastener type or quantity, an additional component is added:

```c
if (iAddFasteners) {
    HardWrComp hwr1;
    hwr1.setName("Nail");
    hwr1.setDescription("Nail");
    hwr1.setArticleNumber(String(pFastenersType));
    hwr1.setModel(String(pFastenersType));
    hwr1.setQuantity(int(iFastenersQty));
    hwr1.setGroup(stLevel);

    hwr.setNotes(hwr.notes() + ", Fasteners: (" + iFastenersQty + ") " + pFastenersType);
    arHwr.append(hwr1);
}
```

**Fastener Component Trigger:**
The fastener component is added only when:
```c
iAddFasteners = true if (
    strInstallation == "Fully Installed" AND (
        pFastenersType != strFastenerChoice OR
        iFastenersQty != iFastenerChoice
    )
)
```

This means custom fastener schedules generate a separate line item in the BOM.

**Notes Field Examples:**
- Fully Installed (default fasteners): `"-Fully Installed "`
- Fully Installed (custom fasteners): `"-Fully Installed , Fasteners: (20) 0.250 x 3 SDS"`
- Tacked: `"-Tacked "`
- Field Installed: `"-Field Installed "`

### DXA Export

The script exports data for DXA (Data Extraction API) systems used by downstream reporting and scheduling tools.

**DXA Fields:**
```c
exportToDxi(TRUE);
model(strConnector);
material("Hold Down");
dxaout("Element", el.number());
dxaout("TH-Item", strConnector);
```

**Field Definitions:**
- **Model**: Connector model name (e.g., "HDU8-SDS2.5 SIMPSON")
- **Material**: Fixed value "Hold Down" for filtering and categorization
- **Element**: Wall element number (e.g., "W101", "W-SHEAR-01")
- **TH-Item**: Connector model name (same as Model field)

**DXA Map Object:**
The script also creates a Map object for DXA data:
```c
Map mapDxaOut;
mapDxaOut.appendInt(strConnector, 1);
_Map.setMap("MapDxaOut", mapDxaOut);
```
This map stores the connector name with a count of 1 for aggregation in DXA extraction queries.

### Hold-Down Data Map

For consumption by annotation scripts, shop drawing generators, and custom reporting tools, the script exports a structured data map:

```c
Map mpHDOut;
mpHDOut.setString("stTypeDescription", String(strConnector));
mpHDOut.setString("stConnector", String(strConnector));
mpHDOut.setDouble("dSizeXEl", arDx[n]);
mpHDOut.setDouble("dSizeYEl", arDy[n]);
mpHDOut.setDouble("dSizeZEl", arDz[n]);
_Map.setMap("mpHoldDownData", mpHDOut);
```

**Map Fields:**
- **stTypeDescription**: Connector full name
- **stConnector**: Connector model code
- **dSizeXEl**: Connector width (in element X-axis)
- **dSizeYEl**: Connector height (in element Y-axis)
- **dSizeZEl**: Connector depth (in element Z-axis)

**Anchor Point Map:**
```c
_Map.setPoint3d("ANCHOR_POINT", arPtSides[1] + vOff*arDDrillCL[n]);
```
Stores the 3D location of the anchor rod centerline for downstream scripts.

**Fastener Schedule Map:**
```c
_Map.setString("HOLDDOWN_FASTENERS", "(" + iFastenersQty + ")" + pFastenersType);
```
Stores the fastener schedule string (e.g., "(20)0.250 x 2 1/2 SDS") for annotation scripts.

## 3D Geometry Generation

The script generates accurate 3D solid models of hold-down connectors using parametric geometry based on manufacturer specifications. Each connector model uses a specific shape type with associated dimensions.

### Shape Type Classification

The script uses six distinct shape algorithms (`arIShape[n]`) to model different connector families:

**Shape 0/1** - Standard Rectangular Vertical Flange:
- Models: HTT5, HTT5KT, HTT16, HTT45, HDU series
- Components: Base plate, vertical flange, side gussets, rod hole
- Profile: Rectangular vertical plate with side flanges at 6" height

**Shape 2** - Wide-Base Bracket:
- Models: HDQ8-SDS3, HHDQ11-SDS2.5, HHDQ14-SDS2.5, DTB-TZ USP
- Components: Full-height rectangular side profile, base plate, rod hole
- Profile: Side plates extend full connector height (no separate gusset)

**Shape 3** - DTT2Z Complex Profile:
- Models: DTT2Z, DTT2Z-SDS2.5, DTT2Z variants
- Components: Custom polyline profile with punched nail holes, mirrored geometry
- Profile: Irregular outline with multiple vertices, symmetrical about centerplane
- Nail holes: Four punched holes in specific locations

**Shape 4** - Formed Lip Profile:
- Models: LTT19, LTT20B, LTTI31, DTT1Z
- Components: Vertical flange with formed lip at top, side gussets, rod hole
- Profile: L-shaped upper edge (0.25" lip extending 0.5" at top)

**Shape 5** - Concrete-Embedded Strap:
- Models: LSTHD8, STHD10, STHD14
- Components: Angled base extension, vertical strap, return lip
- Profile: Strap extends at angle below wall into foundation, return lip at bottom
- Orientation: Extends along wall thickness (Z-axis) rather than face (X-axis)

**Shape 6** - Tapered Bolted Profile:
- Models: HD12, HD19
- Components: Tapered side flanges, triangular base extension, evenly spaced bolt holes
- Profile: Side flanges taper from full width at base to 20% width at head
- Base extension: Triangular profile extending below connector body

### Geometry Construction Process

**1. Base Plate (All Shapes):**
```c
Body bdBase(arPtSides[1], vOff, vZ, vUp, arDx[n], arDz[n], dThick*2, 1, 0, 1);
```
Creates a rectangular solid representing the base mounting plate:
- Position: At the bottom/top of stud pack (`arPtSides[1]`)
- Orientation: Offset direction (`vOff`), Z-axis (`vZ`), Up direction (`vUp`)
- Dimensions: Width × Depth × Thickness = `arDx[n]` × `arDz[n]` × 0.25"

**Special Base for Shape 5 (Concrete Straps):**
```c
Vector3d vBase = -vOff - (2 * vUp); // Diagonal into foundation
vBase.normalize();
bdBase = Body(arPtSides[1] + vOff * arDx[n], vBase, vZ, vBase.crossProduct(vZ),
              dExtra1[n], arDz[n], dThick*2, 1, 0, 1);
```
The base extends diagonally (45° downward and outward) into the foundation, with a return lip.

**2. Vertical Flange (Shapes 0, 1, 4, 5):**
```c
Body bdUp(arPtSides[1], vOff, vZ, vUp, dThick, arDz[n], arDy[n], 1, 0, 1);
```
Creates the main vertical plate extending upward from the base:
- Thickness: 0.125" (standard metal thickness)
- Depth: Connector depth (`arDz[n]`)
- Height: Connector height (`arDy[n]`)

**Shape 4 Modification (LTT Series Lip):**
A 0.25" formed lip is added at the top by creating a separate body and adding it to the main vertical flange.

**Shape 3 (DTT2Z) Profile Extrusion:**
```c
PLine plDtt2(l1, l2, l3, l4, l5, l6, l7); // Custom polyline
plDtt2.close();
Body bdUp = Body(plDtt2, vOff*dThick); // Extrude profile

// Mirror geometry for symmetry
Body bdUp2 = bdUp;
CoordSys csRo.setToRotation(180, vUp, Point3d(arPtSides[1] + vOff*dThick/2));
bdUp2.transformBy(csRo);
bdUp += bdUp2; // Boolean union
```

**Shape 6 (HD12/HD19) Tapered Profile:**
```c
PLine plUp;
Point3d pt = arPtSides[1] - vZ * arDz[n]*.5;
plUp.addVertex(pt); // Bottom left
pt += vZ * arDz[n];
plUp.addVertex(pt); // Bottom right
pt += vUp * dDHupL * dDHSideLFactor; // Up 85% of height
plUp.addVertex(pt);
pt += vUp * dDHupL * (1-dDHSideLFactor) - vZ *arDz[n] * dDHHeadLFactor; // Taper
plUp.addVertex(pt);
pt += -vZ * (arDz[n] - arDz[n] * dDHHeadLFactor * 2); // Top
plUp.addVertex(pt);
pt += -vUp * dDHupL * (1-dDHSideLFactor) - vZ *arDz[n] * dDHHeadLFactor; // Taper
plUp.addVertex(pt);
plUp.close();
bdUp = Body(plUp, vOff*dThick); // Extrude tapered profile
```

**3. Side Gussets (Most Shapes):**
```c
PLine plSide(arPtSides[1], arPtSides[1] + vOff*arDx[n]);
plSide.addVertex(arPtSides[1] + dSideL*vUp); // Height of gusset
plSide.close();
plSide.transformBy(vZ*(arDz[n]/2)); // Offset to one side

Body bdSide(plSide, vZ*(dThick+dExtrudeMore), 0);
bdConnector += bdSide;

// Mirror to other side
bdSide.transformBy(mir); // Mirror across centerplane
bdConnector += bdSide;
```

Side gussets provide lateral stiffness:
- Shape 0/1: Triangular gussets 6" high
- Shape 2: Full-height rectangular sides
- Shape 4: L-shaped profile extending 0.5" with extra depth
- Shape 6: Tapered sides as part of main profile

**4. Rod Hole Subtraction:**
```c
Body bdAnchor(arPtSides[1] + vOff*arDDrillCL[n] - vUp*dThick,
              arPtSides[1] + vOff*arDDrillCL[n] + vUp*dThick*4,
              arDRod[n]/2);
bdConnector -= bdAnchor; // Boolean subtraction
```

Creates a cylindrical hole for the anchor rod:
- Location: Offset from base by drill centerline distance (`arDDrillCL[n]`)
- Diameter: Rod diameter (`arDRod[n]` = 1/2", 5/8", 7/8", or 1")
- Height: Extends through connector body

**5. Fastener Holes (Most Shapes):**
```c
Body bdDrill;
Body bdD1(ptFastener - vOff * dThick, ptFastener + vOff * 2 * dThick, U(.125));
bdDrill += bdD1; // Center hole
bdD1.transformBy(-vZ * arDz[n] * 0.5); // Left hole
bdDrill += bdD1;
bdD1.transformBy(vUp * arDz[n] * 0.5); // Up-Left hole
bdDrill += bdD1;
bdD1.transformBy(vZ * arDz[n] * 0.5); // Up-Right hole
bdDrill += bdD1;

while (dGo < arDy[n]) {
    bdConnector -= bdDrill; // Subtract hole pattern
    bdDrill.transformBy(arDz[n] * vUp); // Move up
    dGo += U(arDz[n]);
}
```

Creates a repeating pattern of nail/screw holes:
- Hole diameter: 0.125" (standard fastener clearance)
- Pattern: Four holes (center, left, up-left, up-right)
- Spacing: Vertical increment equal to connector depth
- Termination: Stops at connector height

**Shape 6 (HD12/HD19) Bolt Holes:**
```c
int nHoles = dExtra2[n]; // 4 for HD12, 5 for HD19
double dDist = dDHupL / (nHoles + 1); // Even spacing
Point3d ptDrill = arPtSides[1];
for (int i = 0; i < nHoles; i++) {
    ptDrill += vUp * dDist;
    Body drill(ptDrill - vOff, ptDrill + vOff, U(0.5)); // 1/2" hole
    bdConnector -= drill;
}
```

Evenly spaced through-bolt holes along the vertical flange.

**6. Final Body Assembly:**
```c
bdConnector = bdBase + bdUp + bdSide + bdSide_mirrored - bdAnchor - bdDrill_pattern;
bdConnector.vis(2); // Visualize for debugging
dpMod.draw(bdConnector); // Display in main view
dpModLay.draw(bdConnector); // Display in hold-down representation
```

### Top View Display

In plan views (looking down Z-axis), the script draws simplified 2D representations:

**Rectangular Outline:**
```c
PLine plRecTop;
plRecTop.createRectangle(
    LineSeg(arPtSides[1] - vZ*arDz[n]/2, arPtSides[1] + vZ*arDz[n]/2 + vOff*arDx[n]),
    vZ, vOff
);
dpTop.draw(plRecTop);
```

**Rod Hole Circle:**
```c
PLine plCTop;
plCTop.createCircle(arPtSides[1] + vOff*arDDrillCL[n], vUp, arDRod[n]/2);
dpTop.draw(plCTop);
```

**Connector Label:**
```c
dpModLay.draw(arConnectors[n], _Pt0 + U(14)*el.vecZ(), vxText, _ZW.crossProduct(vxText), iFlagX, 0);
```
Text displays the connector model name (e.g., "HDU8-SDS2.5") next to the 3D geometry.

### Display Representations

**Main Model View:**
```c
Display dpMod(252);
dpMod.addHideDirection(_ZW); // Hide when viewing from top
dpMod.showInDxa(true); // Include in DXA export
```

**Hold-Down Representation:**
```c
Display dpModLay(252);
dpModLay.showInDispRep("HoldDown"); // Show only in HoldDown representation
```

**Top View:**
```c
Display dpTop(252);
dpTop.addViewDirection(_ZW); // Show when viewing from top
dpTop.addViewDirection(-_ZW); // Show when viewing from bottom
```

**DXA-Only Display:**
```c
Display dpDxa(1);
dpDxa.showInDxa(true);
dpDxa.textHeight(U(4));
dpDxa.showInDispRep("Bogus"); // Hidden from normal views
```

## Wall Element Integration

The hold-down script deeply integrates with the wall element construction process to ensure proper coordination between hardware and framing.

### Element Validation and Assignment

**Element Discovery from Beams:**
```c
for (int b=0; b<_Beam.length(); b++) {
    Element elTest = _Beam[b].element();
    if (!el.bIsValid()) el = elTest;
    else if (elTest.bIsValid()) {
        if (el != elTest) {
            reportNotice("\nBeams belong to different elements in GE_HDWR_WALL_HOLD_DOWN
                          \nCheck Panel\n       " + el.number() + "\n       " + elTest.number());
            eraseInstance();
        }
    }
}
```

**Validation Rule:**
All beams in the hold-down stud pack must belong to the same wall element. If beams from different elements are detected, the script reports an error with both element numbers and erases itself.

**Element Group Assignment:**
```c
assignToElementGroup(el, TRUE, 0, 'Z');
```
- **Second parameter (TRUE)**: Add to element group
- **Third parameter (0)**: Layer priority = 0 (standard)
- **Fourth parameter ('Z')**: Axis = Z (wall thickness direction)

**Beam Sorting by Position:**
The script sorts beams left-to-right along the wall X-axis for consistent processing:
```c
for (int b=0; b<_Beam.length(); b++) {
    double dDist = el.vecX().dotProduct(_Beam[b].ptCen() - el.ptOrg());
    int insert = 0;
    for (int i=0; i<arBmSort.length(); i++) {
        double dDist2 = el.vecX().dotProduct(arBmSort[i].ptCen() - el.ptOrg());
        if (dDist2 <= dDist) insert = i+1;
    }
    arBmSort.insertAt(insert, _Beam[b]);
}
```

### Wall Splitting Detection

When a wall element is split (e.g., at an opening or segment boundary), the script automatically determines which resulting wall segment contains the hold-down:

```c
if (_bOnElementListModified) {
    // Wall might have been split
    for (int i=_Element.length()-1; i>-1; i--) {
        ElementWall elW = (ElementWall)_Element[i];
        if (!elW.bIsValid()) {
            _Element.removeAt(i);
            continue;
        }
        Point3d arPt[] = {elW.ptStartOutline(), elW.ptEndOutline()};

        // Check if hold-down position falls between wall start and end
        if (elW.vecX().dotProduct(arPt[0] - _Pt0) *
            elW.vecX().dotProduct(arPt[1] - _Pt0) < 0) {
            _Element[0] = elW; // Keep this segment
            _Element.setLength(1);
            break;
        }
    }

    if (_Element.length() != 1) eraseInstance(); // Not in any segment

    // Reassign beams to correct element
    for (int b=0; b<_Beam.length(); b++)
        _Beam[b].assignToElementGroup(_Element[0], TRUE, 0, 'Z');
}
```

**Split Detection Logic:**
The dot product check determines if the hold-down position (`_Pt0`) falls between the wall start and end points:
- If `dotProduct(arPt[0] - _Pt0)` and `dotProduct(arPt[1] - _Pt0)` have opposite signs, the hold-down is between the endpoints
- The product of two opposite signs is negative, so the condition `< 0` is true
- If true, the hold-down belongs to this wall segment

**Cleanup on Split:**
If the hold-down does not fall within any resulting wall segment (e.g., split point is exactly at the hold-down location), the instance erases itself to prevent orphaned hardware.

### No-Stud Distribution Range

The hold-down marks a zone where the wall element's automatic stud distribution should not place studs:

```c
// Find leftmost extent of stud pack
Beam bmLeft = bmVertical[0];
double dSizeLeft = bmLeft.dD(vecXEl);
Point3d ptLeft = bmLeft.ptCen() - 0.5*dSizeLeft*vecXEl;

// Find rightmost extent of stud pack
Beam bmRight = bmVertical[bmVertical.length()-1];
double dSizeRight = bmRight.dD(vecXEl);
Point3d ptRight = bmRight.ptCen() + 0.5*dSizeRight*vecXEl;

// Set the no-distribution range
el.setRangeNoDistributionStud(ptLeft, ptRight);
```

**Purpose:**
Prevents the element's stud distribution algorithm from placing additional studs within the hold-down zone, which would create doubled studs and conflicts with the hold-down hardware.

**Range Calculation:**
- Left point: Center of leftmost vertical beam minus half its width
- Right point: Center of rightmost vertical beam plus half its width
- The range encompasses the entire footprint of the hold-down stud pack

### Sheet Cut Location Registration

For vertical beams that touch the structural sheathing zone (zone 1), the script registers cut points to allow sheathing scripts to create proper cutouts:

```c
// Filter beams that touch zone 1 (sheathing zone)
Beam bmTouchingZone1[0];
for (int b=0; b<bmVertical.length(); b++) {
    Beam bm = bmVertical[b];
    double dSizeBeam = bm.dD(vecZEl);
    double dDistToZone1 = vecZEl.dotProduct(ptOrgEl - bm.ptCen()) - 0.5*dSizeBeam;
    if (abs(dDistToZone1) < U(0.1)) {
        bmTouchingZone1.append(bm);
    }
}

// Register sheet cut locations
int nZone = 1;
for (int b=0; b<bmTouchingZone1.length(); b++) {
    el.setSheetCutLocation(nZone, bmTouchingZone1[b].ptCen());
}
```

**Zone 1 Detection:**
Zone 1 starts at the element origin plane (`ptOrgEl`). A beam touches zone 1 if its face is within 0.1" of this plane.

**Cut Location Effect:**
Sheathing distribution scripts (e.g., `HSB_W-SheetDistribution`) read these cut locations and create rectangular or circular cutouts around the hold-down connector to prevent sheathing from overlapping the hardware.

### Panhand Assignment

All beams in the hold-down stud pack receive the wall element's panhand (panel handling reference):

```c
for (int b=0; b<_Beam.length(); b++) {
    _Beam[b].setPanhand(el);
    _Beam[b].setColor(pColor);
    if (_Beam[b].module().length() > 1) bIsAlreadyModule++;
}
```

**Panhand Purpose:**
The panhand links beams to their parent element for:
- Element-level BOM reporting
- Shop drawing generation
- Panel nesting and layout
- Fabrication sequencing

**Module Detection:**
The script checks if beams already belong to a module (`module().length() > 1`). If all beams are already in a module, certain first-time setup operations are skipped to avoid conflicts with pre-existing module configurations.

## Advanced Features

### State Management

The script uses an internal state variable to control one-time operations:

```c
int iState = 0;
if (_Map.hasInt("State")) {
    iState = _Map.getInt("State");
}

// First-time operations
if (_bOnInsert || (_bOnDbCreated && iState==0)) {
    // Automatically add anchor rod
    // Erase conflicting studs
    // Set state = 1 (these operations executed)
}
```

**State Values:**
- **State = 0**: First-time creation, execute initialization operations
- **State ≥ 1**: Subsequent recalculations, skip initialization

**Initialization Operations:**
- Automatic "Add Anchor" command execution
- Erase automatically generated studs that intersect the connector body
- Set module and panhand references

**State Persistence:**
The state value is stored in the instance's Map object (`_Map`) and persists with the drawing.

### Legacy Property Migration

The script includes backward-compatibility logic for instances created with older versions:

```c
Map mpPropsOld = _ThisInst.mapWithPropValues().getMap("PropString[]").getMap(0);
String oldChoice = mpPropsOld.getString("strValue");
int oldFound = arConnDescript.find(oldChoice);
if (oldFound > -1) oldChoice = arTranslation[oldFound];
else oldChoice = "";

if (oldChoice.length() > 0) {
    strConnector.set(oldChoice);
    // Update property map to new format
    // ...
}
```

**Translation Array:**
The `arTranslation[]` array maps old connector naming schemes to current names. For example:
- Old format: "HTT4 NAIL"
- Translation: "HTT4 SIMPSON"
- New format: "HTT4 NAIL SIMPSON"

**Property Map Update:**
For instances with old property formats, the script:
1. Retrieves the old connector choice
2. Translates it to the current naming scheme
3. Updates the property map structure to match the current version
4. Sets property values from the updated map

### Automatic Stud Cleanup on Creation

When a hold-down is first created (`_bOnInsert` or `_bOnDbCreated && iState==0`), the script erases any automatically generated studs that intersect the connector body:

```c
if (_bOnInsert || (_bOnDbCreated && iState==0)) {
    Beam arBm[] = el.vecX().filterBeamsPerpendicular(el.beam());

    for (int h=arBm.length()-1; h>-1; h--) {
        if (arBm[h].realBody().hasIntersection(bdConnector) &&
            _Beam.find(arBm[h]) == -1 &&
            arBm[h].module().length() < 2) {
            arBm[h].dbErase();
        }
    }
}
```

**Cleanup Conditions:**
A stud is erased if ALL of the following are true:
- Stud body intersects the connector body
- Stud is NOT part of the hold-down stud pack (`_Beam.find() == -1`)
- Stud does not belong to a module (`module().length() < 2`)

**Purpose:**
Cleans up studs that were auto-generated before the hold-down was placed, preventing doubled studs in the hold-down zone.

### Coordinate System Calculation

The hold-down derives its local coordinate system from the wall element and the "Side to place connector" setting:

```c
Vector3d vOff = el.vecX(); // Wall length direction
Vector3d vUp = el.vecY();  // Wall height direction
Vector3d vZ = el.vecZ();   // Wall thickness direction

// Change orientation for concrete face anchors
int n = arNewDescription.find(strConnector);
if (n == 5 || n == 21 || n == 22 || n == 23) { // LTTI31, LSTHD8, STHD10, STHD14
    vOff = el.vecZ(); // Orient along wall thickness instead
}

// Apply side selection
if (strSide == arSides[0] || strSide == arSides[2]) vOff *= -1; // Left sides
if (strSide == arSides[2] || strSide == arSides[3]) vUp *= -1;  // Top sides

vZ = vOff.crossProduct(vUp); // Recalculate to maintain right-handed system
```

**Coordinate Vectors:**
- `vOff`: Offset direction (connector extends from stud pack in this direction)
- `vUp`: Vertical direction (connector height aligned with this direction)
- `vZ`: Through-thickness direction (side gussets extend in this direction)

**Right-Handed System:**
The cross product ensures the coordinate system remains right-handed after flips. If `vOff` and `vUp` are flipped, `vZ` is recalculated to maintain orthogonality.

### Extreme Point Calculation

The script calculates the extreme points of the stud pack envelope to determine connector placement:

```c
Body bdAll; // Combined envelope of all beams
for (int b=0; b<_Beam.length(); b++) {
    bdAll += _Beam[b].envelopeBody();
}

Point3d arPtSides[] = bdAll.extremeVertices(vOff); // Left/right extremes
Point3d arPtDnUp[] = bdAll.extremeVertices(vUp);   // Bottom/top extremes
Point3d arPtZ[] = bdAll.extremeVertices(vZ);       // Front/back extremes
Point3d ptCenZ; ptCenZ.setToAverage(arPtZ);        // Center of thickness
```

**Extreme Point Usage:**
- `arPtSides[0]` and `arPtSides[1]`: Leftmost and rightmost points along offset direction
- `arPtDnUp[0]` and `arPtDnUp[1]`: Bottom and top points along vertical direction
- `ptCenZ`: Center of stud pack thickness (for lateral positioning)

**Base Plane Projection:**
The extreme points are projected onto the base plane (bottom or top of wall) and the center wall plane (middle of thickness):

```c
Plane pnBase(arPtDnUp[0] + vUp * pVerticalOffset, vUp);
Plane pnCenWall(ptCenZ, vZ);

arPtSides = pnBase.projectPoints(arPtSides);
arPtSides = pnCenWall.projectPoints(arPtSides);
```

This ensures the connector is positioned at the correct height and lateral position regardless of stud pack irregularities.

### Connector Model Data Arrays

The connector catalog is defined using parallel arrays indexed by model position:

```c
// Array declarations
String arConnDescript[0];  // Full description (dropdown display)
String arNewDescription[0]; // Primary model names (unique keys)
String arTranslation[0];   // Legacy name mapping
String arConnectors[0];    // Short name (for display labels)
double arDx[0];            // Width (inches)
double arDz[0];            // Depth (inches)
double arDy[0];            // Height (inches)
double arDRod[0];          // Rod diameter (inches)
double arDDrillCL[0];      // Drill centerline offset (inches)
int arIShape[0];           // Shape type (0-6)
double dExtra1[0];         // Shape-specific parameter 1
double dExtra2[0];         // Shape-specific parameter 2
int iFastenerQtyFull[0];   // Full installation fastener quantity
int iFastenerQtyTacked[0]; // Tacked installation fastener quantity
int iFastenerTypeFull[0];  // Full installation fastener type index
int iFastenerTypeTacked[0]; // Tacked installation fastener type index
```

**Example Entry (HTT4):**
```c
arConnDescript.append("HTT4 SIMPSON");
arNewDescription.append("HTT4 SIMPSON");
arTranslation.append("HTT4 SIMPSON");
arConnectors.append("HTT4");
arDx.append(U(2.625));        // 2-5/8"
arDz.append(U(2.5));          // 2-1/2"
arDy.append(U(12.375));       // 12-3/8"
arDRod.append(U(0.625));      // 5/8"
arDDrillCL.append(U(1.3125)); // 1-5/16"
arIShape.append(1);           // Shape type 1
dExtra1.append(U(0));
dExtra2.append(U(0));
iFastenerTypeFull.append(0);    // Index to "0.148 x 1 1/2"
iFastenerTypeTacked.append(0);  // Index to "0.148 x 1 1/2"
iFastenerQtyFull.append(18);    // 18 fasteners
iFastenerQtyTacked.append(2);   // 2 fasteners
```

**Array Indexing:**
All arrays use the same index `n` to retrieve data for a specific connector:
```c
int n = arNewDescription.find(strConnector); // Find index of current connector
double width = arDx[n];  // Width of connector n
double rod = arDRod[n];  // Rod diameter of connector n
```

### Fastener Type Array

```c
String arFastenerType[] = {
    "0.148 x 1 1/2\"",      // Index 0
    "0.250 x 2 1/2\" SDS",  // Index 1
    "0.250 x 1 1/2\" SDS",  // Index 2
    "0.162 x 2 1/2\"",      // Index 3
    "0.148 x 3\"",          // Index 4
    "0.148 x 3 1/4\"",      // Index 5
    "0.131 x 3\"",          // Index 6
    "0.250 x 3\" SDS",      // Index 7
    "#10 x 2 1/2\" SD",     // Index 8
    "WS15-EXT",             // Index 9
    "1.0 x X\"Bolt"         // Index 10
};
```

The `iFastenerTypeFull` and `iFastenerTypeTacked` arrays store indices into this array to specify which fastener type to use for each installation mode.

## Settings and Configuration

### No External Settings Files

This script does not use external XML settings files. All connector dimensions, fastener specifications, and shape parameters are defined internally within the script code.

**Advantages:**
- Self-contained: No dependency on external configuration files
- Versioning: Connector catalog is version-controlled with the script
- Deployment: Single file deployment (no separate settings to install)

**Disadvantages:**
- Updates: Adding new connector models requires script modification
- Customization: Cannot add company-specific connectors without editing code

### Connector Catalog Maintenance

To add a new connector model to the catalog:

1. **Append model data to all arrays:**
```c
arConnDescript.append("NEW_MODEL SIMPSON");
arNewDescription.append("NEW_MODEL SIMPSON");
arTranslation.append("NEW_MODEL SIMPSON");
arConnectors.append("NEW_MODEL");
arDx.append(U(width));
arDz.append(U(depth));
arDy.append(U(height));
arDRod.append(U(rod_diameter));
arDDrillCL.append(U(drill_centerline));
arIShape.append(shape_type);
dExtra1.append(U(extra_param_1));
dExtra2.append(U(extra_param_2));
iFastenerTypeFull.append(fastener_type_index);
iFastenerTypeTacked.append(tacked_type_index);
iFastenerQtyFull.append(full_quantity);
iFastenerQtyTacked.append(tacked_quantity);
```

2. **Test the geometry generation** by placing the new model and verifying 3D shape correctness.

3. **Update version history** in the `#BeginDescription` block.

### Drawing Unit Handling

The script uses the `U()` unit conversion function extensively to ensure compatibility with both Imperial and Metric drawing templates:

```c
U(1, "inch"); // Set base unit to inches

// All dimensions use U() wrapper
double dWidth = U(2.625);  // 2-5/8" in current units
double dHeight = U(12.375); // 12-3/8" in current units
```

**Critical:** Never write hardcoded dimensions without `U()` wrapper. This ensures the script works correctly in both Millimeter and Inch templates.

## Troubleshooting

### Common Issues and Solutions

**Issue: "Must be relinked to stud pack" message appears**

**Cause:** The original stud pack beams were deleted or the hold-down lost its beam references.

**Solution:**
1. Right-click the hold-down instance
2. Select "Relink to post"
3. Select the new stud pack
4. Verify the hold-down recalculates correctly

---

**Issue: Doubled studs appear in the hold-down zone**

**Cause:** Stud distribution ran before the hold-down was placed, or "Erase intersecting beams" is disabled.

**Solution:**
1. Enable "Erase intersecting beams" property (set to "Yes")
2. Regenerate the wall element construction
3. Manually delete extra studs if automatic cleanup does not work

---

**Issue: Hold-down studs do not extend to plates**

**Cause:** "Stretch beams" is disabled, or the wall element has not completed construction.

**Solution:**
1. Enable "Stretch beams" property (set to "Yes")
2. Regenerate the wall element (right-click wall, select "Recalculate")
3. Verify plates exist and are recognized (check beam types)

---

**Issue: Wrong hold-down orientation (upside-down or backward)**

**Cause:** Incorrect "Side to place connector" setting.

**Solution:**
1. Open Properties Palette (Ctrl+1)
2. Change "Side to place connector" to the correct option:
   - Bottom Left/Right for foundation connections
   - Top Left/Right for upper-story connections
3. Verify 3D geometry updates correctly

---

**Issue: Anchor rod diameter does not match hold-down**

**Cause:** Hold-down type was changed after anchor was created.

**Solution:**
1. Right-click hold-down
2. Select "Release Anchor"
3. Delete the old anchor instance
4. Right-click hold-down
5. Select "Add Anchor" to create new anchor with correct diameter

---

**Issue: Fastener schedule does not match manufacturer specification**

**Cause:** Manual override was applied, or installation option does not match intended use.

**Solution:**
1. Verify "Installation Options" is set correctly (Fully Installed, Tacked, Field Installed)
2. Check "Hold Down Type" matches the intended connector model
3. If fasteners were manually overridden, change "Hold Down Type" to a different model and back to reset to defaults

---

**Issue: Hold-down appears in wrong location on stud pack**

**Cause:** Lateral or vertical offsets are set incorrectly.

**Solution:**
1. Check "Vertical Offset" property (should be 0 for standard placement)
2. Check "Lateral Offset" property (should be 0 for centered placement)
3. Adjust offsets as needed for special detailing

---

**Issue: "Beams belong to different elements" error**

**Cause:** Selected studs belong to more than one wall element.

**Solution:**
1. Ensure all studs in the hold-down pack belong to the same wall element
2. If studs span a wall split, relink the hold-down to one side
3. Create separate hold-downs for studs in different wall elements

---

**Issue: Hold-down disappears after wall is split**

**Cause:** The hold-down position fell outside all resulting wall segments.

**Solution:**
1. Undo the wall split
2. Move or relink the hold-down away from the split location
3. Re-split the wall
4. Or manually recreate the hold-down on the correct wall segment

---

**Issue: Sheathing overlaps hold-down connector**

**Cause:** Sheet cut locations were not registered, or sheathing script does not recognize cut locations.

**Solution:**
1. Regenerate the wall element to ensure sheet cut locations are registered
2. Verify the stud pack touches zone 1 (sheathing zone)
3. Regenerate sheathing distribution
4. Check sheathing script supports sheet cut locations feature

---

**Issue: Hold-down not appearing in BOM or hardware schedule**

**Cause:** Hardware group assignment failed, or BOM extraction script does not read hardware components.

**Solution:**
1. Verify the hold-down is assigned to "X - Hardware / X-Hold Down Connectors" group
2. Check that BOM extraction script reads `HardWrComp` objects
3. Regenerate BOM or hardware schedule
4. Verify DXA export is enabled and working

## Tips and Best Practices

### Stud Pack Selection Strategy

**Doubled/Tripled Studs:**
When selecting doubled or tripled stud packs, always select ALL studs in the assembly. The script treats the entire selection as a single functional unit and prevents stud distribution within the pack footprint.

**Window Selection:**
Use window selection (left-to-right drag) to efficiently select all studs in a hold-down pack, especially for tripled assemblies.

**Multiple Placements:**
The insertion loop allows placing multiple hold-downs in a single command session. Plan your placement sequence (e.g., left-to-right along the wall) for efficient workflow.

### Connector Model Selection

**Match Structural Capacity:**
Always select the hold-down model specified by the structural engineer on the shear wall schedule. Hold-down capacity (kips uplift resistance) varies significantly between models.

**Rod Diameter Coordination:**
Ensure the hold-down rod diameter matches the foundation anchor bolt:
- 1/2" rod: DTT1Z, DTT2Z series (light-duty)
- 5/8" rod: HTT series, LTT series (medium-duty)
- 7/8" rod: HDQ series (heavy-duty)
- 1" rod: HDU series, HD12/HD19 (maximum-duty)

**Physical Clearances:**
Verify the connector width and depth fit within available space:
- 2x4 walls: Use narrow models (≤ 2")
- 2x6 walls: Can accommodate wider models (up to 4-1/2")
- Doubled stud packs: Wider models work better for centered placement

### Fastener Specification

**Default Schedules:**
Use manufacturer default fastener schedules whenever possible. Manual overrides should only be used when the project specifications explicitly require non-standard fasteners.

**SDS vs. Nail Variants:**
- **SDS screws**: Faster installation, higher pullout resistance, better for engineered lumber
- **Nails**: Traditional fastening, lower cost, adequate for solid sawn lumber

**Installation Mode Selection:**
- **Fully Installed**: Recommended for shop-fabricated panels with full quality control
- **Tacked**: Use for large wall panels requiring field adjustment before final fastening
- **Field Installed**: Use when connectors must be adjusted for exact placement on-site

### Anchor Rod Integration

**When to Add Anchors:**
- Bottom-of-wall hold-downs: Always add anchors for foundation connection
- Top-of-wall hold-downs: Add anchors only for continuous rod systems
- Concrete straps (LSTHD, STHD): Do NOT add anchors (incompatible)

**Anchor Timing:**
Add anchors immediately after placing hold-downs. The script automatically creates anchors on first placement, but verify they exist.

**Drill Plates Coordination:**
The "Drill Plates" property controls whether the anchor script drills through plates. Set to "Yes" for standard foundation connections, "No" for special detailing.

### Color Coding Strategy

**Consistent Color Scheme:**
Establish a project-wide color scheme for special framing:
- Color 1 (Red): Headers and critical structural members
- Color 2 (Yellow): Members requiring field verification
- Color 3 (Green): Hold-down posts and engineered assemblies
- Color 4 (Cyan): Temporary or construction-only members

**Visual Quality Control:**
Use color coding to quickly identify hold-down locations during design reviews. Green studs immediately indicate high-load transfer points.

### Element Construction Workflow

**Recommended Sequence:**
1. Create wall element outline
2. Place hold-down studs (doubled/tripled as needed)
3. Insert hold-down TSL instances
4. Add anchor rods
5. Run element construction (generates plates, distributes studs, applies stretching)
6. Verify hold-down zones have no doubled studs
7. Regenerate sheathing (creates cutouts around hold-downs)

**Stretch and Erase Settings:**
Keep "Stretch beams" and "Erase intersecting beams" enabled (Yes) for automatic coordination. Disable only when manual control is absolutely necessary.

### Offset Usage Guidelines

**Vertical Offset:**
- Standard foundation: 0 (default)
- Raised foundation: +3" to +6" (clears foundation step)
- Floor-to-floor connection: Adjust to align with floor framing

**Lateral Offset:**
- Centered on stud pack: 0 (default)
- Aligned with exterior sheathing: +0.5" to +1"
- Aligned with interior finish: -0.5" to -1"
- Multi-stud pack: Offset to center on specific stud

**Combined Offsets:**
Use both vertical and lateral offsets together for complex detailing (e.g., raised foundation with offset sheathing).

### Wall Splitting Considerations

**Before Splitting:**
Verify hold-down positions relative to planned split locations. If a hold-down is exactly at a split point, move it slightly to one side first.

**After Splitting:**
Check that all hold-downs remain associated with the correct wall segment. Use "Relink to post" if necessary.

**Split at Openings:**
When splitting walls at openings, hold-downs at opening corners may need relinking if the split logic changes element associations.

### Display Representation Management

**Fabrication Views:**
Enable "HoldDown" display representation to show complete hardware detail for shop drawing generation.

**Simplified Views:**
Disable "HoldDown" display representation for framing-only views where hardware detail is not needed.

**Plan Views:**
The script automatically shows simplified 2D representations (rectangles and circles) in top/bottom views regardless of display representation settings.

### BOM and Scheduling

**Hardware Grouping:**
All hold-downs of the same model are automatically grouped under "X - Hardware / X-Hold Down Connectors / [Model]" for easy BOM aggregation.

**Fastener Tracking:**
Custom fastener schedules appear as separate BOM line items. Review BOM carefully when using manual overrides to ensure correct procurement.

**Installation Mode Notes:**
The BOM export includes installation mode in the component notes (Fully Installed, Tacked, Field Installed). Use this for shop vs. field labor scheduling.

### Concrete-Embedded Strap Models

**LSTHD8, STHD10, STHD14 Special Handling:**
These models orient differently from standard hold-downs:
- Extend along wall thickness (Z-axis) rather than face (X-axis)
- Embed into concrete foundation at an angle
- Do NOT support anchor rod creation
- Fastener quantity is 0 (embedded, not fastened)

**Foundation Coordination:**
Coordinate concrete strap placement with foundation contractor. Straps must be positioned in formwork before concrete pour.

**Use Cases:**
Concrete straps are ideal for retrofit applications or when foundation anchor bolts cannot be installed.

### HD12/HD19 Bolted Models

**Through-Bolt Connections:**
These models use 1" through-bolts rather than nails/screws:
- Fastener type: "1.0 x X Bolt"
- Fastener quantity: 4 (HD12) or 5 (HD19)
- Bolt length: "X" indicates field-measured length based on stud pack thickness

**Tapered Profile:**
The side flanges taper from full width at the base to 20% at the top, creating a triangular profile that maximizes bearing at the base plate.

**High-Capacity Applications:**
Use HD12/HD19 for maximum uplift resistance in critical shear wall locations.

### Module and Prefab Considerations

**Pre-Existing Modules:**
If stud pack beams already belong to a module, the script skips certain initialization operations to avoid conflicts. Verify module assignments are correct after hold-down placement.

**Panel Nesting:**
Hold-down connectors affect panel nesting and stacking. Coordinate with fabrication planning to ensure connectors do not create packaging issues.

**Shipping Protection:**
For "Fully Installed" connectors, consider protective packaging to prevent damage during shipping. Tacked connectors are more resistant to shipping damage.

## Technical Notes

### Script Type and Insertion

**Object Type (O-Type):**
The script is an O-Type TSL, meaning it creates its own geometry and manages beam properties. It does not require pre-selected beams at launch (`#NumBeamsReq 0`) but obtains beam references during the insertion workflow.

**Implicit Insertion (`#ImplInsert 1`):**
The script uses an implicit insertion mechanism. During insertion, it clones itself onto each selected stud pack and then erases the original insertion instance. This pattern allows multiple placements from a single command invocation.

**Insertion Loop:**
```c
while(true) {
    PrEntity ssE("select a vertical stud pack", Beam());
    if (ssE.go()) {
        arBm = ssE.beamSet();
    }
    if (arBm.length() == 0) break; // Exit on empty selection

    // Clone onto this stud pack
    TslInst tsl;
    tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts,
                 lstPoints, lstPropInt, lstPropDouble, lstPropString, 1, _Map);
}
eraseInstance(); // Erase original insertion instance
```

**Property Transfer:**
The insertion instance stores its properties in `_Map.setMap("mpProps", mapWithPropValues())` before cloning. Each cloned instance reads these properties and applies them: `setPropValuesFromMap(_Map.getMap("mpProps"))`.

### Coordinate System Details

**Element Coordinate System:**
```c
CoordSys csEl = el.coordSys();
Vector3d vecXEl = csEl.vecX(); // Along wall length
Vector3d vecYEl = csEl.vecY(); // Along wall height (vertical)
Vector3d vecZEl = csEl.vecZ(); // Through wall thickness
Point3d ptOrgEl = csEl.ptOrg(); // Element origin
```

**World Coordinate System:**
```c
Vector3d _XW; // World X-axis
Vector3d _YW; // World Y-axis
Vector3d _ZW; // World Z-axis
```

**Insertion Point (`_Pt0`):**
The hold-down insertion point is calculated as the midpoint of the stud pack footprint with offsets:
```c
_Pt0 = 0.5*(ptLeft + ptRight) + pVerticalOffset*vUp + pLateralOffset*el.vecZ();
```

This ensures the hold-down centers on the stud pack by default.

### Beam Type Constants

The script uses hsbCAD beam type constants for plate recognition:

| Constant | Value | Description |
|----------|-------|-------------|
| `_kSFTopPlate` | 2 | Standard horizontal top plate |
| `_kSFBottomPlate` | 1 | Standard horizontal bottom plate |
| `_kSFAngledTPLeft` | 9 | Angled top plate (left side of gable/hip) |
| `_kSFAngledTPRight` | 10 | Angled top plate (right side of gable/hip) |
| `_kSFSupportingBeam` | 11 | Supporting beam (under opening) |
| `_kSFJackUnderOpening` | 12 | Jack stud under opening (header support) |
| `_kSFJackOverOpening` | 13 | Jack stud over opening (sill support) |

### Debugging Support

**Debug Mode Activation:**
```c
int bDebug = _bOnDebug;
MapObject mo("hsbTSLDev", "hsbTSLDebugController");
if (mo.bIsValid()) {
    Map m = mo.map();
    for (int i=0; i<m.length(); i++) {
        if (m.getString(i) == scriptName()) {
            bDebug = true;
            break;
        }
    }
}
if (bDebug) reportMessage("\n" + scriptName() + " starting " + _ThisInst.handle());
```

**Debug Controller:**
The script checks for a debug controller MapObject (`hsbTSLDebugController`) that can enable debug mode for specific scripts. If the script name is in the controller's list, debug mode is activated.

**Visual Debugging:**
Geometry objects have `.vis(color)` methods for visual debugging:
```c
_Pt0.vis(1); // Draw point in red
bdConnector.vis(2); // Draw body in yellow
vBase.vis(_Pt0, 1); // Draw vector from point in red
```

**Debug Messages:**
Use `reportMessage()` for console output during debugging:
```c
if (bDebug) reportMessage("\nDebug: " + variableName + " = " + value);
```

### Performance Considerations

**Envelope vs. Real Body:**
The script uses `envelopeBody()` for stud pack analysis rather than `realBody()` for performance:
```c
bdAll += _Beam[b].envelopeBody(); // Fast bounding box
// vs.
// bdAll += _Beam[b].realBody(); // Slow exact geometry
```

Envelope bodies are rectangular bounding boxes that provide sufficient accuracy for extreme point calculation while avoiding expensive boolean operations.

**Beam Filtering:**
The script filters beams by direction using vector operations rather than iterating all beams:
```c
Beam bmVertical[] = vecYEl.filterBeamsParallel(_Beam);
Beam bmHorizontal[] = vecXEl.filterBeamsParallel(_Beam);
```

This vectorized filtering is significantly faster than looping with individual dot product checks.

**Early Exit Conditions:**
The script exits early when critical errors are detected:
```c
if (_Beam.length() == 0) return; // No beams, exit immediately
if (!el.bIsValid()) { eraseInstance(); return; } // No element, erase and exit
```

### Map Object Communication

The script uses Map objects for data exchange with child scripts and downstream processes:

**Keys Used:**
- `"State"` (int): Initialization state (0 = first time, ≥1 = subsequent)
- `"mpProps"` (Map): Property values for cloned instances
- `"ANCHOR"` (Entity): Reference to child GE_HDWR_WALL_ANCHOR instance
- `"ANCHOR_POINT"` (Point3d): Anchor rod centerline location
- `"MapDxaOut"` (Map): DXA export data
- `"mpHoldDownData"` (Map): Connector dimensions for annotation scripts
- `"HOLDDOWN_FASTENERS"` (String): Fastener schedule string

**Map Data for Anchor Script:**
```c
Map mpHD;
mpHD.setEntity("HoldDown", _ThisInst); // Parent hold-down reference
mpHD.setDouble("dRodInsert", arDRod[n]); // Rod diameter
tsl.dbCreate(sScriptName, ..., mpHD); // Pass to anchor script
```

### Recalculation Triggers

**Context Menu Triggers:**
```c
String relink = T("|Relink to post|");
addRecalcTrigger(_kContext, relink);

if (_kExecuteKey == relink) {
    // Execute relink command
}
```

The `addRecalcTrigger()` function adds a context menu item that triggers recalculation when selected.

**Property Change Triggers:**
```c
if (_kNameLastChangedProp == "Hold Down Type" ||
    _kNameLastChangedProp == "Installation Options") {
    // Update fastener schedule
}
```

The `_kNameLastChangedProp` predefined variable contains the name of the most recently changed property, allowing conditional logic based on which property was modified.

### Version History

The script maintains a detailed version history in the `#BeginDescription` block:

```
V3.21__01/07/21__Will set hardware group
V3.20__01/Jul/2020__LSTHD8, STHD10, STHD14 types aligned to edge + fastener changes
V3.19__19/Jun/2020__Added DTT2Z SDS2.5, HD12, HD19 + installation options
V3.18__10/1/2019__Added fasteners and install options
V3.16__Jan_03_2019__Added Modelmap support
V3.15__05June2018__Assigns holdowns to subgroups under X-hardware
V3.14__15March2018__Relink capability if studs deleted
V3.12__13Nov 2017__Changed _Pt0 to base of hardware
V3.10__25 Oct 2017__Display for PC
V3.9__26Sept2017__Bugfix offset properties
V3.8__15Sept2017__Sends to display rep called HoldDown
V3.7__14Sept2017__Will not try to set location automatically
V3.6__13Sept2017__Will insert the anchor
V3.5__12Sept2017__Added extra doubles for new hold downs
V3.3__08Sept2017__State stored in dwg
V3.2__28June2017__Added lateral Offset
V3.1__30March 2017__Added vertical offset
V3.0__March 28 2016__Added embedded straps
V2.9__Sept 26 2016__Can now be at top of wall
V2.7__August 2 2016__Should be exported
V2.6__June 21 2016__Added hardware comp to be exported
```

Major updates include connector catalog expansions, installation mode additions, offset capabilities, and anchor rod integration.

## Related Scripts

### GE_HDWR_WALL_ANCHOR
Companion script for anchor rods that pass through plates to connect hold-downs to foundations or upper floors. Automatically created by the "Add Anchor" context menu command.

**Coordination:**
- Receives rod diameter from hold-down
- Receives insertion point at rod hole centerline
- Reads "Drill Plates" property from hold-down
- Tracks parent hold-down for coordinated updates

**Use Case:**
Every hold-down (except concrete-embedded straps) requires an anchor rod for foundation or floor-to-floor connection. The anchor script handles the rod geometry, plate drilling, and connection detailing.

### GE_HDWR_WALL_HOLD_DOWN_ADG
Alternative version of this script (ADG = Alternate Design Group variant). Likely used for different project templates or regional requirements.

**Relationship:**
Same functionality as GE_HDWR_WALL_HOLD_DOWN but with different default settings, group assignments, or connector catalog.

## Summary

GE_HDWR_WALL_HOLD_DOWN is a sophisticated hardware placement tool that provides:

✓ **Comprehensive Connector Catalog**: 30+ Simpson Strong-Tie and USP hold-down models with accurate 3D geometry
✓ **Intelligent Stud Management**: Automatic stretching, conflict detection, and distribution control
✓ **Flexible Installation Modes**: Fully Installed, Tacked, and Field Installed with automatic fastener scheduling
✓ **Integrated Anchor Rods**: Automatic creation and coordination with GE_HDWR_WALL_ANCHOR script
✓ **Wall Element Integration**: No-stud zones, sheet cut locations, and wall split tracking
✓ **Complete BOM Export**: Hardware components, fasteners, and installation notes for procurement

The script streamlines hold-down placement in stick-frame wall construction by automating placement, geometry generation, fastener scheduling, and BOM export while maintaining full parametric control through the Properties Palette.
