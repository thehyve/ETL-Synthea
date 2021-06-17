#' @title Drop Vocabulary Views.
#'
#' @description This function drops Vocabulary views.
#'
#' @usage DropVocabViews(connectionDetails,vocabDatabaseSchema)
#'
#' @param connectionDetails	An R object of type\cr\code{connectionDetails} created using the
#'																		 function \code{createConnectionDetails} in the
#'																		 \code{DatabaseConnector} package.
#' @param vocabDatabaseSchema	The name of the database schema that contains the Vocabulary
#'																		 instance.	Requires read and write permissions to this database. On SQL
#'																		 Server, this should specifiy both the database and the schema,
#'																		 so for example 'vocab_instance.dbo'.
#'
#'@export


DropVocabViews <- function (connectionDetails, vocabDatabaseSchema)
{
	if (cdmVersion == "5.3.1")
		sqlFilePath <- "cdm_version/v531"
	else if (cdmVersion == "6.0.0")
		sqlFilePath <- "cdm_version/v600"
	else
		stop("Unsupported CDM specified. Supported CDM versions are \"5.3.1\" and \"6.0.0\"")

	translatedSql <- SqlRender::loadRenderTranslateSql(
		sqlFilename = paste0(sqlFilePath,"/","drop_vocab_views.sql"),
		packageName = "ETLSyntheaBuilder",
		dbms				= connectionDetails$dbms,
		cdm_schema	= vocabDatabaseSchema
	)

	writeLines("Running drop_vocab_views.sql")

	conn <- DatabaseConnector::connect(connectionDetails)

	DatabaseConnector::executeSql(conn, translatedSql)

	on.exit(DatabaseConnector::disconnect(conn))
}
