# ErectionSequence

## Overview

**ErectionSequence** is a construction sequencing tool that assigns numerical identifiers to building components to control the order of erection/assembly during construction. This tool enables construction planning by organizing components into building phases and assigning them sequential numbers that determine installation order on site.

**Script Type:** O-Type (Object)
**Version:** 1.8 (January 26, 2022)
**Environment:** Model Space
**Category:** Workflow / Construction Management

---

## Purpose

In timber construction projects, components must be assembled in a specific sequence to ensure structural integrity, safety, and efficiency. ErectionSequence addresses this by:

- **Organizing components by construction phase** (e.g., "Foundation", "First Floor", "Roof")
- **Assigning sequence numbers** that define installation order within each phase
- **Tracking erection order** for walls, beams, panels, floors, and other structural elements
- **Supporting logistics planning** by providing numbered sequences for fabrication and delivery schedules

This tool is essential for:
- Site superintendents planning installation sequences
- Fabrication shops organizing production schedules
- Logistics coordinators scheduling deliveries
- Crane operators planning lift sequences

---

## Application Scenarios

### Typical Use Cases

1. **Multi-Story Building Phases**
   - Phase 1: Foundation walls and posts
   - Phase 2: First floor framing
   - Phase 3: Second floor framing
   - Phase 4: Roof structure
   - Each phase has components numbered 1, 2, 3... in installation order

2. **Wall Panel Erection**
   - Exterior walls: Sequence 1-12 (perimeter installation order)
   - Interior walls: Sequence 13-28 (after exterior is complete)
   - Mechanical walls: Sequence 29-35 (final installation)

3. **CLT Assembly**
   - Floor panels: Numbered by crane lift sequence
   - Wall panels: Numbered by standing order
   - Ensures proper connection sequence for structural integrity

4. **Crane Lift Planning**
   - Heavy elements numbered by crane positioning efficiency
   - Reduces crane repositioning time
   - Optimizes site access and safety zones

---

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary working environment for entity selection and numbering |
| Paper Space | No | Not supported |
| Shop Drawing | No | Not supported |

## Prerequisites

- **Required Entities**: At least one structural element must exist in the model
- **Supported Entity Types**: Panel (Sip), Beam, Sheet, Element (Wall/Floor/Roof)
- **Minimum Beam Count**: 0 (works with any entity type)
- **Required Settings Files**: None

---

## User Interface

### Dialog Parameters

When you insert the ErectionSequence tool, a dialog appears with the following options:

#### 1. **Mode**
Controls what operation the tool performs.

**Options:**
- **Add to sequence** (Default) – Assigns sequence numbers to selected entities
- **Remove sequence** – Removes sequence numbers from selected entities
- **Remove sequence by EntityType** – Removes sequences only from specific entity types
- **Remove sequence by Building Phase** – Removes sequences only from a specific phase

**Usage:**
- Use "Add to sequence" during initial planning or when adding new components
- Use removal modes when reorganizing phases or correcting errors

---

#### 2. **Building Phase**
Defines which construction phase the sequence belongs to.

**Input:** Text entry or selection from dropdown
**Examples:** "Foundation", "Floor 1", "Floor 2", "Roof", "MEP Rough-In"

**Behavior:**
- Dropdown shows all existing phases in the current drawing
- Select **"\<New\>"** to create a new phase name
- When creating new phase, you'll be prompted: "Type phase name. (It will be available on next insertion at dropdown)"
- Phase names are case-sensitive
- Each phase maintains its own independent sequence numbering (Phase "Floor 1" has sequences 1, 2, 3... and Phase "Floor 2" also has 1, 2, 3...)

**Best Practices:**
- Use consistent naming conventions across projects
- Keep phase names short for readability in reports
- Use numbered phases for clarity (e.g., "Phase 1", "Phase 2" rather than vague names)

---

#### 3. **Start Number**
Defines the starting sequence number for new assignments.

**Input:** Integer value
**Default:** -1 (auto-assign next available number)
**Range:** Any integer ≥ -1

