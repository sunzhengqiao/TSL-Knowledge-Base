# TypeWriter

## Overview

TypeWriter creates CNC-milled text on timber beams, sheets, or SIP panels by converting text strings into freeprofile milling toolpaths. It uses a custom polyline-based character font system defined in XML settings. The script can mill text as identifying marks, labels, or custom messages using specified CNC tools. It includes a character definition workflow for creating custom fonts from AutoCAD polyline artwork.

## Usage Environment

| Environment | Supported |
|------------|-----------|
| **Model Space** | Yes (creates freeprofile tools on beams/sheets) |
| **Paper Space** | No |
| **Script Type** | Object (Type O) - Milling tool generator |
| **User Interaction** | High (text formatting, character definition, tool selection) |

## Prerequisites

- **Settings Files**:
  - `TypeWriter.xml` - Character font definitions (in `TSL\Settings\` folder)
  - `hsbCLT-Freeprofile.xml` - CNC tool catalog (diameter, length, mode)
- **For Milling Mode**:
  - Target GenBeam (Beam, Sheet, or Sip) must be selected
  - CNC tool must be selected (not "Disabled")
- **For Character Definition Mode**:
  - Polylines drawn in World XY plane representing character shapes

## Usage Steps

### Basic Text Milling Workflow

1. **Start Script**: Run TypeWriter command
2. **Select Target Beam**:
   - Pick the beam/sheet/panel to receive the milled text
   - Or press `<Enter>` to skip and work in definition mode
3. **Set Properties** (Properties Panel):
   - **Font**: Select character set (e.g., "Standard")
   - **Font Height**: Set milling height (default: 200mm)
   - **Format**: Enter text string or format code (e.g., `@(mpLabel.stLabel)`)
   - **Tool**: Select CNC milling tool (e.g., "Finger Mill", "Universal Mill")
   - **Depth**: Set milling depth into beam surface (default: 20mm)
4. **Position Text**: The script places text at the clicked insertion point on the beam face
5. **Preview**: Text appears with toolpath visualization (yellow = tool path, red = out-of-bounds areas)

### Character Definition Workflow (Creating Custom Fonts)

1. **Create Character Linework**:
   - Use AutoCAD `DTEXT` or `TEXT` to place text in desired font
   - Run `_CREATEHLR` to convert text to linework (hidden line removal)
   - Run `_EXPLODE` to explode the resulting block
   - Run `_PEDIT` to join lines into polylines (one polyline per character stroke)
2. **Switch to Definition Mode**:
   - Set **Preview Mode** property to "Defined Characters"
3. **Define Characters**:
   - Right-click → **Define Character**
   - Pick the **base line point** (where character sits on the line)
   - Select polylines representing one character
   - Enter the character in the prompt (e.g., "A", "5", "&")
   - Repeat for each character
4. **Set Reference Height**:
   - Adjust **Height** property in "Character Definition" category to match your drawing's capital letter height
5. **Export Settings**:
   - Right-click → **Export Settings**
   - Saves custom font to `TSL\Settings\TypeWriter.xml`

## Properties Panel Parameters

### Text Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Format** | String | (empty) | Text to mill. Can be literal text or format code (e.g., `@(mpLabel.stLabel)` for beam label) |
| **Font Height** | Double | 200mm | Height of milled characters |
| **Pitch Factor** | Double | 1.0 | Horizontal spacing multiplier between characters (1.0 = default spacing) |
| **Font** | Dropdown | (first available) | Character set name from settings |
| **Preview Mode** | Dropdown | "Alphabet" | Display mode: "Alphabet" (all defined characters), "Defined Characters" (definition mode), "Format" (format string result) |

### Tool Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Tool** | Dropdown | "&lt;Disabled&gt;" | CNC milling tool selection from `hsbCLT-Freeprofile.xml` catalog |
| **Depth** | Double | 20mm | Milling depth into beam surface |

### Character Definition Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Height** | Double | 100mm | Reference height for character definition (capital letter height). Hidden when not in definition mode |

## Right-Click Menu

| Command | Function |
|---------|----------|
| **Define Character** | Opens interactive workflow to create/edit character definitions from polylines |
| **Add Genbeam** | Prompts to select additional beam to apply milling |
| **Remove Genbeam** | Prompts to remove selected beam from milling targets |
| **Import Settings** | Loads TypeWriter.xml from disk (replaces current font definitions) |
| **Export Settings** | Saves current font definitions to TypeWriter.xml |

## Settings Files

### TypeWriter.xml

Located in: `[Company]\TSL\Settings\TypeWriter.xml` or `[Install]\Content\General\TSL\Settings\TypeWriter.xml`

Structure:
```xml
<Hsb_Map>
  <lst nm="GeneralMapObject">
    <int nm="Version" vl="1"/>
  </lst>
  <lst nm="Font[]">
    <lst nm="Standard">  <!-- Font name -->
      <dbl nm="VersalHeight" ut="L" vl="100"/>  <!-- Capital letter height -->
      <lst nm="Character[]">
        <lst nm="A">  <!-- Character name -->
          <pl nm="pline" ... />  <!-- Polyline path(s) -->
          <pp nm="box" ... />     <!-- Bounding box -->
        </lst>
        <lst nm="B">
          ...
        </lst>
      </lst>
    </lst>
  </lst>
</Hsb_Map>
```

### hsbCLT-Freeprofile.xml

Defines CNC tool catalog (shared with other freeprofile scripts):

```xml
<lst nm="Tool[]">
  <lst nm="FingerMill">
    <str nm="Name" vl="Finger Mill"/>
    <dbl nm="Diameter" ut="L" vl="16"/>
    <dbl nm="Length" ut="L" vl="100"/>
    <int nm="ToolIndex" vl="0"/>
  </lst>
</lst>
```

## Tips

- **Format Strings**: Use format codes to automatically mill beam properties:
  - `@(mpLabel.stLabel)` - Beam label
  - `@(mpLabel.stPosNum)` - Position number
  - Combine with text: `"Beam-@(mpLabel.stPosNum)"`
- **Recommended Font Type**: Simple monotype (monospaced) fonts work best for character definition. Avoid ornate or script fonts
- **Character Spacing**: Default spacing uses width of "i" and "e" characters. Adjust **Pitch Factor** to compress or expand
- **Tool Path Visualization**:
  - **Yellow lines**: CNC tool centerline path
  - **Light blue/yellow fill**: Milled area preview
  - **Red areas**: Toolpath exceeds beam face boundaries (warning)
- **Depth Calculation**: If Depth property is 0, script automatically uses full beam depth
- **Punctuation Adjustment**: Periods, commas, and semicolons automatically receive tighter spacing

## FAQ

### Why does the script say "No character definition found"?

The selected font has no characters defined. Switch **Preview Mode** to "Alphabet" to see instructions for creating character definitions using the Define Character workflow.

### How do I create a polyline-based character?

Follow these steps:
1. Type text in AutoCAD using a simple font (like "Arial" or "Romans")
2. Run `_CREATEHLR` to convert to lines
3. Run `_EXPLODE` on the resulting block
4. Use `_PEDIT` → `Multiple` → `Join` to create continuous polylines
5. Use TypeWriter's **Define Character** command to assign polylines to characters

### Can I mill text on both sides of a beam?

Yes. Insert the script twice, once for each face, or use the **Add Genbeam** command to apply the same text to multiple beams.

### What does "Could not resolve path of character" mean?

This error occurs when a character's polyline is too short or invalid after tool diameter compensation. Try:
- Increasing font height
- Using a smaller tool diameter
- Simplifying the character shape

### How do I change the milling tool?

Modify `hsbCLT-Freeprofile.xml` to add/edit tool definitions. Each tool needs:
- Name (display name)
- Diameter (tool width)
- Length (maximum depth)
- ToolIndex (CNC mode: 0=Finger Mill, 1=Universal Mill, 2=Vertical Finger Mill)

### Why is the text not milling on my beam?

Check:
1. **Tool** property is not set to "&lt;Disabled&gt;"
2. **Format** property contains valid text
3. Beam was selected during insertion
4. Text position falls on the visible beam face (check red warning areas)

### Can I use this for serialization or batch numbering?

Yes! Use format strings with beam properties. For sequential numbering, ensure each beam has a unique PosNum or custom property.

### What happens when text exceeds the beam face?

Areas shown in red indicate where the toolpath extends beyond the beam face. These portions will not mill. Reduce font height or reposition the text.

### How do I share custom fonts with other users?

Export settings to `TypeWriter.xml` and share the file. Other users should place it in their `[Company]\TSL\Settings\` folder, then use **Import Settings**.

### Can I mill curved text or text along a path?

No. TypeWriter creates horizontal text only. For curved labeling, consider using FreeProfile or custom TSL scripts.
