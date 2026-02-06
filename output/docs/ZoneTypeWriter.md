# ZoneTypeWriter

## Overview

ZoneTypeWriter creates polyline-based text markings on wall element sheeting zones using custom character definitions. Unlike standard AutoCAD text, this tool generates physical marker lines that can be output to CNC/manufacturing equipment. It supports automatic placement at wall junctions with intelligent alignment and custom font definitions stored in XML.

## Usage Environment

| Item | Details |
|------|---------|
| **Script Type** | O-Type (Object/Tool) |
| **Execution Space** | Model Space |
| **Required Entities** | Wall element with sheeting zones |
| **Output** | ElemMarker (polyline marking) applied to specified zone |

## Prerequisites

- TypeWriter.xml settings file with character definitions
- Wall element with at least one valid sheeting zone
- Understanding of sheeting zones (negative numbers for interior face, positive for exterior)

## Usage Steps

1. **Launch the Tool**
   - Execute the ZoneTypeWriter command
   - If no characters are defined, you'll be prompted to define them first

2. **Configure Text Content**
   - Set the Format property to define what text to write
     - Use formatObject syntax: `@(ElementType)@(ElementNumber)`
     - Or enter literal text: "W-01"
   - Set Text Height (default 100 mm)

3. **Select Wall Element**
   - Click on a wall element or any item belonging to it
   - For connection-based distribution, select a second connected wall

4. **Choose Zone and Position**
   - Select which sheeting zone (1-5 exterior, -1 to -5 interior)
   - Choose Alignment (Bottom-Left, Bottom-Center, etc.)
   - Set Rotation angle if needed

5. **Select Insertion Mode**
   - **Manual**: Click to place text at specific location
   - **Select Connection**: Automatically place at junction with another wall
   - **All Connections**: Place at all detected junctions
   - **T-Connections**: Only at T-type junctions
   - **L-Connections**: Only at L-type (corner) junctions
   - **Parallel-Connections**: Only where walls run alongside
   - **Mitre-Connections**: Only at angled junctions

6. **Define Custom Characters** (if needed)
   - Right-click → Define Character
   - Draw polyline representation of the character in World XY plane
   - Specify base line reference point
   - Select all polylines for this character
   - Enter the character (single letter/symbol)
   - Repeat for each needed character

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Format** | Text | @(ElementType)@(ElementNumber) | Text to write, supports formatObject syntax |
| **Text Height** | Length | 100 mm | Height of uppercase characters (versal height) |
| **Alignment** | Choice | Bottom-Left | Nine-point alignment: Bottom/Center/Top + Left/Center/Right |
| **Rotation** | Number | 0° | Rotation angle of text in degrees |
| **Zone** | Integer | 1 | Sheeting zone to mark on (positive = exterior, negative = interior) |
| **Mode** | Choice | Manual | Insertion mode (Manual, connection-based, or All Connections) |

## Right-Click Menu

| Command | Description |
|---------|-------------|
| **Select describing element** | Choose a different element to use for format evaluation |
| **Define Character** | Add or modify polyline character definitions |
| **Import Settings** | Load character definitions from TypeWriter.xml file |
| **Export Settings** | Save current character definitions to XML file |

## Settings Files

| File | Purpose | Location |
|------|---------|----------|
| **TypeWriter.xml** | Character definitions (polylines) and font settings | `[Company]\TSL\Settings\TypeWriter.xml` or `[Install]\Content\General\TSL\Settings\TypeWriter.xml` |

### TypeWriter.xml Structure

```xml
<Hsb_Map>
  <lst nm="Font[]">
    <lst nm="Font" nm="Standard">
      <dbl nm="VersalHeight" ut="L" vl="100"/>
      <lst nm="Character[]">
        <lst nm="Character" nm="A">
          <pl nm="pline" vl="(polyline data)"/>
          <pp nm="box" vl="(bounding box PlaneProfile)"/>
        </lst>
        <lst nm="Character" nm="B">
          <!-- Additional characters -->
        </lst>
      </lst>
    </lst>
  </lst>
  <lst nm="GeneralMapObject">
    <int nm="Version" vl="1"/>
  </lst>
</Hsb_Map>
```

## Tips

- **Character Library**: Before first use, define all needed characters (A-Z, 0-9, symbols) using Define Character. Common characters can be saved to XML and reused across projects.

