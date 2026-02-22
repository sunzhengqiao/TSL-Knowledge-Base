# hsbCLT-Tape

## Overview

**hsbCLT-Tape** is an intelligent CLT panel sealing tool that automatically applies air-tightness tape to Cross-Laminated Timber (CLT) panel edges. The script supports both **batch automatic mode** (processing multiple panels simultaneously) and **interactive manual mode** (precise individual edge control with visual feedback). It generates production-ready hardware lists and creates visual representations for both 3D models and 2D shop drawings.

### Key Features

- **Dual Operation Modes**: Automatic batch processing or manual interactive placement
- **Smart Product Selection**: Automatically selects appropriate tape products based on edge thickness
- **Hardware Integration**: Generates complete material lists with article numbers and quantities
- **Dynamic Recalculation**: Maintains tape positioning when panels are moved or rotated
- **Opening-Aware**: Applies tapes to both outer perimeter and internal openings (windows, doors)
- **Arc Support**: Handles curved panel edges with proper tangent alignment
- **Shop Drawing Ready**: Creates Paper Space-compatible visual symbols

### Typical Use Cases

- Sealing CLT floor panel perimeters before installation
- Air-barrier treatment for CLT wall panels
- Opening edge sealing (window/door cutouts)
- Batch processing entire building floors or wall assemblies
- Custom sealing for complex panel geometries

---

## Technical Specifications

### Script Metadata

| Property | Value |
|----------|-------|
| **Script Type** | O-Type (Object) |
| **Version** | 1.6 (December 15, 2021) |
| **Required Beams** | 0 (operates on Sip entities) |
| **Keywords** | Tape, CLT |
| **Working Environment** | Model Space only |

### Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.6 | 2021-12-15 | Improved segment calculation at lap joints | Marsel Nakuci |
| 1.5 | 2021-10-27 | Group assignment, lap joint fixes, XML display maps | Marsel Nakuci |
| 1.4 | 2021-10-05 | Distribution rules, hardware writing, MapXData | Marsel Nakuci |
| 1.3 | 2021-09-30 | Panel reference tracking when moving, performance optimization | Marsel Nakuci |
| 1.2 | 2021-09-30 | Arc support, multiple faces per edge | Marsel Nakuci |
| 1.1 | 2021-09-27 | Interactive jigging and grip dragging | Marsel Nakuci |
| 1.0 | 2021-09-27 | Initial working version | Marsel Nakuci |

---

## Prerequisites

### Required Entities

- **Sip (CLT Panel)**: One or more valid CLT panel entities must exist in the drawing
- The panels must have a valid 3D solid body (not just outlines)
- Panels can contain openings (cutouts will be detected automatically)

### Required Configuration Files

**TapeCatalog.xml** must be located at either:
1. **Company Path**: `[Company Folder]\TSL\Settings\TapeCatalog.xml`
2. **Installation Path**: `[Installation Folder]\Content\General\TSL\Settings\TapeCatalog.xml`

If both exist, the Company version takes precedence. The script validates version compatibility and warns if mismatches are detected.

### System Requirements

- hsbCAD CLT module installed
- AutoCAD 2018 or newer (for transparency support)
- Model Space working environment (Paper Space not supported)

---

## Usage Instructions

### Step 1: Launch the Script

**Command Line Method:**
```
Command: TSLINSERT
```
Select `hsbCLT-Tape.mcr` from the file list.

**Optional Custom Command:**
```autolisp
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-Tape")) TSLCONTENT
```

### Step 2: Select CLT Panels

```
Command Line: Select panels
```

**Selection determines operation mode:**

#### Automatic Mode (Multiple Panels)
- **Action**: Select **2 or more** panels
- **Result**: Script creates one TSL instance per panel
- **Behavior**: Tapes are automatically applied to:
  - All outer perimeter edges
  - All internal opening edges
  - Both straight and curved edges

#### Manual Mode (Single Panel)
- **Action**: Select **exactly 1** panel
- **Result**: Interactive edge selection mode activates
- **Behavior**: User picks specific edges for tape application

### Step 3A: Automatic Mode Workflow

1. **Select Panels**: Click multiple CLT panels
2. **Press Enter**: Script processes all panels simultaneously
3. **Review**: Each panel receives tape instances on all edges
4. **Modify (Optional)**: Use "Edit in Place" to split into manual instances

**Automatic Mode Benefits:**
- Fast processing for entire floors/walls
- Consistent tape application across all panels
- Batch hardware generation
- Ideal for standard rectangular panels

### Step 3B: Manual Mode Workflow

1. **Select Single Panel**: Click one CLT panel
2. **Edge Selection Prompt**:
   ```
   Command Line: Select point to select edge or <Enter> to accept automatic generation
   ```

3. **Interactive Edge Highlighting**:
   - Move cursor over panel
   - Closest edge highlights in real-time (red with transparency)
   - Visual feedback shows both edge profile and top view

