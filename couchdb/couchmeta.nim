#[
  couchmeta: Global constants, etc.
]#
import
  json,
  tables

type
  DocumentEntityState             * = enum
    ok, error
  CouchResponseHeaders            * = object
    cache_control                 * : string
    content_length                * : int
    eTag                          * : string
    transfer_encoding             * : string
  Selector                        * = object
  NewIndex                        * = object
    # /db/_index
    index                         * : JsonNode
    ddoc                          * : string
    name                          * : string
    ttype                         * : string
    partial_filter_selector       * : JsonNode
    partitioned                   * : bool
  # PUT /{db}/_purged_infos_limit
  PurgedInfosLimit                * = distinct int
  RevsLimit                       * = distinct int
  # POST /{db}/_purge
  # POST /{db}/_missing_revs
  DocumentMiniSpec                * = OrderedTable[string, seq[string]]
  MissingRevs                     * = object
    missing_revs                  * : DocumentMiniSpec
  RevsDiffEntity                  * = object
    # POST /{db}/_revs_diff
    missing                       * : seq[string]
    possible_ancestors            * : seq[string]
  # POST /{db}/_revs_diff
  RevsDiff                        * = distinct OrderedTable[string, RevsDiffEntity]
  PurgeResponse                   * = object
    purge_seq                     * : string
    purged                        * : DocumentMiniSpec
  Users                           * = object of RootObj
    # /{db}/_security
    names                         * : seq[string]
    roles                         * : seq[string]
  Admins                          * = ref object of Users
  Members                         * = ref object of Users
  NewIndexResult                  * = object
    result                        * : string
    id                            * : string
    name                          * : string
  SimpleConfirmation              * = object
    # /db/_compact
    # /db/_compact/design-doc
    # /db/_view_cleanup
    # PUT /{db}/_revs_limit
    ok                            * : bool
  DocChangesResponse              * = object
    last_seq                      * : string
    pending                       * : int
    results                       * : seq[JsonNode]
  DocChangesQuery                 * = object
    doc_ids                       * : seq[string]
    conflicts                     * : bool
    descending                    * : bool
    feed                          * : string
    filter                        * : string
    heartbeat                     * : int
    include_docs                  * : bool
    attachments                   * : bool
    att_encoding_info             * : bool
    last_event_id                 * : int
    limit                         * : int
    since                         * : string
    style                         * : string
    timeout                       * : int
    view                          * : string
    seq_interval                  * : int
    reason                        * : seq[string]
    nodes                         * : seq[string]
  Document                        * = object
    # GET /{db}/{docid}
    id                            * : string
    rev                           * : string
    deleted                       * : bool
    attachments                   * : JsonNode
    conflicts                     * : seq[string]
    deleted_conflicts             * : seq[string]
    local_seq                     * : string
    revs_info                     * : seq[JsonNode]
    revisions                     * : JsonNode
  NewDocumentResponse             * = object
    # PUT /{db}/{docid}
    # PUT /{db}/{docid}/{attname}
    # DELETE /{db}/{docid}/{attname}
    id                            * : string
    ok                            * : bool
    rev                           * : string
  ViewIndexSizes                  * = object
    # GET /{db}/_design/{ddoc}/_info
    active                        * : int
    disk                          * : int
    external                      * : int
  ViewIndex                       * = object
    # GET /{db}/_design/{ddoc}/_info
    compact_running               * : bool
    language                      * : string
    purge_seq                     * : int
    signature                     * : string
    sizes                         * : ViewIndexSizes
    update_seq                    * : string
    updater_running               * : bool
    waiting_clients               * : int
    waiting_commit                * : bool
  ViewIndexResponse               * = object
    # GET /{db}/_design/{ddoc}/_info
    name                          * : string
    view_index                    * : ViewIndex
  DesignDocInfo                   * = object
    # GET /{db}/_design/{ddoc}/_info
    name                          * : string
    view_index                    * : string
  ViewRow                         * = object
    # GET /{db}/_design/{ddoc}/_view/{view}
    id                            * : string
    key                           * : string
    value                         * : JsonNode
  DesignDocViewResponse           * = object
    # GET /{db}/_design/{ddoc}/_view/{view}
    offset                        * : int
    rows                          * : seq[ViewRow]
    total_rows                    * : int
    #TODO: Figure out the object representation of this node.
    update_seq                    * : JsonNode
  DesignDocIndexSearchResponse    * = object
    # GET /{db}/_design/{ddoc}/_search/{index}
    rows                          * : seq[ViewRow]
    total_rows                    * : int
    bookmark                      * : string
  SyncShardsResponse              * = object
    ok                            * : bool
    error                         * : seq[string]
    reason                        * : seq[string]
    nodes                         * : seq[string]
  DocShardResponse                * = object
    rrange                        * : string
    nodes                         * : seq[string]
  DatabaseShards                  * = object
    shards                        * : JsonNode
  ExplainIndexResult              * = object
    dbname                        * : string
    index                         * : JsonNode
    selector                      * : JsonNode
    opts                          * : JsonNode
    limit                         * : int
    skip                          * : int
    fields                        * : seq[string]
    rrange                        * : JsonNode # Perhaps make definitive.
  UpdatedDocument                 * = object
    # /{db}/_bulk_docs
    id                            * : string
    case ok* : bool:
      of true:
        rev                       * : string
      of false:
        error                     * : string
        reason                    * : string
  SearchedEntity                  * = object
    selector                      * : JsonNode
    limit                         * : int
    skip                          * : int
    sort                          * : seq[string]
    fields                        * : seq[string]
    use_index                     * : seq[string]
    r                             * : int
    bookmark                      * : string
    update                        * : bool
    stable                        * : bool
    execution_stats               * : bool
  ExecutionStats                  * = object
    total_keys_examined           * : int
    total_docs_examined           * : int
    total_quorum_docs_examined    * : int
    results_returned              * : int
    execution_time_ms             * : float
  FoundDocuments                  * = object
    docs                          * : seq[JsonNode]
    warning                       * : string
    execution_stats               * : ExecutionStats
    bookmark                      * : string
  WantedDocument                  * = object of RootObj
    # /{db}/_bulk_get
    id                            * : string
    rev                           * : string
    atts_since                    * : string
  WantedDocuments                 * = object
    # /{db}/_bulk_get
    docs                          * : seq[WantedDocument]
  NewDocument                     * = object of RootObj
    #TODO
    # POST /{db}/_bulk_docs
    id                            * : string
    rev                           * : string
    atts_since                    * : string
  BulkDocuments                   * = object
    # POST /{db}/_bulk_docs
    docs                          * : seq[NewDocument]
  DocRevisions                    * = object
    start                         * : int
    ids                           * : seq[string]
  DocOk                           * = object
    id                            * : string
    rev                           * : string
    value                         * : JsonNode
    revisions                     * : DocRevisions
  DocErr                          * = object
    id                            * : string
    rev                           * : string
    error                         * : string
    reason                        * : string
  DocumentEntity                  * = object
    case state* : DocumentEntityState:
      of ok:
        ok                        * : DocOk
      of error:
        error                     * : DocErr
  DocumentResult                  * = object
    # /{db}/_bulk_get
    id                            * : string
    docs                          * : seq[DocumentEntity]
  DocumentResults                 * = distinct seq[DocumentResult]

