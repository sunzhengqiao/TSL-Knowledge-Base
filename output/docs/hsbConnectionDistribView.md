# hsbConnectionDistribView

## Overview

`hsbConnectionDistribView` is a Model Space Object-type TSL script that generates a visual distribution layout of connectors (nails, screws, dowels, or other fasteners) along the contact zone between two SIP panels, or along a user-defined line segment. The script reads connector catalog data from an XML configuration file (`hsbExcel2Xml.xml`) and places evenly spaced connector markers at the panel interface. It handles three panel relationship types: normal (90-degree), parallel, and arbitrary (angled) connections.

The entity automatically populates hsbCAD hardware component lists (`HardWrComp`) so that the distributed connectors appear in the project Bill of Materials (BOM) and export workflows.

Typical users are CLT/SIP designers and structural detailers who need to document the fastener layout at panel-to-panel connections and ensure correct quantities in material take-offs.

---

## Usage Environment

| Property | Value |
|----------|-------|
| Space | Model Space only |
| Script Type | Object (`#Type O`) |
| Beams Required | 0 |
| Version | 1.10 (24 May 2020) |
| Keywords | klh, connection, wall, floor, distribution |

The script creates a persistent, parametric Object entity that recalculates whenever its linked panels move or when the user modifies a property.

---

## Prerequisites

1. **XML catalog file** -- The file `hsbExcel2Xml.xml` must exist at `<HsbCompanyPath>\TSL\Settings\hsbExcel2Xml.xml`. If missing, the script reports an error and cancels insertion.

2. **At least one Manufacturer entry in the XML** -- The catalog must contain at least one `<Manufacturer>` block with nested `<Model>` and `<Article>` entries.

3. **Two touching or overlapping SIP panels** (recommended) -- Full intelligence (automatic contact face detection, correct distribution direction, BOM export) requires two actual SIP panel entities. The script can also operate in free-point mode with reduced automation.

---

## How to Use

### Step 1 -- Launch

Run the TSL insert command:

```
TSLINSERT -> hsbConnectionDistribView.mcr
```

Or use a ribbon/toolbox button configured with the `TSLCONTENT` command alias.

### Step 2 -- Select Manufacturer and Article

A property dialog appears with cascading selections:

1. Choose a **Manufacturer** from the XML catalog list.
2. Choose a **Model** for that manufacturer (list refreshes automatically).
3. Choose an **Article** (specific part number) for the selected model.
4. Choose a **CD-Ref** connection code for classification and display color.
5. Set the distribution spacing parameters.

Click OK to confirm.

The script also supports silent insertion via an OPM key in the format `Manufacturer?Model?Article` passed through `_kExecuteKey`, bypassing the dialog. This is useful for pre-configured toolbar buttons.

### Step 3 -- Define the Distribution Range

The command line prompts:

```
Select panel(s) or Enter to define a distribution
```

**Option A -- Select panels (recommended):** Click one or more SIP panels. The script detects touching pairs and automatically determines the contact face. One distribution entity is created per touching panel pair.

**Option B -- Manual points:** Press Enter without selecting panels. The command line then prompts for a start point and an end point. Fasteners are placed along this line without being linked to panel geometry.

### Step 4 -- Review the Result

Circular markers (5 mm radius) appear at each calculated fastener position, drawn in the color defined by the selected CD-Ref code. The overlap region is highlighted as a filled profile on normal and parallel connections. The Properties Palette shows the calculated quantity and actual spacing as read-only result fields.

### Step 5 -- Adjust Parameters

Open the Properties Palette (OPM) and adjust spacing parameters. The entity recalculates immediately when any value changes. Manufacturer, model, and article selections can also be changed at any time.

---

## Properties Panel (OPM Parameters)

### General

| Parameter | Type | Default | Read-Only | Description |
|-----------|------|---------|-----------|-------------|
| Loaded Project | String | (from XML) | Yes | Project name read from the XML catalog. Informational only. |

### Component

| Parameter | Type | Default | Read-Only | Description |
|-----------|------|---------|-----------|-------------|
| Manufacturer | String (list) | (first in XML) | No | Connector manufacturer. Changing this refreshes the Model list. |
| Model | String (list) | (first for manufacturer) | No | Product model. Changing this refreshes the Article list. |
| Article | String (list) | (first for model) | No | Specific article (part number) used for BOM export. |