4. **Edge Confirmation**:
   - **Left Click**: Apply tape to highlighted edge
   - **Enter Key**: Switch to automatic generation for all edges

5. **Grip Adjustment**:
   - After placement, two grip points appear at tape endpoints
   - **Drag grips** to adjust tape coverage along the edge
   - Grips snap to edge endpoints or can be positioned anywhere along edge

**Manual Mode Benefits:**
- Precise control over which edges receive tape
- Adjustable tape length per edge
- Visual feedback during selection
- Ideal for complex geometries or partial sealing

---

## Parameters and Configuration

### User-Adjustable Properties

**Important**: This script does **NOT** expose parameters in the AutoCAD Properties Palette (OPM). All settings are controlled through the **TapeCatalog.xml** configuration file.

### XML Configuration File Structure

The `TapeCatalog.xml` file defines:
1. **Available Tape Products** (manufacturer, dimensions, article numbers)
2. **Display Settings** (color, transparency, visual width)
3. **Distribution Rules** (how tapes are selected based on edge thickness)

#### XML Schema Overview

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
  <!-- Version Control -->
  <lst nm="GeneralMapObject">
    <int nm="Version" vl="1"/>
  </lst>

  <!-- Display Settings -->
  <lst nm="Display[]">
    <lst nm="Display">
      <int nm="NrTapesEdge" vl="0"/>
      <int nm="Color" vl="1"/>
      <int nm="Transparency" vl="75"/>
      <dbl nm="TapeWidthFront" ut="L" vl="30"/>
    </lst>
  </lst>

  <!-- Product Catalog -->
  <lst nm="Manufacturer[]">
    <lst nm="Manufacturer">
      <str nm="Name" vl="Siga"/>
      <lst nm="Family[]">
        <lst nm="Family">
          <str nm="Name" vl="Wigluv"/>
          <lst nm="Product[]">
            <!-- Individual Products -->
            <lst nm="Product">
              <str nm="Name" vl="Wigluv 60"/>
              <dbl nm="Width" ut="L" vl="0.06"/>
              <dbl nm="Length" ut="L" vl="40"/>
              <str nm="ArticleNumber" vl="7510-6040"/>
            </lst>
            <lst nm="Product">
              <str nm="Name" vl="Wigluv 150"/>
              <dbl nm="Width" ut="L" vl="0.15"/>
              <dbl nm="Length" ut="L" vl="25"/>
              <str nm="ArticleNumber" vl="7510-15025"/>
            </lst>
            <!-- Additional products... -->
          </lst>
        </lst>
      </lst>
    </lst>
  </lst>

  <unit ut="L" uv="millimeter"/>
