# HSB_G-ReplicatorExport

## Overview
This script manages the creation of delivery lists, updates production quantities, and exports timber construction data to external formats (like BTL or Palletizer) for specific project phases or shipments.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in Model Space where Elements and Entities exist. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Entities/Elements**: Your drawing must contain Elements or Entities in Model Space to be exported.
- **ModelMap Configuration**: Exporter Groups and Shortcuts must be defined in your hsbCAD ModelMap settings.
- **Replicator Script (Optional)**: If you plan to use the "Use unique elements: No" option, the target elements should have the `HSB_E-Replicator` script attached to ensure all linked elements are included.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-ReplicatorExport.mcr` from the file browser.

### Step 2: Select Elements or Entities
```
Command Line: Select a set of elements or <ENTER> to select entities
Action: Select the Elements you wish to export. If you want to select generic entities instead, press ENTER.
```

### Step 3: Select Entities (Optional)
If you pressed ENTER in the previous step:
```
Command Line: Select entities
Action: Select the specific entities (beams, plates, etc.) for the delivery.
```

### Step 4: Configure Properties
After selection, the Properties dialog will appear.
1.  Set the **Delivery name** and **Description name** to identify this shipment.
2.  Select an **Exporter group** or **Single export** from the dropdown lists (populated from your ModelMap settings).
3.  Toggle **Export** to `|Yes|` to generate files, or `|No|` to only update the delivery list (dry run).
4.  Click OK to confirm.

### Step 5: Execution
The script will automatically:
1.  Reset project-wide quantities for unlocked items.
2.  Update quantities for the selected delivery.
3.  Generate production files (if Export was set to Yes).
4.  Update the project database with the delivery details.
5.  Remove itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Exporter group | dropdown | "" | Select the predefined export configuration (e.g., 'Weinmann', 'Standard BTL'). If empty, the Single export is used. |
| Single export | dropdown | "" | Select a specific individual export shortcut. Used if the Exporter group is empty. |
| Delivery name | text | \|New delivery\| | The identifying name for this shipment/batch (e.g., 'Phase 1 - Ground Floor'). |
| Description name | text | \|New description\| | Additional details about the delivery (e.g., destination site, floor level). |
| Use unique elements | dropdown | \|No\| | If set to \|No\|, the script includes all replicated/linked elements. If set to \|Yes\|, only the specific items you clicked are exported. |
| Export | dropdown | \|No\| | If set to \|Yes\|, production files are generated. If set to \|No\|, only internal quantity updates and metadata occur (dry run). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Catalog Execute Keys | Allows pre-configuring the script properties via a specific Catalog entry before insertion. |

## Settings Files
- **ModelMap Settings**: Used internally to determine available Exporter Groups and Shortcuts.
- **Catalog Entries**: Catalog entries for `HSB_G-ReplicatorExport` or `_LastInserted` are used to store default property presets.

## Tips
- **Dry Run**: Set the **Export** property to `|No|` initially. This updates the delivery list and quantities in the project without creating the actual physical files, allowing you to verify the selection.
- **Linked Elements**: If your project uses identical elements (replicated), keep **Use unique elements** set to `|No|` to ensure all instances in the model are accounted for in the production count.
- **Script Removal**: This script is designed to run once and automatically delete itself from the drawing after execution. Do not look for the script instance after running it.

## FAQ
- **Q: What happens if both "Exporter group" and "Single export" are empty?**
  A: The script will update the delivery quantities but will not perform any export operation, effectively acting as a dry run.
- **Q: Can I undo the delivery creation?**
  A: You can undo the command (Ctrl+Z) if done immediately, but since it updates ProjectX (database) data, it is recommended to verify the delivery list manually or delete the delivery entry in the project manager if needed.
- **Q: Why did my quantities reset for other items?**
  A: The script resets the manufacturing quantity of all unlocked elements to 0 before applying the new quantities for the current delivery. This ensures the delivery list accurately reflects *only* the items currently being exported.