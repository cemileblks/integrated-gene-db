# 🧬 Gene Annotation Integration

![R](https://img.shields.io/badge/R-276DC3?style=flat-square&logo=r&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat-square&logo=mysql&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black)
![API Integration](https://img.shields.io/badge/API%20Integration-4AB197?style=flat-square&logo=linktree&logoColor=white)
![biomaRt](https://img.shields.io/badge/biomaRt-3366CC?style=flat-square&logo=r&logoColor=white)
![httr](https://img.shields.io/badge/httr-1462A6?style=flat-square&logo=r&logoColor=white)
![jsonlite](https://img.shields.io/badge/jsonlite-6F42C1?style=flat-square&logo=json&logoColor=white)
![RMySQL](https://img.shields.io/badge/RMySQL-00758F?style=flat-square&logo=database&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=github&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-green?style=flat-square)

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