### Code

| Parameter | Type | Default | Read-Only | Description |
|-----------|------|---------|-----------|-------------|
| CD-Ref | String (list) | (first in XML) | No | Connection code reference. Determines the display color of distribution markers. |
| CD-Ref Number | Integer | 0 | No | Optional integer qualifier combined with CD-Ref for hardware notes (format: `CD-Ref-Number`). Useful for distinguishing multiple connector rows at the same interface. |

### Distribution

| Parameter | Type | Default | Read-Only | Description |
|-----------|------|---------|-----------|-------------|
| Distance Bottom/Start | Double (length) | 0 | No | Edge distance from the start of the distribution range to the first fastener. |
| Distance Top/End | Double (length) | 0 | No | Edge distance from the end of the distribution range to the last fastener. |
| Distance between / Nr. | Double | 5 mm | No | Positive value: nominal center-to-center spacing (the script fits as many fasteners as possible and adjusts the actual spacing). Negative integer: the absolute value is interpreted as the exact number of fasteners to place at equal intervals (e.g., `-6` places exactly 6). |
| Distance between (result) | Double | 0 | Yes | Calculated actual center-to-center distance after fitting. Updated on every recalculation. |
| Nr. (result) | Integer | 0 | Yes | Total number of fastener positions placed. Used as quantity in BOM export. |

---

## Connection Type Detection

The script automatically classifies the geometric relationship of two linked SIP panels:

**Normal connection (90 degrees):** Panel thickness vectors are perpendicular. The script extracts the contact face profiles of both panels at the interface plane, intersects them, and distributes fasteners along the long edge of the contact area.

**Parallel connection:** Both panels have parallel face normals and overlap in projection. The script finds the overlapping region and distributes fasteners along its longest dimension.

**Arbitrary (angled) connection:** Panels meet at any other angle. The script constructs intersection geometry from the bounding bodies and derives the distribution line from the intersection plane. This covers skewed or inclined connections such as roof ridges or raking walls.

When more than two panels are selected, the script analyses all pairs, identifies which ones actually touch, and creates a separate distribution entity for each touching pair.

---

## Hardware BOM Export

Every recalculation updates the `HardWrComp` list on the entity. Exported data includes:

- **Article number** from the selected Article field
- **Quantity** equal to the Nr. result value
- **Manufacturer** and **Model** fields
- **Description** and **Material** from the XML article definition
- **Notes** written as `CD-Ref-CDRefNumber` (e.g., `W1-2`)
- **Physical dimensions** (length, width/diameter, thickness) from XML keys `ScaleX/Length`, `ScaleY/Width/Diameter`, `ScaleZ/Height/Thickness`
- **Sub-components** -- up to four sub-articles (SubA through SubD) per article in the XML; each generates its own hardware entry with quantity = Nr. result x SubQty

The hardware group name is taken from the hsbCAD group the entity belongs to, allowing BOM output organized by wall, floor, or roof element.

---

## Tips and Notes

- **Grip points.** The entity provides grip points at the start and end of the distribution line. Dragging these grips adjusts the range interactively.

- **Multi-region contact areas.** If the contact face consists of disconnected regions (e.g., a panel with an opening), the script creates one child distribution entity per region, each with its own BOM entry.

- **Free-point mode limitations.** When inserted by two manually clicked points, the entity cannot determine the contact face geometry but still exports correct BOM quantities.

- **Negative value clamping.** When a negative integer is entered and the required number would cause overlapping, the script clamps spacing to zero and recalculates the maximum count.

- **Display color.** Marker color is controlled by the `Colour` field in the CD-Ref code block within the XML catalog. Different colors per CD-Ref code help visually distinguish connection types.

- **XML catalog caching.** Catalog data is cached as a `MapObject` under `hsbTSL/hsbExcel2Xml`. If the XML is updated externally, reopen the drawing to force a re-read.

- **Empty dropdowns.** If Manufacturer, Model, or Article lists are empty after insertion, verify that `hsbExcel2Xml.xml` exists at the correct path and contains valid entries.
