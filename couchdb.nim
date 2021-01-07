#[
  couchdb: A new awesome Nim library.
]#
{.push gcsafe.}
import
  httpclient,
  json,
  options,
  tables,
  couchdb/[meta, couchmeta, metainstantiator, modelapplicator]
export
  couchmeta

template adjustClient(): untyped =
  http.headers["accept"] = "application/json"
  http.headers["content-type"] = "application/json"

proc reqGet(http: HttpClient, url, req_kind: string): bool =
  adjustClient()
  http.get(url & req_kind).status == resp_ok

proc reqPost(http: HttpClient, url, req_kind, body: string): bool =
  adjustClient()
  http.post(url & req_kind, body).status == resp_ok

proc reqPut(http: HttpClient, url, req_kind, body: string): bool =
  adjustClient()
  http.put(url & req_kind, body).status == resp_ok

proc reqDelete(http: HttpClient, url, req_kind: string): bool =
  adjustClient()
  http.delete(url & req_kind).status == resp_ok

proc reqHead(http: HttpClient, url, req_kind: string): bool =
  adjustClient()
  http.head(url & req_kind).status == resp_ok

proc getDbAllDocs(http: HttpClient, db, url, req_kind: string): bool =
  http.reqGet(url & req_sep & db, req_db_all_docs)

proc getDbAllDesignDocs(http: HttpClient, db, url, req_kind: string): bool =
  http.reqGet(url & req_sep & db, req_db_design_docs)

proc getDbBulkDocs*(http: HttpClient, db, url, req_kind: string, docs: WantedDocuments): DocumentResults =
  let response = http.post(url & req_sep & db & req_kind, docs.toJtext)
  if response.status == resp_ok:
    result = response.body.parseDocumentResults()
  else:
    result = DocumentResults(@[])

when mode_debug:
  echo WantedDocuments(
    docs: @[
      WantedDocument(
        id : "id1a",
        rev : "rev2a",
        atts_since : "atts_since3a"
      ),
      WantedDocument(
        id : "id1b",
        rev : "rev2b",
        atts_since : "atts_since3b"
      ),
      WantedDocument(
        id : "id1c",
        rev : "rev2c",
        atts_since : "atts_since3c"
      )
    ]
  ).toJtext.parseJson.pretty

{.pop.}