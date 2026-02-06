# sdUK_SIPShowEdgeDirections.mcr

## Overview
This script is an automated shop drawing utility for Structural Insulated Panels (SIPs). It detects and annotates panel edges in generated views, adding labels (e.g., "E1") and directional arrows to clearly indicate edge orientation and bevel angles.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script does not run manually in model space. |
| Paper Space | Yes | It runs automatically when shop drawing layouts are generated. |
| Shop Drawing | Yes | This script must be assigned to a Sip entity within a Shop Drawing Style. |

## Prerequisites
- **Required Entities**: Sip (Structural Insulated Panel).
- **Minimum Beam Count**: 1 SIP.
- **Required Settings**: The script must be assigned to the desired entity in the Shop Drawing Style configuration.

## Usage Steps

### Step 1: Configure Shop Drawing Style
1. Open the **Shop Drawing Style** editor in hsbCAD.
2. Navigate to the entity mapping or TSL assignment section for **Sip** entities.
3. Add `sdUK_SIPShowEdgeDirections.mcr` to the list of scripts to run for the Sip.

### Step 2: Generate Shop Drawing
1. Run the **Generate Shop Drawing** command (usually via the hsbCAD toolbar).
2. Select the desired SIPs or the entire model.
3. The script will execute automatically during the view generation process.

### Step 3: Review Annotations
1. Open the generated layout in Paper Space.
2. Inspect the views of the SIPs.
3. You will see edge labels and directional arrows placed on the panel edges in Normal (perpendicular) views.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose any user-editable parameters in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add specific items to the entity right-click menu. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: The script operates entirely based on the geometry of the selected SIP and does not require external XML configuration files.

## Tips
- **View Orientation**: The script is designed to annotate "Normal" views (views looking perpendicularly at the panel surface). Edge labels may not appear in section or elevation cuts.
- **Text Placement**: The script automatically calculates the position of the label. If the calculated position falls inside the panel profile, it will automatically flip the leader and text to the outside to ensure legibility.
- **Unlinked Panels**: You can use this script on standalone panels that are not linked to a larger wall element.

## FAQ
- **Q: Why don't I see edge labels on my drawing?**
  - A: Ensure that the view showing the panel is a "Normal" view (Top or Bottom view relative to the panel plane). The script skips non-normal views to avoid clutter.
- **Q: Can I change the text size or arrow style?**
  - A: This script uses fixed internal settings for geometry. To change styles, you would need to modify the script source code or adjust the CAD layer settings for the generated entities.
- **Q: Does this work for curved walls?**
  - A: The script processes standard SIP geometry. Results on complex or highly curved geometry may vary based on the specific edge definitions.