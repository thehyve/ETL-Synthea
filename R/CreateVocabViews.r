#' @title Create Vocabulary Views to a Preexisting Vocabulary Schema.
#'
#' @description This function creates views for all Vocabulary tables to a specified schema that contains all those tables.
#'
#' @usage CreateVocabViews(connectionDetails, vocabSourceSchema, vocabTargetSchema)
#'
#' @details This function assumes has already been run and \cr\code{vocabSourceSchema} has all required Vocabulary tables.
#'
#' @param connectionDetails	An R object of type\cr\code{connectionDetails} created using the
#'																		 function \code{createConnectionDetails} in the
#'																		 \code{DatabaseConnector} package.
#' @param vocabSourceSchema	The name of the database schema that already contains the Vocabulary
#'																		 tables to create views to.	Requires read permissions to this database. On SQL
#'																		 Server, this should specifiy both the database and the schema,
#'																		 so for example 'cdm_instance.dbo'.
#' @param vocabTargetSchema	The name of the database schema into which to create the Vocabulary
#'																		 views in.	Requires read and write permissions to this database. On SQL
#'																		 Server, this should specifiy both the database and the schema,
#'																		 so for example 'cdm_instance.dbo'.
#'
#'@export

CreateVocabViews <- function (connectionDetails, vocabSourceSchema, vocabTargetSchema)
{

	if (cdmVersion == "5.3.1")
		sqlFilePath <- "cdm_version/v531"
	else if (cdmVersion == "6.0.0")
		sqlFilePath <- "cdm_version/v600"
	else
		stop("Unsupported CDM specified. Supported CDM versions are \"5.3.1\" and \"6.0.0\"")

	conn <- DatabaseConnector::connect(connectionDetails)

	translatedSql <- SqlRender::loadRenderTranslateSql(
		sqlFilename = paste0(sqlFilePath, "/", "create_vocab_views.sql"),
		packageName = "ETLSyntheaBuilder",
		dbms        = connectionDetails$dbms,
    cdm_schema  = vocabTargetSchema,
    vocab_schema = vocabSourceSchema
	)

	writeLines("Running create_vocab_views.sql")


	DatabaseConnector::executeSql(conn, translatedSql)

	on.exit(DatabaseConnector::disconnect(conn))
}
