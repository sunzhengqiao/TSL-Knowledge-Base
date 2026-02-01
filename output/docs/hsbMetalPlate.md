# hsbMetalPlate

## Overview

**hsbMetalPlate** is a TSL script that creates metal connector plates to join 2 or 3 timber beams (GenBeams) at their common faces. The plates are placed at the intersection of coplanar beam faces and can be configured with various manufacturer products from an XML catalog.

| Property | Value |
|----------|-------|
| Script Type | O (Object) |
| Beams Required | 0 (at insertion), 2-3 (for operation) |
| Version | 1.0 |
| Author | Marsel Nakuci |
| Date | 12.05.2021 |

## Description

This tool automatically detects where selected beams share a common plane and places a metal connector plate at that location. It supports:

- **2-beam connections**: Standard plate connection between two intersecting or adjacent beams
- **3-beam connections**: Corner or junction connections where three beams meet at a common plane

The script reads product specifications (length, width, material) from an external XML catalog file (`MetalPlateCatalog.xml`) and automatically registers the placed plate as a hardware component in the model.

## Properties

### Component Selection

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Manufacturer | String (dropdown) | --- | Select the plate manufacturer from available options in the catalog |
| Family | String (dropdown) | --- | Select the product family within the chosen manufacturer |
| Product | String (dropdown) | --- | Select the specific product/model to use |

### Insertion Mode

| Property | Type | Options | Description |
|----------|------|---------|-------------|
| Mode | String (dropdown) | Single, Multiple | **Single**: Click to place plates one at a time with visual preview. **Multiple**: Automatically distribute plates to all valid connection points facing the view direction |

### Alignment

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Face | String (dropdown) | View Direction | Controls which beam faces receive plates: **View Direction** (faces toward camera), **Normal to View Direction**, or **All** |
| Side | String (dropdown) | One | Place plate on **One** side or **Both** sides of the connection |
| Offset Length | Double | 0 mm | Offset distance along the plate length direction |
| Offset Width | Double | 0 mm | Offset distance along the plate width direction |
| Rotate | Double | 0 | Rotation angle for the plate orientation |

### Connection Type

| Property | Type | Options | Description |
|----------|------|---------|-------------|
| Type | String (dropdown) | 2 Genbeams, 3 Genbeams | Choose whether to create connections for 2-beam or 3-beam joints |

## Usage Workflow

### Step 1: Launch the Script
Run the script using the command:
```
(hsb_ScriptInsert "hsbMetalPlate")
```

### Step 2: Select Beams
When prompted with "Select Genbeams", select two or more timber beams that share a common planar face where you want to place connector plates.

### Step 3: Configure the Plate
A dialog appears for product selection:
1. **Choose Manufacturer** - Select from available manufacturers in the catalog
2. **Choose Family** - Select the product family
3. **Choose Product** - Select the specific plate model

### Step 4: Place the Plate

**Single Mode:**
- A visual preview shows potential connection locations
- Click on a highlighted area to place a plate at that location
- Use the command line keyword option to toggle between 2-beam and 3-beam connection types
- Press ESC to finish placement

**Multiple Mode:**
- Plates are automatically placed at all valid connection points
- Only faces aligned with your current view direction receive plates
- Useful for batch placement across many connections

### Step 5: Adjust Properties (Optional)
After placement, select the plate and modify properties in the Properties Palette:
- Adjust offsets to fine-tune position
- Change the side setting to add plates on both faces
- Rotate the plate if needed

## Context Menu Commands

| Command | Description |
|---------|-------------|
| **Swap Side** | Flips the plate to the opposite side of the connection. Only available when "Side" is set to "One" |

## Settings File

The script reads product data from an XML catalog file:
- **Company location**: `[Company Path]\TSL\Settings\MetalPlateCatalog.xml`
- **Default location**: `[Install Path]\Content\General\TSL\Settings\MetalPlateCatalog.xml`

The catalog structure supports multiple manufacturers, each with multiple product families, each containing multiple products with their dimensions.

## Hardware Registration

Each placed plate is automatically registered as a hardware component with:
- Manufacturer name
- Family (used as article number)
- Product model name
- Material specification
- Dimensions (length, width, thickness)
- Link to the associated beam group
- Category: "Connector"
- Quantity based on Side setting (1 or 2)

## Technical Notes

- The script uses `envelopeBody()` for performance when analyzing beam geometry
- Plate placement requires beams to have coplanar faces within tolerance
- The visual preview (jig) shows potential plate locations in green, with hover highlighting in yellow
- When using Multiple mode, only connections facing the current view direction are processed
- A hyperlink to manufacturer documentation is automatically attached if specified in the catalog

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Could not find manufacturer data" | Verify the MetalPlateCatalog.xml file exists in the Settings folder |
| "2 GenBeams needed" | Ensure at least 2 beams are associated with the script instance |
| "Plane vector not defined" | This indicates an internal state error; try reinserting the script |
| No valid connection points shown | Beams may not have coplanar faces; check beam geometry alignment |
| Version mismatch warning | The catalog file version differs from the drawing; consider updating |
