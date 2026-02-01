# bodyImporter.mcr

## Overview
Imports IFC building geometry and manages its conversion into native hsbCAD structural elements (Beams, Sheets, or Panels). It serves as an intermediate step to validate and convert architectural models into parametric timber components.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script creates 3D model entities (Beams, Sheets, Solids). |
| Paper Space | No | Not applicable for detail views. |
| Shop Drawing | No | This is a model preparation/import tool. |

## Prerequisites
- **Required Entities:** None. The script triggers the import process upon insertion.
- **Minimum Beam Count:** 0.
- **Required Settings:**
  - `hsbIFCtoMapConfigurator.exe` (Must be located in `_kPathHsbInstall\Utilities\hsbCloudStorage\`).
  - `hsbSolid2PanelConversion` (TSL script required for panel creation).

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Select `bodyImporter.mcr` from the list and insert it into the Model Space.

### Step 2: Configure Import
**External Dialog:** The **hsbIFCtoMapConfigurator** will launch automatically.
**Action:**
1. Select the source IFC file.
2. Map IFC entities (e.g., `IfcWall`) to target hsbCAD types (e.g., `BEAM`, `SHEET`, `SIP`).
3. Click **Import**.

### Step 3: Review Imported Geometry
**Action:** The script will generate `bodyImporter` instances in the model representing the imported objects.
- **Green/Normal:** Geometry successfully imported.
- **Red:** Geometry import failed or is invalid.

### Step 4: Convert Geometry
**Action:** Select one or more imported instances.
1. **Right-Click** to open the context menu.
2. Select a conversion option (e.g., "Create Beam", "Create panel").
3. The script will replace the instance with the specific hsbCAD entity.

### Step 5: Validation
**Action:**
- If the conversion geometry matches the import perfectly, the script instance erases itself automatically.
- If there is a mismatch (vertex count difference), the script instance turns **Red** and stays in the model.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| (None) | N/A | N/A | This script does not expose standard user-editable properties in the Properties Palette. All configuration is handled via the IFC Configurator or Context Menu. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Create Beam** | Converts the imported geometry into a parametric Timber Beam (GenBeam). The script calculates orientation based on the longest axis. |
| **Create Sheet** | Converts the imported geometry into a parametric Sheet (e.g., OSB, Plywood). |
| **Create panel** | Converts the geometry into a complex hsbCAD Panel (Wall/Floor) using the external panel conversion engine. |
| **Convert into acis solid** | Replaces the script instance with a static AutoCAD 3D Solid. Useful for reference or collision checking where manufacturing data is not needed. |
| **Convert into mass element** | Replaces the script instance with an AutoCAD Mass Element for conceptual volumetric studies. |
| **Visualize bad faces** | Runs a Quality Assurance check and highlights areas of the geometry that are non-planar or invalid (debugging tool). |
| **set map from beam solid** | (Debug Mode) Updates the internal source map with the geometry of a user-selected beam. |
| **reset map** | (Debug Mode) Clears the internal source map data. |

## Settings Files
- **External Tool:** `hsbIFCtoMapConfigurator.exe`
- **Location:** `%hsbInstall%\Utilities\hsbCloudStorage\`
- **Purpose:** Handles the file selection, IFC parsing, and mapping of IFC types to hsbCAD types before the script logic runs.

## Tips
- **Troubleshooting Red Instances:** If an instance turns red after conversion, use the **Visualize bad faces** option to see if the original IFC geometry has topology errors (like non-planar faces).
- **Panel Orientation:** When creating panels, the script attempts to align the Z-axis to vertical. If the result is upside down, check the source IFC orientation.
- **Batch Processing:** You can select multiple `bodyImporter` instances and convert them simultaneously via the right-click menu.

## FAQ
- **Q: Why did the script instance disappear after I right-clicked?**
  **A:** This is expected behavior. If the conversion is successful and the geometry is valid, the script self-destructs, leaving only the new Beam, Sheet, or Panel.
- **Q: What does it mean if the instance turns Red?**
  **A:** It means the script detected a mismatch between the imported body and the generated hsbCAD solid (usually due to complex geometry). The script remains in the model so you can inspect the error or try a different conversion method (like converting to a generic ACIS solid).
- **Q: Can I edit the dimensions in the properties palette?**
  **A:** No, the dimensions are locked to the imported IFC geometry. You must convert the object to a Beam or Panel first to gain access to parametric dimensions.