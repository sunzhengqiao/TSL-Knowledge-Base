# Sherpa

## Overview

The Sherpa script creates **Sherpa aluminium timber connectors** between two structural timber members (or between a beam and a SIP panel) in hsbCAD. Sherpa connectors are hidden, high-performance timber-to-timber joints manufactured from aluminium. They are inserted into a milled housing in one or both members and fastened with self-tapping screws.

This script is a Tool-type (`#Type T`) that requires exactly **two** associated entities (beams, or one beam and one SIP panel) before it is activated. When inserted, it:

- Detects the contact geometry between the male and female members automatically.
- Calculates the largest connector size that fits within both beams based on their cross-sections and the angle between them.
- Applies the corresponding milling cuts (BeamCut or House tooling operations) to the selected members.
- Places a 3D body representing the connector at the joint for visualization.
- Registers the connector body and all associated screws as hardware components for bill-of-material export.

The script supports six size families (XS, S, M, L, XL, XXL) covering a wide range of timber cross-sections, from small rafters to large glulam beams. Beam-to-SIP connections are supported as of version 2.2.

A hyperlink to the official Sherpa connector website (`http://en.sherpa-connector.com/`) is attached to every inserted instance.

---

## Script Information

| Property | Value |
|----------|-------|
| Script Type | Tool (`#Type T`) |
| Required Beams | 2 (`#NumBeamsReq 2`) |
| Grip Points | 0 |
| Version | 2.3 |
| Keywords | connector, sherpa, beam |
| DXA Output | Yes |
| Implicit Insert | Yes |

---

## Usage Environment

| Space | Supported |
|-------|-----------|
| Model Space | Yes |
| Paper Space | No |
| Shop Drawing | No |

The script operates entirely in Model Space. It creates 3D tooling operations on the associated beams and draws a 3D solid body representing the aluminium connector. A plan view label showing the article name is displayed in top-view viewports.

---

## Prerequisites

Before inserting this script, the following conditions must be met:

