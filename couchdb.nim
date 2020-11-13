#[
  couchdb: A new awesome Nim library.
]#
{.push gcsafe.}
import
  httpclient,
  json,
  options,
  tables
include
  couchdb/meta

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

proc getDbBulkDocs(http: HttpClient, db, url, req_kind: string, docs: WantedDocuments): Documents =
  http.reqPost(url & req_sep & db, req_db_bulk_get, $(%* docs))

when isMainModule:
  echo "Greetings!"

{.pop.}