# XRefPropertySetter

## Overview

XRefPropertySetter overrides property values for elements, beams, and master panels that originate from external references (XRefs). It allows you to prefix, append, or replace property values without modifying the original XRef file, storing overrides locally in the current drawing.

## Usage Environment

| Item | Details |
|------|---------|
| **Script Type** | O-Type (Object/Tool) |
| **Execution Space** | Model Space |
| **Required Entities** | Elements, GenBeams, or MasterPanels from external references (XRefs) |
| **Output** | Property overrides stored in XRef BlockRef's subMapX data |

## Prerequisites

- At least one external reference (XRef) containing elements, beams, or master panels must be present
- Understanding of which properties you want to override
- Knowledge of the property naming system (e.g., "ElementNumber", "Material", "ColorIndex")

## Usage Steps

1. **Launch the Tool**
   - Execute the XRefPropertySetter command
   - The properties dialog appears

2. **Configure Override Settings**
   - **For Element Properties**:
     - Select Property from dropdown (e.g., "ElementNumber", "Material")
     - Enter Value to apply
     - Choose Mode: Append, Prefix, or Replace
   - **For GenBeam Properties** (if GenBeams exist in XRef):
     - Select GenBeam Property
     - Enter Value
     - Choose Mode
   - **For MasterPanel Properties** (if MasterPanels exist in XRef):
     - Select MasterPanel Property
     - Enter Value
     - Choose Mode

3. **Select XRef Entities**
   - Click on elements, beams, or panels from the external reference
   - The tool stores which entities you selected
   - Click to place the tool marker

4. **Verify Overrides**
   - The tool displays a label showing:
     - Which property is being modified
     - The override value
     - How many entities are affected per XRef
   - A colored boundary shows which XRef block contains the overridden entities

5. **Manage Overrides**
   - Right-click to Add Entities, Remove Entities, or Reset+Erase all overrides

## Properties Panel Parameters

### Element Category

| Parameter | Type | Description |
|-----------|------|-------------|
| **Property** | Choice | Which element property to override (e.g., Material, ColorIndex, ElementNumber, ElementType) |
| **Value** | Text | The value to apply (can be text, number, or formatObject expression) |
| **Mode** | Choice | How to apply: "Append" (add to end), "Prefix" (add to start), "Replace" (completely replace) |

### GenBeam Category

| Parameter | Type | Description |
|-----------|------|-------------|
| **Property** | Choice | Which beam property to override (e.g., Material, Name, Description) |
| **Value** | Text | The value to apply |
| **Mode** | Choice | Append, Prefix, or Replace |

### Masterpanel Category

| Parameter | Type | Description |
|-----------|------|-------------|
| **Property** | Choice | Which master panel property to override |
| **Value** | Text | The value to apply |
| **Mode** | Choice | Append, Prefix, or Replace |

### Display Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Text Height** | Length | 200 mm | Size of the label text |
| **Color** | Integer | -1 | Display color (-1 = automatic) |

## Right-Click Menu

| Command | Description |
|---------|-------------|
| **Add Entities** | Add more XRef entities to the override set |
| **Remove Entities** | Remove entities from the override set |
| **Reset+Erase** | Clear all overrides for the associated XRefs and delete the tool |

## Settings Files

This tool does not use external XML settings files. All override data is stored in the drawing's `hsb_XRefContent` subMapX structure on the XRef BlockRef objects.

## Tips

- **Property Naming**: Not all properties are available for override. The tool excludes system properties like:
  - DrawingProperties, UniqueID, Handle
  - Calculated values: Width, Height, Length, Volume
  - Internal identifiers: HostID, HsbID, Beamcode
  - GroupXXX properties, SizeXXX properties, LineXXX properties

- **Mode Examples**:
  - **Append**: Original value "WF-01" + Value "-EXT" = "WF-01-EXT"
  - **Prefix**: Value "EXT-" + Original value "WF-01" = "EXT-WF-01"
  - **Replace**: Ignores original, uses only Value = "NEW-01"

- **ElementNumber Special Handling**: When overriding ElementNumber, the tool automatically extracts just the number portion (after the "|" separator) and applies the modification to that.

- **Multiple XRefs**: If you select entities from different XRef blocks, the tool tracks each XRef separately and displays a count per XRef.

- **Persistent Overrides**: Overrides are stored in the current drawing and persist across sessions. Reloading the XRef does not erase the overrides.

- **Visual Indicator**: The tool draws a semi-transparent colored rectangle around each affected XRef block boundary, with a label showing which XRef number and entity type is overridden.

- **Relocation**: You can drag the tool's insertion point to reposition the label without affecting the overrides.

- **Reset Workflow**: To completely remove all overrides for an XRef:
  1. Select any XRefPropertySetter tool attached to that XRef
  2. Right-click → Reset+Erase
  3. This clears the hsb_XRefContent data and deletes all PropertySetter tools

## FAQ

**Q: Why don't I see any properties in the dropdown list?**
A: Verify that:
  - At least one XRef is loaded with elements, beams, or master panels
  - The XRef contains the entity type you're trying to override
  - The property isn't in the exclusion list (system properties, GroupXXX, etc.)

**Q: Do overrides modify the original XRef file?**
A: No. Overrides are stored only in the current drawing's XRef BlockRef data. The source XRef file remains unchanged.

**Q: Can I override the same property multiple times?**
A: Yes, but only the last override will be active. Inserting a new PropertySetter for the same entity/property will replace the previous override.

**Q: What happens if I change the XRef attachment path?**
A: Overrides are linked to the specific BlockRef object. Detaching and reattaching the XRef will lose the overrides. Reloading the same XRef (without detaching) preserves them.

**Q: Can I override properties for nested XRefs?**
A: Yes. The tool uses `allowNested(true)` when selecting entities, so you can select objects inside nested XRefs.

**Q: How do I see which entities have overrides?**
A: Look at the tool's label. It shows:
  - The property being overridden
  - The override value/mode
  - Count of affected entities per XRef

**Q: Can I export override settings to reuse in other drawings?**
A: Not directly. Overrides are drawing-specific. To replicate:
  1. Note the Property, Value, and Mode settings
  2. Insert XRefPropertySetter in the new drawing
  3. Manually configure the same settings
  4. Select corresponding entities

**Q: What's the difference between disabling a property and setting it to "<Disabled>"?**
A: Setting a property dropdown to "<Disabled>" tells the tool to skip that entity type. For example:
  - Element Property = "<Disabled>" means no element overrides
  - GenBeam Property = "Material" means beam overrides are active

**Q: Can I override nested properties like "GroupName1" or "DetailPath1"?**
A: No. The tool excludes properties with prefixes: "Group", "Detail", "hsb_xrefcontent", "hsbresponsibilityset", "Line", "Size".

**Q: How do I remove overrides from specific entities without deleting the tool?**
A: Right-click → Remove Entities, then select the entities you want to un-override. The tool will stop modifying those entities while keeping overrides on others.

**Q: What happens if multiple PropertySetter tools override the same property?**
A: The behavior is undefined. Avoid this situation by using a single tool per property/XRef combination or using Reset+Erase before creating new overrides.