**Behavior:**
- **-1**: Tool automatically uses the next available number after existing sequences
- **Positive number**: Forces sequence to start at specified number
- When "Keep existing = No", new numbers can overwrite/shift existing sequences
- When "Keep existing = Yes", tool finds gaps in existing sequences to insert new numbers

**Examples:**
- Start Number = -1, existing sequences (1,2,3) → New items become 4,5,6...
- Start Number = 10, no existing sequences → New items become 10,11,12...
- Start Number = 5, existing sequences (1,2,3,7,8) → New item becomes 5, others shift

---

#### 4. **Keep existing**
Controls behavior when new sequence numbers conflict with existing assignments.

**Options:**
- **No** – New numbers can overwrite/replace existing sequences, shifting others as needed
- **Yes** – Preserves existing numbers, inserts new numbers in gaps

**Behavior (Keep existing = No):**
```
Existing: [1, 2, 3, 7, 8, 9]
Start Number = 4
Selected 2 new items
Result: [1, 2, 3, 4, 5, 7→6, 8→7, 9→8]
                  ↑  ↑  Existing shifted
                  New items
```

**Behavior (Keep existing = Yes):**
```
Existing: [1, 2, 3, 7, 8, 9]
Start Number = 4
Selected 2 new items
Result: [1, 2, 3, 4, 5, 7, 8, 9]
                  ↑  ↑
                  New items fill gaps
```

**Recommendation:**
- Use "No" during initial sequencing (allows complete renumbering)
- Use "Yes" when adding components to already-finalized sequences (prevents disruption)

---

#### 5. **EntityType**
Filters which type of components can receive sequence numbers.

**Options:**
- **Any** – No filtering, sequences can be applied to any entity
- **Panel** – Only SIP panels (Structural Insulated Panels)
- **Beam** – Only timber beams/posts/studs
- **Sheet** – Only sheet materials (plywood, OSB, gypsum)
- **Element** – Only complete assemblies (Wall, Floor, Roof elements)

**Usage:**
- Use **"Any"** when sequencing mixed assemblies
- Use specific filters when organizing by component type
  - Example: Sequence all beams 1-50, then all panels 1-30 separately
- Filter is also used in "Remove sequence by EntityType" mode

**Practical Example:**
```
Scenario: Separating panel and framing sequences
1. First run: EntityType = "Beam", Phase = "Floor 1" → Sequences beams 1-40
2. Second run: EntityType = "Panel", Phase = "Floor 1" → Sequences panels 1-15
Result: Floor 1 has two independent sequences (beams and panels)
```

---

### Command Line Prompts

After configuring dialog parameters, the tool prompts:

**Selection Prompt (varies by EntityType setting):**
- EntityType = "Any": **"Select entity"**
- EntityType = "Panel": **"Select panel"**
- EntityType = "Beam": **"Select beam"**
- EntityType = "Sheet": **"Select sheet"**
- EntityType = "Element": **"Select element"**

**Selection Method:**
- Click entities one-by-one in desired sequence order
- OR use window/crossing selection (sequence determined by spatial sorting)
- Press ENTER when finished selecting

**Removal Mode Prompts:**
- When Mode = "Remove sequence": **"Select objects to remove"**
- When Mode = "Remove sequence by EntityType/Building Phase": Same prompt, but only matching entities are affected

---

### Properties Palette (OPM)

Once ErectionSequence is attached to an entity, the following custom properties are stored in the entity's data:

**Property Category: General**

| Property | Description | Data Type |
|----------|-------------|-----------|
| **Building Phase** | The construction phase name | Text |
| **Sequence Number** | The numeric sequence position | Integer |
| **Sequence Number Text** | Zero-padded text version for sorting | Text |

**Notes:**
- These properties are stored in the entity's MapX data (subMapX key: "Hsb_SequenceChild")
- **SequenceNumber** is an integer (1, 2, 3, ... 11, 12)
- **SequenceNumberText** is zero-padded text ("0001", "0002", ... "0011", "0012")
- **Always use SequenceNumberText for sorting/filtering in reports** to ensure proper text-based sorting (otherwise "11" would sort before "2")

