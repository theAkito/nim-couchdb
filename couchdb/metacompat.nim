#[
  MetaCompat: Compatability funcs for working with project-specific couchmeta constructions.
]#
import
  json,
  sequtils,
  tables,
  couchmeta

func toStrSeq*(jtext: JsonNode): seq[string] =
  jtext.getElems.mapIt(it.getStr)

func valToStrSeq*(table: Table[string, JsonNode]|OrderedTable[string, JsonNode]): OrderedTable[string, seq[string]] =
  for key, val in table.pairs: result[key] = val.getElems().mapIt(it.getStr)

func valToRevsDiffEntity*(table: Table[string, JsonNode]|OrderedTable[string, JsonNode]): OrderedTable[string, RevsDiffEntity] =
  for key, val in table.pairs:
    let valFields = val.getFields()
    result[key] = RevsDiffEntity(
      missing            : valFields.getOrDefault("missing").toStrSeq,
      possible_ancestors : valFields.getOrDefault("possible_ancestors").toStrSeq
    )