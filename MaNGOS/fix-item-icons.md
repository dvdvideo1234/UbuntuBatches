## Custom item problem description 3.3.5a
 * You made an item
 * You added it to your database
 * You logged in and your item has a red question mark icon
 * You made a book that teaches a spell.
 * You added it to your database.
 * You logged in and your book is a wrist, belt, helmet etc.

## Why did this happen?

#### A server keeps Items in 3 locations:
 * Client ([Item.dbc][ref-itemdbc])
 * Server ([Item.dbc][ref-itemdbc])
 * Database ([item_template][ref-itempla])

#### You added the Item to 1 location:
 * Database ([item_template][ref-itempla])

#### You need to add the item to the remaining 2 locations:
 * Client ([Item.dbc][ref-itemdbc])
 * Server ([Item.dbc][ref-itemdbc])

## How do I get started?
 * We need that item from your Database
 * Open your Database Manager (SQL Workshop, HeidiSQL, etc)
 * Open up a new query tab.
 * Write a query to retrieve your item.

## What query should I use?
 * [Item.dbc][ref-itemdbc] has less columns than [Item_Template][ref-itempla]
 * we do not require all of the rows from Item_Template
 * We need to use a specific query to return the rows we require.

#### If you're looking for a single item and you know part of it's name:
```sql
SELECT entry,
       CLASS,
       subclass,
       SoundOverrideSubclass,
       Material,
       displayid,
       InventoryType,
       sheath
  FROM item_template
 WHERE NAME LIKE '%part_of_name%' LIMIT 0, 100;
```

#### If you have more than one item, and you know the entry ID range that you're using for your items (80000-100000):
```sql
SELECT entry,
       CLASS,
       subclass,
       SoundOverrideSubclass,
       Material,
       displayid,
       InventoryType,
       sheath
  FROM item_template
 WHERE entry BETWEEN 80000 AND 100000;
```

#### If you want to export range of items in `*.CSV`
```sql
SELECT entry,
       CLASS,
       subclass,
       unk0,
       material,
       displayid,
       inventorytype,
       sheath
  INTO OUTFILE 'cl_export_items.csv'
  FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  ESCAPED BY '\'
  LINES TERMINATED BY '\n'
  FROM item_template
 WHERE entry >= 100
   AND entry <= 500;
```

Either method should result in you retrieving the Item(s) you added.

## What do I do next?
 * Items should be returned.
 * press `Ctrl+A` to select them
 * in the bar above them you should see `Export/Import` if you're using SQL Workbench (or if you're using HeidiSQL you can just right click export)
 * click on the `export recordset to an external file` this will want to make a .csv file, name it `Item.csv`.
 * put it on your Desktop.

#### Retrieve Server Item.dbc (TrinityCore)
 * Go to your "Build\bin\RelWithDebInfo\dbc" Folder
 * Find Item.dbc
 * Create a copy of Item.dbc on your desktop.

#### You should have:
 * Item.csv on Desktop
 * Item.dbc on Desktop.

#### Update Server Item.dbc
 * Download "DBCutil"
 * Drag `Item.dbc` onto the `DBCUtil.exe`, this will make a new file on your desktop called `Item.dbc.csv`
 * delete the copy of `Item.dbc`.
 * Download `Notepad++`
 * Open `item.csv` in Notepad++
 * Open `item.dbc.csv` in Notepad++
 * Notice similarities.
 * Your items are not in `Item.dbc.csv`.
 * Copy `item.csv` rows into `item.dbc.csv`
 * The last item of the "item.dbc.csv" should end with a comma
 * press enter at the end of the document so there is one empty line.
 * Save and close `item.dbc.csv`.
 * you can now safely delete `item.csv`
 * Drag `item.dbc.csv` onto `DBCutil.exe` to get an `Item.dbc`
 * Make a backup of your old `Item.dbc`
 * Replace the old `Item.dbc`
 
#### Update Client Item.dbc
 * Download `Ladiks MPQ Editor`
 * Make new empty `MPQ`
 * In empty MPQ make folder called `DBFilesClient`
 * Drag `Item.dbc` into folder.
 * Name `MPQ` something like `patch-9.MPQ`

#### Finishing up
 * Start up your server
 * The issue should be fixed.

#### Test that it's fixed:
 * if you can right-click equip the item.

#### Notes for the future:
 * You should keep "Item.dbc.csv" in case you need to update it again.
 * Update the MPQ, don't add new ones.

## Not showing correct Icon:
 * make sure that you know the difference between an `EntryID` and a `DisplayID`.
 1. Retrieve from [`WoWhead`][ref-wowhead]
   * Example: Crystal Vial - Item - World of Warcraft
   * "3371" is the entryID.
   * To find the DisplayID, go into "item.dbc" file and search for "3371".
   * second large number on the same line is your displayID.
 2. Search for an item and find it's `displayID`.

[ref-itemdbc]: https://github.com/cmangos/issues/wiki/Item.dbc
[ref-itempla]: https://github.com/cmangos/issues/wiki/Item_template
[ref-wowhead]: https://www.wowhead.com/