---

## Operation Workflow

### Step-by-Step: Adding Sequences

**Scenario:** Numbering wall panels for a first-floor installation

1. **Launch Command**
   - Type: `TSLCONTENT` (or locate ErectionSequence in hsbCAD menus)
   - Dialog appears

2. **Configure Parameters**
   - **Mode:** "Add to sequence"
   - **Building Phase:** Select existing phase (e.g., "Floor 1") or "\<New\>" to create one
   - **Start Number:** -1 (auto) or specify starting number
   - **Keep existing:** "No" (for initial sequencing) or "Yes" (to preserve existing)
   - **EntityType:** "Element" (if sequencing complete wall assemblies) or "Panel" (for individual panels)
   - Click OK

3. **If Creating New Phase:**
   - Prompt: "Type phase name. (It will be available on next insertion at dropdown)"
   - Type: "Floor 1 Walls"
   - Press ENTER

4. **Select Entities**
   - Command line: "Select element" (or appropriate prompt)
   - **Selection order matters** – click entities in the exact order they should be erected
   - For walls: Start at one corner, proceed clockwise/counterclockwise
   - Press ENTER when all entities selected

5. **Automatic Assignment**
   - Tool immediately assigns sequence numbers
   - Numbers are written to entity MapX data
   - Tool terminates automatically

6. **Verification**
   - Select any sequenced entity
   - Open Properties Palette (Ctrl+1)
   - Look for custom properties showing Building Phase and Sequence Number

---

### Step-by-Step: Removing Sequences

**Scenario:** Removing all sequences from a phase being reorganized

1. **Launch Command**
   - Type: `TSLCONTENT`

2. **Configure Parameters**
   - **Mode:** "Remove sequence by Building Phase"
   - **Building Phase:** "Floor 1 Walls" (the phase to clear)
   - Click OK

3. **Select Entities**
   - Command line: "Select objects to remove"
   - Select all entities (or use window selection)
   - Press ENTER

4. **Automatic Removal**
   - Tool removes sequence data from all entities in specified phase
   - Entities not in "Floor 1 Walls" phase are unaffected
   - Tool terminates

---

### Step-by-Step: Inserting Into Existing Sequence

**Scenario:** Adding 3 new wall panels between existing sequences 5 and 6

1. **Launch Command**
   - Type: `TSLCONTENT`

2. **Configure Parameters**
   - **Mode:** "Add to sequence"
   - **Building Phase:** "Floor 1 Walls" (existing phase)
   - **Start Number:** 6 (insert starting at position 6)
   - **Keep existing:** "No" (allows shifting existing numbers)
   - **EntityType:** "Panel"
   - Click OK

3. **Select New Entities**
   - Command line: "Select panel"
   - Click the 3 new wall panels in erection order
   - Press ENTER

4. **Result:**
   - New panels assigned: 6, 7, 8
   - Old sequences 6→9, 7→10, 8→11 (automatically shifted)
   - Sequences 1-5 remain unchanged

**Alternative (Keep existing = Yes):**
- If gaps exist in current sequences (e.g., 1,2,3,7,8,9)
- Start Number = 4, select 3 panels
- Result: New panels fill gaps 4,5,6 without shifting existing 7,8,9

---

## Data Storage and Technical Details

### MapX Data Structure

The tool stores sequencing data using AutoCAD's extended entity data (XData) via hsbCAD's MapX system:

**Storage Key:** `Hsb_SequenceChild`
**Data Format:** Map object containing:

```
Map: Hsb_SequenceChild
├── "BuildingPhase" (String): "Floor 1 Walls"
├── "SequenceNumber" (Integer): 12
└── "SequenceNumberText" (String): "0012"
```

**Access in Reports:**
- This data can be extracted in BOM (Bill of Materials) reports
- Use SequenceNumberText field for Excel/CSV sorting
- Phase and sequence can be used as grouping/filtering criteria