const
  name_db                         * {.strdefine.} = "/db"
  resp_ok                                       * = "200 - OK"
  resp_created                                  * = "201 - Created"
  resp_accepted                                 * = "202 - Accepted"
  resp_badRequest                               * = "400 - Bad Request"
  resp_unauthorized                             * = "401 - Unauthorized"
  resp_forbidden                                * = "403 - Forbidden"
  resp_notFound                                 * = "404 - Not Found"
  resp_methodNotAllowed                         * = "405 - Method Not Allowed"
  resp_notAcceptable                            * = "406 - Not Acceptable"
  resp_conflict                                 * = "409 - Conflict"
  resp_preconditionFailed                       * = "412 - Precondition Failed"
  resp_requestEntityTooLarge                    * = "413 - Request Entity Too Large"
  resp_unsupportedMediaType                     * = "415 - Unsupported Media Type"
  resp_requestedRangeNotSatisfiable             * = "416 - Requested Range Not Satisfiable"
  resp_expectationFailed                        * = "417 - Expectation Failed"
  resp_internalServerError                      * = "500 - Internal Server Error"
  req_root                                      * = "/"
  req_sep                                       * = req_root
  req_active_tasks                              * = "/_active_tasks"
  req_all_dbs                                   * = "/_all_dbs"
  req_dbs_info                                  * = "/_dbs_info"
  req_cluster_setup                             * = "/_cluster_setup"
  req_db_updates                                * = "/_db_updates"
  req_membership                                * = "/_membership"
  req_replicate                                 * = "/_replicate"
  req_scheduler_jobs                            * = "/_scheduler/jobs"
  req_scheduler_docs                            * = "/_scheduler/docs"
  req_node_local                                * = "/_node/_local"
  req_node_local_stats                          * = "/_node/_local/_stats"
  req_node_local_system                         * = "/_node/_local/_system"
  req_node_local_restart                        * = "/_node/_local/_restart"
  req_node_local_config                         * = "/_node/_local/_config"
  req_node_local_config_reload                  * = "/_node/_local/_config/_reload"
  req_search_analyze                            * = "/_search_analyze"
  req_utils                                     * = "/_utils"
  req_up                                        * = "/_up"
  req_uuids                                     * = "/_uuids"
  req_favicon_ico                               * = "/favicon.ico"
  req_reshard                                   * = "/_reshard"
  req_session                                   * = "/_session"
  req_db_all_docs                               * = "/_all_docs"
  req_db_design_docs                            * = "/_design_docs"
  req_db_bulk_get                               * = "/_bulk_get"
  req_db_bulk_docs                              * = "/_bulk_docs"
  req_db_find                                   * = "/_find"
  req_db_index                                  * = "/_index"
  req_db_explain                                * = "/_explain"
  req_db_shards                                 * = "/_shards"
  req_db_sync_shards                            * = "/_sync_shards"
  req_db_changes                                * = "/_changes"
  req_db_compact                                * = "/_compact"
  req_db_ensure_full_commit                     * = "/_ensure_full_commit"
  req_db_view_cleanup                           * = "/_view_cleanup"
  req_db_security                               * = "/_security"
  req_db_purge                                  * = "/_purge"
  req_db_purged_infos_limit                     * = "/_purged_infos_limit"
  req_db_missing_revs                           * = "/_missing_revs"
  req_db_revs_diff                              * = "/_revs_diff"
  req_db_revs_limit                             * = "/_revs_limit"