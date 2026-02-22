# GA.mcr - Generic Angle Bracket

## Overview

| Property | Value |
|----------|-------|
| **Script Name** | GA |
| **Type** | Object (O) |
| **Version** | 2.16 |
| **Category** | Hardware / Connectors |
| **Keywords** | simpson, strong, tie, angle, bracket, winkel |

The Generic Angle Bracket (GA) script creates configurable metal angle brackets for timber connections. It supports both **single-beam surface mounting** and **dual-beam T-connections**, automatically generating the 3D bracket geometry and optional material milling (cutouts) for flush installation.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary workspace - modifies beams and generates hardware bodies |
| Paper Space | No | Not designed for 2D detailing |
| Shop Drawing | No | Does not generate shop drawing views directly |

## Prerequisites

- **Required Entities**: At least one `GenBeam` (Beam, Sheet, or Panel)
- **Maximum Beams**: 2 (for T-connections)
- **Settings File**: `GenericAngle.xml` or manufacturer-specific XML catalogs
- **Settings Locations**:
  1. Company folder: `_kPathHsbCompany\TSL\Settings\`
  2. Install folder: `_kPathHsbInstall\Content\General\TSL\Settings\`

## Usage Workflow

### Step 1: Launch Script

Command: `TSLINSERT` then select `GA` from the script list, or use command shortcuts:

```
Command: (hsb_ScriptInsert "GA" "AA60280")
Command: (hsb_ScriptInsert "GA" "AB")
Command: (hsb_ScriptInsert "GA" "AB?AB70")
```

The command parameter format is: `Manufacturer?Family?Product`

### Step 2: Select Manufacturer and Product

A dialog appears with cascading dropdown selections:

1. **Manufacturer** - Select the hardware brand (e.g., Simpson, Hilti, Rothoblaas)
2. **Family** - Select the product series within the manufacturer
3. **Product** - Select the specific bracket model code
4. **Nail** - Select the fastener type (nail, screw, etc.)
5. **Milling Type** - Choose how the material should be cut
6. **Tolerance** - Set clearance value for pocket cuts

### Step 3: Select Beams

```
Command Line: Select genBeam(s)
```

- **Single Beam**: Click one beam, bracket attaches to the face nearest your click point
- **Dual Beams**: Click two beams for a T-connection at their intersection

### Step 4: Specify Position

```
Command Line: Select the Point
```

Click to place the bracket:
- The **Grip Point** (blue square) controls which edge/face the bracket attaches to
- For two beams, the bracket is placed at the intersection line

### Step 5: Repeat or Exit

The script continues prompting for new placements (up to 20 times). Press **ESC** or cancel selection to exit.

## Properties Panel Parameters

### General Properties

| Parameter | Type | Description |
|-----------|------|-------------|
| **Manufacturer** | String (dropdown) | Hardware supplier brand. Cannot be changed after insertion. |
| **Family** | String (dropdown) | Product series within the selected manufacturer. Updates Product list when changed. |
| **Product** | String (dropdown) | Specific bracket model code. Determines dimensions (A, B, C, t). |
| **Nail** | String (dropdown) | Fastener type for BOM/export (nail, screw, etc.) |

### Milling Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Milling Type** | String (dropdown) | none | Defines how material is cut for bracket recess |
| **Tolerance** | Double (mm) | 0.0 | Extra clearance added to milling pocket for fit adjustment |

#### Milling Type Options

| Value | Behavior |
|-------|----------|
| **none** | No material removal; bracket sits on surface |
| **male** | Cuts pocket on the side where bracket leg extends outward |
| **female** | Cuts pocket on the side where bracket leg is recessed |
| **both** | Cuts pockets on both beam faces for fully flush installation |

### Product Dimensions (Read from XML)

| Dimension | Description |
|-----------|-------------|
| **A** | Horizontal depth of bracket (Leg 2) |
| **B** | Horizontal width of bracket (Leg 1) |
| **C** | Vertical height of bracket |
| **t** | Steel material thickness |

## Context Menu Options

### For Single Beam Connections

| Menu Item | Description |
|-----------|-------------|
| **Add genBeam** | Add a second beam to create a T-connection |
| **Rotate 180 degrees** | Flip bracket orientation 180 degrees |
| **swap legs** | Swap which leg attaches to which face (exchanges A and B usage) |

### For Dual Beam Connections

| Menu Item | Description |
|-----------|-------------|
| **flip genBeams** | Swap primary and secondary beam roles (also via double-click) |
| **Remove genBeam** | Remove one beam from the connection |

## Grip Point Behavior

- **Position**: The grip point (blue square) controls which edge the bracket attaches to
- **Movement**: Drag the grip point to change the attachment edge
- **Automatic Projection**: The grip point automatically projects to the nearest valid edge
- **_Pt0 Tracking**: The insertion point (_Pt0) stays on the intersection line defined by the grip point

## Double-Click Actions

- **Single Beam**: No special action
- **Dual Beams**: Swaps the order of primary and secondary beams, effectively rotating the connection

## Settings File Structure

### File Locations
- Primary: `_kPathHsbCompany\TSL\Settings\GenericAngle_[Manufacturer].xml`
- Fallback: `_kPathHsbInstall\Content\General\TSL\Settings\GenericAngle_[Manufacturer].xml`

### XML Hierarchy

```xml
<Hsb_Map>
  <lst nm="Manufacturer[]">
    <lst nm="Simpson">
      <lst nm="Family[]">
        <lst nm="AA">
          <str nm="FamilyDescription" vl="A-angle brackets"/>
          <lst nm="Product[]">
            <lst nm="AA60280">
              <dbl nm="A" vl="60"/>
              <dbl nm="B" vl="60"/>
              <dbl nm="C" vl="280"/>
              <dbl nm="t" vl="2"/>
              <lst nm="DiamType[]">
                <lst nm="Nail">
                  <dbl nm="Diameter" vl="4"/>
                  <int nm="Number" vl="12"/>
                </lst>
              </lst>
            </lst>
          </lst>
          <lst nm="Nail[]">
            <lst nm="Nail">
              <str nm="Name" vl="CNA4"/>
            </lst>
          </lst>
          <lst nm="Milling">
            <str nm="Milling" vl="none"/>
            <dbl nm="Tolerance" vl="0"/>
          </lst>
        </lst>
      </lst>
      <str nm="Material" vl="Steel Galvanized"/>
    </lst>
  </lst>
  <lst nm="GeneralMapObject">
    <int nm="Version" vl="1"/>
  </lst>
