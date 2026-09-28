#!/usr/bin/env python3
"""Generate shared/catalog.lua and inventory install files from the locked prop list."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

PROPS = """
abelha_plushie_shop
alientoy
angelalien_plushie
angelduck_plushie
angelwings_black
angelwings_blue
angelwings_green
angelwings_grey
angelwings_orange
angelwings_pink
angelwings_purple
angelwings_red
angelwings_tan
angelwings_white
angelwings_yellow
armored_cat
autumndragon_toy
avocadotoy
babydragon_by_joao
babydragon2_by_joao
babydragon3_by_joao
babydragon4_by_joao
babydragon5_by_joao
babydragon6_by_joao
banana_01_plushie_shop
banditboa_toy
bear_01_plushie_shop
bear_02_plushie_shop
bear_03_plushie_shop
bear_04_plushie_shop
bear_05_plushie_shop
bear_06_plushie_shop
bear2_01_plushie_shop
bear3_01_plushie_shop
bear4_01_plushie_shop
bear5_01_plushie_shop
bear6_01_plushie_shop
bear7_01_plushie_shop
bear8_01_plushie_shop
bearballoontoy
black_blue_crown
black_cyan_crown
black_ghost
black_gold_crown
black_green_crown
black_pink_crown
black_purple_crown
black_red_crown
black_white_crown
black_yellow_crown
blackcattoy
blackrabbittoy
blackshibatoy
blossom
bluefoxtoy
bluemorpho_aura
bluemushroomtoy
bluewings
brownchickentoy
brownowltoy
brownrabbittoy
bubbles
bumblebeetoy
bunalien_plushie
bunny1_01_plushie_shop
bunny1_02_plushie_shop
bunny1_03_plushie_shop
bunny1_04_plushie_shop
bunny1_05_plushie_shop
bunny1_06_plushie_shop
bunny1_07_plushie_shop
bunny2_01_plushie_shop
bunny2_02_plushie_shop
bunny2_03_plushie_shop
bunny2_04_plushie_shop
bunny2_05_plushie_shop
bunny2_06_plushie_shop
bunny2_07_plushie_shop
bunny2_08_plushie_shop
bunny2_09_plushie_shop
bunny2_10_plushie_shop
bunny3_01_plushie_shop
bunny3_02_plushie_shop
bunny3_03_plushie_shop
bunny3_04_plushie_shop
bunny3_05_plushie_shop
bunny3_06_plushie_shop
bunny3_07_plushie_shop
bunny3_08_plushie_shop
bunny3_09_plushie_shop
bunny3_10_plushie_shop
bunny4_01_plushie_shop
bunny4_02_plushie_shop
bunny4_03_plushie_shop
bunny4_04_plushie_shop
bunny4_05_plushie_shop
bunny4_06_plushie_shop
bunny4_07_plushie_shop
bunny4_08_plushie_shop
buttercup
cactustoy
capivara_plushie_shop
cat_01_plushie_shop
cat_02_plushie_shop
cat_03_plushie_shop
cat_04_plushie_shop
cat_05_plushie_shop
cat_06_plushie_shop
chococow_plushie
clovercat_toy
coelho_plushie_shop
coelho2_plushie_shop
coraldragon_toy
cosmicalien_plushie
cuteghost_toy
dancingduck_toy
darkphoenix_toy
devilduck_plushie
dino
dino_student
dinossauro_plushie_shop
dog_01_plushie_shop
duck_01_plushie_shop
duck_02_plushie_shop
duck_03_plushie_shop
duck_04_plushie_shop
duck_05_plushie_shop
duck_06_plushie_shop
edgemonkey_toy
fiestadoggo_toy
firekitsune_toy
fox
foxwitch_01_plushie_shop
foxwitch_02_plushie_shop
foxwitch_03_plushie_shop
foxwitch_04_plushie_shop
foxwitch_05_plushie_shop
foxwitch_06_plushie_shop
foxwitch_07_plushie_shop
foxwitch_08_plushie_shop
foxwitch_09_plushie_shop
foxwitch_10_plushie_shop
foxwitch_11_plushie_shop
frog_01_plushie_shop
frog2_01_plushie_shop
frog2_02_plushie_shop
frog2_03_plushie_shop
frog2_04_plushie_shop
frog2_05_plushie_shop
frog2_06_plushie_shop
frog2_07_plushie_shop
frogtoy
galaxycow_plushie
gamerduck_plushie
gardenerduck_plushie
gato_01_plushie_shop
gato_02_plushie_shop
gato_03_plushie_shop
gato_04_plushie_shop
gato_05_plushie_shop
gato_06_plushie_shop
gato_07_plushie_shop
gato_08_plushie_shop
gerbiltoy
ghosttoy
glen_toy
gold_blue_crown
gold_cyan_crown
gold_green_crown
gold_pink_crown
gold_purple_crown
gold_red_crown
gold_white_crown
gothduck_plushie
graffitibear_toy
greenalien_plushie
greenfrogtoy
greenmorpho_aura
greenwings
halo_black
halo_blue
halo_gold
halo_green
halo_orange
halo_pink
halo_purple
halo_red
halo_white
heartbreakimp_toy
highlandcow_plushie
holidaybeartoy
holidaycockatieltoy
hollow_knight
icepup_toy
jacare_plushie_shop
jellycloud_toy
knight_cat
labtoy
lavaalien_plushie
lavendermorpho_aura
magicdovetoy
marsalien_plushie
matchacow_plushie
mickey_mouse
mintaxolotltoy
monk_01_plushie_shop
monkey_punk
monky
monochromemorpho_aura
mouse_01_plushie_shop
mouse_02_plushie_shop
mouse_03_plushie_shop
mouse_04_plushie_shop
mouse_05_plushie_shop
mouse_06_plushie_shop
mouse2_01_plushie_shop
mouse2_02_plushie_shop
mouse2_03_plushie_shop
mouse2_04_plushie_shop
mouse2_05_plushie_shop
mouse2_06_plushie_shop
mouse3_01_plushie_shop
mouse3_02_plushie_shop
mouse3_03_plushie_shop
mouse3_04_plushie_shop
mouse3_05_plushie_shop
mouse3_06_plushie_shop
mouse3_07_plushie_shop
mouse3_08_plushie_shop
mushroom_01_plushie_shop
mushroom_02_plushie_shop
mushroom_03_plushie_shop
mushroom_04_plushie_shop
mushroom_05_plushie_shop
mushroom_06_plushie_shop
mushroom_07_plushie_shop
noctibat_animation
octoalien_plushie
orangecattoy
orangewings
owltoy
panda_plushie_shop
periwinkleaxolotltoy
pig_angel
pinguimrosa_plushie_shop
pinkaxolotltoy
pinkfoxtoy
pinkfrogtoy
pinkkoalatoy
pinkmorpho_aura
pinkpandatoy
pinkrabbittoy
pinkwings
pit_01_plushie_shop
pit2_01_plushie_shop
pit3_01_plushie_shop
polvo_01_plushie_shop
polvo_02_plushie_shop
polvo_03_plushie_shop
polvo_04_plushie_shop
polvo_05_plushie_shop
polvo_06_plushie_shop
polvo_07_plushie_shop
polvo_08_plushie_shop
polvo_09_plushie_shop
purplefoxtoy
purplemushroomtoy
purplewings
questing_mouse
raccoontoy
rainbowaxolotltoy
rainbowtoy
raincow_plushie
raventoy
raveshibatoy
reapertoy
redfoxtoy
redmushroomtoy
redpandatoy
redwings
rinoceronte_plushie_shop
rinoceronte2_plushie_shop
rinoceronte3_plushie_shop
rinoceronte4_plushie_shop
rosemoth_toy
sagerabbittoy
sakuracow_plushie
sakurashibatoy
scarecrow_toy
shark_boi
shibatoy
shoulderguardianstoy
silver_blue_crown
silver_cyan_crown
silver_gold_crown
silver_green_crown
silver_pink_crown
silver_purple_crown
silver_red_crown
silver_yellow_crown
skelebuddyred
skeletonunicorntoy
sleepyduck_plushie
snowleopard_toy
snowmantoy
springbunny_toy
strawberrykit_toy
sunflowercow_plushie
sunflowerpanda_toy
tacocattoy
thugduck_plushie
turkey_toy
unicorn_01_plushie_shop
unicorntoy
ursinhocarinhoso_01_plushie_shop
ursinhocarinhoso_02_plushie_shop
ursinhocarinhoso_03_plushie_shop
ursinhocarinhoso_04_plushie_shop
ursinhocarinhoso_05_plushie_shop
ursinhocarinhoso_06_plushie_shop
ursinhocarinhoso_07_plushie_shop
ursinhocarinhoso_08_plushie_shop
ursinhocarinhoso_09_plushie_shop
vaca_plushie_shop
voidalien_plushie
voodoodoll_toy
white_ghost
whitecattoy
whitechickentoy
whiterabbittoy
whitewings
winterfoxtoy
yellowaxolotltoy
yellowwings
""".strip().splitlines()

WORD_MAP = {
    "abelha": "Bee",
    "axolotl": "Axolotl",
    "babydragon": "Baby Dragon",
    "banditboa": "Bandit Boa",
    "bearballoon": "Bear Balloon",
    "bunalien": "Bun Alien",
    "capivara": "Capybara",
    "chococow": "Choco Cow",
    "clovercat": "Clover Cat",
    "cockatiel": "Cockatiel",
    "coelho": "Rabbit",
    "coraldragon": "Coral Dragon",
    "cosmicalien": "Cosmic Alien",
    "cuteghost": "Cute Ghost",
    "dancingduck": "Dancing Duck",
    "darkphoenix": "Dark Phoenix",
    "devilduck": "Devil Duck",
    "dinossauro": "Dinosaur",
    "edgemonkey": "Edge Monkey",
    "fiestadoggo": "Fiesta Doggo",
    "firekitsune": "Fire Kitsune",
    "foxwitch": "Fox Witch",
    "galaxycow": "Galaxy Cow",
    "gamerduck": "Gamer Duck",
    "gardenerduck": "Gardener Duck",
    "gato": "Cat",
    "gothduck": "Goth Duck",
    "graffitibear": "Graffiti Bear",
    "greenalien": "Green Alien",
    "greenfrog": "Green Frog",
    "heartbreakimp": "Heartbreak Imp",
    "highlandcow": "Highland Cow",
    "holidaybear": "Holiday Bear",
    "holidaycockatiel": "Holiday Cockatiel",
    "icepup": "Ice Pup",
    "jacare": "Alligator",
    "jellycloud": "Jelly Cloud",
    "lavaalien": "Lava Alien",
    "lavendermorpho": "Lavender Morpho",
    "magicdove": "Magic Dove",
    "marsalien": "Mars Alien",
    "matchacow": "Matcha Cow",
    "mickey": "Mickey",
    "mintaxolotl": "Mint Axolotl",
    "monochrome": "Monochrome",
    "monochromemorpho": "Monochrome Morpho",
    "monk": "Monkey",
    "noctibat": "Noctibat",
    "octoalien": "Octo Alien",
    "orangecat": "Orange Cat",
    "periwinkleaxolotl": "Periwinkle Axolotl",
    "pinguimrosa": "Pink Penguin",
    "pinkaxolotl": "Pink Axolotl",
    "pinkfox": "Pink Fox",
    "pinkfrog": "Pink Frog",
    "pinkkoala": "Pink Koala",
    "pinkpanda": "Pink Panda",
    "pinkrabbit": "Pink Rabbit",
    "pit": "Pitbull",
    "polvo": "Octopus",
    "purplefox": "Purple Fox",
    "purplemushroom": "Purple Mushroom",
    "questing": "Questing",
    "rainbowaxolotl": "Rainbow Axolotl",
    "raincow": "Rain Cow",
    "raveshiba": "Rave Shiba",
    "redfox": "Red Fox",
    "redmushroom": "Red Mushroom",
    "redpanda": "Red Panda",
    "rinoceronte": "Rhino",
    "rosemoth": "Rose Moth",
    "sagerabbit": "Sage Rabbit",
    "sakuracow": "Sakura Cow",
    "sakurashiba": "Sakura Shiba",
    "shark": "Shark",
    "shoulderguardians": "Shoulder Guardians",
    "skelebuddy": "Skele Buddy",
    "skelebuddyred": "Skele Buddy Red",
    "skeletonunicorn": "Skeleton Unicorn",
    "sleepyduck": "Sleepy Duck",
    "snowleopard": "Snow Leopard",
    "snowman": "Snowman",
    "springbunny": "Spring Bunny",
    "strawberrykit": "Strawberry Kit",
    "sunflowercow": "Sunflower Cow",
    "sunflowerpanda": "Sunflower Panda",
    "tacocat": "Taco Cat",
    "thugduck": "Thug Duck",
    "ursinhocarinhoso": "Care Bear",
    "vaca": "Cow",
    "voidalien": "Void Alien",
    "voodoodoll": "Voodoo Doll",
    "whitecat": "White Cat",
    "whitechicken": "White Chicken",
    "whiterabbit": "White Rabbit",
    "winterfox": "Winter Fox",
    "yellowaxolotl": "Yellow Axolotl",
    "angelalien": "Angel Alien",
    "angelduck": "Angel Duck",
    "angelwings": "Angel Wings",
    "autumndragon": "Autumn Dragon",
    "blackcat": "Black Cat",
    "blackrabbit": "Black Rabbit",
    "blackshiba": "Black Shiba",
    "bluefox": "Blue Fox",
    "bluemorpho": "Blue Morpho",
    "bluemushroom": "Blue Mushroom",
    "brownchicken": "Brown Chicken",
    "brownowl": "Brown Owl",
    "brownrabbit": "Brown Rabbit",
    "greenmorpho": "Green Morpho",
    "pinkmorpho": "Pink Morpho",
    "hollow": "Hollow",
}

AURA_NAMES = {"blossom", "buttercup", "bubbles"}


def classify(name: str) -> str:
    if "wings" in name:
        return "wings"
    if name.startswith("halo_"):
        return "halo"
    if name.endswith("_crown"):
        return "crown"
    if "plushie" in name:
        return "plushie"
    if name.endswith("_aura") or name in AURA_NAMES:
        return "aura"
    return "shoulder"


def title_case(text: str) -> str:
    parts = []
    for word in text.split():
        if word.isdigit():
            parts.append(word)
        else:
            parts.append(word[:1].upper() + word[1:])
    return " ".join(parts)


def humanize(name: str, category: str) -> str:
    raw = name
    n = name
    n = n.replace("_plushie_shop", "")
    n = n.replace("_plushie", "")
    n = n.replace("_by_joao", "")
    n = n.replace("_animation", "")
    n = n.replace("_aura", "")
    if n.endswith("_toy"):
        n = n[:-4]
    elif n.endswith("toy"):
        n = n[:-3]
    if n.endswith("wings") and n != "wings" and not n.startswith("angelwings"):
        n = n[:-5] + "_wings"

    tokens = [t for t in n.split("_") if t]
    out = []
    for token in tokens:
        base, num = token, ""
        while base and base[-1].isdigit():
            num = base[-1] + num
            base = base[:-1]
        if base in WORD_MAP:
            out.append(WORD_MAP[base])
        elif base:
            out.append(base)
        if num:
            out.append(num)

    label = title_case(" ".join(out)).replace("  ", " ").strip()
    if category == "plushie" and not label.endswith("Plushie"):
        label = f"{label} Plushie"
    elif category == "halo" and not label.startswith("Halo"):
        label = f"Halo {label}"
    elif category == "wings" and "Wings" not in label:
        label = f"{label} Wings"
    elif category == "shoulder" and label in {"Lab", "Rainbow", "Ghost", "Frog", "Owl", "Reaper", "Shiba", "Turkey", "Cactus", "Avocado", "Alien"}:
        label = f"{label} Toy"
    elif category == "aura" and "Aura" not in label and raw.endswith("_aura"):
        label = f"{label} Aura"
    elif category == "crown" and not label.endswith("Crown"):
        label = f"{label} Crown"
    return label


def lua_list(names: list[str], indent: str = "    ") -> str:
    lines = ["{"]
    row = []
    for name in names:
        row.append(f"'{name}'")
        if len(row) == 3:
            lines.append(f"{indent}    {', '.join(row)},")
            row = []
    if row:
        lines.append(f"{indent}    {', '.join(row)},")
    lines.append(f"{indent}}}")
    return "\n".join(lines)


def write_catalog(grouped: dict[str, list[str]], labels: dict[str, str]) -> None:
    sections = []
    for category in ("crown", "halo", "wings", "shoulder", "plushie", "aura"):
        names = grouped[category]
        sections.append(
            f"register('{category}', {lua_list(names)})"
        )

    override_lines = [
        "    -- Hug pose tweaks carried over from the original plushie offsets",
        "    banana_01_plushie_shop = { z = 0.00, xR = -180.0 },",
        "    rinoceronte_plushie_shop = { z = 0.00, xR = -180.0 },",
    ]

    content = f"""-- Locked catalog. Models are streamed by the `cosmetics` resource.
