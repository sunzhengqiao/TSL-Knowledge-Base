# hsbCLT-Hilti

## Overview

**hsbCLT-Hilti** is a comprehensive TSL script for automating the insertion and distribution of **Hilti HCWL (Heavy Connector Wood - Long)** connections between Cross-Laminated Timber (CLT) panels in hsbCAD. This professional-grade connector system is designed specifically for assembling prefabricated timber structures with faster installation and improved structural performance.

The HCWL system combines a wood coupler with various fastener types (hanger bolts for timber-to-timber connections or anchor bolts for timber-to-concrete connections) to create robust structural connections for CLT construction.

### Key Capabilities

- **Male-Female Panel Connections**: Automatically connects two perpendicular CLT panels with intelligent side detection
- **Single Panel Connections**: Connects CLT panels to concrete floors or walls
- **Flexible Distribution**: Supports both fixed-spacing and even-spacing distribution along connection zones
- **Single-Point Insertion**: Places individual connectors at user-specified locations
- **Automatic Machining**: Generates precise mortises and pilot holes on panels
- **Hardware Integration**: Automatically generates BOM entries with manufacturer specifications
- **Visual Representation**: Displays connector positions using 3D blocks or circle symbols

## Usage Environment

| Property | Value |
|----------|-------|
| **Script Type** | O (Object) |
| **Environment** | Model Space |
| **Beams Required** | 0 (panels selected during insertion) |
| **Major Version** | 1 |
| **Minor Version** | 10 |
| **File State** | Released (1) |
| **Implicit Insert** | Yes (1) |

### Environment Compatibility

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | ✓ Yes | Primary environment - required for 3D operations and panel selection |
| Paper Space | ✗ No | Not supported |
| Shop Drawing | ✗ No | Not supported |

## Prerequisites

Before using this script, ensure the following requirements are met:

### Panel Requirements

1. **Minimum Panel Thickness**: All CLT panels (Sip entities) must have a solid height of at least **80 mm**
2. **Panel Validity**: Panels must be valid Sip entities (not corrupted or invalid)
3. **Panel Orientation** (for male-female connections): Panels must be perpendicular to each other (90-degree angle)
4. **Panel Proximity** (for male-female connections): Panels must be within **50 mm** gap tolerance

### Optional Files

