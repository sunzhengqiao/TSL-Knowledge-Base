# hsbCLT-Dovetail.mcr

## Overview

| Property | Value |
|----------|-------|
| **Script Name** | hsbCLT-Dovetail.mcr |
| **Version** | 1.4 |
| **Last Updated** | 12-Dec-2017 |
| **Author** | thorsten.huck@hsbcad.com |
| **Type** | Object (O) |
| **Category** | CLT Panel Connection |

This script creates a **dovetail** or **butterfly spline** connection between two CLT (Cross-Laminated Timber) panels. It mechanically interlocks panels by cutting matching male and female profiles at panel edges. The script can automatically split a single panel into two connected panels or create connections between existing adjacent panels.

**Key Features:**
- Two connection types: Dovetail (male/female) and Butterfly Spline (double-sided female)
- Automatic panel splitting when working with a single panel
- Multi-panel batch processing with automatic edge detection
- Chamfer options for aesthetic edge finishing
- Automatic hardware assignment for butterfly spline mode

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| **Model Space** | Yes | Primary workspace - operates on Sip entities in 3D |
| **Paper Space** | No | Not applicable |
| **Shop Drawing** | No | Machining data generated in model, exported separately |

## Prerequisites

- **Required Entities**:
  - **Sip** (CLT Panel) entities - minimum 2 for connection, or 1 panel that will be split
  - Alternatively, an **ElementWall** containing Sip sub-elements
- **Minimum Beam Count**: 0 (script detects panels internally)
- **Required Settings**: None

---

## Usage Steps

### Workflow A: Single Panel Split + Connect

Use this workflow when you have ONE panel that needs to be split and connected.

**Step 1: Launch Script**
- Command: `TSLINSERT` or `TSL`
- Select `hsbCLT-Dovetail` from the script list

**Step 2: Select Panel**
- Command Line: `Select panel(s), <Enter> to select a wall`
- Click on the single Sip panel you want to split

**Step 3: Define Split Line**
- Command Line: `Select first split point on plane`
- Click the first point on the panel face
- Command Line: `Select second point`
- Click the second point to define the split direction

**Step 4: Projection Options (Roof Panels Only)**
If the panel is not vertical (roof/sloped), you will be prompted:
- Command Line: `Projection of splitting points: [Bottom face/Axis/Top face/Not projected] <Axis>`
- Press **Enter** for axis projection (default), or type:
  - `B` for Bottom face projection
  - `T` for Top face projection
  - `N` for No projection (use exact clicked points)

The script will automatically:
1. Split the panel at the defined line
2. Create the dovetail connection between the two resulting panels
3. Generate the machining cuts

---

### Workflow B: Multiple Panels - Automatic Detection

Use this workflow when you have TWO or MORE adjacent panels to connect.

**Step 1: Launch Script**
- Command: `TSLINSERT` or `TSL`
- Select `hsbCLT-Dovetail` from the script list

**Step 2: Select Panels**
- Command Line: `Select panel(s), <Enter> to select a wall`
- Click and select multiple adjacent Sip panels
- Press **Enter** to confirm selection

**Step 3: Specify Connection Location**
- Command Line: `Select point closed to the desired lap joint, <Enter> for all connections`
- **Option A**: Click near a specific edge to create one connection
- **Option B**: Press **Enter** to automatically create connections at ALL detected adjacent edges

**Step 4: Specify Direction (if prompted)**
- Command Line: `Specify direction, <Enter> for default direction`
- If multiple parallel edges exist, click a point to define which direction the male profile faces
- Press **Enter** to use automatic direction detection

The script will create one instance per detected connection.

---

### Workflow C: Wall Element Mode

Use this workflow when working with ElementWall entities.

**Step 1: Launch Script**
- Command: `TSLINSERT` or `TSL`
- Select `hsbCLT-Dovetail` from the script list

**Step 2: Select Wall or Skip Selection**
- Press **Enter** when prompted for panel selection
- Command Line: `Select Element:`
- Click on an ElementWall entity

**Step 3: Define Insertion Point**
- Click on the wall face where the split/connection should occur

The script will:
1. Detect all Sip panels within the ElementWall
2. Split panels at the insertion point
3. Create dovetail connections automatically

---

## Properties Panel Parameters

Access via Properties Palette (Ctrl+1) after selecting the script instance.

### Geometry Category

| Parameter | Type | Default | Unit | Description |
|-----------|------|---------|------|-------------|
| **(A) Width** | PropDouble | 50 | mm | Depth of the lap joint from the reference side. Set to **0** to automatically use 50% of panel thickness |
| **(B) Depth** | PropDouble | 28 | mm | Width of the lap joint (overlap distance between panels) |
| **(C) Angle** | PropDouble | 0 | degrees | Taper angle of the dovetail sides. A non-zero angle creates the classic dovetail wedge shape |
| **(D) Gap X** | PropDouble | 1 | mm | Clearance gap in the depth direction. Allows for manufacturing tolerances and glue space |

### Alignment Category

| Parameter | Type | Default | Unit | Description |
|-----------|------|---------|------|-------------|
| **(E) Axis Offset X** | PropDouble | 0 | mm | Horizontal offset of the tool profile from the insertion point. Shifts the connection left/right |
| **(F) Bottom Offset** | PropDouble | 0 | mm | Vertical offset from bottom. **0 = through-connection**. Use positive values to start the connection above the panel bottom |

