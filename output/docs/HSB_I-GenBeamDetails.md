# HSB_I-GenBeamDetails

A diagnostic utility script that displays detailed information about selected GenBeam entities (Beams, Sheets, or SIPs) in the hsbCAD command line.

## Script Metadata

| Property | Value |
|----------|-------|
| Version | 1.0 |
| Date | 14 October 2019 |
| Author | david.rueda@hsbcad.com |
| Type | O (Object) |
| Beams Required | 0 |

## Script Type

**O-Type (Object Script)** - This is a standalone utility that does not require pre-selected beams. It prompts the user to select GenBeam entities during insertion and then displays their properties.

## User Properties

This script has **no user-configurable properties** in the Properties Palette. It is a one-time diagnostic tool that erases itself after displaying information.

## Usage Workflow

### Step 1: Launch the Script
Insert the script into your drawing using the standard hsbCAD TSL insertion method.

### Step 2: Select GenBeam(s)
When prompted with "Select GenBeam(s)", click on one or more timber entities in your drawing:
- Beams
- Sheets (panels)
- SIPs (Structural Insulated Panels)

Press Enter when selection is complete.

### Step 3: View Information
For each selected GenBeam, the script displays a detailed report in the command line including:

**Geometric Properties:**
- Volume (in cubic meters)
- Length (in meters)
- Width (in meters)
- Height (in meters)

**Identification Properties:**
- Position number (posnum)
- Grade
- Profile
- Material
- Label / Sublabel / Sublabel2
- Beamcode
- hsbId
- Module
- Type (as string and number)
- Information field
- Name
- Position number and text
- Layer name
- Color
- Dummy status (bIsDummy)

**Attached TSL Scripts:**
- Lists all TSL instances attached to the GenBeam
- Shows the script name of each attached TSL

### Step 4: Script Self-Erases
After displaying the information, the script automatically removes itself from the drawing. No persistent entity is created.

## Context Menu Commands

This script has **no context menu commands**. It is a single-use diagnostic tool.

## Output Example

The script outputs information in the following format to the command line:

```
-------------------- GenBeam [handle] is of type: Beam --------------------
volume: 0.025
length: 3.000
width: 0.045
height: 0.195
posnum: A1
grade: C24
profile: 45x195
material: Spruce
label: Wall-01
...
Found 3 attached:
    Hilti-X-HSN
    hsbDrill
    hsbCut
```

## Technical Notes

- The script validates that selected entities are valid GenBeam types (Beam, Sheet, or SIP)
- Invalid selections are skipped with error messages (visible in debug mode)
- Multiple GenBeams can be selected; each creates a separate TSL instance that reports and self-erases
- Units are automatically converted to meters for display regardless of drawing unit settings
- Debug mode can be enabled via the hsbTSLDebugController MapObject

## Use Cases

1. **Troubleshooting**: Quickly inspect all properties of a beam when investigating issues
2. **Verification**: Confirm material assignments, grades, and position numbers
3. **TSL Audit**: See which TSL scripts are attached to a specific beam
4. **Data Export Preparation**: Review what information is stored on beams before export

## Related Scripts

This script is part of the HSB_I (Information) family of diagnostic utilities in hsbCAD.
