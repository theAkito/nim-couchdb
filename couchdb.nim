#[
  couchdb: A new awesome Nim library.
]#
{.push gcsafe.}
import
  httpclient,
  json,
  tables
include
  couchdb/meta

type
  CouchResponseHeaders = object
    cache_control     : string
    content_length    : int
    eTag              : string
    transfer_encoding : string

template adjustClient(): untyped =
  http.headers["accept"] = "application/json"
  http.headers["content-type"] = "application/json"

proc reqGet(http: HttpClient, url: string): bool =
  adjustClient()
  if http.get(url).status == resp_ok: result = true

proc reqPost(http: HttpClient, url, body: string): bool =
  adjustClient()
  if http.post(url, body).status == resp_ok: result = true

proc reqPut(http: HttpClient, url, body: string): bool =
  adjustClient()
  if http.put(url, body).status == resp_ok: result = true

proc reqDelete(http: HttpClient, url: string): bool =
  adjustClient()
  if http.delete(url).status == resp_ok: result = true

proc reqHead(http: HttpClient, url: string): bool =
  adjustClient()
  if http.head(url).status == resp_ok: result = true

when isMainModule:
  echo "Greetings!"

{.pop.}