---

### Text Sorting Format

**Version 1.8 Enhancement (HSB-14337):**

The **SequenceNumberText** property was introduced to solve text-based sorting issues:

**Problem:**
- Integer sorting: 1, 2, 3, ... 10, 11, 12 (correct)
- Text sorting: "1", "10", "11", "12", "2", "3" (incorrect – "10" comes before "2")

**Solution:**
- SequenceNumberText stores zero-padded format: "0001", "0002", ... "0010", "0011", "0012"
- Text sorting now works correctly: "0001", "0002", "0003", ... "0010", "0011", "0012"
- Formatted with 4 leading zeros (supports sequences up to 9999)

**Implementation:**
```
Format String: @(SequenceNumberText:PL4;0)
PL4 = Pad Left to 4 digits
0 = Pad character (zero)
```

**Usage Recommendation:**
- **Always use SequenceNumberText in reports/exports** for proper sorting
- Only use SequenceNumber for mathematical calculations (if needed)

---

### Version History

| Version | Date | Changes |
|---------|------|---------|
| **1.8** | Jan 26, 2022 | **HSB-14337**: Added SequenceNumberText property with zero-padding (PL4 format) for text-based sorting |
| **1.7** | Aug 28, 2020 | **HSB-8663**: Corrected sequence number calculation logic |
| 1.6 | Jul 24, 2020 | **HSB-8095**: Enhanced sequence removal functionality |
| 1.5 | Jul 01, 2020 | **HSB-8094**: Fixed Start Number respect in calculations |
| 1.4 | Feb 14, 2020 | Enhanced insertion method to use/skip ENTER input |
| 1.3 | Jan 20, 2020 | Thumbnail updated for 4K displays |
| 1.2 | Jan 12, 2019 | Selection changed to one-by-one upon ENTER; Phase names case-preserved; Immediate numbering |
| 1.1 | Dec 16, 2019 | Assigned to entity groups for debugging |
| 1.0 | Dec 15, 2019 | Initial release |

---

## Practical Examples

### Example 1: Multi-Phase Building

**Project:** Three-story residential building

**Phase Setup:**
```
Phase "Foundation"
  - Sequence 1-8: Foundation walls
  - Sequence 9-12: Anchor bolts and hold-downs

Phase "Floor 1"
  - Sequence 1-24: Exterior walls
  - Sequence 25-38: Interior walls
  - Sequence 39-45: Floor joists

Phase "Floor 2"
  - Sequence 1-24: Exterior walls
  - Sequence 25-40: Interior walls
  - Sequence 41-48: Floor joists

Phase "Roof"
  - Sequence 1-16: Roof trusses
  - Sequence 17-20: Ridge beams
```

**Workflow:**
1. Complete structural design
2. Run ErectionSequence for Foundation phase (select 20 components)
3. Run ErectionSequence for Floor 1 phase (select 45 components)
4. Continue for each phase
5. Export sequences to fabrication schedule

---

### Example 2: CLT Panel Installation

**Project:** CLT wall and floor assembly

**Sequencing Strategy:**
- **Phase "CLT Walls"**: Panels numbered by perimeter position
- **Phase "CLT Floors"**: Panels numbered by crane reach efficiency

**Process:**
```
1. Launch ErectionSequence
   - Mode: Add to sequence
   - Phase: <New> → "CLT Walls"
   - Start Number: -1
   - Keep existing: No
   - EntityType: Panel

2. Select wall panels:
   - Click panels in clockwise order around building
   - Start at crane setup position
   - Press ENTER

3. Launch ErectionSequence again
   - Mode: Add to sequence
   - Phase: <New> → "CLT Floors"
   - Start Number: 1
   - EntityType: Panel

4. Select floor panels:
   - Click panels in crane lift order
   - Group by crane position zones
   - Press ENTER
```

**Result:**
- Wall panels: CLT Walls #0001 through #0032
- Floor panels: CLT Floors #0001 through #0028
- Export to crane operator's lift plan