</Hsb_Map>
```

## Hardware Component Export

The script generates hardware components for BOM export:

| Component | Properties Set |
|-----------|---------------|
| **Bracket** | Article Number = Product Code, Manufacturer, Model = Family, Description = FamilyDescription, Material, Category = "Connector" |
| **Fasteners** | Article Number = Nail Name, Quantity, Diameter |

## Tips and Best Practices

### Positioning
- **Moving the Bracket**: Select the script and drag the **Grip Point** to move along the edge
- **Changing Attachment Face**: Move the grip point closer to the desired face
- **T-Connection Placement**: If click point is outside valid range, bracket auto-centers on the common edge

### Orientation
- **Bracket Facing Wrong Way**: Use right-click menu **Rotate 180 degrees**
- **Wrong Leg Assignment**: Use right-click menu **swap legs** (single beam only)
- **Flip Beam Order**: Double-click the bracket (dual beam only)

### Milling
- **Bracket Not Cutting**: Check `Milling Type` is not set to "none"
- **Tight Fit**: Increase `Tolerance` value (e.g., 1-2mm) for easier assembly
- **Timber Swelling**: Add tolerance allowance for moisture expansion

### Troubleshooting
- **"No beam found"**: Ensure you selected a valid GenBeam (Beam, Sheet, or Panel)
- **"Could not find any angle data"**: Check XML settings files exist in the correct folders
- **"No Family found for manufacturer"**: Verify manufacturer has family definitions in XML

## Related Scripts

| Script | Purpose |
|--------|---------|
| `GenericHanger` | Similar structure for hanger-type connectors |
| `GA-T` | T-connection specific angle bracket |
| `Simpson*` | Manufacturer-specific bracket scripts |
| `Hilti-*` | Hilti brand connector scripts |
| `Rothoblaas-*` | Rothoblaas brand connector scripts |

## Version History Highlights

| Version | Date | Changes |
|---------|------|---------|
| 2.16 | 13.09.2024 | Added validation when getting available families for chosen manufacturer |
| 2.15 | 07.10.2022 | Company XML takes priority; don't load Content\General XMLs if company file exists |
| 2.14 | 07.10.2022 | Family written to "Model" field; FamilyDescription to "Description" field in hardware |
| 2.13 | 09.09.2022 | New XML structure aligned with GenericHanger |
| 2.12 | 07.09.2022 | XML name changed to AngleBracketCatalog |
| 2.11 | 07.02.2020 | Grip point controls face only; milling fixes for rotation |

## Technical Notes

### Coordinate System
- `vec0`: Normal vector from primary beam face
- `vec1`: Normal vector from secondary beam face (or perpendicular direction for single beam)
- `vecIntersect`: Direction along the intersection line

### BeamCut Operations
Milling generates `BeamCut` tools applied to connected GenBeams:
- Male milling: Cuts pocket for bracket thickness + tolerance
- Female milling: Cuts recess for bracket leg depth
- Both: Combination cut for fully recessed installation

### Dependency Tracking
- Scripts use `setDependencyOnDictObject()` to track XML setting changes
- `setKeepReferenceToGenBeamDuringCopy(_kAllBeams)` maintains beam references during copy operations
