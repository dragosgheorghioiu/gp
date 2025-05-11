const types = [
  "battle_axe",
  "dagger",
  "knuckleduster",
  "quarterstaff",
  "spear",
]
const damageRange = [100, 300];
const durabilityRange = [100, 300];
const rarityChances = [
  { level: "common", weight: 40 },
  { level: "uncommon", weight: 30 },
  { level: "rare", weight: 15 },
  { level: "epic", weight: 10 },
  { level: "legendary", weight: 5 },
];

const effects = [
  "poison",
  "lifesteal",
  "fire damage",
  "ice slow",
]

function getRandomRarity() {
  const totalWeight = rarityChances.reduce((sum, r) => sum + r.weight, 0);
  let random = Math.random() * totalWeight;

  for (const rarity of rarityChances) {
    if (random < rarity.weight) {
      return rarity.level;
    }
    random -= rarity.weight;
  }
}

export default function weaponGenerator() {
  const weaponClass = types[Math.floor(Math.random() * types.length)];
  const damage = Math.floor(Math.random() * (damageRange[1] - damageRange[0] + 1)) + damageRange[0];
  const durability = Math.floor(Math.random() * (durabilityRange[1] - durabilityRange[0] + 1)) + durabilityRange[0];
  const rarityLevel = getRandomRarity();

  let effectsCount = 0;
  switch (rarityLevel) {
    case "common":
      effectsCount = 0;
      break;
    case "uncommon":
      effectsCount = 1;
      break;
    case "rare":
      effectsCount = 2;
      break;
    case "epic":
      effectsCount = 3;
      break;
    case "legendary":
      effectsCount = 4;
      break;
  }

  const selectedEffects = [];
  while (selectedEffects.length < effectsCount) {
    const randomEffect = effects[Math.floor(Math.random() * effects.length)];
    if (!selectedEffects.includes(randomEffect)) {
      selectedEffects.push(randomEffect);
    }
  }

  return {
    class: weaponClass,
    damage,
    durability,
    rarity: rarityLevel,
    effects: selectedEffects,
  };
}

