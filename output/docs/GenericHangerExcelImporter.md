# GenericHangerExcelImporter

Imports joist hanger product data from Microsoft Excel spreadsheets (.xlsx) into the hsbCAD GenericHanger system. This utility tool reads structured Excel files containing manufacturer-specific hanger specifications -- including dimensional parameters, joist size ranges, skew angle ranges, fixture (fastener) definitions, and optional block overrides -- and converts them into the internal XML settings format used by the GenericHanger script. It supports both in-drawing and company-wide (XML file) import modes, enabling administrators and content managers to populate or update the hanger product catalog without manually editing XML configuration files.

---

## Overview

The GenericHangerExcelImporter bridges the gap between manufacturer product data (typically distributed as spreadsheets) and the internal configuration system of the GenericHanger tool. When a hardware manufacturer releases a new hanger family or updates existing product dimensions, this importer allows you to feed that data directly into hsbCAD rather than hand-editing XML files.

The script parses each sheet in the selected Excel workbook as a separate manufacturer or product group. Each row within a sheet represents one hanger product (article), with columns mapping to dimensional parameters (A through P), joist size constraints, angle ranges, fixture references, and optional 3D block display overrides. A special "Fixture" sheet can define the fastener articles shared across multiple products.

Once imported, the data becomes immediately available to the GenericHanger tool in the current drawing. Optionally, the data can also be exported to the company XML settings folder so that it persists across all future drawings for all users in the organization.

---

## Usage Environment

| Property | Value |
|----------|-------|
| Script Type | O-Type (Object) |
| Environment | Model Space |
| Paper Space | Not applicable |
| Shop Drawing | Not applicable |
| Beams Required | 0 |
| Insertion Mode | Implicit Insert (self-erasing after import) |
| Version | 1.9 |
| Related Scripts | GenericHanger, GA (Generic Angle), GenericAngleExcelImporter |

The script is a one-shot utility: it inserts, performs the import, reports results to the command line, and then automatically erases itself from the drawing. It does not remain as a persistent entity.

---

## Prerequisites

Before using the GenericHangerExcelImporter:

1. **hsbCAD Installation**: A working hsbCAD installation (version 27 or later) is required. The script automatically detects whether to use the .NET 8 DLL variant (version 28+) or the legacy .exe variant (version 27) of the Excel-to-Map converter.