---

### Example 3: Correcting Sequences

**Scenario:** Three panels were omitted from initial sequencing

**Original Sequence:**
```
Wall-01: #0001
Wall-02: #0002
Wall-03: #0003
Wall-04: #0004  ← Should be #0007 after insertion
Wall-05: #0005  ← Should be #0008
Wall-06: #0006  ← Should be #0009
```

**New panels to insert between #0003 and #0004:**
```
Wall-07 (new)
Wall-08 (new)
Wall-09 (new)
```

**Correction Process:**
```
1. Launch ErectionSequence
   - Mode: Add to sequence
   - Phase: "Exterior Walls" (existing)
   - Start Number: 4 (insert at position 4)
   - Keep existing: No (allows renumbering)
   - EntityType: Panel

2. Select new panels:
   - Click Wall-07, Wall-08, Wall-09
   - Press ENTER

3. Tool automatically renumbers:
   Wall-01: #0001 (unchanged)
   Wall-02: #0002 (unchanged)
   Wall-03: #0003 (unchanged)
   Wall-07: #0004 (new)
   Wall-08: #0005 (new)
   Wall-09: #0006 (new)
   Wall-04: #0007 (renumbered from #0004)
   Wall-05: #0008 (renumbered from #0005)
   Wall-06: #0009 (renumbered from #0006)
```

---

## Integration with Other Tools

### Bill of Materials (BOM)

ErectionSequence data appears in BOM exports:

**Typical BOM Format:**
```
| Part ID | Description | Phase        | Sequence | Quantity |
|---------|-------------|--------------|----------|----------|
| W-001   | Ext Wall 8' | Floor 1      | 0001     | 1        |
| W-002   | Ext Wall 8' | Floor 1      | 0002     | 1        |
| W-003   | Int Wall 6' | Floor 1      | 0025     | 1        |
| W-004   | Ext Wall 8' | Floor 2      | 0001     | 1        |
```

**Sorting by Phase and Sequence:**
- Group by "Phase" column
- Sort by "Sequence" column (use SequenceNumberText for correct text sorting)
- Result: Components listed in exact erection order

---

### Shop Drawings

Sequence numbers can be displayed on shop drawings:

**Display Methods:**
1. **Text Labels:** Add sequence number as text annotation near component
2. **Callouts:** Include phase and sequence in detail callouts
3. **Legends:** Create installation sequence legends on drawing sheets

**Implementation:**
- Use hsbCAD's label/tag tools to extract MapX data
- Format: "Phase: Floor 1 / Seq: 0012"
- Place near component elevation/section views

---

### Logistics Planning

Sequence data feeds into:

**Delivery Schedules:**
- Group components by phase
- Create delivery windows based on sequence ranges
- Example: "Week 1: Floor 1, Seq 0001-0020"

**Stacking Plans:**
- Reverse sequence order for loading (last-on, first-off)
- Stack panels in reverse: #0020 on bottom, #0001 on top

**Crane Schedules:**
- Sequence defines lift order
- Coordinate with site access and safety zones

---

## Best Practices

### Planning Phase Setup

1. **Use Hierarchical Naming:**
   ```
   Good: "01-Foundation", "02-Floor1", "03-Floor2", "04-Roof"
   Bad:  "A", "B", "C", "D"
   ```
   - Numbers ensure proper sorting
   - Descriptive names improve clarity

2. **Align with Construction Schedule:**
   - Phase names should match construction schedule phases
   - Makes coordination between planning and execution seamless

3. **Separate by Trade if Needed:**
   ```
   "Frame-Floor1"
   "MEP-Floor1"
   "Finish-Floor1"
   ```
   - Helps when different crews work simultaneously

---

### Sequencing Strategy

1. **Consider Site Logistics:**
   - Sequence based on crane position
   - Account for site access constraints
   - Plan for material storage locations

2. **Structural Dependencies:**
   - Load-bearing elements first
   - Supports before supported elements
   - Shear walls before partition walls

