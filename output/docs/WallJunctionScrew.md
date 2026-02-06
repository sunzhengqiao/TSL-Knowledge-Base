# WallJunctionScrew

## Overview

WallJunctionScrew automatically places screws at wall-to-wall connections using standardized screw catalog definitions. The tool intelligently detects junction types (T-connections, L-connections, parallel connections, mitre connections) and applies screws according to user-defined rules based on wall dimensions and connection geometry.

## Usage Environment

| Item | Details |
|------|---------|
| **Script Type** | O-Type (Object/Tool) |
| **Execution Space** | Model Space |
| **Required Entities** | Two or more connecting wall elements (ElementWallSF) |
| **Output** | Screw objects (Drill tools) placed at wall junctions |

## Prerequisites

- ScrewCatalog.xml must be loaded with manufacturer, family, and product definitions
- Wall elements must have proper corner cleanup to establish connection detection
- Walls must be ElementWallSF type (stick frame walls)
- Connection areas must have detectable overlapping zones

## Usage Steps

1. **Launch the Tool**
   - Execute the WallJunctionScrew command
   - The component selection dialog appears

2. **Select Screw Product**
   - Choose Manufacturer (e.g., Spax, Simpson, etc.)
   - Choose Family (e.g., structural screws, angle screws)
   - Choose Product/Length from available catalog items
   - Review displayed specifications (diameter, length, material)

3. **Select Wall Elements**
   - Click on two or more wall elements that form junctions
   - The tool analyzes all connections between selected walls
   - Screws are automatically placed at detected junctions

4. **Review and Adjust**
   - Check screw placement in 3D view
   - Modify Distribution parameters if needed
   - Use Set Rule to create placement rules for automation

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Manufacturer** | Choice | (varies) | Screw manufacturer from catalog |
| **Family** | Choice | (varies) | Screw family/type within manufacturer |
| **Product** | Choice | (varies) | Specific product/length from family |
| **Screw Spacing** | Length | (auto) | Center-to-center distance between screws along junction |
| **Edge Distance Start** | Length | (auto) | Offset distance from start of junction |
| **Edge Distance End** | Length | (auto) | Offset distance from end of junction |
| **Vertical Spacing** | Length | (auto) | Spacing between screw rows (if multiple rows) |
| **Number of Rows** | Integer | 1 | How many rows of screws to place |
| **Flip Face** | Boolean | No | Flip screw direction to opposite wall face |

## Right-Click Menu

| Command | Description |
|---------|-------------|
| **Set Rule** | Define automatic placement rules based on wall thickness, connection type, or material |
| **Delete Rule** | Remove previously defined placement rule |
| **Flip Face** | Switch screws to opposite wall face |
| **Export Settings** | Save current screw catalog to XML file |

## Settings Files

| File | Purpose | Location |
|------|---------|----------|
| **ScrewCatalog.xml** | Defines available screw manufacturers, families, products with specifications | `[Company]\TSL\Settings\ScrewCatalog.xml` or `[Install]\Content\General\TSL\Settings\ScrewCatalog.xml` |
| **WallJunctionScrew.xml** | Stores placement rules for automatic screw selection | `[Company]\TSL\Settings\WallJunctionScrew.xml` |

### ScrewCatalog.xml Structure

```xml
<Manufacturer Name="Spax">
  <Family Name="Inforce4">
    <Product Name="8x200">
      <dbl nm="Diameter Thread" vl="8.0"/>
      <dbl nm="Diameter Head" vl="14.0"/>
      <dbl nm="Length Thread" vl="200"/>
      <str nm="material" vl="Steel"/>
      <str nm="articleNumber" vl="SPAX-INF4-8x200"/>
    </Product>
  </Family>
</Manufacturer>
```

## Tips

- **Connection Detection**: The tool automatically identifies:
  - T-Connections: One wall terminates into another
  - L-Connections: Two walls meet at a corner
  - Parallel Connections: Two walls run alongside each other
  - Mitre Connections: Two walls meet at an angle

- **Rule-Based Automation**: Create rules to automatically select screw types based on:
  - Manufacturer (specific brand or "Any Manufacturer")
  - Family (specific type or "Any Family")
  - Product (specific length or "Any Product")
  - Wall thickness combinations
  - Connection type

- **Catalog Customization**: Edit ScrewCatalog.xml to add your own manufacturers and products. Each product requires:
  - Thread diameter
  - Head diameter
  - Thread length
  - Article number

- **Multi-Element Distribution**: Select multiple walls to process all junctions in a single operation

- **Visual Verification**: Screws display as drill objects in 3D, allowing inspection before production

## FAQ

**Q: Why aren't screws appearing at my wall junction?**
A: Check that:
  - Walls are ElementWallSF type (not standard walls)
  - Wall corners have proper cleanup (points must overlap within tolerance)
  - Walls are at compatible height levels
  - The selected screw length isn't longer than the combined wall thickness

**Q: How do I add a new screw manufacturer?**
A: Edit ScrewCatalog.xml to add a new `<Manufacturer>` section with families and products. Use "Export Settings" from the tool to update the drawing database.

**Q: Can I control screw spacing independently for each junction?**
A: Yes. Each tool instance has its own spacing parameters. Select the tool and modify the properties.

**Q: What's the difference between "Edge Distance Start" and screw spacing?**
A: Edge Distance is the offset from the junction endpoint to the first screw. Screw Spacing is the center-to-center distance between consecutive screws.

**Q: How do rules work?**
A: Rules let you define: "For walls of thickness X connecting to walls of thickness Y at connection type Z, automatically use Manufacturer/Family/Product". This automates screw selection for similar junctions.

**Q: Can I flip screws after placement?**
A: Yes. Right-click the tool and choose "Flip Face" or toggle the Flip Face property.

**Q: Why do I see screws on both walls at the junction?**
A: This may indicate two separate tool instances. The tool typically places screws from one wall into the adjacent wall. Check if you accidentally inserted the tool twice.

**Q: What happens if I change wall dimensions after placing screws?**
A: The tool should recalculate automatically if the element regenerates. If not, you may need to delete and re-insert the tool.
