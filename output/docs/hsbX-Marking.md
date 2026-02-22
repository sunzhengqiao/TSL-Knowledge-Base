# hsbX-Marking

## Overview

**hsbX-Marking** creates marking lines and/or inscriptions on timber beams at the intersection locations of other beams, trusses, or roof plane rafters. This script is designed for production preparation, generating tooling data that can be exported to Hundegger CNC machines as inscription and marking operations. The marking helps fabricators identify where secondary members (such as rafters, studs, or trusses) connect to a primary beam.

The tooling will be transformed as inscription and/or marking data. It can be used on CNC machines without inkjet capability as long as no text is specified.

---

## Script Information

| Property | Value |
|----------|-------|
| **Script Type** | Object (O-Type) |
| **Version** | 2.6 |
| **Category** | Marking / Production |
| **Keywords** | Marking, beam, truss |
| **Minimum Beams Required** | 0 (dynamically assigned during insertion) |

---

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| **Model Space** | Yes | Primary workspace. Works with 3D beams, trusses, and roof planes. |
| **Paper Space** | No | Not designed for 2D layouts. |
| **Shop Drawing** | No | Does not generate shop drawing views. |

---

## Prerequisites

- **Required entities**: At least one timber beam to be marked, plus marking entities (beams, trusses, or roof planes).
- **Minimum beam count**: 1 beam to mark and at least 1 marking entity (beam/truss/roof plane).
- **Intersection requirement**: Marking entities must intersect with or be within detection range of the beam to be marked.
- **Angle requirement**: Beams must not be parallel to each other (non-parallel intersection required).
- **Required settings files**: None.

---

## Step-by-Step Usage

### Step 1: Launch Script

Run the `TSLINSERT` command and select `hsbX-Marking.mcr` from the file dialog, or use a catalog-based insertion if configured in your project.

### Step 2: Configure Properties (Optional)

If not using catalog-based insertion, a property dialog will appear allowing you to pre-configure marking options such as:
- Face of marking
- Side of marking
- Text settings
- Detection range

### Step 3: Select Marking Entities

```
Command Line: Select marking entities (roofplane and/or beams and/or trusses)
```

**Action**: Click on the beams, trusses, or roof plane that will define **WHERE** the markings appear. Press **Enter** when finished selecting.

**Selection rules**:
- You can select multiple beams
- You can select one roof plane
- You can select multiple trusses
- When selecting a roof plane, all associated rafters (excluding plates and ridges) are automatically included as marking entities

### Step 4: Select Beams to Be Marked

```
Command Line: Select beams to be marked
```

**Action**: Click on the beam(s) that will **RECEIVE** the marking lines. Press **Enter** when finished selecting.

### Result

Marking instances are created at each valid intersection. Each instance appears as a colored line on the specified face of the marked beam. The script automatically:
- Validates that marking entities actually intersect the marked beam
- Filters out parallel beam combinations
- Creates individual marking instances for each valid intersection

---

## Properties Panel Parameters

### Marking Position Parameters

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| **Face of marking** | List | Front | Front, Top, Back, Bottom | Which face of the marked beam receives the marking line. |
| **Side of marking** | List | Both | Both, Left, Center, Right, None | Where on the cross-section the marking appears. "Both" draws lines on both edges of the marking beam intersection. |
| **Direction of marking** | List | Along marking beam | Along marking beam, Rectangular on marked beam | Determines the orientation of the marking line relative to the intersection. |

### Text Parameters

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| **Prefix** | Text | (empty) | Free text | Optional text prefix added before the autotext content. A space is automatically added between prefix and autotext. |
| **Autotext** | List | PosNum | PosNum, PosNum + Text, None | Controls automatic text generation: position number only, position number with description, or no text. |
| **Text Position** | List | Bottom | Bottom, Center, Top | Vertical position of the inscription text relative to the marking line. |
| **Text Alignment** | List | Left | Right, Center, Left | Horizontal alignment of the inscription text. |
| **Text Direction** | List | normal | normal, upside down, back to front, right vertical text, front to back, left vertical text | Orientation of the inscription text for CNC output. |

### Display Parameters

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| **Color** | Integer | 92 | Any CAD color number | Display color of the marking line in the model. |
| **Detection Range** | Number | 5 mm | Positive value | Tolerance for detecting beam intersections (only visible during insertion). |

---

## Right-Click Context Menu

When you right-click on a marking instance, the following options are available:

| Menu Item | Condition | Description |
|-----------|-----------|-------------|
| **Mark top edge** | When "Direction of marking" is "Rectangular on marked beam" and current orientation is bottom | Switches the marking line position to the top edge of the intersection. |
| **Mark bottom edge** | When "Direction of marking" is "Rectangular on marked beam" and current orientation is top | Switches the marking line position to the bottom edge of the intersection. |

---

## Parameter Relationships

### Autotext Behavior

| Autotext Setting | Result | Notes |
|------------------|--------|-------|
| **PosNum** | Displays the marking beam's position number | Not available when marking entity is a truss (no posnum). |
| **PosNum + Text** | Displays position number with additional beam information | Uses the beam's "posnumandtext" name property. |
| **None** | Creates only a marking line without text | Best for machines without inkjet capability. |

