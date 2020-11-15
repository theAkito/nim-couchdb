#[
  Meta: Global constants, etc.
]#
import
  json,
  tables,
  strtabs

type
  DocumentEntityState  {.used.} = enum
    ok, error
  CouchResponseHeaders {.used.} = object
    cache_control     : string
    content_length    : int
    eTag              : string
    transfer_encoding : string
  Selector             {.used.} = object
  NewIndex             {.used.} = object
    index             : JsonNode
    ddoc              : string
    name              : string
    ttype             : string
    partial_filter_se : JsonNode
    partitioned       : bool
  PurgedInfosLimit     {.used.} = distinct int
  RevsLimit            {.used.} = distinct int
  DocumentMiniSpec     {.used.} = distinct StringTableRef
  MissingRevs          {.used.} = distinct StringTableRef
  RevsDiff             {.used.} = object
    missing           : seq[string]
    possible_ancestors: seq[string]
  RevsDiffResponse     {.used.} = object
    revsDiffs         : Table[string, seq[RevsDiff]]
  PurgeResponse        {.used.} = object
    purge_seq         : string
    purged            : seq[DocumentMiniSpec]
  Users                {.used.} = object of RootObj
    names             : seq[string]
    roles             : seq[string]
  Admins               {.used.} = ref object of Users
  Members              {.used.} = ref object of Users
  NewIndexResult       {.used.} = object
    result            : string
    id                : string
    name              : string
  SimpleConfirmation   {.used.} = object
    ok                : bool
  DocChangesResponse   {.used.} = object
    last_seq          : string
    pending           : int
    results           : seq[JsonNode]
  DocChangesQuery      {.used.} = object
    doc_ids           : seq[string]
    conflicts         : bool
    descending        : bool
    feed              : string
    filter            : string
    heartbeat         : int
    include_docs      : bool
    attachments       : bool
    att_encoding_info : bool
    last_event_id     : int
    limit             : int
    since             : string
    style             : string
    timeout           : int
    view              : string
    seq_interval      : int
    reason            : seq[string]
    nodes             : seq[string]
  SyncShardsResponse   {.used.} = object
    ok                : bool
    error             : seq[string]
    reason            : seq[string]
    nodes             : seq[string]
  DocShardResponse     {.used.} = object
    rrange            : string
    nodes             : seq[string]
  DatabaseShards       {.used.} = object
    shards            : JsonNode
  ExplainIndexResult   {.used.} = object
    dbname            : string
    index             : JsonNode
    selector          : JsonNode
    opts              : JsonNode
    limit             : int
    skip              : int
    fields            : seq[string]
    rrange            : JsonNode
  UpdatedDocument      {.used.} = object
    ok                : bool
    id                : string
    rev               : string
  SearchedEntity       {.used.} = object
    selector          : JsonNode
    limit             : int
    skip              : int
    sort              : seq[string]
    fields            : seq[string]
    use_index         : seq[string]
    r                 : int
    bookmark          : string
    update            : bool
    stable            : bool
    execution_stats   : bool
  FoundDocuments       {.used.} = object
    docs              : seq[JsonNode]
    warning           : string
    execution_stats   : bool
    bookmark          : string
  WantedDocument       {.used.} = object of RootObj
    # /{db}/_bulk_get
    id                : string
    rev               : string
    atts_since        : string
  WantedDocuments      {.used.} = object
    # /{db}/_bulk_get
    docs              : seq[WantedDocument]
  DocRevisions         {.used.} = object
    start             : int
    ids               : seq[string]
  DocOk                {.used.} = object
    id                : string
    rev               : string
    value             : JsonNode
    revisions         : seq[DocRevisions]
  DocErr               {.used.} = object
    id                : string
    rev               : string
    error             : string
    reason            : string
  DocumentEntity       {.used.} = object
    case state: DocumentEntityState:
      of ok:
        ok            : DocOk
      of error:
        error         : DocErr
  DocumentResult       {.used.} = object
    # /{db}/_bulk_get
    id                : string
    docs              : seq[DocumentEntity]
  DocumentResults      {.used.} = distinct seq[DocumentResult]