3. **Selection Order Matters:**
   - Always click entities in intended erection order
   - Use orthogonal patterns (clockwise, left-to-right)
   - Document your sequencing logic

4. **Review Before Finalizing:**
   - Visually verify sequence numbers on model
   - Check for gaps or duplicates
   - Coordinate with site superintendent

---

### Modification Workflow

1. **Use "Keep existing = Yes" for Small Changes:**
   - Adds new components without disrupting finalized sequences
   - Only works if gaps exist in sequence

2. **Use "Keep existing = No" for Major Reorganization:**
   - Allows complete renumbering
   - Use when initial sequence was incorrect

3. **Remove and Restart for Complete Redesign:**
   - Remove all sequences from phase
   - Resequence from scratch
   - Cleaner than trying to patch existing sequences

---

### Data Quality

1. **Always Use SequenceNumberText in Reports:**
   - Ensures proper sorting in Excel/CSV
   - Avoids "1, 10, 11, 2, 3" sorting errors

2. **Standardize Phase Naming Across Projects:**
   - Create company-wide naming conventions
   - Makes data aggregation easier
   - Improves template reusability

3. **Document Sequencing Logic:**
   - Add notes to drawing explaining sequence strategy
   - Example: "Sequence follows clockwise perimeter starting at NE corner"

---

## Troubleshooting

### Issue: Sequence Numbers Not Appearing in BOM

**Symptoms:**
- BOM export does not show Building Phase or Sequence Number columns
- Properties exist in OPM but don't export

**Solution:**
1. Verify BOM template includes MapX data extraction
2. Check that column mapping includes:
   - `Hsb_SequenceChild.BuildingPhase`
   - `Hsb_SequenceChild.SequenceNumberText`
3. Update BOM configuration to read subMapX data

---

### Issue: Sequences Sort Incorrectly in Excel

**Symptoms:**
- Excel shows: 1, 10, 11, 12, 2, 3, 4, 5, 6, 7, 8, 9
- Expected: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12

**Solution:**
- **Use SequenceNumberText instead of SequenceNumber**
- SequenceNumberText stores zero-padded format ("0001", "0002", ... "0012")
- Text sorting works correctly with padded format

**Excel Workaround (if using SequenceNumber):**
1. Import as Number column, not Text
2. OR convert to number: `=VALUE(A1)` in helper column
3. Sort by helper column

---

### Issue: "Keep existing = Yes" Not Working

**Symptoms:**
- Selected "Keep existing = Yes"
- Existing sequences still get renumbered

**Cause:**
- No gaps exist in current sequence
- Start Number conflicts with existing sequence

**Example:**
```
Existing: 1, 2, 3, 4, 5, 6 (no gaps)
Start Number = 3
Keep existing = Yes
Result: Tool cannot insert without shifting (no gaps to fill)
```

**Solution:**
- Use "Keep existing = No" to allow shifting
- OR manually create gaps first by removing some sequences
- OR use a Start Number beyond existing range

---

### Issue: Wrong Entities Receiving Sequences

**Symptoms:**
- Beams receiving sequences when only walls should be sequenced
- Mixed entity types in phase

**Solution:**
1. Check **EntityType** filter setting
2. Set filter to specific type (e.g., "Element" for walls only)
3. Run separate sequencing operations for different entity types
4. OR use removal mode to clean up incorrect assignments

---

### Issue: Phase Names Duplicated with Different Cases

**Symptoms:**
- "Floor 1" and "floor 1" appear as separate phases

**Cause:**
- Phase names are case-sensitive

**Solution:**
1. Standardize on one case convention (Title Case recommended)
2. Use removal mode to clear incorrect phase
3. Re-sequence with correct phase name
4. Use dropdown selection instead of typing to avoid case mismatches

---

### Issue: Cannot Remove Sequences

**Symptoms:**
- Selected entities, chose "Remove sequence" mode
- Sequences still appear on entities

**Solution:**
1. Verify you're selecting entities that actually have sequences
   - Check Properties Palette for Hsb_SequenceChild MapX
