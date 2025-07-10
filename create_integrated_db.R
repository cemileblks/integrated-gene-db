# R Script

# Load libraries -------------------------------------------------------
library(biomaRt)
library(httr)
library(jsonlite)
library(queryup)
library(RMySQL)

# Environment setup ----------------------------------------------------

# Load credentials from environment variables
db_user <- Sys.getenv("DB_USER")
db_password <- Sys.getenv("DB_PASSWORD")
db_name <- Sys.getenv("DB_NAME")
db_host <- Sys.getenv("DB_HOST", "localhost")
db_port <- as.integer(Sys.getenv("DB_PORT", "3306"))
api_key_ncbi <- Sys.getenv("NCBI_API_KEY")

# Check for required variables
if (db_user == "" || db_password == "" || api_key_ncbi == "") {
  stop(
    "Missing one or more required environment
  variables: DB_USER, DB_PASSWORD, NCBI_API_KEY."
  )
}

# MYSQL connection -----------------------------------------------------

db <- dbConnect(MySQL(),
  user = db_user,
  password = db_password,
  dbname = db_name,
  port = db_port,
  host = db_host
)

# ENSEMBL (BioMaRt) Query  ---------------------------------------------

ensembl_ids <- c(
  "ENSMUSG00000036061",
  "ENSMUSG00000000555",
  "ENSMUSG00000023055",
  "ENSMUSG00000075394",
  "ENSMUSG00000001655",
  "ENSMUSG00000022485",
  "ENSMUSG00000001657",
  "ENSMUSG00000001661",
  "ENSMUSG00000076010",
  "ENSMUSG00000023048"
)

ensembl_host <- "https://www.ensembl.org"

ensembl <- useEnsembl(
  biomart = "genes",
  dataset = "mmusculus_gene_ensembl",
  host = ensembl_host
)

# Modified to add more attributes to draw from the Ensembl Database
resultEnsembl <- biomaRt::getBM(
  values = ensembl_ids,
  attributes = c(
    "ensembl_gene_id",
    "entrezgene_id",
    "external_gene_name",
    "chromosome_name",
    "gene_biotype",
    "start_position",
    "end_position", "strand"
  ),
  filters = "ensembl_gene_id",
  mart = ensembl
)

dfEnsembl <- data.frame(resultEnsembl)
dbWriteTable(
  db,
  name = "Ensembl_table",
  value = dfEnsembl,
  row.names = FALSE,
  overwrite = TRUE
)

# NCBI Query -------------------------
# NCBI REST API/ Entrez Programming Utilities (E-utilities)

# Code adapted from NCBI official documentation for E-utilities:
# https://www.ncbi.nlm.nih.gov/books/NBK25497/
# https://www.nlm.nih.gov/dataguide/eutilities/utilities.html

entrez_ids <- dfEnsembl$entrezgene_id

genetic_sources <- c()
map_locations <- c()
gene_descriptions <- c()
gene_summaries <- c()
exon_counts <- c()
organisms <- c()

# Code adapted from lecture code, modified requested API and the retrieved data
for (gene_id in entrez_ids) {
  server <- "https://eutils.ncbi.nlm.nih.gov/entrez/eutils"
  ncbi_query_db <- "gene"

  ncbi_query <- paste0(
    "/esummary.fcgi?db=", ncbi_query_db,
    "&api_key=", api_key_ncbi,
    "&id=", gene_id,
    "&retmode=json"
  )

  r <- GET(
    paste(server, ncbi_query, sep = ""),
    content_type("application/json")
  )

  stop_for_status(r)

  res <- fromJSON(content(r, as = "text"))

  # Converted response to data frame
  gene_data <- res$result[[as.character(gene_id)]]

  genetic_sources <- c(genetic_sources, gene_data$geneticsource)
  map_locations <- c(map_locations, gene_data$maplocation)
  gene_descriptions <- c(gene_descriptions, gene_data$description)
  gene_summaries <- c(gene_summaries, gene_data$summary)
  exon_counts <- c(exon_counts, gene_data$genomicinfo$exoncount)
  organisms <- c(organisms, gene_data$organism$scientificname)
}

dfNCBI <- data.frame(
  entrezgene_id = entrez_ids,
  genetic_source = genetic_sources,
  map_location = map_locations,
  gene_description = gene_descriptions,
  gene_summary = gene_summaries,
  exon_count = exon_counts,
  organism = organisms,
  stringsAsFactors = FALSE
)

dbWriteTable(
  db,
  name = "NCBI_table",
  value = dfNCBI,
  row.names = FALSE,
  overwrite = TRUE
)

# UNIPROT Query --------------------------------------------------------------
# Code adapted from: https://github.com/VoisinneG/queryup?tab=readme-ov-file,
# https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/ifelse

taxon_identifier <- "10090"

gene_names <- dfEnsembl$external_gene_name

names <- c()
keywords <- c()
biological_processes <- c()
cellular_components <- c()
molecular_functions <- c()
features <- c()