const
  name_db                 {.strdefine, used.} = "/db"
  resp_ok                            {.used.} = "200 - OK"
  resp_created                       {.used.} = "201 - Created"
  resp_accepted                      {.used.} = "202 - Accepted"
  resp_badRequest                    {.used.} = "400 - Bad Request"
  resp_unauthorized                  {.used.} = "401 - Unauthorized"
  resp_forbidden                     {.used.} = "403 - Forbidden"
  resp_notFound                      {.used.} = "404 - Not Found"
  resp_methodNotAllowed              {.used.} = "405 - Method Not Allowed"
  resp_notAcceptable                 {.used.} = "406 - Not Acceptable"
  resp_conflict                      {.used.} = "409 - Conflict"
  resp_preconditionFailed            {.used.} = "412 - Precondition Failed"
  resp_requestEntityTooLarge         {.used.} = "413 - Request Entity Too Large"
  resp_unsupportedMediaType          {.used.} = "415 - Unsupported Media Type"
  resp_requestedRangeNotSatisfiable  {.used.} = "416 - Requested Range Not Satisfiable"
  resp_expectationFailed             {.used.} = "417 - Expectation Failed"
  resp_internalServerError           {.used.} = "500 - Internal Server Error"
  req_root                           {.used.} = "/"
  req_sep                            {.used.} = req_root
  req_active_tasks                   {.used.} = "/_active_tasks"
  req_all_dbs                        {.used.} = "/_all_dbs"
  req_dbs_info                       {.used.} = "/_dbs_info"
  req_cluster_setup                  {.used.} = "/_cluster_setup"
  req_db_updates                     {.used.} = "/_db_updates"
  req_membership                     {.used.} = "/_membership"
  req_replicate                      {.used.} = "/_replicate"
  req_scheduler_jobs                 {.used.} = "/_scheduler/jobs"
  req_scheduler_docs                 {.used.} = "/_scheduler/docs"
  req_node_local                     {.used.} = "/_node/_local"
  req_node_local_stats               {.used.} = "/_node/_local/_stats"
  req_node_local_system              {.used.} = "/_node/_local/_system"
  req_node_local_restart             {.used.} = "/_node/_local/_restart"
  req_node_local_config              {.used.} = "/_node/_local/_config"
  req_node_local_config_reload       {.used.} = "/_node/_local/_config/_reload"
  req_search_analyze                 {.used.} = "/_search_analyze"
  req_utils                          {.used.} = "/_utils"
  req_up                             {.used.} = "/_up"
  req_uuids                          {.used.} = "/_uuids"
  req_favicon_ico                    {.used.} = "/favicon.ico"
  req_reshard                        {.used.} = "/_reshard"
  req_session                        {.used.} = "/_session"
  req_db_all_docs                    {.used.} = "/_all_docs"
  req_db_design_docs                 {.used.} = "/_design_docs"
  req_db_bulk_get                    {.used.} = "/_bulk_get"
  req_db_bulk_docs                   {.used.} = "/_bulk_docs"
  req_db_find                        {.used.} = "/_find"
  req_db_index                       {.used.} = "/_index"
  req_db_explain                     {.used.} = "/_explain"
  req_db_shards                      {.used.} = "/_shards"
  req_db_sync_shards                 {.used.} = "/_sync_shards"
  req_db_changes                     {.used.} = "/_changes"
  req_db_compact                     {.used.} = "/_compact"
  req_db_ensure_full_commit          {.used.} = "/_ensure_full_commit"
  req_db_view_cleanup                {.used.} = "/_view_cleanup"
  req_db_security                    {.used.} = "/_security"
  req_db_purge                       {.used.} = "/_purge"
  req_db_purged_infos_limit          {.used.} = "/_purged_infos_limit"
  req_db_missing_revs                {.used.} = "/_missing_revs"
  req_db_revs_diff                   {.used.} = "/_revs_diff"
  req_db_revs_limit                  {.used.} = "/_revs_limit"