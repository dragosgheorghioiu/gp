import characterGenerator from "./character_generator.js";
import weaponGenerator from "./weapon_generator.js";

document.addEventListener('DOMContentLoaded', () => {
  const button = document.getElementById('Generator');
  const weaponbutton = document.getElementById('WeaponGenerator');

  button.addEventListener('click', () => {
    const char = characterGenerator();
    const nameTag = document.getElementById('Name');
    const classTag = document.getElementById('Class');
    const healthTag = document.getElementById('Health');
    const damageTag = document.getElementById('Damage');
    const characterTraitTag = document.getElementById('CharacterTrait');
    const charClassImage = document.getElementById('ClassArt');
    nameTag.style.display = 'block'
    nameTag.innerText = char.name;
    classTag.innerText = char.class[0].toUpperCase() + char.class.slice(1);
    classTag.style.display = 'block'
    healthTag.innerText = 'Health: ' + char.health;
    healthTag.style.display = 'block'
    damageTag.innerText = 'Damage: ' + char.damage;
    damageTag.style.display = 'block'
    characterTraitTag.innerText = char.characterTrait;
    characterTraitTag.style.display = 'block'
    charClassImage.src = `./characters/${char.class}.webp`
    charClassImage.style.display = 'block'
  });

  weaponbutton.addEventListener('click', () => {
    const weapon = weaponGenerator();
    const type = document.getElementById('WeaponType');
    const art = document.getElementById('WeaponArt');
    const durability = document.getElementById('WeaponDurability');
    const damage = document.getElementById('WeaponDamage');
    const rarity = document.getElementById('WeaponRarity');
    const effects = document.getElementById('WeaponEffects');
    type.innerText = weapon.class.split("_").map(w => w[0].toUpperCase() + w.slice(1)).join(" ");
    type.style.display = 'block'
    art.src = `./weapons/${weapon.class}.png`
    art.style.display = 'block'
    durability.innerText = "Durability: " + weapon.durability
    durability.style.display = 'block'
    damage.innerText = "Damage: " + weapon.damage
    damage.style.display = 'block'
    rarity.innerText = weapon.rarity;
    rarity.style.display = 'block'
    switch (weapon.rarity) {
      case 'common':
        rarity.style.color = "#565656"; // grey
        break;
      case 'uncommon':
        rarity.style.color = "#2ecc71"; // green
        break;
      case 'rare':
        rarity.style.color = "#3498db"; // blue
        break;
      case 'epic':
        rarity.style.color = "#9b59b6"; // purple
        break;
      case 'legendary':
        rarity.style.color = "#f39c12"; // gold/orange
        break;
    }
    effects.innerText = weapon.effects;
    effects.style.display = 'block'
  });
});