### Connection Type

| Parameter | Type | Options | Default | Description |
|-----------|------|---------|---------|-------------|
| **(G) Connection Type** | PropString | Dovetail / Butterfly Spline | Dovetail | **Dovetail**: Creates male profile on one panel, female on the other. **Butterfly Spline**: Creates female profiles on BOTH panels for a separate key insert |

### Reference Side Category

| Parameter | Type | Default | Unit | Description |
|-----------|------|---------|------|-------------|
| **(H) Chamfer** | PropDouble | 0 | mm | Chamfer size on the Reference Side (Side 0). Adds a 45-degree bevel to the joint edges |

### Opposite Side Category

| Parameter | Type | Default | Unit | Description |
|-----------|------|---------|------|-------------|
| **(I) Chamfer** | PropDouble | 0 | mm | Chamfer size on the Opposite Side (Side 1). Adds a 45-degree bevel to the joint edges |

---

## Context Menu Options (Right-Click)

Right-click on the script instance to access these options:

| Menu Item | Available In | Description |
|-----------|--------------|-------------|
| **Flip Side** | Wall Mode | Inverts which face of the element the connection is applied to. Also triggered by **Double-Clicking** the instance |
| **Flip Direction** | Dovetail Mode | Reverses the direction of the dovetail (swaps male and female panels) |
| **Add Panel(s)** | Panel Mode | Add additional panels to the existing connection |
| **Remove Panel(s)** | Panel Mode | Remove panels from the connection. Female panels will have their edges restored to original position |
| **Edit in Place** | Panel Mode | Enable grip editing to manually adjust the connection extent along the edge |
| **Disable Edit in Place** | Panel Mode | Exit grip editing mode |

---

## Connection Type Comparison

### Dovetail Mode
- Creates **male** profile on one panel
- Creates **female** profile on the adjacent panel
- Panels interlock directly
- No additional hardware required
- Best for: Direct panel-to-panel connections

### Butterfly Spline Mode
- Creates **female** profile on **BOTH** panels
- Requires a separate key/butterfly insert (not generated by script)
- Automatically assigns **X-fix L** hardware component for BOM
- Hardware model name includes dimensions: `X-fix L[Depth] x [Width]`
- Best for: Repair joints, alignment keys, situations requiring removable connections

---

## Visual Indicators

The script displays symbols in the model to indicate connection type and direction:

- **Dovetail symbol**: Arrow/trapezoid shape pointing toward the female panel
- **Butterfly symbol**: Hourglass/butterfly shape centered on the joint
- **Plan view**: Symbol is visible when viewing perpendicular to panel face
- **Panel view**: Symbol visible when viewing along the joint line

---

## Tips and Best Practices

### Design Considerations
1. **Width Setting**: Use `(A) Width = 0` for automatic 50% thickness calculation - ensures balanced load transfer
2. **Gap for Glue**: Set `(D) Gap X` to 1-2mm when using adhesive to allow for squeeze-out
3. **Angle Selection**:
   - `0 degrees` = Straight lap joint (easiest to manufacture)
   - `5-15 degrees` = Traditional dovetail angle (self-locking)
4. **Chamfer Values**: Match chamfer size to your manufacturing capabilities and aesthetic requirements

### Workflow Efficiency
- **Double-Click** to quickly flip the connection side in Wall Mode
- Select **multiple panels at once** for batch connection creation
- Press **Enter** at the connection location prompt to auto-connect all detected edges

### Troubleshooting
| Issue | Solution |
|-------|----------|
| "Two male panels cannot be connected" | The selected panels have incompatible orientations. Use Flip Direction or re-select panels |
| "requires at least 2 panels" | Script needs minimum 2 panels to create a connection. Select more panels or use single-panel split mode |
| Panel disappeared after insert | The panel was split. Check for the new panel created adjacent to the original |
| Connection not at expected location | Click closer to the desired edge, or use single-panel mode for precise control |
| "no common range" | Panels do not have overlapping edges. Verify panels are adjacent and coplanar |

---

## Related Scripts

| Script | Purpose |
|--------|---------|
| hsbCLT-T-Connector | T-shaped panel connections |
| hsbCLT-X-Fix-Connector | X-Fix connection systems |
| hsbCLT-Slot | Slot-based connections |
| hsbCLT-Rabbet | Rabbet/rebate connections |
| hsbCLT-TongueGroove | Tongue and groove connections |

---

## Technical Notes

### Machining Data
- The script generates **Dove** tools applied to the Sip entities
- **BeamCut** helper tools are created but **excluded from CNC export** (`excludeMachineForCNC(_kAnyMachine)`)
- Helper cuts ensure correct visual representation in the model without affecting manufacturing

### Hardware Assignment
- **Dovetail mode**: No hardware assigned
- **Butterfly Spline mode**: Automatically assigns `X-fix L` hardware component
  - Category: Connector
  - Manufacturer: Greenethic
  - Scaled dimensions match connection size

### Update Behavior
- Script automatically recalculates when panels are moved
- Stretch operations on connected panels are supported
- Opening/void intersections are preserved through connection modifications

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.4 | 12-Dec-2017 | Helper beamcuts do not export to any machine |
| 1.3 | 24-May-2017 | Article name of hardware changed to X-fix L |
