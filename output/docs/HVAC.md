# HVAC - Duct Work Assignment Tool

## Description

The HVAC script assigns heating, ventilation, and air conditioning (HVAC) duct work data to a set of beams in your timber construction model. It allows you to define and visualize duct runs by creating connected beam segments that represent ductwork, including rectangular ducts and round (tubular) ducts with optional insulation.

This tool supports both interactive duct routing (clicking points to define the path) and beam-based assignment (selecting existing beams to convert into ductwork). The script automatically handles connections between duct segments and maintains flow direction indicators.

## Script Type

| Attribute | Value |
|-----------|-------|
| Type | O (Object) |
| Beams Required | 0 |
| Version | 2.5 |

## Requirements

This script requires a settings file `HVAC.xml` located in your company TSL settings folder:
- `<Company Path>\TSL\Settings\HVAC.xml`

The settings file defines available duct families, child types (specific models), dimensions, colors, and flow properties.

## Properties (OPM)

The following properties appear in the AutoCAD Properties Palette when the HVAC instance is selected:

| Property | Type | Description |
|----------|------|-------------|
| **Family** | String (Dropdown) | Defines the duct work family type (e.g., round ducts, rectangular ducts). The available options are loaded from the HVAC.xml settings file. |
| **Model** | String (Dropdown) | Defines the specific duct model within the selected family. Options depend on the selected Family. |

### Settings-Driven Parameters

The following parameters are read from the XML settings file based on your Family and Model selection:

| Parameter | Description |
|-----------|-------------|
| Height | Duct height (for rectangular ducts) |
| Width | Duct width (for rectangular ducts) |
| Diameter | Duct diameter (for round/tubular ducts) |
| Insulation | Insulation thickness around the duct |
| Radius | Bending radius for tubular duct work |
| Color | Display color index |
| LineType | Line type for linework display mode |
| LineTypeScale | Scale factor for line type |

## Usage Workflow

### Method 1: Interactive Duct Routing (Point-by-Point)

1. **Start the Command**
   - Launch the HVAC script from the TSL menu or toolbar

2. **Select Family**
   - A dialog appears showing available duct families
   - Select the desired family (e.g., "Round Ducts", "Rectangular Ducts")
   - Click OK

3. **Select Model**
   - A second dialog shows available models within the selected family
   - Select the specific duct size/type
   - Click OK

4. **Define Starting Point**
   - Click a point in model space to set the starting location
   - Alternatively, press Enter to specify an elevation value first

5. **Define Duct Path**
   - Click successive points to create duct segments
   - The system operates in plan view mode by default (maintains current elevation)
   - To change elevation: Press Enter and type a new elevation value
   - To switch to 3D mode: Type "P" (Point3D) when prompted
   - For vertical first segments: A prompt asks you to specify the width direction

6. **Complete the Route**
   - Press Enter twice to finish the duct route
   - Or type "E" (End) to exit

### Method 2: Beam Assignment

1. **Start with Beam Assignment Key**
   - Use the command with the "BEAMASSIGN" key

2. **Select Beams**
   - Select one or more existing beams to convert to ductwork

3. **Select Properties**
   - If the beams already have HVAC data, properties are pre-selected
   - Otherwise, select Family and Model from dialogs

4. **Confirmation**
   - The selected beams are converted to HVAC duct representations

### Silent Insertion (Command Line)

The script supports silent insertion with predefined parameters:
- `HVAC` - Opens family selection dialog
- `HVAC <FAMILYNAME>` - Pre-selects family, opens model dialog
- `HVAC <FAMILYNAME>?<ENTRYNAME>` - Silently inserts with specified family and model

## Context Menu Commands

Right-click on an HVAC instance to access these commands:

| Command | Description |
|---------|-------------|
| **-> [Flow Name]** | Switch to a different flow type/direction defined in settings |
| **Swap Flow (Doubleclick)** | Reverses the flow direction indicator. Can also be triggered by double-clicking the instance. |
| **Set special color** | Opens a prompt to override the default color. Enter a color index (0-255). Enter a negative number to remove the override. |
| **3D Ductwork / Linework** | Toggles between 3D solid display and simplified linework display. The label changes based on current mode. |
| **Erase** | Deletes the entire duct system including all connected segments and references. |

## Display Modes

### 3D Ductwork Mode (Default)
- Displays ducts as 3D solid beams
- Round ducts shown with circular profile
- Rectangular ducts shown with rectangular profile
- Flow direction indicated by arrow symbols

### Linework Mode
- Simplified 2D representation
- Shows centerline of duct runs
- Beam visibility is hidden
- Useful for plan views and documentation

## System Behavior

### Automatic Connection Detection
The script automatically detects connections between duct segments through attached tools (connectors). It maintains the flow direction based on the connection sequence.

### Master Instance
When multiple HVAC instances are attached to a connected duct system, only one instance (the "master") controls the entire system. The master is determined by beam handle order.

### Flow Direction
Flow direction is indicated by arrow symbols along the duct path. The direction can be:
- Set based on the "Feed" parameter in settings
- Manually flipped using "Swap Flow" command
- Controlled by Flow type selection from context menu

### Dimension Updates
When Family or Model is changed, the script automatically updates:
- Beam width and height dimensions
- Extrusion profile (round vs rectangular)
- Display color
- Beam name

## Related Scripts

| Script | Description |
|--------|-------------|
| HVAC-G | Connector/elbow component for joining duct segments at angles |
| HVAC-T | T-junction component (if available) |
| HVAC-P | Additional duct pathway component (if available) |

## Tips

- Use the elevation prompt during routing to create vertical duct runs
- For complex 3D routing, switch to Point3D mode using "P"
- The flow symbol offset can be adjusted by moving the instance origin point (_Pt0)
- Custom colors are preserved even when switching between Family/Model types
- Use Linework mode for cleaner plan view documentation
