# djfivem-headcosmetics

Wear crowns, halos, wings, shoulder pets, a right-leg wrap, and hug plushies from normal inventory items.

You do **not** need Renewed Weapon Carry. Keep the stream resource that contains these models started — this script only attaches them when the inventory item is used.

## What it does

- Crowns and halos attach to `SKEL_Head` (bone `31086`) so they sit on hair and hats
- Wings and morpho auras use the tuned `yellowwings` pose on `SKEL_Spine3` (bone `24818`)
- Shoulder pets use the tuned `shark_boi` pose on that same bone
- Red Skelebuddy uses the tuned right-knee pose (bone `16335`)
- Plushies hug against the chest (bone `24817`) with the `impexp_int-0` hold animation
- One item per category at a time: crown, halo, wings, shoulder pet, leg wrap, and plushie can all be worn together
- Wings, shoulder pets, plushies, and the leg wrap hide in vehicles and while dead
- Use the item to put it on, use it again to take it off (item is not consumed)

Only the props listed in `shared/props.lua` can be equipped. The item name is the streamed model name.

## Install

1. Keep the folder named `djfivem-headcosmetics` (ox_inventory export depends on this name).
2. Start the resource that streams these models. Do not copy the `.ydr` files into this resource. If that resource is not named `cosmetics`, set `Config.StreamResource` in `config.lua` (or set it to `''` when several packs stream the models). Packs this list expects:
   - crowns: `crown_props.ytyp`
   - halos: `n93_halos.ytyp` (includes `halo_orange`)
   - shop plushies: `pelucias_plushie_shop.ytyp`
   - alien / cow / duck plush packs
   - angel wings, color wings, and morpho auras
   - shoulder pets and `skelebuddyred` (`shared/props.lua` is the full list)
3. Add the inventory items:
   - **ox_inventory:** paste `install/ox_inventory_items.lua` into `ox_inventory/data/items.lua`
   - **qb-inventory:** paste `install/qb_items.lua` into `qb-core/shared/items.lua`
   - **ESX without ox:** run `install/esx_items.sql`
4. Copy every PNG from `install/images/` into your inventory images folder:
   - ox_inventory: `ox_inventory/web/images/`
   - qb-inventory: `qb-inventory/html/images/`
5. `ensure` the stream resource, then `ensure djfivem-headcosmetics` after framework and inventory.

```
/giveitem [id] black_blue_crown 1
/giveitem [id] halo_gold 1
/giveitem [id] bluewings 1
/giveitem [id] shark_boi 1
/giveitem [id] skelebuddyred 1
/giveitem [id] bear_01_plushie_shop 1
```

## Commands

| Command | What it does |
| --- | --- |
| Use the inventory item | Toggle that cosmetic |
| `/wearcosmetic shark_boi` | Same toggle (debug) |
| `/clearcosmetics` | Remove everything |
| `/adjustcosmetic shark_boi` | Live placement editor |

Editor keys: arrow keys move X/Y, Page Up/Down move Z, numpad 4/6/8/5/7/9 rotate, Alt = fine, Shift = coarse, Enter prints a config line to F8, Backspace cancels.

Wing, aura, and shoulder poses are starting points. If a model sits off the body, use `/adjustcosmetic` and paste the F8 line over that entry in `shared/props.lua`.

## Frameworks

Auto-detects qb-core / qbx_core / ESX and ox_inventory / qb-inventory / qs-inventory / ESX items. Override `Config.Framework` or `Config.Inventory` in `config.lua` only if detection is wrong.
