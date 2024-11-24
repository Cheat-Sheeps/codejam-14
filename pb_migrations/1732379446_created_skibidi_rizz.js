/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const collection = new Collection({
    "id": "kqqyl6hnbt8shus",
    "created": "2024-11-23 16:30:46.066Z",
    "updated": "2024-11-23 16:30:46.066Z",
    "name": "skibidi_rizz",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "yzsabsex",
        "name": "dsfdsfdsf",
        "type": "text",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      }
    ],
    "indexes": [],
    "listRule": null,
    "viewRule": null,
    "createRule": null,
    "updateRule": null,
    "deleteRule": null,
    "options": {}
  });

  return Dao(db).saveCollection(collection);
}, (db) => {
  const dao = new Dao(db);
  const collection = dao.findCollectionByNameOrId("kqqyl6hnbt8shus");

  return dao.deleteCollection(collection);
})
