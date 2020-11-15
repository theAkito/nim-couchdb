#[
  MetaInstantiator: Create, Construct, Delete, Destroy, Convert, Transform & Manage Meta constructions.
]#
import
  json,
  tables,
  strtabs
include
  meta

proc parseCouchResponseHeaders*(jtext: string): CouchResponseHeaders =
  jtext.parseJson.to(CouchResponseHeaders)

proc parseNewIndex*(jtext: string): NewIndex =
  jtext.parseJson.to(NewIndex)

proc parseRevsDiff*(jtext: string): RevsDiff =
  jtext.parseJson.to(RevsDiff)

proc parseRevsDiffResponse*(jtext: string): RevsDiffResponse =
  jtext.parseJson.to(RevsDiffResponse)

proc parsePurgeResponse*(jtext: string): PurgeResponse =
  jtext.parseJson.to(PurgeResponse)

proc parseAdmins*(jtext: string): Admins =
  jtext.parseJson.to(Admins)

proc parseMembers*(jtext: string): Members =
  jtext.parseJson.to(Members)

proc parseNewIndexResult*(jtext: string): NewIndexResult =
  jtext.parseJson.to(NewIndexResult)

proc parseSimpleConfirmation*(jtext: string): SimpleConfirmation =
  jtext.parseJson.to(SimpleConfirmation)

proc parseDocChangesResponse*(jtext: string): DocChangesResponse =
  jtext.parseJson.to(DocChangesResponse)

proc parseDocChangesQuery*(jtext: string): DocChangesQuery =
  jtext.parseJson.to(DocChangesQuery)

proc parseSyncShardsResponse*(jtext: string): SyncShardsResponse =
  jtext.parseJson.to(SyncShardsResponse)

proc parseDocShardResponse*(jtext: string): DocShardResponse =
  jtext.parseJson.to(DocShardResponse)

proc parseDatabaseShards*(jtext: string): DatabaseShards =
  jtext.parseJson.to(DatabaseShards)

proc parseExplainIndexResult*(jtext: string): ExplainIndexResult =
  jtext.parseJson.to(ExplainIndexResult)

proc parseUpdatedDocument*(jtext: string): UpdatedDocument =
  jtext.parseJson.to(UpdatedDocument)

proc parseSearchedEntity*(jtext: string): SearchedEntity =
  jtext.parseJson.to(SearchedEntity)

proc parseFoundDocuments*(jtext: string): FoundDocuments =
  jtext.parseJson.to(FoundDocuments)

proc parseWantedDocument*(jtext: string): WantedDocument =
  jtext.parseJson.to(WantedDocument)

proc parseWantedDocuments*(jtext: string): WantedDocuments =
  jtext.parseJson.to(WantedDocuments)

proc parseDocRevisions*(jtext: string): DocRevisions =
  jtext.parseJson.to(DocRevisions)

proc parseDocOk*(jtext: string): DocOk =
  jtext.parseJson.to(DocOk)

proc parseDocErr*(jtext: string): DocErr =
  jtext.parseJson.to(DocErr)

proc parseDocumentEntity*(jtext: string): DocumentEntity =
  jtext.parseJson.to(DocumentEntity)

proc parseDocumentResult*(jtext: string): DocumentResult =
  jtext.parseJson.to(DocumentResult)

proc parseDocumentResults*(jtext: string): DocumentResults =
  jtext.parseJson.to(DocumentResults)