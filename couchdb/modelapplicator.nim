import
  couchmeta,
  metacompat,
  metainstantiator,
  json

func toJtext*(docs: WantedDocuments): string = $(%* docs)