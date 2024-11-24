/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("3y8dv4ia0rhnbcr")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "cinn45mx",
    "name": "description",
    "type": "text",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "min": null,
      "max": null,
      "pattern": ""
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("3y8dv4ia0rhnbcr")

  // remove
  collection.schema.removeField("cinn45mx")

  return dao.saveCollection(collection)
})
