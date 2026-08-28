# djfivem-headcosmetics

Wear crowns and halos on the player's head from a normal inventory item. The prop attaches to `SKEL_Head` (bone `31086`) so it sits on hair and hats instead of replacing a clothing slot.

You do **not** need Renewed Weapon Carry. Keep your existing crown and halo **stream resources** started — this script only attaches those models when the inventory item is used.

## Why the old script did not fully work

The two files you sent were:

- a `Config.Toys` table with models and head offsets
- a client toggle that attaches a prop when `n93_halos:useHalo` fires

There was no server file registering those names as usable items, so using an inventory item never called the attach code. This resource adds that, keeps your offsets, and syncs the prop to other players with statebags (local objects, so it still works under entity lockdown).

## Install

1. Keep the folder named `djfivem-headcosmetics` (ox_inventory export depends on this name).
2. Leave your crown/halo stream resources started (the ones with `crown_props.ytyp` and `n93_halos.ytyp`). Do not copy those files into this resource.
3. Add the inventory items:
   - **ox_inventory:** paste `install/ox_inventory_items.lua` into `ox_inventory/data/items.lua`
   - **qb-inventory:** paste `install/qb_items.lua` into `qb-core/shared/items.lua`
   - **ESX without ox:** run `install/esx_items.sql`
4. Copy every PNG from `install/images/` into your inventory images folder:
   - ox_inventory: `ox_inventory/web/images/`
   - qb-inventory: `qb-inventory/html/images/`
5. Add to `server.cfg` after your framework, inventory, and stream resources:

```
ensure your-crown-stream-resource
ensure your-halo-stream-resource
ensure djfivem-headcosmetics
```

6. Restart the server (or `ensure ox_inventory` then `ensure djfivem-headcosmetics` if you only added items).

Give yourself a test item:

```
/giveitem [id] black_blue_crown 1
/giveitem [id] halo_gold 1
```

Use the item in the inventory. Use it again to take it off. A crown and a halo can be worn together. Using a second crown replaces the first.

## Commands

| Command | What it does |
| --- | --- |
| Use the inventory item | Toggle that crown or halo |
| `/wearcosmetic black_blue_crown` | Same toggle (debug) |
| `/clearcosmetics` | Remove everything you are wearing |
| `/adjustcosmetic black_blue_crown` | Live placement editor |

Editor keys: arrow keys move X/Y, Page Up/Down move Z, numpad 4/6/8/5/7/9 rotate, Alt = fine, Shift = coarse, Enter prints a `Config.Toys` line to F8, Backspace cancels.

## Adding another cosmetic

1. Stream the new `.ydr` from your props resource (and include it in that resource's `.ytyp`).
2. Add a row to `Config.Toys` in `config.lua` (copy a crown or halo and change the name/model).
3. Add the matching inventory item and a PNG named `<item>.png`.

## Frameworks

Auto-detects qb-core / qbx_core / ESX and ox_inventory / qb-inventory / qs-inventory / ESX items. Override `Config.Framework` or `Config.Inventory` in `config.lua` only if detection is wrong.
