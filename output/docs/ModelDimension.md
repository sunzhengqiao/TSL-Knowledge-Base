# ModelDimension

## Description

**ModelDimension** is a TSL script that creates dimension lines on timber members (GenBeam) or shop drawing viewports (MultiPage). It is designed to work in both Model Space and Paper Space (shop drawings), providing automatic dimensioning capabilities for timber construction documentation.

The script analyzes beam geometry and tooling operations (cuts, drills, mortises) to automatically place dimension points. It supports multiple dimensioning strategies, stereotype-based configurations, and intelligent collision avoidance with other dimension lines and tags.

## Script Information

| Property | Value |
|----------|-------|
| **Script Type** | O (Object) - Standalone object that can be placed in drawings |
| **Version** | 1.5 |
| **Beams Required** | 0 (optional - works with MultiPage or GenBeam selection) |
| **Author** | Thorsten Huck |
| **Last Updated** | 18.06.2021 |

## Properties

### Dimension Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Strategy** | String (Dropdown) | X-Global | Defines the dimensioning direction strategy. Options: "X-Global" (horizontal), "Y-Global" (vertical) |
| **Stereotype** | String (Dropdown) | Default | Selects a predefined dimensioning rule set from the settings file |

### Display Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **DimStyle** | String (Dropdown) | (system styles) | The AutoCAD dimension style to use for the dimension line appearance |
| **Delta/Chain Mode** | String (Dropdown) | parallel / parallel | Controls how dimension values are displayed. Combines delta mode (cumulative) and chain mode (incremental). Options include: "parallel / parallel", "perpendicular / parallel", etc. |
| **Sequence** | Integer | 0 | Controls the order in which dimension lines resolve collisions with other dimensions and tags. Set to -1 to disable, 0 for automatic sequencing |
| **MapRule** | String | (empty) | Internal rule definition. Read-only field showing the current mapping rule configuration |

### Tool Category (Dialog Mode)

When adding tools to dimension, additional properties appear:

| Property | Type | Description |
|----------|------|-------------|
| **Tool Type** | String (Dropdown) | Type of beam operation to dimension (AnalysedBeamCut, AnalysedDrill, etc.) |
| **Subtype** | String (Dropdown) | Specific operation subtype (e.g., for BeamCuts: SeatCut, LapJoint, Birdsmouth, Housing, etc.) |

## Usage Workflow

### Inserting a New Dimension

1. **Launch the Script**: Run the ModelDimension script from the TSL panel or command line.

2. **Configuration Dialog**: A properties dialog appears allowing you to configure:
   - Strategy (X-Global or Y-Global)
   - Dimension style
   - Display modes

3. **Select Target Entity**:
   - For **Shop Drawings**: Select a MultiPage (shop drawing sheet)
   - For **Model Space**: Select one or more GenBeam (timber member) entities
   - For **Child Panels**: Select a ChildPanel entity

4. **Select View** (MultiPage only): If you selected a MultiPage, you will be prompted to click within the desired viewport to indicate which view should receive the dimension.

5. **Placement**: The dimension line is automatically positioned based on the beam geometry and any existing dimension lines.

### Modifying Dimensions After Insertion

After the dimension is placed, you can:

- **Move the dimension**: Drag the grip point to reposition the dimension line
- **Change properties**: Use the AutoCAD Properties Palette to modify Strategy, DimStyle, or Display Mode
- **Adjust sequence**: Modify the Sequence property to control layering with other dimensions

### Supported Entity Types

| Entity Type | Description |
|-------------|-------------|
| **MultiPage** | Shop drawing sheets with viewports - dimension is placed in Paper Space |
| **GenBeam** | Individual timber members - dimension is placed in Model Space |
| **ChildPanel** | SIP or panel assemblies - dimension follows panel coordinate system |

## Context Commands

The following commands can be executed on existing ModelDimension instances:

| Command | Description |
|---------|-------------|
| **Set View** | Change which viewport the dimension is associated with |
| **Append Tool** | Add additional tool references (cuts, drills) to the dimension point collection |
| **Add Points** | Manually add dimension points to the existing dimension line |

## Tool Types for Dimensioning

ModelDimension can automatically dimension the following beam operations:

### Beam Cuts (AnalysedBeamCut)
- SeatCut, RisingSeatCut, OpenSeatCut
- LapJoint
- Birdsmouth, ReversedBirdsmouth, ClosedBirdsmouth, BlindBirdsmouth
- DiagonalSeatCut, OpenDiagonalSeatCut
- Housing, HousingThroughout, SimpleHousing
- JapaneseHipCut, HipBirdsmouth, ValleyBirdsmouth, RisingBirdsmouth
- Rabbet, Dado
- 5Axis, 5AxisBirdsmouth, 5AxisBlindBirdsmouth, Housed5Axis

### Drills (AnalysedDrill)
- Perpendicular
- Rotated
- Tilted
- Head
- 5Axis

## Settings File

ModelDimension uses an XML settings file for configuration:

- **Company Path**: `[Company]\TSL\Settings\ModelDimension.xml`
- **Default Path**: `[Install]\Content\General\TSL\Settings\ModelDimension.xml`

The settings file contains stereotype definitions and dimension rules that control automatic placement behavior.

## Collision Avoidance

The script includes intelligent collision avoidance:

1. **Sequence System**: Multiple dimension instances are ordered by their sequence number. Lower sequence numbers are processed first.

2. **Protection Areas**: Each dimension registers a protection area. Subsequent dimensions will adjust their position to avoid overlapping.

3. **View Assignment**: Dimensions are assigned to specific views in shop drawings and will only interact with other dimensions in the same view.

## Tips and Best Practices

1. **Use Automatic Sequencing**: Leave the Sequence property at 0 to let the system automatically assign sequence numbers based on insertion order.

2. **Choose the Right Strategy**:
   - Use "X-Global" for horizontal dimensions (typically measuring length)
   - Use "Y-Global" for vertical dimensions (typically measuring width/height)

3. **Dimension Style**: Select a dimension style appropriate for your drawing scale. The script will automatically scale text and arrows for Paper Space views.

4. **Shop Drawing Workflow**: When dimensioning shop drawings, insert the dimension on the MultiPage and select the specific viewport. The dimension will transform correctly between model and paper space.

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.5 | 18.06.2021 | Cleanup added, view dependency modified |
| 1.4 | 14.06.2021 | Map definition of type and subtypes added |
| 1.3 | 11.05.2021 | Settings and multiple rules per stereotype supported, renamed |
| 1.2 | 11.05.2021 | Dimensions of ruleset TSLs contributing for dim location |
| 1.1 | 07.05.2021 | Updated using new MultiPageView class |
| 1.0 | 05.05.2021 | First draft of model-based dimensioning |