</Hsb_Map>
```

#### Display Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Color** | Integer | 1 | AutoCAD color index (1=Red, 2=Yellow, 3=Green, etc.) |
| **Transparency** | Integer | 75 | Opacity percentage (0=Solid, 100=Invisible) |
| **TapeWidthFront** | Length | 30 mm | Visual representation width in plan view (2D) |

**Note**: The `NrTapesEdge` parameter differentiates between single-tape and multi-tape display rules. When `NrTapesEdge=0`, these are the default settings.

#### Default Tape Products (Siga Wigluv)

| Product Name | Width | Roll Length | Article Number | Typical Use |
|--------------|-------|-------------|----------------|-------------|
| **Wigluv 60** | 60 mm | 40 m | 7510-6040 | Narrow edges, finishing tape |
| **Wigluv 150** | 150 mm | 25 m | 7510-15025 | Standard edges, primary tape |
| **Wigluv 250** | 250 mm | 25 m | (varies) | Wide edges (200-250 mm) |
| **Wigluv 300** | 300 mm | 25 m | 7509-30025 | Extra-wide edges (250-300 mm) |

### Automatic Product Selection Logic

The script intelligently selects tape products based on **edge thickness** (CLT panel height):

#### Floor Panels (Horizontal Orientation)

| Edge Thickness | Tape Configuration | Calculation Logic |
|----------------|-------------------|------------------|
| **≤ 130 mm** | **Single Tape** | Smallest product where: `Width ≥ EdgeThickness + 70mm` |
| **130-280 mm** | **Wigluv 150 + Wigluv 60** | Primary 150mm tape + 60mm finishing tape |
| **> 280 mm** | **Multiple Wigluv 150 + Wigluv 60** | As many 150mm tapes as needed + 60mm finish |

**Example Calculations:**

- **90 mm Edge**: Selects Wigluv 150 (90 + 70 = 160 mm < 150 mm? No → Wigluv 250 too wide → Use Wigluv 150)
- **120 mm Edge**: Wigluv 150 (120 + 70 = 190 mm, use Wigluv 250 if available)
- **200 mm Edge**: Wigluv 150 + Wigluv 60 (combination covers edge)
- **320 mm Edge**: 2× Wigluv 150 + Wigluv 60

#### Wall Panels (Vertical Orientation)

Wall panel logic is **similar** but may have different distribution rules depending on:
- Vertical vs. horizontal edge orientation
- Element integration (if panel is part of a Wall Element)
- Custom company standards in TapeCatalog.xml

### Edge Type Detection

The script analyzes panel geometry to identify:

1. **Outer Perimeter Edges**: Main panel outline (always processed in Automatic mode)
2. **Opening Edges**: Internal cutouts (windows, doors, service holes)
3. **Straight Edges**: Linear segments (most common)
4. **Arc Edges**: Curved segments (automatically converted to linear approximations for processing)

**Arc Edge Handling:**
- Curved edges are approximated with 10mm line segments
- Each segment receives tape aligned with local tangent direction
- Visual result appears smooth in both 3D and 2D views

---

## Interactive Features

### Visual Feedback During Selection

**Jig Mode (Manual Edge Selection):**

When selecting edges in Manual Mode, the script provides real-time visual feedback:

1. **Edge Highlighting**: Closest edge to cursor glows in configured color
2. **3D Profile Display**: Shows actual tape cross-section in Model Space
3. **2D Plan View**: Shows top-down tape representation
4. **Dynamic Updates**: Highlights update as cursor moves

**Display Characteristics:**
- Highlight color: Matches configured `Color` parameter (default: Red/1)
- Transparency: Matches configured `Transparency` (default: 75%)
- View-dependent: Front view shows 2D symbol, 3D view shows full profile

### Grip Point Editing

After placing tape in Manual Mode, **two grip points** appear:

| Grip Point | Location | Function |
|------------|----------|----------|
| **_PtG0** | Start of tape segment | Drag to adjust start position along edge |
| **_PtG1** | End of tape segment | Drag to adjust end position along edge |

**Grip Behavior:**
- Grips are **constrained to the edge** (cannot move perpendicular)
- Dragging updates tape length in real-time
- Grip positions are stored in `_Map` for panel movement tracking
- Use `Esc` to cancel grip drag operation

**Use Cases:**
- Shorten tape to avoid panel corners
- Extend tape to cover full edge
- Create partial edge coverage for specific detailing

---

## Right-Click Context Menu

### "Edit in Place" Command

**Trigger**: Right-click on an **Automatic Mode** tape instance

**Function**: Converts a single Automatic instance (covering all edges) into **multiple Manual instances** (one per edge)

**When to Use:**
- You need to adjust tape on specific edges only
- Complex panel shapes require individual edge control
- Custom sealing patterns for architectural details

**Workflow:**
1. Right-click on Automatic tape instance
2. Select **"Edit in Place"**
3. Script generates individual Manual instances for each edge
4. Original Automatic instance is deleted
5. Each new instance can be:
   - Grip-edited independently
   - Deleted individually
   - Recalculated separately

**Result:**
- Full control over each edge
- Individual hardware entries per tape segment
- Independent recalculation per edge

---

## Hardware and Material Output

### Hardware Component Generation

The script generates **HardWrComp** (Hardware Components) for material tracking:

#### Hardware Properties

| Property | Value/Description |
|----------|------------------|
| **Category** | "Tooling" (appears in Bill of Materials under this category) |
| **RepType** | `_kRTTsl` (marks component as TSL-generated) |
| **Article Number** | From TapeCatalog.xml (e.g., "7510-6040") |
| **Description** | Format: `"TapeName;EdgeType;FloorWall;"` |
| **Quantity** | 1 per tape segment |
| **DScaleX** | Tape length (mm) + 200mm overlap allowance |
| **DScaleY** | Tape width (mm) × 1000 for unit conversion |
| **Group** | Element group name (if panel is part of Element) |
| **Linked Entity** | Parent Sip (CLT panel) entity |

#### Hardware Description Format

**Example**: `"Wigluv 150;OuterEdge;Floor;"`

| Field | Possible Values | Meaning |
|-------|----------------|---------|
| **Tape Name** | Wigluv 60, Wigluv 150, etc. | Product identifier |
| **Edge Type** | OuterEdge, OpeningEdge | Perimeter vs. internal opening |
| **Floor/Wall** | Floor, Wall | Panel orientation for detailing |

### Extended Properties (MapXData)

The script writes summary data to the **parent Sip entity** under `ExtendedProperties\Tape`:

```c
Map mapXtape;
mapXtape.setDouble("TotalLength0", 12500.0);  // Total mm for Width0
mapXtape.setDouble("Width0", 150.0);          // Tape width (mm)
mapXtape.setDouble("TotalLength1", 3200.0);   // Total mm for Width1
mapXtape.setDouble("Width1", 60.0);           // Tape width (mm)
sip.setSubMapX("Tape", mapXtape);
```

**Use Cases:**
- Summary reports showing total tape per panel
- Cost estimation (multiply TotalLength × unit price)
- Verification (compare calculated vs. actual edge lengths)
- Integration with external ERP/MRP systems

### Bill of Materials Integration

**Hardware entries can be exported to:**
- hsbCAD BOM (Bill of Materials) reports
- Shop drawing material lists
- External XML/Excel exports
- ERP system integration (via hsbCAD export tools)

**Filtering:**
- Filter by Category: "Tooling"
- Filter by Group: Element group name
- Filter by RepType: `_kRTTsl` to isolate tape hardware

---

## Shop Drawing Integration

### Paper Space Visualization

While the script runs in **Model Space**, it creates **shop drawing requests** compatible with Paper Space layouts:

#### Generated Drawing Elements

1. **PlaneProfile Tape Symbols**
   - Stereotype: "PlaneProfileTape"
   - View-dependent: Shows only in plan views (perpendicular to panel face)
   - Width: `TapeWidthFront` parameter from XML (default 30mm)
   - Color/Transparency: From display settings

2. **Visual Properties**
   - **Filled representation** (not just outlines)
   - **Transparent** for layering with panel details
   - **View direction filtering** (hides in edge views)

#### Shop Drawing Request Structure

The script stores drawing requests in `_Map["DimRequest[]"]`:

```c
Map mapRequestPlaneProfileI;
mapRequestPlaneProfileI.setString("Stereotype", "PlaneProfileTape");
mapRequestPlaneProfileI.setPlaneProfile("PlaneProfile", ppTape);
mapRequestPlaneProfileI.setVector3d("AllowedView", -vecZ);
mapRequestPlaneProfileI.setInt("AlsoReverseDirection", true);
mapRequestPlaneProfileI.setInt("Color", iColor);
mapRequestPlaneProfileI.setInt("DrawFilled", _kDrawFilled);
mapRequestPlaneProfileI.setInt("ShowForDirOfView", true);
mapRequestPlaneProfileI.setInt("ShowForOppositeDirOfView", true);
```

**View Control:**
- `AllowedView`: Shows in plan view (looking down panel face)
- `AlsoReverseDirection`: Shows from both sides
- `ShowForDirOfView`: Enables top view
- `ShowForOppositeDirOfView`: Enables bottom view

### Integration with Shop Drawing Scripts

These requests can be consumed by:
- `sd_*` shop drawing scripts
- `HSB_D-*` display scripts
- Custom layout generation tools

---

## Advanced Features

### Panel Movement Tracking

**Problem**: When users move/rotate a panel, tape instances could lose their edge association.

**Solution**: The script stores **relative coordinates** in `_Map`:

```c
_Map.setDouble("dXclosest", dXclosest);  // X offset from panel center
_Map.setDouble("dYclosest", dYclosest);  // Y offset from panel center
_Map.setDouble("dXclosestPtg0", ...);    // Grip 0 relative position
_Map.setDouble("dYclosestPtg0", ...);
_Map.setDouble("dXclosestPtg1", ...);    // Grip 1 relative position
_Map.setDouble("dYclosestPtg1", ...);
```

**Recalculation Logic:**
1. Detect panel has moved (compare current `ptCen` to stored position)
2. Reconstruct absolute positions from stored relative coordinates
3. Find closest edge to reconstructed position
4. Re-apply tape to correct edge
5. Preserve grip adjustments

**User Experience:**
- Move panel → tapes follow automatically
- Rotate panel → tapes update to new edge orientations
- No manual intervention required

### Lap Joint Optimization (Version 1.6)

**Challenge**: At panel corners, multiple tape segments could overlap or leave gaps.

**Improvement (HSB-13767)**:
- Analyzes corner geometry
- Calculates optimal tape segmentation
- Avoids double-coverage at joints
- Ensures continuous air barrier

**Technical Implementation:**
- Detects adjacent edges meeting at corners
- Adjusts tape endpoints to avoid overlap
- Creates clean transitions at lap joints

### Performance Optimization

**Speed Enhancements:**

1. **Shadow Profile vs. Slice**: Uses `realBody().shadowProfile()` instead of `getSlice()` for faster edge extraction
2. **Conditional Updates**: Only recalculates edge map when panel geometry changes
3. **Execution Loops**: Uses `setExecutionLoops(2)` for two-pass hardware finalization
4. **Caching**: Stores edge geometry in `_Map["Edges"]` to avoid repeated calculations

**Version 1.3 Optimizations:**
- Panel reference tracking reduces recalculation triggers
- Improved edge detection algorithms
- Faster grip point updates

### Arc Edge Approximation

**Process:**

1. **Detection**: Identifies curved edges by comparing original polyline to line-approximation
2. **Conversion**: Breaks arcs into 10mm linear segments (`convertToLineApprox(U(10))`)
3. **Tape Application**: Each segment receives tape aligned with local tangent
4. **Visual Smoothness**: Small segments create visually smooth curves

**Quality Settings:**
- 10mm approximation balances accuracy vs. performance
- Finer approximation possible by editing `U(10)` to smaller value
- Trade-off: More segments = slower calculation + more hardware entries

---

## Workflow Examples

### Example 1: Sealing a Standard CLT Floor Panel

**Scenario**: 3m × 6m CLT floor panel, 120mm thick, rectangular

**Steps:**
1. Launch script: `TSLINSERT` → `hsbCLT-Tape.mcr`
2. Select **single panel** (for demonstration)
3. **Manual Mode** activates → Press **Enter** to accept automatic generation
4. Script applies tape to all 4 edges
5. Review in Properties:
   - Hardware shows 4 tape segments
   - Each segment: Wigluv 150 (120mm + 70mm = 190mm requirement)
   - Total length: ~18m (perimeter)

**Result:**
- Complete perimeter sealing
- Hardware list: 1× Wigluv 150, 18m total
- Ready for shop drawing export

### Example 2: Batch Processing Multiple Panels

**Scenario**: 12 CLT floor panels on a building level

**Steps:**
1. Launch script
2. Select **all 12 panels** at once
3. Press **Enter**
4. Script processes all panels simultaneously

**Result:**
- 12 tape instances created (one per panel)
- Each panel has tapes on all edges
- Hardware consolidated by panel group
- ~5-10 seconds processing time

**Efficiency:**
- Manual method: ~10 minutes
- Automatic method: ~10 seconds
- 60× time savings

### Example 3: Custom Sealing Around Window Opening

**Scenario**: CLT wall panel with large window cutout, need tape on opening edges only

**Steps:**
1. Launch script
2. Select **single panel**
3. **Manual Mode** → Hover over opening edge
4. Click to apply tape to first opening edge
5. **Esc** to finish (don't seal outer perimeter)
6. Repeat for other opening edges if needed

**Result:**
- Selective sealing around window
- Outer perimeter unsealed (as intended)
- Precise control over tape placement

### Example 4: Converting Automatic to Manual for Adjustments

**Scenario**: Automatic mode applied tapes, but one edge needs shorter coverage

**Steps:**
1. Right-click on **Automatic instance**
2. Select **"Edit in Place"**
3. Script creates individual Manual instances
4. Select problematic edge instance
5. Drag **grip points** to shorten tape
6. Leave other edges unchanged

**Result:**
- Most edges: Full automatic coverage
- One edge: Custom shortened coverage
- Individual hardware entries for each edge

---

## Troubleshooting

### Common Issues and Solutions

#### Issue: "Version Mismatch" Warning

**Symptom:**
```
A different Version of the settings has been found for hsbCLT-Tape
Current Version: 1    [DWG path]
Other Version: 2      [Installation path]
```

**Cause**: TapeCatalog.xml version in drawing differs from installation default

**Solution:**
1. **Informational Only**: Both versions work, no action required
2. **To Update**: Copy newer `TapeCatalog.xml` to company folder
3. **To Suppress**: Ensure both locations have same version number

**Prevention:**
- Maintain consistent TapeCatalog.xml across all projects
- Update company XML when hsbCAD is updated

#### Issue: No Tape Products Found / Wrong Tape Selected

**Symptom**: Script applies incorrect tape width or reports missing products

**Diagnosis:**
1. Check TapeCatalog.xml exists at company/install path
2. Verify XML structure matches expected format
3. Check for Siga/Wigluv manufacturer/family names (case-sensitive)
4. Validate product widths in meters (e.g., 0.15 not 150)

**Solution:**
1. Open TapeCatalog.xml in text editor
2. Verify structure:
   ```xml
   <lst nm="Manufacturer[]">
     <lst nm="Manufacturer">
       <str nm="Name" vl="Siga"/>  <!-- Exact match required -->
       <lst nm="Family[]">
         <lst nm="Family">
           <str nm="Name" vl="Wigluv"/>  <!-- Exact match required -->
   ```
3. Correct any typos or structural errors
4. Reload script

#### Issue: Edges Not Receiving Tape

**Symptom**: Some panel edges have no tape applied in Automatic mode

**Possible Causes:**
1. **Invalid Edge Geometry**: Boolean operation failures creating unclosed loops
2. **Complex Curves**: Very tight radii or multi-arc segments
3. **Thickness Mismatch**: No product available for edge thickness
4. **Opening Detection**: Edge classified as internal when it should be external

**Diagnosis Steps:**
1. Inspect panel with `HSB_D-Element` to visualize geometry
2. Check for Boolean tool residue (failed cuts/drills)
3. Measure edge thickness and compare to catalog products
4. Review debug output (enable via `hsbTSLDebugController`)

**Solutions:**
- **Geometry Fix**: Rebuild panel with clean Boolean operations
- **Catalog Update**: Add wider/narrower tape products to XML
- **Manual Override**: Use Manual mode to force tape on problematic edge
- **Edge Simplification**: Convert complex curves to straight segments

#### Issue: Tape Disappears After Panel Move

**Symptom**: Moving panel causes tape instance to lose association

**Diagnosis:**
1. Check if tape instance is in Manual or Automatic mode
2. Verify `_Map` contains relative coordinate data
3. Test with debug mode enabled

**Solution:**
1. **Automatic Mode**: Should auto-update (if not, script bug—report)
2. **Manual Mode**: Verify grip points stored in `_Map`
3. **Workaround**: Delete old instance, re-apply tape after move
4. **Prevention**: Use Automatic mode for panels that will be moved frequently

#### Issue: Grip Points Not Appearing (Manual Mode)

**Symptom**: No grip points after edge selection

**Cause**: Script state machine not completing insertion cycle

**Solution:**
1. Check if `_PtG` array populated (should have 2 points)
2. Verify `setExecutionLoops(2)` called during insertion
3. Try re-inserting on same edge
4. Check AutoCAD grip point settings (may be globally disabled)

#### Issue: Hardware List Shows Incorrect Quantities

**Symptom**: BOM shows wrong tape lengths or duplicate entries

**Diagnosis:**
1. Check for multiple overlapping tape instances on same panel
2. Verify `RepType = _kRTTsl` filter in BOM export
3. Inspect `_ThisInst.hardWrComps()` array

**Solution:**
1. **Duplicates**: Delete extra instances, use "Edit in Place" carefully
2. **Overlap Allowance**: Remember script adds 200mm to each segment for `dScaleX`
3. **Recalculation**: Trigger recalc with `TSLRECALC` command
4. **BOM Filter**: Ensure BOM script filters by correct RepType

---

## Tips and Best Practices

### Design Workflow

1. **Model First, Seal Later**: Complete all panel geometry (cuts, drills, openings) before applying tape
2. **Batch When Possible**: Select all similar panels for automatic processing
3. **Manual for Exceptions**: Use Manual mode only for custom cases
4. **Group Panels**: Assign panels to Element groups before sealing for better hardware organization

### Performance Optimization

1. **Minimize Recalculations**: Avoid unnecessary panel edits after tape application
2. **Use Automatic Mode**: Faster than individual Manual edge selections
3. **Simplify Geometry**: Convert complex curves to straight segments when aesthetically acceptable
4. **Disable Visual Styles**: Work in 2D Wireframe for faster screen updates during batch processing

### Quality Control

1. **Visual Inspection**: Use transparency to verify tape doesn't obscure important details
2. **Hardware Verification**: Export BOM after sealing to verify quantities
3. **Edge Coverage Check**: Zoom in on corners to verify lap joint quality
4. **Shop Drawing Preview**: Generate test layout to verify 2D symbol appearance

### Customization

1. **Company Catalog**: Copy TapeCatalog.xml to company folder for custom products
2. **Display Tweaking**: Adjust Color/Transparency for better visibility in your templates
3. **Product Addition**: Add regional tape brands following existing XML structure
4. **Width Preferences**: Modify selection logic by editing product widths

### Collaboration

1. **Standard Catalog**: Maintain single company TapeCatalog.xml for all users
2. **Version Control**: Track XML changes in version control system
3. **Documentation**: Document custom products in company standards manual
4. **Training**: Train users on Automatic vs. Manual mode selection criteria

---

## Technical Details for Advanced Users

### Internal Data Structures

#### Edge Map Structure

The script stores detailed edge geometry in `_Map["Edges"]`:

```c
Map mapEdges;
  Map mapEdgeI;  // Per edge (index 0, 1, 2, ...)
    .setInt("Outter", 1/0);              // Outer perimeter vs. opening
    .setInt("Straight", 1/0);            // Straight vs. arc
    .setPLine("Pline", plEdge);          // 2-point edge polyline
    .setDouble("EdgeThickness", dH);     // Panel thickness at edge
    .setVector3d("vecEdgeOutter", vec);  // Outward normal
    .setPoint3d("ptEdge", ptMid);        // Edge midpoint
    .setPoint3d("ptEdgeStart", pt1);     // Start point
    .setPoint3d("ptEdgeEnd", pt2);       // End point
    .setMap("pps", mapProfiles);         // 3D edge profiles
    .setMap("ppsTop", mapProfilesTop);   // Top view profiles
