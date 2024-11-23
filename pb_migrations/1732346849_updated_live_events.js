/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("3y8dv4ia0rhnbcr")

  collection.listRule = "restaurant_id = @request.auth.id"
  collection.viewRule = "restaurant_id = @request.auth.id"
  collection.createRule = "restaurant_id = @request.auth.id"
  collection.updateRule = "restaurant_id = @request.auth.id"
  collection.deleteRule = "restaurant_id = @request.auth.id"

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("3y8dv4ia0rhnbcr")

  collection.listRule = null
  collection.viewRule = null
  collection.createRule = null
  collection.updateRule = null
  collection.deleteRule = null

  return dao.saveCollection(collection)
})
