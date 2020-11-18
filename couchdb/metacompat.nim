#[
  MetaCompat: Compatability funcs for working with project-specific meta constructions.
]#
include
  meta

func valToStrSeq*(table: Table[string, JsonNode]|OrderedTable[string, JsonNode]): OrderedTable[string, seq[string]] =
  for key, val in table.pairs: result[key] = val.getElems().mapIt(it.getStr)