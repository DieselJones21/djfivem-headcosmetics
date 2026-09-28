This resource does **not** stream the 3D models.

Keep your existing stream resources started. Every name in `shared/props.lua` must match a streamed model:

- `crown_props.ytyp` plus all `*_crown.ydr` files
- `n93_halos.ytyp` plus all `halo_*.ydr` files, including `halo_orange`
- `pelucias_plushie_shop.ytyp` plus all `*_plushie_shop.ydr` files
- alien / cow / duck `*_plushie` packs
- angel wings (`angelwings_*`), color wings (`bluewings`, `greenwings`, ...), and `*_aura` morpho wings
- shoulder pets (`shark_boi`, `babydragon_by_joao`, `*_toy`, and the rest)

Starting the same `.ydr` files from two resources at once will break the props. Leave this folder empty.
