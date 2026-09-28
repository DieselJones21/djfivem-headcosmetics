# djfivem-headcosmetics

Wear crowns and halos on the head, wings on the back, shoulder pets on the left shoulder, and hug handheld plushies — from normal inventory items.

You do **not** need Renewed Weapon Carry. Keep the **cosmetics** stream resource started — this script only attaches those models when the inventory item is used.

## What it does

- Crowns and halos attach to `SKEL_Head` (bone `31086`) so they sit on hair and hats
- Wings attach to `SKEL_Spine3` (bone `24818`) on the upper back
- Shoulder pets attach to `SKEL_L_Clavicle` (bone `64729`) on the player's left shoulder
- Plushies hug against the chest (bone `24817`) with the `impexp_int-0` hold animation
- One item per category at a time (crown + halo + wings + shoulder pet + plushie + aura)
- Wings, shoulder pets, plushies, and auras hide in vehicles
- Use the item to put it on, use it again to take it off (item is not consumed)

Only the props listed in `shared/catalog.lua` can be equipped. Models are streamed from the `cosmetics` resource.

## Install

1. Keep the folder named `djfivem-headcosmetics` (ox_inventory export depends on this name).
2. Start your `cosmetics` stream resource (do not copy the `.ydr` files into this resource).
3. Add the inventory items:
   - **ox_inventory:** paste `install/ox_inventory_items.lua` into `ox_inventory/data/items.lua`
   - **qb-inventory:** paste `install/qb_items.lua` into `qb-core/shared/items.lua`
   - **ESX without ox:** run `install/esx_items.sql`
4. Copy every PNG from `install/images/` into your inventory images folder:
   - ox_inventory: `ox_inventory/web/images/`
   - qb-inventory: `qb-inventory/html/images/`
5. `ensure cosmetics` then `ensure djfivem-headcosmetics` after framework and inventory.

```
/giveitem [id] black_blue_crown 1
/giveitem [id] halo_gold 1
/giveitem [id] angelwings_blue 1
/giveitem [id] babydragon_by_joao 1
/giveitem [id] bear_01_plushie_shop 1
```

## Commands

| Command | What it does |
| --- | --- |
| Use the inventory item | Toggle that cosmetic |
| `/wearcosmetic bear_01_plushie_shop` | Same toggle (debug) |
| `/clearcosmetics` | Remove everything |
| `/adjustcosmetic angelwings_blue` | Live placement editor |

Editor keys: arrow keys move X/Y, Page Up/Down move Z, numpad 4/6/8/5/7/9 rotate, Alt = fine, Shift = coarse, Enter prints a config line to F8, Backspace cancels.

To move every wing or every shoulder pet at once, edit `Config.Presets` in `config.lua`.

## Frameworks

Auto-detects qb-core / qbx_core / ESX and ox_inventory / qb-inventory / qs-inventory / ESX items. Override `Config.Framework` or `Config.Inventory` in `config.lua` only if detection is wrong.