```

**Usage:**
- Consumed by both Automatic and Manual modes
- Persists across recalculations for performance
- Updated only when `iUpdateMap = true`

#### Automatic vs. Manual Flag

Stored in `_Map["Automatic"]`:
- `true`: Automatic mode (all edges, batch processing)
- `false`: Manual mode (single edge, grip editing)

**Mode Switching:**
- Automatic → Manual: "Edit in Place" command
- Manual → Automatic: Not supported (would require deleting individual instances)

### Coordinate System Tracking

The script maintains **panel-relative coordinates** for movement tracking:

**Panel Coordinate System:**
```c
Point3d ptCen = sip.ptCen();      // Panel center
Vector3d vecX = sip.vecX();       // Panel local X
Vector3d vecY = sip.vecY();       // Panel local Y
Vector3d vecZ = sip.vecZ();       // Panel local Z (normal)
```

**Relative Storage (Manual Mode):**
```c
Vector3d vecClosest = ptMid - ptCen;
double dXclosest = vecX.dotProduct(vecClosest);
double dYclosest = vecY.dotProduct(vecClosest);
_Map.setDouble("dXclosest", dXclosest);
_Map.setDouble("dYclosest", dYclosest);
```

**Reconstruction After Move:**
```c
Vector3d vecClosestRef = vecX * dXclosest + vecY * dYclosest;
Point3d ptMidClosestRef = ptCen + vecClosestRef;
```

### Display System Architecture

**Multi-View Display Strategy:**

1. **Model Display** (`dpModel`):
   - Shows 3D tape profile (actual cross-section)
   - Visible from all view directions
   - Filled PlaneProfiles with transparency

2. **Front Display** (`dpFront`):
   - Shows 2D tape symbol (plan view)
   - **View filtering**: Only visible perpendicular to panel
   - Width controlled by `TapeWidthFront` parameter
   - Hides in edge views to avoid clutter

**View Direction Filtering:**
```c
dpFront.addViewDirection(vecZ);      // Show when looking at panel top
dpFront.addViewDirection(-vecZ);     // Show when looking at panel bottom
dpFront.addHideDirection(vecX);      // Hide in X edge view
dpFront.addHideDirection(-vecX);
dpFront.addHideDirection(vecY);      // Hide in Y edge view
dpFront.addHideDirection(-vecY);
```

### Jig System (Interactive Highlighting)

**Jig Actions:**
- `strJigAction1`: Edge proximity detection
- `strJigAction2`: (Reserved for future use)

**Jig Process:**
1. User moves cursor over panel
2. Script captures `_PtJig` (cursor position)
3. Projects point onto panel plane
4. Calculates distance to all edges
5. Highlights closest edge if within tolerance
6. Updates display every cursor movement

**Performance:**
- Uses pre-calculated edge map (not real-time geometry)
- Proximity check optimized with line segment math
- Visual update throttled to screen refresh rate

### Hardware Component Details

**HardWrComp Initialization:**
```c
HardWrComp hwc(sArticleNumber, nQuantity);
hwc.setCategory("Tooling");
hwc.setRepType(_kRTTsl);  // TSL-generated marker
hwc.setGroup(sGroupName);
hwc.setLinkedEntity(sip);
hwc.setDescription("Wigluv 150;OuterEdge;Floor;");
hwc.setArticleNumber("7510-15025");
hwc.setDScaleX(dLength + U(200));  // Length + overlap
hwc.setDScaleY(dWidth * 1000);     // Width in mm
```

**RepType Filtering:**
- `_kRTTsl`: Marks hardware as script-generated
- Allows script to delete/update its own hardware without affecting manual entries
- BOM exports can filter by RepType to separate TSL vs. manual hardware

### Execution Loop Strategy

**Multi-Pass Processing:**
```c
if (_bOnDbCreated) setExecutionLoops(2);
```

**Why 2 Loops?**
1. **First Loop**: Calculate edge geometry, set up initial state
2. **Second Loop**: Finalize hardware, update display, write MapXData

**Benefits:**
- Ensures panel geometry fully evaluated before hardware creation
- Allows dependent calculations to complete
- Prevents race conditions with AutoCAD entity updates

---

## Related Scripts and Integration

### Complementary Scripts

#### CLT Panel Creation
- **hsbCLT-MasterPanelManager**: Creates CLT panels from design data
- **hsbCreateElement**: Converts panels to Elements for group management
- **hsbCLT-Opening**: Adds door/window cutouts (run before tape application)

#### Edge Treatment
- **hsbCLT-Dovetail**: Creates joinery on panel edges
- **hsbCLT-TongueGroove**: Adds tongue-and-groove profiles
- **hsbCLT-Rabbet**: Creates recessed joints
- **hsbCLT-Slot**: Adds spline slots along edges

#### Hardware and Fasteners
- **hsbCLT-X-Fix-L**: Angle brackets (complements tape sealing)
- **hsbCLT-Hilti**: Anchoring systems
- **hsbCLT-Drill-Distribution**: Pre-drilling for connectors

#### Shop Drawings
- **sd_ABeamcutDE**: Shop drawing generation (consumes DimRequest data)
- **HSB_D-Element**: Element visualization
- **HSB_G-BillOfMaterial**: Hardware export to BOM

### Workflow Integration Points

**Upstream Dependencies:**
1. CLT panels must exist (created by MasterPanelManager or manual)
2. Openings should be finalized (via hsbCLT-Opening)
3. Panels assigned to Element groups (optional, for BOM organization)

**Downstream Consumers:**
1. Shop Drawing scripts read `DimRequest[]` for layout symbols
2. BOM scripts aggregate hardware by group/category
3. CNC export tools may reference tape locations for handling notes

### Suite Membership

**hsbCLT-Tape is a standalone tool** (no parent/child relationships detected).

**Complementary Suite Recommendations:**
- Often used alongside **hsbCLT-Opening** in opening detailing workflows
- Integrated with **HSB_G-BillOfMaterial** for material tracking
- Precedes **shop drawing scripts** in fabrication workflow

---

## Appendix

### Command Reference

| Command | Purpose |
|---------|---------|
| `TSLINSERT` | Standard TSL insertion command |
| `TSLRECALC` | Force recalculation of selected instance |
| `TSLCONTENT` | Custom command (if defined) for quick access |

### Keyboard Shortcuts

| Key | Context | Function |
|-----|---------|----------|
| **Enter** | Edge selection prompt | Accept automatic generation |
| **Esc** | Edge selection | Cancel selection, finalize current tapes |
| **Left Click** | Edge highlighting | Apply tape to highlighted edge |
| **Grip Drag** | Manual instance | Adjust tape start/end points |

### File Locations

| File | Path | Purpose |
|------|------|---------|
| **hsbCLT-Tape.mcr** | `[Install]\TSL\` | Main script file |
| **TapeCatalog.xml** | `[Company]\TSL\Settings\` | Company catalog (priority) |
| **TapeCatalog.xml** | `[Install]\Content\General\TSL\Settings\` | Default catalog (fallback) |

### XML Reference

**Supported Data Types:**
- `<str nm="Name" vl="Value"/>` - String
- `<dbl nm="Width" ut="L" vl="0.15"/>` - Double with unit
- `<int nm="Color" vl="1"/>` - Integer
- `<lst nm="Array[]">` - List/Array container

**Unit Types:**
- `ut="L"` - Length (millimeters when `uv="millimeter"`)
- No unit type - Dimensionless number

### Terminology

| Term | Definition |
|------|------------|
| **Sip** | hsbCAD entity representing CLT panel (Structural Insulated Panel heritage) |
| **Automatic Mode** | Batch processing mode applying tape to all edges |
| **Manual Mode** | Interactive mode for precise edge selection |
| **Jig** | Real-time cursor feedback during edge selection |
| **Grip Point** | AutoCAD edit handle for adjusting tape endpoints |
| **Edge Map** | Internal data structure storing panel edge geometry |
| **Hardware Component** | Material list entry for BOM integration |
| **DimRequest** | Shop drawing visualization request |
| **RepType** | Hardware component type flag (`_kRTTsl` for TSL-generated) |
| **MapXData** | Extended entity data stored in AutoCAD object dictionary |

### Support and Feedback

**Debug Mode:**
Enable via `hsbTSLDebugController` MapObject to output diagnostic messages.

**Version Information:**
- Current version shown in script header: `#MajorVersion 1` `#MinorVersion 6`
- XML version tracked in `GeneralMapObject\Version`

