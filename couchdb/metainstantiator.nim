#[
  MetaInstantiator: Create, Construct, Delete, Destroy, Convert, Transform & Manage Meta constructions.
]#
import
  sequtils,
  json,
  tables,
  strtabs
include
  meta

func `&`(collection: DocumentResults, item: DocumentResult): DocumentResults =
  # Putting into `metacompat.nim` and exporting does not work.
  result = DocumentResults(cast[seq[DocumentResult]](collection) & item)

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

proc extractUpdatedDocuments*(jtext: JsonNode): seq[UpdatedDocument] =
  # /{db}/_bulk_docs
  if jtext.kind == JNull: return @[]
  for doc in jtext.elems:
    var upDocOk: bool
    try:
      upDocOk = doc["ok"].getBool()
    except:
      return @[UpdatedDocument()]
    if upDocOk:
      result.add(
        UpdatedDocument(
          ok      : true, # Explicitly not using var, to prevent compilation error.
          id      : doc["id"].getStr(),
          rev     : doc.getOrDefault("rev").getStr()
        )
      )
    elif not upDocOk:
      result.add(
        UpdatedDocument(
          ok      : false, # Explicitly not using var, to prevent compilation error.
          id      : doc["id"].getStr(),
          error   : doc.getOrDefault("error").getStr(),
          reason  : doc.getOrDefault("reason").getStr()
        )
      )

proc parseUpdatedDocuments*(raw_text: string): seq[UpdatedDocument] =
  # /{db}/_bulk_docs
  let jtext = try: raw_text.parseJson() except: nil
  result = extractUpdatedDocuments(jtext)

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

func extractDocumentResult*(jtext: JsonNode): DocumentResult =
  # /{db}/_bulk_get
  if jtext.kind == JNull: return DocumentResult()
  if jtext["docs"].elems[0].fields.hasKey("ok"):
    let
      doc = jtext["docs"].elems[0].fields["ok"]
      docRevisions = DocRevisions(
        start : doc["_revisions"].fields["start"].getInt(),
        ids   : doc["_revisions"].fields["ids"].elems.mapIt(it.getStr())
      )
      docOk = DocOk(
        id    : doc["_id"].getStr(),
        rev   : doc["_rev"].getStr(),
        value : doc["value"],
        revisions: docRevisions
      )
      docEntity = DocumentEntity(
        state : ok,
        ok    : docOk
      )
    result = DocumentResult(
      id      : jtext["id"].getStr(),
      docs    : @[docEntity]
    )
  elif jtext["docs"].elems[0].fields.hasKey("error"):
    let
      doc = jtext["docs"].elems[0].fields["error"]
      docErr = DocErr(
        id     : doc["id"].getStr(),
        rev    : doc["rev"].getStr(),
        error  : doc["error"].getStr(),
        reason : doc["reason"].getStr()
      )
      docEntity = DocumentEntity(
        state  : error,
        error  : docErr
      )
    result = DocumentResult(
      id       : jtext["id"].getStr(),
      docs     : @[docEntity]
    )
  else:
    return DocumentResult()

proc parseDocumentResult*(raw_text: string): DocumentResult =
  # /{db}/_bulk_get
  let jtext = try: raw_text.parseJson() except: nil
  result = extractDocumentResult(jtext)

proc parseDocumentResults*(raw_text: string): DocumentResults =
  # /{db}/_bulk_get
  for res in raw_text.parseJson().elems:
    result = result & extractDocumentResult(res)