2. If removing by filter:
   - Verify EntityType matches (e.g., don't select Beams if removing Panel sequences)
   - Verify Building Phase matches exactly (case-sensitive)
3. Try "Remove sequence" mode (without filters) first

---

## Related Tools

### Upstream Tools (Prerequisites)

| Tool | Purpose | Relationship |
|------|---------|--------------|
| **hsbCreateElement** | Create wall/floor/roof assemblies | Elements must exist before sequencing |
| **hsbCLT-MasterPanelManager** | Manage CLT panel assemblies | Panels must exist before sequencing |
| **Element design tools** | Design structural components | Complete design before sequencing |

**Workflow Position:** ErectionSequence is used **after** structural design is complete and **before** fabrication/shop drawing production.

---

### Downstream Tools (Consumers)

| Tool | Purpose | Uses Sequence Data For |
|------|---------|------------------------|
| **HSB_G-BillOfMaterial** | Generate BOMs | Grouping/sorting by phase and sequence |
| **HSB_G-Stack** | Plan logistics stacking | Reverse sequence for loading order |
| **Shop Drawing Tools** | Create fabrication drawings | Label components with sequence numbers |
| **f_Truck / f_Package** | Plan deliveries | Group components by phase/sequence |

---

### Complementary Tools

| Tool | Purpose | Use Together For |
|------|---------|------------------|
| **hsbLayoutTag** | Add tags to drawing views | Display sequence numbers on elevations |
| **HSB_D-Element** | Visualize elements | Preview sequencing before finalizing |
| **hsbViewTag** | Add callouts to views | Annotate shop drawings with sequences |

---

## Summary

ErectionSequence is a critical construction planning tool that bridges design and execution. By organizing components into phases and assigning installation order numbers, it enables:

- **Clear communication** between design, fabrication, and field teams
- **Efficient logistics** by providing structured delivery schedules
- **Safer construction** through planned sequential installation
- **Reduced errors** by eliminating ambiguity in erection order

**Key Features:**
- ✓ Phase-based organization
- ✓ Flexible numbering (auto or manual start)
- ✓ Gap-filling and renumbering modes
- ✓ Entity type filtering
- ✓ Text-sortable sequence format (SequenceNumberText)
- ✓ Integration with BOM and shop drawing tools

**Target Users:**
- Project managers planning construction sequences
- Site superintendents coordinating installation
- Fabrication managers organizing production
- Logistics coordinators scheduling deliveries
- CAD operators preparing construction documentation

**Typical Project Phase:** Used during **Design Development** through **Construction Documentation** phases, after structural design is finalized but before fabrication begins.

---

## Quick Reference

### Insertion Command
```
TSLCONTENT
```

### Common Parameter Combinations

**Initial Sequencing:**
```
Mode: Add to sequence
Building Phase: <New> → "Floor 1"
Start Number: -1
Keep existing: No
EntityType: Element
```

**Adding to Existing Sequence:**
```
Mode: Add to sequence
Building Phase: "Floor 1" (select from dropdown)
Start Number: 10 (or -1 for auto)
Keep existing: Yes (preserve existing)
EntityType: Element
```

**Clearing a Phase:**
```
Mode: Remove sequence by Building Phase
Building Phase: "Floor 1"
```

**Removing Specific Types:**
```
Mode: Remove sequence by EntityType
EntityType: Beam (or other type)
```

---

### MapX Data Access

**Property Path for Reports:**
```
Hsb_SequenceChild.BuildingPhase (String)
Hsb_SequenceChild.SequenceNumber (Integer)
Hsb_SequenceChild.SequenceNumberText (String) ← Use this for sorting
```

**Format String:**
```
@(SequenceNumberText:PL4;0)
PL4 = Pad Left, 4 digits
0 = Pad character (zero)
Result: "0001", "0002", ... "9999"
```

---

*Document generated for ErectionSequence v1.8*
*TSL Knowledge Base - hsbCAD Timber Construction System*
