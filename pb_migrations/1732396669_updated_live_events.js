/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("3y8dv4ia0rhnbcr")

  collection.indexes = [
    "CREATE UNIQUE INDEX `idx_XaHeEB6` ON `live_events` (`title`)"
  ]

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("3y8dv4ia0rhnbcr")

  collection.indexes = [
    "CREATE UNIQUE INDEX `idx_XaHeEB6` ON `live_events` (\n  `title`,\n  `restaurant_id`\n)"
  ]

  return dao.saveCollection(collection)
})
