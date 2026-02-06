# hsbCLT-FastenerLine.mcr

## Overview
Automates the distribution and placement of fasteners (screws, nails, or bolts) along panel edges for CLT construction. It allows users to define complex engineering rules for spacing, edge distances, and hardware selection based on panel types (e.g., Walls or Floors).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for detecting Structural Insulated Panels (Sip) and generating hardware. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: Structural Insulated Panels (Sip) or CLT Panels must exist in the model.
- **Minimum Beams**: None.
- **Required Settings**: 
  - `FastenerAssembly/FastenerManager.dll` (for hardware catalog).
  - `Utilities/DialogService/TslUtilities.dll` (for UI dialogs).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-FastenerLine.mcr`

### Step 2: Initial Configuration
```
Dialog: Fastener Line Configuration
Action: The script scans the model for existing settings. If this is the first run, it initializes default "Wall" and "Floor" painter definitions.
```

### Step 3: Define or Select a Rule
```
Dialog: Main Configuration Window
Action: 
1. Select a "Detail" (Category) or create a new one.
2. Select a "Rule" (Connection Logic) such as "Wall T-Connection" or "Wall-Floor Connection".
3. Adjust geometric parameters:
   - Set 'Mode' to Fixed (max spacing) or Even (specific quantity).
   - Enter 'Interdistance' (spacing between fasteners).
   - Enter 'Offset Start' and 'Offset End' (edge distances).
```

### Step 4: Select Hardware
```
Dialog: Fastener Selection
Action: Select the specific screw or nail from the catalog. If the desired hardware is missing, click the "Fastener Manager" button to browse or import new parts.
```

### Step 5: Apply and Generate
```
Dialog: Main Configuration Window
Action: Click OK. The script saves these rules to the drawing database and automatically generates the fasteners on all panels matching your criteria.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Mode | Enum | Fixed | Method of distribution: **Fixed** (max spacing), **Even** (specific count), or **Fixed, last odd** (handle remainders). |
| Interdistance | Number | 600 mm | Center-to-center distance between fasteners (used in Fixed modes). |
| Quantity | Number | 1 | Exact number of fasteners to place (used in Even mode). |
| Offset Start | Number | 50 mm | Distance from the start of the edge to the first fastener center. |
| Offset End | Number | 50 mm | Distance from the end of the edge to the last fastener center. |
| Radius | Number | 50 mm | Search distance to detect intersecting or adjacent panels (e.g., for T-connections). |
| Painter | String | Wall/Floor | Filter that determines which panel type (orientation) the rule applies to. |
| Vector Direction | Vector | Calculated | The direction in which the fastener is driven/inserted. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add Rule | Opens a sub-dialog to create a new connection rule (e.g., a different spacing for floor panels) and add it to the configuration. |
| Remove Rule | Displays a list of active rules. Selecting one removes it from the configuration and deletes associated fasteners. |
| Show Fastener Manager | Opens the external Fastener Manager dialog to manage hardware mappings, dimensions, and material properties. |
| Import Settings | Loads a previously saved configuration from an XML file. Useful for applying standard office settings to a new project. |
| Export Settings | Saves the current configuration (all rules and hardware settings) to an XML file for backup or sharing. |

## Settings Files
- **Filename**: `UserDefined.xml` (or custom filename chosen by user)
- **Location**: Project folder or Company Standards path
- **Purpose**: Stores the complete configuration of fastener rules (spacings, offsets, hardware assignments) allowing for consistent application across different projects.

## Tips
- **Mode Selection**: Use **Fixed** mode when engineering specifications require a maximum spacing (e.g., "screws max 600mm o.c."). Use **Even** mode when architectural constraints dictate a specific look or count.
- **Troubleshooting Detections**: If fasteners are not appearing on a T-connection, increase the **Radius** parameter in the rule properties. The search radius might be too small to detect the intersecting panel.
- **Painter Management**: Ensure your panels are correctly classified as "Wall" or "Floor" in the model properties, as the script uses these filters to apply the correct rules automatically.

## FAQ
- **Q: Why are no fasteners generating?**
  A: Check if the "Painter" filter in your rule matches the actual classification of your panels in the model. Also, verify that the "Radius" is large enough to detect adjacent panels if using connection-based rules.
- **Q: How do I switch between screws and nails?**
  A: Right-click the script instance and select "Show Fastener Manager". Update the hardware mapping in the catalog, then return to the script properties to re-select the updated hardware.
- **Q: Can I use this for lines instead of panels?**
  A: Yes, provided the "Selection Method" in the rule configuration is set to "byLine". This allows placing fasteners along arbitrary Polylines or vector paths.