# Sherpa.mcr

## Overview
Generates parametric Sherpa aluminum timber connectors between beams or panels. It automatically creates the 3D connector body, applies the necessary millings (pockets) to the timber for flush mounting, and generates hardware data for production lists.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script creates 3D geometry and modifies beam contours. |
| Paper Space | No | Not designed for 2D drawings or layout views. |
| Shop Drawing | No | Not a shop drawing generation script. |

## Prerequisites
- **Required Entities**: Two GenBeams (or a combination of GenBeams and Panels).
- **Minimum Beam Count**: 2.
- **Required Settings**: None (uses internal Sherpa size databases).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Sherpa.mcr` from the list.

### Step 2: Select Connector Family
```
Dialog: Select Family
Action: Choose the size series (XS, S, M, L, XL, XXL) and click OK.
```
This determines the load capacity range and available sizes.

### Step 3: Configure Connector Settings
```
Dialog: Configure Sherpa
Action: 
1. Select the specific Article (Size index).
2. Set the Milling Mode (Surface mount, recessed in Main, recessed in Secondary, or Half/Half).
3. Adjust depths or gaps if necessary.
4. Click OK.
```

### Step 4: Select Main Beam
```
Command Line: Select beam or panel:
Action: Click on the primary timber element (e.g., the bearer or rafter).
```

### Step 5: Select Secondary Beam
```
Command Line: Select beam or panel:
Action: Click on the secondary timber element (e.g., the joist or purlin) that intersects the first.
```

### Step 6: Verification
The script automatically checks if the beams are parallel or if the connector is too large for the timber cross-section.
- **Success**: The connector body is inserted, and toolings (pockets) are applied to the beams.
- **Failure**: An error text appears at the insertion point, and the `sArticle` property displays the specific error.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sFamilyName | String | "XS" | The size series of the connector (XS, S, M, L, XL, XXL). Changing this resets available sizes. |
| nArticle | Index | 0 | The specific model number within the selected family (determines exact width, height, and thickness). |
| nMillMode | Enumeration | 0 | **Mounting Strategy**: 0=None (Surface), 1=Male (Milled into Main Beam), 2=Female (Milled into Sec Beam), 3=Both (Half/Half). |
| dMaleMillDepth | Length | U(10) | Depth of the pocket milled into the main beam (only used in Mode 3). |
| dShadowGap | Length | U(1) | Tolerance gap between connector and timber (accounts for swelling/paint). |
| sCatName | String | "" | Name used to save the current configuration to the catalog. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| setCatalog | Prompts you to enter a name and saves the current property configuration (Size, Family, Milling settings) to the catalog for future use. |

## Settings Files
- **Catalog Entries**: Stored via the internal `setCatalog` function.
- **Purpose**: Allows you to save "presets" (e.g., "M 20 Half-Half") so they can be inserted quickly later without re-entering values.

## Tips
- **Milling Mode 3 (Both)** is best for hidden connections where you want the connector centered between the two timber members. Ensure your beams are thick enough to accommodate the pocket depth.
- **Fit Error**: If you see "The chosen Sherpa connector does not fit," try selecting a smaller `nArticle` or `sFamilyName`.
- **Re-use Configurations**: If you frequently use a specific size (e.g., "L 60" milled halfway), use the `setCatalog` context menu. You can then insert it directly using the execute key logic if mapped to a toolbar button.

## FAQ
- **Q: Why does the script fail with "At least two non parallel beams are required"?**
  **A**: The connector is designed for intersecting members (e.g., T-junctions). You cannot connect two beams that run perfectly parallel to each other with this script.

- **Q: Can I use this on CLT panels or just solid timber?**
  **A**: You can use this on Panels. The script detects if you select a Panel and applies the tooling (using the House entity) appropriately.

- **Q: How do I change the connector size after inserting?**
  **A**: Select the connector instance in the model, open the Properties Palette (Ctrl+1), and change the `sFamilyName` or `nArticle` dropdown. The geometry will update automatically.