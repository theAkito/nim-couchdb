#[
  MetaInstantiator: Create, Construct, Delete, Destroy, Convert, Transform & Manage Meta constructions.
]#
import
  sequtils,
  json,
  tables,
  strtabs,
  segfaults
include
  meta

func `&`(collection: DocumentResults, item: DocumentResult): DocumentResults =
  # Putting into `metacompat.nim` and exporting does not work.
  result = DocumentResults(cast[seq[DocumentResult]](collection) & item)

proc parseCouchResponseHeaders*(raw_text: string): CouchResponseHeaders =
  raw_text.parseJson.to(CouchResponseHeaders)

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

proc extractNewIndexResult*(jtext: JsonNode): NewIndexResult =
  # /db/_index
  if jtext.isNil: return NewIndexResult()
  result = try: NewIndexResult(
    result : jtext["result"].getStr(),
    id     : jtext["id"].getStr(),
    name   : jtext["name"].getStr()
  ) except: NewIndexResult()

proc parseNewIndexResult*(raw_text: string): NewIndexResult =
  # /db/_index
  let jtext = try: raw_text.parseJson() except: nil
  result = extractNewIndexResult(jtext)

proc extractUsers*(jtext: JsonNode): (Admins, Members) =
  # /{db}/_security
  if jtext.isNil: return (Admins(), Members())
  let
    admin_fields  = jtext.getOrDefault("admins").getFields()
    member_fields = jtext.getOrDefault("member").getFields()
    admin_names   = admin_fields.getOrDefault("names").getElems()
    member_names  = member_fields.getOrDefault("names").getElems()
    admin_roles   = admin_fields.getOrDefault("roles").getElems()
    member_roles  = member_fields.getOrDefault("roles").getElems()
  result = (
    Admins(
      names : admin_names.mapIt(it.getStr),
      roles : admin_roles.mapIt(it.getStr)
    ),
    Members(
      names : member_names.mapIt(it.getStr),
      roles : member_roles.mapIt(it.getStr)
    )
  )

proc parseUsers*(raw_text: string): (Admins, Members) =
  # /{db}/_security
  let jtext = try: raw_text.parseJson() except: nil
  result = extractUsers(jtext)

proc extractSimpleConfirmation*(jtext: JsonNode): SimpleConfirmation =
  # /db/_compact
  # /db/_compact/design-doc
  # /db/_view_cleanup
  if jtext.isNil: return SimpleConfirmation()
  result = try: SimpleConfirmation(
    ok : jtext["ok"].getBool
  ) except: SimpleConfirmation()

proc parseSimpleConfirmation*(raw_text: string): SimpleConfirmation =
  # /db/_compact
  # /db/_compact/design-doc
  # /db/_view_cleanup
  # Response Header validation is crucial with single bool
  # that may have excepted.
  let jtext = try: raw_text.parseJson() except: nil
  result = extractSimpleConfirmation(jtext)

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

proc extractExplainIndexResult*(jtext: JsonNode): ExplainIndexResult =
  # /db/_explain
  if jtext.isNil: return ExplainIndexResult()
  result = ExplainIndexResult(
    dbname            : jtext["dbname"].getStr,
    index             : jtext.getOrDefault("index"),
    selector          : jtext.getOrDefault("selector"),
    opts              : jtext.getOrDefault("opts"),
    limit             : jtext["limit"].getInt,
    skip              : jtext["skip"].getInt,
    fields            : jtext["fields"].getElems.mapIt(it.getStr),
    rrange            : jtext.getOrDefault("rrange")
  )

proc parseExplainIndexResult*(raw_text: string): ExplainIndexResult =
  # /db/_explain
  let jtext = try: raw_text.parseJson() except: nil
  result = extractExplainIndexResult(jtext)

proc extractUpdatedDocuments*(jtext: JsonNode): seq[UpdatedDocument] =
  # /{db}/_bulk_docs
  if jtext.isNil: return @[]
  for doc in jtext.elems:
    var upDocOk: bool
    try:
      upDocOk = doc["ok"].getBool()
    except KeyError:
      return @[]
    except:
      echo getCurrentExceptionMsg()
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

proc extractFoundDocuments*(jtext: JsonNode): FoundDocuments =
  if jtext.isNil: return FoundDocuments()
  let
    docs = try: jtext["docs"].elems except: @[]
    jexec_stats = try: jtext["execution_stats"].fields except: {"": JsonNode()}.toOrderedTable()
    exec_stats = try: ExecutionStats(
      total_keys_examined        : jexec_stats["total_keys_examined"].getInt(),
      total_docs_examined        : jexec_stats["total_docs_examined"].getInt(),
      total_quorum_docs_examined : jexec_stats["total_quorum_docs_examined"].getInt(),
      results_returned           : jexec_stats["results_returned"].getInt(),
      execution_time_ms          : jexec_stats["execution_time_ms"].getFloat()
    ) except: ExecutionStats()
  result = FoundDocuments(
    docs              : docs,
    warning           : jtext.getOrDefault("warning").getStr(">>none<<"),
    execution_stats   : exec_stats,
    bookmark          : jtext.getOrDefault("bookmark").getStr(">>none<<")
  )

proc parseFoundDocuments*(raw_text: string, fields: seq[string]): FoundDocuments =
  let jtext = try: raw_text.parseJson() except: nil
  result = extractFoundDocuments(jtext)

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
  if jtext.isNil: return DocumentResult()
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