# Pokémon Rogue Extract - Trainer Class Mappings

**AI ASSISTANT DIRECTIVE (JULES):**
When generating random parties for dynamic trainers, you **MUST** adhere to the thematic rules and species pools outlined in this document. Do not assign Pokémon outside of a Trainer Class's designated theme.

**Progression Rule:** The pools below primarily list base-form or lower-tier Pokémon. When generating a party for deeper/harder floors, you are expected to programmatically evolve these base species based on the current floor/level.

---

## Early-Game / General Classes

### `YOUNGSTER`
* **Map Themes:** Grass, Cave
* **Description:** Early-route mammals, Normal, Flying, low-tier Bug types.
* **Approved Pool:** RATTATA, SENTRET, ZIGZAGOON, BIDOOF, PATRAT, BUNNELBY, YUNGOOS, SKWOVET, LECHONK, PIDGEY, STARLY, FLETCHLING, NIDORANmA, EKANS.

### `LASS`
* **Map Themes:** Grass
* **Description:** "Cute" Pokémon, Normal, Fairy, Grass.
* **Approved Pool:** JIGGLYPUFF, CLEFAIRY, MARILL, ODDISH, SKITTY, BUNEARY, MINCCINO, FLABEBE, FIDOUGH, TINKATINK, VULPIX, NIDORANfE, HOPPIP.

### `CAMPER` / `PICNICKER`
* **Map Themes:** Grass, Cave
* **Description:** Diverse early-to-mid route Pokémon, Grass, Water, Fire, Bug.
* **Approved Pool:** BULBASAUR, CHARMANDER, SQUIRTLE, MANKEY, POLIWAG, BELLSPROUT, PONYTA, MAREEP, MARILL, SHROOMISH, NUMEL, SEEDOT, LOTAD.

---

## Thematic / Type-Specific Classes

### `BUGCATCHER`
* **Map Themes:** Grass
* **Description:** Strictly Bug-types.
* **Approved Pool:** CATERPIE, WEEDLE, PARAS, VENONAT, PINSIR, SCYTHER, LEDYBA, SPINARAK, WURMPLE, SURSKIT, NINCADA, KRICKETOT, BURMY, COMBEE, SEWADDLE, VENIPEDE, DWEBBLE, KARRABLAST, JOLTIK, SHELMET, SCATTERBUG, GRUBBIN, CUTIEFLY, BLIPBUG, TAROUNTULA, NYMBLE.

### `HIKER`
* **Map Themes:** Cave
* **Description:** Rock, Ground, Fighting, Steel (Mountain dwellers).
* **Approved Pool:** GEODUDE, MACHOP, ONIX, DIGLETT, RHYHORN, NOSEPASS, ARON, NUMEL, ROGGENROLA, DRILBUR, TIMBURR, ROLYCOLY, SILICOBRA, NACLI, MUDBRAY.

### `BIRDKEEPER`
* **Map Themes:** Grass
* **Description:** Strictly Flying-types (specifically birds).
* **Approved Pool:** PIDGEY, SPEAROW, FARFETCHD, DODUO, HOOTHOOT, TAILLOW, SWABLU, STARLY, CHATOT, PIDOVE, RUFFLET, VULLABY, FLETCHLING, PIKIPEK, ROOKIDEE, WATTREL, FLAMIGO.

### `FISHERMAN`
* **Map Themes:** Water
* **Description:** Water-types (specifically fish).
* **Approved Pool:** MAGIKARP, GOLDEEN, TENTACOOL, SHELLDER, KRABBY, HORSEA, CHINCHOU, QWILFISH, REMORAID, CARVANHA, BARBOACH, CORPHISH, FEEBAS, FINNEON, BASCULIN, WISHIWASHI, ARROKUDA, FINIZEN.

### `SAILOR` / `SWIMMER_M` / `SWIMMER_F`
* **Map Themes:** Water
* **Description:** Broad Water-types.
* **Approved Pool:** POLIWAG, SEEL, STARYU, LAPRAS, MARILL, WOOPER, WINGULL, WAILMER, SPHEAL, BUIZEL, MANTYKE, FRILLISH, CLAUNCHER, WIMPOD, CHEWTLE, WIGLETT.

### `BLACKBELT`
* **Map Themes:** Cave
* **Description:** Strictly Fighting-types.
* **Approved Pool:** MANKEY, MACHOP, TYROGUE, MAKUHITA, MEDITITE, RIOLU, TIMBURR, THROH, SAWK, PANCHAM, HAWLUCHA, CRABRAWLER, CLOBBOPUS, PAWMI, FLAMIGO.

### `PSYCHIC_M` / `PSYCHIC_F`
* **Map Themes:** Graveyard/Ghost
* **Description:** Psychic and Ghost types.
* **Approved Pool:** ABRA, DROWZEE, MRMIME, NATU, ESPON, RALTS, SPOINK, CHIMECHO, BRONZOR, GOTHITA, SOLOSIS, ELGYEM, HATENNA, FLITTLE.

---

## Mid-to-Late Game Classes

### `POKEMANIAC`
* **Map Themes:** Cave
* **Description:** Rare, slow-leveling, or "Kaiju" (Monster egg group) Pokémon.
* **Approved Pool:** CHARMANDER, NIDORANmA, NIDORANfE, SLOWPOKE, CUBONE, RHYHORN, KANGASKHAN, LAPRAS, SNORLAX, LARVITAR, ARON, BAGON, GIBLE, AXEW, GOOMY, JANGMOO, FRIGIBAX.

### `SCIENTIST` / `SUPERNERD`
* **Map Themes:** Cave, Graveyard/Ghost
* **Description:** Electric, Poison, Steel, Artificial/Man-made Pokémon.
* **Approved Pool:** GRIMER, KOFFING, VOLTORB, MAGNEMITE, PORYGON, DITTO, ROTOM, TRUBBISH, KLINK, GOLETT, CHARJABUG, TOGEDEMARU, VAROOM, IRONJUGULIS.

### `TEAMROCKET_M` / `TEAMROCKET_F` / `BURGLAR` / `BIKER`
* **Map Themes:** Cave, Graveyard/Ghost
* **Description:** Poison, Dark, aggressive Normal/Fire types.
* **Approved Pool:** ZUBAT, KOFFING, GRIMER, RATTATA, MEOWTH, HOUNDOUR, MURKROW, POOCHYENA, CARVANHA, SKUNTANK, PURRLOIN, SCRAGGY, SANDILE, TRUBBISH, INKAY, SALANDIT, NICKIT, MASCHIFF.

### `BEAUTY`
* **Map Themes:** Water, Grass
* **Description:** Elegant, visually appealing Pokémon (Water, Grass, Ice, Normal, Fairy).
* **Approved Pool:** VULPIX, MEOWTH, GOLDEEN, LAPRAS, CHIKORITA, BELLOSSOM, MARILL, CORSOLA, ROSELIA, MILOTIC, CHERUBI, GLAMEOW, LILLIGANT, MINCCINO, FOMANTIS, TSARAREENA, FLABEBE, TOGEPI, HATENNA, CLEFAIRY.

### `COOLTRAINER_M` / `COOLTRAINER_F`
* **Map Themes:** Cave, Water, Grass, Graveyard/Ghost
* **Description:** Diverse, highly competitive, strong base-stat Pokémon. No specific type limit.
* **Approved Pool:** BULBASAUR, CHARMANDER, SQUIRTLE, EEVEE, GROWLITHE, ABRA, MACHOP, GASTLY, MAGIKARP, DRATINI, LARVITAR, BELDUM, GIBLE, DEINO, GOOMY, JANGMOO, DREEPY, FRIGIBAX.