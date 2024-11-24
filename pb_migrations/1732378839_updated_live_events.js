/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("3y8dv4ia0rhnbcr")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "hsvla4ik",
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
  const collection = dao.findCollectionByNameOrId("3y8dv4ia0rhnbcr")

  // remove
  collection.schema.removeField("hsvla4ik")

  return dao.saveCollection(collection)
})
