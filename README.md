# 🧬 Gene Annotation Integration

This project was developed for the *Biological Databases* course (MSc Bioinformatics, University of Edinburgh) in 2024. It integrates gene annotation data from multiple biological databases into a local MySQL database using an R script.

## Description

Given a list of 10 mouse genes (Ensembl IDs), this script:

- Retrieves annotation data from **Ensembl**, **NCBI Entrez**, **UniProt**, and **STRING-db**
- Integrates the results into a **local MySQL database**
- Produces a **final SQL summary table** combining all annotations

## Requirements

- R 4.2+
- MySQL server (on `localhost`)
- R packages:  
  `biomaRt`, `httr`, `jsonlite`, `queryup`, `RMySQL`

You can install all required R packages with:

```r
install.packages(c("biomaRt", "httr", "jsonlite", "queryup", "RMySQL"))
```
## Usage
### Inputs 

- The list of 10 Ensembl gene IDs is hardcoded in the script.
- All database queries are performed programmatically via API or library.

### How to Run

1. Make sure your MySQL server is running.

2. Supply your own database and API credentials by creating a  `.Renviron` file in the project root with the following variables:
    ```r
    DB_USER=your_db_username
    DB_PASSWORD=your_db_password
    DB_NAME=your_db_name
    DB_HOST=localhost
    DB_PORT=3306
    NCBI_API_KEY=your_ncbi_api_key
    ```
    You can also start by copying `Renviron.template`:
    ```bash
    cp .Renviron.template .Renviron
    ```

3. Open the R script (`create_integrated_db.R`).

4. Run the script in full (recommended inside an RStudio session or terminal).

5. The script will:

    - Create 5 MySQL tables (Ensembl_table, NCBI_table, Uniprot_table, String_table, Summary_table)

    -  Write the merged gene annotations into Summary_table.

### Output

The final `Summary_table` contains an integrated view across all data sources. Each row corresponds to a gene, with fields from:

- **Ensembl**: gene location, gene type  
- **NCBI**: gene summary, genetic source  
- **UniProt**: protein functions, GO terms  
- **STRING**: top 3 protein interaction partners

### Project Structure
```md
    .
    ├── create_integrated_db.R      # Main integration script
    ├── schema.sql                  # MySQL table schema
    ├── data.sql                    # Sample integrated data
    ├──.Renviron.template           # Template for user credentials
    ├── README.md                   # Project overview and instructions
    └──.gitignore                   # Prevents committing sensitive files
```
## Notes

- This project demonstrates practical biological data integration using APIs and SQL.

- Designed as a fully automated script with error handling and compatibility for re-running.

- Code is structured to allow generalisation for other gene sets.

## License

This project is licensed under the [MIT License](LICENSE).

