/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("ysdcd79ob22g24y")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "1u7np6qh",
    "name": "thumbnail",
    "type": "file",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "mimeTypes": [],
      "thumbs": [],
      "maxSelect": 1,
      "maxSize": 5242880,
      "protected": false
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("ysdcd79ob22g24y")

  // remove
  collection.schema.removeField("1u7np6qh")

  return dao.saveCollection(collection)
})
