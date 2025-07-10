-- MySQL dump 10.13  Distrib 8.0.39, for Linux (x86_64)
--
-- Host: localhost    Database: your_database_name
-- ------------------------------------------------------
-- Server version	8.0.39-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Ensembl_table`
--

DROP TABLE IF EXISTS `Ensembl_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Ensembl_table` (
  `ensembl_gene_id` text,
  `entrezgene_id` bigint DEFAULT NULL,
  `external_gene_name` text,
  `chromosome_name` bigint DEFAULT NULL,
  `gene_biotype` text,
  `start_position` bigint DEFAULT NULL,
  `end_position` bigint DEFAULT NULL,
  `strand` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `NCBI_table`
--

DROP TABLE IF EXISTS `NCBI_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `NCBI_table` (
  `entrezgene_id` bigint DEFAULT NULL,
  `genetic_source` text,
  `map_location` text,
  `gene_description` text,
  `gene_summary` text,
  `exon_count` bigint DEFAULT NULL,
  `organism` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `String_table`
--

DROP TABLE IF EXISTS `String_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `String_table` (
  `entrezgene_id` bigint DEFAULT NULL,
  `highest_scoring_protein_interaction_partner_1` text,
  `combined_interaction_score1` text,
  `highest_scoring_protein_interaction_partner_2` text,
  `combined_interaction_score2` text,
  `highest_scoring_protein_interaction_partner_3` text,
  `combined_interaction_score3` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Summary_table`
--

DROP TABLE IF EXISTS `Summary_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Summary_table` (
  `entrezgene_id` bigint DEFAULT NULL,
  `ensembl_gene_id` text,
  `organism` text,
  `external_gene_name` text,
  `gene_description` text,
  `genetic_source` text,
  `chromosome_name` bigint DEFAULT NULL,
  `map_location` text,
  `start_position` bigint DEFAULT NULL,
  `end_position` bigint DEFAULT NULL,
  `strand` bigint DEFAULT NULL,
  `gene_biotype` text,
  `exon_count` bigint DEFAULT NULL,
  `gene_summary` text,
  `uniprot_keywords` text,
  `protein_biological_process` text,
  `protein_cellular_component` text,
  `protein_molecular_function` text,
  `protein_features` text,
  `highest_scoring_protein_interaction_partner_1` text,
  `combined_interaction_score1` text,
  `highest_scoring_protein_interaction_partner_2` text,
  `combined_interaction_score2` text,
  `highest_scoring_protein_interaction_partner_3` text,
  `combined_interaction_score3` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Uniprot_table`
--

DROP TABLE IF EXISTS `Uniprot_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Uniprot_table` (
  `external_gene_name` text,
  `uniprot_keywords` text,
  `protein_biological_process` text,
  `protein_cellular_component` text,
  `protein_molecular_function` text,
  `protein_features` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-12  4:11:45