-- Generated by tools/generate_catalog.py — edit that list, then regenerate.

Config.Toys = Config.Toys or {{}}

local function copyPreset(preset)
    local data = {{}}
    for key, value in pairs(preset) do
        data[key] = value
    end
    return data
end

local LABELS = {{
"""
    for name in PROPS:
        content += f"    ['{name}'] = '{labels[name]}',\n"

    content += f"""}}

local OVERRIDES = {{
{chr(10).join(override_lines)}
}}

local function register(category, names)
    local preset = Config.Presets[category]
    if not preset then
        error(('[djfivem-headcosmetics] missing Config.Presets.%s'):format(category))
    end
    for i = 1, #names do
        local name = names[i]
        local data = copyPreset(preset)
        data.model = name
        data.category = category
        data.label = LABELS[name] or name
        local extra = OVERRIDES[name]
        if extra then
            for key, value in pairs(extra) do
                data[key] = value
            end
        end
        Config.Toys[name] = data
    end
end

{chr(10).join(sections)}
"""
    (ROOT / "shared" / "catalog.lua").write_text(content)


def write_ox(labels: dict[str, str]) -> None:
    chunks = [
        "-- Paste these entries into ox_inventory/data/items.lua",
        "-- consume = 0 keeps the item when used (toggle wear / remove).",
        "-- Generated by tools/generate_catalog.py",
        "",
        "--[[",
    ]
    for name in PROPS:
        chunks.append(f"""    ['{name}'] = {{
        label = '{labels[name]}',
        weight = 50,
        stack = false,
        close = true,
        consume = 0,
        client = {{
            export = 'djfivem-headcosmetics.useCosmetic',
        }},
    }},""")
    chunks.append("]]")
    chunks.append("")
    (ROOT / "install" / "ox_inventory_items.lua").write_text("\n".join(chunks))


def write_qb(labels: dict[str, str]) -> None:
    chunks = [
        "-- Paste these entries into qb-core/shared/items.lua",
        "-- Add matching images named <item>.png to your inventory html/images folder.",
        "-- Generated by tools/generate_catalog.py",
        "",
        "--[[",
    ]
    for name in PROPS:
        chunks.append(
            f"    {name} = {{ name = '{name}', label = '{labels[name]}', weight = 50, type = 'item', image = '{name}.png', unique = true, useable = true, shouldClose = true, description = 'Wearable cosmetic' }},"
        )
    chunks.append("]]")
    chunks.append("")
    (ROOT / "install" / "qb_items.lua").write_text("\n".join(chunks))


def write_esx(labels: dict[str, str]) -> None:
    lines = [
        "-- ESX items (oxmysql example). Run once, or add through your item SQL workflow.",
        "-- If you use ox_inventory on ESX, use ox_inventory_items.lua instead.",
        "-- Generated by tools/generate_catalog.py",
        "",
        "INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES",
    ]
    last = len(PROPS) - 1
    for i, name in enumerate(PROPS):
        comma = "," if i < last else ";"
        lines.append(f"    ('{name}', '{labels[name]}', 1, 0, 1){comma}")
    lines.append("")
    (ROOT / "install" / "esx_items.sql").write_text("\n".join(lines))


def main() -> None:
    seen = set()
    grouped = {key: [] for key in ("crown", "halo", "wings", "shoulder", "plushie", "aura")}
    labels = {}
    for name in PROPS:
        if name in seen:
            raise SystemExit(f"duplicate prop: {name}")
        seen.add(name)
        category = classify(name)
        grouped[category].append(name)
        labels[name] = humanize(name, category)

    write_catalog(grouped, labels)
    write_ox(labels)
    write_qb(labels)
    write_esx(labels)

    print("props", len(PROPS))
    for category, names in grouped.items():
        print(f"  {category:9} {len(names)}")


if __name__ == "__main__":
    main()