for (gene_name in gene_names) {
  query <- list(
    "gene_exact" = gene_name,
    "organism_id" = taxon_identifier,
    "reviewed" = "true"
  )
  result <- query_uniprot(query,
    columns = c(
      "id",
      "keyword",
      "gene_primary",
      "reviewed",
      "go_p",
      "go_c",
      "go_f",
      "feature_count"
    ),
    show_progress = FALSE
  )

  if (nrow(result) == 0) {
    names <- c(names, gene_name)
    keywords <- c(keywords, "Not found")
    biological_processes <- c(biological_processes, "Not found")
    cellular_components <- c(cellular_components, "Not found")
    molecular_functions <- c(molecular_functions, "Not found")
    features <- c(features, "Not found")
  } else {
    names <- c(names, result$`Gene Names (primary)`)
    keywords <- c(keywords, result$Keywords)
    biological_processes <- c(
      biological_processes,
      ifelse(result$`Gene Ontology (biological process)` == "",
        "Data not available", result$`Gene Ontology (biological process)`
      )
    )
    cellular_components <- c(
      cellular_components,
      ifelse(result$`Gene Ontology (cellular component)` == "",
        "Data not available", result$`Gene Ontology (cellular component)`
      )
    )
    molecular_functions <- c(
      molecular_functions,
      ifelse(result$`Gene Ontology (molecular function)` == "",
        "Data not available", result$`Gene Ontology (molecular function)`
      )
    )
    features <- c(features, result$Features)
  }

  Sys.sleep(1)
}

dfUniprot <- data.frame(
  external_gene_name = names,
  uniprot_keywords = keywords,
  protein_biological_process = biological_processes,
  protein_cellular_component = cellular_components,
  protein_molecular_function = molecular_functions,
  protein_features = features
)

dbWriteTable(
  db,
  name = "Uniprot_table",
  value = dfUniprot,
  row.names = FALSE,
  overwrite = TRUE
)

# STRING API Query ----------------------------------------------
# Getting the top 3 STRING interaction partners of the protein
# Code adapted from lecture code and: https://string-db.org/help/api/
# https://sqlpad.io/tutorial/in-operator/,
# https://stackoverflow.com/questions/34859558/set-a-delay-between-two-instructions-in-r

server_stringdb <- "https://version-12-0.string-db.org/api"
format <- "/json"
param <- "/interaction_partners"

gene_names <- c()
HS_interaction_partners1 <- c()
HS_interaction_partners2 <- c()
HS_interaction_partners3 <- c()
combined_interaction_scores1 <- c()
combined_interaction_scores2 <- c()
combined_interaction_scores3 <- c()

for (gene in entrez_ids) {
  query_url <- paste0(
    server_stringdb, format, param,
    "?identifiers=", gene,
    "&species=", taxon_identifier,
    "&limit=", "3"
  )

  response <- content(GET(query_url), "text", encoding = "UTF-8")
  data <- fromJSON(response)

  stringResult <- as.data.frame(data)

  if ("Error" %in% names(data) && data$Error == "not found") {
    # If Error in result append "not found"
    gene_names <- c(gene_names, "Not found")
    HS_interaction_partners1 <- c(HS_interaction_partners1, "Not found")
    HS_interaction_partners2 <- c(HS_interaction_partners2, "Not found")
    HS_interaction_partners3 <- c(HS_interaction_partners3, "Not found")
    combined_interaction_scores1 <- c(combined_interaction_scores1, "Not found")
    combined_interaction_scores2 <- c(combined_interaction_scores2, "Not found")
    combined_interaction_scores3 <- c(combined_interaction_scores3, "Not found")
  } else {
    gene_names <- c(gene_names, data$preferredName_A)
    HS_interaction_partners1 <- c(HS_interaction_partners1, data$preferredName_B[1])
    HS_interaction_partners2 <- c(HS_interaction_partners2, data$preferredName_B[2])
    HS_interaction_partners3 <- c(HS_interaction_partners3, data$preferredName_B[3])

    combined_interaction_scores1 <- c(combined_interaction_scores1, data$score[1])
    combined_interaction_scores2 <- c(combined_interaction_scores2, data$score[2])
    combined_interaction_scores3 <- c(combined_interaction_scores3, data$score[3])
  }

  Sys.sleep(1)
}

dfSTRING <- data.frame(
  entrezgene_id = entrez_ids,
  highest_scoring_protein_interaction_partner_1 = HS_interaction_partners1,
  combined_interaction_score1 = combined_interaction_scores1,
  highest_scoring_protein_interaction_partner_2 = HS_interaction_partners2,
  combined_interaction_score2 = combined_interaction_scores2,
  highest_scoring_protein_interaction_partner_3 = HS_interaction_partners3,
  combined_interaction_score3 = combined_interaction_scores3,
  stringsAsFactors = FALSE
)

dbWriteTable(db, name = "String_table", value = dfSTRING, row.names = FALSE, overwrite = TRUE)

# Combine and Export ---------------------------------------------
# Combined Data Frame, code adapted from:
# https://stackoverflow.com/questions/5620885/how-does-one-reorder-columns-in-a-data-frame
combined_table <- merge(dfEnsembl, dfNCBI, by = "entrezgene_id")
combined_table <- merge(combined_table, dfUniprot, by = "external_gene_name")
combined_table <- merge(combined_table, dfSTRING, by = "entrezgene_id")
combined_table <- combined_table[, c(
  "entrezgene_id", "ensembl_gene_id", "organism", "external_gene_name",
  "gene_description", "genetic_source", "chromosome_name", "map_location",
  "start_position", "end_position", "strand", "gene_biotype", "exon_count",
  "gene_summary", "uniprot_keywords", "protein_biological_process",
  "protein_cellular_component", "protein_molecular_function",
  "protein_features", "highest_scoring_protein_interaction_partner_1",
  "combined_interaction_score1",
  "highest_scoring_protein_interaction_partner_2",
  "combined_interaction_score2",
  "highest_scoring_protein_interaction_partner_3",
  "combined_interaction_score3"
)]

dbWriteTable(
  db,
  name = "Summary_table",
  value = combined_table,
  row.names = FALSE,
  overwrite = TRUE
)

# Disconnect MySQL -------------------

dbDisconnect(db)
