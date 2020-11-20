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
  if http.get(url & req_kind).status == resp_ok: result = true

proc reqPost(http: HttpClient, url, req_kind, body: string): bool =
  adjustClient()
  if http.post(url & req_kind, body).status == resp_ok: result = true

proc reqPut(http: HttpClient, url, req_kind, body: string): bool =
  adjustClient()
  if http.put(url & req_kind, body).status == resp_ok: result = true

proc reqDelete(http: HttpClient, url, req_kind: string): bool =
  adjustClient()
  if http.delete(url & req_kind).status == resp_ok: result = true

proc reqHead(http: HttpClient, url, req_kind: string): bool =
  adjustClient()
  if http.head(url & req_kind).status == resp_ok: result = true

proc getDbAllDocs(http: HttpClient, db, url, req_kind: string): bool =
  http.reqGet(url & req_sep & db, req_db_all_docs)

proc getDbAllDesignDocs(http: HttpClient, db, url, req_kind: string): bool =
  http.reqGet(url & req_sep & db, req_db_design_docs)

proc getDbBulkDocs(http: HttpClient, db, url, req_kind: string, docs: WantedDocuments): bool =
  http.reqPost(url & req_sep & db, req_db_bulk_get, docs.toJtext)

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