**Issue Reporting:**
Reference script name (`hsbCLT-Tape`) and version (1.6) when reporting issues.

---

## Summary

**hsbCLT-Tape** is a production-ready tool for air-tightness sealing in CLT construction. Its dual-mode operation (Automatic for speed, Manual for precision) makes it suitable for both standardized and custom detailing workflows. The intelligent product selection, panel movement tracking, and comprehensive hardware integration ensure reliable material lists and shop drawings for fabrication.

**Key Takeaways:**
- **Automatic Mode**: Select multiple panels → instant batch processing
- **Manual Mode**: Select single panel → precise edge control with grip editing
- **Edit in Place**: Convert Automatic to Manual for hybrid workflows
- **Hardware Integration**: Automatic BOM generation with article numbers and quantities
- **Shop Drawings**: Plan view symbols compatible with Paper Space layouts
- **Customization**: XML-based product catalog for company-specific tapes

**Recommended Workflow:**
1. Complete panel modeling (geometry, openings, cuts)
2. Run hsbCLT-Tape in Automatic mode for standard panels
3. Use "Edit in Place" + grip editing for exceptions
4. Export hardware to BOM for material ordering
5. Generate shop drawings with integrated tape symbols

For most users, **Automatic Mode + Edit in Place** provides the optimal balance of speed and control.