2. **Excel Converter Utility**: The external utility `hsbExcelToMap.dll` (or `hsbExcelToMap.exe` for hsbCAD v27) must be present at `[InstallPath]\Utilities\hsbExcelToMap\`. This component is included with standard hsbCAD installations.

3. **Excel File Preparation**: You must have a properly formatted .xlsx file ready. The spreadsheet must follow the expected column structure (see the "Excel File Format" section under Settings below). Each sheet in the workbook represents one manufacturer or product group.

4. **GenericHanger Settings**: The GenericHanger XML settings file (`GenericHanger.xml`) should already exist in either:
   - The company TSL settings folder: `[CompanyPath]\TSL\Settings\GenericHanger.xml`
   - The installation content folder: `[InstallPath]\Content\General\TSL\Settings\GenericHanger.xml`

   If no settings file exists yet, the script will create the initial MapObject in the drawing dictionary.

5. **Settings Folder**: On first run, the script will automatically create the `Settings` subfolder under `[CompanyPath]\TSL\` if it does not already exist.

6. **Write Permissions**: If using the "Drawing + Company XML" import mode, ensure you have write access to the company TSL Settings folder so the exported XML files can be saved.

---

## Usage Steps

### Step 1: Launch the Importer

Run the GenericHangerExcelImporter script from the hsbCAD TSL menu, toolbar, or command line. The AutoCAD command is:

```
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "GenericHangerExcelImporter")) TSLCONTENT
```

The script only allows a single insertion cycle; attempting to insert it again in the same session will cause it to erase itself immediately.

### Step 2: Select the Excel File

Upon insertion, a file browser dialog opens (powered by the `hsbExcelToMap` utility). Navigate to and select the `.xlsx` file that contains the hanger product data.

- If you have previously imported a file, the dialog will remember the last used file path and open to that location.
- Select the Excel file and confirm.
- If you cancel the file selection dialog (no file path returned), the script continues without loading new data.

### Step 3: Review Available Sheets

After reading the Excel file, the script identifies all valid data sheets. A sheet is considered valid if its first data row contains at minimum the columns **Manufacturer**, **Family**, and **ArticleNumber**. Sheets named "Empty" or "Fixture" are automatically excluded from the main product list (the Fixture sheet is processed separately for fastener definitions).

The valid sheet names appear sorted alphabetically in the **Sheet Import** dropdown in the Properties Panel.

If no valid sheets are found in the workbook, the script displays the message "Could not find any data in [Path]" and erases itself.

### Step 4: Choose Import Options

In the Properties Panel dialog that appears automatically:

1. **Sheet Import**: Select which Excel sheet to import.
   - Choose a specific sheet name to import only that manufacturer's data.
   - Select **"All Sheets"** (listed at the top of the dropdown) to import every valid sheet in the workbook at once.

2. **Import Mode**: Choose how the imported data should be stored:
   - **Drawing**: Imports the data only into the current drawing's dictionary. The data is available to GenericHanger in this drawing only.
   - **Drawing + Company XML**: Imports into the current drawing and also exports the data as XML files to the company settings folder (`[CompanyPath]\TSL\Settings\`). This makes the data available to all future drawings across the organization.

### Step 5: Confirm and Execute

After setting your preferences, confirm the dialog. The script will:

1. Parse the "Fixture" sheet first, collecting all shared fastener articles into a lookup table.
2. Iterate through the selected product sheet(s), reading each row as a product article.
3. Validate that each row has a valid Family name and Article Number (rows missing these are skipped with a warning).
4. Collect dimensional parameters (A through P), thickness (t), joist width/height ranges, angle constraints, TopFlush flag, Adjustable Height Strap flag, block overrides, and fixture references for each product.
5. Build the internal Map structure for each manufacturer, organized by Family and Product hierarchy.
6. Store or update the MapObject in the drawing dictionary under the entry name `GenericHanger_[SheetName]`.
7. If "Drawing + Company XML" mode is selected, write the XML file to `[CompanyPath]\TSL\Settings\GenericHanger_[SheetName].xml`.
8. If the manufacturer is new (not already listed in the master GenericHanger.xml settings), append it to the manufacturer list.

### Step 6: Review Import Results

The script reports results to the AutoCAD command line:

- **Total articles imported**: The number of product rows successfully parsed (e.g., "GenericHangerExcelImporter articles imported: 142").
- **Updated entries**: Each dictionary entry that was created or updated is listed by name (e.g., "GenericHanger_StrongTie_UK has been updated").
- **XML export path**: If using company XML mode, the full path of each exported XML file is displayed (e.g., "exported to C:\...\Settings\GenericHanger_StrongTie_UK.xml").
- **New manufacturers**: If a manufacturer was not previously known, the message "[ManufacturerName] has been appended to default manufacturers" is shown.
- **Warnings**: Any rows that were skipped due to missing Family or ArticleNumber values are reported with the sheet name and row number.

After reporting, the script automatically erases itself from the drawing.

---

## Properties Panel Parameters

### General Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Path** | String (hidden) | (empty) | Stores the last used file path for the Excel file browser. This field is hidden from the Properties Panel and is maintained automatically to remember the previous import location between sessions. |
| **Sheet Import** | Dropdown | (first valid sheet) | Selects which Excel sheet to import. Options are populated dynamically from the valid sheets found in the loaded workbook. An "All Sheets" option is added at the top of the list to import every valid sheet at once. |
| **Import Mode** | Dropdown | Drawing | Controls the scope of the import. **Drawing** stores data only in the current drawing dictionary. **Drawing + Company XML** additionally exports XML files to the company TSL Settings folder for organization-wide availability. |

---

## Right-Click Menu

This script does not define any right-click context menu actions. It is a one-shot import utility that runs during insertion and then erases itself.

---

## Settings

### Settings File Locations

The script reads and writes the following settings files:

| Location | Path | Purpose |
|----------|------|---------|
| Company Master Settings | `[CompanyPath]\TSL\Settings\GenericHanger.xml` | Master settings file containing the list of known manufacturers and general configuration |
| Installation Default Settings | `[InstallPath]\Content\General\TSL\Settings\GenericHanger.xml` | Default/fallback settings shipped with the hsbCAD installation |
| Per-Manufacturer Export | `[CompanyPath]\TSL\Settings\GenericHanger_[SheetName].xml` | Individual XML files created per manufacturer/sheet when using "Drawing + Company XML" mode |

### Dictionary Entries

The imported data is stored in the AutoCAD drawing dictionary under the namespace `hsbTSL`. Each manufacturer sheet creates an entry named `GenericHanger_[SheetName]` (e.g., `GenericHanger_StrongTie_UK`).

### Settings Version Validation

When a new instance is created, the script compares the version number stored in the drawing's MapObject (`GeneralMapObject\Version`) against the version in the XML file on disk. If the versions differ, a notice is displayed alerting you that a different settings version has been found, showing both version numbers and file paths. This helps identify when local settings are out of sync with the installation defaults.

### Excel File Format

The imported Excel workbook (.xlsx) must follow this structure:

#### Main Product Sheets

Each worksheet (other than "Fixture" and "Empty") is treated as a manufacturer product group. The sheet name becomes the manufacturer identifier (e.g., "StrongTie_UK", "Wuerth_DACH").

**Required columns (must be present in the first data row):**

| Column Header | Type | Description |
|---------------|------|-------------|
| **Manufacturer** | String | Manufacturer name. Only needs to appear once per group of rows; subsequent rows inherit the last specified value. |
| **Family** | String | Product family name (e.g., "JHA", "LUS"). Required for every row -- rows without this value are skipped. |
| **ArticleNumber** | String | Unique product article number. Required for every row -- rows without this value are skipped. |

**Dimensional parameter columns (all optional, numeric/Double values):**

| Column | Description |
|--------|-------------|
| **A** through **P** | Up to 16 dimensional parameters defining the hanger geometry. The exact meaning of each parameter depends on the hanger family and is interpreted by the GenericHanger script. |
| **t** | Material thickness |
| **MinWidth** | Minimum supported joist width (mapped to `Joist\MinWidth`) |
| **MaxWidth** | Maximum supported joist width (mapped to `Joist\MaxWidth`) |
| **MinHeight** | Minimum supported joist height (mapped to `Joist\MinHeight`) |
| **MaxHeight** | Maximum supported joist height (mapped to `Joist\MaxHeight`) |

**Flag columns (optional):**

| Column | Type | Description |
|--------|------|-------------|
| **TopFlush** | Numeric (0/1) | If value is greater than 0, marks the hanger as top-flush mounted |
| **Adjustable Height Strap** | Numeric (0/1) | If value is greater than 0, marks the hanger as having an adjustable height strap |
| **Alpha** | String or Numeric | Supported skew angle or angle range for the product (e.g., "45-90" or a single numeric value) |

**Additional metadata columns (optional):**

| Column | Type | Description |
|--------|------|-------------|
| **URL** | String | Manufacturer product URL. One definition applies per group of rows. |
| **Material** | String | Material specification. One definition applies per group of rows. |

**Block override columns (optional, up to 10 per product):**

| Column | Type | Description |
|--------|------|-------------|
| **Block1** through **Block10** | String | AutoCAD block name for 3D display override |
| **BlockOffset1** through **BlockOffset10** | Numeric | X-axis offset for the corresponding block |

Block overrides allow products that require multiple display blocks. For example, the Simpson Strong-Tie SDE series uses two separate blocks for left and right flanges, each with different X offsets. A block entry is only recorded when both the block name and its corresponding offset are provided.

**Fixture reference columns (optional, up to 10 per product):**

| Column | Type | Description |
|--------|------|-------------|
| **Fixture1** through **Fixture10** | String or Numeric | Article number referencing a fixture defined on the Fixture sheet. Only fixtures whose article numbers exist in the Fixture sheet are accepted; unmatched references produce a warning. |
| **Header** | Numeric (integer) | Number of fasteners on the header (supporting beam) side for full nailing pattern |
| **Joist** | Numeric (integer) | Number of fasteners on the joist (incoming beam) side for full nailing pattern |
| **Header Partial** | Numeric (integer) | Number of fasteners on the header side for partial nailing pattern |
| **Joist Partial** | Numeric (integer) | Number of fasteners on the joist side for partial nailing pattern |

#### Fixture Sheet

A worksheet named exactly **"Fixture"** defines shared fastener articles that can be referenced by products in the main product sheets:

| Column Header | Type | Description |
|---------------|------|-------------|
| **Manufacturer** | String | Fastener manufacturer name (required -- rows without this are skipped) |
| **ArticleNumber** | String or Numeric | Unique fixture article identifier (required -- rows without this are skipped) |
| *(additional columns)* | Various | Any additional properties for the fixture (e.g., length, diameter, type). Empty string values are automatically cleaned from the map. |

Duplicate article numbers are automatically filtered; only the first occurrence is kept.

---

## Tips

- **Start with "All Sheets"**: When importing a new workbook for the first time, select "All Sheets" to bring in the complete catalog at once. You can then selectively re-import individual sheets later if targeted updates are needed.

- **Use "Drawing + Company XML" for production**: For data that should be available to all users in your organization, always choose the "Drawing + Company XML" import mode. The "Drawing-only" mode is useful for testing a new spreadsheet before committing it to the company configuration.

- **Check the command line output**: After every import, review the AutoCAD command line for warnings about skipped rows. Common issues include missing Family names or missing ArticleNumber values. The warning message includes the sheet name and row number to help you locate the problem in the spreadsheet.

- **One manufacturer per sheet**: The script uses the Excel sheet name as the manufacturer entry identifier in the dictionary (prefixed with `GenericHanger_`). Keep each manufacturer's products on a separate sheet for clean data organization.

- **Fixture sheet is shared**: Fixtures defined on the "Fixture" sheet are available to all products across all manufacturer sheets in the same workbook. Define your complete fastener catalog on this single sheet and reference them by article number in the product rows.

- **Updating existing data**: If you re-import a workbook with the same sheet names, existing products with matching article numbers are replaced with the new data. Products with article numbers not present in the new import remain untouched in the existing data.

- **Coordinate with GenericHanger users**: After importing new data, any open drawings that already have GenericHanger instances will need those instances to recalculate to pick up the new product catalog. New drawings will automatically load the updated company XML on first use.

- **Backup before overwriting**: When using company XML export mode, the script overwrites existing XML files without creating backups. Consider manually backing up the `[CompanyPath]\TSL\Settings\` folder before performing large import operations.

- **Version compatibility**: The script automatically detects your hsbCAD version to use the correct Excel conversion utility. Version 28 and later use a .NET DLL (`hsbExcelToMap.dll`), while version 27 uses a standalone executable (`hsbExcelToMap.exe`). The .NET 8 support was added in version 1.9 of this script.

- **Numeric article numbers**: Article numbers can be either text strings or numeric values in the Excel file. The script handles both formats transparently, so you do not need to force text formatting in Excel.

- **Debug output**: The script writes a temporary debug file to `c:\temp\hsbExcelToMap.xml` containing the raw parsed Excel data. This can be useful for troubleshooting import issues.

- **Verification**: After running the script, launch the GenericHanger tool and verify that the newly imported products appear in the manufacturer, family, and product dropdown lists.

---

## Technical Notes

| Property | Detail |
|----------|--------|
| Script Type | O-Type (Object), `#Type O` |
| Beams Required | 0 (`#NumBeamsReq 0`) |
| Implicit Insert | Yes (`#ImplInsert 1`) -- self-erases after completion |
| Single Cycle | Enforced via `insertCycleCount() > 1` check |
| Unit System | Millimeters (`U(1, "mm")`) |
| DXA Output | Enabled (`#DxaOut 1`) |
| Excel Converter | `hsbExcelToMap.dll` (hsbCAD v28+) or `hsbExcelToMap.exe` (hsbCAD v27) at `[InstallPath]\Utilities\hsbExcelToMap\` |
| .NET Interface | Class: `hsbCad.hsbExcelToMap.HsbCadIO`, Method: `ExcelToMap` |
| Dictionary Namespace | `hsbTSL` |
| Entry Naming | `GenericHanger_[SheetName]` per manufacturer sheet |
| Master Settings File | `GenericHanger.xml` |
| Settings Priority | Company path checked first, then installation path |
| Debug Support | Controlled via `hsbTSLDebugController` MapObject; when enabled, prevents auto-erase and XML export |
| Catalog Persistence | Uses `setPropValuesFromCatalog` / `setCatalogFromPropValues` with the `_LastInserted` key to remember the last file path across sessions |

### Version History

| Version | Date | Change |
|---------|------|--------|
| 1.0 | Feb 2022 | Initial version |
| 1.1 | Feb 2022 | Added joist dimension ranges and alpha (angle) ranges |
| 1.2 | Feb 2022 | Bugfix for writing new manufacturer entries |
| 1.3 | Feb 2022 | Added support for adjustable height straps |
| 1.4 | Feb 2022 | Support for individual localization files |
| 1.5 | Feb 2022 | Bugfix for writing map keys |
| 1.6 | Mar 2022 | Added Fixture import from dedicated Fixture sheet |
| 1.7 | Mar 2022 | Added support for numeric fixture article numbers |
| 1.8 | Mar 2022 | Added support for multiple block overrides per product (e.g., SDE) |
| 1.9 | Feb 2025 | Added .NET 8 version distinction for hsbExcelToMap |

### Data Flow

```
Excel File (.xlsx)
       |
       v
  hsbExcelToMap (.dll/.exe)   -- .NET utility converts Excel to Map
       |
       v
  Map (in-memory)             -- Sheets -> Rows -> Columns
       |
       +---> "Fixture" Sheet ---> mapFixtures (shared fastener catalog)
       |
       +---> Product Sheets  ---> Per-manufacturer MapObjects
                |
                +---> Drawing Dictionary: "GenericHanger_[SheetName]"
                |
                +---> (Optional) Company XML: GenericHanger_[SheetName].xml
                |
                +---> Master Settings Update: GenericHanger.xml
                      (new manufacturers appended to Manufacturer[] list)
