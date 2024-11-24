/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("ysdcd79ob22g24y")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "h0bpcyer",
    "name": "city",
    "type": "text",
    "required": true,
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
  const collection = dao.findCollectionByNameOrId("ysdcd79ob22g24y")

  // remove
  collection.schema.removeField("h0bpcyer")

  return dao.saveCollection(collection)
})