- **Versal Height**: This is the height of uppercase letters (like "A", "H"). The tool scales all characters proportionally based on this standard height.

- **Automatic Junction Placement**: Connection-based modes analyze wall geometry to:
  - Detect junction type (T, L, parallel, mitre)
  - Position text near the connection
  - Automatically flip alignment at wall ends for readability
  - Respect sheeting zone boundaries

- **Format Object Syntax**: The Format field supports:
  - `@(PropertyName)` - Reads any element property
  - `@(ElementType)` - Wall type code
  - `@(ElementNumber)` - Element number
  - Literal text - "WALL-" (combines with properties)

- **Rotation + Alignment**: When rotating text:
  - Horizontal text (0°): Left/Center/Right alignments work as expected
  - Vertical text (90°): Alignment behavior flips (tested for 0° and 90° only)

- **Zone Selection**: Different zones appear on different sheeting faces:
  - Zone 1, 2, 3... = Exterior face (positive Z direction)
  - Zone -1, -2, -3... = Interior face (negative Z direction)
  - Choose zone based on where you want text visible

- **Character Pitch**: Characters are spaced at versal_height / 7 apart by default. Some letters (T, F) use reduced width for better proportions.

- **Outside Zone Warning**: If positioned text falls outside the sheeting zone boundary, the tool displays the polylines in red (color 1) as a warning instead of creating marker lines.

- **Plugin Mode Support**: This tool supports Element Plugin mode (`_bOnMapIO`), allowing it to be attached to element types as a default marking tool.

## FAQ

**Q: Why don't my characters appear on the sheeting?**
A: Check that:
  - Characters are defined in TypeWriter.xml (use Define Character)
  - Text height isn't too large for the zone area
  - Text position (after alignment) falls within the sheeting zone boundaries
  - The zone you selected has sheeting material

**Q: How do I create a new character?**
A:
  1. Draw polyline(s) in World XY plane representing the character shape
  2. Right-click tool → Define Character
  3. Pick base line reference point
  4. Select all polylines for this character
  5. Enter the character (e.g., "A")
  6. Repeat for next character or press Enter to finish

**Q: Can I use lowercase and uppercase?**
A: Yes, but you must define each as a separate character (e.g., define both "A" and "a"). The tool is case-sensitive.

**Q: What happens if a character isn't defined?**
A: The tool will:
  - Report which characters are missing
  - Substitute a placeholder width (versal_height / 3)
  - Continue processing other defined characters

**Q: How do I distribute text on all wall junctions automatically?**
A:
  1. Set Mode to "All Connections" (or specific type like "T-Connections")
  2. Select the wall element
  3. The tool creates separate instances at each detected junction

**Q: Can I change text after placement?**
A: Yes. Modify the Format property or other parameters, and the tool recalculates. The polyline markers update automatically.

**Q: Why is my text backwards or upside down?**
A: Check:
  - Rotation angle (should be 0 for horizontal text)
  - Zone number (negative vs positive affects face direction)
  - Alignment settings for wall start/end auto-flip behavior

**Q: How do I export my character set to share with others?**
A: Right-click → Export Settings. This writes TypeWriter.xml to your company TSL\Settings folder. Copy that file to share.

**Q: What's the difference between Format and a secondary element?**
A:
  - Format is evaluated from the wall element you selected during insertion
  - Right-click → "Select describing element" lets you choose a different element to pull property values from
  - Useful when you want wall A to display information from wall B

**Q: Can I use symbols or special characters?**
A: Yes. Define any symbol as a character (e.g., define "→" as an arrow, "#" as hash). Just make sure you can type it on your keyboard to reference it in Format.

**Q: How do I adjust character spacing?**
A: Character spacing is controlled by the character width definitions plus pitch (versal_height / 7). To change globally, you'd need to modify the source code pitch calculation.

**Q: What happens if I change the wall zone configuration?**
A: If you add/remove sheeting zones, existing ZoneTypeWriter instances may reference invalid zones. Check the Zone property and update if needed.

**Q: Can I place text on floor or roof elements?**
A: Currently, ZoneTypeWriter is designed specifically for ElementWallSF (stick frame walls). For floor/roof marking, you'd need a different tool or manual marker lines.