- **Block File**: `HCWL.dwg` should be placed in `[Company Path]\Block\` for accurate 3D visualization
  - If not found, the script still functions but displays only circle symbols

### Technical Knowledge

- Basic understanding of CLT panel terminology (male vs. female panels)
- Familiarity with hsbCAD panel selection methods
- Understanding of connector distribution concepts

## Connection Modes

The script operates in **5 distinct modes** based on connection type and distribution requirements:

### Mode 0: Initial Distribution (Batch Creation)

- **Trigger**: After selecting multiple male and female panels during insertion
- **Behavior**: Automatically creates separate TSL instances for each detected male-female pair
- **User Properties**: All distribution properties visible
- **Use Case**: Quickly apply connectors to multiple panel intersections in a building

### Mode 1: Male-Female Distribution

- **Configuration**: Two perpendicular panels with distribution along connection line
- **User Properties**: Full distribution control (Start Offset, End Offset, Interdistance)
- **Features**:
  - Automatic side detection (inner vs. outer connection face)
  - "Flip Side" context menu option
  - "Explode distribution" option to convert to individual instances

### Mode 2: Single Panel Distribution

- **Configuration**: One panel connected to concrete floor/wall
- **Selection**: User selects panel edge for connector placement
- **Features**:
  - Edge highlighting during selection
  - Distribution along selected edge
  - "Flip Side" for switching mounting face

### Mode 101: Single Point Male-Female

- **Trigger**: When Interdistance = 0 and two panels selected
- **Behavior**: Places one connector at user-specified point
- **User Properties**: Distribution properties hidden (Start/End Offset, Interdistance)
- **Use Case**: Precise connector placement at specific load points

### Mode 102: Single Point Single Panel

- **Trigger**: When Interdistance = 0 and one panel selected
- **Behavior**: Places one connector at user-specified point on panel edge
- **User Properties**: Distribution properties hidden
- **Use Case**: Special anchoring requirements or non-standard spacing

## Step-by-Step Usage Guide

### Scenario A: Connecting Two Perpendicular Panels (Male-Female)

This is the most common use case for connecting CLT wall panels at corners or wall-to-floor connections.

#### Step 1: Launch the Script

```
Command: TSLINSERT
[Select "hsbCLT-Hilti" from the TSL browser]
```

or use the custom command:
```
Command: TSLCONTENT
```

#### Step 2: Configure Properties Dialog

The Properties dialog appears automatically. Configure the following parameters:

**General Category:**
- **Connection Type**: Select `male-female`

**Distribution Category:**
- **Rule**: Choose distribution method
  - `Fixed Distribution`: Constant spacing (e.g., every 1000 mm)
  - `Even Distribution`: Auto-calculated even spacing
- **Start Offset**: Distance from connection start (minimum 72 mm, default 350 mm)
- **End Offset**: Distance from connection end (minimum 72 mm, default 350 mm)
- **Interdistance**: Spacing between connectors (default 1000 mm)
  - Set to `0` for single-point insertion mode
- **Offset Y**: Vertical offset in height direction (minimum -80 mm, default 0 mm)
- **Depth**: Milling depth at female panel (default 0 mm)

**Position Setting:**
- **Position**: Mounting position of connector
  - `Panel Outside` (Z-offset 0 mm): Connector on exterior surface
  - `Milled in Strap` (Z-offset 3 mm): Partially recessed
  - `Flush` (Z-offset ~30 mm): Flush mount, requires deeper mortise

**Fasteners Category:**
- **Fastener**: Select fastener type
  - `None`: No fastener (HCWL only)
  - `HST3 M12x165`: Concrete bolt anchor, 165 mm (auto-switches to HSW for timber)
  - `HST3 M12x185`: Concrete bolt anchor, 185 mm (auto-switches to HSW for timber)
  - `HAS-U 8.8 M12x180`: Chemical anchor, 180 mm (auto-switches to HSW for timber)
  - `HAS-U 8.8 M12x200`: Chemical anchor, 200 mm (auto-switches to HSW for timber)
  - `Stockschraube HSW M12x220/60 8.8`: Hanger bolt for timber, 220 mm (recommended)
  - `Stockschraube HSW M12x140/60 8.8`: Hanger bolt for timber, 140 mm

> **Important**: For male-female timber connections, if you select a concrete anchor (HST3 or HAS-U), the script automatically switches to the appropriate hanger bolt (HSW series) because concrete anchors are not suitable for timber-to-timber joints.

#### Step 3: Select Male Panels

When prompted `"Select male panels"`:

1. Click on the panel(s) that will receive the **HCWL wood coupler**
2. The script validates each panel:
   - Checks for minimum 80 mm thickness
   - Verifies panel validity
   - Reports errors for invalid panels
3. Press `Enter` to confirm selection

**Selection Tips:**
- You can select multiple male panels
- Invalid panels are automatically removed from selection
- Error messages display panel position numbers for easy identification

#### Step 4: Select Female Panels

When prompted `"Select female panels"`:

1. Click on the perpendicular panel(s) that will receive the **fastener (HSW/HST3/HAS-U)**
2. The script validates thickness and validity
3. Press `Enter` to confirm selection

#### Step 5: Automatic Execution

The script automatically:

1. **Detects Male-Female Pairs**:
   - Checks perpendicularity (panels must be at 90 degrees)
   - Validates proximity (within 50 mm gap)
   - Uses shadow profile intersection analysis
2. **Determines Connection Side**:
   - Analyzes panel geometry to find inner/outer connection face
   - Automatically selects the appropriate mounting side
3. **Calculates Distribution Line**:
   - Finds common intersection zone between panels
   - Computes distribution line along panel junction
4. **Creates TSL Instances**:
   - One instance per detected male-female pair
   - Each instance manages its own distribution

**Result**: Connectors are distributed along panel joints according to your settings.

### Scenario B: Connecting a Single Panel to Concrete

This scenario is used for CLT wall panels anchored to concrete floors or foundation walls.

#### Step 1: Launch and Configure

1. Start the script (`TSLINSERT` → `hsbCLT-Hilti`)
2. Configure properties:
   - **Connection Type**: `single panel`
   - **Distribution**: Set offsets and interdistance
   - **Fastener**: Select concrete anchor (HST3 or HAS-U series)

#### Step 2: Select the Panel

When prompted `"Select the Panel"`:

1. Click on the CLT panel
2. Script validates thickness (≥ 80 mm)
3. If panel too thin: Error message `"Selected panel must have a thickness >= 80 mm"`

#### Step 3: Select Edge

The script enters **edge selection mode** with interactive highlighting:

1. Move cursor near panel edges
2. The script highlights the nearest edge with a visual indicator (colored rectangle)
3. **Click** to confirm edge selection, or
4. Type `Finish` and press `Enter` to exit without creating connection

**Edge Selection Features:**
- Real-time edge highlighting (nearest edge to cursor)
- Visual feedback in current view orientation
- Supports all panel edges (4 edges for rectangular panels)

#### Step 4: Connector Placement

**For Distributed Connectors** (Interdistance > 0):
- Connectors automatically distribute along selected edge
- Distribution respects Start Offset, End Offset, and Interdistance

**For Single Point Insertion** (Interdistance = 0):
- After edge selection, prompt: `"Select Insertion point"`
- Click to specify exact connector location
- Connector placed at clicked point along selected edge

#### Step 5: Repeat or Finish

- To add connectors to another edge: Click another point to select different edge
- To finish: Type `Finish` or press `Esc`

### Scenario C: Single Instance Placement (Precision Mode)

For precise connector placement at specific structural load points.

#### Configuration

Set **Interdistance = 0** in the Properties dialog before starting.

#### For Male-Female Connection

1. Select **one male panel** and **one female panel**
2. When prompted `"Select Insertion point"`:
   - Click the exact location for the connector
   - Point is automatically projected onto the connection line
3. Single connector placed at specified point

#### For Single Panel

1. Select the panel and the edge (as in Scenario B)
2. Click to specify exact insertion point along selected edge
3. Single connector placed at clicked location

**Use Cases:**
- Specific structural load transfer points
- Non-standard spacing requirements
- Reinforcement at openings or edges
- Compliance with engineered connection schedules

## Properties Panel Reference

### General Category

#### Connection Type

| Parameter | Connection Type |
|-----------|----------------|
| **Type** | PropString (dropdown selection) |
| **Default** | `single panel` |
| **Options** | `single panel`, `male-female` |
| **Description** | Defines the connection configuration |

**Details:**
- **single panel**: Connects one CLT panel to concrete floor/wall
  - Requires HCWL on panel + concrete anchor/bolt
  - User selects panel edge for distribution
- **male-female**: Connects two perpendicular CLT panels
  - HCWL on male panel, HSW hanger bolt on female panel
  - Automatic side detection and distribution line calculation

**Business Logic:**
- Selection of `male-female` triggers two-panel selection prompts
- Selection of `single panel` triggers edge selection workflow
- Property is hidden (read-only) after insertion to prevent mode conflicts

### Distribution Category

#### Rule (Distribution Method)

| Parameter | Rule |
|-----------|------|
| **Type** | PropString (dropdown selection) |
| **Default** | `Fixed Distribution` |
| **Options** | `Fixed Distribution`, `Even Distribution` |
| **Description** | Controls how connectors are spaced along the distribution line |

**Fixed Distribution:**
- Uses exact Interdistance value
- May result in leftover space at end if length is not evenly divisible
- **Formula**:
  - Number of connectors = floor((Length - Start Offset - End Offset) / Interdistance)
  - Last connector placed at: End - End Offset

**Even Distribution:**
- Calculates even spacing to fill available length
- Ensures connectors distributed evenly from start to end
- **Formula**:
  - Estimated connectors = floor((Length - Start Offset - End Offset) / Interdistance)
  - Actual spacing = (Length - Start Offset - End Offset) / Estimated connectors

**Recommendation:**
- Use **Fixed Distribution** when engineering specifies exact spacing (e.g., "1000 mm on center")
- Use **Even Distribution** for aesthetic purposes or to maximize connector count

#### Start Offset

| Parameter | Start Offset |
|-----------|-------------|
| **Type** | PropDouble (length) |
| **Default** | 350 mm |
| **Minimum** | 72 mm |
| **Unit** | Length (mm in metric, inches in imperial) |
| **Description** | Distance from start of connection zone to first connector |

**Technical Details:**
- **72 mm minimum** corresponds to connector geometry requirements (21 mm radius + tolerance)
- Offset measured along distribution direction
- For male-female: Start is determined by connection geometry
- For single panel: Start is at beginning of selected edge

**Validation:**
- If user enters value < 72 mm: Script sets to 72 mm and displays warning message

**Common Values:**
- **72 mm**: Minimum edge distance
- **150 mm**: Standard edge distance for structural loads
- **350 mm** (default): Conservative offset for typical applications

#### End Offset

| Parameter | End Offset |
|-----------|------------|
| **Type** | PropDouble (length) |
| **Default** | 350 mm |
| **Minimum** | 72 mm |
| **Unit** | Length (mm in metric, inches in imperial) |
| **Description** | Distance from end of connection zone to last connector |

**Same technical requirements as Start Offset.**

**Design Consideration:**
- Equal Start and End Offsets create symmetrical distribution
- Unequal offsets may be required for:
  - Proximity to panel edges
  - Adjacent openings or panel boundaries
  - Asymmetric structural loads

#### Interdistance

| Parameter | Interdistance |
|-----------|--------------|
| **Type** | PropDouble (length) |
| **Default** | 1000 mm |
| **Special Value** | 0 = Single-point insertion mode |
| **Unit** | Length (mm in metric, inches in imperial) |
| **Description** | Center-to-center spacing between consecutive connectors |

**Distribution Behavior:**
- **> 0**: Distribution mode (multiple connectors)
  - Value represents spacing between connector centers
  - Combined with Start/End Offsets to calculate total count
- **= 0**: Single-point mode
  - Disables distribution
  - User manually specifies each connector location
  - Distribution properties (Start/End Offset, Rule) hidden

**Common Values:**
- **400-600 mm**: Heavy load transfer, dense spacing
- **800-1000 mm**: Standard structural connections
- **1200-1500 mm**: Light loads or redundant connections

**Engineering Note:**
- Spacing should comply with Hilti HCWL design guidelines
- Consult structural engineer for load-bearing requirements
- Maximum spacing typically limited by structural code

#### Offset Y

| Parameter | Offset Y |
|-----------|----------|
| **Type** | PropDouble (length) |
| **Default** | 0 mm |
| **Minimum** | -80 mm |
| **Unit** | Length (mm in metric, inches in imperial) |
| **Description** | Vertical offset of connectors along the panel height direction |

**Direction:**
- **Positive values**: Shift connectors upward along panel height
- **Negative values**: Shift connectors downward along panel height
- **Zero**: Connectors at geometric center of connection zone

**Use Cases:**
1. **Panel Thickness Variation**:
   - Align connectors when connecting panels of different thicknesses
   - Example: 100 mm panel to 140 mm panel → Offset Y = -20 mm
2. **Eccentric Load Transfer**:
   - Shift connection point for moment-resisting connections
3. **Clash Avoidance**:
   - Adjust height to avoid conflicts with other hardware or MEP

**Validation:**
- Minimum -80 mm prevents excessive offset that would weaken connection
- No maximum limit (script allows unlimited positive offset)

**Warning:**
- Large positive offsets may require deeper mortises
- Check that offset doesn't place connector outside panel boundaries

#### Depth

| Parameter | Depth |
|-----------|-------|
| **Type** | PropDouble (length) |
| **Default** | 0 mm |
| **Unit** | Length (mm in metric, inches in imperial) |
| **Description** | Milling depth at the female panel for recessing the connector housing |

**Machining Details:**
- **0 mm**: No milling at female panel
  - Fastener drilled directly into panel face
  - HCWL connector may protrude from panel surface
- **> 0 mm**: Creates round housing at female panel
  - **Diameter**: 42 mm (matches HCWL housing)
  - **Actual depth**: 2 × Depth value (double-sided milling)
  - **Tool type**: House (round mortise)

**Adjusted Depth Calculation:**
```c
double dDepthTooling = -dOffsetY + dDepth;
```
- Depth compensates for Offset Y to maintain consistent connector engagement

**Common Values:**
- **0 mm**: Surface-mounted fasteners
- **10-20 mm**: Partial recess for flush appearance
- **30-40 mm**: Full recess for completely flush installation

**Consideration:**
- Deeper milling reduces effective panel thickness
- Ensure female panel thickness > (80 mm + 2 × Depth)

### Position Setting

#### Position

| Parameter | Position |
|-----------|----------|
| **Type** | PropString (dropdown selection) |
| **Default** | `Panel Outside` |
| **Options** | `Panel Outside`, `Milled in Strap`, `Flush` |
| **Description** | Mounting position of the connector relative to the panel face |

**Position Options and Z-Offsets:**

1. **Panel Outside** (Z-offset = 0 mm)
   - Connector mounted on exterior panel surface
   - HCWL housing visible on panel face
   - **Mortise depth**: 42 mm into panel
   - **Use case**: Standard installation, fastest installation

2. **Milled in Strap** (Z-offset = 3 mm)
   - Connector partially recessed into panel
   - **Mortise depth**: 42 mm + 3 mm
   - **Use case**: Slightly reduced profile, semi-flush appearance

3. **Flush** (Z-offset = 42 - 22 + dFlushExtraGap + 1 ≈ 30.1 mm)
   - Connector sits flush with panel surface
   - **Requires two mortises**:
     - **Bottom mortise**: 42 mm diameter × 122 mm length (oval pocket)
     - **Top mortise**: 68 mm width × 268 mm length (rectangular pocket for flush-mounted top)
   - **Total depth requirement**: ~30 mm deeper than standard
   - **Use case**: Architectural applications requiring flush surfaces

**Code Implementation:**
```c
double dOffsetZs[] = { U(0), U(3), U(42) - U(22) + dFlushExtraGap + U(1)};
dOffsetZ = dOffsetZs[sPositions.find(sPosition, 0)];
```

**Selection Guide:**
- **Panel Outside**: Default, simplest installation, fastest on-site assembly
- **Milled in Strap**: Improved aesthetics, minimal additional machining
- **Flush**: Premium finish, requires thicker panels, more complex machining

**Machining Validation:**
- Flush position checks: `if(dOffsetZ > -U(22) + dFlushExtraGap)`
- Ensures panel has sufficient thickness for deeper mortise

### Fasteners Category

#### Fastener

| Parameter | Fastener |
|-----------|----------|
| **Type** | PropString (dropdown selection) |
| **Default** | `None` |
| **Options** | 7 options (see table below) |
| **Description** | Fastener type for anchoring to concrete or timber |

**Available Fasteners:**

| Option | Type | Article No. | Length | Application |
|--------|------|-------------|--------|-------------|
| None | - | - | - | HCWL only (no fastener) |
| HST3 M12x165 | Concrete bolt anchor | 2107687 | 165 mm | Concrete connection |
| HST3 M12x185 | Concrete bolt anchor | 2107687 | 185 mm | Concrete connection |
| HAS-U 8.8 M12x180 | Chemical anchor | 2226626 | 180 mm | Concrete connection |
| HAS-U 8.8 M12x200 | Chemical anchor | 2226626 | 200 mm | Concrete connection |
| Stockschraube HSW M12x220/60 8.8 | Hanger bolt | 2316491 | 220 mm | Timber connection (recommended) |
| Stockschraube HSW M12x140/60 8.8 | Hanger bolt | 216376 | 140 mm | Timber connection (short) |

**Automatic Fastener Selection Logic:**
```c
if(nFastener > 0 && nConnectionType == 1 && nFastener < 5)
{
    sFastener.set(sFasteners[5]); // Auto-switch to HSW M12x220/60
}
```

**Logic Explanation:**
- **Connection Type = male-female** (timber-to-timber)
- **User selects concrete anchor** (HST3 or HAS-U)
- **Script automatically switches to HSW M12x220/60 8.8** (hanger bolt for timber)
- **Reason**: Concrete anchors incompatible with timber substrates

**Fastener Details:**

**HST3 Series (Concrete Bolt Anchors):**
- **Manufacturer**: Hilti
- **Application**: Concrete floors/walls
- **Installation**: Pre-drilled hole, mechanical expansion
- **Lengths**: 165 mm (thin slabs), 185 mm (standard slabs)
- **Advantages**: Fast installation, removable, high load capacity

**HAS-U Series (Chemical Anchors):**
- **Manufacturer**: Hilti
- **Application**: Concrete/masonry
- **Installation**: Pre-drilled hole + injectable adhesive
- **Lengths**: 180 mm, 200 mm
- **Advantages**: Higher load capacity, better for cracked concrete, fire-rated

**HSW Series (Hanger Bolts/Stockschraube):**
- **Manufacturer**: Hilti
- **Application**: Timber-to-timber connections
- **Construction**: Wood thread on one end (60 mm), machine thread on other end
- **Lengths**:
  - 220 mm total (160 mm machine thread + 60 mm wood thread) - standard
  - 140 mm total (80 mm machine thread + 60 mm wood thread) - compact
- **Installation**: Wood thread screws into female panel, machine thread connects to HCWL
- **Advantages**: Designed specifically for HCWL system

**Selection Guide:**
- **Single panel to concrete**: HST3 or HAS-U (concrete anchors)
- **Male-female panels**: HSW (hanger bolts) - auto-selected even if you pick concrete anchor
- **None**: When fastener will be installed on-site manually

**Hardware Assignment:**
- HCWL coupler → Linked to male panel
- Fastener → Linked to female panel (male-female mode) or same panel (single panel mode)

## Right-Click Context Menu Options

After placing a connector instance, right-click on it to access these commands:

### Flip Side

**Command**: `Flip Side`

**Purpose**: Switches the connector placement to the opposite side of the panel.

**Use Case:**
- Automatic side detection places connectors on wrong face (interior vs. exterior)
- Structural requirements specify specific mounting face
- Aesthetic preferences (hidden vs. visible connectors)

**Technical Behavior:**
```c
String sTriggerFlipSide = T("|Flip Side|");
addRecalcTrigger(_kContextRoot, sTriggerFlipSide);
if (_bOnRecalc && _kExecuteKey==sTriggerFlipSide)
{
    _Map.setInt("Side", -_Map.getInt("Side"));
    setExecutionLoops(2);
    return;
}
```

**Effect:**
- **Side = 1** (default): Connectors on -vecZ side (typically interior/inner face)
- **Side = -1** (after flip): Connectors on +vecZ side (typically exterior/outer face)
- Script recalculates all connector positions, machining, and hardware

**Availability:**
- Mode 1 (Male-Female Distribution)
- Mode 2 (Single Panel Distribution)
- Mode 101 (Single Point Male-Female)
- Mode 102 (Single Point Single Panel)

### Explode Distribution

**Command**: `Explode distribution`

**Purpose**: Converts a distributed row of connectors into individual single-point instances.

**Use Case:**
- Need to adjust individual connector positions after initial distribution
- Delete specific connectors from distribution without affecting others
- Customize spacing for non-uniform requirements

**Technical Behavior:**
```c
String sTriggerReiheAufloesen = T("|Explode distribution|");
addRecalcTrigger(_kContextRoot, sTriggerReiheAufloesen);
if (_bOnRecalc && _kExecuteKey==sTriggerReiheAufloesen)
{
    // Create individual TSL instances for each distributed point
    for (int p=0; p<ptsDis.length(); p++)
    {
        ptsTsl[0] = ptsDis[p];
        tslNew.dbCreate(scriptName(), vecXTsl, vecYTsl, gbsTsl, entsTsl,
            ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
    }
    eraseInstance(); // Delete original distributed instance
    return;
}
```

**Effect:**
- Original distributed instance deleted
- New instances created for each connector position
- **Mode switches**:
  - Male-Female Distribution (Mode 1) → Single Point Male-Female (Mode 101)
  - Single Panel Distribution (Mode 2) → Single Point Single Panel (Mode 102)
- Each instance independently editable (move, delete, modify parameters)
- Distribution properties (Start/End Offset, Interdistance) become hidden

**Availability:**
- Mode 1 (Male-Female Distribution) ✓
- Mode 2 (Single Panel Distribution) ✓
- Mode 101/102 (Single Point modes) ✗ (not applicable - already individual)

**Warning:**
- **Irreversible operation** - cannot re-combine instances back into distribution
- All individual instances inherit current parameter values
- Changing parameters on one instance does not affect others

## Hardware Components Generated

The script automatically generates hardware component entries for Bill of Materials (BOM) and procurement.

### Main Component: HCWL Wood Coupler

**Hardware Definition:**
```c
HardWrComp getMainHardwareDefinition(int _nQty)
{
    String _sHWArticleNumber = "2316495";
    HardWrComp _hwc(_sHWArticleNumber, _nQty);
    _hwc.setManufacturer("Hilti");
    _hwc.setModel("Wood coupler HCWL 40x295 M12");
    _hwc.setDescription("Faster and more efficient wood connector system for assembling prefabricated timber structures");
    _hwc.setCategory(T("|Connector|"));
    _hwc.setRepType(_kRTTsl);
    return _hwc;
}
```

| Property | Value |
|----------|-------|
| **Article Number** | 2316495 |
| **Manufacturer** | Hilti |
| **Model** | Wood coupler HCWL 40x295 M12 |
| **Description** | Faster and more efficient wood connector system for assembling prefabricated timber structures |
| **Category** | Connector |
| **Dimensions** | 40 mm × 295 mm |
| **Thread** | M12 metric thread |
| **Quantity** | Number of connectors in distribution |
| **Linked Entity** | Male panel (Sip) |

**Technical Specifications (Hilti HCWL):**
- **Material**: Galvanized steel
- **Connection Method**: Wood coupler with integrated M12 thread
- **Panel Engagement**: 40 mm diameter housing, 295 mm total length
- **Load Capacity**: Consult Hilti engineering data for specific loads
- **Installation Time**: Faster than traditional bolt connections

### Fastener Components

**Hardware Definition (HSW Series):**
```c
HardWrComp getHardwareDefinitionHSW(int _nQty, String sHardwareInfo[])
{
    String _sHWManufacturer = "Hilti";
    String _sHWArticleNumber = sHardwareInfo[0];
    String _sHWModel = sHardwareInfo[1];
    double dHWScaleX = sHardwareInfo[2].atof();

    HardWrComp _hwc(_sHWArticleNumber, _nQty);
    _hwc.setCategory(T("|Connector|"));
    _hwc.setManufacturer(_sHWManufacturer);
    _hwc.setModel(_sHWModel);
    _hwc.setDScaleX(dHWScaleX);
    _hwc.setDScaleY(U(12));
    _hwc.setDScaleZ(U(12));
    _hwc.setRepType(_kRTTsl);
    return _hwc;
}
```

#### Fastener Specifications Table

| Fastener Selection | Article No. | Model | Length | Diameter | Linked To |
|-------------------|-------------|-------|--------|----------|-----------|
| None | - | - | - | - | - |
| HST3 M12x165 | 2107687 | HST3 M12x165 | 165 mm | M12 | Female panel (single) or Male panel (single panel mode) |
| HST3 M12x185 | 2107687 | HST3 M12x185 | 185 mm | M12 | Female panel (single) or Male panel (single panel mode) |
| HAS-U 8.8 M12x180 | 2226626 | HAS-U 8.8 M12x180 | 180 mm | M12 | Female panel (single) or Male panel (single panel mode) |
| HAS-U 8.8 M12x200 | 2226626 | HAS-U 8.8 M12x200 | 200 mm | M12 | Female panel (single) or Male panel (single panel mode) |
| Stockschraube HSW M12x220/60 8.8 | 2316491 | Hanger bolt HSW M12x220/60 8.8 | 220 mm | M12 | Female panel |
| Stockschraube HSW M12x140/60 8.8 | 216376 | Hanger bolt HSW M12x140/60 8.8 | 140 mm | M12 | Female panel |

**Hardware Assignment Logic:**
- **Male-Female Connection**:
  - HCWL → Linked to **male panel**
  - Fastener (HSW) → Linked to **female panel**
- **Single Panel Connection**:
  - HCWL → Linked to **the panel**
  - Fastener (HST3/HAS-U) → Linked to **the same panel**

**BOM Integration:**
- Hardware quantities automatically match connector count
- Components inherit group name from parent element
- Hardware linked to correct panels for accurate procurement
- RepType set to `_kRTTsl` to identify TSL-generated hardware

**Procurement Notes:**
- Order quantities include all connectors in project
- Hardware automatically grouped by element/group
- Consult Hilti for current pricing and availability

## Tooling Operations

The script automatically creates precise machining operations on panels for connector installation.

### Tooling on Male Panel (HCWL Receiver)

#### Bottom Mortise (Standard for all positions)

**Operation Type**: Mortise (Oval pocket)

**Technical Specifications:**
```c
double _dLength = 2*U(61) + 2*_dOffsetY;    // Total: 122 mm + 2×OffsetY
double _dDiameter = U(42);                   // Width: 42 mm
double _dWidth = _dDiameter;                 // 42 mm
double _dDepth = _dDiameter;                 // Depth: 42 mm

Mortise ms(_ptHouse, _vecXT, -_vecYT, -_vecZT, _dLength, _dWidth, _dDepth, 0, 0, 0);
ms.setEndType(_kFemaleSide);
ms.setExplicitRadius(U(21));                // Corner radius: 21 mm
ms.setRoundType(_kExplicitRadius);
```

**Geometry:**
- **Shape**: Oval (elongated circle with rounded ends)
- **Length**: 122 mm (base) + 2 × Offset Y (adjustable)
- **Width**: 42 mm (matches HCWL housing diameter)
- **Depth**: 42 mm (full housing depth)
- **Corner Radius**: 21 mm (explicit radius for oval ends)
- **End Type**: Female side (pocket opens on panel face)

**Purpose:**
- Receives HCWL wood coupler housing
- Allows connector to sit flush or partially recessed
- Provides precise fit for connector alignment

**Position:**
- Center of mortise at distributed connector point
- Orientation: Length along panel height (vecUp direction)

#### Top Mortise (Only for "Flush" Position)

**Condition**: `if(dOffsetZ > U(0))` (Flush position selected)

**Operation Type**: Mortise (Rectangular pocket)

**Technical Specifications:**
```c
_ptHouse = _ptsDis[p] + _vecUp*U(174) + _dOffsetY*_vecUp;
_dLength = U(268);                          // Length: 268 mm
_dWidth = U(68);                            // Width: 68 mm
_dDepth = dFlushExtraGap;                   // Depth: ~9.1 mm

Mortise ms(_ptHouse, _vecXT, -_vecYT, -_vecZT, _dLength, _dWidth, _dDepth*2, 0, 0, 0);
ms.setExplicitRadius(U(21));                // Corner radius: 21 mm
ms.setRoundType(_kExplicitRadius);
ms.setEndType(_kFemaleSide);
```

**Geometry:**
- **Shape**: Rectangle with rounded corners
- **Length**: 268 mm
- **Width**: 68 mm
- **Depth**: 2 × dFlushExtraGap ≈ 18.2 mm
- **Corner Radius**: 21 mm
- **Position**: 174 mm + Offset Y above connector center

**Purpose:**
- Allows HCWL top portion to sit flush with panel surface
- Provides clearance for connector top plate
- Creates architectural flush finish

**Visual Result:**
- Connector completely recessed into panel
- Only M12 thread protrudes for fastener connection
- Smooth panel face for finishing

### Tooling on Female Panel (Male-Female Connections)

#### Round Housing (Optional, when Depth > 0)

**Condition**: `if(_dDepth > 0)` (Depth parameter set)

**Operation Type**: House (Round mortise)

**Technical Specifications:**
```c
double _dDiameter = U(42);                   // Diameter: 42 mm
double _dWidth = _dDiameter;                 // 42 mm
double _dLength = U(60);                     // Length: 60 mm
double _dDepthTooling = -_dOffsetY + _dDepth;

House ms(_ptHouse, _vecXT, -_vecYT, -_vecZT, _dWidth, _dLength, _dDepth*2, 1, 0, 0);
ms.setEndType(_kFemaleSide);
ms.setRoundType(_kRound);
```

**Geometry:**
- **Shape**: Round (cylindrical)
- **Diameter**: 42 mm (matches fastener housing)
- **Actual Depth**: 2 × (Depth - Offset Y)
- **End Type**: Female side

**Purpose:**
- Recesses fastener housing into female panel
- Reduces connector protrusion from panel face
- Improves aesthetics and protects fastener

**Depth Adjustment:**
- Compensates for Offset Y to maintain connector engagement
- Formula: `dDepthTooling = -dOffsetY + dDepth`

#### Pilot Drill (Always created for male-female)

**Operation Type**: Drill

**Technical Specifications:**
```c
double dDiamPilotDrill = U(8);              // Diameter: 8 mm
double dDepthPilotDrill = U(100);           // Depth: 100 mm

Drill dr(_ptsDis[p] + _vecUp * 10 * dEps,
         _ptsDis[p] - _vecUp * dDepthPilotDrill,
         .5 * dDiamPilotDrill);
```

**Geometry:**
- **Diameter**: 8 mm
- **Depth**: 100 mm into female panel
- **Direction**: Along vecUp (perpendicular to panel face)
- **Purpose**: Pre-drill for HSW hanger bolt wood thread

**Installation Sequence:**
1. Pilot hole drilled first (8 mm)
2. HSW hanger bolt screwed into pilot hole (wood thread engages)
3. M12 machine thread connects to HCWL on male panel

**Note:**
- No pilot drill created for single panel connections (concrete anchors drilled on-site)

### Tooling on Single Panel (Concrete Connections)

**Same as male panel tooling**:
- Bottom mortise (always)
- Top mortise (if Flush position)
- **No pilot drill** (concrete anchoring done on-site)

## Visual Representation

The script provides two visual display methods for connectors:

### Method 1: 3D Block Display (Preferred)

**Requirement**: `HCWL.dwg` block file in `[Company Path]\Block\`

**Technical Implementation:**
```c
String sBlockName = "HCWL";
String sBlockPath = _kPathHsbCompany + "\\Block";

if (_BlockNames.findNoCase(sBlockName, -1) < 0)
{
    bBlockFound = false;
    String files[] = getFilesInFolder(sBlockPath);
    String fileName = sBlockName;
    if (files.findNoCase(fileName+".dwg", -1) > -1)
    {
        sBlockName = sBlockPath + "\\" + fileName + ".dwg";
        bBlockFound = true;
    }
}
```

**Display Behavior:**
- Searches for `HCWL.dwg` in company Block folder
- If found: Inserts 3D block at each connector position
- Block oriented with:
  - **X-axis**: vecSide × vecUp (perpendicular to panel face)
  - **Y-axis**: -vecSide (into panel)
  - **Z-axis**: vecUp (along panel height)
- Block offset by Offset Y and Offset Z parameters

**Advantages:**
- Accurate 3D visualization
- Shows connector geometry and orientation
- Useful for clash detection
- Improves shop drawing clarity

### Method 2: Circle Symbol Display (Fallback)

**Condition**: If HCWL.dwg not found

**Technical Implementation:**
```c
double _dDiameter = U(42);                  // Circle diameter: 42 mm
for (int p=0; p<_ptsDis.length(); p++)
{
    PLine plCirc;
    plCirc.createCircle(_ptsDis[p], _vecUp, _dDiameter/2.0);
    dp.draw(plCirc);
}
```

**Display Behavior:**
- Draws 42 mm diameter circle at each connector position
- Circle oriented perpendicular to panel face
- Display color: 6 (by default, or as specified)

**Advantages:**
- Works without external block file
- Lightweight display
- Shows connector locations clearly

**Disadvantages:**
- No 3D geometry detail
- Lacks orientation information

### Display Color Control

**Default Color**: 6 (Magenta in standard AutoCAD color palette)

**Color Assignment:**
```c
Display dp(3);                              // Default color
if(_min.hasInt("Color"))
{
    dp.color(_min.getInt("Color"));
}
```

**Recommendation:**
- Install HCWL.dwg block for professional presentations and shop drawings
- Circle display sufficient for design phase and connector quantity verification

## Technical Implementation Details

### Male-Female Panel Detection

The script uses sophisticated geometry analysis to distinguish male and female panels:

**Algorithm: `distinguishMaleFemaleFrom2Sips()`**

```c
Map distinguishMaleFemaleFrom2Sips(Sip _sips[])
{
    Map _m;
    if(_sips.length() != 2) return _m;

    Sip _sipMale = _sips[0];
    Sip _sipFemale = _sips[1];

    Vector3d vecZmale = _sipMale.vecZ();
    Vector3d vecZfemale = _sipFemale.vecZ();

    // Check perpendicularity
    if(!vecZmale.isPerpendicularTo(vecZfemale))
    {
        _m.setInt("Error", true);
        return _m;
    }

    // Shadow profile analysis
    double dAllowedGap = U(50);
    Plane pn(_sipMale.ptCen(), vecZmale);
    PlaneProfile ppMale = _sipMale.envelopeBody().shadowProfile(pn);
    PlaneProfile ppFemale = _sipFemale.envelopeBody().shadowProfile(pn);

    // Shrink profiles to detect gap
    PlaneProfile ppMaleShrink = ppMale;
    PlaneProfile ppFemaleShrink = ppFemale;
    ppMaleShrink.shrink(U(1));
    ppFemaleShrink.shrink(U(1));

    // Extend profiles to check proximity
    PlaneProfile ppMaleExtend = ppMale;
    PlaneProfile ppFemaleExtend = ppFemale;
    ppMaleExtend.shrink(-0.5*dAllowedGap);
    ppFemaleExtend.shrink(-0.5*dAllowedGap);

    // Validation: No intersection when shrunk, intersection when extended
    if(!ppMaleShrink.intersectWith(ppFemaleShrink) &&
        ppMaleExtend.intersectWith(ppFemaleExtend))
    {
        _m.setEntity("male", _sipMale);
        _m.setEntity("female", _sipFemale);
        return _m;
    }
    else
    {
        // Try swapping male/female assignment
        // [Repeat logic with swapped panels]
    }

    _m.setInt("Error", true);
    return _m;
}
```

**Detection Logic:**
1. **Perpendicularity Check**: Panels must be at 90 degrees
2. **Shadow Profile Creation**: Project panels onto plane perpendicular to male panel
3. **Shrink Test**: Shrink profiles by 1 mm - should NOT intersect (gap between panels)
4. **Proximity Test**: Extend profiles by 25 mm (half gap tolerance) - should intersect (panels close enough)
5. **Male Assignment**: Panel whose plane is used for projection
6. **Female Assignment**: Perpendicular panel

**Error Conditions:**
- Panels parallel (not perpendicular)
- Panels too far apart (> 50 mm gap)
- Panels overlapping (intersection when shrunk)

**Gap Tolerance:**
- **Maximum gap**: 50 mm between panel surfaces
- Allows for construction tolerances and joint details

### Connection Side Detection

**Algorithm: `getConnectionSideOf2Panels()`**

Determines which side of the male panel (left vs. right, inner vs. outer) should receive connectors.

**Logic:**
```c
Map getConnectionSideOf2Panels(Sip _sips[])
{
    Map _m;
    Sip _sipMale = _sips[0];
    Sip _sipFemale = _sips[1];

    Vector3d vecZmale = _sipMale.vecZ();
    Vector3d vecZfemale = _sipFemale.vecZ();

    // Create plane perpendicular to female panel
    Plane pn(_sipFemale.ptCen(), vecZfemale);
    PlaneProfile ppFemale = _sipFemale.envelopeBody().shadowProfile(pn);
    PlaneProfile ppMale = _sipMale.envelopeBody().shadowProfile(pn);

    // Distribution direction
    Vector3d _vecDir = vecZmale.crossProduct(vecZfemale);
    _vecDir.normalize();

    // Create test strips on left and right sides of male panel
    Point3d ptL = _sipMale.ptCen() - 0.5*_sipMale.dH()*_sipMale.vecZ();
    Point3d ptR = _sipMale.ptCen() + 0.5*_sipMale.dH()*_sipMale.vecZ();

    PlaneProfile ppStripL(pn), ppStripR(pn);
    ppStripL.createRectangle(/* large strip on left side */);
    ppStripR.createRectangle(/* large strip on right side */);

    // Intersect strips with female panel profile
    ppStripL.intersectWith(ppFemale);
    ppStripR.intersectWith(ppFemale);

    // Side with larger intersection area is the connection side
    Vector3d _vecSide = -_sipMale.vecZ();  // Default: left side
    int nSide = 1;
    if(ppStripR.area() > ppStripL.area())
    {
        _vecSide *= -1;  // Switch to right side
        nSide = -1;
    }

    _m.setVector3d("vecSide", _vecSide);
    _m.setInt("Side", nSide);

    // Calculate distribution line
    PlaneProfile _ppCommon = ppMale;
    _ppCommon.intersectWith(ppFemale);
    LineSeg _segCommon = _ppCommon.extentInDir(_vecDir);

    // Project to intersection of panel faces
    Plane pnMale(_sips[0].ptCen() + 0.5*_sips[0].dH()*_vecSide, _vecSide);
    Vector3d _vecFemale = /* adjusted female panel normal */;
    Plane pnFemale(_sips[1].ptCen() + 0.5*_sips[1].dH()*_vecFemale, _vecFemale);
    Line ln = pnMale.intersect(pnFemale);

    Point3d _ptStart = ln.closestPointTo(_segCommon.ptStart());
    Point3d _ptEnd = ln.closestPointTo(_segCommon.ptEnd());

    _m.setPoint3d("ptStart", _ptStart);
    _m.setPoint3d("ptEnd", _ptEnd);
    _m.setVector3d("vecDir", _vecDir);

    return _m;
}
```

**Side Selection:**
- Creates test strips on both sides of male panel
- Intersects strips with female panel shadow profile
- **Inner side** (L-corner): Larger intersection area
- **Outer side**: Smaller intersection area
- Automatically selects inner side for corner connections

**Distribution Line Calculation:**
1. Find common overlap between male and female profiles
2. Get extent of overlap in distribution direction
3. Project extent endpoints onto intersection line of panel faces
4. Result: Start and end points for connector distribution

**Return Values:**
- **vecSide**: Vector pointing to connection side
- **Side**: Integer (1 = -vecZ, -1 = +vecZ)
- **ptStart**: Distribution start point
- **ptEnd**: Distribution end point
- **vecDir**: Distribution direction vector

### Distribution Calculation

**Algorithm: `calcDistribution()`**

Computes connector positions along distribution line based on user parameters.

**Input Map:**
```c
Map minDistribution;
minDistribution.setDouble("PartLength", 0);              // Connector length (0 for point objects)
minDistribution.setPoint3d("pt0Start", ptStartDistribution);
minDistribution.setPoint3d("pt0End", ptEndDistribution);
minDistribution.setDouble("OffsetBottom", dOffsetBottom);
minDistribution.setDouble("OffsetTop", dOffsetTop);
minDistribution.setDouble("OffsetBetween", dOffsetBetween);
minDistribution.setVector3d("vecDistribution", vecDirDistribution);
minDistribution.setInt("evenDistribution", nDistribution);  // 0=Fixed, 1=Even
```

**Fixed Distribution Logic** (nDistribution = 0):
```c
Vector3d _vecDir = (_pt0End - _pt0Start).normalize();
Point3d _pt1 = _pt0Start + _vecDir * _dOffsetBottom;
Point3d _pt2 = _pt0End - _vecDir * (_dOffsetTop + _dPartLength);

double _dDistTot = (_pt2 - _pt1).dotProduct(_vecDir);

if(_dDistTot < 0)
{
    // Error: No distribution possible
    return error;
}

double dDistMod = _dOffsetBetween + _dPartLength;
int iNrParts = _dDistTot / dDistMod;

// First point
Point3d pt = _pt0Start + _vecDir * (_dOffsetBottom + _dPartLength/2);
_ptsDis.append(pt);

// Intermediate points
for (int i=0; i<iNrParts; i++)
{
    pt += _vecDir * dDistMod;
    _ptsDis.append(pt);
}

// Last point
_ptsDis.append(_pt0End - _vecDir * (_dOffsetTop + _dPartLength/2));
```

**Even Distribution Logic** (nDistribution = 1):
```c
double dDistMod = _dOffsetBetween + _dPartLength;
int iNrParts = _dDistTot / dDistMod;
double dNrParts = _dDistTot / dDistMod;
if (dNrParts - iNrParts > 0) iNrParts += 1;  // Round up

double dDistModCalc = 0;
if (iNrParts != 0)
    dDistModCalc = _dDistTot / iNrParts;  // Recalculated even spacing

// First point
Point3d pt = _pt0Start + _vecDir * (_dOffsetBottom + _dPartLength/2);
_ptsDis.append(pt);

// Evenly distributed points
if (dDistModCalc > 0)
{
    for (int i=0; i<iNrParts; i++)
    {
        pt += _vecDir * dDistModCalc;
        _ptsDis.append(pt);
    }
}
```

**Comparison:**
- **Fixed**: Exact spacing, last point at End Offset
- **Even**: Calculated spacing, fills entire length evenly

**Error Detection:**
```c
if (_dDistTot < 0)
{
    String sTxt = T("|no distribution possible. Try to change the distribution parameters|");
    _m.setString("sTxt", sTxt);
    _m.setInt("Error", true);
    return _m;
}
```

**Common Error**: Start Offset + End Offset exceeds available length

**Output:**
- **Point3d array**: `ptsDis[]` containing all connector positions

### Polyline Cleanup Function

**Algorithm: `cleanUpPline()`**

Removes redundant vertices from panel edge polylines (points lying on straight segments).

**Purpose:**
- Simplify panel contours for accurate edge detection
- Remove construction artifacts from panel profiles
- Ensure clean edge selection in single panel mode

**Logic:**
```c
Map cleanUpPline(PLine plIn)
{
    Map _m;
    Point3d pts[] = plIn.vertexPoints(true);

    if(pts.length() < 3)
    {
        _m.setPLine("pl", plIn);  // No cleanup needed
        return _m;
    }

    Point3d ptsAddition[0];  // Removed points
    int nIndicesAdd[0];      // Removed indices

    // For each point
    for (int p=0; p<pts.length()-2; p++)
    {
        Point3d ptP = pts[p];
        Vector3d vecDirP;
        Line lnp;

        // Check subsequent points
        for (int j=p+1; j<pts.length(); j++)
        {
            Point3d ptJ = pts[j];

            if(j == p+1)
            {
                // First subsequent point - establish direction
                vecDirP = (ptJ - ptP).normalize();
            }
            else
            {
                // Check if point j lies on line from p to j
                Vector3d vecDirJ = (ptJ - ptP).normalize();
                Vector3d vecDirJ1 = (ptJ - pts[j-1]).normalize();

                if(abs(abs(vecDirP.dotProduct(vecDirJ)) - 1.0) < 0.1*dEps &&
                   abs(abs(vecDirP.dotProduct(vecDirJ1)) - 1.0) < 0.1*dEps)
                {
                    // Parallel - check distance from line
                    lnp = Line(0.5*(ptP + ptJ), vecDirP);
                    Point3d ptAtLine = lnp.closestPointTo(pts[j-1]);

                    if((ptAtLine - pts[j-1]).length() < U(1))
                    {
                        // Point j-1 is redundant (lies on line p-j)
                        ptsAddition.append(pts[j-1]);
                        nIndicesAdd.append(j-1);
                    }
                }
                else
                {
                    // Direction change - stop checking
                    break;
                }
            }
        }
    }

    // Rebuild polyline without redundant points
    Point3d ptsFinal[0];
    for (int p=0; p<pts.length(); p++)
    {
        if(nIndicesAdd.find(p) < 0)
        {
            ptsFinal.append(pts[p]);
        }
    }

    PLine plOut = PLine(plIn.coordSys().vecZ());
    for (int p=0; p<ptsFinal.length(); p++)
    {
        plOut.addVertex(ptsFinal[p]);
    }

    _m.setPLine("pl", plOut);
    _m.setPoint3dArray("ptsAddition", ptsAddition);
    return _m;
}
```

**Use Case:**
- CLT panels from CAD may have extra vertices along straight edges
- Cleanup ensures edge selection works correctly
- Prevents false edge detection

### Panel Edge Detection

**Algorithm: `getPanelEdges()`**

Extracts all edges of a panel for user selection in single panel mode.

**Logic:**
```c
Map getPanelEdges(Sip _sip, Map _min)
{
    Map _m;
    Plane _pn(_sip.ptCen(), _sip.vecZ());
    PlaneProfile _pp = _sip.envelopeBody().shadowProfile(_pn);
    PLine _plOutters[] = _pp.allRings(true, false);

    if(_plOutters.length() != 1)
    {
        _m.setString("sError", T("|Unexpected, more then one panel contour found|"));
        _m.setInt("Error", true);
        return _m;
    }

    PLine _plOutter = _plOutters[0];

    // Clean up polyline
    Map mCleanUp = cleanUpPline(_plOutter);
    if(mCleanUp.hasPoint3dArray("ptsAddition"))
    {
        _plOutter = mCleanUp.getPLine("pl");
    }

    Point3d _pts[] = _plOutter.vertexPoints(false);

    // Extract edge data
    Point3d _ptStarts[0], _ptEnds[0], _ptMids[0];
    for (int p=0; p<_pts.length()-1; p++)
    {
        Point3d ptS = _pts[p];
        Point3d ptE = _pts[p+1];
        Point3d ptM = 0.5 * (ptS + ptE);

        _ptStarts.append(ptS);
        _ptEnds.append(ptE);
        _ptMids.append(ptM);
    }

    _m.setPoint3dArray("Starts", _ptStarts);
    _m.setPoint3dArray("Ends", _ptEnds);
    _m.setPoint3dArray("Mids", _ptMids);
    _m.setVector3d("vecPlane", _sip.vecZ());

    // Optional: Find selected edge based on input point
    if(_min.hasPoint3d("pt"))
    {
        Point3d _pt = _min.getPoint3d("pt");
        int _nEdgeSelected = -1;
        double dDist = U(10e9);

        for (int p=0; p<_ptMids.length(); p++)
        {
            double dDistI = (_ptMids[p] - _pt).length();
            if(dDistI < dDist)
            {
                dDist = dDistI;
                _nEdgeSelected = p;
            }
        }

        if(_nEdgeSelected > -1)
        {
            _m.setInt("IndexEdgeSelected", _nEdgeSelected);
        }
    }

    return _m;
}
```

**Output:**
- **Starts[]**: Start points of all edges
- **Ends[]**: End points of all edges
- **Mids[]**: Midpoints of all edges (for edge selection)
- **vecPlane**: Panel normal vector
- **IndexEdgeSelected**: Closest edge to cursor (if point provided)

**Edge Selection:**
- User moves cursor near panel
- Script calculates distance to all edge midpoints
- Highlights nearest edge
- User clicks to confirm selection

## Advanced Usage Scenarios

### Scenario 1: L-Shaped Corner Wall Connection

**Configuration:**
- Two perpendicular CLT wall panels (100 mm thick)
- Interior corner connection
- Structural load transfer required

**Steps:**
1. Launch script, set Connection Type = `male-female`
2. Distribution: Start Offset = 150 mm, End Offset = 150 mm, Interdistance = 600 mm
3. Position = `Panel Outside`
4. Fastener = `Stockschraube HSW M12x220/60 8.8`
5. Select vertical panel 1 as male
6. Select vertical panel 2 as female
7. Script automatically places connectors on interior corner face

**Result:**
- Connectors every 600 mm from floor to ceiling
- First connector 150 mm above floor
- Last connector 150 mm below ceiling
- HCWL on panel 1, HSW bolts on panel 2

### Scenario 2: CLT Wall to Concrete Floor

**Configuration:**
- CLT wall panel (120 mm thick) on concrete slab
- Full-length distribution along bottom edge

**Steps:**
1. Launch script, set Connection Type = `single panel`
2. Distribution: Start Offset = 300 mm, End Offset = 300 mm, Interdistance = 800 mm
3. Position = `Panel Outside`
4. Fastener = `HST3 M12x185` (concrete bolt anchor)
5. Select wall panel
6. Move cursor to bottom edge, click when highlighted
7. Script distributes connectors along bottom edge

**Result:**
- Connectors every 800 mm along wall length
- HCWL mortises on wall panel bottom
- Anchor bolts will be installed on-site into concrete

### Scenario 3: CLT Floor to Wall Connection

**Configuration:**
- Horizontal CLT floor panel connecting to vertical wall panel
- Architectural flush finish required

**Steps:**
1. Launch script, set Connection Type = `male-female`
2. Distribution: Even Distribution, Start = 200 mm, End = 200 mm, Interdistance = 1000 mm
3. Position = `Flush`
4. Fastener = `Stockschraube HSW M12x220/60 8.8`
5. Offset Y = 0 mm
6. Depth = 20 mm (recess fastener on wall)
7. Select floor panel as male
8. Select wall panel as female

**Result:**
- Even distribution of connectors (script calculates optimal spacing)
- HCWL fully recessed into floor panel (flush surface)
- HSW bolts recessed 20 mm into wall panel
- No visible hardware protrusion

### Scenario 4: Point Load Transfer Connection

**Configuration:**
- Beam pocket connection at specific load point
- Single connector at engineered location

**Steps:**
1. Launch script, set Connection Type = `male-female`
2. **Set Interdistance = 0** (activates single-point mode)
3. Position = `Panel Outside`
4. Fastener = `Stockschraube HSW M12x220/60 8.8`
5. Select beam panel and wall panel
6. When prompted "Select Insertion point": Click at exact load point

**Result:**
- Single connector at specified point
- Precise placement for engineered load transfer
- No distribution properties visible

### Scenario 5: Adjusting Existing Distribution

**Configuration:**
- Previously placed distributed connectors
- Need to modify spacing or remove some connectors

**Steps:**
1. Select existing distributed connector instance
2. Right-click → `Explode distribution`
3. Script creates individual instances for each connector
4. Delete unwanted instances
5. Move remaining instances as needed
6. Each instance editable independently

**Result:**
- Custom connector layout
- Individual control over each connector
- Cannot re-combine into distribution (explode is permanent)

### Scenario 6: Multiple Panel Intersections

**Configuration:**
- 4 perpendicular walls at building corner
- Need connectors at all 4 intersections

**Steps:**
1. Launch script, set Connection Type = `male-female`
2. Configure distribution parameters
3. Select ALL 4 wall panels as "male panels"
4. Select ALL 4 wall panels again as "female panels"

**Result:**
- Script automatically detects all perpendicular pairs
- Creates separate TSL instance for each intersection (up to 12 instances for 4 walls)
- Each instance manages its own distribution

**Note:**
- Script only creates instances for valid perpendicular pairs within 50 mm proximity
- Parallel panels ignored
- Panels too far apart ignored

## Troubleshooting Guide

### Error Messages and Solutions

#### "Selected panel must have a thickness >= 80 mm"

**Cause**: Panel solid height less than required minimum

**Solutions:**
1. Check panel properties in hsbCAD
2. Increase panel thickness if possible
3. If panel is multi-layer, ensure solid CLT core is at least 80 mm
4. For thinner panels, use alternative connection methods

**Technical Reason**:
- HCWL mortise requires 42 mm depth
- Minimum 80 mm ensures structural integrity after machining

#### "No male panel found"

**Cause**: Invalid Sip entity or incorrect selection

**Solutions:**
1. Verify you selected a **Sip** (CLT panel) entity, not:
   - Polyline
   - Solid
   - GenBeam
   - Other entity type
2. Check panel validity:
   - Right-click panel → Properties
   - Ensure no corruption errors
3. Regenerate panel if corrupted
4. Check panel thickness (>= 80 mm)

**Script Validation:**
```c
if(!sipMale.bIsValid())
{
    reportMessage("\n"+scriptName()+" "+T("|No male panel found|"));
    eraseInstance();
    return;
}
```

#### "No female panel found"

**Same diagnosis and solutions as "No male panel found"**

#### "Panels not parallel" (Error)

**Cause**: Panels are parallel, not perpendicular

**Solutions:**
1. Verify panel orientation:
   - Male-female connections require **90-degree angle**
   - Check panel normal vectors
2. For parallel panels:
   - Use different connection method
   - Or rotate one panel to perpendicular orientation
3. Check for nearly-perpendicular panels:
   - Script requires exact 90 degrees
   - Adjust panel rotation if close but not exact

**Technical Check:**
```c
if(!vecZmale.isPerpendicularTo(vecZfemale))
{
    _m.setString("sError", "mConnectionSide2Panels: "+T("|Panels not parallel|"));
    return _m;
}
```

#### "No contact between male and female"

**Cause**: Panels too far apart (> 50 mm gap)

**Solutions:**
1. Move panels closer together
2. Check for modeling errors:
   - Panels at different heights
   - Panels offset horizontally
3. Verify panel positions:
   - Use measurement tools to check gap
   - Maximum allowed gap: 50 mm
4. Adjust panel positions to bring within tolerance

**Technical Validation:**
```c
if(_ppCommon.area() < pow(U(1), 2))
{
    String sError = T("|No contact between male and female, distribution not possible|");
    _m.setString("sError", sError);
    _m.setInt("Error", true);
    return _m;
}
```

#### "no distribution possible. Try to change the distribution parameters"

**Cause**: Offsets too large for available connection length

**Solutions:**
1. **Reduce Start Offset**:
   - Try smaller value (e.g., 150 mm instead of 350 mm)
2. **Reduce End Offset**:
   - Match Start Offset reduction
3. **Increase Interdistance**:
   - Larger spacing requires fewer connectors
4. **Check connection length**:
   - Very short panels may not accommodate distribution
   - Use single-point mode (Interdistance = 0) instead

**Calculation:**
```
Available Length = Total Length - Start Offset - End Offset
Required Length = Interdistance × (Number of Connectors - 1)

If Available Length < Required Length → Error
```

**Example Error:**
- Connection length: 1000 mm
- Start Offset: 400 mm
- End Offset: 400 mm
- Interdistance: 500 mm
- Available: 1000 - 400 - 400 = 200 mm
- Required: 500 mm (for 2 connectors)
- **Error**: Not enough space

**Solution for Example:**
- Reduce offsets to 100 mm each: Available = 800 mm ✓
- Or reduce Interdistance to 200 mm ✓

#### "Unexpected, more then one panel contour found"

**Cause**: Panel has complex geometry (holes, multiple outlines)

**Solutions:**
1. Simplify panel geometry
2. Remove internal holes/openings if not needed
3. Split complex panel into simpler panels
4. Contact hsbCAD support if panel should be simple

**Expected**: Single rectangular CLT panel
**Problem**: Panel with openings, irregular shape, or modeling errors

#### Connectors on Wrong Face (Not an error, but common issue)

**Symptom**: Connectors placed on exterior instead of interior (or vice versa)

**Solution:**
1. Right-click connector instance
2. Select `Flip Side` from context menu
3. Connectors regenerate on opposite panel face

**Automatic Detection:**
- Script attempts to detect inner corner face
- May occasionally select wrong side for complex geometries
- `Flip Side` provides manual override

### Distribution Problems

#### "Distribution shows fewer connectors than expected"

**Diagnosis:**
1. Check distribution formula:
   - **Fixed**: Count = floor((Length - Start - End) / Interdistance)
2. Verify offsets haven't reduced available length too much
3. Check Interdistance value

**Example:**
- Length: 5000 mm
- Start: 350 mm, End: 350 mm
- Interdistance: 1000 mm
- Available: 5000 - 350 - 350 = 4300 mm
- Count: floor(4300 / 1000) = 4 connectors
- Actual spacing: ~1433 mm (4300 / 3 spaces)

**Solution:**
- Use **Even Distribution** to fill length optimally
- Or adjust Interdistance to achieve desired count

#### "Connectors not evenly spaced"

**Diagnosis:**
- Using **Fixed Distribution** mode
- Length not evenly divisible by Interdistance

**Solution:**
1. Switch to **Even Distribution** mode
2. Or calculate exact Interdistance:
   ```
   Interdistance = (Length - Start - End) / (Desired Count - 1)
   ```

#### "Cannot adjust individual connector after placement"

**Cause**: Connectors in distribution mode (Mode 1 or 2)

**Solution:**
1. Right-click instance
2. Select `Explode distribution`
3. Now each connector is individual instance
4. Move, delete, or modify as needed

**Warning**: Cannot re-combine after explode

### Hardware/BOM Issues

#### "Fastener automatically changed from concrete anchor to HSW"

**Not an error** - This is intentional behavior

**Explanation:**
- User selected concrete anchor (HST3 or HAS-U)
- Connection Type = male-female (timber-to-timber)
- Script auto-switches to appropriate timber fastener (HSW hanger bolt)
- Concrete anchors not suitable for timber substrates

**Validation:**
```c
if(nFastener > 0 && nConnectionType == 1 && nFastener < 5)
{
    sFastener.set(sFasteners[5]); // Auto-set to HSW M12x220/60
}
```

**Solution:**
- Accept auto-selection (recommended)
- Or manually select HSW series from start

#### "Hardware quantities incorrect in BOM"

**Diagnosis:**
1. Check connector count: `ptsDis.length()`
2. Verify hardware assignment:
   - HCWL quantity = connector count
   - Fastener quantity = connector count
3. Check for multiple instances overlapping

**Solutions:**
1. Regenerate instance (delete and recreate)
2. Check for duplicate instances at same location
3. Verify hardware linked to correct panels

#### "Hardware missing from BOM report"

**Diagnosis:**
1. Check hardware components:
   ```c
   HardWrComp hwcs[] = _ThisInst.hardWrComps();
   ```
2. Verify RepType set to `_kRTTsl`
3. Check group assignment

**Solutions:**
1. Ensure instance fully regenerated (2 execution loops)
2. Check BOM report filters (may exclude TSL-generated hardware)
3. Verify element/group assignment correct

### Visual Display Issues

#### "Block not showing, only circles displayed"

**Cause**: HCWL.dwg block file not found

**Solutions:**
1. Obtain HCWL.dwg block file
2. Place in: `[Company Path]\Block\`
3. Regenerate connector instances
4. Block should now display

**Fallback**: Circle display (42 mm diameter) is functional alternative

#### "Connectors not visible in view"

**Diagnosis:**
1. Check display color (default: 6 - magenta)
2. Verify layer not frozen/off
3. Check if connectors outside view extents

**Solutions:**
1. Zoom to connector location
2. Check layer settings
3. Regenerate with different color

### Performance Issues

#### "Script slow when selecting many panels"

**Cause**: Computational complexity for multiple male-female pairs

**Math**: N male panels × M female panels = up to N×M instances

**Solutions:**
1. Select panels in smaller batches
2. Use multiple insertion sessions
3. Increase computer RAM/CPU if possible

**Example:**
- 10 male panels × 10 female panels = up to 100 checks
- Only perpendicular pairs within 50 mm created
- Actual instances typically << theoretical maximum

#### "Regeneration takes long time"

**Cause**:
- Complex machining operations
- Large number of connectors
- Multiple execution loops

**Solutions:**
1. Simplify connector count (increase Interdistance)
2. Reduce number of instances
3. Use lower-detail display during design phase

## Version History

### Version 1.10 (30.10.2025)

**HSB-24843**: Fix to allow insertion at multiple female-male connections

**Author**: Marsel Nakuci

**Changes**:
- Fixed batch creation mode (Mode 0)
- Improved multiple panel selection handling
- Corrected male-female pair detection for simultaneous insertions

### Version 1.9 (12.12.2024)

**HSB-19771**: Added missing hanger bolt

**Author**: Nils Gregor

**Changes**:
- Added `Stockschraube HSW M12x140/60 8.8` (short hanger bolt)
- Article number 216376
- 140 mm total length option

### Version 1.8 (10.12.2024)

**HSB-19771**: Changed TSL to the requirements of Hilti

**Author**: Nils Gregor

**Changes**:
- Updated to match Hilti HCWL specifications
- Revised hardware definitions
- Improved fastener selection logic

### Version 1.7 (29.11.2024)

**20241129**: Fix when drawing symbol

**Author**: Marsel Nakuci

**Changes**:
- Fixed symbol display orientation
- Corrected side parameter in symbol drawing
- Improved visual representation

### Version 1.6 (08.10.2024)

**HSB-19771**: Change TSL image

**Author**: Marsel Nakuci

**Changes**:
- Updated script icon/image
- Improved visual identification in TSL browser

### Version 1.5 (24.09.2024)

**HSB-19771**: Fix drilling position (apply Z-offset) for the hanger bolt/Concrete fastener (Stockschraube/Bolzenanker)

**Author**: Marsel Nakuci

**Changes**:
- Corrected pilot drill positioning
- Applied Z-offset to fastener drill location
- Improved machining accuracy

### Version 1.4 (20.09.2024)

**HSB-19771**: Fix when identifying male and female panel at "distinguishMaleFemaleFrom2Sips"

**Author**: Marsel Nakuci

**Changes**:
- Improved male-female detection algorithm
- Fixed edge cases in panel orientation detection
- Updated shadow profile analysis

### Version 1.3 (13.09.2024)

**HSB-19771**: Fix when calculating the distribution line of a male-female panel

**Author**: Marsel Nakuci

**Changes**:
- Corrected distribution line calculation
- Fixed shadow profile issues for near-parallel panels
- Improved error handling

### Version 1.2 (22.08.2024)

**HSB-19771**: Enable insertion of one single connector by point

**Author**: Marsel Nakuci

**Changes**:
- Implemented single-point insertion mode (Mode 101, 102)
- Added Interdistance = 0 trigger
- Enabled precise point-based placement

### Version 1.1 (19.06.2024)

**HSB-22250**: Initial: Add block display of the connectors

**Author**: Marsel Nakuci

**Changes**:
- Added 3D block display support (HCWL.dwg)
- Implemented fallback circle display
- Improved visual representation

### Version 1.0 (18.06.2024)

**HSB-22250**: Initial version

**Author**: Marsel Nakuci

**Initial Features**:
- Male-female panel connections
- Single panel to concrete connections
- Fixed and even distribution modes
- Automatic machining operations
- Hardware BOM generation
- Basic visual display

## Related Scripts

### Complementary TSL Scripts

**hsbCLT-JointBoard**
- Purpose: Creates joint boards at CLT panel connections
- Relationship: Can be used in conjunction with HCWL for enhanced joint stiffness
- Use Case: Panel-to-panel connections requiring additional bracing

**hsbCLT-Opening**
- Purpose: Creates openings in CLT panels
- Relationship: Openings may require additional HCWL connectors around perimeter
- Use Case: Window/door openings with reinforced connections

**hsbCLT-Slot**
- Purpose: Creates slot connections in CLT panels
- Relationship: Alternative connection method for panel joints
- Use Case: When HCWL not suitable (e.g., parallel panels)

**Hilti-Verankerung**
- Purpose: General Hilti anchoring system
- Relationship: Broader anchoring tool, HCWL-Hilti is specialized for CLT
- Use Case: Other Hilti anchor types not covered by HCWL

**Hilti-P2P (Panel-to-Panel)**
- Purpose: Other Hilti panel connection systems
- Relationship: Alternative connector technology
- Use Case: Different load requirements or connection geometries

### Workflow Integration

**Upstream Scripts** (Create panels first):
1. **hsbCLT-MasterPanelManager**: Create and manage CLT panel library
2. **Element creation scripts**: Generate wall/floor elements with CLT panels

**Concurrent Scripts** (Used during same design phase):
1. **hsbCLT-Drill**: Add additional drilling operations
2. **hsbCLT-Opening**: Define window/door openings
3. **hsbCLT-Lift**: Define lifting points for transportation

**Downstream Scripts** (After HCWL placement):
1. **hsbCLT-QC**: Quality control and validation
2. **HSB_G-BillOfMaterial**: Generate BOM reports (includes HCWL hardware)
3. **sd_* (Shop Drawing scripts)**: Create fabrication drawings with connector details

### Hardware Vendor Scripts

**Simpson StrongTie Series**:
- Simpson StrongTie Anchor
- Simpson StrongTie BT (Beam Ties)
- Alternative connector vendor for timber construction

**Rothoblaas Series**:
- Rothoblaas WHT (Hidden connectors)
- Rothoblaas Titan (Angle brackets)
- Alternative European connector systems

**BMF Series**:
- BMF Balkenschuh (Beam hangers)
- BMF U Shoe
- Alternative German connector manufacturer

## FAQ (Frequently Asked Questions)

### General Questions

**Q: What does HCWL stand for?**

A: **HCW-L** = **H**eavy **C**onnector **W**ood - **L**ong. It's Hilti's designation for this heavy-duty wood coupler system designed for prefabricated timber structures.

**Q: Can I use this script for non-CLT panels (e.g., LVL, Glulam)?**

A: The script is designed specifically for **Sip entities** (CLT panels in hsbCAD). For other timber products like LVL or Glulam beams, use generic fastener scripts or adapt the tooling manually.

**Q: Is HCWL suitable for seismic zones?**

A: Consult Hilti engineering data and local structural codes. HCWL is designed for structural connections, but seismic design requires engineering validation for specific load cases.

**Q: Can I modify connector positions after insertion?**

A: Yes, in two ways:
1. **Distributed instances**: Adjust distribution parameters in Properties Palette
2. **Individual instances**: Right-click → "Explode distribution" → Move individual connectors

### Technical Questions

**Q: Why does the script reject my panel selection?**

A: The script requires:
1. **Valid Sip entity** (not Beam, Solid, or other types)
2. **Minimum 80 mm solid height**
3. **Perpendicular orientation** (for male-female mode)
4. **Within 50 mm proximity** (for male-female mode)

Check error messages for specific rejection reason.

**Q: How do I change the connector side after insertion?**

A: Right-click on the connector instance and select **"Flip Side"** from the context menu. The script will recalculate all positions on the opposite panel face.

**Q: Can I edit individual connectors in a distributed row?**

A: Yes. Right-click and select **"Explode distribution"** to convert the row into individual instances. Each connector becomes independently editable (move, delete, modify parameters). Warning: This operation is irreversible - you cannot re-combine instances.

**Q: Why are some fastener options automatically changed?**

A: The script validates fastener compatibility:
- **Male-female timber connections**: Requires timber hanger bolts (HSW series)
- **User selects concrete anchor** (HST3, HAS-U): Auto-switches to HSW M12x220/60
- **Reason**: Concrete anchors unsuitable for timber-to-timber joints

**Q: The distribution shows an error "no distribution possible" - what should I do?**

A: This occurs when Start Offset + End Offset exceeds available connection length. Solutions:
1. Reduce Start Offset (e.g., from 350 mm to 150 mm)
2. Reduce End Offset similarly
3. Increase Interdistance (larger spacing = fewer connectors needed)
4. For very short connections: Use single-point mode (Interdistance = 0)

**Q: How do I connect multiple male panels to multiple female panels?**

A: Select all male panels in first prompt, then all female panels in second prompt. The script automatically:
1. Analyzes all panel pairs
2. Detects perpendicular relationships
3. Validates proximity (within 50 mm)
4. Creates separate instances for each valid pair

**Q: Where are the hardware quantities reported?**

A: Hardware components are:
1. Linked to TSL instance
2. Appear in hsbCAD hardware reports
3. Included in BOM listings via HSB_G-BillOfMaterial
4. Quantity automatically matches connector count

**Q: Why are the distribution properties (Start Offset, End Offset, etc.) grayed out?**

A: Properties are hidden in **single-instance mode** (Mode 101/102). This occurs when:
1. Interdistance set to 0 during insertion, or
2. After using "Explode distribution"

Distribution properties only relevant for distributed connectors, not individual points.

**Q: The script says "No male panel found" - what does this mean?**

A: Ensure you selected a valid **Sip panel entity**. Common mistakes:
1. Selected a **GenBeam** instead of Sip
2. Selected a **Polyline** outline
3. Panel corrupted or invalid
4. Panel thickness < 80 mm (rejected during validation)

Check entity type: Right-click → Properties → Entity Type should show "Sip"

**Q: How do I update the fastener size after insertion?**

A:
1. Select the connector instance
2. Open Properties Palette (Ctrl+1 or double-click)
3. Change **Fastener** dropdown to new selection
4. Hardware automatically updates in BOM

**Q: Can I use this script for wall-to-roof connections?**

A: Yes, as long as:
1. Both are CLT panels (Sip entities)
2. Panels perpendicular to each other (wall vertical, roof angled)
3. Minimum 80 mm thickness for both
4. Structural engineer approves connection for roof loads

**Q: What is the "Depth" parameter used for?**

A: **Depth** controls milling at the **female panel**:
- **0 mm**: No milling, fastener on surface
- **> 0 mm**: Round housing milled into female panel
  - Diameter: 42 mm
  - Actual depth: 2 × Depth (double-sided)
  - **Purpose**: Recess fastener for flush appearance or clearance

### Installation & Workflow Questions

**Q: Do I need to install anything before using this script?**

A: Optional but recommended:
- **HCWL.dwg block file**: Place in `[Company Path]\Block\` for 3D visualization
- If not installed: Script works but displays circles instead of 3D blocks

**Q: What's the recommended workflow for a building with multiple CLT panels?**

A:
1. **Create all CLT panels** first (using hsbCLT-MasterPanelManager or Element tools)
2. **Define openings** (hsbCLT-Opening for windows/doors)
3. **Apply HCWL connectors** to panel intersections (this script)
4. **Add other hardware** (hangers, straps, etc. with other scripts)
5. **Generate BOM** (HSB_G-BillOfMaterial)
6. **Create shop drawings** (sd_* scripts)
7. **Quality check** (hsbCLT-QC)

**Q: Should I use Fixed or Even Distribution?**

A:
- **Fixed Distribution**:
  - Use when engineering specifies exact spacing (e.g., "600 mm on center")
  - May have leftover space at end
  - Example: Building codes require max 600 mm spacing
- **Even Distribution**:
  - Use for aesthetic purposes or to fill length optimally
  - Calculates even spacing to distribute connectors across entire length
  - Example: Maximize connector count for given length

**Q: How do I handle panels of different thicknesses?**

A: Use **Offset Y** parameter:
1. Calculate thickness difference: e.g., 100 mm vs. 140 mm = 40 mm difference
2. Set Offset Y = -20 mm (half the difference)
3. Connectors align at midpoint between panel faces
4. Adjust as needed for eccentric load transfer

**Q: What's the maximum spacing allowed between connectors?**

A: Not enforced by script, but follow:
1. **Hilti engineering guidelines** for HCWL load capacity
2. **Structural code requirements** for CLT connections
3. **Engineering calculations** for specific loads
4. Typical range: 400-1200 mm depending on loads

**Q: Can I delete some connectors from a distribution without affecting others?**

A: Yes, using "Explode distribution":
1. Right-click distributed instance
2. Select "Explode distribution"
3. Individual instances created for each connector
4. Delete unwanted connectors
5. Keep, move, or modify remaining connectors independently

### Troubleshooting Questions

**Q: Connectors appear on the wrong side of the panel - how do I fix this?**

A: Use **Flip Side** command:
1. Right-click connector instance
2. Select "Flip Side"
3. Connectors regenerate on opposite face
4. Script recalculates all machining and hardware

**Q: Script reports "Panels not parallel" but they look perpendicular - why?**

A: The error message is misleading - it actually means "Panels ARE parallel" (not perpendicular as required). Check:
1. Panel normal vectors (should be at 90 degrees)
2. Panel rotation (ensure true perpendicularity, not just visual appearance)
3. For male-female mode, panels MUST be perpendicular

**Q: Hardware not showing in BOM report - what's wrong?**

A: Check:
1. **Hardware generated**: Select instance → Properties → Check hardware components
2. **RepType correct**: Should be `_kRTTsl`
3. **Group assignment**: Hardware inherits element/group from panel
4. **BOM filters**: May exclude TSL-generated hardware by default
5. **Instance regenerated**: Delete and recreate if necessary

**Q: Performance is slow when selecting many panels - is this normal?**

A: Yes, for batch operations:
- **Complexity**: N male × M female = up to N×M pair checks
- **Solution**: Select panels in smaller batches
- **Example**: 10 × 10 panels = 100 checks (only valid pairs created)

**Q: Can I use this for timber frame (stick frame) construction?**

A: No, this script is specifically for **CLT panels** (Sip entities). For stick frame:
- Use **Simpson StrongTie** scripts for hangers/connectors
- Use **Hilti-P2P** or other timber connection scripts
- hsbCLT-Hilti requires solid CLT panels, not framed walls

## Best Practices

### Design Phase

1. **Panel Thickness**:
   - Use minimum 100 mm panels for robust connections
   - 80 mm minimum supported, but thicker preferred for flush mounting
   - Consider machining depth when selecting panel thickness

2. **Connection Planning**:
   - Plan connector locations before modeling panels
   - Consider structural loads and transfer paths
   - Coordinate with structural engineer for spacing requirements

3. **Distribution Strategy**:
   - Start with Fixed Distribution for code-compliant spacing
   - Use Even Distribution to optimize connector count
   - Single-point mode for special load points or irregular spacing

### Modeling Phase

1. **Panel Creation Order**:
   - Create all panels before applying connectors
   - Ensure panels properly aligned (within 50 mm tolerance)
   - Verify perpendicularity for male-female connections

2. **Edge Distances**:
   - Use conservative Start/End Offsets (minimum 150 mm recommended)
   - Minimum 72 mm required by script, but 150+ mm better for edge loads
   - Coordinate with opening locations (windows, doors)

3. **Parameter Selection**:
   - **Position**: Start with "Panel Outside" (simplest machining)
   - **Fastener**: HSW series for timber-to-timber, HST3/HAS-U for concrete
   - **Offset Y**: Use for panels of different thicknesses

### Production Phase

1. **Shop Drawing Integration**:
   - HCWL connectors appear in shop drawings automatically
   - Verify machining operations visible in panel drawings
   - Check hardware callouts in BOM

2. **CNC Preparation**:
   - Export machining operations to CNC
   - Mortises and pilot holes ready for production
   - Verify tool paths before machining

3. **BOM Verification**:
   - Check hardware quantities match connector count
   - Verify article numbers for procurement
   - Confirm fastener types appropriate for application

### Installation Phase

1. **On-Site Assembly**:
   - HCWL couplers pre-installed on male panels (factory)
   - Fasteners installed on-site
   - Verify connector alignment before fastening

2. **Quality Control**:
   - Check machining accuracy (mortise depth, diameter)
   - Verify fastener engagement depth
   - Ensure proper torque on threaded connections

### Maintenance & Updates

1. **Modifications**:
   - If design changes: Delete and recreate instances (ensures consistency)
   - Use "Explode distribution" for minor adjustments only
   - Document all changes for coordination

2. **Version Control**:
   - Track script version used in project
   - Update to latest version for new features/fixes
   - Test updates on sample panels before production

---

## Summary

**hsbCLT-Hilti** is a sophisticated TSL script providing comprehensive automation for Hilti HCWL connector placement in CLT construction. With support for male-female panel connections, single panel concrete anchoring, flexible distribution modes, and automatic machining/hardware generation, it streamlines the connection design process from initial modeling through fabrication.

**Key strengths**:
- Intelligent male-female panel detection
- Flexible distribution (fixed, even, single-point)
- Automatic side detection with manual override
- Comprehensive machining operations
- Integrated hardware BOM generation
- Visual representation (3D blocks or symbols)

**Typical workflow**:
1. Create CLT panels
2. Launch hsbCLT-Hilti
3. Configure distribution parameters
4. Select panels (male, then female)
5. Script automatically distributes connectors
6. Adjust with Flip Side or Explode distribution if needed
7. Generate shop drawings and BOM

For complex projects with multiple panel intersections, the script's batch creation mode (Mode 0) efficiently handles numerous connections simultaneously, while single-point mode provides precision for engineered load points.

**Version**: 1.10 (30.10.2025)
**Author**: Marsel Nakuci
**Manufacturer**: Hilti
**Product**: HCWL 40x295 M12 Wood Coupler System

---

*Documentation generated for hsbCAD TSL Knowledge Base*
*For technical support: Contact hsbCAD support team*
*For product specifications: Refer to Hilti HCWL engineering documentation*
