# hsbHiddenConnector.mcr

## Overview
This script generates hidden timber connectors (such as Ricon or KNAPP types) between a main beam and a secondary beam. It automatically creates the necessary 3D geometry (pockets or protrusions), drill holes, and hardware components based on a configurable XML catalog.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in 3D to create solids and modify beams. |
| Paper Space | No | Not designed for 2D layout or view generation. |
| Shop Drawing | No | Generates physical geometry, not annotations. |

## Prerequisites
- **Required Entities**: Two GenBeams (Main and Secondary).
- **Minimum Beam Count**: 2
- **Required Settings Files**: `hsbHiddenConnector.xml` (Must be located in the Company or Install `TSL\Settings` folder).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbHiddenConnector.mcr` from the list.

### Step 2: Select Main Beam
```
Command Line: Select Main Beam
Action: Click on the primary beam (e.g., a rafter or top plate) that will hold the connector pocket.
```

### Step 3: Select Secondary Beam
```
Command Line: Select Secondary Beam
Action: Click on the intersecting beam (e.g., a purlin or stud) that will hold the connector part.
```

### Step 4: Select Insertion Point
```
Command Line: Select point on main beam
Action: Click on the main beam to define the precise location for the hidden connector.
```

### Step 5: Configure Connector
1. Select the inserted script instance.
2. Open the **Properties Palette** (Ctrl+1).
3. Under the **Component** category, select the **Manufacturer**, **Family**, and **Model**.
4. Adjust the **Milling** direction (Male/Female) if necessary.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Manufacturer** | Dropdown | | Select the hardware manufacturer (e.g., Knapp). This filters the available families. |
| **Family** | Dropdown | | Select the product family (e.g., Hidden Connector). This filters the available models. |
| **Model** | Dropdown | | Select the specific connector model (e.g., Ricon S SK-Schraube). Selecting this automatically loads dimensions and screw settings. |
| **Milling** | Dropdown | Male | Determines which side the connector is generated on. <br>• **Male**: Solid part on Secondary Beam.<br>• **Female**: Pocket on Main Beam. |
| **Width (Female/Male)** | Number | 0.0 | Defines the width of the milling or connector body. |
| **Height (Female/Male)** | Number | 0.0 | Defines the height of the milling or connector body. |
| **Depth (Female/Male)** | Number | 0.0 | Defines the depth of the pocket or length of the connector. |
| **Distance Height** | Number | 0.0 | Vertical offset of the connector from the beam reference point. |
| **Distance Width** | Number | 0.0 | Lateral offset of the connector from the beam reference point. |
| **Verbindungsmittel Nebenträger** | Dropdown | None | Selects the screw type for the Secondary Beam. (Visible depending on project configuration). |
| **Verbindungsmittel Hauptträger** | Dropdown | None | Selects the screw type for the Main Beam. (Visible depending on project configuration). |
| **Color** | Number | 7 | Sets the display color of the 3D connector representation. |
| **Show Tag** | Dropdown | No | Toggles the visibility of the text label identifying the connector model in the 3D model. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Show Tag** | Toggles the visibility of the connector label (Tag) in the 3D model. Useful for identification in assembly views. |
| **TslDoubleClick** | Default action; typically re-opens the Properties Palette or highlights the script for editing. |

## Settings Files
- **Filename**: `hsbHiddenConnector.xml`
- **Location**: `_kPathHsbCompany\TSL\Settings` or `_kPathHsbInstall\Content\General\TSL\Settings`
- **Purpose**: Contains the catalog of manufacturers, families, models, and their specific dimensions (Width, Height, Depth) and default screw configurations.

## Tips
- **Cascading Selections**: Always select the **Manufacturer** first. The **Family** and **Model** dropdowns will update automatically based on your previous selection.
- **Swapping Sides**: Use the **Milling** property to switch between creating a pocket on the main beam (Female) or a solid connector on the secondary beam (Male).
- **Dimensions**: If you select a Model, the width, height, and depth are filled automatically. You can manually override these values if you need a custom fit.
- **Tags**: The "Show Tag" feature is particularly useful for Baufritz projects to identify connectors directly in the 3D model without opening properties.

## FAQ
- **Q: Why did the script disappear after I selected the beams?**
  A: This usually happens if the script cannot find the `hsbHiddenConnector.xml` file or if the selected beams were invalid (not GenBeams). Ensure the XML file is in the correct Settings folder and that you select valid timber beams.
- **Q: How do I change the screw type used?**
  A: In the Properties Palette, look for the "Verbindungsmittel" (Connectors/Fasteners) category. You can select different screw options for both the Main and Secondary beams.
- **Q: Can I offset the connector from the center?**
  A: Yes. Use the "Distance Height" and "Distance Width" properties in the Position category to move the connector within the beam cross-section.