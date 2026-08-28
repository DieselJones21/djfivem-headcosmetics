# djfivem-headcosmetics

Wear crowns and halos on the player's head from a normal inventory item. The prop attaches to `SKEL_Head` (bone `31086`) so it sits on hair and hats instead of replacing a clothing slot.

You do **not** need Renewed Weapon Carry. That script is for holstered weapons. Turning crowns into fake weapons is a workaround. This resource uses the same attach method as the `n93_halos` client you already had, plus the missing inventory + sync pieces.

## Why the old script did not fully work

The two files you sent were:

- a `Config.Toys` table with models and head offsets
- a client toggle that attaches a prop when `n93_halos:useHalo` fires

There was no server file registering those names as usable items, so using an inventory item never called the attach code. This resource adds that, keeps your offsets, and syncs the prop to other players with statebags (local objects, so it still works under entity lockdown).

## Install

1. Keep the folder named `djfivem-headcosmetics` (ox_inventory export depends on this name).
2. Copy every `.ydr` and `.ytyp` listed in `stream/README.md` into `stream/`.
3. Add the inventory items:
   - **ox_inventory:** paste `install/ox_inventory_items.lua` into `ox_inventory/data/items.lua`
   - **qb-inventory:** paste `install/qb_items.lua` into `qb-core/shared/items.lua` and add `<item>.png` images
   - **ESX without ox:** run `install/esx_items.sql`
4. Add to `server.cfg` after your framework and inventory:

```
ensure djfivem-headcosmetics
```

5. Restart the server (or `ensure ox_inventory` then `ensure djfivem-headcosmetics` if you only added items).

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

1. Drop the `.ydr` into `stream/` and make sure the matching `.ytyp` includes it.
2. Add a row to `Config.Toys` in `config.lua` (copy a crown or halo and change the name/model).
3. Add the matching inventory item from the install snippets.

## Frameworks

Auto-detects qb-core / qbx_core / ESX and ox_inventory / qb-inventory / qs-inventory / ESX items. Override `Config.Framework` or `Config.Inventory` in `config.lua` only if detection is wrong.
