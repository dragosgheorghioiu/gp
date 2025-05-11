const names = ["Aric", "Thalindra", "Borin", "Elyndra", "Drake", "Alara", "Faelan", "Morwen", "Galadriel", "Dorian", "Qyburn"];
const classes = ['cleric', 'mage', 'huntress', 'rogue', 'duelist', 'warrior'];
const healthRanges = [50, 150];
const damageRanges = [50, 150];
const characterTraits = ["Intelligent", "Cunning", "Absent-minded", "Insightful", "Superstitious", "Charismatic", "Blunt", "Charming", "Awkward", "Manipulative"];

export default function characterGenerator() {
  return {
    name: names[Math.floor(Math.random() * names.length)],
    class: classes[Math.floor(Math.random() * classes.length)],
    health: Math.floor(Math.random() * (healthRanges[1] - healthRanges[0] + 1)) + healthRanges[0],
    damage: Math.floor(Math.random() * (damageRanges[1] - damageRanges[0] + 1)) + damageRanges[0],
    characterTrait: characterTraits[Math.floor(Math.random() * characterTraits.length)],
  };
}