- **Two non-parallel beams** must be selected, or **one beam plus one SIP panel**. The script requires exactly 2 associated entities (`#NumBeamsReq 2`).
- The male beam and female beam (or SIP) must not be parallel to each other. Parallel member pairs are automatically rejected.
- The male beam axis must intersect the female beam within the female beam's solid length. Connections that miss the female beam are skipped.
- The connector must not be oriented **upside down** (the female member's local Y-axis must not point downward in World coordinates). A red "out of range" error label appears if this is violated.
- The connector must not be **sideward oriented** (the World Z-axis component along the male beam axis must not exceed the component along the female beam axis). An error is displayed if this condition is violated.
- The **female beam (or SIP) width** at the contact face must be at least as wide as the selected size family's connector width.
- The **male beam width** (in the screw-insertion direction) must be at least as large as the chosen screw length.

---

## How to Use

### Step 1: Launch

The script can be started in two ways:

**Without an execute key (interactive dialog):**
```
TSLINSERT -> Sherpa.mcr
```
A two-step dialog appears. In the first step you choose the connector family (XS, S, M, L, XL, or XXL). In the second step you configure all remaining parameters (article, milling mode, screw length, offsets, and so on).

**With an execute key (catalog-driven, no dialog):**
```
^C^C(hsb_scriptinsert "Sherpa" "XS-Vorgabe")
```
The execute key consists of two parts separated by exactly one character (dash, underscore, space, or similar). The first part specifies the connector family; the second part identifies a saved catalog entry. If the catalog entry exists, the script inserts immediately using those saved settings. If the catalog entry does not exist, only the second dialog step is shown with the family preset from the key.

Tool palette buttons are the typical delivery mechanism for predefined size presets on a project.

### Step 2: Set Connector Properties (dialog, if shown)

When the dialog is displayed, configure:
- **Type** (family): XS, S, M, L, XL, or XXL
- **Article**: specific load capacity variant within the family
- **Screw Length**: available lengths depend on the family
- **Milling**: which beam receives the housing
- Other parameters as needed (see Properties Panel section below)

The Family field is read-only in the dialog when it was preset by the execute key.

### Step 3: Select Male Beam(s)

At the command prompt:
```
Select male beam(s):
```
Pick one or more beams that carry the protruding side of the connector (the member that runs into the joint). Multiple selections are allowed; the script creates one connector instance per valid male-female combination.

### Step 4: Select Female Beam(s) or SIP(s)

At the command prompt:
```
Select female beam(s) or SIP(s):
```
Pick one or more female beams or SIP panels. The script automatically skips pairs that are parallel or that do not geometrically intersect within the beam lengths. One connector instance is created for every valid male-female combination found.

### Step 5: Automatic Geometry and Validation

After selection the script:
1. Calculates the contact area between each male-female pair.
2. Filters the available article sizes to those that physically fit inside the beams (based on height, width, and screw length).
3. Validates minimum edge distances for angled connections (referring to the Sherpa manual's 75 mm rule and screw-tip-to-edge requirements).
4. Applies the milling tools to the selected beams or SIP.
5. Creates the 3D connector body and registers hardware components.

If no valid article can be found for a given pair, a red "out of range" error label is drawn at the joint location and that pair is skipped.

### Step 6: Adjust Properties After Insertion

Select the inserted instance and open the **Properties Palette (OPM)** to fine-tune any parameter. The connector geometry, milling, and hardware components update automatically whenever a property changes or a linked beam moves.

---

## Properties Panel (OPM Parameters)

### Category: Type

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type (Family) | String (list) | XS | Connector size family: XS, S, M, L, XL, or XXL. Changing this resets the available article list. |
| Article | String (list) | Largest fitting | Specific load-capacity variant within the selected family (for example, "M 25"). The list is filtered to sizes that fit the actual beam geometry. Shown as "out of range" if no valid size exists. |
| Screw Length | Double (list) | Family default | Length of the self-tapping screws in mm. XS, S, M, and L each have one fixed length; XL and XXL offer 120, 140, 160, or 180 mm. Read-only when only one length is available for the selected family. |

### Category: Tooling

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Milling | String (list) | None | Controls which beam receives the milled housing: **None** (connector sits in a full-thickness gap), **Male beam** (housing in male beam only), **Female beam** (housing in female beam or SIP only), **Both** (housing split between both members with the male-beam depth controlled separately). |
| Milling tolerance | Double | 1 mm | Additional width added to the housing in all directions to account for machine tolerances. |
| Shadow Gap | Double | Family default (1-3 mm) | Gap left visible between the two beams when the connector is milled into one or both members. Automatically capped at the connector thickness if an out-of-range value is entered. |
| Tool Shape | String (list) | Not rounded | CNC milling profile for the housing in the female beam: not rounded, round, relief, rounded with small diameter, relief with small diameter, or rounded. Note: the male beam housing is always milled as "not rounded" regardless of this setting, due to machine restrictions. |
| Milling depth in male beam | Double | 4 mm | Only active when Milling is set to **Both**. Sets how far the connector is sunk into the male beam. The minimum meaningful value is 4 mm (the connector ground plate thickness). Automatically corrected if it would exceed connector thickness minus shadow gap. |

### Category: Position

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Offset Lateral | Double | 0 mm | Shifts the connector laterally along the contact face (perpendicular to the male beam axis within the contact plane). |
| Offset Vertical | Double | 0 mm | Shifts the connector vertically along the contact face (along the male beam depth direction). |

---

## Right-Click Menu Options

| Menu Item | Action |
|-----------|--------|
| Set catalog entry | Saves the current property values as a named catalog entry. A prompt asks for the catalog name. If no name is entered, an automatic name is generated from the pattern "Article MillingMode milled". The catalog entry can then be referenced in tool palette command strings as the execute key suffix. |

---

## Hardware Specifications

The script encodes the complete Sherpa product range. Key dimensions for each family are listed below. All connectors are aluminium; all screws are steel.

### Family XS - Connector width: 30 mm, Thickness: 12 mm, Screw diameter: 4.5 mm, Screw length: 50 mm

| Article | Connector Height | Screws Total | Min Beam Height (male) |
|---------|-----------------|--------------|------------------------|
| XS 5 | 50 mm | 12 | 80 mm |
| XS 10 | 70 mm | 18 | 100 mm |
| XS 15 | 90 mm | 21 | 120 mm |
| XS 20 | 110 mm | 25 | 140 mm |

### Family S - Connector width: 40 mm, Thickness: 12 mm, Screw diameter: 4.5 mm, Screw length: 50 mm

| Article | Connector Height | Screws Total | Min Beam Height (male) |
|---------|-----------------|--------------|------------------------|
| S 5 | 50 mm | 12 | 80 mm |
| S 10 | 70 mm | 18 | 100 mm |
| S 15 | 90 mm | 21 | 120 mm |
| S 20 | 110 mm | 25 | 140 mm |

### Family M - Connector width: 60 mm, Thickness: 14 mm, Screw diameter: 6.5 mm, Screw length: 65 mm

| Article | Connector Height | Screws Total | Min Beam Height (male) |
|---------|-----------------|--------------|------------------------|
| M 15 | 90 mm | 16 | 120 mm |
| M 20 | 110 mm | 20 | 140 mm |
| M 25 | 130 mm | 23 | 160 mm |
| M 30 | 150 mm | 26 | 180 mm |
| M 40 | 170 mm | 30 | 200 mm |

### Family L - Connector width: 80 mm, Thickness: 18 mm, Screw diameter: 8 mm, Screw length: 100 mm, Shadow gap: 3 mm

| Article | Connector Height | Screws Total | Min Beam Height (male) |
|---------|-----------------|--------------|------------------------|
| L 30 | 150 mm | 15 | 180 mm |
| L 40 | 170 mm | 18 | 200 mm |
| L 50 | 210 mm | 21 | 240 mm |
| L 60 | 250 mm | 25 | 280 mm |
| L 80 | 290 mm | 29 | 320 mm |
| L100 | 330 mm | 33 | 360 mm |
| L120 | 370 mm | 37 | 400 mm |

### Family XL - Connector width: 120 mm, Thickness: 20 mm, Screw diameter: 8 mm, Screw lengths: 120/140/160/180 mm, Shadow gap: 3 mm

| Article | Connector Height | Screws Total | Min Beam Height (male) |
|---------|-----------------|--------------|------------------------|
| XL 55 | 250 mm | 18 | 280 mm |
| XL 70 | 290 mm | 21 | 320 mm |
| XL 80 | 330 mm | 24 | 360 mm |
| XL 100 | 370 mm | 25 | 400 mm |
| XL 120 | 410 mm | 29 | 440 mm |
| XL 140 | 450 mm | 32 | 480 mm |
| XL 170 | 490 mm | 36 | 520 mm |
| XL 190 | 530 mm | 40 | 560 mm |
| XL 250 | 610 mm | 48 | 640 mm |

### Family XXL - Connector width: 140 mm, Thickness: 20 mm, Screw diameter: 8 mm, Screw lengths: 120/140/160/180 mm, Shadow gap: 3 mm

| Article | Connector Height | Screws Total | Min Beam Height (male) |
|---------|-----------------|--------------|------------------------|
| XXL 170 | 410 mm | 37 | 440 mm |
| XXL 190 | 450 mm | 42 | 480 mm |
| XXL 220 | 490 mm | 47 | 520 mm |
| XXL 250 | 530 mm | 52 | 560 mm |
| XXL 280 | 570 mm | 54 | 600 mm |
| XXL 300 | 610 mm | 59 | 640 mm |

**Ground plate thickness (all families):** 4 mm. This is the minimum meaningful value for the "Milling depth in male beam" parameter when Milling is set to Both.

---

## Validation and Error Handling

The script performs several geometric and dimensional checks during recalculation. When a check fails, a red "out of range" text label is drawn at the joint location and the Article property becomes read-only with the value "out of range". The following validation checks are applied:

| Check | Condition | Error Message |
|-------|-----------|---------------|
| Upside-down orientation | Female beam local Y-axis points downward in World Z | "Connector is upside down oriented -- Please change axis orientation" |
| Sideward orientation | World Z component along male axis exceeds component along female axis | "Connector is sideward orientated -- Please change axis orientation" |
| Connector width vs. contact width | Selected family connector width exceeds the contact face width | "Connector [family] is not possible for this beam width -- Please select smaller type" |
| Screw length vs. female beam width | Female beam width is less than the required screw length | "Connector [family] with screw length [value] is not possible for this beam width" |
| Milling into female beam | Milling into the female beam would leave insufficient wood for screw penetration | "Connector [family] with screw length [value] can't be milled into the female beam -- Please select other milling option" |
| 75 mm edge distance (XL/XXL at 160 mm screws) | Angled connection does not satisfy the 75 mm minimum edge distance per Sherpa manual | "Invalid connection -- distance at 75mm is too small" |
| Screw tip to beam edge | Distance between screw tips and beam edge is insufficient for angled connections | "Invalid connection -- Distance between screw tips and beam edge is too small" |
| Double-tilted connections | Both tilt planes are non-parallel to the female beam axis | Warning: "Limit values are not tested on double tilted connections" (connector is still created) |

To reduce command line clutter during normal operation, each error message type is displayed only once per recalculation cycle. Enable debug mode (Control = On) to see all messages on every recalculation.

---

## Bill of Material (BOM) Output

Each connector instance registers two hardware components for data export:

1. **Connector**: Category "Connectors", manufacturer "Sherpa", material "Aluminium". The model field contains the article name (e.g., "M 25"). Scale dimensions encode the connector height, width, and thickness.
2. **Screws**: Category "Connectors", manufacturer "Sherpa", material "Steel". The description is "Screw" and the model field contains the diameter and length (e.g., "6.5 x 65"). The quantity equals the total screw count for the selected article.

---

## Tips and Notes

**Male vs. female terminology.** The "male beam" is the one whose end meets the joint -- the member that is cut short and into whose end face the connector back plate sits. The "female beam" (or SIP) is the one that continues through the joint and into which the screws penetrate laterally from the connector side.

**Milling option None.** The connector sits in a gap equal to its full thickness between the two beams. No housing is cut. This is the safest option for CNC machines but leaves the connector visible as a gap in the timber face.

**Milling option Male beam.** The full connector thickness is milled into the end face of the male beam using a BeamCut. The female beam face remains uncut and flush.

**Milling option Female beam.** A rounded housing is routed into the face of the female beam. A shadow gap remains visible on the face. This is the most common choice for exposed surfaces and provides a near-flush appearance.

**Milling option Both.** The connector depth is shared between both members. The male beam receives a BeamCut (depth controlled by "Milling depth in male beam"), and the female beam receives a rounded housing. The combined depth equals the connector thickness minus the shadow gap. Use this option when you want the connector hidden inside both members.

**Article auto-correction.** If you change the family or if beams are resized so that the previously selected article no longer fits, the script automatically selects the largest valid article and reports the correction in the command line. This prevents the connector instance from becoming invalid when beams change.

**Multiple pair insertion.** When selecting multiple male and female beams in one operation, the script creates one independent connector instance for every valid non-parallel male-female intersection found. Pairs that are parallel or that do not geometrically intersect within the beam solid lengths are silently skipped.

**Beam movement.** When a linked beam moves or is resized, the connector recalculates automatically. If beam cross-sections have changed, the connector body, milling tools, and hardware data are all updated. The article size is not changed automatically on beam movement (only on explicit beam-size change detection) so that design intent is preserved.

**Catalog workflow.** Use the "Set catalog entry" right-click command to save a fully configured connector as a catalog entry. Catalog entries can then be referenced directly in tool palette command strings using the format `^C^C(hsb_scriptinsert "Sherpa" "L-Ridge80")`, enabling one-click insertion of pre-configured connectors for repetitive joint types on a project.

**Angled connections (XL/XXL with 160 mm screws).** The script applies additional geometric checks derived from the Sherpa manual's 75 mm edge distance rule. If the beam geometry does not satisfy minimum distances for angled joints, the available article list is reduced or cleared and an "out of range" error is shown. Reduce the screw length or select a smaller article to resolve this.

**SIP support.** The female member can be a Structural Insulated Panel (SIP). The script calculates the correct intersection geometry between the male beam axis and the SIP face plane and applies the housing tool directly to the SIP entity.

**Error indicators.** When a connector cannot be created for a given pair, a red "out of range" text label is drawn at the joint location. The Article property in the OPM also displays "out of range" and becomes read-only. Correct the family, article selection, beam sizes, or connector orientation to resolve the error.

**Debug mode.** Enable debug mode on the instance (set Control = On) to display all orientation vectors as colored lines in the model, receive verbose command-line messages, and see repeated error messages. In normal operation each error type is reported only once per recalculation to avoid flooding the command line.

**Execution loop behavior.** The script uses a two-loop execution cycle internally. On the first loop it applies the cut that stretches the male beam to the female beam. On the second loop it reads the resulting contact area and places the connector. This ensures the contact area geometry is accurate after the beam cut is applied.

**Minimum edge distances.** The script enforces minimum clearances around the connector body: 15 mm vertically (above and below) and 10 mm laterally (left and right). For angled connections, additional checks at 10 mm and 15 mm clearance zones are applied based on the tilt direction.

---

## Version History

| Version | Date | Description |
|---------|------|-------------|
| 2.3 | 08/09/2025 | Fix orientation vectors for SIP panel connections |
| 2.2 | 03/09/2025 | Add support for SIP panels as female member |
| 2.1 | 18/12/2023 | Bugfix: article detection logic |
| 2.0 | 14/12/2021 | Bugfix: reference location calculation |
| 1.9 | 20/06/2020 | Added L100 and L120 articles; improved orientation for non-horizontal/non-vertical situations; "half and half" milling renamed to "Both" with separate male depth control; male beam milling changed to BeamCut |
| 1.8 | 17/04/2018 | Translation issue fixed |
| 1.7 | 22/02/2017 | Orientation improved for non-horizontal and non-vertical situations |
| 1.6 | 15/06/2016 | "Half and half" milling renamed to "Both"; new property for mill depth in male beam |
| 1.5 | 31/05/2016 | Bugfix: male beam milling changed to BeamCut (BVN format compatibility) |
| 1.4 | 12/08/2015 | Bugfix: error messages appeared multiple times in certain situations |
| 1.3 | 12/08/2015 | Bugfix: hardware components were not being added |
| 1.2 | 11/08/2015 | Connector size no longer changes when beams are moved |
| 1.1 | 31/07/2015 | Catalog-based insertion improved; shadow gap available as property; minor bugfixes |
| 1.0 | 21/07/2015 | Initial version |