**Special case**: If Prefix is empty AND Side is "None" AND Autotext is "None", the script automatically defaults to "PosNum" to ensure some marking appears.

### Direction of Marking Behavior

| Direction Mode | Marking Line Behavior | CNC Export |
|----------------|----------------------|------------|
| **Along marking beam** | Line follows the direction of the beam that creates the marking | Standard marking macro |
| **Rectangular on marked beam** | Line is perpendicular to the beam being marked | Uses right-click menu to toggle top/bottom edge |

### Side of Marking Behavior

| Side Setting | Lines Created | Use Case |
|--------------|---------------|----------|
| **Both** | Two marking lines on left and right edges | Full intersection visualization |
| **Left** | Single line on left edge of intersection | Partial marking |
| **Center** | Single line at center of intersection | Center reference |
| **Right** | Single line on right edge of intersection | Partial marking |
| **None** | No marking lines (only text if enabled) | Text-only inscription |

---

## Workflow Examples

### Example 1: Mark Rafters on a Header Beam

1. Launch `hsbX-Marking`
2. Select the roof plane (or individual rafters) as marking entities
3. Select the header beam to be marked
4. Set **Face of marking** to "Top" for visibility on top surface
5. Set **Autotext** to "PosNum" to show which rafter crosses

### Example 2: Mark Stud Locations on Bottom Plate

1. Launch `hsbX-Marking`
2. Select all wall studs as marking entities
3. Select the bottom plate to be marked
4. Set **Face of marking** to "Top"
5. Set **Side of marking** to "Both" for clear intersection marks
6. Set **Autotext** to "None" for machines without inkjet

### Example 3: Mark Truss Locations on Girder

1. Launch `hsbX-Marking`
2. Select the truss entities as marking entities
3. Select the girder beam to be marked
4. Set **Direction of marking** to "Rectangular on marked beam"
5. Use right-click menu to toggle between top and bottom edge

---

## Tips and Best Practices

### Production Workflow

- The marking tooling is exported as Hundegger macro operations (inscription and/or marking)
- Markings can be executed on CNC machines without inkjet capability as long as no text is specified (use Autotext = "None")

### Skewed Markings

- Markings at angles other than 90 degrees are supported in hsbCAD version 13.2.86 and later
- Non-perpendicular markings use Hundegger macro 6.2, which is **not compatible with K1 machines**

### Roof Plane Efficiency

- When marking rafters from a roof plane, select the roof plane entity rather than individual rafters
- The script automatically extracts all rafters while filtering out plates and ridges

### Group Assignment

- Markings are automatically assigned to the same processing groups as the marked beam (using the 'T' tool category)

### Multiple Intersections

- The script handles batch insertion - selecting multiple marking entities and multiple beams creates all valid intersection markings in one operation

### Connection Validation

- A 50mm tolerance is applied when checking beam-to-beam and beam-to-truss connections
- If entities drift beyond this tolerance during model updates, the marking instance is automatically removed with an error message

---

## Troubleshooting

### Problem: Marking instance was deleted

**Cause**: The script validates connections on every recalculation. If the beams or trusses have moved apart and no longer intersect (within tolerance), the instance is automatically removed.

**Solution**: Check that your structural members still physically intersect. If the model geometry has changed, you may need to re-insert the marking.

### Problem: "Parallel beams cannot be marked" error

**Cause**: Marking requires an actual intersection between non-parallel members. If the marking beam runs parallel to the marked beam, no meaningful intersection line can be calculated.

**Solution**: Verify that the marking entity is at an angle to the beam being marked. Parallel beams cannot create intersection markings.

### Problem: No text appears with truss markings

**Cause**: Trusses do not have position numbers like individual beams, so the Autotext feature cannot retrieve this information.

**Solution**: Use the **Prefix** parameter to manually specify text for truss intersection markings.

### Problem: Marking appears on wrong face

**Cause**: The face determination is relative to the beam's local coordinate system and the direction of the intersecting member.

**Solution**: Adjust the **Face of marking** parameter. If the beam is rotated or inclined, you may need to experiment with different face settings.

---

## Related Scripts

- **hsbTslDim** - Dimension tooling for annotations
- **hsbViewTag** - View tagging and labeling
- **ToolTag** - General tool tagging system

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.6 | 29/04/2025 | Fixed validity checking for beam as marking entity |
| 2.5 | 21/12/2023 | Bug fix for section width/height calculation |
| 2.4 | 10/01/2022 | Fixed TSL description |
| 2.3 | 07/12/2021 | Added group assignment feature |
| 2.2 | 23/08/2021 | Changed TSL type from "X" to "O"; added truss entity support |
| 2.1 | 26/05/2021 | Bugfix for face selection at vertical beams; catalog-based insertion support |
| 2.0 | 25/05/2021 | Bugfix for marking face direction |
| 1.9 | 12/02/2021 | Fixed incorrect end points; markings follow contact using "Along marking beam"; UCS-independent calculation |
| 1.7 | 12/04/2013 | Catalog-based insertion supported |
| 1.6 | 16/10/2008 | Multiple insert for beams to be marked |
| 1.5 | 16/08/2008 | Multiple insert selection possible |
| 1.0 | 30/01/2008 | Initial release |
