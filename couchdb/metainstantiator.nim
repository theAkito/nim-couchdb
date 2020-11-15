#[
  MetaInstantiator: Create, Construct, Delete, Destroy, Convert, Transform & Manage Meta constructions.
]#
import
  json,
  tables,
  strtabs
include
  meta

proc parseCouchResponseHeaders*(raw_text: string): CouchResponseHeaders =
  raw_text.parseJson.to(CouchResponseHeaders)

proc parseNewIndex*(raw_text: string): NewIndex =
  raw_text.parseJson.to(NewIndex)

proc parseRevsDiff*(raw_text: string): RevsDiff =
  raw_text.parseJson.to(RevsDiff)

proc parseRevsDiffResponse*(raw_text: string): RevsDiffResponse =
  raw_text.parseJson.to(RevsDiffResponse)

proc parsePurgeResponse*(raw_text: string): PurgeResponse =
  raw_text.parseJson.to(PurgeResponse)

proc parseAdmins*(raw_text: string): Admins =
  raw_text.parseJson.to(Admins)

proc parseMembers*(raw_text: string): Members =
  raw_text.parseJson.to(Members)

proc parseNewIndexResult*(raw_text: string): NewIndexResult =
  raw_text.parseJson.to(NewIndexResult)

proc parseSimpleConfirmation*(raw_text: string): SimpleConfirmation =
  raw_text.parseJson.to(SimpleConfirmation)

proc parseDocChangesResponse*(raw_text: string): DocChangesResponse =
  raw_text.parseJson.to(DocChangesResponse)

proc parseDocChangesQuery*(raw_text: string): DocChangesQuery =
  raw_text.parseJson.to(DocChangesQuery)

proc parseSyncShardsResponse*(raw_text: string): SyncShardsResponse =
  raw_text.parseJson.to(SyncShardsResponse)

proc parseDocShardResponse*(raw_text: string): DocShardResponse =
  raw_text.parseJson.to(DocShardResponse)

proc parseDatabaseShards*(raw_text: string): DatabaseShards =
  raw_text.parseJson.to(DatabaseShards)

proc parseExplainIndexResult*(raw_text: string): ExplainIndexResult =
  raw_text.parseJson.to(ExplainIndexResult)

proc parseUpdatedDocument*(raw_text: string): UpdatedDocument =
  raw_text.parseJson.to(UpdatedDocument)

proc parseSearchedEntity*(raw_text: string): SearchedEntity =
  raw_text.parseJson.to(SearchedEntity)

proc parseFoundDocuments*(raw_text: string): FoundDocuments =
  raw_text.parseJson.to(FoundDocuments)

proc parseWantedDocument*(raw_text: string): WantedDocument =
  raw_text.parseJson.to(WantedDocument)

proc parseWantedDocuments*(raw_text: string): WantedDocuments =
  raw_text.parseJson.to(WantedDocuments)

proc parseDocRevisions*(raw_text: string): DocRevisions =
  raw_text.parseJson.to(DocRevisions)

proc parseDocOk*(raw_text: string): DocOk =
  raw_text.parseJson.to(DocOk)

proc parseDocErr*(raw_text: string): DocErr =
  raw_text.parseJson.to(DocErr)

proc parseDocumentEntity*(raw_text: string): DocumentEntity =
  raw_text.parseJson.to(DocumentEntity)

proc parseDocumentResult*(raw_text: string): DocumentResult =
  # /{db}/_bulk_get
  let
    jtext = try: raw_text.parseJson() except: nil
  if jtext.kind == JNull: return DocumentResult()
  if jtext["docs"].elems[0].fields.hasKey("ok"):
    let
      doc = jtext["docs"].elems[0].fields["ok"]
      docOk = DocOk(
        id: doc["_id"].getStr(),
        rev: doc["_rev"].getStr(),
        value: doc["value"],
      )
      docEntity = DocumentEntity(
        state: ok,
        ok: docOk
      )
    result = DocumentResult(
      id: jtext["id"].getStr(),
      docs: @[docEntity]
    )
  elif jtext["docs"].elems[0].fields.hasKey("error"):
    discard
  else:
    return DocumentResult()

proc parseDocumentResults*(raw_text: string): DocumentResults =
  # /{db}/_bulk_get
  raw_text.parseJson.to(DocumentResults)