```

### Internal Map Structure (Per Manufacturer Entry)

```
MapObject entry: "GenericHanger_[SheetName]"
  +-- Manufacturer
       +-- Family[]
       |    +-- Family (MapName = FamilyName)
       |         +-- Name: "FamilyName"
       |         +-- url: "https://..."
       |         +-- Material: "Steel"
       |         +-- Product[]
       |              +-- Product (MapName = ArticleNumber)
       |                   +-- A, B, C, ... P  (geometric dimensions)
       |                   +-- t               (material thickness)
       |                   +-- Joist\MinWidth, Joist\MaxWidth
       |                   +-- Joist\MinHeight, Joist\MaxHeight
       |                   +-- Alpha           (skew angle range)
       |                   +-- TopFlush        (int flag)
       |                   +-- Adjustable Height Strap (int flag)
       |                   +-- Block[]
       |                   |    +-- Block
       |                   |         +-- Name  (block name)
       |                   |         +-- dX    (X offset)
       |                   +-- Fixture
       |                        +-- ArticleNumber[]
       |                        |    +-- ArticleNumber (string values)
       |                        +-- Header         (int, full nailing)
       |                        +-- Joist          (int, full nailing)
       |                        +-- Header Partial (int, partial nailing)
       |                        +-- Joist Partial  (int, partial nailing)
       +-- Fixture[]
            +-- Fixture (MapName = ArticleNumber)
                 +-- Manufacturer
                 +-- ...additional fixture properties
```

### Relationship to GenericHanger

This importer is a companion utility to the **GenericHanger** script. The GenericHanger tool reads the MapObjects and XML files that this importer produces. The naming convention `GenericHanger_[SheetName]` ensures that each imported manufacturer's data is stored in a separate, identifiable dictionary entry. The GenericHanger script's manufacturer dropdown is populated from the `Manufacturer[]` array in the master `GenericHanger.xml` settings file, which this importer updates when new manufacturers are encountered during import.

### Error Handling and Warnings

- **Missing Family name**: Rows without a Family value produce the warning: "Required family name missing." with the sheet name and row number.
- **Missing ArticleNumber**: Rows without an ArticleNumber value produce the warning: "Required articlenumber missing." with the sheet name and row number.
- **Unknown fixture reference**: Fixture references (Fixture1-Fixture10) that do not match any article in the Fixture sheet produce a warning identifying the key name and the unresolvable article number.
- **No valid data**: If the workbook contains no valid sheets (no sheets with Manufacturer/Family/ArticleNumber columns), the script displays "Could not find any data in [Path]" and erases itself.
- **Settings version mismatch**: Version differences between the drawing dictionary MapObject and the file on disk trigger an informational notice but do not prevent the import from proceeding.
