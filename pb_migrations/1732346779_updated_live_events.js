/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("3y8dv4ia0rhnbcr")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "chim0ze5",
    "name": "restaurant_id",
    "type": "relation",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "collectionId": "ysdcd79ob22g24y",
      "cascadeDelete": false,
      "minSelect": null,
      "maxSelect": 1,
      "displayFields": null
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("3y8dv4ia0rhnbcr")

  // remove
  collection.schema.removeField("chim0ze5")

  return dao.saveCollection(collection)
})
