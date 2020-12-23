
# devtools::install_github("thehyve/OHDSI-ETL-Synthea")

library(ETLSyntheaBuilder)


# Settings --------------------------------------------------------
cd <- DatabaseConnector::createConnectionDetails(
  dbms     = "postgresql",
  server   = "localhost/ohdsi",
  user     = "username",
  password = "",
  port     = 5432
)

vocabSchema <- "vocab2"
pathToVocabCsv <- "/Users/maxim/Documents/OMOP data/OMOP Vocabulary/vocab_21_dec_2020"
sourceSchema <- "native"
cdmSchema <- "cdm_synthea"



# Vocabulary --------------------------------------------------------
conn <- DatabaseConnector::connect(cd)
DatabaseConnector::executeSql(conn, paste("CREATE SCHEMA", vocabSchema))
ETLSyntheaBuilder::DropVocabTables(cd,vocabSchema)
ETLSyntheaBuilder::CreateVocabTables(cd,vocabSchema)
ETLSyntheaBuilder::LoadVocabFromCsv(cd,vocabSchema,pathToVocabCsv)
ETLSyntheaBuilder::CreateVocabConstraintsAndIndices(cd, vocabSchema)

# Synthea source --------------------------------------------------------
DatabaseConnector::executeSql(conn, paste("CREATE SCHEMA", sourceSchema))
ETLSyntheaBuilder::DropSyntheaTables(cd, sourceSchema)
ETLSyntheaBuilder::CreateSyntheaTables(cd, sourceSchema)
ETLSyntheaBuilder::LoadSyntheaTables(cd, sourceSchema,"/Users/maxim/Develop/OHDSI/OHDSI-ETL-Synthea/20191101 - 1000 Massachusetts/csv")

ETLSyntheaBuilder::DropMapAndRollupTables(cd,cdmSchema)
ETLSyntheaBuilder::CreateVocabMapTables(cd,vocabSchema)

# Mapping to OMOP CDM ------------------------------------------------------
DatabaseConnector::executeSql(conn, paste("CREATE SCHEMA", cdmSchema))

# Prepare
ETLSyntheaBuilder::CreateVisitRollupTables(cd,cdmSchema,"native")
ETLSyntheaBuilder::DropVocabViews(cd, cdmSchema)
ETLSyntheaBuilder::CreateVocabViews(cd, vocabSchema, cdmSchema)

# create view cdm5.source_to_standard_vocab_map AS (SELECT * FROM vocab.source_to_standard_vocab_map);
# create view cdm5.source_to_source_vocab_map AS (select * from vocab.source_to_source_vocab_map);

ETLSyntheaBuilder::DropEventTables(cd,cdmSchema)
ETLSyntheaBuilder::CreateEventTables(cd,cdmSchema)
ETLSyntheaBuilder::LoadEventTables(cd,cdmSchema,"native")

DatabaseConnector::disconnect(conn)
