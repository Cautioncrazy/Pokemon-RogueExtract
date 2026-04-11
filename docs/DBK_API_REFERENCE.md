# Deluxe Battle Kit for v21.1

Page 1:

<div align="left" data-full-width="false"><figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FepVcQ7YjHFd0arAWqYql%2Fdemo15.gif?alt=media&#x26;token=605b68dd-f9f0-4c06-b397-7bb7e8e3a5b7" alt=""><figcaption></figcaption></figure></div>

This documentation outlines how to fully utilize the features and mechanics included in the the plugin "Deluxe Battle Kit" for Pokemon Essentials v21. This plugin expands what is capable of the Pokemon battle system to give developers much more control in how they may design their battles.

[**Eevee Expo Link**](https://eeveeexpo.com/resources/1470/)

[**PokeCommunity Link**](https://www.pokecommunity.com/threads/deluxe-battle-kit-v21-1.525780/#post-10792141)

[**Download Link**](https://www.mediafire.com/file/j4fbhvem8fsmvuo/Deluxe_Battle_Kit.zip/file)

***

**Tutorial Table of Contents**

1. <mark style="background-color:blue;">**Deluxe Animations**</mark>\
   Showcases new animations introduced by this plugin for Mega Evolution, Primal Reversion and more.
2. <mark style="background-color:green;">**Deluxe Battle Rules**</mark>\
   Details all of the new Battle Rules added by this plugin, explaining what they do and how to set them.
3. <mark style="background-color:orange;">**Wild Boss Attributes**</mark>\
   Details two new attributes added to make wild Pokemon more challenging by giving them expanded HP pools and unique immunities.
4. <mark style="background-color:purple;">**Mid-Battle Scripting**</mark>\
   A comprehensive guide for implementing mid-battle scripts for total battle customization.
5. <mark style="background-color:red;">**Example Battles**</mark>\
   Showcases some example battle setups that utilize various features of this plugin to show off its potential.
6. <mark style="background-color:yellow;">**Miscellaneous Utilities**</mark>\
   A section for detailing out some of the smaller and more niche features introduced by this plugin which don't quite fit in any of the above sections.&#x20;
7. <mark style="background-color:yellow;">**Add-On Tutorials**</mark>\
   Detailed guides on a variety of plugins that function as add-ons to the Deluxe Battle Kit.

***

**General Plugin Utilities**\
In the Settings file of the plugin, you may edit the following settings to customize certain features.

* `SHORTEN_MOVES`\
  When this is set to true, moves that have really long names (more than 16 characters) will be shortened with ellipses so that they may properly fit the battle UI. Set this to false to disable this feature.
* `HIDE_DATABOXES_DURING_MOVES`\
  When this is set to true, all battler databoxes will be hidden during a Pokemon's move animation in battle, as they are in Gen 5+. Set this to false to disable this feature.
* `PLAY_LOW_HP_MUSIC`\
  When this is set to true, the battle music will change whenever the HP of the player's Pokemon is critically low (<= 25% max HP). Set this to false to disable this feature.
* `SHOW_MEGA_ANIM`\
  When this is set to true, a new animation added by this plugin will play when Mega Evolution is triggered. If you don't want to use this animation, you may set this to false.
* `SHOW_PRIMAL_ANIM`\
  When this is set to true, a new animation added by this plugin will play when Primal Reversion is triggered. If you don't want to use this animation, you may set this to false.
* `SHADOW_PATTERN_MOVEMENT`\
  This controls how the pattern used to overlay sprites for Shadow Pokemon will animate. More details on this can be found in the "Animation: Shadow Pokemon" section.

***

**Plugin Add-Ons**\
The following plugins act as add-ons to the Deluxe Battle Kit, expanding its suite of features and capabilities. Consider installing these as well if they appeal to you.

* [**Enhanced Battle UI**](https://eeveeexpo.com/resources/1472/)
* [**SOS Battles**](https://eeveeexpo.com/resources/1473/)
* [**Raid Battles**](https://eeveeexpo.com/resources/1780/)
* [**Z-Power**](https://eeveeexpo.com/resources/1478/)
* [**Dynamax**](https://eeveeexpo.com/resources/1495/)
* [**Terastallization**](https://eeveeexpo.com/resources/1476/)
* [**Improved Item AI**](https://eeveeexpo.com/resources/1537/)
* [**Wonder Launcher**](https://eeveeexpo.com/resources/1538/)
* [**Animated Pokemon System**](https://eeveeexpo.com/resources/1544/)
* [**Animated Trainer Intros**](https://eeveeexpo.com/resources/1667/)

***

**Plugin Compatibility**\
The following third party plugins have been tested and are 100% compatible with the Deluxe Battle Kit, and are highly recommended:

* [**Generation 9 Pack**](https://eeveeexpo.com/resources/1101/)
* [**Modular UI Scenes**](https://eeveeexpo.com/resources/1325/)
* [**Enhanced Pokemon UI**](https://eeveeexpo.com/resources/1387/)
* [**Pokedex Data Page**](https://eeveeexpo.com/resources/1380/)
* [**Improved Mementos**](https://eeveeexpo.com/resources/1381/)
* [**Improved Field Skills**](https://eeveeexpo.com/resources/1401/)

...many more plugins may also be compatible, but this is a small sample of some that I can personally attest to being compatible and would recommend using along side this kit.

Page 2:

# Deluxe Animations

The Deluxe Battle Kit includes a host of new animation utilities which are utilized by itself and supported plugins to create a variety of new battle animations. In the following subpages in this section, I will go over each new animation included by this plugin by default. Animations for any add-on plugins will be detailed in their own sections.

Page 3: 

# Animation: Databoxes

The battle scene in Essentials mirrors generation 3 by default. In these older generations, the databoxes for each battler remains on screen throughout the entire battle, even during move animations. Here's an example of what this looks like normally:

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FJso35piLnqXwvYQa1Sru%2Fboxes2.gif?alt=media&#x26;token=90fa8028-acaa-4845-8cbb-71f902bac7f3" alt="" width="376"><figcaption><p>Databoxes in vanilla Essentials.</p></figcaption></figure>

However, in newer generations starting with Gen 5, these databoxes would be hidden during move animations, allowing you to appreciate the visuals of the move animations better. This plugin allows you to implement this same mechanic with the `HIDE_DATABOXES_DURING_MOVES` setting, which is set to `true` by default. Here's the same animation as seen above, but with this feature enabled:

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FcUUlnsxboAF1DgQSv6Pj%2Fboxes.gif?alt=media&#x26;token=9bd467bc-0bb1-4e01-b3de-63b0eafe4221" alt="" width="376"><figcaption><p>Hidden databoxes during move animations.</p></figcaption></figure>

When enabled, all databoxes on screen will be hidden for the duration of any move animations in battle, and then reappear once the animations are complete. If you wish to disable this feature, then you may set the `HIDE_DATABOXES_DURING_MOVES` plugin setting to `false`.

Page 4:

# Animation: Item Usage

In the newer games in the series, there is a simple animation that plays when using an item during battle directly on an active battler. However, since Essentials is based around the Gen 3 games, it doesn't naturally include an animation like this.

This plugin introduces a new animation to address this; allowing items used on battlers to show a simple animation to indicate an item is being used. Here's an example of what this looks like:

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FGaAiwbitogBavyyG5nwK%2Fitem.gif?alt=media&#x26;token=71a753eb-7a58-4360-be87-3596ca5e6d4e" alt="" width="382"><figcaption><p>Item animation on battlers.</p></figcaption></figure>

You'll notice that the battle text describing item usage has also been updated so that it will now be more specific about which Pokemon the trainer is using the item on. This is also true for items used on party Pokemon and not active battlers.

It's also worth noting that while items used in battle that are used on a Pokemon in the party will not show any animation, there will now be a sound effect that plays to indicate an item is being used. Items used in battle that don't target any particular battler or Pokemon, such as the Guard Spec. or the Poke Flute, will neither play an animation or a sound effect.

Page 5: 

# Animation: Fleeing Pokemon

Typically, when a wild Pokemon "flees" from battle, such as with roamers or Safari Pokemon, there isn't any animation associated with this. The battle simply ends, and it's just implied that the Pokemon ran away.

This plugin introduces a new animation which is specifically used to animate these fleeing Pokemon. It's a simple animation, but it adds some more visual flair than a static still image that simply fades to black.

Here are some examples of this animation taking place:

![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FxVQcuyRgqyfT8TjqcP14%2Fdemo17.gif?alt=media\&token=b4bc6494-7a55-4bc8-9e2b-12ef0dfb483c)    <img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F2JPOuMuyI6a8xw2sSq0j%2Fdemo16.gif?alt=media&#x26;token=373432b1-72f3-49da-9f0a-be62e70081a9" alt="" data-size="original">

Note, however, that there are other instances where this animation may be seen. This kit specifically introduces several new ways for wild Pokemon to flee from battle, most of which will be covered in detail elsewhere in this tutorial.

***

Here's an example of a wild Pokemon fleeing as part of the <mark style="background-color:green;">"raidStyleCapture"</mark> Battle Rule. More on this can be learned in the "Deluxe Battle Rules" section.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fz4DYSpsfC3qlxLkNGXao%2Fdemo18.gif?alt=media&#x26;token=56a85cf4-bbdc-4cb6-a80d-842dd4f94cb0" alt="" width="381"><figcaption><p>A wild Articuno fleeing after a failed Raid-style capture.</p></figcaption></figure>

***

Here's an example of a wild Pokemon fleeing as part of a mid-battle script by utilizing the <mark style="background-color:blue;">"wildFlee"</mark> Command Key. More on this can be learned in the "Mid-Battle Scripting" section.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FwLHIXu7wmlSEF2y9reoa%2Fdemo19.gif?alt=media&#x26;token=e78c3df6-a74b-431e-8a82-f58ee089e65f" alt="" width="381"><figcaption><p>A wild Latios fleeing as part of a mid-battle script.</p></figcaption></figure>

Page 6:

# Animation: Mega Evolution

Though Mega Evolution is incorporated into Essentials by default, it doesn't contain any built-in animations related to the mechanic. To address this, the Deluxe Battle Kit includes its own set of animations for Mega Evolution. The animation style used for Mega Evolution acts as the basis that all other animations are built on for mechanics introduced by supported plugins such as Z-Moves, Dynamax, and Terastallization.

There's a bit to explain about these animations and how they work, so I'll provide a break down of everything in this section.

{% hint style="info" %}
Note: If you already have an existing Mega Evolution animation which is stored as a Common animation named `"MegaEvolution"`, that animation will take priority over the animation added by this plugin. This means that there's no risk of your animation being overwritten or ignored, nor do you need to change anything to make this plugin compatible.
{% endhint %}

***

<mark style="background-color:orange;">**Trainer Mega Evolution**</mark>

Mega Evolution typically requires a trainer with a Mega Ring and a Pokemon with a compatible Mega Stone. If so, the option to Mega Evolve that Pokemon will appear in battle. When triggered, the Mega Evolution animation will play.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FTU4jyF70ylW4pNwovaWI%2Fdemo21.gif?alt=media&#x26;token=7c525947-2eb2-47d5-9007-a6c9f025f9fc" alt="" width="381"><figcaption><p>Mega Evolution on the player's side.</p></figcaption></figure>

There will be slight differences in the animation based on which side of the field the Mega Evolved Pokemon is on. Pokemon on the player's side of the field will face right, and their trainer will slide in from off screen on the left. If the Pokemon is on the opponent's side of the field, they will face left and their trainer will slide in from off screen on the right. This helps distinguish if the Mega Evolved Pokemon is friend or foe during the animation.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FLaN5I7AO9apOxqWNAWXp%2Fdemo20.gif?alt=media&#x26;token=30de435a-e190-4bc8-b399-d9ec532e9fa4" alt="" width="381"><figcaption><p>Mega Evolution on the opponent's side.</p></figcaption></figure>

Mega Animations will always display the trainer's Mega Ring above the trainer and the Pokemon's held Mega Stone above the Pokemon during the animation. The trainer's item may not always be the same, however. The Mega Ring is the default item used, but it's possible to give trainers unique items that trigger Mega Evolution such as Diantha's Mega Charm in XY, or Maxie's Mega Glasses in Omega Ruby. If you create unique Mega items such as these for a trainer to utilize along with the necessary sprites, then the sprite for that unique item will appear in this animation instead of the default Mega Ring.

If the Pokemon Mega Evolves without a held Mega Stone, such as Rayquaza, then no item will appear above the Pokemon during the animation.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FHXiJAaX6TlhUhmGoN7bN%2Fdemo23.gif?alt=media&#x26;token=802e52e3-249b-4fbb-a35e-50c894759869" alt="" width="381"><figcaption><p>Mega Evolution animation without a Mega Stone.</p></figcaption></figure>

***

<mark style="background-color:orange;">**Wild Mega Evolution**</mark>

Typically, wild Pokemon are incapable of Mega Evolving, even if they are holding the appropriate Mega Stone or have the appropriate Mega move. This is because a trainer with a corresponding Mega Ring is required.

However, this plugin includes a feature that allows wild Pokemon to Mega Evolve on their own without a trainer, by utilizing the <mark style="background-color:green;">"wildMegaEvolution"</mark> Battle Rule (more details on this can be found in the "Deluxe Battle Rules" section of this tutorial). This bypasses the Mega Ring requirement, allowing the wild Pokemon to Mega Evolve as long as they are holding the required Mega Stone or have the necessary Mega move. If so, the wild Pokemon will immediately Mega Evolve when encountered.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F4UYtDQ0UbI9oQ9xpuJAa%2Fdemo22.gif?alt=media&#x26;token=7b7bf27d-cb5f-4dfa-845b-49cfd570e4f2" alt="" width="381"><figcaption><p>Wild Mega Evolution animation.</p></figcaption></figure>

The animation for wild Mega Evolution is mostly the same. The only obvious difference is that no trainer slides on screen during the animation, since no trainer exists. The text message which indicates the Pokemon is about to Mega Evolve is also changed to remove all mention of a trainer or Mega Ring.

***

<mark style="background-color:orange;">**Animation Utilities**</mark>

<mark style="background-color:yellow;">**Skipping Animations**</mark>

You may have noticed in the examples above that during the Mega Evolution animation, a button prompt on the bottom left-hand corner of the screen appears. This "skip" button indicates that you can cut the animation short by pressing the `ACTION` key. Pressing it will immediately end the animation, allowing you to get right back to the battle if you grow tired of sitting through these animations.

<mark style="background-color:yellow;">**Turning Off Animations**</mark>

If you want to turn these animations off entirely, there are two ways to accomplish this. First, you may do so by turning off battle animations completely in the Options menu.&#x20;

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FwOMVVwf7z58G4TSKSGM6%2F%5B2024-01-12%5D%2011_58_20.948.png?alt=media&#x26;token=36cd6063-28d1-4886-9f6e-49bbf7642b8f" alt="" width="384"><figcaption><p>Battle animations in the Options menu.</p></figcaption></figure>

If so, this animation will also be turned off. Instead, it'll be replaced with a generic "quick-change" animation which happens instantaneously.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F0oyTsuVh8xg6uFbnUdpl%2Fdemo24.gif?alt=media&#x26;token=7e5c8fba-af50-451a-913b-491ee4b32520" alt="" width="381"><figcaption><p>Quick-change animation.</p></figcaption></figure>

The second way to turn off the animation would be to open the Deluxe Battle Kit plugin, and head into the Settings. Here, you'll find the setting  `SHOW_MEGA_ANIM`. If you set this to `false`,  the Mega Evolution animation will be shut off permanently, and will be replaced with the quick-change animation above, even when battle animations are turned on.

***

<mark style="background-color:orange;">**Mega Icons**</mark>

While this isn't strictly animation-related, there's no better place to make note of this, so I'll do so here. You may have noticed in the examples above that the Mega icon that displays on the battler's data boxes is different than the one included by Essentials by default. That's because this plugin includes a new icon for Mega Evolution, which replaces the old one.

These icons are placed on the sides of the battler's data boxes similar to how Primal icons are placed, rather than appearing within the box.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F7Z7Hzk3aGC33xVZGt5IJ%2F%5B2024-01-12%5D%2011_19_33.028.png?alt=media&#x26;token=d49d3b55-5204-49c4-a12a-258c08c29012" alt="" width="384"><figcaption><p>Example of Mega icons.</p></figcaption></figure>

Page 7:

# Animation: Primal Reversion

Though Primal Reversion is incorporated into Essentials by default, it doesn't contain any built-in animations related to the mechanic. To address this, the Deluxe Battle Kit includes its own set of animations for Primal Reversion. The animation style used for Primal Reversion is based on the same animation style this plugin utilizes for Mega Evolution.

There's a bit to explain about these animations and how they work, so I'll provide a break down of everything in this section.

{% hint style="info" %}
Note: If you already have an existing Primal Reversion animation which is stored as a Common animation named `"Primal"` plus a species ID such as `"PrimalGroudon"` or `"PrimalKyogre"`, then the animations for those species will take priority over the animation added by this plugin. This means that there's no risk of your animations being overwritten or ignored, nor do you need to change anything to make this plugin compatible.
{% endhint %}

***

<mark style="background-color:orange;">**Primal Animation**</mark>

When a Pokemon that meets the conditions for Primal Reversion enters the field, it will immediately Primal Revert. When this occurs, the Primal Reversion animation will play.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FOQXhfHEB41m20f5TAS5S%2Fdemo26.gif?alt=media&#x26;token=9f772dfd-71f4-4980-8970-334e6e173543" alt="" width="381"><figcaption><p>Primal Reversion on the player's side.</p></figcaption></figure>

There will be slight differences in the animation based on which side of the field the Primal Pokemon is on. Pokemon on the player's side of the field will face right, while Pokemon is on the opponent's side of the field will face left. This helps distinguish if the Primal Pokemon is friend or foe during the animation.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F473gY3ab8TRi2hNSVBWE%2Fdemo27.gif?alt=media&#x26;token=73c79aca-3207-4066-8db8-abb2c4b99f0f" alt="" width="381"><figcaption><p>Primal Reversion on the opponent's side.</p></figcaption></figure>

Unlike with Mega Evolutions, the animation for Primal Reversion doesn't include a trainer. This is due to Primal Reversion happening independently of any trainer, since it's something that happens passively and not manually activated.

Since Primal Reversion is a mechanic that is exclusive to Groudon and Kyogre by default, their animations are more unique to each of them, whereas the Mega Evolution animation is more generic since it can apply to any Pokemon. With the Primal Reversion animation, an image of the user's specific orb crystallizes around them before they emerge in their Primal forms. The background of the animation also differs to indicate the user, with Groudon's background being red and Kyogre's background being blue.

If you want to include your own custom Primal forms to utilize this animation, you'll have to include the appropriate graphics for the animation to use. These can be stored in \
`Graphics/Plugins/Deluxe Battle Kit/Primal`.&#x20;

You'll need both an icon graphic, as well as a white silhouette for the icon.

***

<mark style="background-color:orange;">**Animation Utilities**</mark>

<mark style="background-color:yellow;">**Skipping Animations**</mark>

You may have noticed in the examples above that during the Primal Reversion animation, a button prompt on the bottom left-hand corner of the screen appears. This "skip" button indicates that you can cut the animation short by pressing the `ACTION` key. Pressing it will immediately end the animation, allowing you to get right back to the battle if you grow tired of sitting through these animations.

<mark style="background-color:yellow;">**Turning Off Animations**</mark>

If you want to turn these animations off entirely, there are two ways to accomplish this. First, you may do so by turning off battle animations completely in the Options menu.&#x20;

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FwOMVVwf7z58G4TSKSGM6%2F%5B2024-01-12%5D%2011_58_20.948.png?alt=media&#x26;token=36cd6063-28d1-4886-9f6e-49bbf7642b8f" alt="" width="384"><figcaption><p>Battle animations in the Options menu.</p></figcaption></figure>

If so, this animation will also be turned off. Instead, it'll be replaced with a generic "quick-change" animation which happens instantaneously.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F8CFBfRYI9gQTfeXgVC3k%2Fdemo25.gif?alt=media&#x26;token=25e825af-f7a2-45e4-bd61-9e1299a010a6" alt="" width="381"><figcaption><p>Quick-change animation.</p></figcaption></figure>

The second way to turn off the animation would be to open the Deluxe Battle Kit plugin, and head into the Settings. Here, you'll find the setting  `SHOW_PRIMAL_ANIM`. If you set this to `false`,  the Primal Reversion animation will be shut off permanently, and will be replaced with the quick-change animation above, even when battle animations are turned on.

Page 8:

# Animation: Shadow Pokemon

<mark style="background-color:orange;">**Shadow Overlay Patterns**</mark>

By default, Essentials supports Shadow Pokemon introduced in *Pokemon Colosseum*. You can add your own custom sprites for these Shadow forms so that they look different when encountered. However, if you intend to include lots of different species as Shadow Pokemon in your game, creating or finding sprites for each and every Shadow form can add up to become quite a lot of extra work.

To simplify this, this plugin introduces a method of automatically applying an overlay on top of Pokemon sprites if they are in Shadow form. This allows you to have any species in Shadow form to appear different when viewed, without having to manually add new sprites for each Shadow form. Here's an example of what this looks like when applied:

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FkSj9mm8qarc4jskFijue%2F%5B2024-06-26%5D%2010_33_21.477.png?alt=media&#x26;token=7028380b-f11b-4067-9899-5713b8db992a" alt="" width="384"><figcaption><p>Shadow Lugia with the overlay applied.</p></figcaption></figure>

To accomplish this, this plugin includes a graphic file named `shadow_pattern`, which is located in the folder `Graphics/Plugins/Deluxe Battle Kit`. This image is what's used as the pattern which Shadow Pokemon sprites are overlayed with. You can edit or change this image if you wish to customize how your Shadow Pokemon sprites look.

However, if you already have existing Shadow form sprites for a particular species, then this generic overlay effect will not apply to those sprites. This can allow you to have specific unique Shadow forms for certain species, while maintaining a more generic effect for others.

If you wish to disable this feature and apply the generic overlay to all Shadow forms regardless if they're already using an existing Shadow form sprite or not, then you may do so by opening the plugin Settings and setting `DONT_OVERLAY_EXISTING_SHADOW_SPRITES` to `false`.

***

<mark style="background-color:orange;">**Animated Overlay Patterns**</mark>

The overlay displayed on Shadow Pokemon is a pattern than can actually move around in a loop, creating an animation of sorts. By default, this overlay will scroll upwards, creating a smoky effect.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FLOVerzo5k9vsN6bFS163%2Fshadow.gif?alt=media&#x26;token=5e861c40-6a5b-4518-8cfc-6236483d7589" alt="" width="382"><figcaption><p>Shadow Tyranitar with an animated pattern.</p></figcaption></figure>

To edit how this pattern moves, you simply have to open the plugin Settings and find the setting `SHADOW_PATTERN_MOVEMENT`. You will see that this is set to an array containing two symbols.

The first element in this array corresponds to how the overlay animates along the X-axis. The second element in this array corresponds to how the overlay animates along the Y-axis. By combining different settings for each axis, you can control how the pattern moves.&#x20;

If you'd prefer that the pattern is a still image that doesn't animate, then you would just set this as `[:none, :none]` to prevent any movement on either axis.

{% tabs %}
{% tab title="X-Axis" %}

<table><thead><tr><th width="115">Symbol</th><th>Animation Effect</th><th data-hidden></th></tr></thead><tbody><tr><td>:none</td><td>The overlay will not move along this axis.</td><td></td></tr><tr><td>:left</td><td>The overlay will move to the left in a loop.</td><td></td></tr><tr><td>:right</td><td>The overlay will move to the right in a loop.</td><td></td></tr><tr><td>:erratic</td><td>The overlay will "jitter" erratically left and right.</td><td></td></tr></tbody></table>
{% endtab %}

{% tab title="Y-Axis" %}

<table><thead><tr><th width="115">Symbol</th><th>Animation Effect</th><th data-hidden></th></tr></thead><tbody><tr><td>:none</td><td>The overlay will not move along this axis.</td><td></td></tr><tr><td>:up</td><td>The overlay will move up in a loop.</td><td></td></tr><tr><td>:down</td><td>The overlay will move down in a loop.</td><td></td></tr><tr><td>:erratic</td><td>The overlay will "jitter" erratically up and down.</td><td></td></tr></tbody></table>
{% endtab %}
{% endtabs %}

***

<mark style="background-color:orange;">**Hyper Mode Icon**</mark>

There isn't anywhere else to make note of this, but when a Shadow Pokemon enters Hyper Mode in battle, a new icon will appear on its databox to indicate this, similar to the icons used for things like Mega Evolution and Primal Reversion.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F0rkdtnmKkokKAachvpn0%2F%5B2025-04-17%5D%2012_46_40.519.png?alt=media&#x26;token=89472ae1-7ce6-4fd2-ada8-a8ce00e8446b" alt="" width="384"><figcaption><p>Hyper Mode icon appears on databoxes.</p></figcaption></figure>

Page 9:

# Deluxe Battle Rules

Essentials allows you to set special rules for your encounters by using the `setBattleRule` script to customize your battles. These are placed above the battle call, and you can set as many different rules as you'd like. You can use this to do things such as turn off money or experience gains for this battle, disable Poke Balls from being used, prevent the player from fleeing, and more.&#x20;

This kit expands on this by adding several new types of rules that allow you to customize things even further, allowing you to create some really unique encounters. The subpages in this section will go over each rule added by this plugin, and how to use them.\
\
Rules that affect similar things have been grouped together to make them easier to find.

{% hint style="info" %}
**Battle Rule Applicator**

While playing in debug mode, you can manually assign battle rules that you want to apply to your next battle through the debug menu. To do so, select "Deluxe plugin settings..." and then select "Set battle rules..." to begin manually adding battle rules to apply.&#x20;

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FbFmKC0qmxVP3S7xrq6L9%2F%5B2024-12-04%5D%2013_58_27.237.png?alt=media&#x26;token=e7e74ab4-3480-425a-9858-bd9c6c9ad2da" alt="" data-size="original">

Note that while not a battle rule, you may also use the "Set partner trainer" in a similar fashion to manually set a partner trainer to accompany the player in battle.
{% endhint %}

Page 10:

# Rules: Battle Modes

These are rules that affect the overall style of battle, such as how it controls or operates.

<details>

<summary><mark style="background-color:green;"><strong>"autoBattle"</strong></mark></summary>

This rule enables the AI to take control of the player's actions for this battle, allowing the battle to play out fully automated.\
\
This is entered as `setBattleRule("autoBattle")`

</details>

<details>

<summary><mark style="background-color:green;"><strong>"towerBattle"</strong></mark></summary>

While this rule is enabled, this battle will be considered a competitive/pvp battle similar to how battles would behave in the Battle Tower, meaning the player cannot use items from their bag, and will be able to forfeit trainer battles by using the Run command.\
\
This is entered as `setBattleRule("towerBattle")`

</details>

<details>

<summary><mark style="background-color:green;"><strong>"noBag"</strong></mark></summary>

While this rule is enabled, no trainers (including the player) will be able to use any items from their inventories. For the player, the "Bag" command will not be selectable at all.

This is entered as `setBattleRule("noBag")`

</details>

<details>

<summary><mark style="background-color:green;"><strong>"inverseBattle"</strong></mark></summary>

This rule enables inverse battle rules for this battle, as was introduced in Gen 6. During an Inverse Battle, the type chart is flipped so that Super Effective moves will be resisted, and moves that would normally be resisted or deal no damage will now be Super Effective.\
\
This is entered as `setBattleRule("inverseBattle")`

</details>

Page 11:

# Rules: Battle Visuals

These are rules that edit or overwrite certain visuals during battle, such as text or animations.

<details>

<summary><mark style="background-color:green;"><strong>"battleIntroText"</strong></mark></summary>

Intro text is what is displayed at the start of a battle to introduce your opponent. For example, wild battles will typically begin with "A wild \_\_ appeared!", while trainer battles will typically begin with "You are challenged by \_\_!" With this rule, you can customize this text to display whatever custom messages that you want.\
\
This is entered as `setBattleRule("battleIntroText", String)`, where "String" is the message you want to be displayed.\
\
You can use `{1}` in this message text to display the opponent's name. If there are multiple opponents, you can use `{2}` and `{3}` to also display the second and third opponent's names, respectively.\
\
Example: \
`setBattleRule("battleIntroText", "You were ambushed by a wild {1}!")`

</details>

<details>

<summary><mark style="background-color:green;"><strong>"opponentLoseText"</strong></mark></summary>

You can use this rule to customize lose messages for the opponent if they are defeated by the player in this battle. This will override their normal lose messages that they would normally display.\
\
This is entered as `setBattleRule("opponentLoseText", Message)`, where "Message" can either be a string or an array of strings where each string in the array corresponds to an opponent in this battle so that you can edit the lose text of multiple opposing trainers in double/triple battles. If this battle only has one opponent, then only one string is necessary.\
\
Example: `setBattleRule("opponentLoseText", "No fair! You must have cheated!")`

</details>

<details>

<summary><mark style="background-color:green;"><strong>"opponentWinText"</strong></mark></summary>

You can use this rule to customize victory messages for the opponent if they defeat the player in this battle. This rule doesn't do anything unless the <mark style="background-color:green;">"towerBattle"</mark> rule is also enabled, because NPC trainers only display win speech in Battle Tower-style battles.\
\
This is entered as `setBattleRule("opponentWinText", Message)`, where "Message" can either be a string or an array of strings where each string in the array corresponds to an opponent in this battle. If this battle only has one opponent, then only one string is necessary.\
\
Example: `setBattleRule("opponentWinText", "Heh, I knew I'd win!")`

</details>

<details>

<summary><mark style="background-color:green;"><strong>"setSlideSprite"</strong></mark></summary>

You can use this rule to customize how the opponent's sprite slides on to screen at the start of a battle. You can use this to control the direction they slide in from, and/or whether or not any base appears below them. You can use this to emulate things such as how Giratina enters battle from above when you first encounter it in *Pokemon Platinum*, or come up with some other unique scenarios.

This is entered as `setBattleRule("setSlideSprite", String)`, where "String" may be any one of the following strings:

* <mark style="background-color:yellow;">**"side"**</mark>\
  The opponent will slide in from the left side of the screen. This is the standard encounter method, and this will act as the default if no rule is set.\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FHZ2BKRsiWB98N6PsHWLK%2Fdemo57.gif?alt=media\&token=067d1921-f425-46d9-b97b-348f6096f08c)
* <mark style="background-color:yellow;">**"top"**</mark>\
  The opponent will slide in from the top of the screen.\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FvylASHZeBsOk409OcWuP%2Fdemo58.gif?alt=media\&token=68fa11c5-7328-4be3-835b-af110161c9b7)<br>
* <mark style="background-color:yellow;">**"bottom"**</mark>\
  The opponent will slide upwards, as if rising out of the ground.\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FnCyVIsOfGuIr3e0q7Zfh%2Fdemo61.gif?alt=media\&token=0bfcd819-7150-430b-bbaf-5490b9149b6e)<br>
* <mark style="background-color:yellow;">**"still"**</mark>\
  The opponent will remain still, and not slide on screen at all.\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FXzbnF3j0uLNoVsMaTn6C%2Fdemo60.gif?alt=media\&token=9914ec19-b544-4db3-9cf2-ecbf871a5f00)

Note: For any of the above strings, you may add <mark style="background-color:yellow;">"\_hideBase"</mark> to the string in order to hide the opponent's base and shadow sprites. This can be used to give the impression of the opponent floating in an abyss. For example, you may use *<mark style="background-color:yellow;">"</mark>*<mark style="background-color:yellow;">top\_hideBase"</mark> to emulated how Giratina is encountered in *Pokemon Platinum* where it would slide on screen from above, without any base or shadow sprites. As seen in the gifs for each slide-in style, examples are shown of each style with a base, and one without.

</details>

<details>

<summary><mark style="background-color:green;"><strong>"databoxStyle"</strong></mark></summary>

You can use this rule to customize how battler's databoxes will look during battle. By default, this plugin includes two different visual styles that can be set, but it's possible to add more custom styles with a little work. These databoxes are primarily designed to be used for boss encounters, so certain elements that are normally displayed on the opponent's databoxes (such as gender or level) are absent here.

To set this rule, you may enter `setBattleRule("databoxStyle", Style)`, where "Style" should be a symbol ID of the specific databox style you want to set. This plugin includes the following settable styles by default:

* `:Basic`\
  This applies simple but modernized databoxes for all battlers. The HP bars for the foe's databoxes are longer than normal, and there's much more name space than the usual databoxes. These make them suitable to be used for special boss encounters.\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fis348eq5AKW29Wfwl7vn%2F%5B2024-11-04%5D%2018_26_48.113.png?alt=media\&token=12c2b2e5-ecb4-436e-a73a-97166c9a9daf)\
  \
  These databoxes are much more compact than the normal ones Essentials uses, so they're ideal for double and triple battles since they take up less screen space. However, HP totals won't be displayed on the player's databoxes, so this may not be ideal in single battles. This databox style is used as the default style in situations where other styles aren't eligible for a particular battler.
* `:Long`\
  This applies a long databox on the foe's side that runs across the top of the screen. This is specifically designed to be used for boss battles to give the opponent a more imposing presence.\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FvhPt7uOE61cBTDrS9j91%2F%5B2024-11-04%5D%2018_27_32.082.png?alt=media\&token=286fa829-fcff-4bd9-8754-2dce768cf191)\
  \
  This style of databox only applies to the opponent's side, so the player's databoxes will just default to the `:Basic` style when this style is set. This style only applies if the opponent's side of the field contains just a single battler slot. If more than one battler slot is present on the opponent's side, the opponent's databoxes will default to the `:Basic` style instead.

***

<mark style="background-color:orange;">**Displaying Opponent Titles**</mark>

In *Pokemon Scarlet & Violet*, you could challenge wild Titan Pokemon that acted as boss encounters. These Titans would have unique titles displayed over their HP bars during battle. For example, "Klawf, the Stony Cliff Titan." You can replicate this mechanic through setting a databox style, however, this will only work for wild battles.

This can be accomplished by setting a databox style and entering an array that contains the symbol ID of the specific style you want to set, followed by a string that will function as the wild battler's display name on their databox. For example:

```ruby
setBattleRule("databoxStyle", [:Long, "{1} the Long Name-Haver"])
WildBattle.start(:CRABOMINABLE, 50)
```

![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F1Td9nHrlZjpXyBIkvMsN%2F%5B2024-11-04%5D%2018_27_54.705.png?alt=media\&token=d132c499-1ace-4543-ae04-b78cb059af93)

This begins a battle with a wild Crabominable with the `:Long` style applied. However, the name that appears above the wild battler's HP bar will be the title set as part of the rule, rather than the battler's normal name. Note that `{1}` can be used in this string to call the battler's actual name and include it as part of the title. However, you don't need to include its name in the title if you'd prefer to write in something entirely unique.

If you're setting up a wild double or triple battle and would like each wild Pokemon to have a unique title, you can accomplish this simply by adding additional strings to the array for each additional wild battler included. For example:

```
setBattleRule("databoxStyle", [:Basic,
  "{1} the First Champion",
  "{1} the Second Champion",
  "{1} the Third Champion"
])
WildBattle.start(:COBALION, 40, :TERRAKION, 40, :VIRIZION, 40)
```

![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F46eUQ8iv8l7rIhwBFIeP%2F%5B2024-11-04%5D%2018_28_34.514.png?alt=media\&token=25b55c38-34e7-401b-a021-c363e0dd3d48)

This begins a wild triple battle versus Cobalion, Terrakion, and Virizion with the `:Basic` style applied. However, each wild battler will have a unique title assigned to them that will be displayed above their HP bars.

If for some reason you want to set a wild triple battle where only the first and third opponent have a title, but the second opponent doesn't, then you can accomplish this by setting the second opponent's title to just `"{1}"`, so only their name will be displayed.

***

<mark style="background-color:orange;">**Memento Titles**</mark>

In *Pokemon Scarlet & Violet*, wild Pokemon encountered in Tera Raids would sometimes display a title if they generated with a mark. For example, if the raid Pokemon has the Mightiest Mark, it will have the title of "the Unrivaled" displayed along with its name.&#x20;

![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F2q02IkhrmroFRKhJRaRv%2F%5B2024-11-04%5D%2018_28_12.401.png?alt=media\&token=d1e162c4-fdc5-4a12-b518-54b0e1986781)

This feature is replicated in the same way here, but only if the [**Improved Mementos**](https://eeveeexpo.com/resources/1381/) plugin is installed to implement marks and titles. If so, any wild Pokemon you encounter while a databox style is enabled will display their full title over their HP bars.

If a wild Pokemon is encountered with a memento title when you have already manually set a specific title through the battle rule, then the manually entered title will take priority and be displayed instead of the natural title conferred from the ribbon or mark.

***

<mark style="background-color:orange;">**Adding Custom Databox Styles**</mark>

While this plugin only includes two different databox styles by default, it's set up so that you can add your own custom styles without much effort. To do so, you only need to implement the following:

<mark style="background-color:yellow;">**Graphics**</mark>

All of the graphics used for databox styles are stored in:\
`Graphics/Plugins/Deluxe Battle Kit/Databoxes`

In here, you can add a new folder which will contain the graphics for your new databox style. This folder should be named according to what symbol ID you want to refer to this custom style by. For example, there are already two folders located here named `Basic` and `Long`, which correlate to the two styles that are included in this plugin by default.

Within these folders, they should contain graphics with the following file names:

* `databox`
* `overlay_hp`
* `overlay_exp`
* `databox_foe`
* `overlay_hp_foe`

If databox graphics for the player or foe's side are missing from this folder, then the databoxes for that side will just default to whatever is used in the `Basic` folder. For example, the `Long` folder only contains graphics for the foe's databox, because only enemy battlers can use that databox style. This means that when the `Long` style is enabled, the databoxes on the player's side will pull from the `Basic` folder instead. So if you're designing a databox style that is only meant to be displayed on one side of the field, you do not need to include graphics for the opposing side's databoxes.

<mark style="background-color:yellow;">**Game Data**</mark>

Once the graphics have been set, the next thing that is required are setting the display properties for your custom databox style. This is done in the plugin file `[001] Deluxe Utilities/[008] Databox Styles`.

At the top of the script, there is a class called `DataboxStyle`, which is included in the `GameData` module. This is where the display properties of all databox styles are stored. You can add a new handler for any new databox styles you wish to add here, among the ones that already exist for the `:Basic` and `:Long` styles.

I won't delve into much more detail in how this is done here, as you should be able to more or less figure it out from by looking at the existing examples and comments in the script itself. The basic idea is that you enter all of the coordinate values and other display properties in your handler, and it will automatically apply these to the battle scene when your databoxes are loaded.

</details>

Page 12:

# Rules: Battle Audio

These are rules that are used to customize certain music tracks for this battle.

<details>

<summary><mark style="background-color:green;"><strong>"battleBGM"</strong></mark></summary>

You can use this rule to customize the BGM that will play during this battle.\
This is entered as `setBattleRule("battleBGM", String)`, where "String" is the file name of the track you want to play.

If you set this to an empty string, like `""`, then this will make it so the battle will have no battle music at all.

</details>

<details>

<summary><mark style="background-color:green;"><strong>"victoryBGM"</strong></mark></summary>

You can use this rule to customize the victory music that will play upon winning this battle.\
This is entered as `setBattleRule("victoryBGM", String)`, where "String" is the file name of the track you want to play.

If you set this to an empty string, like `""`, then this will make it so that this battle won't play any victory music at all. Instead, the battle music will just continue to play until it fades out.

</details>

<details>

<summary><mark style="background-color:green;"><strong>"lowHealthBGM"</strong></mark></summary>

You can use this rule to customize the low health music that will play upon the HP of the player's Pokemon falling to critically low levels.\
This is entered as `setBattleRule("lowHealthBGM", String)`, where "String" is the file name of the track you want to play.

If you set this to an empty string, like `""`, then this will make it so that this battle won't play any low HP music at all. Instead, the battle music will just continue to play as it normally would.

</details>

<details>

<summary><mark style="background-color:green;"><strong>"captureME"</strong></mark></summary>

You can use this rule to customize the jingle that plays upon successfully capturing a wild Pokemon. This is entered as `setBattleRule("captureME", String)`, where "String" is the file name of the track you want to play.

If you set this to an empty string, like `""`, then this will make it so that this battle won't play a capture jingle at all.

</details>

Page 13:

# Rules: Editing the Player

These are rules that can be used to temporarily edit attributes of the player, their party or their inventory for the duration of this battle.

<details>

<summary><mark style="background-color:green;"><strong>"tempPlayer"</strong></mark></summary>

You can use this rule to change the player's name and/or appearance for this battle, and revert back to normal afterwards. For example, you can use this to disguise the player as a different character for a capture tutorial.\
\
This is entered as `setBattleRule("tempPlayer", Attributes)`, where "Attributes" can be either a String, Integer, or an Array which contains both a string and an integer.\
\
The string entered here will be used as the player's new temporary name for this battle. If an integer is entered, this will change the player's outfit to whichever outfit number is set here.

</details>

<details>

<summary><mark style="background-color:green;"><strong>"tempParty"</strong></mark></summary>

You can use this rule to give the player a temporary party that will replace their normal party for this battle, and revert back to their normal party afterwards.\
\
This is entered as `setBattleRule("tempParty", Array)`, where "Array" is an array that contains a number of Pokemon objects, or species ID's and levels.\
\
For example, `[:PIKACHU, 20, :MEOWTH, 15]` will give the player a temporary party consisting of a level 20 Pikachu and a level 15 Meowth.\
\
If you want to edit specific values on the temporary Pokemon the player should have, then you can first create a Pokemon object yourself with something like:&#x20;

```
pkmn = Pokemon.new(:PIKACHU, 20)
```

Then you may edit its values from there. Once the Pokemon is edited to your liking, you may just enter `pkmn` in the array for this battle rule instead of a species ID and level.

</details>

<details>

<summary><mark style="background-color:green;"><strong>"tempBag"</strong></mark></summary>

You can use this rule to give the player a temporary inventory that will replace their normal bag for this battle, and return all of their normal items afterwards.\
\
This is entered as `setBattleRule("tempBag", Array)`, where "Array" is an array that contains a number of item ID's and quantities for each item.\
\
For example, `[:POTION, 5, :ANTIDOTE, 2]` will give the player a temporary bag consisting of only 5 Potions and 2 Antidotes. If no quantity is entered after an item ID, the quantity will always assumed to be 1. So for example, if you set this to something like `[:POKEBALL, 5, :QUICKBALL, :DUSKBALL]`, then the player's temporary bag will consist of 5 Poke Balls, 1 Quick Ball and 1 Dusk Ball.

</details>

Page 14:

# Rules: Mega Evolution

These are rules related to Mega Evolution.

<details>

<summary><mark style="background-color:green;"><strong>"wildMegaEvolution"</strong></mark></summary>

You can use this rule to flag wild Pokemon encountered in this battle as capable of using Mega Evolution if they are holding the appropriate Mega Stone, even though they don't have a trainer with a Mega Ring. Wild Pokemon will always Mega Evolve immediately upon being encountered, prior to any commands even being entered.\
\
This is entered as `setBattleRule("wildMegaEvolution")`

When this rule is enabled, the <mark style="background-color:green;">"disablePokeBalls"</mark> Battle Rule is also enabled. This will persist until the wild Mega Pokemon reaches its damage threshold and its Mega Evolved state ends. After which, Poke Balls will become useable again.

If the SOS Battles plugin is installed, the <mark style="background-color:green;">"SOSBattle"</mark> and <mark style="background-color:green;">"totemBattle"</mark> rules are ignored and turned off for this battle.

</details>

<details>

<summary><mark style="background-color:green;"><strong>"noMegaEvolution"</strong></mark></summary>

You can use this rule to disable the ability to use Mega Evolution for certain trainers in this battle, even if they meet all the criteria otherwise. You can disable this for the player's side of the field, the opponent's, or for all trainers.\
\
This is entered as `setBattleRule("noMegaEvolution", Symbol)`, where "Symbol" can be any one of the following:

* <mark style="background-color:yellow;">:Player</mark>\
  All trainers on the player's side will be unable to use Mega Evolution.
* <mark style="background-color:yellow;">:Opponent</mark>\
  All trainers on the opponent's side will be unable to use Mega Evolution.
* <mark style="background-color:yellow;">:All</mark>\
  All trainers on both sides in this battle will be unable to use Mega Evolution.

</details>

Page 15: 

# Rules: Capturing Pokemon

These are rules related to capturing wild Pokemon.

<details>

<summary><mark style="background-color:green;"><strong>"alwaysCapture"</strong></mark></summary>

This rule allows you to adjust the capture chance of any Poke Ball used in this battle so that they always succeed, regardless of normal capture chances.

This is entered as `setBattleRule("alwaysCapture")`

</details>

<details>

<summary><mark style="background-color:green;"><strong>"neverCapture"</strong></mark></summary>

This rule allows you to adjust the capture chance of any Poke Ball used in this battle so that they always fail, regardless of normal capture chances. This rule will even cause Master Balls to fail.

This is entered as `setBattleRule("neverCapture")`

</details>

<details>

<summary><mark style="background-color:green;"><strong>"tutorialCapture"</strong></mark></summary>

This rule makes it so that this battle is considered a tutorial battle, which means that any Pokemon captured in this battle are not kept by the player, nor are they recorded in the Pokedex.

This is entered as `setBattleRule("tutorialCapture")`

</details>

<details>

<summary><mark style="background-color:green;"><strong>"raidStyleCapture"</strong></mark></summary>

This rule emulates how capturing raid Pokemon works. While this rule is active, wild Pokemon will not faint when their HP reaches zero. Instead, you will be prompted to throw a ball to capture them. If you choose not to, or if the Poke Ball fails to capture them, they will flee to end the battle.\
\
This is entered as `setBattleRule("raidStyleCapture", true)`, but you may further customize this if you wish by entering a hash instead of `true` as the second argument.\
\
In this hash, you can customize how you want this raid-style capture to behave by setting one or more of these keys:

* <mark style="background-color:yellow;">**:capture\_chance**</mark>\
  This replaces the natural capture chance of the selected Poke Ball with one that you manually input here. For example, if you set this to 25, then any thrown Poke Ball during this capture sequence will have a 25% capture chance, regardless of what the normal capture chance would be. Master Balls ignore this setting. If not set, then the normal capture rate is used.<br>

  Example:\
  `setBattleRule("raidStyleCapture", {` \
  &#x20; `:capture_chance => 25`\
  `})`\
  `WildBattle.start(:ABRA, 20)`
* <mark style="background-color:yellow;">**:flee\_msg**</mark>\
  This allows you to set a custom message that should display if the wild Pokemon isn't captured by the player, and instead flees. You can use `{1}` to refer to the name of the wild Pokemon. If not set, the default message ("The wild \_\_\_ fled") will be displayed.\
  \
  Example:\
  `setBattleRule("raidStyleCapture", {`\
  &#x20; `:capture_chance => 25,`\
  &#x20; `:flee_msg       => "{1} quickly escaped in the blink of an eye!"`\
  `})`\
  `WildBattle.start(:ABRA, 20)`<br>
* <mark style="background-color:yellow;">**:capture\_bgm**</mark>\
  This sets up custom music that should begin to play when the player is prompted to capture the wild Pokemon. If no BGM file is entered here, the normal battle music will continue to play as it usually would.\
  \
  Example:\
  `setBattleRule("raidStyleCapture", {` \
  &#x20; `:capture_chance => 25,`\
  &#x20; `:capture_bgm    => "Raid capture music",`\
  &#x20; `:flee_msg       => "{1} quickly escaped in the blink of an eye!"`\
  `})`\
  `WildBattle.start(:ABRA, 20)`

</details>

Page 16: 

# Rules: Editing Wild Pokemon

These are rules related to editing certain attributes on wild Pokemon to customize encounters.

<details>

<summary><mark style="background-color:green;"><strong>"editWildPokemon"</strong></mark></summary>

You can use this rule to edit various attributes of wild Pokemon prior to initiating battle. This allows you to customize their Natures, IV's, shinyness, and more. In double or triple wild battles, this only edits the attributes of the primary wild Pokemon that appears in the first slot.\
\
This is entered as `setBattleRule("editWildPokemon", Attributes)`, where "Attributes" is a hash containing all the settings you want to apply to the wild Pokemon. More details on this found below.

</details>

<details>

<summary><mark style="background-color:green;"><strong>"editWildPokemon2"</strong></mark></summary>

This rule functions identically to <mark style="background-color:green;">"editWildPokemon"</mark>, ​accept this rule only edits the attributes of the second wild Pokemon in a double or triple battle.

</details>

<details>

<summary><mark style="background-color:green;"><strong>"editWildPokemon3"</strong></mark></summary>

This rule functions identically to <mark style="background-color:green;">"editWildPokemon"</mark>, accept this rule only edits the attributes of the third wild Pokemon in a triple battle.

</details>

***

Here are all of the possible attributes you may set in a hash for any of the above rules:

<table><thead><tr><th width="145">Key</th><th width="197" align="center">Value</th><th>Description</th></tr></thead><tbody><tr><td><mark style="background-color:yellow;">:species</mark></td><td align="center">Species ID</td><td>Changes the species of the wild Pokemon.</td></tr><tr><td><mark style="background-color:yellow;">:form</mark></td><td align="center">Integer</td><td>Sets the form of the wild Pokemon.</td></tr><tr><td><mark style="background-color:yellow;">:form_simple</mark></td><td align="center">Integer</td><td>Sets the form of the wild Pokemon. Use this instead of <mark style="background-color:yellow;">:form</mark> to skip the move learning prompt for species like Rotom.</td></tr><tr><td><mark style="background-color:yellow;">:name</mark></td><td align="center">String</td><td>Sets the nickname of the wild Pokemon.</td></tr><tr><td><mark style="background-color:yellow;">:level</mark></td><td align="center">Integer</td><td>Sets the level of the wild Pokemon.</td></tr><tr><td><mark style="background-color:yellow;">:gender</mark></td><td align="center">Integer</td><td>Sets the gender of the wild Pokemon (0 = Male, 1 = Female).</td></tr><tr><td><mark style="background-color:yellow;">:hp</mark></td><td align="center">Integer</td><td>Sets the HP of the wild Pokemon (out of its total HP).</td></tr><tr><td><mark style="background-color:yellow;">:status</mark></td><td align="center">Status ID</td><td>Sets the status condition of the wild Pokemon.</td></tr><tr><td><mark style="background-color:yellow;">:statusCount</mark></td><td align="center">Integer</td><td>Sets the status counter of the wild Pokemon (for Sleep and Poison).</td></tr><tr><td><mark style="background-color:yellow;">:shiny</mark></td><td align="center">Boolean</td><td>Sets whether this wild Pokemon should be shiny or not.</td></tr><tr><td><mark style="background-color:yellow;">:super_shiny</mark></td><td align="center">Boolean</td><td>Sets whether this wild Pokemon should be super shiny or not.</td></tr><tr><td><mark style="background-color:yellow;">:nature</mark></td><td align="center">Nature ID</td><td>Sets the Nature of the wild Pokemon.</td></tr><tr><td><mark style="background-color:yellow;">:item</mark></td><td align="center">Item ID</td><td>Sets the Item of the wild Pokemon.</td></tr><tr><td><mark style="background-color:yellow;">:mail</mark></td><td align="center">Mail Object</td><td>Sets the held mail of the wild Pokemon. You must create the mail object prior to this rule.</td></tr><tr><td><mark style="background-color:yellow;">:ability</mark></td><td align="center">Ability ID</td><td>Sets the Ability of the wild Pokemon.</td></tr><tr><td><mark style="background-color:yellow;">:ability_index</mark></td><td align="center">Integer</td><td>Sets the Ability index of the wild Pokemon.</td></tr><tr><td><mark style="background-color:yellow;">:moves</mark></td><td align="center">Move ID (or Array)</td><td>Sets the moves this wild Pokemon will have.</td></tr><tr><td><mark style="background-color:yellow;">:ribbons</mark></td><td align="center">Ribbon ID (or Array)</td><td>Sets the ribbons this wild Pokemon will have.</td></tr><tr><td><mark style="background-color:yellow;">:pokerus</mark></td><td align="center">Boolean</td><td>Sets whether the wild Pokemon will have Pokerus or not.</td></tr><tr><td><mark style="background-color:yellow;">:happiness</mark></td><td align="center">Integer</td><td>Sets the happiness level of this wild Pokemon (0-255).</td></tr><tr><td><mark style="background-color:yellow;">:iv</mark></td><td align="center">Integer, Array or Hash</td><td>Sets the IV's of the wild Pokemon.<br>When set as an integer, all of the Pokemon's IV's are set to the same number.<br>When set as an array, each of the Pokemon's IV's are set to the number in the array (in PBS stat order).<br>When set as a hash, directly sets the IV's of each stat ID in the hash.</td></tr><tr><td><mark style="background-color:yellow;">:ev</mark></td><td align="center">Integer, Array or Hash</td><td>Sets the EV's of the wild Pokemon.<br>When set as an integer, all of the Pokemon's EV's are set to the same number.<br>When set as an array, each of the Pokemon's EV's are set to the number in the array (in PBS stat order).<br>When set as a hash, directly sets the EV's of each stat ID in the hash.</td></tr><tr><td><mark style="background-color:yellow;">:obtain_text</mark></td><td align="center">String</td><td>Sets the met location text that will appear in the memo page of the Summary once this wild Pokemon has been captured.</td></tr></tbody></table>

***

Example:

```
setBattleRule("editWildPokemon", {
  :name    => "Sparky",
  :shiny   => true,
  :ability => :VOLTABSORB,
  :item    => :LIGHTBALL,
  :nature  => :HASTY,
  :moves   => [:VOLTTACKLE, :SURF, :WISH, :ENCORE],
  :iv      => 31
})
WildBattle.start(:PIKACHU, 35)
```

***

<mark style="background-color:orange;">**Exclusive Attributes for Supported Plugins**</mark>

{% tabs %}
{% tab title="Enhanced Pokemon UI" %}

<table><thead><tr><th width="129">Key</th><th width="146" align="center">Value</th><th>Description</th></tr></thead><tbody><tr><td><mark style="background-color:yellow;">:shiny_leaf</mark></td><td align="center">Integer (0-6)</td><td>Sets a number of shiny leaves on the wild Pokemon. Six leaves will apply a shiny leaf crown.</td></tr></tbody></table>
{% endtab %}

{% tab title="Improved Mementos" %}

<table><thead><tr><th width="124.66666666666666">Key</th><th width="167" align="center">Value</th><th>Description</th></tr></thead><tbody><tr><td><mark style="background-color:yellow;">:memento</mark></td><td align="center">Ribbon or Mark ID</td><td>Sets the memento that should be adorned on this wild Pokemon. If the memento has a title, that title will be automatically given to the Pokemon.</td></tr><tr><td><mark style="background-color:yellow;">:scale</mark></td><td align="center">Integer (0-255)</td><td>Sets the size of the wild Pokemon, where 0 is the smallest and 255 is the largest. </td></tr></tbody></table>
{% endtab %}

{% tab title="Dynamax" %}

<table><thead><tr><th width="168">Key</th><th width="139" align="center">Value</th><th>Description</th></tr></thead><tbody><tr><td><mark style="background-color:yellow;">:dynamax_able</mark></td><td align="center">Boolean</td><td>Toggles whether the wild Pokemon is capable of using Dynamax.</td></tr><tr><td><mark style="background-color:yellow;">:dynamax_lvl</mark></td><td align="center">Integer (0-10)</td><td>Sets the Dynamax level of the wild Pokemon.</td></tr><tr><td><mark style="background-color:yellow;">:gmax_factor</mark></td><td align="center">Boolean</td><td>Sets whether the wild Pokemon has G-Max Factor.</td></tr><tr><td><mark style="background-color:yellow;">:dynamax</mark></td><td align="center">Boolean</td><td>Sets whether the wild Pokemon is Dynamaxed.</td></tr></tbody></table>
{% endtab %}

{% tab title="Terastallization" %}

<table><thead><tr><th width="154">Key</th><th width="112" align="center">Value</th><th>Description</th></tr></thead><tbody><tr><td><mark style="background-color:yellow;">:terastal_able</mark></td><td align="center">Boolean</td><td>Toggles whether the wild Pokemon is capable of using Terastallization.</td></tr><tr><td><mark style="background-color:yellow;">:tera_type</mark></td><td align="center">Type ID</td><td>Sets the Tera type of the wild Pokemon.</td></tr><tr><td><mark style="background-color:yellow;">:terastallized</mark></td><td align="center">Boolean</td><td>Sets whether the wild Pokemon is Terastallized.</td></tr></tbody></table>
{% endtab %}
{% endtabs %}

Page 17: 

# Wild Boss Attributes

The Deluxe Battle Kit allows you to edit wild encounters with special attributes that make them much more challenging than your normal wild battles. These attributes can give wild Pokemon much larger HP pools that would normally be impossible for a Pokemon to have, or grant them special immunities to things such as status effects, stat drops, or cheesy tactics like OHKO moves or Perish Song.

\
Applying these attributes is done in the same way that you can edit any wild Pokemon by using the <mark style="background-color:green;">"editWildPokemon"</mark> Battle Rule outlined in the "Deluxe Battle Rules" section above. However, there are two additional attributes not listed there that are to be set only for these special boss encounters. Each of these attributes will be detailed in this section.

Page 18:

# Attribute: Boosted HP

<mark style="background-color:orange;">**:hp\_level**</mark>\
This attribute sets the HP level of the wild Pokemon. "HP level" is simply how much the wild Pokemon's HP should be scaled up beyond its normal bounds. The Pokemon's total HP will be multiplied by whatever number this is set to. For example, if the wild Pokemon you encounter would normally have 100 total HP and you set its <mark style="background-color:orange;">:hp\_level</mark> to 3, it will have 3x HP, which means in battle it would actually have 300 HP. There's technically no limit to how much HP you can scale by, so you can easily have a wild Pokemon with HP in the thousands. Once the Pokemon is captured however, its HP will return to whatever its normal amount would usually be. Here's an example of what this may look like when set:

```
setBattleRule("editWildPokemon", {
  :name     => "Supreme Rat",
  :hp_level => 6
})
setBattleRule("cannotRun")
WildBattle.start(:RATICATE, 50)
```

In this example, a wild battle vs a level 50 Raticate named "Supreme Rat" will be initiated. It's HP will be scaled up by 6x its normal amount. At level 50, this can be around 540-630 HP.

Note that while HP is scaled up in this way, effects that deal damage, inflict recoil and/or heal HP based on a percentage of the Pokemon's total or remaining HP will still run their calculations based on what the Pokemon's original HP would normally be, not what their currently scaled up HP is.\
\
For example, the move Super Fang deals damage equal to 50% of the target's remaining HP. If the target has 100 HP, this means the move will deal 50 points of damage. However, let's say the Pokemon's original HP is 100, but is then scaled up to 500 by setting <mark style="background-color:orange;">:hp\_level => 5</mark>. When Super Fang is used on this Pokemon, it will not deal half of 500 to inflict 250 points of damage. Instead, it will calculate based on the original 100 HP the Pokemon would normally have, meaning Super Fang will still only deal 50 points of damage, despite the target's actual HP being far higher.\
\
This helps keep these moves and effects balanced, and prevents you from being able to deal obscene damage to boss Pokemon who are meant to have a lot of HP. This also nerfs healing moves used by the boss Pokemon, to prevent them from being entirely too good. For example, let's say that same 100 HP Pokemon was scaled up to have 1,000 HP and used the move Recover. Normally, this would mean it would heal a whopping 500 HP with each use, which would be totally unreasonable for the player to deal with. But because healing is scaled to its original HP, Recover will only heal 50 HP instead.\
\
Here is a list of all of the effects that will scale their damage/recoil/healing based on the Pokemon's original HP, and not its boosted HP:

* Super Fang
* Nature's Madness
* Endeavor
* Crush Grip
* Wring Out
* Hard Press (Gen 9 Pack)
* Pain Split (both damage done and healing received)
* Curse (self-inflicted damage by Ghost-types)
* Steel Beam (self-inflicted damage)
* Mind Blown (self-inflicted damage)
* Belly Drum (self-inflicted damage)
* Clangorous Soul (self-inflicted damage)
* All self-inflicted damage from crash damage moves (High Jump Kick, etc.)
* All splash damage taken by a move's effect (Flame Burst, etc.)
* All passive damage taken by move effects (Leech Seed, Nightmare, Spiky Shield, etc.)
* All passive damage taken from status conditions (Poison, Burn, Frostbite, etc.)
* All passive damage taken from weather or terrain (Sandstorm, Hail, etc.)
* All passive damage taken from held items (Life Orb, Rocky Helmet, etc.)
* All passive damage taken from abilities (Solar Power, Rough Skin, etc.); except for those that deal a fixed amount (Innards Out)
* All healing received from all moves effects (Recover, Life Dew, etc); except for those that heal a fixed amount (Strength Sap, HP draining moves)
* All healing received from all held item effects (Leftovers, Sitrus Berry, etc.); except for those that heal a fixed amount (Oran Berry, Berry Juice, Shell Bell)

Page 19:

# Attribute: Immunities

<mark style="background-color:orange;">**:immunities**</mark>\
This attribute is an array of symbols, where each symbol grants the wild Pokemon special immunities for this battle only. Once the Pokemon is captured however, it will no longer have any of these immunities. Here's an example of what this may look like when set:

```
setBattleRule("editWildPokemon", {
  :name       => "Big Kahuna",
  :form       => 1,
  :item       => :THICKCLUB,
  :hp_level   => 10,
  :immunities => [:SLEEP, :FROZEN, :OHKO, :ITEMREMOVAL]
})
setBattleRule("cannotRun")
setBattleRule("disablePokeBalls")
WildBattle.start(:MAROWAK, 50)
```

In the example above, a wild battle vs a level 50 Alolan Marowak named "Big Kahuna" will be initiated. It'll be holding the Thick Club, and it's HP will be scaled up by 10x as well as being completely immune to Sleep, Freeze, OHKO moves/effects, and any effect that would remove/replace/disable its held item.

Here's the total list of potential immunities you can give to a wild Pokemon, and the symbols you would use for each one:

<details>

<summary><mark style="background-color:yellow;"><strong>:SLEEP</strong></mark></summary>

Makes the wild Pokemon completely immune to the Sleep status, including from indirect means such as Yawn or Synchronize. This is similar to having the Insomnia ability. This will not prevent self-inflicted Sleep through Rest, however.

</details>

<details>

<summary><mark style="background-color:yellow;"><strong>:POISON</strong></mark></summary>

Makes the wild Pokemon completely immune to the Poison status, including from indirect means such as Synchronize. This is similar to having the Immunity ability.

</details>

<details>

<summary><mark style="background-color:yellow;"><strong>:BURN</strong></mark></summary>

Makes the wild Pokemon completely immune to the Burn status, including from indirect means such as Synchronize. This is similar to having the Water Veil ability.

</details>

<details>

<summary><mark style="background-color:yellow;"><strong>:PARALYSIS</strong></mark></summary>

Makes the wild Pokemon completely immune to the Paralyzed status, including from indirect means such as Synchronize. This is similar to having the Limber ability.

</details>

<details>

<summary><mark style="background-color:yellow;"><strong>:FROZEN</strong></mark></summary>

Makes the wild Pokemon completely immune to the Frozen status, including from indirect means such as Synchronize. This is similar to having the Magma Armor ability.

</details>

<details>

<summary><mark style="background-color:yellow;"><strong>:FROSTBITE</strong></mark></summary>

Makes the wild Pokemon completely immune to the Frostbite status, including from indirect means such as Synchronize. This is only relevant if you have the Gen 9 Pack installed.

</details>

<details>

<summary><mark style="background-color:yellow;"><strong>:DROWSY</strong></mark></summary>

Makes the wild Pokemon completely immune to the Drowsy status, including from indirect means such as Synchronize. This is only relevant if you have the Gen 9 Pack installed.

</details>

<details>

<summary><mark style="background-color:yellow;"><strong>:CONFUSION</strong></mark></summary>

Makes the wild Pokemon completely immune to being confused. This is similar to having the Own Tempo ability.

</details>

<details>

<summary><mark style="background-color:yellow;"><strong>:ATTRACT</strong></mark></summary>

Makes the wild Pokemon completely immune to being infatuated. This is similar to being genderless.

</details>

<details>

<summary><mark style="background-color:yellow;"><strong>:ALLSTATUS</strong></mark></summary>

This combines the effects of all of the immunities listed above, making the wild Pokemon completely immune to the Sleep, Poison, Burn, Paralysis, Frozen, Frostbite, and Drowsy status conditions. This also makes the wild Pokemon immune to being confused or infatuated.

</details>

<details>

<summary><mark style="background-color:yellow;"><strong>:FLINCH</strong></mark></summary>

Makes the wild Pokemon completely immune to being flinched. This is similar to having the Inner Focus ability.

</details>

<details>

<summary><mark style="background-color:yellow;"><strong>:CRITICALHIT</strong></mark></summary>

Makes the wild Pokemon completely immune to being critically hit. This is similar to having the Battle Armor ability.

</details>

<details>

<summary><mark style="background-color:yellow;"><strong>:STATDROPS</strong></mark></summary>

Makes the wild Pokemon completely immune to having its stats lowered. This does not prevent self-inflicted stat drops, however. This is similar to having the Clear Body ability.

</details>

<details>

<summary><mark style="background-color:yellow;"><strong>:PPLOSS</strong></mark></summary>

Makes it so the wild Pokemon's PP cannot be lowered, even from using its own moves. This effectively gives the wild Pokemon infinite PP. Moves that would directly reduce the target's PP, such as Spite, will simply fail when used on the target.

</details>

<details>

<summary><mark style="background-color:yellow;"><strong>:TYPECHANGE</strong></mark></summary>

Makes the wild Pokemon completely immune to effects that would change its typing in any way. This includes effects that add to the target's typing, such as Forest's Curse. Effects that would cause the user to change its own typing, such as from the effects of moves like Reflect Type and Conversion2, will also fail to work.

</details>

<details>

<summary><mark style="background-color:yellow;"><strong>:ITEMREMOVAL</strong></mark></summary>

Makes the wild Pokemon completely immune to effects that would remove, replace, swap or disable its held item. This is similar to having the Sticky Hold ability. Effects that would cause the user to remove its own held item, such as through the effects of Fling or Bestow, will also fail to work.

</details>

<details>

<summary><mark style="background-color:yellow;"><strong>:ABILITYREMOVAL</strong></mark></summary>

Makes the wild Pokemon completely immune to effects that would remove, replace, swap, or disable its ability. This is similar to having an ability that cannot be negated, like Multitype. Effects that would cause the user to replace or swap its own ability, such as through the effects of Role Play or Skill Swap, will also fail to work.

</details>

<details>

<summary><mark style="background-color:yellow;"><strong>:INDIRECT</strong></mark></summary>

Makes the wild Pokemon completely immune to taking damage from indirect sources. This is similar to having the Magic Guard ability. This means any passive damage taken from things like status conditions, weather, Leech Seed, recoil, entry hazards, etc. will have no effect on this Pokemon.

</details>

<details>

<summary><mark style="background-color:yellow;"><strong>:DISABLE</strong></mark></summary>

Makes the wild Pokemon completely immune to effects that would temporarily disable one or more of the moves in its moveset. This is similar to having the Aroma Veil ability. This means that any of the following effects will fail to work on the Pokemon: Disable/Cursed Body, Torment, Encore, Taunt, Heal Block, and Throat Chop.

</details>

<details>

<summary><mark style="background-color:yellow;"><strong>:OHKO</strong></mark></summary>

Makes the wild Pokemon completely immune to effects that would instantly set its HP to zero. This includes all OHKO moves such as Fissure and Horn Drill, but this also includes passive OHKO effects from moves such as Destiny Bond and Perish Song.

</details>

<details>

<summary><mark style="background-color:yellow;"><strong>:SELFKO</strong></mark></summary>

Makes the wild Pokemon incapable of forcing itself to faint with self-KO moves. This causes the following moves to fail when used by this Pokemon: Self-Destruct, Explosion, Misty Explosion, Final Gambit, and Memento. In addition, moves that instantly cut the user's HP by 50% of its total HP, such as Mind Blown, Steel Beam, and Ghost-type Curse will fail to work if the user would KO itself by using the move. However, traditional recoil or crash damage moves such as Double-Edge or High Jump Kick are not affected by this.

</details>

<details>

<summary><mark style="background-color:yellow;"><strong>:ESCAPE</strong></mark></summary>

Makes the wild Pokemon completely immune to effects that would force it to flee to end the battle. This is similar to having the Suction Cups ability. This means any of the following effects will fail to work on the Pokemon: Roar, Whirlwind, Circle Throw, and Dragon Tail. Effects that would cause the user to force itself to flee from battle, such as through the effects of Teleport, Emergency Exit, or Wimp Out, will also fail to work.

</details>

<details>

<summary><mark style="background-color:yellow;"><strong>:TRANSFORM</strong></mark></summary>

Makes the wild Pokemon completely immune to being copied by the effects of Transform or Imposter. This also prevents the Pokemon from changing itself with these effects. This can be used to prevent the player from copying overpowered boss-exclusive moves and/or abilities, while simultaneously preventing the wild boss Pokemon from being cheesed by manipulating it into transforming into something less threatening.

</details>

Page 20:

# Mid-Battle Scripting

The Deluxe Battle Kit allows you to create special scripts that will run during battle to create custom scenarios. This can be used to display trainer speech during battle, change the battle music, make an animation play, edit the attributes of a battler or the battlefield, and so much more. What you can accomplish with this is only limited by your imagination.

To set up a midbattle script, you must use the <mark style="background-color:green;">"midbattleScript"</mark> Battle Rule. This is a special rule that wasn't covered in the "Deluxe Battle Rules" section above, as it requires its own section to go over all the ways in which it may be used and set up.

This rule is entered as `setBattleRule("midbattleScript", Script)`, where "Script" can be a hash which contains a series of Trigger Keys.&#x20;

Refer to the "Trigger Keys" section for more details.

Page 21:

# Trigger Keys

The primary way of setting up a midbattle script is by entering a hash which contains a series of keys and values. Each key corresponds to a specific point in battle where you want something to trigger. Because of this, I'm going to refer to this set of keys as "Trigger Keys." In the following subsections, I will go over every possible Trigger Key, how they can be set, and at what specific point in battle they activate. Trigger Keys which activate under similar points in battle have been grouped together to make them easier to find.

Note that Trigger Keys are always strings, and always begin with an upper case letter.

Page 22:

# Triggers: Round Phases

These are keys which trigger during certain phases of a battle round.

* <mark style="background-color:purple;">**"RoundStartCommand"**</mark>\
  Triggers at the start of the Command Phase, before any inputs or decisions are made.<br>
* <mark style="background-color:purple;">**"RoundStartAttack"**</mark>\
  Triggers at the start of the Attack Phase, after all selections have been made, but prior to any of them executing.<br>
* <mark style="background-color:purple;">**"RoundEnd"**</mark>\
  Triggers at the very end of a round, after everything has concluded, but before the next Command Phase begins.

{% hint style="info" %}
Trigger Extensions: You may extend these keys with a number to specify a turn that they should trigger on. For example, <mark style="background-color:purple;">"RoundStartCommand\_2"</mark> would trigger only on the second turn.

Note that these particular triggers will always require an extension to indicate who to trigger them on. For more details, check out the "Extensions: User" section.
{% endhint %}

Page 23:

# Triggers: Battler Turns

These are keys which trigger during a specific battler's turn.

* <mark style="background-color:purple;">**"TurnStart"**</mark>\
  Triggers at the start of a battler's turn, before any of the commands entered for that battler's turn are executed.<br>
* <mark style="background-color:purple;">**"TurnEnd"**</mark>\
  Triggers at the end of a battler's turn, after all of its commands have been executed.

{% hint style="info" %}
Trigger Extensions: You may extend these keys with a number to specify a turn that they should trigger on. For example, <mark style="background-color:purple;">"TurnEnd\_4"</mark> would trigger only on the battler's fourth turn. You may also extend these keys with a species or type ID so that they may only trigger during the turn of a specific species or a species of a specific type. For example, <mark style="background-color:purple;">"TurnStart\_CUBONE"</mark> would only trigger at the start of a Cubone's turn, while <mark style="background-color:purple;">"TurnEnd\_ROCK"</mark> would only trigger at the end of a Rock-type's turn.
{% endhint %}

Page 24: 

# Triggers: Item Usage

These are keys which trigger upon a trainer using an item from their inventory.

* <mark style="background-color:purple;">**"BeforeItemUse"**</mark>\
  Triggers when a trainer chooses to use an item, but before the effects of that item are actually executed.<br>
* <mark style="background-color:purple;">**"AfterItemUse"**</mark>\
  Triggers after the effects of a trainer's used item are executed.

{% hint style="info" %}
Trigger Extensions: You may extend these keys with an item ID to specify that they should only trigger when a specific item is used. For example, <mark style="background-color:purple;">"BeforeItemUse\_POTION"</mark> would trigger only when a trainer is about to use a Potion.
{% endhint %}

Page 25:

# Triggers: Wild Capture

These are keys which trigger upon the player throwing a Poke Ball in a wild battle.

* <mark style="background-color:purple;">**"BeforeCapture"**</mark>\
  Triggers when the player is chooses to throw a Poke Ball, but before the ball is actually thrown.<br>
* <mark style="background-color:purple;">**"AfterCapture"**</mark>\
  Triggers after the player threw a Poke Ball and it successfully captured the target Pokemon.<br>
* <mark style="background-color:purple;">**"FailedCapture"**</mark>\
  Triggers after the player threw a Poke Ball and it failed to capture the target Pokemon.

{% hint style="info" %}
Trigger Extensions: You may extend these keys with a species ID or a type ID to specify that they should only trigger when capturing a specific species, or species of a specific type. For example, <mark style="background-color:purple;">"AfterCapture\_PIKACHU"</mark> would trigger only when capturing a wild Pikachu, where <mark style="background-color:purple;">"FailedCapture\_ELECTRIC"</mark> would trigger only when you failed to capture any wild Electric-type.
{% endhint %}

Page 26:

# Triggers: Switching

These are keys which trigger upon a trainer withdrawing or sending out a new Pokemon.

* <mark style="background-color:purple;">**"BeforeSwitchOut"**</mark>\
  Triggers when a trainer chooses to manually switch out an active Pokemon, but before that Pokemon is actually recalled.<br>
* <mark style="background-color:purple;">**"BeforeSwitchIn"**</mark>\
  Triggers when a trainer sends out a new Pokemon, but before that Pokemon actually enters the field.<br>
* <mark style="background-color:purple;">**"BeforeLastSwitchIn"**</mark>\
  Triggers when a trainer is about to send out the last remaining Pokemon in reserve, but before that Pokemon actually enters the field. If there are multiple trainers on a side, this only counts the last remaining Pokemon for that *side*, not any particular trainer.<br>
* <mark style="background-color:purple;">**"AfterSwitchIn"**</mark>\
  Triggers after a trainer has successfully sent out a new Pokemon.<br>
* <mark style="background-color:purple;">**"AfterLastSwitchIn"**</mark>\
  Triggers after a trainer has successfully sent out the last remaining Pokemon in reserve. If there are multiple trainers on a side, this only counts the last remaining Pokemon for that *side*, not any particular trainer.<br>
* <mark style="background-color:purple;">**"AfterSendOut"**</mark>\
  This is identical to <mark style="background-color:purple;">"AfterSwitchIn"</mark>, except this will trigger whenever a Pokemon is sent out, and not specifically when sent out due to a switch (for example, when sending out the lead Pokemon at the start of battle).<br>
* <mark style="background-color:purple;">**"AfterLastSendOut"**</mark>\
  This is identical to <mark style="background-color:purple;">"AfterLastSwitchIn"</mark>, except this will trigger whenever a trainer sends out the last remaining Pokemon in reserve, and not specifically when sent out due to a switch (for example, when sending out the lead Pokemon at the start of battle). If there are multiple trainers on a side, this only counts the last remaining Pokemon for that *side*, not any particular trainer.

{% hint style="info" %}
Trigger Extensions: You may extend these keys with a species ID or a type ID to specify that they should only trigger when switching a specific species, or species of a specific type. For example, <mark style="background-color:purple;">"BeforeSwitchOut\_MEOWTH"</mark> would trigger only before switching out an active Meowth, where <mark style="background-color:purple;">"AfterSwitchIn\_DARK"</mark> would trigger only after sending out a Dark-type.
{% endhint %}

Page 27:

# Triggers: Megas & Primals

These are keys which trigger upon a battler utilizing Mega Evolution or Primal Reversion.

* <mark style="background-color:purple;">**"BeforeMegaEvolution"**</mark>\
  Triggers when a battler is going to Mega Evolve this turn, but before that Pokemon actually Mega Evolves.<br>
* <mark style="background-color:purple;">**"AfterMegaEvolution"**</mark>\
  Triggers after a battler successfully Mega Evolves.<br>
* <mark style="background-color:purple;">**"BeforePrimalReversion"**</mark>\
  Triggers when a battler is going to Primal Revert, but before that Pokemon actually undergoes Primal Reversion.<br>
* <mark style="background-color:purple;">**"AfterPrimalReversion"**</mark>\
  Triggers when a battler successfully completes its Primal Reversion.

{% hint style="info" %}
Trigger Extensions: You may extend these keys with a species ID or a type ID to specify that they should only trigger when Mega Evolving or Primal Reverting a specific species, or species of a specific type. For example, <mark style="background-color:purple;">"BeforeMegaEvolution\_MAWILE"</mark> would trigger only when a Mawile is about to Mega Evolve, where <mark style="background-color:purple;">"AfterPrimalReversion\_WATER"</mark> would trigger only after a Water-type has Primal Reverted.
{% endhint %}

Page 28:

# Triggers: Move Usage

These are keys which trigger upon a battler using a move.

* <mark style="background-color:purple;">**"BeforeMove"**</mark>\
  Triggers right before a battler's selected move is about to be executed.<br>
* <mark style="background-color:purple;">**"BeforeDamagingMove"**</mark>\
  Triggers right before a battler's selected damage-dealing move is about to be executed.<br>
* <mark style="background-color:purple;">**"BeforePhysicalMove"**</mark>\
  Triggers right before a battler's selected physical move is about to be executed.<br>
* <mark style="background-color:purple;">**"BeforeSpecialMove"**</mark>\
  Triggers right before a battler's selected special move is about to be executed.<br>
* <mark style="background-color:purple;">**"BeforeStatusMove"**</mark>\
  Triggers right before a battler's selected status move is about to be executed.

{% hint style="info" %}
Trigger Extensions 1: You may extend these keys with a species ID or type ID to specify that they should only trigger when a specific species is about to use a move, or when a move of a specific type is about to be used. For example, <mark style="background-color:purple;">"BeforePhysicalMove\_MACHOP"</mark> would trigger only when a Machop is about to use a physical move, where <mark style="background-color:purple;">"BeforeSpecialMove\_PSYCHIC"</mark> would trigger only when a special Psychic-type move is about to be used.&#x20;
{% endhint %}

{% hint style="info" %}
Trigger Extensions 2: For the <mark style="background-color:purple;">"BeforeMove"</mark> key specifically, you can also use a move ID to specify a specific move. For example, <mark style="background-color:purple;">"BeforeMove\_TACKLE"</mark> would only trigger before the move Tackle is used.
{% endhint %}

* <mark style="background-color:purple;">**"AfterMove"**</mark>\
  Triggers right after a battler's selected move is successfully executed.<br>
* <mark style="background-color:purple;">**"AfterDamagingMove"**</mark>\
  Triggers right after a battler's selected damage-dealing move is successfully executed.<br>
* <mark style="background-color:purple;">**"AfterPhysicalMove"**</mark>\
  Triggers right after a battler's selected physical move is successfully executed.<br>
* <mark style="background-color:purple;">**"AfterSpecialMove"**</mark>\
  Triggers right after a battler's selected special move is successfully executed.<br>
* <mark style="background-color:purple;">**"AfterStatusMove"**</mark>\
  Triggers right after a battler's selected status move is successfully executed.

{% hint style="info" %}
Trigger Extensions 1: You may extend these keys with a species ID or type ID to specify that they should only trigger when a specific species is used a move, or when a move of a specific type was used. For example, <mark style="background-color:purple;">"AfterSpecialMove\_GENGAR"</mark> would trigger only when a Gengar used a special move, where <mark style="background-color:purple;">"AfterStatusMove\_FIRE"</mark> would trigger only when a Fire-type status move was used.&#x20;
{% endhint %}

{% hint style="info" %}
Trigger Extensions 2: For the <mark style="background-color:purple;">"AfterMove"</mark> key specifically, you can also use a move ID to specify a specific move. For example, <mark style="background-color:purple;">"AfterMove\_GROWL"</mark> would only trigger after the move Growl was used.
{% endhint %}

Page 29:

# Triggers: Damage Results

These are keys which trigger after the results of a used damage-dealing move has been calculated.

* <mark style="background-color:purple;">**"UserDealtDamage"**</mark>\
  Triggers when the result of the user's move is that it dealt damage to the target.<br>
* <mark style="background-color:purple;">**"UserDamagedSub"**</mark>\
  Triggers when the result of the user's move is that it damaged the target's Substitute, but didn't break it.<br>
* <mark style="background-color:purple;">**"UserBrokeSub"**</mark>\
  Triggers when the result of the user's move is that it broke the target's Substitute.<br>
* <mark style="background-color:purple;">**"UserDealtCriticalHit"**</mark>\
  Triggers when the result of the user's move is that it landed a critical hit.<br>
* <mark style="background-color:purple;">**"UserMoveEffective"**</mark>\
  Triggers when the result of the user's move is that it landed a Super Effective hit.<br>
* <mark style="background-color:purple;">**"UserMoveResisted"**</mark>\
  Triggers when the result of the user's move is that it landed a Not Very Effective hit.<br>
* <mark style="background-color:purple;">**"UserMoveNegated"**</mark>\
  Triggers when the result of the user's move is that it was completely negated by the target (type immunity, Protect, etc.)<br>
* <mark style="background-color:purple;">**"UserMoveDodged"**</mark>\
  Triggers when the result of the user's move is that it missed the target.<br>
* <mark style="background-color:purple;">**"UserHPHalf"**</mark>\
  Triggers when the user of the move has 50% or less of their total HP remaining after their move is executed.<br>
* <mark style="background-color:purple;">**"UserHPLow"**</mark>\
  Triggers when the user of the move has 25% or less of their total HP remaining after their move is executed.<br>
* <mark style="background-color:purple;">**"LastUserHPHalf"**</mark>\
  Triggers when the user of the move has no remaining ally Pokemon in reserve on their side, and it has 50% or less of its total HP remaining after its move is executed.<br>
* <mark style="background-color:purple;">**"LastUserHPLow"**</mark>\
  Triggers when the user of the move has no remaining ally Pokemon in reserve on their side, and it has 25% or less of its total HP remaining after its move is executed.

{% hint style="info" %}
Trigger Extensions: You may extend these keys with a species ID, move ID or type ID to specify that they should only trigger when the user is of a specific species, used a specific move, or used a specific type of move. For example, <mark style="background-color:purple;">"UserDealtDamage\_SCYTHER"</mark> would trigger only when a Scyther was the user of a move that dealt damage, where <mark style="background-color:purple;">"UserMoveEffective\_EMBER"</mark> would trigger only when the user's Ember attack dealt Super Effective damage, and <mark style="background-color:purple;">"UserMoveNegated\_GHOST"</mark> would trigger only when the user's Ghost-type move was ineffective on its target.
{% endhint %}

* <mark style="background-color:purple;">**"TargetTookDamage"**</mark>\
  Triggers when the target took damage as a result of a used move.<br>
* <mark style="background-color:purple;">**"TargetSubDamaged"**</mark>\
  Triggers when the target's Substitute was damaged as a result of a used move, but it didn't break.<br>
* <mark style="background-color:purple;">**"TargetSubBroken"**</mark>\
  Triggers when the target's Substitute was broken as a result of a used move.<br>
* <mark style="background-color:purple;">**"TargetTookCriticalHit"**</mark>\
  Triggers when the target suffered a critical hit as a result of a used move.<br>
* <mark style="background-color:purple;">**"TargetWeakToMove"**</mark>\
  Triggers when the target suffered a Super Effective hit as a result of a used move.<br>
* <mark style="background-color:purple;">**"TargetResistedMove"**</mark>\
  Triggers when the target suffered a Not Very Effective hit as a result of a used move.<br>
* <mark style="background-color:purple;">**"TargetNegatedMove"**</mark>\
  Triggers when the target completely negated a used move, resulting in no damage taken (type immunity, Protect, etc.)<br>
* <mark style="background-color:purple;">**"TargetDodgedMove"**</mark>\
  Triggers when the target evaded a used move, resulting in a miss.<br>
* <mark style="background-color:purple;">**"TargetHPHalf"**</mark>\
  Triggers when the target has 50% or less of their total HP remaining after being hit by a move.<br>
* <mark style="background-color:purple;">**"TargetHPLow"**</mark>\
  Triggers when the target has 25% or less of their total HP remaining after being hit by a move.<br>
* <mark style="background-color:purple;">**"LastTargetHPHalf"**</mark>\
  Triggers when the target has no remaining ally Pokemon in reserve on their side, and it has 50% or less of its total HP remaining after being hit by a move.<br>
* <mark style="background-color:purple;">**"LastTargetHPLow"**</mark>\
  Triggers when the target has no remaining ally Pokemon in reserve on their side, and it has 25% or less of its total HP remaining after being hit by a move.

{% hint style="info" %}
Trigger Extensions: You may extend these keys with a species ID, move ID or type ID to specify that they should only trigger when the target is of a specific species, was targeted by a specific move, or targeted by a specific type of move. For example, <mark style="background-color:purple;">"TargetDodgedMove\_NINJASK"</mark> would trigger only when a Ninjask evaded a move it was targeted with, where <mark style="background-color:purple;">"TargetResistedMove\_WATERGUN"</mark> would trigger only when the target resisted the move Water Gun, and <mark style="background-color:purple;">"TargetTookCriticalHit\_GRASS"</mark> would trigger only when the target suffered a critical hit from a Grass-type move.
{% endhint %}

Page 30:

# Triggers: Battler Condition

These are keys which trigger upon the battler undergoing some kind of change to its condition.

* <mark style="background-color:purple;">**"BattlerHPRecovered"**</mark>\
  Triggers whenever a battler recovers HP for any reason.<br>
* <mark style="background-color:purple;">**"BattlerHPFull"**</mark>\
  Triggers whenever a battler recovers HP for any reason and it results in its HP being restored to full.<br>
* <mark style="background-color:purple;">**"BattlerHPReduced"**</mark>\
  Triggers whenever a battler's HP is reduced for any reason.<br>
* <mark style="background-color:purple;">**"BattlerHPCritical"**</mark>\
  Triggers whenever a battler's HP is reduced for any reason and it results in its HP falling to critically low levels (<= 25% of max HP).<br>
* <mark style="background-color:purple;">**"BattlerFainted"**</mark>\
  Triggers upon a battler's HP falling to zero and fainting.<br>
* <mark style="background-color:purple;">**"LastBattlerFainted"**</mark>\
  Triggers upon the last remaining Pokemon on a side falling to zero HP and fainting.<br>
* <mark style="background-color:purple;">**"BattlerReachedHPCap"**</mark>\
  Triggers upon a battler's HP reaching a specific threshold where it cannot fall any lower.<br>
* <mark style="background-color:purple;">**"BattlerStatusChange"**</mark>\
  Triggers upon a battler being inflicted with a status condition.<br>
* <mark style="background-color:purple;">**"BattlerStatusCured"**</mark>\
  Triggers upon a battler's status condition returning to normal.<br>
* <mark style="background-color:purple;">**"BattlerConfusionStart"**</mark>\
  Triggers upon a battler being inflicted with confusion.<br>
* <mark style="background-color:purple;">**"BattlerConfusionEnd"**</mark>\
  Triggers upon a battler snapping out of confusion.<br>
* <mark style="background-color:purple;">**"BattlerAttractStart"**</mark>\
  Triggers upon a battler becoming infatuated with another Pokemon.<br>
* <mark style="background-color:purple;">**"BattlerAttractEnd"**</mark>\
  Triggers upon a battler shaking off its infatuation.<br>
* <mark style="background-color:purple;">**"BattlerStatRaised"**</mark>\
  Triggers upon a battler's stats being raised by a number of stages.<br>
* <mark style="background-color:purple;">**"BattlerStatLowered"**</mark>\
  Triggers upon a battler's stats being lowered by a number of stages.<br>
* <mark style="background-color:purple;">**"BattlerMoveZeroPP"**</mark>\
  Triggers upon one of a battler's moves falling to zero PP either through using the move, or having it reduced by an effect.

{% hint style="info" %}
Trigger Extensions 1: You may extend these keys with a species ID to specify when a battler of a specific species suffers from one of these conditions. For example, <mark style="background-color:purple;">"BattlerFainted\_PIDGEY"</mark> would trigger only when a Pidgey fainted.&#x20;
{% endhint %}

{% hint style="info" %}
Trigger Extensions 2: For all keys related to HP or fainting, you may also use a type ID to specify a species of a specific type. For example, <mark style="background-color:purple;">"BattlerHPCritical\_NORMAL"</mark> would trigger only when a Normal-type's HP falls to critical levels.
{% endhint %}

{% hint style="info" %}
Trigger Extensions 3: For the <mark style="background-color:purple;">"BattlerStatusChange"</mark> key specifically, you may also use a status ID to specify when a specific status condition is inflicted. For example, <mark style="background-color:purple;">"BattlerStatusChange\_BURN"</mark> would trigger only when a battler is inflicted with a Burn.&#x20;
{% endhint %}

{% hint style="info" %}
Trigger Extensions 4: For the <mark style="background-color:purple;">"BattlerStatRaised"</mark> and <mark style="background-color:purple;">"BattlerStatLowered"</mark> keys specifically, you may also use a stat ID to specify a specific stat that was raised or lowered, respectively. For example, <mark style="background-color:purple;">"BattlerStatRaised\_ATTACK"</mark> would trigger only when a battler's Attack stat has been raised.
{% endhint %}

{% hint style="info" %}
Trigger Extensions 5: For the <mark style="background-color:purple;">"BattlerMoveZeroPP"</mark> key specifically, you may also use a move ID or type ID to specify when a specific move or move of a specific type runs out of PP. For example, <mark style="background-color:purple;">"BattlerMoveZeroPP\_HYPERBEAM"</mark> would trigger only when a battler's Hyper Beam runs out of PP, where <mark style="background-color:purple;">"BattlerMoveZeroPP\_ICE"</mark> would trigger only when a battler's Ice-type move runs out of PP.
{% endhint %}

Page 31:

# Triggers: Battler Condition

These are keys which trigger upon the battler undergoing some kind of change to its condition.

* <mark style="background-color:purple;">**"BattlerHPRecovered"**</mark>\
  Triggers whenever a battler recovers HP for any reason.<br>
* <mark style="background-color:purple;">**"BattlerHPFull"**</mark>\
  Triggers whenever a battler recovers HP for any reason and it results in its HP being restored to full.<br>
* <mark style="background-color:purple;">**"BattlerHPReduced"**</mark>\
  Triggers whenever a battler's HP is reduced for any reason.<br>
* <mark style="background-color:purple;">**"BattlerHPCritical"**</mark>\
  Triggers whenever a battler's HP is reduced for any reason and it results in its HP falling to critically low levels (<= 25% of max HP).<br>
* <mark style="background-color:purple;">**"BattlerFainted"**</mark>\
  Triggers upon a battler's HP falling to zero and fainting.<br>
* <mark style="background-color:purple;">**"LastBattlerFainted"**</mark>\
  Triggers upon the last remaining Pokemon on a side falling to zero HP and fainting.<br>
* <mark style="background-color:purple;">**"BattlerReachedHPCap"**</mark>\
  Triggers upon a battler's HP reaching a specific threshold where it cannot fall any lower.<br>
* <mark style="background-color:purple;">**"BattlerStatusChange"**</mark>\
  Triggers upon a battler being inflicted with a status condition.<br>
* <mark style="background-color:purple;">**"BattlerStatusCured"**</mark>\
  Triggers upon a battler's status condition returning to normal.<br>
* <mark style="background-color:purple;">**"BattlerConfusionStart"**</mark>\
  Triggers upon a battler being inflicted with confusion.<br>
* <mark style="background-color:purple;">**"BattlerConfusionEnd"**</mark>\
  Triggers upon a battler snapping out of confusion.<br>
* <mark style="background-color:purple;">**"BattlerAttractStart"**</mark>\
  Triggers upon a battler becoming infatuated with another Pokemon.<br>
* <mark style="background-color:purple;">**"BattlerAttractEnd"**</mark>\
  Triggers upon a battler shaking off its infatuation.<br>
* <mark style="background-color:purple;">**"BattlerStatRaised"**</mark>\
  Triggers upon a battler's stats being raised by a number of stages.<br>
* <mark style="background-color:purple;">**"BattlerStatLowered"**</mark>\
  Triggers upon a battler's stats being lowered by a number of stages.<br>
* <mark style="background-color:purple;">**"BattlerMoveZeroPP"**</mark>\
  Triggers upon one of a battler's moves falling to zero PP either through using the move, or having it reduced by an effect.

{% hint style="info" %}
Trigger Extensions 1: You may extend these keys with a species ID to specify when a battler of a specific species suffers from one of these conditions. For example, <mark style="background-color:purple;">"BattlerFainted\_PIDGEY"</mark> would trigger only when a Pidgey fainted.&#x20;
{% endhint %}

{% hint style="info" %}
Trigger Extensions 2: For all keys related to HP or fainting, you may also use a type ID to specify a species of a specific type. For example, <mark style="background-color:purple;">"BattlerHPCritical\_NORMAL"</mark> would trigger only when a Normal-type's HP falls to critical levels.
{% endhint %}

{% hint style="info" %}
Trigger Extensions 3: For the <mark style="background-color:purple;">"BattlerStatusChange"</mark> key specifically, you may also use a status ID to specify when a specific status condition is inflicted. For example, <mark style="background-color:purple;">"BattlerStatusChange\_BURN"</mark> would trigger only when a battler is inflicted with a Burn.&#x20;
{% endhint %}

{% hint style="info" %}
Trigger Extensions 4: For the <mark style="background-color:purple;">"BattlerStatRaised"</mark> and <mark style="background-color:purple;">"BattlerStatLowered"</mark> keys specifically, you may also use a stat ID to specify a specific stat that was raised or lowered, respectively. For example, <mark style="background-color:purple;">"BattlerStatRaised\_ATTACK"</mark> would trigger only when a battler's Attack stat has been raised.
{% endhint %}

{% hint style="info" %}
Trigger Extensions 5: For the <mark style="background-color:purple;">"BattlerMoveZeroPP"</mark> key specifically, you may also use a move ID or type ID to specify when a specific move or move of a specific type runs out of PP. For example, <mark style="background-color:purple;">"BattlerMoveZeroPP\_HYPERBEAM"</mark> would trigger only when a battler's Hyper Beam runs out of PP, where <mark style="background-color:purple;">"BattlerMoveZeroPP\_ICE"</mark> would trigger only when a battler's Ice-type move runs out of PP.
{% endhint %}

Page 32:

# Triggers: End of Effects

These are keys which trigger after some kind of battle effect has ended.

* <mark style="background-color:purple;">**"WeatherEnded"**</mark>\
  Triggers upon a weather condition ending.<br>
* <mark style="background-color:purple;">**"TerrainEnded"**</mark>\
  Triggers upon a battle terrain condition ending.<br>
* <mark style="background-color:purple;">**"FieldEffectEnded"**</mark>\
  Triggers upon a field effect ending, such as Trick Room or Gravity.<br>
* <mark style="background-color:purple;">**"TeamEffectEnded"**</mark>\
  Triggers upon a team effect ending, such as Reflect or Light Screen.<br>
* <mark style="background-color:purple;">**"BattlerEffectEnded"**</mark>\
  Triggers upon a battler effect ending, such as Disable or Encore.

{% hint style="info" %}
Trigger Extensions: You may extend these keys with a specific effect ID to specify that they should only trigger when a specific effect ends. For example, <mark style="background-color:purple;">"WeatherEnded\_Rain"</mark> would trigger only when it stopped raining, where <mark style="background-color:purple;">"TeamEffectEnded\_Tailwind"</mark> would trigger only when the Tailwind effect ended on one side. Only effects that count down each turn are compatible extensions.
{% endhint %}

Page 33:

# Triggers: End of Battle

These are keys which trigger at the end of a battle.

* <mark style="background-color:purple;">**"BattleEnd"**</mark>\
  Triggers upon a battle ending, regardless of outcome.<br>
* <mark style="background-color:purple;">**"BattleEndWin"**</mark>\
  Triggers upon a battle ending where the player won.<br>
* <mark style="background-color:purple;">**"BattleEndLoss"**</mark>\
  Triggers upon a battle ending where the player lost.<br>
* <mark style="background-color:purple;">**"BattleEndDraw"**</mark>\
  Triggers upon a battle ending where it ended in a draw.<br>
* <mark style="background-color:purple;">**"BattleEndForfeit"**</mark>\
  Triggers upon a trainer battle ending where the player forfeited the match (Battle Tower-style battles only).<br>
* <mark style="background-color:purple;">**"BattleEndRun"**</mark>\
  Triggers upon a wild battle ending where the player chose to run.<br>
* <mark style="background-color:purple;">**"BattleEndFled"**</mark>\
  Triggers upon a wild battle ending where the wild Pokemon fled.<br>
* <mark style="background-color:purple;">**"BattleEndCapture"**</mark>\
  Triggers upon a wild battle ending where the player captured at least one Pokemon.

{% hint style="danger" %}
Trigger Extensions: These keys are not compatible with any trigger extensions.
{% endhint %}

Page 34:

# Triggers: Variable

These are keys which only trigger when a special midbattle variable is changed.

* <mark style="background-color:purple;">**"Variable\_#"**</mark>\
  Triggers upon the midbattle variable reaching a specified number (#).<br>
* <mark style="background-color:purple;">**"VariableUp"**</mark>\
  Triggers upon the midbattle variable being increased.<br>
* <mark style="background-color:purple;">**"VariableDown"**</mark>\
  Triggers upon the midbattle variable being decreased.<br>
* <mark style="background-color:purple;">**"VariableOver\_#"**</mark>\
  Triggers upon the midbattle variable reaching a value that is greater than a specified number (#).<br>
* <mark style="background-color:purple;">**"VariableUnder\_#"**</mark>\
  Triggers upon the midbattle variable reaching a value that is less than a specified number (#).

{% hint style="warning" %}
Trigger Extensions: These keys are not compatible with any trigger extensions except for the ones listed in the "Extensions: Frequency" subsection.
{% endhint %}

Page 35:

# Triggers: Choices

These are keys which only trigger when the player selects a choice during a midbattle text or speech event.

* <mark style="background-color:purple;">**"Choice\_\id\\\_#"**</mark>\
  Triggers upon the player selecting a specified choice index (#) for a question with a specified ID (\id\\).<br>
* <mark style="background-color:purple;">**"ChoiceRight\_\id\\"**</mark>\
  Triggers upon the player making the correct choice for a question with a specified ID (\id\\).<br>
* <mark style="background-color:purple;">**"ChoiceWrong\_\id\\"**</mark>\
  Triggers upon the player making the incorrect choice for a question with a specified ID (\id\\).

{% hint style="danger" %}
Trigger Extensions: These keys are not compatible with any trigger extensions.
{% endhint %}

Page 36:

# Triggers: Extensions

Most keys can be extended by adding an underscore followed by additional qualifiers. I already noted within each Trigger Key subsection specific extensions that are compatible with those keys. However, there are more general extensions you may include to provide additional utility. These extensions help to narrow down more specifically when they should trigger, or by which trainer or battler. <br>

Page 37:

# Extensions: User

These extensions specify the activation of a Trigger Key from a particular perspective. For example, attaching the <mark style="background-color:orange;">"\_player"</mark> extension would only activate Trigger Key's from the player's perspective, while attaching the <mark style="background-color:orange;">"\_foe"</mark> extension would only activate Trigger Keys from the opponent's perspective.\
\
However, not every key is compatible with these extensions. Since these extensions are used to specify the perspective of who has activated a specific key, any keys that occur during a point in battle that don't happen from any particular perspective aren't compatible.

For example, <mark style="background-color:purple;">"TargetHPLow"</mark> is compatible with these extensions, since it is possible to specify a particular battler that may have low HP. However, <mark style="background-color:purple;">"BattleEnd"</mark> would not be compatible with these extensions, since the end of the battle doesn't occur from any particular perspective, it's simply part of the structure of battle itself.\
\
As a rule of thumb, all of the keys in the subsections "Triggers: End of Battle", "Triggers: Variable", and "Triggers: Choices" are not compatible with these extensions. In addition, none of the keys in the "Wild Capture" subsection are compatible with these extensions since only the player is ever capable of capturing a Pokemon, so there isn't ever a need to specify any other perspective for those Trigger Keys.\
\
With all of that out of the way, here are all of the possible user extensions that can be used:

<details>

<summary><mark style="background-color:orange;"><strong>"_player"</strong></mark></summary>

Add this extension to a key so that it may only trigger when activated by one of the player's Pokemon. For example, <mark style="background-color:purple;">"BeforeMove"</mark> would trigger before any Pokemon uses a move, but <mark style="background-color:purple;">"BeforeMove\_player"</mark> would only ever trigger before one of the *player's* Pokemon uses a move.

</details>

<details>

<summary><mark style="background-color:orange;"><strong>"_player1"</strong></mark></summary>

Add this extension to a key so that it may only trigger when activated by the Pokemon that occupies the left-most position on the player's side (index 0). For example, <mark style="background-color:purple;">"BeforeMove\_player"</mark> would trigger before any of the Pokemon on the player's side uses a move, but <mark style="background-color:purple;">"BeforeMove\_player1"</mark> would only ever trigger before the first Pokemon on the player's side uses a move.

</details>

<details>

<summary><mark style="background-color:orange;"><strong>"_player2"</strong></mark></summary>

Add this extension to a key so that it may only trigger when activated by the Pokemon that occupies the right-most position (doubles) or center position (triples) on the player's side (index 2). For example, <mark style="background-color:purple;">"BeforeMove\_player1"</mark> would trigger before the first Pokemon on the player's side uses a move, but <mark style="background-color:purple;">"BeforeMove\_player2"</mark> would only ever trigger before the second Pokemon on the player's side uses a move. This extension does nothing in single battles.

</details>

<details>

<summary><mark style="background-color:orange;"><strong>"_player3"</strong></mark></summary>

Add this extension to a key so that it may only trigger when activated by the Pokemon that occupies the right-most position on the player's side (index 4). For example, <mark style="background-color:purple;">"BeforeMove\_player2"</mark> would trigger before the second Pokemon on the player's side uses a move, but <mark style="background-color:purple;">"BeforeMove\_player3"</mark> would only ever trigger before the third Pokemon on the player's side uses a move. This extension does nothing in single or double battles.

</details>

<details>

<summary><mark style="background-color:orange;"><strong>"_foe"</strong></mark></summary>

Add this extension to a key so that it may only trigger when activated by one of the opponent's Pokemon. For example, <mark style="background-color:purple;">"AfterMove"</mark> would trigger after any Pokemon uses a move, but <mark style="background-color:purple;">"AfterMove\_foe"</mark> would only ever trigger after one of the *opponent's* Pokemon uses a move.

</details>

<details>

<summary><mark style="background-color:orange;"><strong>"_foe1"</strong></mark></summary>

Add this extension to a key so that it may only trigger when activated by the Pokemon that occupies the right-most position on the opponent's side (index 1). For example, <mark style="background-color:purple;">"AfterMove\_foe"</mark> would trigger after any of the Pokemon on the opponent's side uses a move, but <mark style="background-color:purple;">"AfterMove\_foe1"</mark> would only ever trigger after the first Pokemon on the opponent's side uses a move.

</details>

<details>

<summary><mark style="background-color:orange;"><strong>"_foe2"</strong></mark></summary>

Add this extension to a key so that it may only trigger when activated by the Pokemon that occupies the left-most position (doubles) or center position (triples) on the opponent's side (index 3). For example, <mark style="background-color:purple;">"AfterMove\_foe1"</mark> would trigger after the first Pokemon on the opponent's side uses a move, but <mark style="background-color:purple;">"AfterMove\_foe2"</mark> would only ever trigger after the second Pokemon on the opponent's side uses a move. This extension does nothing in single battles.

</details>

<details>

<summary><mark style="background-color:orange;"><strong>"_foe3"</strong></mark></summary>

Add this extension to a key so that it may only trigger when activated by the Pokemon that occupies the left-most position on the opponent's side (index 5). For example, <mark style="background-color:purple;">"AfterMove\_foe2"</mark> would trigger after the second Pokemon on the opponent's side uses a move, but <mark style="background-color:purple;">"AfterMove\_foe3"</mark> would only ever trigger after the third Pokemon on the opponent's side uses a move. This extension does nothing in single or double battles.

</details>

<details>

<summary><mark style="background-color:orange;"><strong>"_ally"</strong></mark></summary>

Add this extension to a key so that it may only trigger when activated by a Pokemon owned by a partner trainer who is teamed up with the player. For example, <mark style="background-color:purple;">"BattlerFainted\_player"</mark> would trigger upon any Pokemon on the player's side fainting, but <mark style="background-color:purple;">"BattlerFainted\_ally"</mark> would only ever trigger upon a Pokemon owned by the player's partner fainting. Unlike "player" and "foe", there is only a single "ally" extension, since the player cannot ever have more than one partner trainer with them at a time, anyway.

</details>

Page 38:

# Extensions: Frequency

These extensions add extra utility to the Trigger Key it's attached to by allowing you to alter when they may trigger, and/or how often. These extensions can be combined with the extensions listed in the "Extensions: User" subsection to add an extra layer of customization to each key. However, not every key is compatible with these extensions, although most are. Since these extensions are used to alter the frequency of a key triggering, any keys that can only ever be triggered once per battle are not compatible with these extensions.&#x20;

For example, the <mark style="background-color:purple;">"BeforeItemUse"</mark> key is compatible with these extensions since it's possible that multiple items may be used in a battle, so it makes sense that you would want to add extensions to repeat or randomize when this key may be triggered. However, the <mark style="background-color:purple;">"BattleEnd"</mark> key is not compatible with these extensions, since each battle obviously only ends once, so it makes no sense to randomize or repeat when that key could trigger.

As a rule of thumb, all of the keys in the subsections "Triggers: End of Battle" and "Triggers: Choices" are not compatible with these extensions.

With all of that out of the way, here are all of the possible frequency extensions that can be used:

<details>

<summary><mark style="background-color:orange;"><strong>"_repeat"</strong></mark></summary>

Add this extension to a key so that it will continuously repeat indefinitely. Normally, each trigger in a midbattle hash will only trigger once. With this extension however, it will continuously trigger for the entire battle. For example, <mark style="background-color:purple;">"TargetTookDamage\_foe"</mark> would only trigger the first time an opponent's Pokemon took damage from an attack, and then never again for that battle. While <mark style="background-color:purple;">"TargetTookDamage\_foe\_repeat"</mark> would continuously trigger each time any of the opponent's Pokemon took damage during this battle.

</details>

<details>

<summary><mark style="background-color:orange;"><strong>"_random"</strong></mark></summary>

Add this extension to a key so that it will randomly trigger instead of being guaranteed to trigger. For example, <mark style="background-color:purple;">"UserDealtDamage\_player"</mark> is guaranteed to trigger upon one of the player's Pokemon dealing damage to a target with an attack, but <mark style="background-color:purple;">"UserDealtDamage\_player\_random"</mark> would only randomly have a chance to trigger when one of the player's Pokemon deals damage. You can extend this even further by adding another underscore followed by a number to specify the odds of this occurring. For example, <mark style="background-color:purple;">"UserDealtDamage\_player\_random\_25"</mark> would have a 25% chance to randomly trigger when the player's Pokemon deals damage. If no number is added to this extension, this rate defaults to 50%.

</details>

<details>

<summary><mark style="background-color:orange;"><strong>"_repeat_random"</strong></mark></summary>

This extension is a combo of both the <mark style="background-color:orange;">"\_repeat"</mark> and <mark style="background-color:orange;">"\_random"</mark> extensions above. Add this extension to a key so that it will continuously repeat, but at randomized intervals. For example, <mark style="background-color:purple;">"TurnEnd\_player\_repeat"</mark> would continuously trigger at the end of every turn for the player's Pokemon, while <mark style="background-color:purple;">"TurnEnd\_player\_random"</mark> would randomly trigger once at the end of their turn. However, <mark style="background-color:purple;">"TurnEnd\_player\_repeat\_random"</mark> would continuously trigger at the end of their every turn, but it would only have a random chance of triggering each time. Like with the regular <mark style="background-color:orange;">"\_random"</mark> extension, you can specify the rate at which this random chance occurs by attaching an additional underscore, followed by a number. For example, <mark style="background-color:purple;">"TurnEnd\_player\_repeat\_random\_75"</mark> would continuously trigger at the end of their every turn with a 75% success rate. If no number is added to this extension, this rate defaults to 50%.

</details>

***

<mark style="background-color:yellow;">**Turn Count Extensions**</mark>\
These frequency extensions are special in that they can only apply to the keys listed in the "Triggers: Round Phases", "Triggers: Battler Turns" and "Triggers: Variable" subsections. This is because these extensions determine when they trigger based on the number value that a Trigger Key keeps track of, such as the battle turn count, an individual battler's turn count, or the value of a variable.

<details>

<summary><mark style="background-color:orange;"><strong>"_repeat_odd"</strong></mark></summary>

Add this extension to a key so that it will continuously repeat in battle, but only when the value that the key is tracking is an odd number. For example, <mark style="background-color:purple;">"RoundStartCommand\_foe\_repeat"</mark> would trigger at the start of the Command Phase of every turn, while <mark style="background-color:purple;">"RoundStartCommand\_foe\_repeat\_odd"</mark> would repeatedly trigger only on odd-numbered turns.

</details>

<details>

<summary><mark style="background-color:orange;"><strong>"_repeat_even"</strong></mark></summary>

Add this extension to a key so that it will continuously repeat in battle, but only when the value that the key is tracking is an even number. For example, <mark style="background-color:purple;">"VariableUp"</mark> would trigger whenever the midbattle variable is increased, while <mark style="background-color:purple;">"VariableUp\_repeat\_even"</mark> would repeatedly trigger only when the value of the variable is increased to an even number.

</details>

<details>

<summary><mark style="background-color:orange;"><strong>"_repeat_every_#"</strong></mark></summary>

Add this extension to a key so that it will continuously repeat in battle, but only when the value that the key is tracking is divisible by the number entered where <mark style="background-color:orange;">#</mark> is. For example, <mark style="background-color:purple;">"RoundEnd\_player\_repeat"</mark> would trigger at the end of each round, while <mark style="background-color:purple;">"RoundEnd\_player\_repeat\_every\_3"</mark> would repeatedly trigger only on turns that are divisible by 3. This means turns 3, 6, 9, etc. will trigger this key, while all other turns will not.

</details>

Page 39:

# Command Keys

Trigger Keys are only half of the equation, however. Once you have a Trigger Key set that will trigger at a specific point in battle, you need to set something that you want to actually *happen* at that point in battle. This is done by setting yet another hash as this Trigger Key's value. In this hash, you can set a whole new set of keys with their own set of values. These keys are what actually prompt specific commands to be carried out. Because of this, I will refer to these set of keys as "Command Keys".&#x20;

In the following subsections, I will go over every possible Command Key, how they can be set, and what actions they will perform. Command Keys which have related effects or affect similar areas of battle have been grouped together to make them easier to find.

Note that Command Keys are always strings, and always begin with a lower case letter.

Page 40:

# Commands: Text & Speech

These are keys which trigger text or trainer dialogue to be displayed, or editing the display of trainer sprites or text windows during dialogue.

<details>

<summary><mark style="background-color:blue;">"text"</mark> => <mark style="background-color:yellow;">String or Array</mark></summary>

This is used to display custom battle messages. This can be entered either as a single string, or an array containing multiple strings to display multiple boxes of text. You can use `{1}` in these strings to refer to the battler name, or `{2}` to refer to the name of the battler's trainer (if any). If you want to refer to the player's name specifically, you can use `\\PN`. \
\
If set as an array, you may also include battler indexes prior to a string to change the focus of the text. For example, if entered as `[0, "{1} wont back down!"]`, the `{1}` in the string will refer to the name of the battler at index 0, which would be the player's Pokemon, even if the battler who initially triggered this was the opponent. If you don't want to set specific battler indexes, you can also use the following symbols to more generally set which battler should be the user of the focus: `:Self`, `:Ally`, `:Ally2`, `:Opposing`, `:OpposingAlly`, `:OpposingAlly2`.\
\
You may also include the symbol `:Choices` in the array to display dialogue choices for the player to select from. However, these choices must first be set up with the <mark style="background-color:blue;">"setChoices"</mark> key.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"speech"</strong></mark> => <mark style="background-color:yellow;">String or Array</mark></summary>

This works identically to how the <mark style="background-color:blue;">"text"</mark> key works, except this will trigger dialogue animations. This includes cinematic black bars on the top and bottom of the screen, battle UI will be hidden, and a trainer sprite will appear on screen to speak the lines of text (if it's an opposing trainer).&#x20;

When a speaker is talking, their name will appear above their dialogue boxes. In wild battles, the wild Pokemon will be considered the opposing speaker, so no trainer will slide on screen since the wild battler will already be on screen. Trainers who appear on the player's side will never slide on screen, so you will only ever see dialogue boxes for those trainers, even if they're a partner trainer and not the player.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"setChoices"</strong></mark> => <mark style="background-color:yellow;">Array</mark></summary>

This is used to set up branching dialogue choices which can then be used by both the <mark style="background-color:blue;">"text"</mark> and <mark style="background-color:blue;">"speech"</mark> keys. This must be set up *before* the text or speech key in which you want the player to select from these choices. Then, that text or speech key must be set to an array containing a string that asks the player the question, followed by the symbol `:Choices`. This symbol will indicate that the choices you set up in this key should be displayed. To set up your list of choices with this key, this must be entered as an array that contains the following data in this order:

* <mark style="background-color:yellow;">Symbol ID</mark>. This can be anything you want, as long as it's a unique symbol. This is meant to identify this specific set of choices. For example, if you have a set of choices asking the player for their favorite color, you might want to name this something like `:colors`. This ID is important, because this is what the "Choice" Trigger Keys use to determine when to trigger.<br>
* <mark style="background-color:yellow;">Answer Index</mark>. This stores what the correct answer to this list of choices should be. For example, if you have a set of choices asking the player what color the sky is, and the possible choices are "Red", "Green", "Blue" and "Yellow", then you would set the answer index to 3, since the correct answer is Blue, which is the third choice. If the set of choices doesn't have a correct answer, such as the question "What's your favorite color?", then you just set this answer index to `nil`.<br>
* <mark style="background-color:yellow;">Choices</mark>. Finally, the next entries should be the actual choices you want the player to choose between, which can just be entered as strings. For example, if the player is being asked "What's your favorite color?", the choices you set here might look something like:\
  `[:colors, nil, "Red", "Green", "Blue", "Yellow"]`\
  If you want some sort of response to be displayed upon the player making a selection, then you may set your choices as a hash instead of a series of strings. This will make it so there will be some sort of reaction to the choice the player makes. For example, if the player is being asked "What color is the sky?", the choices you set here might look something like this:\
  `[:colors, 3, {`  \
  &#x20; `"Red"    => "Huh? No...maybe during sunset?",`\
  &#x20; `"Green"  => "I don't think I've ever seen a green sky...",`\
  &#x20; `"Blue"   => "Ding! Ding! Correct!",`\
  &#x20; `"Yellow" => "Huh? No...maybe during a sunrise?" }]`

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"setSpeaker"</strong></mark> => <mark style="background-color:yellow;">Integer, Symbol, or Array</mark></summary>

This is used to manually set a specific speaker to begin speaking. This can be used if you want to swap out the current speaker for another one within one seamless speech event without having to end the animation and restart it again for each different speaker that you want to say a line of dialogue. For example, if you set this to an integer, you can set the index of a specific battler, and the owner of that battler will slide on screen to speak. If the owner is on the player's side (or a wild Pokemon), then any currently active speaker will be hidden, and the dialogue boxes will change to indicate the new speaker.\
\
Alternatively, you may also use one of the following symbols if you want to more generally assign an index: `:Self`, `:Ally`, `:Ally2`, `:Opposing`, `:OpposingAlly`, `:OpposingAlly2`. \
\
If you want the actual Pokemon to be the speaker (even if it's owned by a trainer and not wild), then you can set this symbol to `:Battler`, instead. If you want to hide the current speaker sprite altogether, you can set this symbol to `:Hide`.\
\
You can even set up a speaker to slide on screen who isn't even participating in this battle. You may set the symbol ID of any trainer type to have the sprite of that trainer type slide on screen to speak. For example, if you set this to `:LEADER_Brock`, Brock may slide on screen to speak, even if you aren't even currently battling him.\
\
The same can even be done with Pokemon sprites. If you enter a species ID, a sprite of that Pokemon will slide on screen to speak, even if you aren't battling that species. For Pokemon sprites only, you can expand on this even further by setting up an array. If you do, you can set the following data in this array in this order to customize the Pokemon sprite that will appear on screen:

* <mark style="background-color:yellow;">Species ID</mark>
* <mark style="background-color:yellow;">Form number</mark>
* <mark style="background-color:yellow;">Gender</mark> (0 = Male, 1 = Female)
* <mark style="background-color:yellow;">Shiny</mark> (Boolean)

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"editSpeaker"</strong></mark> => <mark style="background-color:yellow;">Integer, Symbol or Array</mark></summary>

This accepts all of the same arguments and does all of the same things as <mark style="background-color:blue;">"setSpeaker"</mark>, except this can't be used to slide a new speaker sprite on screen. Instead, all this does is update the current speaker sprite to display a different graphic.&#x20;

This has a niche use, but is mainly used to update a trainer's sprite while they're talking to display a different "frame", if you have multiple sprites of the same trainer. This can be used to convey emotion while the trainer is speaking certain lines, or to create mini animations by stringing multiple different frames of the same trainer together back to back. You don't have to use it this way, though. You can change the speaker's sprite into an entirely different one, if you'd like.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"editWindow"</strong></mark> => <mark style="background-color:yellow;">String, Array or Symbol</mark></summary>

This is used to customize the name plates and dialogue windowskin of the current speaker. Normally when a speaker is talking, the windowskin of their dialogue boxes will match their gender. Male speakers will have a blue windowskin, while female speakers will have a red windowskin, and genderless speakers will use the default windowskin. However, you can edit the windowskin of these dialogue boxes as well as the speaker's name that appears in the name plate with this key.&#x20;

Setting this to a string will change the speaker's display name that appears in the name plate to the entered string. This can be used if you want to give this speaker a custom name, or if you want to suggest someone else is speaking off screen. If you want to edit the windowskin of the speaker's dialogue boxes, then you must enter this as an array where the first item in the array is the speaker's name (or nil if you want to keep the default name), and the second item in the array can be the name of the specific windowskin file you want to use that is found in the `Graphics/Windowskins` folder. The color of the dialogue text will change to suit the colors of the windowskin you set here.\
\
If you would like to hide all name plates and dialogue boxes entirely, then you can instead set this to the symbol `:Hide`. This will hide these displays completely, and any text will simply appear over the black bar at the bottom of the screen. If you want to display the default name plate and dialogue boxes for this speaker again, you may set this to the symbol `:Show`.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"endSpeech"</strong></mark> => <mark style="background-color:yellow;">Boolean</mark></summary>

This prematurely ends cinematic speech when set to `true`. Most of the time, cinematic speech animations will end on their own when appropriate. However, there are niche situations where you might want to end the animation early to do something else without the trainer on screen, such as play a sound effect or animation; in which case you may need to use this key.

</details>

Page 41:

# Commands: Audio & Animation

These are keys which trigger sound effects, music files, or animations to play.

<details>

<summary><mark style="background-color:blue;"><strong>"playSE"</strong></mark> => <mark style="background-color:yellow;">String</mark></summary>

Plays a sound effect. Set as a string containing the file name of the desired sound effect found in the `Audio/SE` folder.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"playCry"</strong></mark> => <mark style="background-color:yellow;">Integer or Symbol</mark></summary>

Plays the cry of a Pokemon. You can set this as an integer to play the cry of the Pokemon found at a specific battler index. For example, setting this to 1 would play the cry of the opponent's Pokemon at index 1. If you don't want to set specific battler indexes, you can also use the following symbols to more generally set which battler's cry should play: `:Self`, `:Ally`, `:Ally2`, `:Opposing`, `:OpposingAlly`, `:OpposingAlly2`.\
\
Alternatively, you can instead set this to a species ID to play the cry of any species you want, even if that species isn't currently participating in battle.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"changeBGM"</strong></mark> => <mark style="background-color:yellow;">String or Array</mark></summary>

Changes the current BGM being played to a different track of your choosing. You can set this to a string containing the file name of that music track located in the `Audio/BGM` folder. Alternatively, if you set this as an array, you can customize how this track will play. This array should contain the following data, in this order:

* <mark style="background-color:yellow;">BGM file name</mark> (String)
* <mark style="background-color:yellow;">Fade time</mark> (Integer). This will determine how long the current BGM will take to fade out (in seconds) before the new one begins playing.
* <mark style="background-color:yellow;">Volume</mark> (Integer or nil). This will determine the volume level of the new BGM. You can omit this or set this to nil for the default volume.
* <mark style="background-color:yellow;">Pitch</mark> (Integer or nil). This will determine the pitch level of the new BGM. You can omit this or set this to nil for the default pitch.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"endBGM"</strong></mark> => <mark style="background-color:yellow;">Float</mark> </summary>

Fades out and ends the current BGM being played. This must be set to a float number, which just means any number with a decimal place. This number determines how long (in seconds) the currently playing music will fade out before it completely ends. For example, setting this to `1.5` will have the current music fade out for one and a half seconds before it ends. If you want the current music to end immediately without fading, you would just set this to `0.0`.

Once the music ends, the battle will continue in complete silence. There may be times where you may want this to happen, for some reason. However, if you want to restore music to the battle, you may use <mark style="background-color:blue;">**"resumeBGM"**</mark> to restore the previous BGM, or <mark style="background-color:blue;">**"changeBGM"**</mark> to begin playing a brand new track.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"pauseAndPlayBGM"</strong></mark><strong> => </strong><mark style="background-color:yellow;"><strong>String</strong></mark></summary>

Pauses the current battle music and remembers its position before playing a new BGM. You can set this to a string containing the file name of that music track located in the `Audio/BGM` folder to start playing that BGM.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"resumeBGM"</strong></mark><strong> => </strong><mark style="background-color:yellow;"><strong>Boolean</strong></mark></summary>

Ends the current BGM, and resumes playing a previously paused BGM from its saved position. This won't do anything if there isn't any music track that has been previously paused with <mark style="background-color:blue;">"pauseAndPlayBGM"</mark>.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"playAnim"</strong></mark> => <mark style="background-color:yellow;">String, Symbol, or Array</mark></summary>

This can be used to make a certain animation play. If this is set to a String, this will attempt to play a common animation by that name (for example "StatUp" will play the stat increase animation). If this is set to a move ID Symbol, this will attempt to play the animation of that move. The targets for these animations will automatically be decided based on which Pokemon triggered the specific Trigger Key this command is located in. If you'd wish to manually set who the user and/or target of this animation should be, you may do so by setting this as an array which contains the following data in this order:

* <mark style="background-color:yellow;">Animation ID</mark> (String or Symbol)
* <mark style="background-color:yellow;">User ID</mark> (Integer or Symbol). This is the battler index of the user of the animation. If there is no user for this animation (something that happens independently of any particular battler, like Trick Room or weather), then a user isn't required. If you don't want to set specific battler indexes, you can also use the following symbols to more generally set which battler should be the user of the animation: `:Self`, `:Ally`, `:Ally2`, `:Opposing`, `:OpposingAlly`, `:OpposingAlly2`.
* <mark style="background-color:yellow;">Target ID</mark> (Integer or Symbol). This is the battler index of the target of the animation. If there is no target for this animation (an animation that only affects the user, or happens independently of any particular battler), then a target isn't required. If you don't want to set specific battler indexes, you can also used the same symbols listed in the User ID section above to more generally set which battler should be the target of the animation.

</details>

Page 42:

# Commands: Utilities

These are keys which trigger general utilities, such as creating a pause between actions, delaying an action until a certain point, or setting specific switches or variables.

<details>

<summary><mark style="background-color:blue;"><strong>"setBattler"</strong></mark> => <mark style="background-color:yellow;">Integer or Symbol</mark></summary>

Changes the battler to be used as the focus of many of the commands listed below and in other sections. By default, the battler that these commands apply to is determined by whichever battler triggered the initial Trigger Key. For example, if the Trigger Key is <mark style="background-color:purple;">"UserDealtDamage"</mark>, then the default battler is whoever is the user of the move that just dealt damage. With this key, however, you can manually set which battler should be the focus, regardless of what the default battler may be.&#x20;

To do this, you may simply set this to a battler index to have that battler be flagged as the new focus. Alternatively, you may also use one of the following symbols if you want to more generally assign which battler should be the new focus: `:Self`, `:Ally`, `:Ally2`, `:Opposing`, `:OpposingAlly`, `:OpposingAlly2`.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"wait"</strong></mark> => <mark style="background-color:yellow;">Integer or Float</mark></summary>

Freezes the battle scene and prevents anything from happening for a set number of seconds. You can enter a float number such as 0.5 for a half second pause.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"pause"</strong></mark> => <mark style="background-color:yellow;">Integer or Float</mark></summary>

Creates a delay that pauses any further actions from occurring for a set number of seconds. You can enter a float number such as 0.5 for a half second pause.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"ignoreUntil"</strong></mark> => <mark style="background-color:yellow;">String or Array</mark></summary>

Prevents any other keys below this one from activating until a specified Trigger Key has been triggered. For example, if you set this to <mark style="background-color:purple;">"BattlerFainted\_foe"</mark>, then no other keys in this hash will be able to trigger until one of the foe's Pokemon have fainted to trigger that key. Alternatively, you can set this to an array containing multiple Trigger Keys, and no other keys in this hash will be able to trigger until at least one of the Trigger Keys in this array have been triggered.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"ignoreAfter"</strong></mark> => <mark style="background-color:yellow;">String or Array</mark></summary>

Prevents any other keys below this one from activating after a specified Trigger Key has been triggered. For example, if you set this to <mark style="background-color:purple;">"BattlerFainted\_foe"</mark>, then no other keys in this hash will be able to trigger after one of the foe's Pokemon have fainted to trigger that key. Alternatively, you can set this to an array containing multiple Trigger Keys, and no other keys in this hash will be able to trigger once any of the Trigger Keys in this array have been triggered.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"toggleSwitch"</strong></mark> => <mark style="background-color:yellow;">Integer</mark></summary>

Toggles a particular game switch off or on. The integer set here determines which game switch to toggle. For example, if this is set to 75, then game switch 75 will be toggled on. If game switch 75 is already on, then it will be turned off instead.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"setVariable"</strong></mark> => <mark style="background-color:yellow;">Integer or Array</mark></summary>

Sets the default value of the midbattle variable to whatever number the set integer is. If set as an array of integers, a random value will be selected instead.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"addVariable"</strong></mark> => <mark style="background-color:yellow;">Integer or Array</mark></summary>

Adds to the value of the midbattle variable that is checked for by certain Trigger Keys. Whatever integer is set here will be added to the cumulative total of this variable. If you want to subtract an amount from this variable, set this to a negative number instead.

If set as an array of integers, a random value from this array will be selected to add to the variable's value.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"multVariable"</strong></mark> => <mark style="background-color:yellow;">Integer or Float</mark></summary>

Multiplies the value of the midbattle variable that is checked by certain Trigger Keys by whatever integer is set. If you want to divide the value of the this variable instead, then set this to a float number like 0.5 to divide the value of the variable by half (rounded).

</details>

Page 43:

# Commands: Battle Mechanics

These are keys which trigger certain actions to take place during battle, such as forcing a trainer to use an item or switch out, or toggling the availability of the player's Poke Balls.

<details>

<summary><mark style="background-color:blue;"><strong>"useItem"</strong></mark> => <mark style="background-color:yellow;">Symbol or Array</mark></summary>

Forces a trainer (or a wild Pokemon) to use an item on the battler. The item does not have to be in the trainer's inventory to be used, nor will it be removed from their inventory if it is. If the set item doesn't have any in-battle use, or if the item wouldn't have any effect, then nothing will happen.&#x20;

If the set item is any type of Poke Ball, then the ball will always be used by the player and thrown at the opposing Pokemon, even if the battler who triggered the item to be used is an opposing Pokemon. This is because only the player can use and throw Poke Balls, so this will always default to the player's item, regardless of who triggers the item to be used.&#x20;

If a PP-restoring item is used that would normally require a move to be selected to be used, such as an Ether or Leppa Berry, then these items will just automatically select the move with the lowest PP to use itself on.\
\
If you want to select a random item to be used out of a list, you can simply enter this as an array of item ID's, and a random one will be chosen out of that array.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"useMove"</strong></mark> => <mark style="background-color:yellow;">Integer, Symbol, String, or Array</mark></summary>

Forces a battler to use a specific move in their moveset during their turn, regardless of whatever their actual selected move was going to be this turn. This won't work if the battler has already moved this turn, or if a different action has been chosen besides using a move, such as switching or using an item. This also won't work if the battler is under some condition that would prevent it from using a different move, such as being in the charging turn of a different attack, having zero PP for the selected move, or being under the effects of things like Encore, Disable, or Choice Band. Lastly, this also will fail to work if the battler's naturally selected move is a Z-Move or a Dynamax move, as those cannot be overridden by a normal move.\
\
If this is set as an integer, then the move that the battler will be forced to use will be whatever move appears at the index of that integer. For example, if set to 1, then the battler will be forced to use whatever move appears second in its moveset (since the first index counted would be 0). Alternatively, you can set this to a move ID symbol instead, and the battler will be forced to use that move as long as it appears in their moveset.\
\
If you set this as an array, you may also include an integer as the second argument of the array to specify a particular target for the move. This isn't necessary if the move is a self-targeting move, or doesn't specifically target anyone. If the specified target cannot be found, or isn't eligible, then the first eligible target that can be found will be set instead.\
\
If you don't want to specify which specific move the battler should use, but want to apply a more general rule for which *kinds* of moves it should use, you may do so by setting a string instead of using indexes or move ID's. If it has multiple moves that fit the inputted criteria, it will select a random one to use among those moves. Here are the possible strings you can use to narrow down the kinds of moves that should be used:

* <mark style="background-color:yellow;">**"Damage"**</mark>\
  This will force the battler to select only damage-dealing moves to use, if able. If you use <mark style="background-color:yellow;">"Damage\_foe"</mark> instead, this will specify further that it should only pick damage-dealing moves that will damage opponents, or you can use <mark style="background-color:yellow;">"Damage\_ally"</mark> to specify that it should only pick damage-dealing moves that will damage an ally.
* <mark style="background-color:yellow;">**"Heal"**</mark>\
  This will force the battler to select only healing moves to use, if able. A healing move is any move where `healingMove?` returns true. If you use <mark style="background-color:yellow;">"Heal\_self"</mark>, this will specify further that it should only pick healing moves that target the user, like Recover. If you use <mark style="background-color:yellow;">"Heal\_ally"</mark>, this will specify that only healing moves that are capable of targeting an ally should be picked, like Heal Pulse. If you use <mark style="background-color:yellow;">"Heal\_foe"</mark>, this will specify that only healing moves that are capable of targeting a foe should be picked, like Leech Life.
* <mark style="background-color:yellow;">**"Status"**</mark>\
  This will force the battler to select only non-healing status moves, if able. If you use <mark style="background-color:yellow;">"Status\_self"</mark>, this will specify further that it should only pick status moves that target the user, like Swords Dance. If you use <mark style="background-color:yellow;">"Status\_ally"</mark>, this will specify that only status moves that are capable of targeting an ally should be picked, like Helping Hand. If you used <mark style="background-color:yellow;">"Status\_foe"</mark>, this will specify that only status moves that are capable of targeting a foe should be picked, like Thunder Wave.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"switchOut"</strong></mark> => <mark style="background-color:yellow;">Integer, Symbol, or Array</mark></summary>

Forces the battler to switch out with another one in the party. This key doesn't do anything if there are no other eligible Pokemon to switch to in the battler's party, or if the battler is unable to switch out for some reason. When set to an integer, the new Pokemon that will be sent out will be the one that matches the party index of that integer. For example, if set to 2, then the trainer will send out the Pokemon that appears third in their party line up (since the first index counted would be 0).&#x20;

Alternatively, you may set this to a species ID symbol, and the trainer will send out the first Pokemon in their party line up that matches that species. For example, if you set this to `:PIKACHU`, the trainer will always send out a Pikachu, if they have one in their party. If they have multiple Pokemon of the same species, then the first able one in their party will be the one that gets sent out.\
\
If you set this as an array, you can include a string as the second argument of the array to display a custom battle message that occurs when the battler is switched out. You can use `{1}` in this string to refer to the specific battler's name.\
\
If you don't want to specify which Pokemon the trainer will switch to, there are alternate symbols you may use for this purpose instead of using indexes or species ID's:

* <mark style="background-color:yellow;">**:Choose**</mark>\
  This will allow the trainer to decide for themselves what the next Pokemon sent out should be. If this is the player, then they will manually choose a Pokemon from the party menu. If this is an AI trainer, then they will select the best Pokemon to send out based on their skill level.
* <mark style="background-color:yellow;">**:Random**</mark>\
  This will choose a totally random Pokemon from the trainer's party to send out.
* <mark style="background-color:yellow;">**:Forced**</mark>\
  This functions identically to <mark style="background-color:yellow;">:Random</mark>, except the messages that display will indicate that the trainer is being forced to make this switch, instead of by choice (similar to how moves like Roar and Whirlwind work).

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"megaEvolve"</strong></mark> => <mark style="background-color:yellow;">Boolean or String</mark></summary>

Forces the battler to Mega Evolve when set to `true`, as long as they are able to. If set to a string instead, you can customize a message that will display upon this Mega Evolution triggering. Note that this can even be used to force a wild Pokemon to Mega Evolve, as long as they are holding the appropriate Mega Stone, or has the required Mega Move.\
\
Unlike natural Mega Evolution, you can use this to force Mega Evolution to happen at any point in battle, even at the end of the turn or after the battler has already attacked. This cannot happen if a different action with this battler has been chosen however, such as switching it out or using an item.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"disableMegas"</strong></mark> => <mark style="background-color:yellow;">Boolean</mark></summary>

Toggles the availability of Mega Evolution for the owner of the battler. If set to `true`, Mega Evolution will be disabled for this trainer. If set to `false`, Mega Evolution will no longer be disabled, allowing this trainer to use it again even if they've already used Mega Evolution prior in this battle.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"disableBalls"</strong></mark> => <mark style="background-color:yellow;">Boolean</mark></summary>

Toggles the player's ability to throw Poke Balls during this battle. If set to `true`, Poke Balls will be disabled. When set to `false`, this flag is removed, allowing the trainer to throw Poke Balls again.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"disableItems"</strong></mark> => <mark style="background-color:yellow;">Boolean</mark></summary>

Toggles the ability of all trainers participating in this battle to use items from their inventory during this battle. If set to `true`, item usage will be disabled. When set to `false`, this flag is removed, allowing all trainers to use items again.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"disableControl"</strong></mark> => <mark style="background-color:yellow;">Boolean</mark></summary>

Toggles the player's ability to input controls. If set to `true`, the player's control will be disabled and the AI will control the inputs of the player's character. When set to `false`, this flag is removed, allowing controls to return to the player.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"endBattle"</strong></mark> => <mark style="background-color:yellow;">Integer</mark></summary>

Prematurely ends the battle. This can be used to end a battle early, and manually set its outcome. This is done by setting this to one of the following integers:

* <mark style="background-color:yellow;">1</mark>: Ends the battle as if the player won.
* <mark style="background-color:yellow;">2</mark>: Ends the battle as if the player lost.
* <mark style="background-color:yellow;">3</mark>: Ends the battle as if the player ran/forfeited.
* <mark style="background-color:yellow;">4</mark>: Ends the battle as if the player won (identical to 1).
* <mark style="background-color:yellow;">5</mark>: Ends the battle as if it ended in a draw (identical to 2 in most cases).

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"wildFlee"</strong></mark> => <mark style="background-color:yellow;">Boolean or String</mark></summary>

This wont do anything unless the battler is a wild Pokemon. Setting this to `true` will force the wild Pokemon to flee, prematurely ending the battle. If you set this to a string instead, whatever text you enter will be displayed as the flee message for the wild Pokemon. You can use `{1}` in this string to refer to the wild Pokemon by name.

</details>

Page 44:

# Commands: Battler Attributes

These are keys which trigger something to happen to a battler, such as changing its attributes or effects, changing its stats, or manipulating its HP.

<details>

<summary><mark style="background-color:blue;"><strong>"battlerName"</strong></mark> => <mark style="background-color:yellow;">String</mark></summary>

Changes the name of the battler to whatever string is entered here.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"battlerHP"</strong></mark> => <mark style="background-color:yellow;">Integer or Array</mark></summary>

Changes the HP of the battler. When set to a positive integer, the battler's HP will be restored by that percentage of its total HP. When set to a negative integer, the battler's HP will be reduced by that percentage instead.\
\
For example, if this is set to 25, the battler will restore 25% of its total HP. If set to 100, the battler will restore 100% of its total HP. However, if you inverse these to negative numbers instead, the battler will have their HP reduced by 25% or 100%, respectively. If you set this to 0 instead of a positive or negative number, the battler's HP will always be set to 1 HP, regardless of whatever its current amount is.\
\
If you set this as an array, you can include a string as the second argument of the array to display a custom battle message that occurs when the battler's HP is changed. You can use `{1}` in this string to refer to the specific battler's name.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"battlerHPCap"</strong></mark> => <mark style="background-color:yellow;">Integer</mark></summary>

This sets an HP threshold for the battler that will cap how much damage it can possibly take from direct attacks.\
\
For example, if this is set to 25, the battler's HP will be prevented from dropping below 25% of its max HP when it is struck by an attack, regardless of how strong the attack was. If set to 100, the battler will prevent any damage being taken by an attack at all. If you set this to 0, the battler will survive an attack with 1 HP.\
\
This can be used to design boss-like encounters who trigger certain actions when their HP reaches certain thresholds. Note however that this only affects damage taken by attacks, so any indirect damage may still reduce the battler's HP below the set damage cap.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"battlerStatus"</strong></mark> => <mark style="background-color:yellow;">Symbol or Array</mark></summary>

Changes the status condition of the battler. If set to a symbol, you may enter the ID of a specific status to inflict that status on the battler. For example, `:BURN` would inflict a burn on the battler. You can also use the symbols `:TOXIC` or `:CONFUSION` to apply toxic Poison or to make the battler confused, respectively. If you want to cure the battler of its status conditions, you can use the symbol `:NONE` to remove them. Note that this will also remove the confusion and infatuation conditions, too. If you want to set a random status condition, you can simply set an array of different status symbols, and a random one will be chosen out of that array.\
\
Another way to use an array is to have the first item of the array be a status symbol (or array of status symbols), and the second item in the array may be set to `true` in order to display certain success/failure messages in applying that status condition.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"battlerType"</strong></mark><strong> ⇒ </strong><mark style="background-color:yellow;"><strong>Symbol or Array</strong></mark></summary>

Changes the battler's typing. If set to a symbol, you may enter the ID of a specific type to replace the battler's current typing with that new type. For example, `:WATER` would turn the battler into a Water-type. If you want to give the battler multiple new types, you can do so by entering an array of type ID's. For example, `[:FIRE, :DRAGON]` would turn the battler into a Fire/Dragon type. If you would like to reset the battler's type back to their original typing, you can set this to `:Reset` instead.

Note that this command will fail to do anything on battlers who are immune to having their type changed for some reason, such as a Pokemon the Multitype or RKS System abilities, or a battler who is currently Terastallized.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"battlerForm"</strong></mark> => <mark style="background-color:yellow;">Integer, Symbol, or Array</mark></summary>

Changes the battler's form, if possible. If set to an integer, the battler will change to that form number, if one exists. You may also set this to `:Random` to change the battler into a random form out of all of its eligible forms, or you can set this to `:Cycle` for the battler to cycle through to its next form in order. For example, if the battler is Deoxys and `:Cycle` is set, Deoxys will shift from Normal form to Attack, Defense, then Speed, and then back to Normal again, each time its form is changed with `:Cycle`.\
\
Note however that certain forms, such as Mega and Primal forms, are not considered eligible forms with this setting, and will be ignored. So you cannot force a Charizard to become Mega Charizard X with this setting. Pretty much everything else however is fair game.\
\
You may also set this to an array if you'd like, and if you do, you may set the second item in this array as a string so that a custom message may appear when the battler changes form. If you set this second item to `true` instead, then a generic transform message will appear instead. Otherwise, no message will display.\
\
Note that a battler cannot have its species changed if it's currently under the effects of a special form or state, such as Mega Evolution, Ultra Burst, Dynamax, or Terastallization. It also cannot change species if it's currently in a semi-invulnerable state due to moves like Fly or Dig, or lifted up in the air due to Sky Drop.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"battlerSpecies"</strong></mark> => <mark style="background-color:yellow;">Symbol or Array</mark></summary>

Changes a battler's species. Set this to a species ID such as `:PIKACHU` to change the species of that battler. Note that this is a permanent change, so the battler will not revert once switched out. In the case of the player's Pokemon, this means that their Pokemon will be permanently changed as well even once they leave battle, so be careful in how you apply this. NPC's Pokemon are re-generated from their PBS data whenever battle is initiated, so these effects won't persist out of battle for them.\
\
If you set this as an array, you can include a string as the second argument of the array to display a custom battle message that occurs when the battler changes species. You can use `{1}` in this string to refer to the specific battler's name, `{2}` to refer to the new species name, and `{3}` to refer to the name of the trainer who owns that battler.\
\
Note that a battler cannot have its species changed if it's currently under the effects of a special form or state, such as Mega Evolution, Ultra Burst, Dynamax, or Terastallization. It also cannot change species if it's currently in a semi-invulnerable state due to moves like Fly or Dig, or lifted up in the air due to Sky Drop.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"battlerEvolve"</strong></mark> => <mark style="background-color:yellow;">Symbol or Array</mark></summary>

Forces a battler to evolve during battle. Unlike normal evolution, battle evolutions cannot be cancelled and do not require any sort of evolution methods or criteria to be met; you can evolve any species at any point in battle. So for example, you can force Pikachu to evolve into Raichu without a Thunder Stone requirement.\
\
You can set this to `:Next` to force the battler to evolve into the next evolutionary stage listed in that species' PBS data. If the species has multiple branches it can evolve into, such as Eevee, you can set this to `:Random` to choose a random evolution out of all possible branches. If the battler is already fully evolved and has no evolution data, nothing will happen when these symbols are set.\
\
If you'd like to set a specific species for the battler to evolve into, you can set a specific species ID such as `:PIKACHU`, instead. Note that you can force a battler to evolve into *any* species if you set a specific species ID in this way, even if it's a species that would otherwise be impossible for that battler to evolve into. For example, if you set this to `:MEWTWO`, you can make the battler evolve into Mewtwo even though that would be impossible normally. However, if you set the species ID to the same species that the battler already is, then nothing will happen.\
\
If you set this as an array, you can include a number as the second item in the array to set the form of the battler prior to evolution. This can be used to force a battler to evolve directly into a specific form of a species. For example, if set as `[:RAICHU, 1]`, this will force the battler to evolve specifically into Alolan Raichu.\
\
When a battler owned by the player evolves into a species that learns new moves upon evolving, it will be prompted to learn those moves like it normally would. However, if the battler is wild or owned by an NPC trainer, it will automatically have those evolution moves added to its moveset silently, without any prompts. A battler that evolves during battle will be considered a "new" battler once evolution is complete, meaning any effects the battler suffered from before evolution will be removed, similarly to how they would be they had been switched out of battle. However, any effects that would be carried over with the effects of Baton Pass (such as stat stages) will still be retained by the evolved battler.\
\
Note that a battler cannot be forced to evolve if it's currently under the effects of a special form or state, such as Mega Evolution, Ultra Burst, Dynamax, or Terastallization. It also cannot evolve if it's currently in a semi-invulnerable state due to moves like Fly or Dig, or lifted up in the air due to Sky Drop.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"battlerAbility"</strong></mark> => <mark style="background-color:yellow;">Symbol or Array</mark></summary>

Changes the battler's ability. If set to an ability ID symbol, the battler's ability will be changed to that ability. This won't work however if the battler currently has an ability that cannot be removed, or if the ability you're attempting to give it is an ability that can only be utilized by a specific species. If you want to reset the battler's ability back to its original ability, you can use the symbol `:Reset`, instead. \
\
If you want to assign a random ability to the battler out of a list, you can simply enter this as an array of ability ID's, and a random one will be chosen out of that array. If you want to alert the player of this ability change, you may enter this as an array where the first item in the array is the ability ID (or array of ability ID's), and the second item of this array may be set as either `true`, or a string containing a custom message. If neither are included, then the battler's ability will be changed silently, without alerting the player.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"battlerItem"</strong></mark> => <mark style="background-color:yellow;">Symbol or Array</mark></summary>

Changes the battler's held item. If set to an item ID symbol, the battler's held item will be changed to that item. This won't work however if the battler is currently holding an item that cannot be removed. If you want to remove a battler's held item without replacing it with another, you can use the symbol `:Remove`, instead. \
\
If you want to assign a random held item to the battler out of a list, you can simply enter this as an array of item ID's, and a random one will be chosen out of that array. If you want to alert the player of this item change, you may enter this as an array where the first item in the array is the item ID (or array of item ID's), and the second item of this array may be set as either `true`, or a string containing a custom message. If neither are included, then the battler's item will be changed silently, without alerting the player.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"battlerMoves"</strong></mark> => <mark style="background-color:yellow;">Symbol or Array</mark></summary>

Changes the battler's moves. If set to a move ID, the battler will have that move added to their moveset. If their moveset is already full, their first move will be deleted and their moveset will shift up by one to make room for the new move. If you want to reset the battler's moveset back to the normal moves it would typically have at that level, you can use the symbol `:Reset` instead. \
\
If you want to change multiple moves in a battler's moveset, you may instead enter this as an array of move IDs, and each move ID will replace the existing move located at that index in the battler's current moveset. If you want to simply delete a move in a battler's moveset instead of replacing it with anything, you can just enter `nil` at that index.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"battlerStats"</strong></mark> => <mark style="background-color:yellow;">Array or Symbol</mark></summary>

Changes the battler's stat stages. Set this to an array containing the ID of the stat you want to change, followed by the number of stages you want to change it by. For example, entering `[:ATTACK, 2]` would increase the battler's Attack stat by 2 stages. You can enter as many stats as you want in this array, as long as it follows this pattern of symbols and numbers. If you want to decrease the stage of a particular stat, then you would just enter a negative number instead. For example, `[:DEFENSE, -3]` would lower the battler's Defense by 3 stages. \
\
If you would like a random stat to be altered, then you can use `:Random` in place of a stat ID. This randomized stat will never be a stat that already appears in the array, however. So for example, if your stat array looks like `[:SPEED, 1, :Random, -1]`, the random stat will never be Speed, since that stat is already going to be altered.\
\
If you would like to reset all of a battler's stat stages back to zero, you may do so by entering the symbol `:Reset`, instead of an array. If you only want to reset a battler's increased stat stages to zero, then you would use the symbol `:ResetRaised`. Alternatively, if you only want to reset a battler's negative stat stages to zero, then you would use the symbol `:ResetLowered`.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"battlerEffects"</strong></mark> => <mark style="background-color:yellow;">Array</mark></summary>

Changes the effects that are applied to the battler. This is entered as an array that must contain at least two items; the first item in the array must be the symbol of the specific effect you'd like to alter or apply, and the second item in the array must be the value you want to set this effect to. Optionally, you may enter a string as the third item in this array, which will display a custom message when applying this effect. For example, you may enter this as `[:Endure, true]` to silently apply the Endure effect on a battler, or you could set something like `[:FocusEnergy, 2, "{1} is getting pumped!"]` to set the battler's Focus Energy effect to 2 and announce it to the player.\
\
You may even enter multiple different effects to be applied all at once if you want, by making an array of arrays, like this:\
`[[:Rage, true],` \
&#x20;`[:NoRetreat, true],`\
&#x20;`[:PerishSong, 3, "{1} will faint in three turns!"]]`

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"battlerWish"</strong></mark><strong> =>  </strong><mark style="background-color:yellow;"><strong>Boolean, Integer, or Array</strong></mark></summary>

Sets the Wish effect on the battler's position. When set to `true`, this sets the Wish effect which will trigger in 2 turns. After which, any battler occupying that position will be healed by up to 50% of the original Wish-maker's total HP.

If this is instead set as an integer, you can manually set the number of turns before the Wish effect will trigger, instead of it defaulting to the normal 2 turns. If this is instead set as an array, you can enter two integers; the first dictates the number of turns before the Wish triggers, while the second specifies the amount of HP that will be restored once the Wish triggers.

Note: The Wish effect cannot be set with the normal <mark style="background-color:blue;">"battlerEffect"</mark> command because the Wish effect is not placed on a specific battler, but instead on a specific battler *position* on the field.

</details>

Page 45:

# Commands: Battlefield Conditions

These are keys which trigger something to happen to the battlefield, such as changing weather or terrain, the effects that are in play, or even changing the backdrop.

<details>

<summary><mark style="background-color:blue;"><strong>"teamEffects"</strong></mark> => <mark style="background-color:yellow;">Array</mark></summary>

Changes the effects that are applied to one side of the field. This is entered as an array that must contain at least two items; the first item in the array must be the symbol of the specific effect you'd like to alter or apply, and the second item in the array must be the value you want to set this effect to. Optionally, you may enter a string as the third item in this array, which will display a custom message when applying this effect. For example, you may enter this as `[:StickyWeb, true]` to silently apply the Sticky Web effect to a team's side, or you could set something like `[:Tailwind, 3, "A strong wind suddenly blew behind {1}!"]` to set the Tailwind effect to 3 on a team's side and announce it to the player.\
\
You may even enter multiple different effects to be applied all at once if you want, by making an array of arrays, like this:\
`[[:StealthRock, true],` \
&#x20;`[:Spikes, 3],`\
&#x20;`[:ToxicSpikes, 2, "{1} fell into a thorny trap!"]]`

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"fieldEffects"</strong></mark> => <mark style="background-color:yellow;">Array</mark></summary>

Changes the effects that are applied to the entire battlefield. This is entered as an array that must contain at least two items; the first item in the array must be the symbol of the specific effect you'd like to alter or apply, and the second item in the array must be the value you want to set this effect to. Optionally, you may enter a string as the third item in this array, which will display a custom message when applying this effect. For example, you may enter this as `[:Gravity, 5]` to silently apply the Gravity effect to the battlefield for 5 turns, or you could set something like `[:PayDay, 1000, "Coins scattered everywhere!"]` to set the Pay Day effect on the field, allowing the player to pick up an additional $1,000 at the end of the battle.\
\
You may even enter multiple different effects to be applied all at once if you want, by making an array of arrays, like this:\
`[[:MagicRoom, 5],` \
&#x20;`[:WonderRoom, 5],`\
&#x20;`[:TrickRoom, 5, "The battlefield became topsy-turvy!"]]`

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"changeWeather"</strong></mark> => <mark style="background-color:yellow;">Symbol</mark></summary>

Changes the current battle weather. Set to a weather ID to change the weather to that weather type. If set to `:Random`, a random weather will be set. If set to `:None`, any currently active weather will be cleared. Note that while Primal weather can be set, those weather conditions are hardcoded to immediately end if a Pokemon with the corresponding Primal weather ability isn't on the field.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"changeTerrain"</strong></mark> => <mark style="background-color:yellow;">Symbol</mark></summary>

Changes the current battle terrain. Set to a terrain ID to change the terrain to that terrain type. If set to `:Random`, a random terrain will be set. If set to `:None`, any currently active terrain will be cleared.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"changeEnvironment"</strong></mark> => <mark style="background-color:yellow;">Symbol</mark></summary>

Changes the current battle environment. Set to an environment ID to change the environment to that environment type. If set to `:Random`, a random environment will be set. If set to `:None`, the current environment will be set to neutral (usually associated with indoor buildings or urban environments).

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"changeBackdrop"</strong></mark> => <mark style="background-color:yellow;">String or Array</mark></summary>

Changes the battlefield background and/or bases. Set to a string to change the background and bases used in battle to match the one you entered. You may enter this as an array containing two different strings if you want to mix and match different backgrounds and bases. The first element of the array refers to the background, and the second refers to the bases. The strings you enter for either one only need to contain the root name of the file. For example, you may use `"elite1"` or `"grass_night"`. You must omit the `_bg` or `_base` parts of the file name.\
\
It's also worth noting that changing the bases in battle may also automatically change the battle environment as well, depending on the type of base you have set. This happens independently of the <mark style="background-color:blue;">"changeEnvironment"</mark> key, so this may override that key if you entered this one after it.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"changeDataboxes"</strong></mark> => <mark style="background-color:yellow;">Symbol or Array</mark></summary>

Changes the active databox style. Refer to the <mark style="background-color:green;">"databoxStyle"</mark> Battle Rule if you're unfamiliar with databox styles. Set to a databox style ID to change to that databox style during battle. This plugin only has two possible databox styles to select from by default; the `:Basic` and `:Long` styles.

If there is a databox style already active and you would like to remove this style so that battler databoxes return to normal, you can simply set this to `nil` instead.

For wild battles only, you can also set this as an array where the first item in the array is the databox style ID, and any additional items in the array are strings that will act as display titles to appear in each wild battler's databox. This can be used to update a wild Pokemon's title midbattle to indicate different boss phases, for example.

</details>

Page 46:

# Commands: Extensions

You cannot have more than one key in a single hash with the same name. If you do, the last instance of that key will overwrite all of the others, effectively making the duplicate keys meaningless. Because of this, you cannot have duplicate Command Keys in a single hash at the same time. This poses a problem, however, if you wish to use the effects of a Command Key multiple times in a single hash to do different things.

For example, say you want to use the <mark style="background-color:purple;">"UserDealtCriticalHit\_player"</mark> Trigger Key so that some text is displayed when the player's Pokemon scores a critical hit in battle.

```
"UserDealtCriticalHit_player" => {
  "speech" => [:Opposing, "No fair! Lucky hit...", "C'mon, {1}!"],
  "text"   => [:Opposing, "{1} is raring to go!"]
}
```

In this example, the opponent will comment on the player's lucky hit. But what if you wanted the player to respond to this with their own line of dialogue? Using the <mark style="background-color:blue;">"speech"</mark> Command Key is no longer possible, since it has already been used once, right? Well normally, yes. However, you can bypass this limitation by using Command Key extensions.

This is very simple, and much more straightforward than Trigger Key extensions. For Command Keys, all you need to do is include an underscore and then add any other character you want to the key to make it unique. For simplicity's sake, I tend to just use letters in alphabetical order to keep things neat and tidy. However, you can use whatever you want, in reality. Letters, numbers, symbols, or entire words - pretty much anything that can be used in a string can be used here, just as long as it appears after an underscore.

```
"UserDealtCriticalHit_player" => {
  "speech_A" => [:Opposing, "No fair! Lucky hit...", "C'mon, {1}!"],
  "text"     => [:Opposing, "{1} is raring to go!"],
  "speech_B" => "Hmph, looks like they aren't giving up so easily!"
}
```

Building off of the previous example, we now added dialogue for the player in response to the opponent's text. Because <mark style="background-color:blue;">"speech\_A"</mark> and <mark style="background-color:blue;">"speech\_B"</mark> are different names, the key limitation is bypassed, allowing you to use as many of the same Command Keys as you'd like in a single hash.

Here's a much more elaborate example, building off of the previous example even further:

```
"UserDealtCriticalHit_player" => {
    "speech_A"       => [:Opposing, "No fair! Lucky hit...", "C'mon, {1}!"],
    "text_A"         => [:Opposing, "{1} is raring to go!"],
    "speech_B"       => "Hmph, looks like they aren't giving up so easily!",
    "setBattler_A"   => 1,
    "battlerStats_A" => [:ATTACK, 1, :SPEED, 1],
    "speech_C"       => "Hah! Looks like my {1} will stop at nothing to win!",
    "setBattler_B"   => 0,
    "speech_D"       => "Two can play at that game! Let's go, {1}!",
    "battlerStats_B" => [:SPECIAL_ATTACK, 1, :SPEED, 1]
  }
```

Page 47:

# Advanced Scripting

The pages in this subsection will go over some advanced ways of setting up your custom midbattle scripts.&#x20;

* In the subsection "Speech Utilities", I will go over everything related to setting up speech and dialogue in much more thorough detail.
* In the subsection "Variable Utilities", I will introduce the midbattle variable, how to edit it's value, and how you can make something happen in response to its value changing.
* In the subsection "Storing Scripts", I will go over how to store entire midbattle hashes in the plugin scripts themselves so that you may call upon them when you need them. This not only allows you to save space in your event scripts themselves, but makes your midbattle scripts more accessible and easily re-usable for multiple battle calls.
* In the subsection "Hardcoding", I will go over an entirely different method of setting up midbattle scripts where you may simply hardcode entire battle scenarios freehand, rather than relying on the pre-made hash system where you input certain values for certain outcomes. This method requires you to be fairly competent at coding, so I recommend sticking with the hash system if you aren't confident in your abilities.
* In the subsection "Global Scripts", I will go over a way to implement midbattle scripts that can apply globally to any battle, without having to set a battle rule for a specific battle.

Page 48:

# Advanced: Speech Utilities

Triggering speech through midbattle scripts is probably the most complex and robust part of the entire kit, mainly because this is primarily what people will typically be using midbattle scripts for. Simply making a trainer say lines of dialogue may seem like the simplest thing this plugin can do, but in reality, it's the part of the kit that the most time and work has been devoted to.

There's so many different ways to utilize speech that I thought it deserved it's own section in this tutorial. In the following subsections, I will go over just some of the ways you may set up mid-battle trainer speech.

Page 49:

# Speech: General

This subsection details the basics in setting speech and offers general tips and advice on how to get the most out of your speech events.

***

<mark style="background-color:orange;">**Speech as a String**</mark>

This is the simplest way to set up speech. This is done by setting the <mark style="background-color:blue;">"speech"</mark> Command Key to a string, and whichever trainer's Pokemon has triggered the associated Trigger Key will speak that line of text. For example:

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FPQnFyo3elIyj7ntbO78f%2Fdemo1.gif?alt=media&#x26;token=8e2326c4-9154-4f93-8aa6-0b56b6b25d83" alt="" width="381"><figcaption></figcaption></figure>

```
"BeforeMove_TRICKROOM_foe" => {
  "speech" => "Time to flip things upside-down!"
}
```

This will trigger before the  opponent's Pokemon uses the move Trick Room. If so, the they will slide on screen and speak the line of dialogue entered. Pretty simple.&#x20;

But what if I told you there's a way to make this even simpler? If speech is all you want to happen when this Trigger Key is triggered, then you don't even have to bother setting up a hash and using the <mark style="background-color:blue;">"speech"</mark> Command Key. Instead, you can simply set the Trigger Key itself as the desired line of speech, like so:

```
"BeforeMove_TRICKROOM_foe" => "Time to flip things upside-down!"
```

This will produce exactly the same results as the previous example. When Trigger Keys are given strings as values like shown here, they will automatically assume that the string is meant as speech, and act as if the <mark style="background-color:blue;">"speech"</mark> Command Key is being called. This shortcut can *only* be used for speech. No other function may be set up in this manner.

***

<mark style="background-color:orange;">**Speech as an Array**</mark>

In some scenarios, you may want multiple lines of dialogue to be spoken, and don't want to cram it all in a single string. To accomplish this, setting <mark style="background-color:blue;">"speech"</mark> as an array will also work, like in the example below:

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Ff6XiKA645XZZxFtSpaAV%2Fdemo2.gif?alt=media&#x26;token=42847d4d-b879-4859-9363-227b642a0ed8" alt="" width="381"><figcaption></figcaption></figure>

```
"BattlerFainted_CHARIZARD_foe" => {
  "speech" => ["N-no! Charizard!",
               "Argh, do you think this is over because you've beaten my ace?",
               "No...not by a long shot!"]
}
```

In this example, the opponent will slide on screen and say three different consecutive lines of speech after their Charizard faints. However, this can also be simplified in exactly the same way as outlined in the "String" section above, like so:

```
"BattlerFainted_CHARIZARD_foe" => ["N-no! Charizard!",
                                   "Argh, do you think this is over because you've beaten my ace?",
                                   "No...not by a long shot!"]
```

You may set the value of the Trigger Key itself to the array of strings to have these lines be spoken without having to set up an entire hash.

***

&#x20;<mark style="background-color:orange;">**Speech with Multiple Speakers**</mark>

There may be some scenarios where you don't want just a single speaker saying lines, but instead want multiple speakers with back and forth dialogue. There are a multitude of ways to accomplish this, and I'll outline them below.

***

<mark style="background-color:yellow;">**Adding Indexes to Arrays**</mark>

One of the more simple ways of accomplishing this is to set up the entire dialogue exchange in an array with a single "speech" Command Key, except you can indicate which lines of speech should be spoken by each speaker by entering an index prior to the lines you want that speaker to say. For example:

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F8EwWVdGg82gPvpyYr35m%2Fdemo3.gif?alt=media&#x26;token=f5cf4a82-110d-4c0c-b3dd-f8677eb29153" alt="" width="381"><figcaption></figcaption></figure>

```
"AfterLastSwitchIn_player" => {
  "speech" => [1, "Pathetic. Give up, already.",
               0, "Never! {1} and I can still win!",
               1, "Win? You can hardly stand! Haha!",
               0, "We'll show you!"]
}
```

In this example, we have an array of speech which is triggered after the player sends out their final remaining Pokemon. However, you'll notice that within this array, there are numbers included along with the strings of text. These numbers indicate which trainer actually speaks the following line of dialogue. The numbers represent battler indexes. "0" refers to the first battler on the player's side, and "1" refers to the first battler on the opponent's side. The speaker is whichever trainer owns the Pokemon that appears at that index.

So in this example, "1" sets the speaker as the opponent, so the opposing trainer will slide in to speak the first line of dialogue. Then, since "0" appears next in the array, the active speaker is hidden and the next line of dialogue is then spoken by the player. Note that you can still use the shortcut described in the "Speech as an Array" section to set this speech directly to the Trigger Key instead of creating a hash.

***

<mark style="background-color:yellow;">**Adding Symbols to Arrays**</mark>

What if you don't want to keep track of index numbers for speakers? Perhaps you find it too confusing, or perhaps you're just setting up a scenario where you can't be sure exactly which speaker index will be available to use. In situations like this, you may set certain symbols in place of an index. Here's an example:

```
"BattlerEffectEnded_SlowStart" => {
  "speech" => [:Self, "Now you're in trouble! Get'em, {1}!",
               :Opposing, "Oh no...how could I let this happen?"]
}
```

Here, we have an array of speech which is triggered when the turn counter for the Slow Start ability ends, and Regigigas's stats are at full power. Because no Trigger Extension is used on this Trigger Key to indicate if this should trigger for the player or opponent's Pokemon, this will simply trigger when *any* battler meets these conditions. In this scenario, this becomes impossible to tell which indexes should be used to indicate the speakers of each line, since you have no way of knowing which trainer's Pokemon will be the one who's Slow Start turns end first.

To resolve this, we can simply use generic symbols to indicate who should speak each line, instead of specific indexes. Here are all of the available symbols that may be used, and who they refer to:

* <mark style="background-color:yellow;">:Self</mark>  \
  This indicates that the speaker should be set to the index of whichever battler triggered the associated Trigger Key.
* <mark style="background-color:yellow;">:Ally</mark> \
  This indicates that the speaker should be set to the index of the first available *ally* of whichever battler triggered the associated Trigger Key. Defaults to `:Self` if no ally exists.
* <mark style="background-color:yellow;">:Ally2</mark> \
  This indicates that the speaker should be set to the index of the second available ally (if any) of whichever battler triggered the associated Trigger Key. Defaults to `:Ally` if no secondary ally exists. Defaults to `:Self` if neither exist.
* <mark style="background-color:yellow;">:Opposing</mark> \
  This indicates that the speaker should be set to the index of the closest available *opponent* of whichever battler triggered the associated Trigger Key. Defaults to `:Self` if no opponent exists.
* <mark style="background-color:yellow;">:OpposingAlly</mark> \
  This indicates that the speaker should be set to the index of the first available ally (if any) of the closest available opponent to whichever battler triggered the associated Trigger Key. Defaults to `:Opponent` if no opposing ally exists. Defaults to `:Self` if neither exist.
* <mark style="background-color:yellow;">:OpposingAlly2</mark> \
  This indicates that the speaker should be set to the index of the second available ally (if any) of the closest available opponent to whichever battler triggered the associated Trigger Key. Defaults to `:OpposingAlly` if no secondary opposing ally exists. Defaults to `:Opposing` if no opposing allies exist. Defaults to `:Self` if no opponents exist.

So following this, it's easy to see how the speech would flow in the example provided. The first line of speech is indicated to be spoken by whichever trainer owns the Pokemon found at whichever index `:Self` refers to, which would be whichever battler initially triggered the Trigger Key. The second line of speech is indicated to be spoken by whichever trainer owns the Pokemon found at whichever index `:Opposes` refers to, which would be whichever battler directly opposes the battler which `:Self` refers to.

So for example, if the scenario played out in a way where the player's Regigigas was the one who triggered <mark style="background-color:purple;">"BattlerEffectEnded\_SlowStart"</mark>, then the player would speak the line that follows `:Self`, and the opponent would speak the line that follows `:Opposing`.&#x20;

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FnKAzjqs2KtXpIcqytyEt%2Fdemo4.gif?alt=media&#x26;token=7c353c18-579c-4fcd-b576-2f4778671c14" alt="" width="381"><figcaption><p>Triggered from the player's perspective.</p></figcaption></figure>

However, if it was the *opponent's* Regigigas who was the one who triggered <mark style="background-color:purple;">"BattlerEffectEnded\_SlowStart"</mark>, then it would be the *opponent* that would speak the line that follows `:Self`, and the *player* would be the one who spoke the line that follows `:Opposing`. This is because from the opponent's perspective, the player is the one who `:Opposing` points to, since they are the one who activated the Trigger Key.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FSDR0WZR6oFFdNYkvJMkK%2Fdemo5.gif?alt=media&#x26;token=87a4784a-43d2-4b88-bc43-cc24199d273d" alt="" width="381"><figcaption><p>Triggered from the opponent's perspective.</p></figcaption></figure>

Page 50:

# Speech: Choices

This subsection details setting up speech with branching dialogue paths that can be selected by the player. This can be simple Yes/No questions, or entire dialogue trees without any right or wrong answers.

***

<mark style="background-color:orange;">**Setting Up Choices**</mark>

The simplest way to set up speech with choice selections is to present the player with a list of choices where there can only be one right answer. Here's an example of such a set up:

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FUQwudpXpE01vUq7TTKd1%2F%5B2024-01-11%5D%2020_42_49.721.png?alt=media&#x26;token=dea74c5e-2110-46b0-8900-39db660f08f0" alt="" width="384"><figcaption></figcaption></figure>

```
"RoundStartCommand_foe" => {
  "setChoices" => [:weekday, 1, "Yes", "No"],
  "speech"     => ["Does Tuesday come after Monday?", :Choices]
}
```

When this is triggered, a set of choices are set up. This is entered as an array which contains an ID for this specific set of choices, an index for what the correct choice should be, followed by a series of strings which act as the possible choices the player must pick from. These choices must be set up *before* the <mark style="background-color:blue;">"speech"</mark> or <mark style="background-color:blue;">"text"</mark> Command Keys which present these choices are called. Then, the text which presents these choices must be entered as an array, where `:Choices` is placed within this array, wherever it is that you want those choices to appear during the speaker's speech.

In the example provided, the opponent will present the player with a question - *"Does Tuesday come after Monday?"* The player is then presented with two choices - "Yes" and "No." Because this particular set of choices does have only one correct answer ("Yes"), the index for this choice is set within <mark style="background-color:blue;">"setChoices"</mark>. Since "Yes" is the first choice in this list, the index for this is set as 1. When the player selects a choice that matches this stored index, a little chime will play to indicate that they made the correct choice. If the player selects a choice that doesn't match this stored index, a buzzer sound will play to indicate that they made an incorrect choice.

***

<mark style="background-color:orange;">**Choices With Reactions**</mark>

If you want the speaker to react to the player's selected choice, you can tweak how you enter your choices to allow for this. This is done by setting the possible choices to a hash instead of a series of strings, where each possible choice is paired with a particular line of dialogue that will be used as the speaker's reaction to that choice. Let's modify the previous example to demonstrate this:

```
"RoundStartCommand_foe" => {
  "setChoices" => [:weekday, 1, {
                   "Yes" => "You're right, of course it does!", 
                   "No"  => "I'm sorry, that's incorrect!"}],
  "speech"     => ["Does Tuesday come after Monday?", :Choices]
}
```

Here, we've set up different responses that the speaker will have whether the player selects "Yes" or "No." This will allow your speakers to interact with the player's decision immediately upon selection, instead of abruptly leaving off screen. There may be scenarios in which there is no reason for the speaker to have any reaction to the player's choice, so which way you set up your choices depends on the scenario.

***

<mark style="background-color:orange;">**Choices With Consequences**</mark>

Ok, so now we know how to make the player select a choice, and we also know how to make the speaker react to the player's choice. But how do we make something *happen* when a choice is made? For this, we need to rely on other Trigger Keys.

***

<mark style="background-color:yellow;">**Consequences for the Right Choice**</mark>

If you want to trigger something to happen after the player selects the correct choice, this can be done by utilizing the <mark style="background-color:purple;">"ChoiceRight"</mark> Trigger Key. This key must include a trigger extension that matches the ID that was entered for this specific set of choices. For example, the ID used in the examples above was set as `:weekday`. This ID can be whatever you want, as long as it's a symbol and unique from any other ID used for a set of choices in the hash. If we combine this with our Trigger Key, we get <mark style="background-color:purple;">"ChoiceRight\_weekday"</mark>, which is the key we need to make something happen in response to the player making the right choice for this set of questions. Let's add this to our example to make something happen:

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FSAFFtilGS79T2QjiXhDn%2Fdemo6.gif?alt=media&#x26;token=786d6530-4800-42c2-877b-78d76c0d9012" alt="" width="381"><figcaption></figcaption></figure>

```
"RoundStartCommand_foe" => {
  "setChoices" => [:weekday, 1, {
                   "Yes" => "You're right, of course it does!", 
                   "No"  => "I'm sorry, that's incorrect!"}],
  "speech"     => ["Does Tuesday come after Monday?", :Choices]
},
"ChoiceRight_weekday" => {
  "setBattler"   => 0,
  "battlerStats" => [:SPEED, 2]
}
```

By adding <mark style="background-color:purple;">"ChoiceRight\_weekday"</mark> to our midbattle hash, we can now set up any effects we want to trigger whenever the player selects the correct choice for the set of questions with the `:weekday` ID. For this example, I've set it up so that selecting the correct choice raises the Speed stat of the player's Pokemon at index 0 by two stages.

***

<mark style="background-color:yellow;">**Consequences for the Wrong Choice**</mark>

You may also set separate consequences which trigger whenever the player makes an incorrect choice. This is handled similarly to how consequences for a correct choice is set up, the only difference is that you would use the Trigger Key <mark style="background-color:purple;">"ChoiceWrong"</mark> instead of <mark style="background-color:purple;">"ChoiceRight"</mark>. Continuing our example, let's add a consequence to the player selecting the wrong choice when presented with the `:weekday` choices, which would use the Trigger Key <mark style="background-color:purple;">"ChoiceWrong\_weekday"</mark>.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FkHhor83yrUGJgMUBB5A6%2Fdemo7.gif?alt=media&#x26;token=e526823a-9902-4f89-a82c-b0f9f60f0d9b" alt="" width="381"><figcaption></figcaption></figure>

```
"RoundStartCommand_foe" => {
  "setChoices" => [:weekday, 1, {
                   "Yes" => "You're right, of course it does!", 
                   "No"  => "I'm sorry, that's incorrect!"}],
  "speech"     => ["Does Tuesday come after Monday?", :Choices]
},
"ChoiceRight_weekday" => {
  "setBattler"   => 0,
  "battlerStats" => [:SPEED, 2]
},
"ChoiceWrong_weekday" => {
  "setBattler"   => 0,
  "battlerStats" => [:SPEED, -2]
}
```

With this addition, I've set it up so that selecting an incorrect choice *lowers* the Speed stat of the player's Pokemon at index 0 by two stages. So now when the player is presented with this particular question, they will be rewarded for selecting the correct choice, and punished for selecting an incorrect one.

***

<mark style="background-color:orange;">**Branching Choices**</mark>

What if you want to set up a list of choices that don't have any particular right or wrong answer, but simply result in different outcomes based on the decisions made? This can also be done in a similar fashion. However, instead of setting an index for a correct choice, we can simply set this as `nil`.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FFrcPLDkAUfV5pxYDSiZ9%2F%5B2024-01-11%5D%2020_52_12.626.png?alt=media&#x26;token=eaec5089-da27-490d-b604-e2f956341f17" alt="" width="384"><figcaption></figcaption></figure>

```
"RoundStartCommand_foe" => {
  "setChoices" => [:weather, nil, "Sunny!", "Rainy!", "Snowy!"],
  "speech"     => ["What's your favorite type of weather?", :Choices]
}
```

In this example, the player is asked by the speaker to select their favorite type of weather among three different choices. Because this question has no right or wrong answer, the index for the "correct" choice for this set of questions is simply set to nil.

However, if we want something to trigger based on the player's selection, we can no longer use the <mark style="background-color:purple;">"ChoiceRight"</mark> or <mark style="background-color:purple;">"ChoiceWrong"</mark> Trigger Keys. Instead, we can simply use the <mark style="background-color:purple;">"Choice"</mark> Trigger Key, which requires two extensions. The first extension needs to be the ID used for this set of choices, like before. The ID used here is set as `:weather`, so we would combine this to get <mark style="background-color:purple;">"Choice\_weather"</mark>. Secondly, we need to indicate the index of the specific choice made where we want something to trigger. For example, if you want something to trigger when the player selects "Rainy!", then the resulting Trigger Key would look like <mark style="background-color:purple;">"Choice\_weather\_2"</mark>, since "Rainy!" is the second choice in this list of choices. Here's an example which trigger different outcomes based on each possible choice the player can make:

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FmcHhKKrFfScrPSf7lSHE%2Fdemo8.gif?alt=media&#x26;token=d93c1af6-9814-4da7-b889-63492c532950" alt="" width="381"><figcaption></figcaption></figure>

```
"RoundStartCommand_foe" => {
  "setChoices" => [:weather, nil, "Sunny!", "Rainy!", "Snowy!"],
  "speech"     => ["What's your favorite type of weather?", :Choices]
},
"Choice_weather_1" => {
  "changeWeather" => :Sun
},
"Choice_weather_2" => {
  "changeWeather" => :Rain
},
"Choice_weather_3" => {
  "changeWeather" => :Hail
}
```

In this example, the player's choice determines which weather condition is set. If they pick "Sunny!", then the weather is changed to Sun. If they pick "Rainy!", then the weather is changed to Rain. Finally, if they pick "Snowy!", then the weather is changed to Hail.

Page 51:

# Speech: Speakers

This subsection details methods of setting how your speakers and their text windows are displayed, the different ways in which you may edit and customize them, and examples of how these utilities may be used.

***

<mark style="background-color:orange;">**Manually Setting a Speaker**</mark>

Sometimes you may want to force certain speakers to tag in during dialogue without assigning any lines of speech to them yet. This may be because you want something to happen while they are on screen, but *before* they actually speak any lines. To do this, you would use the <mark style="background-color:blue;">"setSpeaker"</mark> Command Key.

For example, perhaps you want to set a scenario where the opposing trainer slides on screen to begin speaking, but before they actually say any lines, the battle music changes to indicate that now things are getting "serious." This may look something like this:

```
"AfterLastSwitchIn_foe" => {
  "setSpeaker" => :Self,
  "changeBGM"  => ["Battle Elite", 1],
  "speech"     => "No more playing around!"
}
```

In this scenario, after the opponent sends out their final Pokemon, they will slide on screen and begin a cinematic speech event. However, the text entered with the <mark style="background-color:blue;">"speech"</mark> Command Key will only be displayed *after* the battle music fades out and changes. It's a small thing, but little flourishes like this can be accomplished by utilizing the <mark style="background-color:blue;">"setSpeaker"</mark> key.

If you ever want to hide the sprite of the current speaker, but don't want to exit entirely from the speech event, you can accomplish this by setting this key to `:Hide`, instead.

***

<mark style="background-color:yellow;">**Bystander Speakers**</mark>

However, this is by no means the extent of the usefulness of this Command Key. This can also be used to manually set entirely custom speakers who aren't even participating in this battle. For example, let's say you're battling some Team Rocket grunts, and you want the Rocket Boss to slide in to speak as if he's watching this battle unfold in the background. Typically, this wouldn't be possible since you can only set speakers with indexes of existing battlers. However, with the <mark style="background-color:blue;">"setSpeaker"</mark> rule you aren't limited to battler indexes. You can manually set any trainer sprite to appear on screen that you desire. To accomplish this, all you need to do is set the ID of the specific trainer type you want to use as a speaker, like so:

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F3DmUciExIN6ruP3gZZAc%2Fdemo9.gif?alt=media&#x26;token=044df525-463a-4a43-95a7-39a24969b807" alt="" width="381"><figcaption></figcaption></figure>

```
"RoundStartCommand_foe" => {
  "setSpeaker" => :ROCKETBOSS,
  "speech"     => ["Go, minions!", "Teach this child some manners!"]
}
```

In this scenario, the sprite used for the `:ROCKETBOSS` trainer type will appear on screen to speak. This can be done with any trainer type. You'll notice however, that the display name for this speaker will be the generic name for the trainer class itself, rather than an individual trainer. What if you wanted to set a specific name for a character, rather than using this generic class name? This can be done by using the <mark style="background-color:blue;">"editWindow"</mark> Command Key. I'll go into more detail about this in the "Editing Speaker Windows" section further down.

***

<mark style="background-color:yellow;">**Pokemon Speakers**</mark>

As explained above, it's entirely possible to have bystanders slide on screen to speak who aren't even participating in battle. However, this isn't only limited to trainers. You can also set any Pokemon species you want to be a speaker as well. This has more niche uses, since Pokemon typically don't speak, but there may be situations where you may want to utilize this feature. The way you set this is identical to how you set trainers. All that you have to do is set the species ID for the Pokemon you'd like to set as a speaker, like so:

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FPUcmoCp8Y8BdIj3SXaV5%2Fdemo13.gif?alt=media&#x26;token=1e1dfa17-20a9-48c9-811e-12a67b4a3155" alt="" width="381"><figcaption></figcaption></figure>

```
"RoundStartCommand_foe" => {
  "setSpeaker" => :MEWTWO,
  "speech"     => "My clone army will not fall to your inferior originals!"
}
```

This example is inspired by *Pokemon: The First Movie* where Mewtwo challenges trainers with his genetically enhanced super clones. Let's say that the player is battling a wild Charizard "super clone". In this scenario, Mewtwo will slide on screen at the start of the battle to say this line of speech, even though Mewtwo itself isn't participating in this battle.

Unlike with trainers however, individual species can often have a variety of sprites based on things like their form, gender, or shinyness. Because of this, you may enter these attributes in an array in this same order to customize the specific sprite of the species that should appear. For example:

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F8EeIhezVuxP4zuGOzri5%2Fdemo14.gif?alt=media&#x26;token=1d342cb6-2456-4b0c-b4d3-4d6c6b61ef8f" alt="" width="381"><figcaption></figcaption></figure>

```
"RoundStartCommand_foe" => {
  "setSpeaker" => [:CHERRIM, 1, 1, true],
  "speech"     => "Cherr!"
}
```

In this example, Cherrim is set as the speaker. However, several of its attributes have been set to customize the specific sprite that should be displayed. Its form has been set to 1 (Sunshine form), as well as its gender (female). As the last entry, a boolean is set to determine whether this should be a shiny sprite or not. If no boolean is included, it is assumed to be `false` by default. Note that setting the Pokemon's gender also changes the default windowskin it uses for speech, so this is still relevant to set even if the species itself doesn't have any visual gender differences. If no gender is set, then its gender will be determined from the gender ratio of the species itself. For example, Chansey speakers will always be female, since Chansey itself is a female-only species. For species without a set gender, this is randomly determined.

If you'd like to set a custom name for this Pokemon speaker, this can be done by using the <mark style="background-color:blue;">"editWindow"</mark> Command Key. I'll go into more detail about this in the "Editing Speaker Windows" section further down.

***

<mark style="background-color:orange;">**Editing Speaker Sprites**</mark>

Sometimes you may want to edit a speaker in some way while they are in the middle of speaking, instead of setting a new speaker to be swapped in. This can be handled with the <mark style="background-color:blue;">"editSpeaker"</mark> Command Key. For example, let's say you want to change a speaker while they are on screen to reveal their true identity...

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FxOnjDdkhoEEa6rfN8086%2Fdemo11.gif?alt=media&#x26;token=004fe3b4-bd4e-4d2e-92c8-c09293190682" alt="" width="381"><figcaption></figcaption></figure>

```
"BattleEndWin" => {
  "speech_A"    => ["Alright! You got me!", "I'm actually a..."],
  "editSpeaker" => :TEAMROCKET_M,
  "speech_B"    => "..spy for Team Rocket!"
}
```

In this example, after the player wins the battle and the trainer slides on screen to say their lose text, this speech event will trigger where they reveal their true identity as a member of Team Rocket. The speaker sprite will instantly update instead of sliding off screen. You can use this to instantly update the speaker's sprite. The way this is handled functions identically to the way you would set up the arguments for the <mark style="background-color:blue;">"setSpeaker"</mark> key. The only difference here is that <mark style="background-color:blue;">"setSpeaker"</mark> sets the appearance of the *next* speaker, while <mark style="background-color:blue;">"editSpeaker"</mark> changes the appearance of the *current* speaker.

Another way which you may use this is to set different "frames" of the same speaker to display some quasi-animations. This can only be done if you have several different sprites of the same speaker. You can use this to emphasize emotions or just add a little extra flair to your speaker's speech.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FwDYpsMrg57m8u8R40rhM%2Fdemo12.gif?alt=media&#x26;token=fc2f0748-c083-4af1-8ff5-bf139fd9e8ba" alt="" width="381"><figcaption></figcaption></figure>

```
"RoundStartCommand_foe" => {
  "speech_A"      => "You're going down, this time!",
  "editSpeaker_A" => :RIVAL2,
  "speech_B"      => "I'll beat you without even breaking a sweat!",
  "editSpeaker_B" => :RIVAL1,
  "speech_C"      => "Good luck! You're gonna need it!"
}
```

***

<mark style="background-color:orange;">**Editing Speaker Windows**</mark>

You may also edit a speaker's message boxes independently from the speaker themselves. For example, let's say you want to change a speaker's name or windowskin in the middle of their dialogue, without changing the current speaker at all. This can be accomplished by using the <mark style="background-color:blue;">"editWindow"</mark> Command Key. Here's an example:

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FHDHBoMPtGMv1L0n9jCxa%2Fdemo3.gif?alt=media&#x26;token=ff11c6b7-752c-4bd3-8448-4518bee4e6e0" alt="" width="381"><figcaption></figcaption></figure>

```
"BattleEndWin" => {
  "speech_A"   => "I...lost. I guess I'm no longer champion...",
  "editWindow" => "Former Champion",
  "speech_B"   => "That title now belongs to you."
}
```

Here, the champion speaks upon the player defeating him and relinquishes his title. The <mark style="background-color:blue;">"editWindow"</mark> key is used to change the speaker's name to "Former Champion" to indicate they no longer hold the title. If you'd also like to edit the windowskin used, you can enter this as an array with the second item in the array being the file name of the windowskin you'd like to use.&#x20;

Note that if you simply want to change the "gender" of the windowskin used, you can input numbers instead of file names. If you want to use the blue boarder windowskin typically used for male speech, you can just input 0. For the red boarder windowskin typically used for female speech, you can just input 1. Any other number you enter will give you the windowskin used for genderless speech.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F2uSiHihn4bkFKZYn6MRv%2Fdemo1.gif?alt=media&#x26;token=c73623db-25b6-430f-9afd-1e93c9c46956" alt="" width="381"><figcaption><p>Windowskin examples</p></figcaption></figure>

If you would ever like to hide the speaker's text boxes entirely for some reason, then this can also be accomplished by setting "editWindow" to the symbol `:Hide`. If you'd like the text boxes to reappear, then you may set this to the symbol `:Show`.

You can combine the use of the <mark style="background-color:blue;">"editWindow"</mark> and <mark style="background-color:blue;">"setSpeaker"</mark>/<mark style="background-color:blue;">"editSpeaker"</mark> Command Keys to fully customize your speakers. Lets return to a few of the earlier examples in this subsection and combine these keys to full effect.&#x20;

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FSOfYdjeolZpW8F75TLCw%2Fdemo10.gif?alt=media&#x26;token=3e09e9b9-52c6-44b1-852f-a92f1ba0a62d" alt="" width="381"><figcaption></figcaption></figure>

```
"RoundStartCommand_foe" => {
  "setSpeaker" => :ROCKETBOSS, 
  "editWindow" => ["Giovanni", "speech hgss 10"],
  "speech"     => ["Go, minions!", "Teach this child some manners!"]
}
```

Going back to this example with the Rocket Boss used earlier, we can now update this to include a custom name and windowskin for this speaker.

If you want to edit the speaker's windowskin, but you *don't* want to edit their name, then you can do this by simply setting the name entry to nil. Doing so will keep the speaker's default name while still setting a custom windowskin. Let's return to the very first example found on this page and edit its windowskin to demonstrate this:

```
"AfterLastSwitchIn_foe" => {
  "setSpeaker" => :Self,
  "editWindow" => [nil, "choice 24"],
  "changeBGM"  => ["Battle Elite", 1],
  "speech"     => "No more playing around!"
}
```

You can edit the windows of any speaker, even ones who don't appear on screen, such as the player. This can be used as a way of implying there are off-screen speakers who are supporting you during the battle by changing the player's name and/or windowskin.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FqeKLcuqehmAtI1yLdIsO%2F%5B2024-01-11%5D%2021_48_47.209.png?alt=media&#x26;token=f77aca0e-c5f8-48ab-8e43-d05950d33931" alt="" width="384"><figcaption></figcaption></figure>

```
"RoundEnd_player_1" => {
  "setSpeaker" => :Self, 
  "editWindow" => ["Prof. Oak", 0],
  "speech"     => "Quite impressive, \\PN!"
}
```

In this example, we've set the speaker as the player, but edited the window so that it appears as if Proffessor Oak is commenting on the player's performance from off screen.

Page 52:

# Advanced: Variable Utilities

This subsection will introduce the midbattle variable and how it can be utilized within a midbattle script. Examples are provided to give a clearer picture in how this can be applied.

***

<mark style="background-color:orange;">**Manipulating the Variable's Value**</mark>

By default, this variable is set to zero at the start of every battle. However, you can manipulate this variable's default value by manually setting it to the specific value you desire. To do this, we would use the <mark style="background-color:blue;">"setVariable"</mark> Command Key.

```
"RoundEnd_foe_every_4" => {
  "setVariable" => 0
}
```

In this example, the value of the variable is reset to zero at the end of every 4th turn. Something like this can be utilized if you want to have some sort of timer in battle that resets every four turns. This is a handy want of have some way to hard reset this variable once it has reached a value threshold that you needed it to.

If you want this variable to start counting in response to something, you may do so by utilizing the <mark style="background-color:blue;">"addVariable"</mark> key. For example, let's say you want the variable to be increased by 1 at the start of each round in a battle.

```
"RoundStartCommand_foe_repeat" => {
  "addVariable" => 1
}
```

You could use something like this to accomplish that. Now each turn, the variable's value will be increased by 1. If you want to *reduce* the variable's value instead, you would still use the <mark style="background-color:blue;">"addVariable"</mark> key, except you would set this to a negative number instead. For example, if set to -1, then the variable would be reduced by 1 each turn.&#x20;

If you want to randomize how much this variable should be changed by, you can instead set it to an array with as many different values as you want, and one of these values will randomly be selected to add to the variable's total value. For example:

```
"RoundStartCommand_foe_repeat" => {
  "addVariable" => [1, 4, -2, 0]
}
```

This would add to the value at the start of each turn, but the amount would be randomly selected amongst the values in the array.

Finally, if you want to increase the variable's value by a certain factor rather than directly adding an amount, you can accomplish this with the <mark style="background-color:blue;">"multVariable"</mark> Command Key.

```
"RoundStartCommand_foe_repeat" => {
  "multVariable" => 2
}
```

In this example, the value of the variable will now double at the start of each round. If you would like to reduce the variable by a certain factor, you would still use the <mark style="background-color:blue;">"multVariable"</mark> key, except you would set this to a float number instead. For example, if set to 0.5, then the variable would be reduced by half each turn.

{% hint style="info" %}
Note: The value of the midbattle variable may never be less than zero. If you use any of the above methods to set or reduce the variable's value to a number less than zero, the variable will just default to zero. Keep this in mind when designing scenarios where the variable's value may decrease for some reason.
{% endhint %}

By utilizing <mark style="background-color:blue;">"setVariable"</mark>, <mark style="background-color:blue;">"addVariable"</mark> and <mark style="background-color:blue;">"multVariable"</mark>, you have full control in manipulating the value of the midbattle variable. Now let's move on to how we can make something actually *happen* in response to this variable's value.

***

<mark style="background-color:orange;">**Responding to the Variable's Value**</mark>

Any time you utilize the <mark style="background-color:blue;">"addVariable"</mark> or <mark style="background-color:blue;">"multVariable"</mark> Command Keys described in the above section of this page, a series of Trigger Keys are checked for. These are the keys you want to use in order to make something happen in response to the value of the variable changing. Note that <mark style="background-color:blue;">"setVariable"</mark> does not trigger these keys.

***

<mark style="background-color:yellow;">**When the Variable Reaches a Specific Value**</mark>

Whenever the variable is changed, the <mark style="background-color:purple;">"Variable\_#"</mark> Trigger Key is checked for, where <mark style="background-color:purple;">#</mark> corresponds to the specific value of the variable. For example, if you set the Trigger Key <mark style="background-color:purple;">"Variable\_2"</mark>, this will trigger whenever the value of the variable equals exactly 2. Here's an example:

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FpL3A79ovfnl2SeGmj3jo%2Fdemo28.gif?alt=media&#x26;token=67c7b7e9-7327-4463-a0ca-474170745ddd" alt="" width="381"><figcaption></figcaption></figure>

```
"TargetDodgedMove_foe_repeat" => {
  "addVariable" => 1
},
"Variable_2" => {
  "speech" => "Man, are you battling blind-folded?"
}
```

In this example, each time the player's Pokemon misses the opponent with a move, the variable's value is increased by 1 thanks to the <mark style="background-color:blue;">"addVariable"</mark> Command Key. Once this value reaches 2, this will trigger a speech event thanks to the <mark style="background-color:purple;">"Variable\_2"</mark> Trigger Key where the opponent mocks you about your inaccuracy.

You can include as many <mark style="background-color:purple;">"Variable\_#"</mark> keys as you want in order to check for as many different variable values as you want. For example, we can expand upon the previous example so that the opponent will now say something each time the player misses, up to 3 times.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FemDLugsJfSR5wsPFqc7Y%2Fdemo29.gif?alt=media&#x26;token=71b0c0d4-cf3a-4dec-b590-f9fc224d9bae" alt="" width="381"><figcaption></figcaption></figure>

```
"TargetDodgedMove_foe_repeat" => {
  "addVariable" => 1
},
"Variable_1" => {
  "speech" => "That's strike one."
},
"Variable_2" => {
  "speech" => "That's strike two!"
},
"Variable_3" => {
  "speech" => "Three strikes! You're outta here!"
}
```

***

<mark style="background-color:yellow;">**When the Variable Changes Value**</mark>

If you want to respond to the variable changing value, but don't want to specify a particular value to check for, you may do so with the <mark style="background-color:purple;">"VariableUp"</mark> and/or <mark style="background-color:purple;">"VariableDown"</mark> Command Keys. Unlike the normal <mark style="background-color:purple;">"Variable\_#"</mark> key, these don't require any specific number value entered. Instead, these keys simply check the value of the variable to see if it has been changed by any amount since the last time it was changed. If so, the respective key will trigger depending on whether this amount has increased or decreased.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FqzpCUA595cQHdO0HQn9t%2Fdemo31.gif?alt=media&#x26;token=072c458e-6413-4fc6-93cc-be5d5ef5b9da" alt="" width="381"><figcaption></figcaption></figure>

```
"TurnEnd_player_repeat" => {
  "speech"      => [:Opposing, "Let's flip a coin!",
                    "Heads, you win!\nTails, you lose!"],
  "text"        => [:Opposing, "{2} tossed a coin in the air!"],
  "setVariable" => 1,
  "addVariable" => [-1, 1]
},
"VariableUp_repeat" => {
  "speech"       => [:Opposing, "Heads! Lucky you!"],
  "battlerStats" => [:Random, 1]
},
"VariableDown_repeat" => {
  "speech"       => [:Opposing, "Tails! Too bad!"],
  "battlerStats" => [:Random, -1]
}
```

In this example, the opponent plays a game with the player at the end of each of the player's Pokemon's turns. During each instance, the opponent will "flip a coin." If the player wins the coin flip, their Pokemon has a random stat raised by one stage. If the player loses the coin flip, then their Pokemon has a random stat lowered by one stage. This is accomplished by using <mark style="background-color:blue;">"setVariable"</mark> to reset the variable to 1 each turn. Then, <mark style="background-color:blue;">"addVariable"</mark> is used to randomly add 1 or subtract 1 from this value, simulating a coin flip. Finally, the <mark style="background-color:purple;">"VariableUp"</mark> or <mark style="background-color:purple;">"VariableDown"</mark> Trigger Key will trigger depending on this outcome.

If you want something to happen when the variable's value is changed, but only if its new value is above or below a certain value, then you may do so by using the <mark style="background-color:purple;">"VariableOver\_#"</mark> and <mark style="background-color:purple;">"VariableUnder\_#"</mark> Trigger Keys, respectively. The <mark style="background-color:purple;">#</mark> in these keys represent the number which the variable's value should be compared to.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FUnhXLNXOC3XL5peS65Ns%2Fdemo30.gif?alt=media&#x26;token=d55f4265-c0d7-45ac-8fc6-45dc92c0e90c" alt="" width="381"><figcaption></figcaption></figure>

```
"AfterItemUse_player_repeat" => {
  "addVariable" => 1
},
"VariableOver_2" => {
  "speech" => [1, "Ugh...stop spamming items!"]
}
```

In this example, the variable's value is increased by 1 each time the player uses an item from their bag. Once this variable reaches a value which is greater than 2, a speech event will trigger in which the opponent will comment on the player's repeated item use.

The same idea works in reverse when using <mark style="background-color:purple;">"VariableUnder\_#"</mark>, which will trigger only when the variable's value has been reduced, but only if this value is less than the entered number.

Page 53:

# Advanced: Storing Scripts

Midbattle hashes can be quite long and complex. Because of this, sometimes It's simply impractical to include the entire thing in the <mark style="background-color:green;">"midbattleScript"</mark> Battle Rule in an event. To address this, I've created a secondary way of implementing a midbattle script by simply using a symbol ID to refer to an entire hash. This is done by instead creating the entire hash in the plugin scripts themselves. This can be done by using the `MidbattleScripts` module.

In the Deluxe Battle Kit plugin scripts, create a new script file (in the `RB` format, like the rest of the plugin scripts) and name this new file whatever you want. You can install [**Notepad++**](https://notepad-plus-plus.org/) for these types of files, if you don't already have a program that recognizes this format. In here, create a module called `MidbattleScripts`. Inside this module, you can save as many midbattle hashes as you want as constants, which you can then call upon as a shortcut to that midbattle hash without having to include the entire thing in a battle rule. This allows you to make as long of a script as you want without having to worry about cramming each event with enormous scripts.\
\
For example, say your custom file contained this script:

```
module MidbattleScripts
  MIDBATTLE_EXAMPLE_SCRIPT = {
    "RoundStartCommand_1_foe" => {
      "speech" => "You're not gonna beat me this time!"
    },
    "BattleEndLose" => {
      "speech" => "See? I told you!"
    },
    "BattleEndWin" => {
      "speech" => "No! Impossible!"
    }
  }
end
```

The constant used here is named `MIDBATTLE_EXAMPLE_SCRIPT`, but you may name this whatever you wish, as long as it's unique and doesn't overlap with an existing constant within this module. Once your constant is saved, you can then call it within the <mark style="background-color:green;">"midbattleScript"</mark> Battle Rule instead of inputting the entire hash, like so:

```
setBattleRule("midbattleScript", :MIDBATTLE_EXAMPLE_SCRIPT)
```

Note that when the constant is entered in the battle rule, it needs to be entered as a symbol, meaning it requires a semi-colon in front. It shouldn't have this when entered in the module.

You can use this method to make very long and intricate midbattle hashes without having to worry about space in the event scripts. If you want more intricate examples of midbattle scripts that utilize this feature, check the plugin file `[002] Midbattle Scripting/[003] MidbattleScripts Module`.

Page 54:

# Advanced: Hardcoding

There is one final way of entering a midbattle script, which is to simply hardcode the entirety of the script itself, rather than relying on a hash. The advantage of using this method is that you are totally unrestricted in what you're able to do, as long as you have the know-how to code it. The downside is that this requires more technical grasp of Essentials and Ruby in general, and a lot of things that are simply configured automatically when entering data into a hash must now be set up manually. Because of this, setting up scripts in this manner should be reserved for more advanced users who are already somewhat competent at coding, so I'm not going to go into extensive detail here since I can assume these users can figure it out mostly by looking at examples.\
\
To hardcode a midbattle script, you have to use the `MidbattleHandlers` module to set up your own midbattle handler. To do so, open the Deluxe Battle Kit plugin scripts, create a new text file and name it whatever you want. In here, you may include all of your custom handlers. Here's an example of what one of these may look like:&#x20;

```
MidbattleHandlers.add(:midbattle_scripts, :midbattle_example_script,
  proc { |battle, idxBattler, idxTarget, trigger|
    scene = battle.scene
    case trigger
    when "RoundStartCommand_1_foe"
      scene.pbStartSpeech(1)
      battle.pbDisplayPaused(_INTL("You're not gonna beat me this time!"))
    when "BattleEndLose"
      scene.pbStartSpeech(1)
      battle.pbDisplayPaused(_INTL("See? I told you!"))
    when "BattleEndWin"
      scene.pbStartSpeech(1)
      battle.pbDisplayPaused(_INTL("No! Impossible!"))
    end
  }
)
```

I'll provide a quick breakdown of the arguments used in these handlers.

1. **Handler type**\
   This identifies whether this handler is a trigger handler, or a script handler. For your purposes, this argument should be `:midbattle_scripts`, as you are using this handler to hardcode an entire script, not a specific trigger. However, if you're designing a global midbattle script, you'd want to use `:midbattle_global` instead (more on this in the "Advanced: Global Scripts" section).<br>
2. **Script ID**\
   This is the specific ID that should be used to identify this script handler. This is what is used to actually call upon this script when entered in the <mark style="background-color:green;">"midbattleScript"</mark> Battle Rule in an event. In the above example, I used the id `:midbattle_example_script`, but this can be whatever symbol you want. This should be a unique symbol not shared by any other midbattle script handler. This is what you actually enter in the battle rule to call this script. As a rule of thumb, I suggest that these ID's are always in lower case, so that you don't risk confusing them with constants entered in the `MidbattleScripts` module outlined in the previous subsection.<br>
3. **Proc**\
   This is where you'll actually code the battle script you want. This proc will always contain the following arguments:

{% tabs %}
{% tab title="battle" %}
The battle class. You can use this to access pretty much anything you want related to the battle.
{% endtab %}

{% tab title="idxBattler" %}
The index of the battler who activated the Trigger Key. You can use this to obtain the battler object that appears at this index.
{% endtab %}

{% tab title="idxTarget" %}
The index of the target. This is usually only relevant for Trigger Keys related to using moves.
{% endtab %}

{% tab title="trigger" %}
The specific Trigger Key that has been activated.
{% endtab %}
{% endtabs %}

Once your handler is set up, you may then set this script by calling it with the the <mark style="background-color:green;">"midbattleScript"</mark> Battle Rule in an event, like so:

```
setBattleRule("midbattleScript", :midbattle_example_script)
```

***

<mark style="background-color:orange;">**Coding a Midbattle Handler**</mark>

How I suggest setting up these handlers is by using `case trigger`, followed by a series of `when X` statements for each specific Trigger Key that you want to check for where you want something to happen. Then you can simply code whatever it is you want to happen for each Trigger Key. Though, there may be situations where there's a more efficient way to set this up. If you want more intricate examples of midbattle scripts that utilize midbattle handlers, check the plugin file `[002] Midbattle Scripting/[004] MidbattleHandlers Scripts`.\
\
Something to note is that any variations of the <mark style="background-color:purple;">"\_repeat"</mark> or <mark style="background-color:purple;">"\_random"</mark> Trigger Key extensions have no use when hardcoding midbattle scripts. When coding scripts in this way, each key is automatically assumed to always trigger and always repeat indefinitely. So if you want something to only trigger once, or to only occur at a random, you have to specifically code it to do so.&#x20;

While I'm at it, here's a list of methods and/or properties that you might want to reference when hardcoding your scripts to help with this as well as other scenarios, since this plugin adds a lot of new custom content which you may need to call on to make certain things happen:

<details>

<summary><strong>Battle Class</strong></summary>

* `pbTriggerActivated?(*triggers)`\
  Returns true if any of the inputted Trigger Keys have activated in this battle at least once. You may use this to check for repeated keys if you only want a specific Trigger Key to trigger only once.<br>
* `pbPauseAndPlayBGM(track)`\
  Pauses the current BGM playing in this battle and saves its position to be restored later before playing the new `track`, which should be an audio file or name of one.<br>
* `pbResumeBattleBGM`\
  Ends the current BGM and resumes playing a previously paused BGM from the same position it was paused at. This doesn't do anything if no BGM is currently paused.

</details>

<details>

<summary><strong>Battle::Battler Class</strong></summary>

* `@damageThreshold`\
  Sets the damage cap for a battler. This works exactly as the <mark style="background-color:blue;">"battlerDamageCap"</mark> Command Key does.
* `wild_flee(fleeMsg = nil)`\
  Used to make a wild battler flee from battle. Doesn't do anything if the battler isn't a wild Pokemon. You can set `fleeMsg` to a string to set a custom message upon fleeing.

</details>

<details>

<summary><strong>Battle::Scene Class</strong></summary>

* `pbStartSpeech(speaker)`\
  Begins cinematic speech. If the entered argument is a battler index, the speaker will be set to whichever trainer owns the battler at that index. If it's a wild Pokemon, then the speaker will be set to the wild Pokemon itself. If the entered argument is a battler object, then the speaker will be set to that specific battler itself, regardless if it's owned by a trainer or not. If the speaker is set to a symbol (either a species ID or a trainer type ID), then the speaker will be set to that specific species or trainer type, even if they aren't participating in this battle. For species ID's in particular, this can be entered as an array containing the ID, form number, gender number, and a boolean to determine shininess to customize this Pokemon speaker.
* `pbGetSpeaker(speaker)`\
  If `speaker` is `nil`, this returns the object that was set as the last active speaker. This can be either an in-battle trainer or battler, a Pokemon object, or a Trainer Type object. If `speaker` is set to a battler index, this will return the object that should be assigned as the speaker for that index. For wild Pokemon, this will return the battler object itself. For non-wild Pokemon, it will return the trainer object that owns the Pokemon at that index.
* `pbHideSpeaker`\
  This will slide the sprite of the current speaker off screen (if any) during cinematic speech and close any of their message boxes which may be on screen.
* `pbShowSpeaker(speaker)`\
  This will slide in the sprite of a new speaker during cinematic speech (if any). This accepts the same arguments as `pbStartSpeech`.
* `pbUpdateSpeakerSprite(speaker)`\
  This will replace the sprite of the currently active speaker during cinematic speech (if any), without sliding the current sprite off screen first. This can be used to display different "frames" of the same speaker to convey different emotions, for example. The argument set here can either be a trainer type ID or a Pokemon species ID. For Pokemon species in particular, this can be set as an array containing the ID, form number, gender number, and a boolean to determine shininess to customize this Pokemon speaker.
* `pbShowSpeakerWindows(name, windowskin)`\
  This can be used to update and display the current speaker's and/or windowskin that is used for their dialogue. If either argument is set to `nil`, then the default name and/or windowskin will be displayed.
* `pbHideSpeakerWindows(speech)`\
  This can be used to hide the display of the current speaker's message windows. If `speech` is set to `true`, the text color will be set to white so that any displayed text can be displayed over the cinematic black bar itself, instead of within a message box.
* `pbInCinematicSpeech?`\
  Returns true if you are currently in the middle of cinematic speech.
* `pbForceEndSpeech`\
  This abruptly ends cinematic speech, hides all speaker sprites and returns the battle scene to normal.&#x20;

</details>

Page 55:

# Advanced: Global Scripts

There may be situations where you want to apply a script to make something happen mid-battle, but you can't use the <mark style="background-color:green;">"midbattleScript"</mark> Battle Rule to apply it. For example, perhaps you want something to occur during *every* wild battle, or in every battle on a specific map, or after a switch is flipped.

In this case, the best course of action may be to create a global midbattle script. A global script is one that applies at all times, and will be called by every battle. These scripts can stack on top of existing midbattle scripts without overwriting them, too.

Here's an example of a global midbattle script that this plugin utilizes to add low HP music to play whenever the HP of the player's Pokemon is low:

```ruby
MidbattleHandlers.add(:midbattle_global, :low_hp_music,
  proc { |battle, idxBattler, idxTarget, trigger|
    next if !Settings::PLAY_LOW_HP_MUSIC
    battler = battle.battlers[idxBattler]
    next if !battler || !battler.pbOwnedByPlayer?
    track = pbGetBattleLowHealthBGM
    next if !track.is_a?(RPG::AudioFile)
    playingBGM = battle.playing_bgm
    case trigger
    #---------------------------------------------------------------------------
    # Restores original BGM when HP is restored to healthy.
    when "BattlerHPRecovered_player"
      next if playingBGM != track.name
      next if battle.pbAnyBattlerLowHP?(idxBattler)
      battle.pbResumeBattleBGM
      PBDebug.log("[Midbattle Global] low HP music ended.")
    #---------------------------------------------------------------------------
    # Restores original BGM when battler is fainted.
    when "BattlerHPReduced_player"
      next if playingBGM != track.name
	  next if battle.pbAnyBattlerLowHP?(idxBattler)
      next if !battler.fainted?
      battle.pbResumeBattleBGM
      PBDebug.log("[Midbattle Global] low HP music ended.")
    #---------------------------------------------------------------------------
    # Plays low HP music when HP is critical.
    when "BattlerHPCritical_player"
      next if playingBGM == track.name
      battle.pbPauseAndPlayBGM(track)
      PBDebug.log("[Midbattle Global] low HP music begins.")
    #---------------------------------------------------------------------------
    # Restores original BGM when sending out a healthy Pokemon.
    # Plays low HP music when sending out a Pokemon with critical HP.
    when "AfterSendOut_player"
      if battle.pbAnyBattlerLowHP?(idxBattler)
        next if playingBGM == track.name
        battle.pbPauseAndPlayBGM(track)
        PBDebug.log("[Midbattle Global] low HP music begins.")
      elsif playingBGM == track.name
        battle.pbResumeBattleBGM
        PBDebug.log("[Midbattle Global] low HP music ended.")
      end
    end
  }
)
```

Unlike regular midbattle scripts, global midbattle scripts can *only* be implemented by hardcoding a midbattle script handler. So I would advise that you refer to the "Advanced: Hardcoding" section for a general breakdown on how to set up one of these handlers. The only difference with a global midbattle script handler is that it uses the `:midbattle_global` handler ID, instead of the usual `:midbattle_scripts`. Otherwise, they're structured in the same way.

Page 56:

# Example Battles

In this section, I will provide a few examples of battle set ups which combine a variety of features covered in this tutorial. These may help show what sorts of battles may be accomplished by using the tools this plugin provides. Feel freel to copy/paste these into an event to try them out for yourself first hand!

Page 57:

# Examples: Wild Battles

<mark style="background-color:red;">**Wild Battle Example # 1**</mark>

The example below demonstrates a 1v1 battle against a wild Deoxys. In this battle, the following rules are set:

* <mark style="background-color:green;">"cannotRun"</mark> is used to prevent the playing from fleeing.
* <mark style="background-color:green;">"disablePokeBalls"</mark> is used to prevent the player from manually throwing Poke Balls.
* <mark style="background-color:green;">"terrain"</mark> is used to set permanent Psychic terrain.
* <mark style="background-color:green;">"environ"</mark> is used to set the battle environment to :Space.
* <mark style="background-color:green;">"backdrop"</mark> and <mark style="background-color:green;">"base"</mark> are used to customize the battle backdrop and bases, respectively.
* <mark style="background-color:green;">"alwaysCapture"</mark> is used to ensure a 100% capture rate in this battle.
* <mark style="background-color:green;">"battleBGM"</mark> is used to set custom battle music.
* <mark style="background-color:green;">"battleIntroText"</mark> is used to set custom battle intro text.
* <mark style="background-color:green;">"editWildPokemon"</mark> is used to edit the following attributes of the wild Deoxys:
  * Name is set to "????" so that it may be "revealed" in battle.
  * Obtain location is set to "Outer Space."
  * Flagged as Super Shiny.
  * Given Pokerus.
  * HP Level set to 2, multiplying its natural HP 2x.
  * Given boss immunity to OHKO effects, effects that would force it to flee, and all forms of indirect damage.
* <mark style="background-color:green;">"midbattleScript"</mark> is used to set a script to use for this battle which does the following:
  * "Reveals" Deoxy's real name at the start of the battle.
  * Sets a damage cap for Deoxys so that it will survive with 1 HP regardless of damage taken.
  * At the end of each round, Deoxys will cycle to its next form and recover its HP/Status.
  * Whenever Deoxys takes damage from an attack, it recovers back a little HP.
  * When Deoxy's HP falls to 25% or lower, it stops regenerating HP.
  * When Deoxys reaches the set damage cap (1 HP) after its regeneration has ended, the player will automatically throw a Poke Ball to capture Deoxys. This capture is guaranteed thanks to the <mark style="background-color:green;">"alwaysCapture"</mark> rule.

```ruby
setBattleRule("cannotRun")
setBattleRule("disablePokeBalls")
setBattleRule("terrain", :Psychic)
setBattleRule("environ", :Space)
setBattleRule("backdrop", "elite4")
setBattleRule("base", "distortion")
setBattleRule("alwaysCapture")
setBattleRule("battleBGM", "Battle roaming")
setBattleRule("battleIntroText", "You encountered an alien invader!")
setBattleRule("editWildPokemon", {
  :name        => "????",
  :obtain_text => "Outer Space.",
  :super_shiny => true,
  :pokerus     => true,
  :hp_level    => 2,
  :immunities  => [:OHKO, :ESCAPE, :INDIRECT]
})
setBattleRule("midbattleScript", {
  "RoundStartCommand_1_foe" => {
    "text_A"       => "You used Prof. Pluto's Roto-Dex upgrade to identify the alien species!",
    "playSE"       => "PC access",
    "battlerName"  => "Deoxys",
    "battlerHPCap" => -1,
    "text_B"       => "The alien species was identified as Deoxys!"
  },
  "RoundEnd_foe_repeat" => {
    "playSE"        => "Anim/Sound2",
    "battlerForm"   => [:Cycle, "{1} suddenly mutated!"],
    "playCry"       => :Self,
    "battlerMoves"  => :Reset,
    "ignoreAfter"   => "TargetHPLow_foe",
    "battlerStatus" => [:NONE, true],
    "battlerHP"     => [4, "{1} regenerated some HP!"]
  },
  "TargetTookDamage_foe_repeat" => {
    "ignoreAfter" => "TargetHPLow_foe",
    "text"        => "{1} started to regenerate!",
    "battlerHP"   => [8, "{1} regenerated some HP!"]
  },
  "TargetHPLow_foe" => {
    "text" => "{1} has become too weak to regenerate any more HP!"
  },
  "BattlerReachedHPCap_foe" => {
    "speech"       => [:Opposing, "It's getting weak!\nIt's now or never!", "Go, Poké Ball!"],
    "disableBalls" => false,
    "useItem"      => :POKEBALL
  },
  "AfterCapture" => [0, "Phew...it's finally over.", "The professor would be proud."]
})
WildBattle.start(:DEOXYS, 50)
```

***

<mark style="background-color:red;">**Wild Battle Example # 2**</mark>

The example below demonstrates a double battle where the player and their partner May encounter a wild Latias and Latios. In this battle, the following rules are set:

* <mark style="background-color:green;">"cannotRun"</mark> is used to prevent the playing from fleeing.
* <mark style="background-color:green;">"weather"</mark> is used to set permanent Hail.
* <mark style="background-color:green;">"backdrop"</mark> is used to customize the battle backdrop and bases.
* <mark style="background-color:green;">"editWildPokemon"</mark> is used to edit the following attributes of the wild Latias:
  * Nature is set to Modest.
  * Given Soul Dew to hold.
  * Ability is set to Healer.
  * Given the moves Life Dew, Reflect, Helping Hand, and Psychic.
* <mark style="background-color:green;">"editWildPokemon2"</mark> is used to edit the following attributes of the wild Latios:
  * Nature is set to Adamant.
  * Given Soul Dew to hold.
  * Ability is set to Friend Guard.
  * Given the moves Dragon Dance, Breaking Swipe, Zen Headbutt, and Earthquake.
* <mark style="background-color:green;">"midbattleScript"</mark> is used to set a script to use for this battle which does the following:
  * When either Latios or Latias reach 25% HP or lower, they will call upon the other to heal them.
  * When either Latios or Latias faint, the remaining one will flee, ending the battle.

```ruby
setBattleRule("cannotRun")
setBattleRule("weather", :Hail)
setBattleRule("backdrop", "champion2")
setBattleRule("editWildPokemon", {
  :nature  => :MODEST,
  :item    => :SOULDEW,
  :ability => :HEALER,
  :moves   => [:LIFEDEW, :REFLECT, :HELPINGHAND, :PSYCHIC]
})
setBattleRule("editWildPokemon2", {
  :nature  => :ADAMANT,
  :item    => :SOULDEW,
  :ability => :FRIENDGUARD,
  :moves   => [:DRAGONDANCE, :BREAKINGSWIPE, :ZENHEADBUTT, :EARTHQUAKE]
})
setBattleRule("midbattleScript", {
  "TargetHPLow_foe_repeat" => {
    "text_A"    => "{1} calls out to its partner with a whimpering cry!",
    "playCry"   => :Self,
    "text_B"    => [:Ally, "{1} comes to its partner's aid!"],
    "battlerHP" => [4, "{1} restored a little HP!"]
  },
  "BattlerFainted_foe" => {
    "setBattler" => :Ally,
    "text"       => "{1} looks upset by its partner's defeat...\nIt lost the will to fight!",
    "wildFlee"   => true
  }
})
pbRegisterPartner(:POKEMONTRAINER_May, "May")
WildBattle.start(:LATIAS, 30, :LATIOS, 30)
```

Page 58:

# Examples: Trainer Battles

<mark style="background-color:red;">**Trainer Battle Example # 1**</mark>

The example below demonstrates a 1v1 quiz battle vs Gym Leader Opal, as she appeared in Pokemon Sword & Shield. In this battle, the following rule is set:

* <mark style="background-color:green;">"midbattleScript"</mark> is used to set a script to use for this battle which does the following:
  * At the end of the first round, Opal quizes the player on what her nickname is. If the player guesses right, their Pokemon's Speed is increased by 2 stages. If the player guesses wrong, their Pokemon's Speed is decreased by 2 stages.
  * At the end of the third round, Opal quizes the player on her favorite color. If the player guesses right, their Pokemon's defenses are increased by 2 stages. If the player guesses wrong, their Pokemon's defenses are decreased by 2 stages.
  * At the end of the fifth round, Opal quizes the player on her age. If the player guesses the answer she wants to hear, their Pokemon's offenses are increased by 2 stages. If the player guesses wrong, their Pokemon's offenses are decreased by 2 stages.
  * Before Opal speaks a message prior to sending out her final Pokemon.

```ruby
setBattleRule("midbattleScript", {
  "RoundEnd_1_foe" => {
    "setChoices" => [:nickname, 2, {
                      "The magic-user" => "Bzzt! Too bad!",
                      "The wizard"     => "Ding ding ding! Congratulations, you're correct."
                    }],
    "speech"     => ["Question!", "You...\nDo you know my nickname?", :Choices]
  },
  "ChoiceRight_nickname" => {
    "setBattler"   => :Opposing,
    "battlerStats" => [:SPEED, 2]
  },
  "ChoiceWrong_nickname" => {
    "setBattler"   => :Opposing,
    "battlerStats" => [:SPEED, -2]
  },
  "RoundEnd_3_foe" => {
    "setChoices" => [:color, 2, {
                      "Pink"   => "That's what I like to see in other people, but it's not what I like for myself.",
                      "Purple" => "Yes, a nice, deep purple...\nTruly grand, don't you think?"
                    }],
    "speech"     => ["Question!", "What is my favorite color?", :Choices]
  },
  "ChoiceRight_color" => {
    "setBattler"   => :Opposing,
    "battlerStats" => [:DEFENSE, 2, :SPECIAL_DEFENSE, 2]
  },
  "ChoiceWrong_color" => {
    "setBattler"   => :Opposing,
    "battlerStats" => [:DEFENSE, -2, :SPECIAL_DEFENSE, -2]
  },
  "RoundEnd_5_foe" => {
    "setChoices" => [:age, 1, {
                      "16 years old" => "Hah!\nI like your answer!",
                      "88 years old" => "Well, you're not wrong. But you could've been a little more sensitive."
                    }],
    "speech"     => ["Question!", "All righty then... How old am I?", :Choices]
  },
  "ChoiceRight_age" => {
    "setBattler"   => :Opposing,
    "battlerStats" => [:ATTACK, 2, :SPECIAL_ATTACK, 2]
  },
  "ChoiceWrong_age" => {
    "setBattler"   => :Opposing,
    "battlerStats" => [:ATTACK, -2, :SPECIAL_ATTACK, -2]
  },
  "BeforeLastSwitchIn_foe" => "My morning tea is finally kicking in, and not a moment too soon!"
})
TrainerBattle.start(:LEADER_Opal, "Opal")
```

***

<mark style="background-color:red;">**Trainer Battle Example # 2**</mark>

The example below demonstrates a 1v1 battle vs a Team Rocket grunt who is blocking the exit of a collapsing cave. In this battle, the following rules are set:

* <mark style="background-color:green;">"canLose"</mark> is used to allow the player to continue even if they lose the battle.
* <mark style="background-color:green;">"victoryBGM"</mark> is used to set no victory music to play if you win this battle.
* <mark style="background-color:green;">"battleIntroText"</mark> is used to customize the intro text at the start of the battle.
* <mark style="background-color:green;">"opponentLoseText"</mark> is used to set custom lose text for this trainer when you beat them.
* <mark style="background-color:green;">"midbattleScript"</mark> is used to set a script to use for this battle which does the following:
  * Informs the player at the start of the battle that the cave is collapsing and they have a limited number of turns to win the battle.
  * Plays a sound effect and displays a message at the end of each turn to indicate the cave is in the midst of collapsing.
  * When the HP of the opponent's final Pokemon is low, they will stand their ground to recover some HP, and increase both of their defenses by two stages.
  * At the end of the second round, a falling rock falls on your Pokemon's head, dealing damage to them and causing confusion.
  * At the end of the third round, a message is displayed indicating that the player is almost out of time.
  * At the end of the fourth round, the player has run out of time and is forced to recall their Pokemon and flee the battle to escape the cave.
  * Upon the player forfeiting the match, the opponent will speak a message taunting the player.

```ruby
setBattleRule("canLose")
setBattleRule("victoryBGM", "")
setBattleRule("battleIntroText", "{1} blocks your escape!")
setBattleRule("opponentLoseText", "H-hey wait! Don't abandon me in here...")
setBattleRule("midbattleScript", {
  "RoundStartCommand_1_foe" => {
    "playSE"  => "Mining collapse",
    "text_A"  => "The cave ceiling begins to crumble down all around you!",
    "speech"  => ["I am not letting you escape!", "I don't care if this whole cave collapses down on the both of us...haha!"],
    "text_B"  => "Defeat your opponent before time runs out!"
  },
  "RoundEnd_player_repeat" => {
    "playSE" => "Mining collapse",
    "text"   => "The cave continues to collapse all around you!"
  },
  "RoundEnd_2_player" => {
    "text"          => "{1} was struck on the head by a falling rock!",
    "playAnim"      => [:ROCKSMASH, :Opposing, :Self],
    "battlerHP"     => -4,
    "battlerStatus" => :CONFUSED
  },
  "RoundEnd_3_player" => {
    "text" => ["You're running out of time!", "You need to escape immediately!"]
  },
  "RoundEnd_4_player" => {
    "text_A"    => "You failed to defeat your opponent in time!",
    "playAnim"  => ["Recall", :Self],
    "text_B"    => "You were forced to flee the battle!",
    "playSE"    => "Battle flee",
    "endBattle" => 3
  },
  "LastTargetHPLow_foe" => {
    "speech"       => "My {1} will never give up!",
    "endSpeech"    => true,
    "playAnim"     => [:BULKUP, :Self],
    "playCry"      => :Self,
    "battlerHP"    => [2, "{1} is standing its ground!"],
    "battlerStats" => [:DEFENSE, 2, :SPECIAL_DEFENSE, 2]
  },
  "BattleEndForfeit" => "Haha...you'll never make it out alive!"
})
TrainerBattle.start(:TEAMROCKET_M, "Grunt", 1)
```

Page 59:

# Miscellaneous Utilities

This section will briefly touch on a variety of smaller features or mechanics implemented by this plugin that don't really fit anywhere else in the guide, or aren't significant enough to warrant their own dedicated section.

***

<mark style="background-color:orange;">**Shorted Move Names**</mark>

As the Pokemon series has gone on, character limits on move names has increased, allowing for moves with much longer names than in older generations. However, the default Essentials battle UI isn't designed to handle moves with really long names, so these moves can break the UI when trying to display them. To resolve this, the Deluxe Battle Kit allows you to truncate these long names with ellipses while displayed in the fight menu.&#x20;

To toggle whether this feature applies, this can be done by simply opening the Settings file in the Deluxe Battle Kit plugin, and setting the `SHORTEN_MOVES` setting to `true` or `false` to turn the feature on or off.

![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Frw8R6AWaQpvycyq8DguV%2F%5B2024-01-14%5D%2010_33_08.674.png?alt=media\&token=9e3ec234-fd4c-4fc1-aee3-a90fc32f6bc3)    ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F9jhh2H3NKyN8eiKEfbDa%2F%5B2024-01-14%5D%2010_32_15.738.png?alt=media\&token=3e51c88a-ff67-411e-9221-ce1a7391bb57)

The examples above displays a mock move which was given the apt name "Move With a Very Long Name." On the left, this is how this move would appear normally. As you can see, the name is so long that it breaks the menu UI. On the right, however, this is how this same move would appear when the `SHORTEN_MOVES` setting is turned on, truncating the move name with ellipses so that it now properly fits in the UI.

***

<mark style="background-color:orange;">**Low HP Music**</mark>

In *Pokemon Black & White*, a feature was introduced where the battle music would change whenever the HP of the player's Pokemon reached critically low levels. This plugin replicates this feature by utilizing a global midbattle script to change the battle music in these scenarios.

To toggle whether this feature applies, this can be done by simply opening the Settings file in the Deluxe Battle Kit plugin, and setting the `PLAY_LOW_HP_MUSIC` setting to `true` or `false` to turn the feature on or off.

If you'd like to disable or change the BGM that plays for specific battles, you may do so by using the <mark style="background-color:green;">"lowHealthBGM"</mark> Battle Rule.

***

<mark style="background-color:orange;">**Trainer Battle with Selection Sizes**</mark>

One feature added by this plugin is the ability to initiate trainer battles where the player may only bring a select number of Pokemon from their party into battle. For example, if you want to set up a Gym Leader battle where the player can only bring 2 party members into battle, you do so.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FHZub0FsxUtzwDnYfZX2L%2FAnimation2.gif?alt=media&#x26;token=c03bd91b-703b-4999-95a8-84ead05e09c6" alt="" width="375"><figcaption><p>Brock requires you to select only 2 party members to battle with.</p></figcaption></figure>

In order to set this up, you can use the following battle call to initiate this:

```
TrainerBattle.select_start(size, *args)
```

With this battle call, `size` can be set to the number of party members the player must select to enter battle with. While `args` should just be the normal conditions that you would normally enter in a `TrainerBattle.start` battle call (trainer type, trainer name, version, etc.).

***

<mark style="background-color:orange;">**Deluxe Plugin Settings in Debug Menu**</mark>

While playing in Debug mode, there will now be a new option in the Debug menu named "Deluxe plugin settings..." In this menu, you will find options for toggling a variety of features related to special battle mechanics. By default, this will include the ability to toggle the availability of Mega Evolution on or off.

![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FdvJ02j6kQ3rFyQLLAp96%2F%5B2024-02-05%5D%2012_08_24.263.png?alt=media\&token=31f35768-9dc7-447b-8eaf-3e2da44ffc16)    ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FTcOidP2cxreuImaxsDgJ%2F%5B2024-01-14%5D%2010_30_47.210.png?alt=media\&token=57874400-8c96-406b-b8bb-37e1c89165cb)

Other add-on plugins for the Deluxe Battle Kit may introduce new options, such as the ability to toggle off Z-Moves, setting the maps that are capable of supporting Dynamax, or charging the player's Tera Orb, for example. Remember to check this menu option when installing a new add-on plugin for the Deluxe Battle Kit, as chances are it will introduce new Debug options here.

***

<mark style="background-color:orange;">**Held Mega Stones in the Party Menu**</mark>

Essentials is capable of displaying held item icons for specific types of items that differ from the generic icon. The Deluxe Battle Kit utilizes this code to fully implement this feature for Mega Stones, as seen below.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FAW1h2hnHistVEZ7oNKqT%2F%5B2024-01-12%5D%2011_12_51.003.png?alt=media&#x26;token=eba6fc9c-b06e-4c29-b52d-bb500bde7bbd" alt="" width="384"><figcaption><p>Example of a held Mega Stone icon.</p></figcaption></figure>

***

<mark style="background-color:orange;">**Primal Reversion Counter**</mark>

Essentials internally keeps track of a variety of the player's game statistics. Things such as number of Repels used, number of eggs hatches, or battles won. One of those statistics is how many times the player has used Mega Evolution, which can be called with `$stats.mega_evolution_count`.

However, the same isn't true for Primal Reversion. There is no internal counter for the number of times your Pokemon have entered Primal form through this mechanic. Which is understandable, since it's a fairly niche feature compared to Mega Evolution. However, adding a counter for this is rather trivial, so I decided to throw one in for the heck of it.

With the Deluxe Battle Kit installed, the game will now keep track of how many times the player's Pokemon have used Primal Reversion. To call this counter, you may use the following script:

`$stats.primal_reversion_count`

***

<mark style="background-color:orange;">**Wild Mega Battle Counter**</mark>

The game will now also keep count of the number of wild Mega Battles won. This counts whenever the player defeats or captures a wild Mega Pokemon that was encountered through the use of the <mark style="background-color:green;">"wildMegaEvolution"</mark> Battle Rule.&#x20;

To call this counter, you may use the following script:

`$stats.wild_mega_battles_won`

***

<mark style="background-color:orange;">**Improved HighCriticalHitRate Move Flag**</mark>

In the `moves.txt` PBS file, you can flag a move as a high critical hit ratio move by giving it the `HighCriticalHitRate` flag. This flag essentially grants a +1 critical hit stage to those moves. However, there is one example of a move that has a +2 critical hit ratio, essentially as if the Pokemon used Focus Energy. This is the Z-Move 10,000,000 Volt Thunderbolt.

Because this move has this unique property, I decided to update how this move flag works. Now, the `HighCriticalHitRate` flag can have a number attached to it in order to set the number of stages it should raise the critical hit ratio by. This is done by adding an underscore followed by the number of stages, such as `HighCriticalHitRate_2`. If this extension isn't included, then the default `HighCriticalHitRate` is always assumed to grant +1 to the move's critical hit ratio.

You can use this updated flag property to implement custom moves that grant higher critical hit ratios than your typical high-crit moves normally would. Keep in mind that anything with 4 or more stages will just be a guaranteed critical hit, so at that point you might as well just utilize the `AlwaysCriticalHit` function code.

***

<mark style="background-color:orange;">**UsesAllBattleActions Item Flag**</mark>

Some items, when used in battle, use up the player's entire turn regardless of how many Pokemon are on the player's side to issue commands to. The only types of items that behave this way by default are Poke Balls, however, many add-on plugins introduce other items which behave in this manner.

Due to this, I incorporated a new item flag to indicate the specific items that have this behavior. This is flag is called `UsesAllBattleActions`. If you're designing a custom item which you want to have this behavior, you may give your item this flag to implement it. Keep in mind, however, that this is only half of what's required. To truly implement this properly, you'll need to utilize the `firstAction` argument in the item handler for your custom item. Going into this any further would extend outside the scope of this plugin however, so I'll leave it at that.

***

<mark style="background-color:orange;">**Damage Calculation Refactor**</mark>

Essentials uses the method `pbCalcDamageMultipliers` to calculate various damage multipliers that may affect the resulting damage from an attack. This is a very long and complex method that factors in a huge range of possible effects, from weather/terrain to STAB, status effects, as wells as random effects like Charge and Helping Hand. Because of this, editing this method can be quite unruly when you're trying to implement a custom effect of some kind that can affect damage outcomes.

Because of this, I've chosen to completely recode this method in the Deluxe Battle Kit. I've refactored `pbCalcDamageMultipliers` so that it is now broken off into much smaller and more manageable chunks so that adding custom content is far easier.

If you're a more experienced user who plans on implementing new custom content that may be affected by this, you may want to take a look at this refactored code. You can find it in the plugin scripts, located in `[000] Essentials Patches/[003] Damage Calc Refactor`.

***

Page 60:

# Add-On Tutorials

The following subpages in this section provide tutorials and guides for other add-on plugins that build upon the Deluxe Battle Kit. Links to each add-on are provided in each plugin page as well as on the plugin overview page.

Page 61:

# Enhanced Battle UI

[**Eevee Expo Link**](https://eeveeexpo.com/resources/1472/)

[**PokeCommunity Link**](https://www.pokecommunity.com/threads/enhanced-battle-ui-dbk-add-on-v21-1.525837/#post-10793143)

[**Download Link**](https://www.mediafire.com/file/illn3aqmty5yv3b/Enhanced_Battle_UI.zip/file)

This plugin builds upon the Deluxe Battle Kit to add brand new elements to your battle UI. This aims to introduce various quality of life updates to the battle UI that is found in some of the modern generation of games, such as viewing details of moves, seeing the stat changes of all battlers, as well as any effects currently in play. This also adds a Poke Ball shortcut menu similar to the one found in *Pokemon Scarlet & Violet*, to quickly throw a Poke Ball in battle without having to open the Bag menu.

This plugin is broken down into three core parts - the Battler Info UI, the Poke Ball shortcut UI, and the Move Info UI. In the following subsections, I'll go into detail of each part and all the features they provide.

***

<mark style="background-color:orange;">**Battle UI Prompts**</mark>

Because this plugin adds various new UI's to battles, button prompts for each UI has been added to the battle screen, depending on which UI is available to view.

![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FHPrLeyQH917zQSyBmGOC%2F%5B2024-05-02%5D%2009_33_06.295.png?alt=media\&token=d8ea4a97-3ee3-4da0-a4bb-78b9f9973720)  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FrmdIPaTd2s7A0xl6FuWh%2F%5B2024-05-02%5D%2009_47_58.623.png?alt=media\&token=c33d23e4-4d9c-4a55-ae2e-a2e0e6fa5391)

The Battler Info UI is always accessed with the `JUMPUP` (A) key, while the Poke Ball shortcut and Move Info UI's are accessed with the `JUMPDOWN` (S) key, depending on whether you're viewing the command menu or fight menu. These button prompts will only display when it's possible to open their respective UI's, and will otherwise be hidden during move animations and such.&#x20;

However, you may control the display properties of these prompts with the `UI_PROMPT_DISPLAY` setting in the plugin file named `[000] Main`. If you wish to hide these prompts from displaying, you may set this to 0. If you'd like them to display, set this to 1. However, if you'd like the prompts to display but naturally hide after remaining idle on the command window for a few seconds, you may set this to 2. By default, this setting is set to 2.

Page 62:

# UI: Battler Info

This UI is used for displaying various information about the current state of the battlefield as well as each specific battler. This can be used to track the remaining number of turns on certain effects such as weather or terrain, the current number of stat boosts or drops a particular battler has, and so much more.

***

<mark style="background-color:orange;">**Accessing the UI**</mark>

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F83G1lphFq9PdM58kH1Pj%2F%5B2024-05-02%5D%2009_33_49.495.png?alt=media&#x26;token=a3ae3f79-e562-482c-973c-28cbe706e541" alt="" width="384"><figcaption><p>Info (A) key prompt.</p></figcaption></figure>

An "Info" prompt will appear in the bottom left hand corner of the battle screen to indicate that you can open the Battler Info UI with the press of the `JUMPUP` (A) key. This prompt will not display if `UI_PROMPT_DISPLAY` is set to zero.&#x20;

This UI may be accessed when either the command menu or fight menu are open. If so, a window will appear in the center of the screen which will display general information about all currently active Pokemon in this battle. Select a particular battler in this menu in order to open their specific battler info page.

***

<mark style="background-color:orange;">**Selecting a Battler**</mark>

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FmFHmDo3nN8QxN7hWCKQs%2Fdemo34.gif?alt=media&#x26;token=57ebbf46-b708-42b5-8aa0-41a285516845" alt="" width="381"><figcaption><p>Navigating the selection UI.</p></figcaption></figure>

All active battlers will be displayed in this UI. The Pokemon who appear in the top row are the Pokemon on the opponent's side, while the Pokemon who appear on the bottom row are the Pokemon on the player's side.

The icons, names and genders of each Pokemon will be displayed, as well as the name of their trainer in order to indicate which Pokemon belongs to which trainer. If the Pokemon is wild, then no trainer name will be displayed.

For each trainer in this battle, their party count will also be displayed next to their currently active Pokemon with a row of Poke Ball icons. Fainted Pokemon will be represented with a grayed out Poke Ball, while ones inflicted with status conditions will be completely red and darkened.

You can navigate this UI with the directional keys. Pressing the `BACK` key or the `JUMPUP` (A) key again will exit the UI. Pressing the `JUMPDOWN` (S) key will switch to the Poke Ball Shortcut UI or Move Info UI (depending on which is available, if any). If you press the `USE` key while highlighting a particular Pokemon, you will open up the battler info page for that Pokemon. Details on that part of the UI  are provided below.

{% hint style="info" %}
**Wonder Launcher Compatibility**

Note that if the Wonder Launcher add-on is installed, each trainer's current LP totals will also be displayed parallel to their party line-up during Wonder Launcher battles.
{% endhint %}

***

<mark style="background-color:orange;">**Battler Info**</mark>

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FxVTDrNea3jgvxXIVQe5Y%2Fdemo35.gif?alt=media&#x26;token=a34deff7-b808-4bc9-bffa-76498142b3b1" alt="" width="381"><figcaption><p>Navigating through the battler info pages.</p></figcaption></figure>

When a battler has been selected to view, a new window will open displaying all the relevant information related to that battler. You can press the Left/Right keys to cycle through the pages of all active battlers. If any effects are in play, you may use the Up/Down keys to scroll through that list as well.

When viewing a battler's info page, a ton of various info may be displayed. I'll go over each element that can appear in this page.

<details>

<summary>Battler Condition</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FajHyggFSR0AN7Gnj92XJ%2F%5B2024-01-19%5D%2013_24_03.922.png?alt=media&#x26;token=6ea3251e-9a8f-47d8-a112-bec298dc6e00" alt="" data-size="original">

The battler's icon, gender, and name appear in a box in the upper left hand corner of the UI. If the battler is owned by the player, the exact HP totals will appear as well. Otherwise, only the bar will be displayed.

In the box below this one, the battler's level will be displayed, as well as any status conditions they're suffering from, if any. If the battler is a shiny Pokemon, then the shiny icon will also appear in this box.

</details>

<details>

<summary>Battler Typing</summary>

To the right of the boxes detailing the battler's condition, you will see the battler's type icons. These icons will update to reflect the battler's current in-battle typing. So for example, if a battler's type was changed to Water due to the effects of the move Soak, its typing will appear as Water here.

This field may display up to three types. So if you have a battler that has 3 types for some reason (such as the effect of the move Forest's Curse), all three of its types will appear here, as the example below demonstrates.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FdGuoEubuMREXQ1FeUev7%2F%5B2024-01-19%5D%2013_12_16.404.png?alt=media&#x26;token=be6b315d-3b34-4c4e-b589-32e90fa24d1d" alt="" data-size="original">

When viewing the info page of a Pokemon species you have yet to battle or register to your Pokedex, the battler's typing display will be hidden. Instead, it will just show the ??? type, as seen in the example below.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FYnxdeOBW9doCprFplc4E%2F%5B2024-01-19%5D%2013_10_27.828.png?alt=media&#x26;token=598ff613-fd97-4d61-a8bb-9bb1554d5937" alt="" data-size="original">

However, this is a toggleable feature. If you would like to turn on the type display even for newly encountered species, you may do so by opening the plugin and setting `SHOW_TYPE_EFFECTIVENESS_FOR_NEW_SPECIES` to `true` in the file named `[000]Main`.

Note that in PvP or Battle Tower-style battles, the opponent's typing will always be displayed, even if you've never encountered the species before.

The only other time the ??? type will be displayed for a battler is if the battler has removed its typing entirely. An example of this is when a pure Fire-type uses the move Burn Up.

If the Terastallization plugin is installed, the battler's Tera Type will also appear in the space below its normal typing.

</details>

<details>

<summary>Battler Attributes</summary>

To the right of the battler's displayed typing, attributes related to the battler will be displayed here. If the battler is owned by the player, then the battler's Ability and held item will be displayed here. These displays reflect the battler's in-battle attributes. This means if they have their ability or item changed during battle, those new attributes will be displayed here.

If the battler is not owned by the player, then this space will simply be blank. However, if the battler is a wild Pokemon, there may be additional displays that utilize this space if certain plugins are installed.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FgYEC4UdMWeQBBhO7uF2D%2F%5B2024-01-19%5D%2013_14_00.900.png?alt=media&#x26;token=b1fed7e2-3f83-4c97-b2c2-a18e34a5040e" alt="" data-size="original">

In the above example, certain icons are displayed in this field for a wild Pokemon. If the [**Enhanced Pokemon UI**](https://www.pokecommunity.com/threads/enhanced-pokemon-ui-v21-1.500755/#post-10661986) plugin is installed and the wild Pokemon was given a number of shiny leaves, then an icon indicating that this wild Pokemon has shiny leaves will appear here. Similarly, if you have the [**Improved Mementos**](https://www.pokecommunity.com/threads/improved-mementos-ribbons-marks-v21-1.500629/#post-10660800) plugin installed, icons may appear which indicate the general size of the Pokemon, as well as if it has any marks.

Below the attributes field, there will be another box that displays the battler's last used move in this battle. If the battler has not moved yet, this box will remain empty.

</details>

<details>

<summary>Battler Stats</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FzDn2ZLCMf2Iwor40yfFs%2F%5B2024-01-19%5D%2013_01_34.131.png?alt=media&#x26;token=bc6e49b0-e140-4b6e-b4f4-79466f00c82d" alt="" data-size="original">

Below the field related to the battler's condition, there is a large box containing the battler's current stat changes. This will reflect all increases or decreases to all of its battle stats. Increases are indicated with a red arrow pointing upwards, and decreases are indicated with a blue arrow pointing downwards.

Unlike the core series, I implemented a line to display a battler's critical hit stages. This caps out at four stages rather than six, because after four stages of crit-boosting effects, the user's critical hit chance is guaranteed.

If the battler is owned by the player, the name of each stat may be color coated to indicate Nature boosts, just as it works in the Summary screen. Stats in red are being boosted by Nature, while stats in blue are being lowered.

</details>

<details>

<summary>Battler Effects</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FraXOHUMKZA8txvfPeTKq%2Fdemo35.gif?alt=media&#x26;token=cd7a1402-cbff-4dcb-9207-9c71b98f1eb1" alt="" data-size="original">

The space to the right of the battler's stats is used to display any effects currently in play that are affecting the battler in some way. This can be anything from weather, terrain, field effects, or conditions that are specifically affecting this battler.&#x20;

If there's more than one effect in play, then each effect will be listed. You can use the Up/Down keys to scroll through this list. If there are more effects active than can fit in the UI at once, then you can scroll down the list to reveal each effect.

Next to each effect, there may be some sort of counter to indicate that effect's duration or other properties. Typically, if a counter is displayed as a fraction, such as 3/5, this is indicating that this particular effect has a set duration, and will expire once it reaches zero. If a counter is displayed as a number with a plus sign in front of it, such as +1, this indicates that this is an effect that has applied a number of stacks and will not expire until something happens to remove those stacks. If a counter is displayed as a plain number, this indicates that this effect is counting down to something happening once it reaches zero, such as Perish Song or the Slow Start ability. If the counter for an effect is simply displayed as dashes, this means this effect has no counter, or no counter worth tracking.

Below the list of effects, a box will be shown which will display a brief description of what the highlighted effect does. There's not a lot of space, so the descriptions are fairly simple, but they get the job done.

If no conditions are in play that affect the battler, then this entire field will remain empty.&#x20;

</details>

Page 63:

# UI: Poke Ball Shortcut

This UI allows you to quickly use a Poke Ball in battle, without having to go through the Bag menu to select a ball. The design and function of this UI emulates the Poke Ball UI used in *Pokemon Scarlet & Violet*, which allows you to scroll left and right through your entire Poke Ball inventory, as well as pressing a button to view details about each ball.

***

<mark style="background-color:orange;">**Accessing the UI**</mark>

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FHPrLeyQH917zQSyBmGOC%2F%5B2024-05-02%5D%2009_33_06.295.png?alt=media&#x26;token=d8ea4a97-3ee3-4da0-a4bb-78b9f9973720" alt="" width="384"><figcaption><p>Ball (S) key prompt.</p></figcaption></figure>

A "Ball" prompt will appear in the bottom left hand corner of the battle screen to indicate that you can open the Poke Ball Shortcut UI with the press of the `JUMPDOWN` (S) key. This prompt will not display if `UI_PROMPT_DISPLAY` is set to zero.&#x20;

This prompt will also be hidden if any of the following is true:

* The battle is a Trainer battle.
* The battle is a Battle Tower or PvP-style battle where items cannot be used.
* The disablePokeBalls Battle Rule is enabled for this battle.
* The battle is a wild Safari Zone encounter, or the player is in the Bug Catching contest.
* There are more than one wild Pokemon targets, preventing a ball from being thrown.

***

<mark style="background-color:orange;">**Navigating the UI**</mark>

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FwvU729uBAEHYj0KLT5WS%2F%5B2024-05-02%5D%2010_38_36.640.png?alt=media&#x26;token=cd95ea21-a446-45e7-91e6-5264a2246b63" alt="" width="384"><figcaption><p>Shortcut UI display.</p></figcaption></figure>

When accessed, a window will appear above the Command Menu displaying your inventory of usable Poke Balls. The specific ball that your cursor highlights by default when you open this UI will be whichever ball you last previously used or viewed in your Bag. Below the icon of each ball, there will be a number which reflects how many of that specific ball you have left in your inventory.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fo0pUQi0Y3Lxx1ilqgpRn%2Fpokeball.gif?alt=media&#x26;token=660aa0b8-7702-46f9-bea2-319a19c86af8" alt="" width="381"><figcaption><p>UI controls and navigation.</p></figcaption></figure>

You can scroll through each ball in the list with the Left/Right keys. Holding either of these keys will quickly scroll in that respective direction instead. Pressing the `JUMPUP` (A) and `JUMPDOWN` (S) keys will instead automatically scroll you to the start or end of the list, respectively. Pressing the `ACTION` (Z) key will open an additional window in this UI that will display the description of your currently highlighted ball, allowing you to view details about its specific properties.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FRVQmmwOkk06Au0tTZdmM%2Fpokeball2.gif?alt=media&#x26;token=b582adc6-346f-4e98-b78a-552a2b133e3a" alt="" width="381"><figcaption><p>Throwing a selected ball.</p></figcaption></figure>

Once you've decided on a Poke Ball you wish to use, simply press the `USE` key to immediately use that Poke Ball. Note that if for some reason a Poke Ball cannot be used on the wild Pokemon (the target is out of range due to Fly/Dig, for example), then a message will display to inform you of this instead, and the ball will not be thrown.

Page 64:

# UI: Move Info

This UI is used for displaying various information about each of a specific battler's moves. This allows you to quickly read the description of the move's effect as well as all of its other attributes at the press of a button, without having to enter the Party menu to look up the battler's moves.&#x20;

This UI also displays various additional info not normally displayed, such as specific flags the move has, what its current Power/Typing/Category if it's being altered by an effect, as well as its type effectiveness against each potential target on the field.

***

<mark style="background-color:orange;">**Accessing the UI**</mark>

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FrmdIPaTd2s7A0xl6FuWh%2F%5B2024-05-02%5D%2009_47_58.623.png?alt=media&#x26;token=c33d23e4-4d9c-4a55-ae2e-a2e0e6fa5391" alt="" width="384"><figcaption><p>Move (S) key prompt.</p></figcaption></figure>

A "Move" prompt will appear in the bottom left hand corner of the battle screen to indicate that you can open the Move Info UI with the press of the `JUMPDOWN` (S) key. This prompt will not display if `UI_PROMPT_DISPLAY` is set to zero.&#x20;

***

<mark style="background-color:orange;">**UI Display**</mark>

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FTmdCPNXdZ6FABsYbnSic%2Fdemo.gif?alt=media&#x26;token=6ac3fb8f-c35c-4774-aea6-b5ab1fda094f" alt="" width="376"><figcaption><p>Info UI backgrounds reflect the move's type.</p></figcaption></figure>

By default, the info UI for each move will change colors to reflect the type of each move. If you have custom types in your game, you will have to add a UI background for that type by editing the `move_bg` graphic located in `Graphics/Plugins/Enhanced Battle UI`.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F6XiSCx3yOR8E7dpm5TSh%2Fdemo1.gif?alt=media&#x26;token=57eaacf5-5ec5-4edc-9528-b468ed7c8c4d" alt="" width="376"><figcaption><p>Info UI when type-based backgrounds are disabled.</p></figcaption></figure>

However, if you do not wish for the backgrounds to change for each type and would rather keep a consistent background for every move, you can disable this feature by setting `USE_MOVE_TYPE_BACKGROUNDS` to `false` in the plugin Settings.

***

<mark style="background-color:orange;">**Viewing Move Details**</mark>

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FPUf848xFhsbw5PRCvnzP%2Fdemo33.gif?alt=media&#x26;token=2c0c7ef2-69a0-40ae-83fb-c88c5382b808" alt="" width="381"><figcaption><p>Navigating the Move Info UI.</p></figcaption></figure>

This UI may be accessed only when the Fight Menu is open and the battler's moves are being displayed. If so, a window will appear in the center of the screen which will provide details about whichever move you're currently highlighting. This will update as you scroll through your moves with the directional keys, allowing you to view this data for each move.&#x20;

Pressing the `BACK` key or `JUMPDOWN` (S) key again will toggle off this UI. Pressing the `JUMPUP` (A) key will switch to the Battler Info UI. Pressing the `USE` key will select the highlighted move to be used like it normally would, and hide this UI again so the move may be used.

Below, I'll break down each display in this UI.

<details>

<summary>Type and Category</summary>

<mark style="background-color:yellow;">**Type Display**</mark>\
The move's type will be displayed to the right of the move name. If the move has an effect that would cause its type to differ from its base type, such as the moves Weather Ball or Terrain Pulse, then the displayed type here will also reflect this. This is even true for non-move effects that would change the move's type, such as the Electrify or Ion Deluge effects, or certain abilities like Pixilate and Liquid Voice.

![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FUC5N9UZLlsiguDX5rt8z%2F%5B2024-08-08%5D%2012_52_03.980.png?alt=media\&token=06b0bdb1-aad2-4241-8927-d4faaa5f7a5d)  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F9tJTepgSBzuL7uT53rxw%2F%5B2024-08-08%5D%2012_52_16.326.png?alt=media\&token=c0d6749f-5c46-490d-86f4-d25ddfe748da)

On the left, the move Weather Ball is displayed as a Normal-type move as it is under normal conditions. On the right, Weather Ball is displayed as a Water-type move while it's raining.

\ <mark style="background-color:yellow;">**Category Display**</mark>\
The move's category will be displayed to the right of the type display. Like with typing, if the move has an effect that would alter its category for some reason, this display will also update to reflect its true category. By default though, the only moves that have some sort of property that change its category are Photon Geyser and Shell Side Arm. However, moves or mechanics introduced in other plugins that have moves with fluctuating categories (Z-Moves, Dynamax moves, Tera Blast, etc) will also utilize this feature to display the true category of the move.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FctUOl2UYMvU1cgk3WOIN%2F%5B2024-08-08%5D%2012_54_28.939.png?alt=media&#x26;token=53117434-9a57-4cb9-89bd-96d17073e4be" alt="" data-size="original">  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Feuri195MdOmcQ1uRpNLl%2F%5B2024-08-08%5D%2012_54_46.557.png?alt=media\&token=9d0abd9b-799c-4b60-9043-8782402256cd)

On the left, the move Photon Geyser is displayed as a physical move if the user would deal more damage with physical moves. On the right, Photon Geyser is displayed as a special move if the user would deal more damage with a special move.

</details>

<details>

<summary>Move Statistics</summary>

All statistics related to a move will be displayed in the upper right corner of this UI, which include the following:

* Power
* Accuracy
* Priority
* Effect chance

Status moves which don't deal any damage will just display "---" as its power. This is also true for accuracy if the move has perfect accuracy, and for priority if the move has a priority of 0. The effect chance refers to the percent chance of this move proccing an added effect, such as Flamethrower's 10% chance to burn. If the move doesn't have any additional effects, then this field will also simply display empty dashes as its value.

These attributes may display differently however depending on certain modifiers in play. Below, I'll go over every type of modifier that may alter how a move is displayed in the UI.

***

<mark style="background-color:red;">**Held Items & Abilities**</mark>

Certain items and abilities modify a move's attributes when active. If the user of a move has one of these, and the effect of that ability would alter one of their moves, this will be reflected in what's displayed in the info UI for that move.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FUO842nNP76nURfyF5TTq%2F%5B2024-08-08%5D%2012_50_45.363.png?alt=media&#x26;token=8f22d0ee-b963-482b-998a-2ab90e9b26e6" alt="" data-size="original"> ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FvInAh4Pd1YUOrC9tpMLg%2F%5B2024-08-08%5D%2012_50_26.684.png?alt=media\&token=4b14e772-d319-414b-b01d-9d8a42056f32)

For example, the ability Iron Fist powers up the base power of all "punching" moves by 20%. If a Pokemon has this ability in battle and views the info for one of their punching moves, this bonus will be reflected in the displayed power for that move.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F8siOuDdFpYr13Xu0v7wT%2F%5B2024-08-09%5D%2010_12_48.748.png?alt=media&#x26;token=d7811a5a-dcee-4ec4-bd02-4b95121e926b" alt="" data-size="original">

Attributes that are being boosted by the user's ability or held item will be highlighted in green text, while attributes that are being lowered will be highlighted in red text. For example, the Hustle ability actually reduces a move's accuracy, and so this will be displayed in red text to indicate the ability's effect.

Note that this only considers items or abilities that alter the actual attributes of a move. So an ability like Torrent will not apply, since Torrent boosts the user's actual stats when using a Water-type move, not the power of the move itself.

If a Pokemon has both an ability *and* a held item that are both affecting the properties of a move at the same time, then the ability text will take priority in this display.

Below are all of the abilities that may modify a move's attribute and may change how it displays in this UI:

* Aerilate/Pixilate/Refrigerate/Galvanize/Normalize (Power)
* Compound Eyes (Accuracy)
* Flare Boost (Power)
* Gale Wings (Priority)
* Hustle (Accuracy)
* Iron Fist (Power)
* Mega Launcher (Power)
* No Guard (Accuracy)
* Prankster (Priority)
* Reckless (Power)
* Rivalry (Power - Single Battles only)
* Sand Force (Power)
* Sheer Force (Power)
* Strong Jaw (Power)
* Technician (Power)
* Tough Claws (Power)
* Toxic Boost (Power)
* Triage (Priority)
* Serene Grace (Effect Chance)
* Sharpness (Power - Gen 9 Pack ability)
* Supreme Overlord (Power - Gen 9 Pack ability)
* Victory Star (Accuracy)

Below are all of the held items that may modify a move's attribute and may change how it displays in this UI:

* Wide Lens
* Zoom Lens
* Choice Band
* Choice Specs
* Muscle Band
* Wise Glasses
* Expert Belt
* Adamant Orb
* Lustrous Orb
* Griseous Orb
* All type-boosting items (Silk Scarf, Mystic Water, etc.)
* All type-boosting Plates (Zap Plate, Splash Plate, etc.)

***

<mark style="background-color:red;">**STAB**</mark>

If the move's type matches the user's typing, the move will gain a same-type attack bonus, also known as STAB. This increases the move's base power by 50%. When a move's power is displayed in this UI, it will take STAB into account when determining which number to display.

![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F2S194zVYjwwIBNrlKryX%2F%5B2024-08-08%5D%2012_57_01.213.png?alt=media\&token=cb739531-d075-46ab-bcf1-a3b9586bde82)  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FP4rGpM0Z4C3ouA9CUcf1%2F%5B2024-08-08%5D%2012_57_24.197.png?alt=media\&token=916e82d2-aa63-4560-9490-95aab19ed202)

In the example above, the move Quick Attack is displayed on two different Pokemon. On the left is a Pokemon which doesn't gain any STAB, while the one on the right does. Notice that when a move is being boosted in power beyond what its default power would be, the text is displayed in green to indicate this.

Note that these STAB bonuses will always take the user's actual in-battle typing into account. So if the user changes types somehow through an effect, this will affect which moves gain a STAB boost in this UI.

If a move always deals set damage and would receive no additional bonus in power due to STAB, such as Sonic Boom or Dragon Rage, then no STAB bonuses will apply even if the move type matches the user's typing.

***

<mark style="background-color:red;">**Move Properties**</mark>

The last thing that may influence the power displayed in this UI are the properties of the move itself. This is less simple than STAB because this is something that depends on each specific move. Some moves don't have a set power, and change based on specific functions of that move. Below I'll give some examples of how these types of moves may display their power in this UI.

<mark style="background-color:yellow;">**Moves that Increase in Power**</mark>

If a move is being powered up by something related to the function of that move, this power increase will be accounted for in the UI. For example, the power of the move Flail scales based on how low the user's remaining HP is. The lower its HP, the more its power increases. When viewing Flail's power in this UI, you will be able to see the actual power this move has at your current HP level.

![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FaKNh0vIjh4oXlJsKqDE6%2F%5B2024-01-19%5D%2010_15_00.145.png?alt=media\&token=b405b317-73d5-4984-b6cd-3dadfe7b8e99)  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FY7vQRC6OlMxNohGQ706F%2F%5B2024-01-19%5D%2010_15_20.641.png?alt=media\&token=82f8bd93-0395-4d79-ad77-96c92086b3a7)

The picture on the left demonstrates Flail's power at full HP, while the picture on the right demonstrates its power when the user is at 1 HP. Note that moves that are being increased in power in some manner will display with green text, just like with STAB boosts. In the case of Flail, its power is perceived as being "boosted" even when at full HP because the move itself is boosted to 20 power at full HP, which is still higher than its raw base power of 1.

<mark style="background-color:yellow;">**Moves that Decrease in Power**</mark>

If a move is being weakened in some way due to the move's properties, this will also be reflected. Here's an example using the move Eruption, which is the inverse of Flail. It deals its intended damage when the user's HP is full, and grows weaker as the user's HP drops.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FyRmeSWAigeLu7RyYA39t%2F%5B2024-01-19%5D%2010_13_26.623.png?alt=media&#x26;token=1e85ea34-5224-4e19-bf01-aed827984e95" alt="" data-size="original">  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FfR1SPNAUHfpreuiJaz6d%2F%5B2024-01-19%5D%2010_14_20.345.png?alt=media\&token=3c1e0157-9a5c-4060-8012-5e81aaa45052)

The picture on the left demonstrates Eruption when the user's HP is full, and the picture on the right demonstrates the drop in power after the user's HP has been lowered. Note that moves that are being weakened in some manner will display with red text instead of green. Not many moves do this, so this will be rarer to see.

<mark style="background-color:yellow;">**Moves That Hide Their Power**</mark>

Not every move that has fluctuating damage will work with this, however. Some moves would reveal too much about the opponent if they displayed their real values, and so in those cases the true damage isn't displayed. For example, the move Gyro Ball increases in power the slower you are compared to your opponent. However, if the true power of this move was displayed, it would reveal how fast the opponent was compared to you. Because of this, this move has been blacklisted from displaying its true power, and will just display as ??? instead.&#x20;

![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FwPPvp9PHX3fBHae2ZYVg%2F%5B2024-01-19%5D%2011_11_22.256.png?alt=media\&token=e8480215-a008-4275-b4d0-aebf1503e855)  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FWrRvJGKyXajzaFFsmStO%2F%5B2024-01-19%5D%2011_10_38.593.png?alt=media\&token=0dc0fba7-22fc-40d0-8f14-76f56b3ba623)

The examples above showcase how this will be displayed. Note that even if a move's power is hidden, it will still display in green text if the move's power is being boosted by STAB, even though its actual power can't be displayed.

The are only certain situations where a move will display ??? as its power. Usually, this will be because the move either can't calculate its real strength until the turn plays out (moves like Counter or Metal Burst), the move has some unique properties that make it impossible to reliably calculate its true damage (moves with random damage, like Magnitude or Present), or the move would reveal too much information about the opponent if you could see its true power.

Here's a list of moves that are blacklisted due to being impossible to calculate, or due to revealing too much information. This may not be an exhaustive list:

* Psywave (random damage)
* Magnitude (random damage)
* Present (random damage)
* Fling (only if an item isn't being held)
* Natural Gift (only if a berry isn't being held)
* Crush Grip (could reveal the target's HP value)
* Wring Out (could reveal the target's HP value)
* Low Kick (could reveal the target's weight)
* Grass Knot (could reveal the target's weight)
* Electro Ball (could reveal the target's speed)
* Gyro Ball (could reveal the target's speed)

***

Besides for STAB bonuses, Abilities that modify move attributes, or changes in power through the move's own effect, no other modifiers will be calculated when determining what to display. So held items, stat changes, or any other sorts of effects will not play into the displayed move attributes.

</details>

<details>

<summary>Move Flags</summary>

Right below the move's name, some moves may have a row containing various icons. Each of these icons represent a special flag associated with this move which appears in its PBS data. These icons can help you quickly identify characteristics of a move that would typically be invisible to you in most cases unless you've simply memorized it. Below is a list of every possible flag that may appear in this section.

* ![](https://i.imgur.com/y4ymoGL.png) Move *doesn't* have the `CanProtect` flag.\
  Indicates that this move cannot by blocked, and will bypass moves like Protect.
* ![](https://i.imgur.com/FFFdHGi.png) Move *doesn't* have the `CanMirrorMove` flag.\
  Indicates that this move cannot be mirrored back by moves like Mirror Move.
* ![](https://i.imgur.com/pGYtvp6.png) Move has the `Contact` flag. \
  Indicates that this is a contact move.
* ![](https://i.imgur.com/7ssMOdz.png) Move has the `TramplesMinimize` flag.\
  Indicates that this move will deal increased damage to targets in the Minimize state.
* ![](https://i.imgur.com/QYF1pNy.png) Move has the `HighCriticalHitRate` flag.\
  Indicates that this move has a high critical hit ratio.
* ![](https://i.imgur.com/nLOKpbq.png) Move has the `ThawsUser` flag.\
  Indicates that this move will thaw out frozen Pokemon.
* ![](https://i.imgur.com/bqGu9j2.png) Move has the `Sound` flag.\
  Indicates that this is a sound-based move that is blocked by the Soundproof ability.
* ![](https://i.imgur.com/F9OIiso.png) Move has the `Punching` flag.\
  Indicates that this is a punching move that is boosted by the Iron Fist ability.
* ![](https://i.imgur.com/2pOKaKk.png) Move has the `Biting` flag.\
  Indicates that this is a biting move that is boosted by the Strong Jaw ability.
* ![](https://i.imgur.com/vNPYFHQ.png) Move has the `Bomb` flag.\
  Indicates that this is a bomb or ball move that is blocked by the Bulletproof ability.
* ![](https://i.imgur.com/1ExskCo.png) Move has the `Pulse` flag.\
  Indicates that this is an aura or pulse move that is boosted by the Mega Launcher ability.
* ![](https://i.imgur.com/3CGK2Yf.png) Move has the `Powder` flag.\
  Indicates that this is a powder move that is blocked by the Overcoat ability.
* ![](https://i.imgur.com/3ti5OCy.png) Move has the `Dance` flag.\
  Indicates that this is a dance move that is recognized by the Dancer ability.

<mark style="background-color:yellow;">**Additional Flags**</mark>

The following flags are also supported, but do not appear in Essentials by default. Instead, they are introduced by other plugins which this plugin is compatible with.

* ![](https://i.imgur.com/4emumeO.png) Move has the `ElectrocuteUser` flag.\
  Indicates that this move will wake Pokemon suffering from the Drowsy status, like in *Pokemon Legends: Arceus*. This flag is introduced in the Gen 9 Pack plugin.
* ![](https://i.imgur.com/E0RyDFm.png) Move has the `Slicing` flag.\
  Indicates that this move is a slicing move that is boosted by the Sharpness ability. This flag is introduced in the Gen 9 Pack plugin.
* ![](https://i.imgur.com/sNpSXDl.png) Move has the `Wind` flag.\
  Indicates that this move is a wind-based move that is blocked by the Wind Rider ability. This flag is introduced in the Gen 9 Pack plugin.
* ![](https://i.imgur.com/iVe5d79.png) Move has the `ZMove` flag.\
  Indicates that this move is considered a Z-Move. This flag is introduced in the Z-Moves plugin.
* ![](https://i.imgur.com/reOslXZ.png) Move has the `DynamaxMove` or `GmaxMove` flag.\
  Indicates that this move is considered a Dynamax move. This flag is introduced in the Dynamax plugin.

</details>

<details>

<summary>Move Effectiveness</summary>

If the move you are viewing is a damage-dealing move, then there may be some boxes with Pokemon icons inside them above the UI on the right hand corner. This is for displaying the effectiveness of this move. An icon of each viable opponent on the field will appear in their own box, and the color and symbol used for these boxes indicate how effective the highlighted move will be when used on those particular targets.&#x20;

Here's all of the boxes that may be shown, and the effectiveness that they indicate:

* ![](https://i.imgur.com/HGJKJoj.png) Normal effectiveness.
* ![](https://i.imgur.com/k2425p6.png) Super Effective.
* ![](https://i.imgur.com/6GdgdUi.png) Not Very Effective.
* ![](https://i.imgur.com/IsYi59r.png) Immune.
* ![](https://i.imgur.com/jaKho2W.png) Unknown effectiveness.

You'll notice that each box is color coated to reflect what it indicates, but there are also symbols that appear over each box so that it's still apparent what they mean. If a Pokemon's type is changed by an effect that would alter the effectiveness of a move, this will also be taken into account. For example, if you use the move Soak to change a Fire-type Pokemon into a Water-type, the effectiveness display will take into account that that Pokemon is now a Water-type, and display the true effectiveness of the move on that target.

<mark style="background-color:yellow;">**Unknown Effectiveness**</mark>

You'll notice in the list above that the last entry shows a box that is used for targets where the effectiveness of the move is unknown. This only occurs when fighting species you have never battled before, or never registered in your Pokedex. After you defeat or capture one of these species for the first time, they will become known to you and you will be able to see the effectiveness of moves on them. Note that this doesn't count whether a Pokemon has been *seen* yet, only if it has been defeated or captured.

However, this is a toggleable feature. If you would like to turn on the type effectiveness display even for newly encountered species, you may do so by opening the plugin and setting `SHOW_TYPE_EFFECTIVENESS_FOR_NEW_SPECIES` to `true` in the file named `[000]Main`.

</details>

<details>

<summary>Move Description</summary>

The description of what the move does is also displayed in this UI. This is pretty straightforward. Keep in mind that this description field only allows for two lines of text, so if you have very long move descriptions, they be cut off in the UI.

There is space for a third line of text, but this space is reserved for special notifications that are used to inform you of special modifications the move may have, which can include any of the following.

* **Held Item & Ability Bonuses**\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FHuM9iBw6MvG6otznCe9n%2F%5B2024-08-09%5D%2010_22_41.052.png?alt=media\&token=3bbf7528-d687-42c4-9965-23db52e8157b)\
  \
  Some abilities and hold items have effects that modify a move's properties. If the user has one of these active, its effects will be calculated into the displayed attributes, and a bonus line of text will appear below the move's description indicating this modification. If both an item *and* an ability are both affecting the properties of a move at the same time, then the ability text will take priority in this display.<br>
* **Z-Power**\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FKM8U8Z9nKbGSdRIbNcoc%2F%5B2024-08-09%5D%2010_22_18.308.png?alt=media\&token=9dc10c17-6495-4e37-acfd-0f31a0a7c1e7)\
  \
  When this add-on is installed, an additional line will be displayed here indicating the additional effects that will be added to a status move when enhanced with Z-Power.<br>
* **Terastallization**\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FmN0WZvHIQGhToLdVQgVq%2F%5B2024-08-09%5D%2010_23_39.525.png?alt=media\&token=043ad62b-b58c-48a6-a6bc-6c81260e5ffe)\
  \
  When this add-on is installed, an additional line will be displayed here indicating if a move will be boosted by the user's Tera Type if Terastallized.

</details>

Page 65:

# SOS Battles

[**Eevee Expo Link**](https://eeveeexpo.com/resources/1473/)

[**PokeCommunity Link**](https://www.pokecommunity.com/threads/sos-battles-dbk-add-on-v21-1.525882/#post-10794215)

[**Download Link**](https://www.mediafire.com/file/9dcc48nv1krf20i/SOS_Battles.zip/file)

This plugin builds upon the Deluxe Battle Kit to add SOS functionality to your wild battles. The SOS mechanic was a feature that was introduced in *Pokemon Sun & Moon*. In these games, wild Pokemon had a chance of calling for aid at the end of each turn; summoning new wild Pokemon to their side to help them in battle.&#x20;

In the following subsections, I'll go into detail about the various aspects and features of this plugin.

***

<mark style="background-color:orange;">**General Plugin Utilities**</mark>

<details>

<summary>Turning On SOS Mechanics</summary>

In order to allow wild Pokemon to call for help during battle via SOS calls, you must first turn on the appropriate game switch. The switch number used for this can be found by going into this plugin's files and opening the Settings file.&#x20;

Here, you will find a setting called `SOS_CALL_SWITCH`. This is where the switch number used to toggle wild Pokemon's ability to use the SOS mechanic on or off is stored. By default, this switch number is set to `62`, but please set this to whatever switch number you want if this overlaps with an existing switch that you are using elsewhere. While playing in debug mode, you can quickly toggle this switch by going to "Deluxe plugin settings..." in the debug menu, and using the "Toggle SOS battles" setting.

Once your preferred switch number is set and you turn this switch on in-game, all eligible wild Pokemon will now be able to call for help via SOS.

If you ever want to turn this feature off and disable the SOS mechanic for all wild Pokemon, you can do so by simply turning this game switch off again.

</details>

<details>

<summary>Customizing SOS Frequency</summary>

In *Pokemon Sun & Moon*, wild Pokemon could call for help via SOS calls indefinitely. This meant that each turn, a wild Pokemon had a chance to call for help.&#x20;

However, in *Pokemon Ultra Sun & Ultra Moon*, this was nerfed so that wild Pokemon could only call for help once per battle. However, by using an Adrenaline Orb in battle, this would allow wild Pokemon to call for help indefinitely again, as they originally did in Sun & Moon.

This plugin allows you to set either style of SOS call frequency through a setting found in the plugin's Settings file. In here, you will find a setting called `LIMIT_SOS_CALLS_TO_ONE`. When this is `true`, SOS frequency functions as it did in Ultra Sun & Ultra Moon; meaning wild Pokemon will only call for help once, but can call indefinitely if an Adrenaline Orb is used.

If this setting is set to `false`, then SOS frequency functions as it did in the original Sun & Moon; meaning wild Pokemon have a chance to call every turn indefinitely.

By default, this setting is set to `true`, so that the SOS mechanic functions as it did in Ultra Sun & Ultra Moon. But you may change this if you prefer how the SOS mechanic originally worked.

</details>

<details>

<summary>Customizing SOS Chain Shiny Rates</summary>

When chaining wild Pokemon with the SOS mechanic, the odds of the summoned Pokemon being shiny increases as the chain gets higher. After a chain of 31 or higher, the odds of a shiny Pokemon are maxed, essentially giving you 13 extra rolls to check for shininess for each subsequent Pokemon summoned.

However, if you would like to inflate these odds even higher, you may do so by opening the plugin Settings file and editing the `SOS_CHAIN_SHINY_MULTIPLIER` setting. This will multiply the number of shiny rolls during an SOS chain by the number set here. So for example, if you set this to 10, each summoned Pokemon will have 130 shiny rolls instead of 13 after the chain reaches 31 or higher, which is a massive boost.

If you'd like to make shiny Pokemon more common while SOS chaining, consider utilizing this setting.&#x20;

</details>

Page 66:

# SOS: Plugin Overview

This plugin adds several new features that I will go over briefly below. Details on how to actually set and use these mechanics will be dealt with in their appropriate subpages.

***

<mark style="background-color:orange;">**SOS Calls**</mark>

The primary function of this plugin implements the SOS mechanic, which allows wild Pokemon to call for help during battle. SOS calls may only happen if the wild Pokemon is alone on their side of the field, aren't suffering from any status conditions, and aren't in the semi-invulnerable phase of a two-turn attack.

If the `LIMIT_SOS_CALLS_TO_ONE` plugin setting is set to true, then wild Pokemon will only be able to call for help once per battle, unless an Adrenaline Orb was used. If this setting is set to false, then wild Pokemon will be able to call for help indefinitely.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fdmi2x8AGSSsC9w0SFg1N%2Fdemo36.gif?alt=media&#x26;token=ce5faec2-0af1-4e0b-a013-05549624c8b2" alt="" width="381"><figcaption><p>Wild Rattata calling for help.</p></figcaption></figure>

The odds of a wild Pokemon calling for help is based on their `CallRateSOS`, which is set in their PBS data. If this data isn't set, it's assumed to be zero, and thus that species cannot use the SOS mechanic. The call rate of a wild Pokemon in battle may be modified by various factors which increase its likelihood, such as how much remaining HP the caller has, whether it was struck by a Super Effective move that turn, or whether you have a Pokemon on the field with the Intimidate, Unnerve, or Pressure abilities. If the Adrenaline Orb is used in battle, this will also increase the odds of the wild Pokemon calling for help.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FHcA9b7eWlAxbws1yw2F4%2Fdemo37.gif?alt=media&#x26;token=20964420-c486-4433-9f9e-626b9cc8d557" alt="" width="381"><figcaption><p>Wild Tauros calling a different species.</p></figcaption></figure>

The exact species that a wild Pokemon may call is based on their `SpeciesSOS`, which is set in their PBS data. This is an array containing a number of species that can be possibly called when a wild Pokemon of this species calls for help. If this data isn't set, it's assumed that this species may only call other members of its own species. In addition to this, you may also set conditional species that the species may summon on certain maps or when encountered through certain methods by setting `ConditionalSOS` in their PBS data.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F1QbLlTJWNWOChKnPOVnu%2Fdemo38.gif?alt=media&#x26;token=294f945a-63bf-4d45-bb46-e5ff33f84fa8" alt="" width="381"><figcaption><p>Shiny Caterpie appears after racking up a high SOS chain.</p></figcaption></figure>

As more wild Pokemon are summoned via SOS calls, this will increase your SOS chain. The higher your SOS chain grows, the higher your odds of each summoned Pokemon having higher IV's, hidden abilities, or even being shiny. After you begin an SOS chain, all EV's your Pokemon gain from this battle will be doubled. This effect will not expire, even if your chain prematurely ends. The only way for an SOS chain to end is if you KO the original caller Pokemon, and there are no other Pokemon on its side of the field that are in its evolutionary family.

If you would like to increase the likelihood of shiny Pokemon appearing during an SOS chain, you can open the Settings file in the plugin and set `SOS_CHAIN_SHINY_MULTIPLIER` to whatever you'd like. The number of rolls the game makes to check for shininess during an SOS chain will be multiplied by this number, allowing you to set the odds to your liking.

For a more detailed breakdown on SOS mechanics that have been covered in this section, I recommend skimming through the [Bulbapedia](https://bulbapedia.bulbagarden.net/wiki/SOS_Battle) page on this topic.

{% hint style="info" %}
More details on the various PBS data used to set up SOS calls may be found in the "SOS: PBS Data" subsection.
{% endhint %}

***

<mark style="background-color:orange;">**Rival Species**</mark>

This plugin allows you to set up species rivalries for wild Pokemon. This means that whenever a wild Pokemon of a particular species detects a Pokemon on the field that is a member of a species it considers a rival species, the wild Pokemon will mercilessly attack that rival species, even if they're on the same side.&#x20;

For example, in *Pokemon X & Y*, if you encountered a horde battle versus a horde of Zangoose, sometimes a random Seviper would be among the Pokemon found in the horde. But because Zangoose and Seviper have such a bitter rivalry, these wild Pokemon would often attack each other in horde battles, even though they were on the same side.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FIwYwALUU7wEOUk9jh7G5%2Fdemo39.gif?alt=media&#x26;token=93ea6b45-cf09-479b-bf65-402e8cdf5de7" alt="" width="381"><figcaption><p>Wild Zangoose and Seviper attacking each other.</p></figcaption></figure>

This plugin allows you to replicate this behavior, as seen above. Whichever species you enter in `RivalSpecies` in a species' PBS data will always take top priority for the wild Pokemon's AI. This means it will always prefer to attack rival species as its primary target. If there are multiple rival species on the field for the Pokemon to choose from, it'll randomly select one of those targets. Non-rival species will take the lowest priority, and the wild Pokemon will only ever choose to target them if they are forced to by an effect, or if all rival species on the field have been removed or defeated.

This feature can work hand-in-hand with the SOS mechanic, since this can be set up to create scenarios where wild Pokemon meet rival species on the battlefield. For example, in *Pokemon Sun & Moon*, wild Corsola would have a chance of attracting wild Mareanie through SOS calls. However, Mareanie considers Corsola prey, so once Mareanie is on the field it would try to attack and KO Cosola first, even before it focuses on attacking the player. This same behavior can be mimicked by this plugin by listing Corsola as a rival species for Mareanie, and listing Mareanie as a potential SOS species that Corsola can call. You can use this to design unique interactions between different wild species.

{% hint style="info" %}
More details on setting up rival species may be found in the "SOS: PBS Data" subsection.
{% endhint %}

***

<mark style="background-color:orange;">**Totem Battles**</mark>

*Pokemon Sun & Moon* introduced Totem Pokemon; wild boss Pokemon that acted as powerful trial challenges. Totem Battles utilized the SOS mechanic to allow the Totem Pokemon to summon minions during battle. This plugin allows you to easily set up your own Totem Battles as well by utilizing the <mark style="background-color:green;">"totemBattle"</mark> Battle Rule.

Totem Battles aren't dramatically different than standard wild battles, but there are some key differences.

* You cannot run from a Totem Battle.
* You cannot throw Poke Balls during a Totem Battle.
* During battle, Totem Pokemon will be referred to as "Totem \_\_" instead of "The wild \_\_."
* Totem Pokemon get an aura boost at the start of the battle that raises their stats a number of stages. The exact stats and stages can be set.
* Totem Pokemon have more advanced AI than wild Pokemon, mirroring medium skilled trainers.
* Totem Pokemon and their allies will work together in battle, ignoring any species rivalries.
* The Totem Pokemon will always be able to call for help, even if the SOS mechanic is disabled.
* Unlike normal wild Pokemon, Totem Pokemon cannot be prevented from calling for help while suffering from a status condition. Totems also have a 100% call rate, which overrides whatever the base call rate is for the species in its PBS. The success rate when calling allies is also 100%.
* Unlike normal wild Pokemon, Totem Pokemon can only call for help a maximum of two times during the battle. The first Pokemon will always be summoned at the end of the first turn, and the second Pokemon will be summoned once the Totem Pokemon's HP drops to 30% of their max HP or lower.&#x20;
* The wild Pokemon that are called by the Totem Pokemon will be summoned in a fixed order, instead of randomly chosen. However, this only occurs when SOS species are set via battle rules. Any species set with the <mark style="background-color:green;">"setSOSPokemon"</mark> rule will always be summoned first, and any species set with the <mark style="background-color:green;">"addSOSPokemon"</mark> rule will always be summoned second.

Example:

![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FaLb5eUDHLldzia0Ge5hN%2Fdemo40.gif?alt=media\&token=cde31163-3935-4aa1-8c0c-e52a0bc28b40)  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FTph0kc46FulRUD8vMz4q%2Fdemo41.gif?alt=media\&token=e61ddf9d-db29-43f1-81c9-c764aeed8e7e)

```ruby
setBattleRule("battleIntroText", "You were challenged by Totem {1}!")
setBattleRule("totemBattle", [:DEFENSE, 1, :SPECIAL_DEFENSE, 1])
setBattleRule("setSOSPokemon", :PELIPPER)
setBattleRule("addSOSPokemon", :CASTFORM)
WildBattle.start(:LUDICOLO, 20)
```

In this example above, the player will be challenged by a level 20 Totem Ludicolo. The Totem Pokemon will gain +1 Defense and +1 Sp. Def with their aura boost at the start of the battle, and summon a Pelipper to their aid at the end of the first turn. When Totem Ludicolo grows weak, it'll summon a Castform to its side as its second support Pokemon.

{% hint style="info" %}
More details on the <mark style="background-color:green;">"totemBattle"</mark> Battle Rule may be found in the "SOS: Battle Rules" subsection.
{% endhint %}

***

<mark style="background-color:orange;">**Mid-Battle Wild Reinforcements**</mark>

Having wild Pokemon join the battle isn't only limited to SOS mechanics. You can make wild Pokemon join a battle whenever you want, and function completely independently of any SOS mechanics. You can even use this to make a third wild Pokemon join the battle. This can be done through mid-battle scripting by utilizing the <mark style="background-color:blue;">"addWild"</mark> Command Key.

More details on the <mark style="background-color:blue;">"addWild"</mark> Command Key may be found in the "SOS: Mid-Battle Scripting" subsection.

![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FanIEJ5LUBfGyigIRu7dP%2Fdemo42.gif?alt=media\&token=8feb0127-b0cc-432d-9527-5d4241a323c6)  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F9g6l4UFk9hUeGMqo00EG%2Fdemo43.gif?alt=media\&token=125cbccc-31c2-4899-8960-9563daa8d7c7)

{% hint style="info" %}
Note that while in playing in debug mode, you can manually force a new wild Pokemon to join the battle by opening the debug menu (F9) and selecting "Battlers..." and then "Add new foe."
{% endhint %}

***

<mark style="background-color:orange;">**Mid-Battle Trainer Reinforcements**</mark>

You aren't only limited to using this plugin to have wild Pokemon join the opponent during wild battles. You can even utilize this in trainer battles by having entirely new trainers enter the fight at any point in battle. You can use this to suddenly turn a 1v1 battle into a 1v2 or even a 1v3 fight. This can be done through mid-battle scripting by utilizing the <mark style="background-color:blue;">"addTrainer"</mark> Command Key.

More details on the <mark style="background-color:blue;">"addTrainer"</mark> Command Key may be found in the "SOS: Mid-Battle Scripting" subsection.

![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FVWz3nJ0VUjnwxXEINNtO%2Fdemo44.gif?alt=media\&token=b58020e1-6c93-429a-ae8f-10d78723554b)  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FgjygXL7zDgSCN5szN49r%2Fdemo45.gif?alt=media\&token=ba4b58a3-312e-4fa2-98d7-f249612cc583)

{% hint style="info" %}
Note that while in playing in debug mode, you can manually force a new trainer to join the battle by opening the debug menu (F9) and selecting "Battlers..." and then "Add new foe."
{% endhint %}

{% hint style="info" %}
**Wonder Launcher Compatibility**

If the Wonder Launcher add-on is installed and a new trainer is added during a Wonder Launcher battle, their inventory will automatically be updated with Launcher items and will start with 0 LP.
{% endhint %}

Page 67:

# SOS: PBS Data

Upon installing the plugin for the first time, you *must* recompile your game. This is not an optional step. This will update all of your relevant PBS files with the necessary data. If you're unaware of how to recompile your game, simply hold down the `CTRL` key while the game is loading in debug mode and the game window is in focus.

<details>

<summary>Installation Details</summary>

If done correctly, your game should recompile. However, you will also notice lines of yellow text above the recompiled files, like this:

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FlTHKCd1qWKU4U5OfrAnt%2FCapture.JPG?alt=media&#x26;token=0e84aca6-15d3-45e0-af2d-e7fab6fead62" alt="Yellow text in the debug console." data-size="original">

This indicates that the appropriate data have been added to the following PBS files:

* `items.txt`
* `pokemon.txt`
* `pokemon_forms.txt`
* `pokemon_base_Gen_9_Pack.txt` (if the Gen 9 Pack is installed)
* `pokemon_forms_Gen_9_Pack.txt` (if the Gen 9 Pack is installed)

This will only occur the first time you install the plugin. If you for whatever reason ever need to re-apply the data this plugin adds to these PBS files, you can force this to happen again by holding the `SHIFT` key while loading your game in debug mode. This will recompile all your plugins, and the data will be re-added by this plugin as if it was your first time installing.

</details>

{% hint style="info" %}
Note: Because this plugin adds new PBS data to your files, it is highly recommended that you make back ups of the PBS files listed above prior to installing this plugin. Also, keep in mind that if you ever choose to uninstall this plugin, you'll need to replace these PBS files with your backups, since the data added by this plugin will no longer be readable by Essentials without this plugin installed.
{% endhint %}

***

<mark style="background-color:orange;">**Item PBS Data**</mark>

After compiling, some of the data for the following items found in `items.txt` may have changed.

<details>

<summary>Adrenaline Orb</summary>

This plugin edits your `items.txt` PBS file to make a single change to the Adrenaline Orb item. All this does is set `BattleUse = Direct` for this item, which allows it to be used from your bag during battle.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FF4KP8FulpF6xaYGzi7DU%2Fdemo35.gif?alt=media&#x26;token=fa115b1f-ff07-418b-a958-354b8f6ccaf7" alt="" data-size="original">

Using the Adrenaline Orb in battle increases the odds of wild Pokemon using SOS calls.

</details>

***

<mark style="background-color:orange;">**Species PBS Data**</mark>

For each species or form entered in your various PBS files, any number of the following lines of data may have been added. I'll go into detail about what each new line of data does, how it can be set, and provide some examples.

<details>

<summary><mark style="background-color:red;">CallRateSOS</mark> = <mark style="background-color:yellow;">Integer</mark></summary>

This sets the SOS call rate for this species or form. An SOS call rate determines how likely the species is to call for help during battle, and the odds of each call being successful. This should be set as an integer, which represents the odds of these things occurring.&#x20;

In Sun & Moon, the call rate for each species was set as either 3, 6, 9, or 15; with 3 being the lowest odds, while 15 being the highest odds. Typically, very common and weak species will have a high call rate of 15, such as Caterpie or Rattata. While strong and/or rare Pokemon will have the lowest call rate of 3, such as Scyther or Gyarados. However, you have no obligation to stick to these standards. You can set the call rate to whatever number you want, for any species.

Note that if you do not set a call rate for a species at all, then it is assumed that the call rate for this species is zero. A species with a call rate of 0 will never call for help during battle. Most legendaries, starters, and 3-stage fully evolved Pokemon do not call for help, so by default these species will not have call rate data set. But again, you don't have to stick to these standards.

One last thing to note is the call rate for specific forms of a species. If no call rate is set for that form, then the call rate they use will always just default to whatever the call rate is for the base form of that species. However, if you set a call rate for a form, that will override the default call rate, allowing each form to have different call rates.&#x20;

</details>

<details>

<summary><mark style="background-color:red;">SpeciesSOS</mark> = <mark style="background-color:yellow;">Species ID or Array</mark></summary>

This sets the species that may join this species in battle after a successful SOS call. By default, every species will always just call another Pokemon of their same species to help them. However with this setting, you can change it so that any species you set here may appear instead.&#x20;

You can set multiple species here too, if you want there to be the potential for a variety of different species to answer an SOS call from this species. However, the order is important. The first species entered will always be the most common to appear, while all subsequent species in this list will be considered "rare" encounters, and thus only have a 15% chance to roll for one of them to be called.

For some example, Tauros is given this line in its PBS data:

`SpeciesSOS = TAUROS,MILTANK`

This means that 85% of the time, wild Tauros will call other wild Tauros to its side when it calls for help. However, 15% of the time wild Miltank will show up instead.

For a more extreme example, let's take Tyrogue's entry:

`SpeciesSOS = TYROGUE,HITMONCHAN,HITMONLEE,HITMONTOP,HAPPINY`

Here, wild Tyrogue will have an 85% chance to call other wild Tyrogue to its side. However, there is a 15% chance that it may call one of the following instead: Hitmonchan, Hitmonlee, Hitmontop, or Happiny.

***

By default, if a species is entered in SpeciesSOS that matches the same species as the user, then the form of that called species will match the caller's form. For example, let's take the Tauros example from above:

`SpeciesSOS = TAUROS,MILTANK`

This makes it so Tauros may call another Tauros or a Miltank when using an SOS call. However, what if you have Paldean Tauros in your game? If Paldean Tauros makes an SOS call, it will also call Tauros or Miltank. But, because Tauros and Paldean Tauros both share the same base species, any Tauros called by Paldean Tauros will also be in Paldean form, and will not spawn in its base form.

There may be situations where you don't want this to happen, however. For these situations, you can use the `SOSForm_#` flag, where `#` is the form number you want to spawn. For example, Spiky-Eared Pichu is form 1 of Pichu. So, if you're in a battle with Spiky-Eared Pichu and it uses an SOS call to summon another Pichu, that newly spawned Pichu would want to inherit the form of the original caller (form 1), making it another Spiky-Eared Pichu.&#x20;

However, you don't want this to happen, since Spiky-Eared Pichu should be unique. Instead, we want base form Pichu to be summoned.

To do this, all we need to do is give Spiky-Eared Pichu the flag `SOSForm_0`. This will flag it so that if Spiky-Eared Pichu ever makes an SOS call that summons another one of its kind, the form of that new Pichu will always be set to 0. This can be done with any species, so you can customize the exact forms of certain species you would like to appear, regardless of the form of the original caller.

</details>

<details>

<summary><mark style="background-color:red;">ConditionalSOS</mark> = <mark style="background-color:yellow;">Species ID, Encounter type ID, Map number</mark></summary>

This sets additional species that may join this species in battle after a successful SOS call, but only under very specific conditions. These conditions include whether you encountered the species in a specific way and/or whether or not the species was encountered on a specific map.&#x20;

For example, let's say you want wild Magikarp to have a chance to call wild Gyarados to come to their aid through SOS calls. But, you don't want this to happen with just any Magikarp the player encounters, because this would be too overpowered to encounter early on in the game. So instead, you only want Magikarp that are encountered in a specific way or a specific map (or both) to be able to do this. You can accomplish this by setting a `ConditionalSOS`. Here's some examples of ways this could be set up:

* `ConditionalSOS = GYARADOS,Water,10`\
  This would allow wild Magikarp to have a chance to call wild Gyarados, but only if Magikarp was specifically encountered through the `:Water` encounter type, and only specifically on map 10. <br>
* `ConditionalSOS = GYARADOS,SuperRod,`\
  This would allow wild Magikarp to have a chance to call wild Gyarados, but only if Magikarp was specifically encountered through the `:SuperRod` encounter type. The map number here has been left blank, so this means this can happen on any map.<br>
* `ConditionalSOS = GYARADOS,,30,GYARADOS,,31,GYARADOS,,32`\
  This would allow wild Magikarp to have a chance to call wild Gyarados, but only if Magikarp was specifically encountered on maps 30, 31, and 32. The encounter type has been left blank, so this means that this can happen regardless of the method in which Magikarp is encountered.<br>
* `ConditionalSOS = GYARADOS,Water,,WISHIWASHI,WaterDay,25,MILOTIC,PokeRadar,72`\
  This would allow wild Magikarp to have a chance to call wild Gyarados, but only if Magikarp was specifically encountered through the `:Water` encounter type on any map. This would also allow wild Magikarp to have a chance to call wild Wishiwashi, but only if Magikarp was specifically encountered through the `:WaterDay` encounter type, and only specifically on map 25. This would also allow wild Magikarp to have a chance to call wild Milotic, but only if Magikarp was specifically encountered through the `:PokeRadar` encounter type, and only specifically on map 72.

***

If you need to reference all the possible encounter type ID's which can be used, these are the ones included in Essentials by default:

* `:Land`
* `:Cave`
* `:Water`
* `:OldRod`
* `:GoodRod`
* `:SuperRod`
* `:RockSmash`
* `:HeadbuttLow`
* `:HeadbuttHigh`
* `:PokeRadar`
* `:BugContest`

Note: For the first three types in this list, you may add any one of the following to specify a time of day: Day, Night, Morning, Afternoon, or Evening. For example, `:LandDay` would only consider encounters that happen on land in the day time.

</details>

<details>

<summary><mark style="background-color:red;">RivalSpecies</mark> = <mark style="background-color:yellow;">Species ID or Array</mark></summary>

This setting allows you to set the rival species for a particular species. You can list as many different rivals as you please. If a wild Pokemon of this species is on the field with another Pokemon that is a member of one of its rival species, it will prioritize attacking that rival first, even if they're on the same side.

For example, Corsola is listed as Mareanie's rival, as such:

`RivalSpecies = CORSOLA`

So whenever a wild Mareanie is on the field while a Corsola is also on the field, the wild Mareanie will always prioritize attacking Corsola.

***

If you want all forms of a species to count as a rival species, you can do so by using the flag `AllRivalForms`. For example, let's say you want wild Lickitung to consider Alcremie a rival species and attack it whenever it detects one on the field. To do this, you would enter Alcremie as a rival species for Lickitung, as so:\
\
`RivalSpecies = ALCREMIE`

However, this poses a problem. Only the base form of Alcremie will be recognized as a rival species. You could resolve this by entering all of Alcremie's possible forms as rival species too, but with 60+ forms to consider, this would be really impractical to have to enter by hand.

To resolve this, you can instead give Alcremie's base form the flag `AllRivalForms`. This will flag all of Alcremie's forms as being eligible rival species for any other species that lists Alcremie as a rival. This can be a helpful shortcut for setting up rival species for Pokemon that have many different cosmetic forms.

</details>

***

<mark style="background-color:orange;">**Map Metadata**</mark>

The `map_metadata.txt` file is not edited by this plugin. However, code is put in place to recognize the following if you so choose to add this data to any of your map entries yourself.

<details>

<summary><mark style="background-color:red;">SpecialSOS</mark> = <mark style="background-color:yellow;">Species ID, Integer, Time of day, Conditional type, Condition</mark></summary>

This allows you to set up map-specific SOS encounters that can be called by *any* Pokemon encountered on that map. This can be used if you want a specific species to be a possible SOS encounter on a given map, regardless of the species of the caller.

To do this, you just need to add this line to the data of a specific map's entry in `map_metadata.txt` that contains the following data:

* **Species ID**\
  The ID of the specific species you want to appear as an SOS call on this map.
* **Integer**\
  The percent chance of this species answering a wild Pokemon's call (1-100).
* **Time of Day**\
  The specific time of day this species should be available to call, if any. This can be any one of the following: `Any`, `Day`, `Night`, `Morning`, `Afternoon`, `Evening`. If this field is left empty, then it defaults to `Any` time of day.
* **Field Conditional type**\
  The specific type of field condition that should be checked for to see if this species should be available to call. This can be any one of the following: `Any`, `Weather`, `Terrain`, `Environment`. If this field is left empty, then it defaults to `Any` field conditional type.
* **Field Condition**\
  The specific field condition of the type listed above. For example, if `Weather` was set, then this field should be a type of weather, such as `Rain` or `Sun`. If `Terrain` was set, this should be set to a specific terrain type, such as `Grassy` or `Misty`. If `Environment` was set, this should be set to a specific environment type, such as `Forest` or `Underwater`. If `Any` was set, or it was left empty, then this field should also be left empty.

For example, let's add a special SOS encounter to Route 1 in default Essentials:

```
[005] # Route 1
Name = Route 1
Outdoor = true
ShowArea = true
MapPosition = 0,13,11
BattleBack = field
SpecialSOS = PIKACHU,5,Any,Any,
```

This will make it so that *any* wild Pokemon you encounter on Route 1 will have a 5% chance of attracting a wild Pikachu when making an SOS call, regardless of the species of the caller and regardless of which species it would normally call. This can happen at any time of day, under any circumstances.

Here's a series of more detailed examples to demonstrate the many ways that this data can be set:

* `SpecialSOS = POLIWRATH,1,Any,Weather,Rain`\
  This would make it so that wild Poliwrath have a 1% chance to be called during any time of day, but only if it's currently raining in battle.<br>
* `SpecialSOS = FLORGES,50,Morning,Terrain,Grassy`\
  This would make it so that wild Florges have a 50% chance to be called, but only during morning hours, and only if Grassy Terrain is currently set in battle.<br>
* `SpecialSOS = TRAPINCH,20,Day,Environment,Sand`\
  This would make it so that wild Trapinch have a 20% chance to be called, but only during daytime hours, and only if the battle environment is set to Sand.<br>
* `SpecialSOS = LYCANROC_1,100,Night,Any,`\
  This would make it so that wild Midnight form Lycanroc have a 100% chance to be called, but only during night time hours. This can happen under any field condition.<br>
* `SpecialSOS = JOLTEON,10,Any,Terrain,Electric,FLAREON,10,Any,Environment,Volcano,VAPOREON,10,Any,Weather,Rain,LEAFEON,10,Any,Weather,Sun,GLACEON,10,Any,Weather,Hail,ESPEON,10,Day,Any,,UMBREON,10,Night,Any,,`\
  Here's an extreme example to show how far this can be pushed. This would make it so that the following SOS encounters may be called by any Pokemon while on this map:
  * 10% chance to call Jolteon, but only if Electric Terrain is in play.
  * 10% chance to call Flareon, but only if the battle environment is set to Volcano.
  * 10% chance to call Vaporeon, but only if the weather is set to Rain.
  * 10% chance to call Leafeon, but only if the weather is set to Sun.
  * 10% chance to call Glaceon, but only if the weather is set to Hail.
  * 10% chance to call Espeon, but only during the day.
  * 10% chance to call Umbreon, but only at night.

***

<mark style="background-color:yellow;">**Special Spawn: Castform**</mark>

If you set a `SpecialSOS` for a map that depends on the current weather in battle, there is a small chance that Castform will spawn instead, regardless of whatever the `SpecialSOS` species was that you set. This may only occur if the weather that you set is either Sun, Rain, or Hail.

For example, if you set this SOS encounter for a particular map:

`SpecialSOS = CHERRIM,5,Day,Weather,Sun`

Then this would make it so that wild Cherrim have a 5% chance to be called, but only during the day while the weather is sunny. However, because Weather was specifically set for this special SOS encounter, and the specific weather being checked for is one of Sun, Rain, or Hail, it's possible that Castform may be summoned instead. Castform is considered a "rare" spawn, which means it has a 15% chance frequency to appear if Cherrim would be called.&#x20;

This means that since Cherrim in this example is set to have a 5% chance to be called, Castform would have a 15% chance out of a 5% chance to be called, meaning that Castorm's overall chance to appear from any SOS call is 0.8%. This is an exceedingly rare spawn, but it's a fun little surprised when it happens.

</details>

Page 68:

# SOS: Battle Rules

This plugin adds additional battle rules related to the SOS mechanic.

<details>

<summary><mark style="background-color:green;">"SOSBattle"</mark></summary>

This rule enables all wild Pokemon in this battle to perform SOS calls, even if the species normally has a call rate of zero, or if the SOS mechanic has been disabled. This can be used to set specific encounters to use the SOS mechanic, even if that species would typically be unable to use it.\
\
This is entered as `setBattleRule("SOSBattle")`

</details>

<details>

<summary><mark style="background-color:green;">"noSOSBattle"</mark></summary>

This rule disables the SOS mechanic from being triggered in this battle by all wild Pokemon. This can be used toggle the feature off for certain encounters, even if the species would normally be able to use SOS calls.\
\
This is entered as `setBattleRule("noSOSBattle")`

</details>

<details>

<summary><mark style="background-color:green;">"totemBattle"</mark></summary>

This rule flags the wild Pokemon encountered in this battle as a Totem Pokemon, and the battle will operate under Totem Battle rules. When this rule is enabled, the <mark style="background-color:green;">"SOSBattle"</mark>, <mark style="background-color:green;">"cannotRun"</mark> and <mark style="background-color:green;">"disablePokeBalls"</mark> Battle Rules are also enabled, regardless of however you may have set them.\
\
This is entered as `setBattleRule("totemBattle", true)`, but you may further customize this if you wish by entering an array instead of `true` as the second argument. In this array, you can include the specific stat ID's and stages  to set which specific aura boost the Totem Pokemon should receive at the start of the battle

For example, if you set `[:DEFENSE, 2]`, then the Totem Pokemon's aura will grant it +2 Defense at the start of the battle. If you enter `[:ATTACK, 1, :SPEED, 1]`, then the Totem Pokemon's aura will grant it +1 Attack and +1 Speed.

If no stats are set and this argument is just left as `true`, then the Totem Pokemon's aura will grant it a +1 omni boost to all stats by default.

</details>

<details>

<summary><mark style="background-color:green;">"setSOSPokemon"</mark></summary>

This rule replaces the species that the wild Pokemon would usually call via SOS. You can use this if you want to set a unique SOS call for the wild Pokemon in this battle that is a species that it normally wouldn't call. Keep in mind that this will replace any of the species that this Pokemon would naturally call, so any species that are assigned to it in its PBS data will be ignored. For Totem Battles specifically, this rule is used to set the first species the Totem Pokemon calls during battle.

This is entered as `setBattleRule("setSOSPokemon", Species)` where "Species" can be any species ID you want the wild Pokemon to call. If you set this to a hash instead, you can customize the called Pokemon's attributes. For example:

```
setBattleRule("setSOSPokemon", {
  :species => :URSARING,
  :level   => 35,
  :name    => "Big Mama",
  :gender  => 1,
  :shiny   => true
})
```

This would replace the wild Pokemon's normal SOS call with a level 35 Ursaring named "Big Mama" which is always female and always shiny. The specific data which may be set in this hash is identical to the data that may be set with the <mark style="background-color:green;">"editWildPokemon"</mark> rule found in the "Deluxe Battle Rules" section of this tutorial.

</details>

<details>

<summary><mark style="background-color:green;">"addSOSPokemon"</mark></summary>

This rule adds another species that the wild Pokemon may call via SOS. Unlike the <mark style="background-color:green;">"setSOSPokemon"</mark> rule above, this rule doesn't replace any of the normal species the wild Pokemon may call, it simply adds an additional species to their list of potential calls that may be rolled for. This additional species will be considered a "rare" spawn, so it will be included in that 15% roll that is used for all additional "rare" SOS calls. For Totem Battles specifically, this rule is used to set the second species the Totem Pokemon calls during battle.

This is entered as `setBattleRule("addSOSPokemon", Species)` where "Species" can be any species ID you want the wild Pokemon to call. If you set this to a hash instead, you can customize the called Pokemon's attributes. How this hash is set up is identical to how it's set up in the <mark style="background-color:green;">"setSOSPokemon"</mark> rule.

</details>

Page 69:

# SOS: Mid-Battle Scripting

This plugin adds various new keys to be used by the Deluxe Battle Kit's mid-battle scripting functionality.

***

<mark style="background-color:orange;">**Trigger Keys**</mark>

These are keys which trigger at various points of a wild Pokemon calling for help.

* <mark style="background-color:purple;">**"BeforeSOS"**</mark>\
  Triggers before a wild Pokemon makes its call for help.<br>
* <mark style="background-color:purple;">**"AfterSOS"**</mark>\
  Triggers after a wild Pokemon successfully called an ally Pokemon.<br>
* <mark style="background-color:purple;">**"FailedSOS"**</mark>\
  Triggers after a wild Pokemon called for help, but its help failed to appear.

{% hint style="info" %}
Trigger Extensions: You may extend these keys with a species ID or a type ID to specify that they should only trigger when an SOS call is made by a specific species, or species of a specific type. For example, <mark style="background-color:purple;">"BeforeSOS\_PIKACHU"</mark> would trigger only when a wild Pikachu is about to call for help, where <mark style="background-color:purple;">"FailedSOS\_ELECTRIC"</mark> would trigger only when a wild Electric-type attempted to call for help, but no help appeared.
{% endhint %}

***

<mark style="background-color:orange;">**Command Keys**</mark>

These are keys which trigger certain actions related to SOS calls, or adding new battlers or trainers to the battle.

<details>

<summary><mark style="background-color:blue;">"sosCall"</mark> => <mark style="background-color:yellow;">Boolean</mark></summary>

Forces a wild Pokemon to call for help when set to true. This will be ignored if the Pokemon isn't a wild Pokemon, is fainted, in the middle of a two-turn attack, or if their side of the battlefield is already at max capacity.&#x20;

Unlike a normal SOS call, forcing a wild Pokemon to call for help in this way cannot fail, so the call will always be answered by a new Pokemon. This can even be used to force SOS calls for species who typically have a call rate of zero, and would normally be unable to use SOS calls.&#x20;

Additionally, this can be used to force a wild Pokemon to call for an ally even if they already have one ally on the field, allowing you to use this to add a third wild Pokemon to the opponent's side. This is the only way to have a third Pokemon enter the field via SOS call, as the mechanic normally will only trigger if there is only a single wild Pokemon on the field.

</details>

<details>

<summary><mark style="background-color:blue;">"disableSOS"</mark> => <mark style="background-color:yellow;">Boolean</mark></summary>

Toggles the ability of wild Pokemon to call for help during this battle. If set to `true`, wild Pokemon will be flagged as unable to call for help via SOS. When set to `false`, this flag is removed, allowing wild Pokemon to make SOS calls again, if they are able to.

</details>

<details>

<summary><mark style="background-color:blue;">"addWild"</mark> => <mark style="background-color:yellow;">Symbol, Boolean, or Array</mark></summary>

Adds a new wild Pokemon to the opponent's side of the field during a wild battle, as long as their is room for a new battler. This happens independently of any SOS mechanics.&#x20;

When entered as a symbol, you can simply set this to a species ID to generate a Pokemon of that species to join the battle. If set to `true`, the species that is spawned is determined by whatever species the existing wild Pokemon on the field would normally call if the SOS mechanic was being used. If set as an array, you can include an integer as the second element of this array to indicate the level that this wild Pokemon should be. If no level is specified, the wild Pokemon will generate with whatever level a normal SOS spawn would typically have.

Note that the species added to battle in this way inherits the same traits as the ones set for that species with the <mark style="background-color:green;">"setSOSPokemon"</mark> and <mark style="background-color:green;">"addSOSPokemon"</mark> Battle Rules.

For example if you use the <mark style="background-color:green;">"setSOSPokemon"</mark> rule to set the SOS call for this battle to be a shiny Magikarp, then if you use this Command Key to add a wild Magikarp to the battle, it will also be shiny even though it wasn't properly SOS called. You can use this as a way of editing the attributes of specific species you intend to add to the battle with this key, even if you don't intend to use the actual SOS mechanic for this battle.

</details>

<details>

<summary><mark style="background-color:blue;">"addTrainer"</mark> => <mark style="background-color:yellow;">Array</mark></summary>

Adds a new trainer to join the opponent's side during a trainer battle, as long as there is room for a new battler.&#x20;

This must be set as an array which contains a trainer type ID of the trainer you want to add, followed by the name of that specific trainer. Optionally, you may include a version number as a third entry in this array if you want to add a trainer which has multiple versions. Otherwise, the version number is always assumed to be zero.

</details>

***

<mark style="background-color:orange;">**Hardcoding**</mark>

Here's a list of methods and/or properties that you might want to reference when hardcoding a midbattle script, since this plugin adds a lot of new custom content which you may need to call on to make certain things happen:

<details>

<summary>Battle class</summary>

**Variables**

* `@sosBattle`\
  When set equal to true, wild Pokemon may call for help. When set to false, this is disabled.<br>
* `@totemBattle`\
  This battle is considered a Totem Battle when the value of this variable is anything but false or nil.<br>
* `@primarySOS`\
  Stores the species ID or hash of data that will be used to replace the SOS species that would normally be called by the wild Pokemon. For Totem Battles, this refers to the first Pokemon that the Totem Pokemon will summon.<br>
* `@secondarySOS`\
  Stores the species ID or hash of data that will be used to add an additional SOS species that the wild Pokemon may call. For Totem Battles, this refers to the second Pokemon that the Totem Pokemon will summon.<br>
* `@sos_chain`\
  Stores the current SOS chain count.<br>
* `@adrenalineOrb`\
  When set to true, this will flag the battle as if an Adrenaline Orb has been used to boost the SOS call rate.<br>
* `@originalCaller`\
  Stores the Pokemon object of the initial caller that started the SOS chain. If the chain is broken, the new caller will be saved as the original caller.

**Methods**

* `pbCallForHelp(caller)`\
  Makes a wild battler attempt to call for help. The `caller` argument is the battler object who should be making the call.<br>
* `pbCallForHelpSimple(caller)`\
  Identical to the method above, except this simplifies the calling process and makes it so that the user's call is guaranteed to be answered by a wild Pokemon.<br>
* `pbAddNewBattler(species, level)`\
  Forces a new wild Pokemon to join the opponent's side, independent of any SOS mechanics. The `species` argument must be a species ID, and `level` should be the level of this new wild Pokemon. If either or both of these arguments are set to nil, the species and level of the called Pokemon will be determined based on the SOS data of the first available battler on the opponent's side.<br>
* `pbAddNewTrainer(tr_type, tr_name, version)`\
  Forces a new trainer to join the opponent's side in a trainer battle. The `tr_type` argument must be a valid trainer type ID, where `tr_name` should be the name of the specific trainer you want to add. For the `version` argument, you may enter the number of the specific version of this trainer that you want. If omitted, the version defaults to zero.

</details>

<details>

<summary>Battle::Battler class</summary>

**Variables**

* `@totemBattler`\
  When set to true, this battler object is considered a Totem Pokemon.<br>
* `@tookSuperEffectiveDamage`\
  When set to true, this flags the battler as if they have taken Super Effective damage this round. This is used to boost call rate chances.

**Methods**

* `sos_call_rate`\
  Returns the effective SOS call rate for this battler. This is based off of the base call rate of this battler's species. This always returns 100 if the battler is a Totem Pokemon. Defaults to a call rate of 9 if the battler's default call rate is zero but are being forced to make an SOS call anyway.<br>
* `canSOSCall?`\
  Returns true if the battler is capable of making an SOS call and passes all randomized checks based on their call rate.<br>
* `canSOSCallSimple?`\
  Returns true if the battler is capable of making an SOS call. This is a simplified version of the method above, and ignores call rate calculations. It simply returns true if nothing is preventing the battler from making an SOS call.<br>
* `isRivalSpecies?(other)`\
  Returns true if this battler is a rival species to the battler object entered as `other`.

</details>

Page 70:

# Raid Battles

[**Eevee Expo Link**](https://eeveeexpo.com/resources/1780/)

[**PokeCommunity Link**](https://www.pokecommunity.com/threads/raid-battles-dbk-add-on-v21-1.538045/#post-10954248)

[**Download Link**](https://www.mediafire.com/file/1xagrnhy2wd40hw/Raid_Battles.zip/file)

This plugin builds upon the Deluxe Battle Kit to add raid battle functionality. Raid battles were first introduced in *Pokemon Sword & Shield* as Max Raid Battles which featured battle challenges vs wild Dynamax Pokemon who had expanded HP pools and other unique mechanics such as raid shields. This has since become a staple of the mainline series, though each iteration adds a new twist to the mechanic, such as Tera Raid battles in *Pokemon Scarlet & Violet*.

The goal of this plugin is to implement the core functionality that allows you to set up your own raid battles. While this plugin does support both Max Raid and Tera Raid variants, it isn't required that you feature the Dynamax or Terastallization mechanics in your game. This plugin is capable of setting up a generic raid battle variant that implements general raid battle mechanics, but without tying it to any specific generational battle mechanic. So you're free to use this plugin to set up raid-style boss encounters even without those specific mechanics present.

***

<mark style="background-color:orange;">**Raid Battle Types**</mark>

By default, this plugin supports up to four different raid battle variants, depending on what type of mechanics are featured in your game.

<details>

<summary>Basic Raid Battles</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FfBZ7Je1dV6UjmyXSR9xy%2F%5B2024-11-27%5D%2017_45_38.873.png?alt=media&#x26;token=3aad66ff-4231-4291-81b1-68f9346b98e9" alt="" data-size="original">

These are generic raid battles that borrow mechanics from both Max Raid and Tera Raid battles featured in the main series, but without any specific generational battle gimmicks attached to them. In these raids, you're pitted against wild Pokemon that have expanded HP pools and a variety of special mechanics that make them more challenging than your average wild Pokemon.

While in a Basic Raid, no trainer is able to use Z-Moves, Ultra Burst, Dynamax, or Terastallization.

You can set up Basic Raid battles right out of the box, without any other supported plugins required.

</details>

<details>

<summary>Max Raid Battles</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F5KDmQaFqvpLlgLeTd10R%2F%5B2024-11-27%5D%2017_47_32.903.png?alt=media&#x26;token=01d7324a-8397-4335-a931-0484fdadc848" alt="" data-size="original">

These are raid battles inspired by Max Raid battles featured in *Pokemon Sword & Shield*. In these raids, you're pitted against wild Dynamax or Gigantamax Pokemon that have expanded HP pools and utilize the power of Dynamax to launch powerful Max Moves or G-Max Moves against you. Pokemon encountered in Max Raids will always be in Eternamax form if they have one, such as Eternatus.

While in a Max Raid, no trainer is able to use Mega Evolution, Z-Moves, Ultra Burst, or Terastallization.\
\
The [**Dynamax**](https://eeveeexpo.com/resources/1495/) add-on plugin is required if you wish to set up Max Raid battles.

</details>

<details>

<summary>Tera Raid Battles</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FKytS7wRK6RsUlHN4jwCW%2F%5B2024-11-27%5D%2017_48_14.809.png?alt=media&#x26;token=8f26282c-0205-44cb-972b-ced5cb94f710" alt="" data-size="original">

These are raid battles inspired by Tera Raid battles featured in *Pokemon Scarlet & Violet*. In these raids, you're pitted against wild Terastallized Pokemon that have expanded HP pools and utilize the power of Terastallization to change their typing and launch Tera-boosted moves against you. Pokemon encountered in Tera Raids will always be in Terastal form if they have one, such as Ogerpon and Terapagos.

While in a Tera Raid, no trainer is able to use Mega Evolution, Z-Moves, Ultra Burst, or Dynamax.\
\
The [**Terastallization**](https://eeveeexpo.com/resources/1476/) add-on plugin is required if you wish to set up Tera Raid battles.

</details>

<details>

<summary>Ultra Raid Battles</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FZhqjQe6L8IyVsamU3yru%2F%5B2024-11-27%5D%2017_46_46.896.png?alt=media&#x26;token=d81c4b94-132b-4cf0-a4d0-4a6c53c2b0ff" alt="" data-size="original">

These are raid battles totally unique to this plugin that imagine what raid battles would have been in the Gen 7 games, if they were included in *Pokemon Sun & Moon*. In these raids, you're pitted against wild Pokemon holding Z-Crystals that have expanded HP pools and utilize Z-Power to launch powerful Z-Moves against you. Pokemon encountered in Ultra Raids will always be in Ultra Burst form if they have one, such as Necrozma.

While in an Ultra Raid, no trainer is able to use Mega Evolution, Dynamax, or Terastallization.\
\
The [**Z-Power**](https://eeveeexpo.com/resources/1478/) add-on plugin is required if you wish to set up Ultra Raid battles.

</details>

***

<mark style="background-color:orange;">**Raid Battle Count**</mark>

Essentials internally keeps track of a variety of the player's game statistics. I've added trackers which will keep count of various statistics related to raid battles, too.

Below are all of the new statistics tracked by this plugin, and how to call them.

* **Raid Battle victories**\
  This plugin keeps count of how many times the player has defeated or captured a wild raid Pokemon in any type of raid battle. This can be called with the script `$stats.raid_battles_won`.<br>
* **Raid Dens cleared**\
  This plugin keeps count of how many times the player has cleared a Raid Den by either capturing or defeating the wild raid Pokemon within it. This can be called with the script `$stats.raid_dens_cleared`.<br>
* **Online Raid Dens cleared**\
  This plugin keeps count of how many times the player has cleared a distributed online Raid Den event by either capturing or defeating the wild raid Pokemon within it. This can be called with the script `$stats.online_raid_dens_cleared`.

Page 71:

# Raid: Properties

Various new properties are added by this plugin in order to establish the basic foundation for raid battles. The two fundamental properties are Raid Types - which determine the overall characteristics of raids, and Raid Ranks - which determine the difficulty levels of individual raids, what species are eligible to encounter, and the attributes those Pokemon may have when encountered.

These two things are what form the basis of what the rest of the plugin builds upon. Below, I'll go into detail about both properties.

***

<mark style="background-color:orange;">**Raid Types**</mark>

This plugin offers a variety of different types of raid battle styles to participate in. These are defined in the `RaidType` class within the `GameData` module in the plugin scripts. This is where all of the specifics of each raid type is stored, such as the specific music, battle text, and background visuals that are used for that specific type of raid.

By default, this plugin includes the following types of raids:

* **Basic Raids**
* **Ultra Raids** (only available when the [**Z-Power**](https://eeveeexpo.com/resources/1478/) add-on is installed)
* **Max Raids** (only available when the [**Dynamax**](https://eeveeexpo.com/resources/1495/) add-on is installed)
* **Tera Raids** (only available when the [**Terastallization**](https://eeveeexpo.com/resources/1476/) add-on is installed)

Basic Raids are always available for anyone who installs this plugin. However, the others may require additional add-on plugins to be present in order to be used.

Below, I'll go into detail about all of the defined properties for a raid type.

<details>

<summary>General Properties</summary>

* `:id`\
  Sets the ID associated with this raid type.<br>
* `:name`\
  This sets the name associated with this raid type. This typically isn't used for gameplay purposes, and is mostly used for debug and dev functions.<br>
* `:available`\
  This sets whether a specific type of raid should be available to the player. This should always be set to `true`. For Ultra, Max, and Tera raids in particular; this may be set to `false` instead if the required add-on plugins for those raid types are not installed.

</details>

<details>

<summary>Battle Properties</summary>

* `:battle_bg`\
  This sets the file name of the background image that is displayed during a specific type of raid battle. These graphics are located in `Graphics/Battlebacks`. Note that this shouldn't contain the full name of the graphic file, it should only contain the portion of the filename that appears before the first underscore. For example, you only need to include `"cave3"` here, not `"cave3_bg"`.<br>
* `:battle_base`\
  This sets the file name of the graphics used as the battler bases during a specific type of raid battle. These graphics are located in `Graphics/Battlebacks`. Note that this shouldn't contain the full name of the graphic file, it should only contain the portion of the filename that appears before the first underscore. For example, you only need to include `"cave3"` here, not `"cave3_base0"`.<br>
* `:battle_environ`\
  This sets the environment used during a specific type of raid battle. This can be set to any environment ID. By default, all raid battles use the `:Cave` environment. However, Ultra Raids in particular use the `:UltraSpace` environment, instead.<br>
* `:battle_text`\
  This sets the intro text that is displayed when encountering a wild Pokemon in a specific type of raid battle. This will replace the usual "A wild Pokemon appeared!" text. Note that despite whatever is entered here, you can still always manually override this text with the <mark style="background-color:green;">"battleIntroText"</mark> battle rule.<br>
* `:battle_flee`\
  This sets the text that is displayed if the raid Pokemon flees from a specific type of raid battle, which may happen if you fail or refuse to capture the raid Pokemon after defeating it. This will replace the usual "Pokemon fled!" text. Note that most types of raids use identical text for this, but you may want to customize this for different types of raids.<br>
* `:battle_bgm`\
  This sets the BGM that should play during a specific type of raid battle. Note that this is an array containing the name of at least two music files. The first file is the track that plays during most raid battles of a selected type, while the second file is the track that plays specifically during 7-star raids of a selected type. Some types of raids may have a third track entered here that plays during very specific encounters.<br>
* `:capture_bgm`\
  This sets the BGM that should play during the capture sequence of a specific type of raid battle. This track will begin to play when the raid Pokemon has been defeated, and you are prompted to capture it.

</details>

<details>

<summary>Overworld Properties</summary>

* `:den_name`\
  This sets the display name used on Raid Den entry screens for this specific type of raid.<br>
* `:den_sprite`\
  This sets the name of the graphic used for Raid Dens of this specific type of raid in the overworld. These graphics are located in `Graphics/Characters`.<br>
* `:den_size`\
  This sets how large a Raid Den will be on the overworld map. The number set here determines the number of tiles it will take up both in length and width. For example, when set to 2, this means the event will take up 2x2 tiles worth of space.<br>
* `:lair_bgm`\
  This sets the BGM that should play while exploring the map during a Raid Adventure.

</details>

***

<mark style="background-color:orange;">**Raid Ranks**</mark>

A raid's rank is simply the number of stars that raid has, which generally indicates the overall difficulty level of the raid. A raid's rank can range between 1-7 stars, with 1 being the easiest and 7 being the hardest.

The rank of a raid also determines which species can naturally be found in that raid. Generally speaking, weak and unevolved species such as Caterpie and Magikarp will typically be found in lower ranked raids such as ranks 1-2, while stronger evolved species will be found in higher ranks such as ranks 3-5. For the purposes of this plugin, rank 6 raids are reserved specifically for Legendary and Mythical species, as well as things like Ultra Beasts and Paradox species.

Rank 7 raids are the hardest difficulty raids. Unlike the other raid ranks, no species are naturally found in these raids, because it's already assumed that any species can appear in a rank 7 raid. I'll go into more detail on this when covering raid battles and dens elsewhere in this guide.

<details>

<summary>Assigning Raid Ranks Per Species</summary>

The raid ranks a species can be naturally found in is manually assigned in the PBS data for each species and form. Each species can appear in up to a maximum of three different raid ranks. For example, here are the raid ranks this plugin assigns to the Bulbasaur line by default:

```
#-------------------------------
[BULBASAUR]
...
RaidRanks = 1,2,3
#-------------------------------
[IVYSAUR]
...
RaidRanks = 3,4
#-------------------------------
[VENUSAUR]
...
RaidRanks = 4,5
```

For each species, the `RaidRanks` property is set to an array of numbers. The numbers indicate which raid ranks that particular species may appear in. In Bulbasaur's case, it can appear in raids with 1-3 stars. Ivysaur can appear in raids with 3-4 stars, while Venusaur only appears in 4-5 star raids.

Each species can only appear in up to three different raid ranks, so if you add additional ranks beyond three, the rest will be ignored. No species can be set to exclusively appear in 7-star raids, so if you add rank 7 to a species' `RaidRanks`, it will be ignored. Typically, you can only assign a species to appear in 1-6 star raids. However, this plugin reserves 6-star raids for Legendary and Mythical species by default, so keep that in mind when assigning raid ranks.

***

<mark style="background-color:orange;">**Species Eligibility**</mark>

If a species has no assigned `RaidRanks` data, it will be assumed that this species is banned from appearing in raid battles entirely, and thus will not appear in any raids. The same is true if you assign a species rank data as `RaidRanks = 0`. If you do not wish for a species or form to appear in raid battles for any reason, you can either set their `RaidRanks` to 0, or omit the line altogether.

By default, several species such as Shedinja and Smeargle are banned from appearing in raids due to not having any `RaidRanks` data set. Many species that have awkward gimmicks that aren't suitable for raid battles fall into this category.

***

<mark style="background-color:orange;">**Form Eligibility**</mark>

Unlike with most other species PBS data, any forms of a species will not naturally inherit the same `RaidRanks` as its base form. If you want a specific form of a species to be eligible to naturally appear as raid bosses, you must give them their own `RaidRanks` data in the same manner as you would with the base species.

The form of a species doesn't need to have the same `RaidRanks` data as its base form, however. For example, base Rotom has `RaidRanks = 3,4` set in its PBS data, while all of its forms have `RaidRanks = 4,5` set instead. It's even possible to make it so that the base form of a species doesn't appear in raid battles at all, but one of its forms do.

If no `RaidRanks` data is set for a form, that form will be considered banned from appearing in raid battles in the same way as base species. By default, most forms are banned from raids by default due to being battle-only forms, or forms that are naturally decided upon when the Pokemon is first created. However, genuine variants of a species, such as regional forms, are given their own `RaidRanks` data by this plugin by default.

</details>

<details>

<summary>Raid Eligibility Per Raid Type</summary>

Each type of raid may have further specifications that determine which species may appear in them. If you want to flag a certain species so that it may only appear in certain types of raids, but be banned from others, you can do so by setting the `RaidStyle` property.

```
#-------------------------------
[BULBASAUR]
...
RaidRanks = 1,2,3
RaidStyle = Basic,Tera
```

In this example, Bulbasar is given the `RaidStyle` property. This is set to an array with the symbols `Basic` and `Tera`, meaning that Bulbasaur may appear in 1-3 star Basic Raids and 1-3 star Tera Raids. However, Bulbasaur will be completely banned from appearing in any Max Raids or Ultra Raids. You may use this property if you'd like to limit what sort of raids a species may appear in. If the `RaidStyle` property is not set, it will just always be assumed that the species is eligible for any type of raid.

Here are all of the possible raid type symbols that may be set in the `RaidStyle` property:

* `Basic`
* `Max`
* `Tera`
* `Ultra`

In addition to this setting, each raid type is hardcoded to ban certain species or forms. Below, I'll list all of the species that will be automatically disqualified from appearing in each type of raid.

***

<mark style="background-color:orange;">**Basic Raids**</mark>\
The following species or forms are hardcoded to always be banned from all Basic Raids, even if they would otherwise be eligible to appear in a specific raid rank:

* All Ultra Burst forms of a species.
* All Gigantamax forms of a species.
* All Eternamax forms of a species.
* All Terastal forms of a species.

***

<mark style="background-color:orange;">**Max Raids**</mark>\
The following species or forms are hardcoded to always be banned from all Max Raids, even if they would otherwise be eligible to appear in a specific raid rank:

* All Mega Evolved forms of a species.
* All Primal forms of a species.
* All Ultra Burst forms of a species.
* All Terastal forms of a species.
* The base form of any species that have an Eternamax form. For example, Eternamax Eternatus can appear in Max Raids, but not base Eternatus.
* All species with the `"CannotDynamax"` flag, such as Zacian and Zamazenta.

***

<mark style="background-color:orange;">**Tera Raids**</mark>\
The following species or forms are hardcoded to always be banned from all Tera Raids, even if they would otherwise be eligible to appear in a specific raid rank:

* All Mega Evolved forms of a species.
* All Primal forms of a species.
* All Ultra Burst forms of a species.
* All Gigantamax forms of a species.
* All Eternamax forms of a species.
* The base form of any species that have a Terastal form. For example, Stellar Terapagos can appear in Tera Raids, but not base Terapagos.
* All species with the `"CannotTerastallize"` flag.

***

<mark style="background-color:orange;">**Ultra Raids**</mark>\
The following species or forms are hardcoded to always be banned from all Ultra Raids, even if they would otherwise be eligible to appear in a specific raid rank:

* All Mega Evolved forms of a species.
* All Primal forms of a species.
* All Gigantamax forms of a species.
* All Eternamax forms of a species.
* All Terastal forms of a species.
* The base forms of any species that have an Ultra Burst form. For example, Ultra Necrozma can appear in Ultra Raids, but not base Necrozma or its fused forms.

</details>

Page 72:

# Raid: Battle Call

To initiate a raid battle, you just have to enter a script in an event like you would with any other battle. Except, instead of using `WildBattle.start` or `TrainerBattle.start`, you can use a brand new battle call named `RaidBattle.start`.

This new battle call can accept two arguments, although each of these arguments are optional. Just entering `RaidBattle.start` on its own is enough to trigger a raid battle, but you can control various aspects about the raid with the following arguments that I will go into detail about in this subsection.

***

<mark style="background-color:orange;">**Setting A Species**</mark>

A species can be set by entering a value as the first argument in the `RaidBattle.start` call. There are various ways in which this value can be set, each of which can control which species will be encountered in a raid battle in different ways. I'll explain each method that this may be set below.

<details>

<summary>Setting a specific species</summary>

If you would like to set the specific species generated for a raid battle, you can enter the species ID of the Pokemon you want, exactly like you would in a `WildBattle.start` call. However, unlike with normal wild battles, you do not enter a level for the Pokemon as the second argument, since raid battles will automatically determine the level the raid Pokemon should be based on the raid's difficulty level.

For example:

```
RaidBattle.start(:PIKACHU)
```

This would initiate a raid battle with a wild Pikachu. Its level and other attributes will be naturally decided for you based on the difficulty of the raid, which will automatically scale based on your badge count and the raid ranks that the entered species is naturally capable of generating in.

Note that if the species you entered is an ineligible raid species (such as Shedinja is by default), then Ditto will be generated by the raid instead. Ditto will always act as a placeholder species to spawn in scenarios where the entered species cannot appear in a raid battle.

***

<mark style="background-color:orange;">**Entering Forms**</mark>

You may enter a specific form to appear in a raid, too. This can be done the same as above, by entering the species ID of that specific form, like so:

```
RaidBattle.start(:RAICHU_1)
```

However, if you enter a form which isn't eligible, then the base form of the species will be generated instead. For example, Primal Kyogre is an ineligible raid form by default. So if you enter `:KYOGRE_1` in a raid battle call, it will generate a raid with base Kyogre despite what you entered here.

If the base species is also ineligible, then the species generated will default to Ditto, same as above.

</details>

<details>

<summary>Setting a random species based on entered criteria</summary>

If you would like a raid battle to generate a random species, or generate a random species based on certain criteria, then you can enter a hash instead of a specific species ID. This hash can contain any number of the following:

* `:type =>` <mark style="background-color:yellow;">Type ID</mark>\
  This will only randomize species that have a particular type. For example, entering `:FIRE` would only generate random Fire-type species.\ <br>
* `:habitat =>` <mark style="background-color:yellow;">Habitat ID</mark>\
  This will only randomize species that are found in a particular habitat. For example, entering `:Forest` will only generate random species that appear in the Forest habitat. A species' habitat is set in their PBS data.\ <br>
* `:generation =>` <mark style="background-color:yellow;">Generation Number</mark>\
  This will only randomize species that were introduced in a particular generation. For example, entering `3` will only generate random species from the Hoenn region, introduced in Generation 3. A species' generation is set in their PBS data.\ <br>
* `:encounter ⇒` <mark style="background-color:yellow;">Encounter Type ID</mark>\
  This will only randomize species that are found on a certain encounter table on the specific map this event is found on. For example, entering `:Land` will only generate random species that may be encountered in the Land encounter table for this map defined in the `encounters.txt` PBS file. The encounter type will automatically update based on the time of day, so you don't have to manually enter something like `:LandNight`, unless you specifically want the raid to only pull from the nighttime encounter table at all times of day.\
  \
  Note that the species found in this manner will scale based on the difficulty rank of the raid. So for example, if the encounter tables only contain weak Pokemon like Pidgey, but the difficulty rank of the raid would outclass Pidgey; the raid may generate a raid with the evolved forms of Pidgey instead, even though Pidgeotto or Pidgeot do not appear in this encounter table.

You can set as few or as many of these filters as you want. You can even set none of them if you'd like, and just enter `nil` or an empty hash for a truly random selection of species. Or, you can combine multiple filters to really narrow down the specific kinds of species you would like to appear in a raid battle. For example:

```
RaidBattle.start({
  :habitat    => :Cave,
  :generation => 1
})
```

This raid battle would generate a random species found in the Cave habitat that was introduced in Gen 1. This includes things like Onix, Zubat, Gastly, and Diglett. If you added the `:type` filter to this and set it to `:POISON`, this would narrow things down further so that only things like Zubat and Gastly could be generated.

You can use these filters to make highly specified types of raid battles that aren't set to a specific species, but will still generate species that match a specific theme. If you set a combination of filters that doesn't result in any species that matches the entered criteria, then Ditto will be spawned instead.

Note that the species that are randomly generated in this manner are entirely based on the difficulty of the raid, which is determined by the player's badge count by default. So the player will never randomly encounter something like Charizard if they only have 1 badge, for example.

</details>

***

<mark style="background-color:orange;">**Setting Raid Properties**</mark>

The second argument in the `RaidBattle.start` call is used for setting various special rules and conditions that alter certain properties of this raid battle. These rules are entered as a hash that may contain any number of the following elements:

<table><thead><tr><th width="196">Key</th><th width="125">Value</th><th>Description</th></tr></thead><tbody><tr><td><code>:rank</code></td><td>Integer (1-7)</td><td>Sets the number of stars of this raid battle, aka the difficulty of the raid. By default, the rank of a raid is determined by the player's badge count, but you can manually set the rank with this setting.<br><br>Note that rank 7 is the highest difficulty a raid can be.</td></tr><tr><td><code>:style</code></td><td>Raid Type ID</td><td>Sets the type of raid for this raid battle. This can be set to any of the following: <code>:Basic</code>, <code>:Ultra</code>, <code>:Max</code>, or <code>:Tera</code>. By default, all raid battles are Basic Raids unless specified.<br><br>NOTE: This setting is totally ignored when setting up a Raid Den event, as the type of raid is determined through other means. Check out the "Raid: Raid Dens" subsection of this guide for details.</td></tr><tr><td><code>:size</code></td><td>Integer (1-3)</td><td>Sets the number of battlers the player will send out against the raid boss at one time. By default, this is set to the value of <code>RAID_BASE_PARTY_SIZE</code> in the plugin Settings. This setting is ignored if the player has less than the number of able Pokemon in the party, or if the <code>:partner</code> setting is entered.</td></tr><tr><td><code>:partner</code></td><td>Array</td><td>Sets a partner trainer to accompany the player in this raid battle. This is an array containing a trainer type ID, the name of the particular trainer, and the desired version number (optional). This partner trainer will replace any existing follower the player currently has with them for this battle only, and the original partner will be restored afterwards.<br><br>Note that you may add <code>true</code> as an optional fourth element in this array if you wish to set a trainer without their attributes being automatically scaled to suit the raid.</td></tr><tr><td><code>:turn_count</code></td><td>Integer</td><td>Overrides the natural turn counter for this raid battle with the number of turns entered here. If set to <code>nil</code>, the turn counter for this raid battle will be disabled altogether.</td></tr><tr><td><code>:ko_count</code></td><td>Integer</td><td>Overrides the natural KO counter for this raid battle with the number of KO's entered here. If set to <code>nil</code>, the KO counter for this raid battle will be disabled altogether.</td></tr><tr><td><code>:shield_hp</code></td><td>Integer</td><td>Overrides the natural amount of max shield HP the raid Pokemon will have during this raid battle with the HP number entered here. If set to <code>nil</code>, the the raid Pokemon will be unable to summon a raid shield altogether.</td></tr><tr><td><code>:extra_actions</code></td><td>Array</td><td><p>Overrides the natural extra actions the raid Pokemon will use during this raid battle with the ones entered here. If set to <code>nil</code>, the the raid Pokemon will be unable to use these extra actions altogether. By default, this array contains the following extra actions:</p><p></p><p><code>:reset_boosts</code></p><p><code>:reset_drops</code></p><p><code>:drain_cheer</code></p><p><br>You can include or exclude whichever of these actions that you like.</p></td></tr><tr><td><code>:support_moves</code></td><td>Array</td><td>Overrides the natural extra support moves the raid Pokemon may select from during this raid battle with the ones entered here. If set to <code>nil</code>, the raid Pokemon will not use any extra support moves. By default, this array contains all eligible support moves that the species is capable of learning.<br><br>You can include as many move ID's in this array as you like to allow the raid Pokemon to use an extra move when a support move is triggered. Despite the name "support moves," you can technically enter any move ID's here.</td></tr><tr><td><code>:spread_moves</code></td><td>Array</td><td>Overrides the natural extra spread moves the raid Pokemon may select from during this raid battle with the ones entered here. If set to <code>nil</code>, the raid Pokemon will not use any extra spread moves. By default, this array contains all eligible spread moves that the species is capable of learning.<br><br>You can include as many move ID's in this array as you like to allow the raid Pokemon to use an extra move when a spread move is triggered. Despite the name "spread moves," you can technically enter any move ID's here.</td></tr><tr><td><code>:loot</code></td><td>Array</td><td>Used for Raid Den events only. Check out the "Raid: Raid Dens" subsection of this guide for details.</td></tr><tr><td><code>:online</code></td><td>False</td><td>Used for Raid Den events only. Check out the "Raid: Raid Dens" subsection of this guide for details.</td></tr></tbody></table>

For more details on specifics about partner trainers, raid counters, raid shields, and extra raid actions and moves, check out the "Raid: Battle Mechanics" subsection of this guide. That will clarify what some of these settings do, and how they are meant to be used.

***

<mark style="background-color:orange;">**Example Raid Battles**</mark>

By combining the information above, I'll provide various examples of several raid battles to show how these various elements may be set.

<details>

<summary>Basic Raid Examples</summary>

<mark style="background-color:orange;">**Example 1**</mark>

```
RaidBattle.start(:CHARIZARD, {
  :rank          => 5,
  :shield_hp     => 8,
  :support_moves => [:SUNNYDAY]
})
```

This initiates a 5-star Basic  Raid vs. a wild Charizard. Charizard will always use the move Sunny Day as its support move, and will always have 8 bars of shield HP when it summons its raid shield. This will be a 3v1 battle by default, since no `:size` information was manually set.

***

<mark style="background-color:orange;">**Example 2**</mark>

```
RaidBattle.start({
  :type       => :ROCK,
  :habitat    => :Mountain }, {
  :turn_count => 25,
  :partner    => [:POKEMONTRAINER_May, "May"]
})
```

This initiates a Basic Raid vs. a random Rock-type species that is found in the Mountain habitat. The difficulty of the raid and encounter is determined by the player's badge count, since no `:rank` information was manually set.

The player will have Pokemon Trainer May set as their raid partner for this battle only, so this will always be a 2v1 battle. You will also be given 25 turns to clear the raid, instead of whatever the natural turn counter would be.

***

<mark style="background-color:orange;">**Example 3**</mark>

```
RaidBattle.start(nil, {
  :size          => 1,
  :extra_actions => [:reset_boosts, :reset_drops]
})
```

This initiates a Basic Raid vs. a completely random wild species based on the raid's rank. Since no `:rank` information has been manually set, the rank will be determined based on the player's badge count. This will be a 1v1 battle, and the raid Pokemon will be able to perform the `:reset_boosts` and `:reset_drops` extra actions, but be unable to use the `:drain_cheer` action since it's not included in the array.

***

<mark style="background-color:orange;">**Example 4**</mark>

```
RaidBattle.start({
  :encounter => :Cave }, {
  :rank      => 5
})
```

This initiates a 5-star Basic Raid vs. a random wild species found on the `:Cave` encounter table for this specific map. If the species found on this encounter table are too weak to appear in a 5-star raid, such as Geodude or Machop, then the raid will consider the evolved forms of these species instead. If this map doesn't have an encounter table of this type, or if none of the species can appear in this raid (including their evolved forms), then this will be a Ditto raid instead.

</details>

<details>

<summary>Ultra Raid Examples</summary>

<mark style="background-color:orange;">**Example 1**</mark>

```
RaidBattle.start(:NECROZMA, {
  :style      => :Ultra,
  :ko_count   => 6,
  :shield_hp  => nil,
})
```

This initiates a 6-star Ultra Raid vs. Ultra Necrozma. This will always be a 6-star raid since legendary Pokemon are always set to appear in 6-star raids by default. Necrozma will always be in Ultra Burst form despite base Necrozma being entered here, because species that have Ultra Burst forms will always appear in those forms when encountered in an Ultra Raid.

In this raid battle, the KO counter will be set to 6, overriding the natural KO counter. Ultra Necrozma will not summon a raid shield in this battle, since it has been disabled.

***

<mark style="background-color:orange;">**Example 2**</mark>

```
RaidBattle.start({
  :generation   => 7 }, {
  :style        => :Ultra,
  :partner      => [:POKEMONTRAINER_Brendan, "Brendan", 1],
  :spread_moves => nil
})
```

This initiates an Ultra Raid vs. a random species from Generation 7. The difficulty of the raid and encounter is determined by the player's badge count, since no `:rank` information was manually set.

The player will have version 1 of Pokemon Trainer Brendan set as their raid partner for this battle only, so this will always be a 2v1 battle. The raid Pokemon will not use any extra spread moves during this battle, as they have been disabled.

***

<mark style="background-color:orange;">**Example 3**</mark>

```
setBattleRule("editWildPokemon", {
  :item => :GHOSTIUMZ,
  :moves => [:CURSE, :SHADOWBALL, :SLUDGEBOMB, :CONFUSERAY]
})
RaidBattle.start(:GENGAR, {
  :rank          => 5,  
  :style         => :Ultra,
  :extra_actions => nil,
})
```

This initiates a 5-star Ultra Raid vs. Gengar. The <mark style="background-color:green;">"editWildPokemon"</mark> rule has been set to ensure that this Gengar will always be holding the Z-Crystal Ghostium Z, and has specific moves to use with its held Z-Crystal. In this battle, Gengar will not perform extra actions (reset boosts, reset drops, and drain cheer), since they have been disabled.

</details>

<details>

<summary>Max Raid Examples</summary>

<mark style="background-color:orange;">**Example 1**</mark>

```
RaidBattle.start(:GYARADOS, {
  :style         => :Max,
  :spread_moves  => [:BREAKINGSWIPE, :EARTHQUAKE],
  :support_moves => [:AQUARING, :BULKUP]
})
```

This initiates a Max Raid vs. Gyarados. The difficulty of this raid will be randomly determined based on the raid ranks that Gyarados may appear in, since no `:rank` information has been set.

In this raid battle, Gyarados' AI will always select between using the moves Breaking Swipe or Earthquake when an extra spread move is triggered, and it will select between using Aqua Ring and Bulk Up when an extra support move is triggered. Note that Gyarados doesn't normally learn the moves Aqua Ring or Bulk Up, but it can be forced to use them anyway when set here.

***

<mark style="background-color:orange;">**Example 2**</mark>

```
RaidBattle.start(:LAPRAS_1, {
  :rank     => 3,
  :style    => :Max,
  :ko_count => nil
})
```

This initiates a 3-star Max Raid vs. G-Max Lapras. Note that `:LAPRAS_1` is usually banned from most other types of raids, and would default to base Lapras when set in most situations. However, the G-Max Lapras form *is* eligible in Max Raids specifically, so it can be set and encountered here without issue.

In this raid, the KO counter has been disabled, so the raid will not end regardless of how many times your Pokemon are KO'd.

***

<mark style="background-color:orange;">**Example 3**</mark>

```
RaidBattle.start(:ETERNATUS, {
  :style         => :Max,
  :extra_actions => nil,
})
```

This initiates a 6-star Max Raid vs. Eternamax Eternatus. This will always be a 6-star raid since legendary Pokemon are always set to appear in 6-star raids by default. Eternatus will always be in its Eternamax form despite base Eternatus being entered here, because species that have an Eternamax form will always appear in those forms when encountered in a Max Raid.

</details>

<details>

<summary>Tera Raid Examples</summary>

<mark style="background-color:orange;">**Example 1**</mark>

```
RaidBattle.start({
  :type      => :WATER,
  :encounter => :SuperRod }, {
  :rank      => 7,
  :style     => :Tera
})
```

This initiates a 7-star Tera Raid vs. a random Water-type species found on the `:SuperRod` encounter table for this specific map. This will be fought on the most extreme difficulty, since 7 is the highest rank a raid may have.

***

<mark style="background-color:orange;">**Example 2**</mark>

```
RaidBattle.start(:TERAPAGOS, {
  :style         => :Tera,
  :size          => 2,
  :support_moves => nil,
  :extra_actions => [:drain_cheer]
})
```

This initiates a 6-star Tera Raid vs. Stellar Terapagos. This will always be a 6-star raid since legendary Pokemon are always set to appear in 6-star raids by default. Terapagos will always be in its Terastallized Stellar form despite base Terapagos being entered here, because species that have a special Terastal form will always appear in those forms when encountered in a Tera Raid.

This will be a 2v1 battle, and Terapagos will not use any extra support moves since they have been disabled. Terapagos will be able to perform the `:drain_cheer` extra action, but it won't be able to perform the `:reset_boosts` or `:reset_drops` actions since they have been excluded.

***

<mark style="background-color:orange;">**Example 3**</mark>

```
setBattleRule("editWildPokemon", {
  :tera_type => :GHOST
})
RaidBattle.start(:SLAKING, {
  :rank          => 5,
  :style         => :Tera,
  :support_moves => [:SKILLSWAP]
})
```

This initiates a 5-star Tera Raid vs. Slaking. The <mark style="background-color:green;">"editWildPokemon"</mark> rule has been set to ensure that this Slaking is always Tera Ghost. In this battle, Slaking will use the move Skill Swap as an extra support move. Note that Slaking doesn't normally learn Skill Swap, but it can be forced to use it anyway when set here.&#x20;

</details>

***

<mark style="background-color:orange;">**Debug Raid Battle**</mark>

Note that if you would like to quickly set up a raid battle for testing purposes, you can create your own in-game through the debug menu. To do so, navigate to "Deluxe plugin settings...", and then select "Other plugin settings..."

From here, there will be an option called "Raid settings..." that opens a menu with three other options. The last option here is called "Test raid battle."

<div><figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FdCSwyWqMHGxrkmWLPJqq%2F%5B2024-11-27%5D%2017_51_26.808.png?alt=media&#x26;token=6a3dc369-87c5-4acb-be32-930640290331" alt=""><figcaption></figcaption></figure> <figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FoIF2pOmesHt7Hr3IIEwl%2F%5B2024-12-03%5D%2010_14_56.022.png?alt=media&#x26;token=e82a5030-7cfc-493a-b8c9-d8a16900b25e" alt=""><figcaption></figcaption></figure> <figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F7lMxHJLvBw7OFUzV9CgG%2F%5B2024-12-03%5D%2010_19_39.911.png?alt=media&#x26;token=03f341f2-fa6b-4a8b-9134-c696d5cc2364" alt=""><figcaption></figcaption></figure></div>

Once selected, you will be asked to choose the specific type of raid battle to participate in, and the specific species you wish to challenge. From there, you will be allowed to set specific criteria for this raid, such as the rank, what party members to bring, or whether or not there should be a partner trainer accompanying you. Once you finalized on the desired criteria for this raid battle, select the Battle option to initiate a demo raid battle.

Page 73:

# Raid: Raid Dens

Raid Dens are an alternative way of initiating raid battles. Instead of instantly entering a battle like you would with a normal battle event, you can set up a Raid Den event that will generate new Pokemon for you to encounter on a regular basis. This means you can revisit a den to capture new Pokemon, and earn new rewards. You can set up dens of various raid types, such as Max Raid Dens and Tera Raid Dens.

It's also possible to set up special dens that feature exclusive Pokemon that are distributed to players over the internet, like an online event. This can allow you to release special challenge raids to your players as a limited timed event.

Below, I'll explain how to set up your own Raid Dens and how they operate.

***

<mark style="background-color:orange;">**Setting Up a Raid Den**</mark>

To set up a Raid Den event, you need to create a new event with the following criteria:

<details>

<summary>Event name</summary>

The event name should be one of the following, depending on the type of Raid Den you'd like to make:

* `BasicRaidDen`
* `UltraRaidDen`
* `MaxRaidDen`
* `TeraRaidDen`

This is important, as the name of the event allows for certain den features to function, such as which graphic is used, how many tiles of space the event takes up, and other mechanics. Note that these names should have no spaces between each word.

</details>

<details>

<summary>Event animation and graphic</summary>

In the event's Options pane, you must make sure that `Move Animation` should be **unchecked**, while the `Stop Animation` setting should be **checked** off . This is important, otherwise certain visual features of the den event will not work correctly.

In addition, you should *not* set a graphic for the Raid Den event. An appropriate graphic will automatically be set based on the event name that you entered.

</details>

<details>

<summary>Event script command</summary>

The command list of the event should contain the script `pbRaidDen`. This script can either be left exactly as-is, or you may customize it by including up to two additional arguments.

This script accepts the same exact arguments as the `RaidBattle.start` command does, so refer to the "Raid: Battle Call" subsection of this guide for a breakdown on what arguments you may set to customize your Raid Den.

***

<mark style="background-color:orange;">**Argument Differences**</mark>

There are a few small differences between using `pbRaidDen` and `RaidBattle.start` when it comes to the keys that are set in the rules hash of the second argument.

* `:style`\
  Unlike regular raid battles, Raid Den events completely ignore the `:style` key. This is because the type of raid is automatically decided based on the name of the Raid Den event. So using the `:style` setting here will do nothing.\ <br>
* `:loot`\
  Raid Den events accept this key which can be used to set exclusive rewards that are added to a specific raid's loot tables. I'll go into more detail about this in the "Raid Den Rewards Screen" section below.\ <br>
* `:online`\
  Raid Den events accept this key which can be used to toggle whether or not this particular den should be capable of generating a Pokemon distributed by the developer over the internet. If set to `true`, then this den will *always* generate an online event, if one is available. If set to `false`, then this den will *never* generate an online event, even if one is available. If this key is omitted entirely, then by default it will be assumed that this den will have a 1 in 3 chance of generating an online event if one is available. I'll go into more detail about this in the table below, under the "Online Raids" tab.

</details>

The table below will provide a basic example of how each type of Raid Den event should look like both in and out of gameplay.

{% tabs %}
{% tab title="Basic Raids" %}
This is an example of what a Basic Raid Den event looks like.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FCBPgX5ifmtC6etedXKk5%2Fbasic%20event.JPG?alt=media&#x26;token=9b80cc50-9984-4f7a-ae7e-c31159dcd3b9" alt="" width="506"><figcaption><p>Example of a Basic Raid event.</p></figcaption></figure>

Note that Basic Raid Dens take up 3x3 tiles worth of space during actual gameplay, so be mindful of where you place the event. Any event given the name `BasicRaidDen` will automatically load the following graphic to be displayed during gameplay, so no graphic should be manually set for the event.

The Raid Den graphic will automatically update and display differently depending on the current state of the Raid Den. Here are the different states a Basic Raid Den may be in:

* **Purple Eyes**\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FBrW4ErAyva9QMYaCc3w9%2Fbasic%20den%204.png?alt=media\&token=7c9e5709-9e3c-4652-b345-e1dbf049bf28)\
  If the eye color of the Basic Raid Den are purple, that means this den contains an unknown Pokemon to battle. This color will be displayed when the den has been reset with a new Pokemon to encounter.\ <br>
* **Red Eyes**\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FCQOT3jb8X8cwU7dTJglb%2Fbasic%20den%202.png?alt=media\&token=e70da2f4-3a64-4d8f-88df-9c22092480dd)\
  If the eye color of the Basic Raid Den are red, that means this den contains a known Pokemon that has already been saved to this den. While the eyes of this den remain red, you will always encounter the same exact Pokemon each time you enter this den until it is forced to reset.\ <br>
* **Blue Eyes**\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F51dKWqRjDY3kBB72su3V%2Fbasic%20den%203.png?alt=media\&token=7143cbb3-c984-4914-9fc1-3badb6e6c781)\
  If the eye color of the Basic Raid Den are blue, that means this den contains a known Legendary or Mythical species that has already been saved to this den. While the eyes of this den remain blue, you will always encounter the same exact Pokemon each time you enter this den until it is forced to reset.\ <br>
* **Colorless Eyes**\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FCktHljs9QVdcN8FJYGtX%2Fbasic%20den%201.png?alt=media\&token=307fdbf7-07a6-4730-a274-cc9ac08586c9)\
  If the eyes of the Basic Raid Den are colorless, that means this den is empty and contains no Pokemon. You will be unable to enter this den until it has been reset through some means.
  {% endtab %}

{% tab title="Ultra Raids" %}
This is an example of what an Ultra Raid Den event looks like.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FOflJRlL8yuks3LlJY1ej%2Fultra%20event.JPG?alt=media&#x26;token=aab7123b-7509-4fbd-b6fd-ded2d1c09178" alt="" width="504"><figcaption><p>Example of an Ultra Raid event.</p></figcaption></figure>

Note that Ultra Raid Dens take up 3x3 tiles worth of space during actual gameplay, so be mindful of where you place the event. Any event given the name `UltraRaidDen` will automatically load the following graphic to be displayed during gameplay, so no graphic should be manually set for the event.

The Raid Den graphic will automatically update and display differently depending on the current state of the Raid Den. Here are the different states an Ultra Raid Den may be in:

* **Dark Blue Portal**\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fr5jwP45eOirp3LUrKJ5M%2Fultra%20den%204.png?alt=media\&token=53ca2ccc-bf4e-44ac-812e-3aded0efb73b)\
  If the portal color of the Ultra Raid Den is a dark blue, that means this den contains an unknown Pokemon to battle. This color will be displayed when the den has been reset with a new Pokemon to encounter.\ <br>
* **Red Portal**\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F5eo7zBaKbhA8j9FdKke8%2Fultra%20den%202.png?alt=media\&token=ef897fc8-5077-4715-ba87-366b8e292289)\
  If the portal color of the Ultra Raid Den is red, that means this den contains a known Pokemon that has already been saved to this den. While the portal of this den remains red, you will always encounter the same exact Pokemon each time you enter this den until it is forced to reset.\ <br>
* **Light Blue Portal**\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FOR6942yMPs4gefECt9vP%2Fultra%20den%203.png?alt=media\&token=5ff5686f-0b33-496f-8cf8-bc799bf0e87f)\
  If the portal color of the Ultra Raid Den is a light blue, that means this den contains a known Ultra Beast or Ultra Burst species that has already been saved to this den. While the portal of this den remains blue, you will always encounter the same exact Pokemon each time you enter this den until it is forced to reset.\ <br>
* **Colorless Portal**\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FvYzSyn1u4Sc4AyWgWown%2Fultra%20den%201.png?alt=media\&token=68fa0e14-a34f-4fb2-8696-b8d47502f2c1)\
  If the portal of the Ultra Raid Den is colorless, that means this den is empty and contains no Pokemon. You will be unable to enter this den until it has been reset through some means.
  {% endtab %}

{% tab title="Max Raids" %}
This is an example of what a Max Raid Den event looks like.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FmviJWB3qvwVCPyaiI6ft%2Fmax%20event.JPG?alt=media&#x26;token=a8b7748a-8ea0-4777-9556-2a37262c9779" alt="" width="504"><figcaption><p>Example of a Max Raid event.</p></figcaption></figure>

Note that Max Raid Dens take up 2x2 tiles worth of space during actual gameplay, so be mindful of where you place the event. Any event given the name `MaxRaidDen` will automatically load the following graphic to be displayed during gameplay, so no graphic should be manually set for the event.

The Raid Den graphic will automatically update and display differently depending on the current state of the Raid Den. Here are the different states a Max Raid Den may be in:

* **Purple Beam**\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fdhq8QJ7sqQX47QXT12bH%2Fmax%20den%204.png?alt=media\&token=8817e4b4-650a-4ec8-8a21-f20a3b80a905)\
  If the beam color of the Max Raid Den is purple, that means this den contains an unknown Pokemon to battle. This color will be displayed when the den has been reset with a new Pokemon to encounter.\ <br>
* **Red Beam**\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fp8EaUxwmPrPeTyfopTYj%2Fmax%20den%202.png?alt=media\&token=67289173-095f-49cd-9f3d-c672156d737c)\
  If the beam color of the Max Raid Den is red, that means this den contains a known Pokemon that has already been saved to this den. While the beam of this den remains red, you will always encounter the same exact Pokemon each time you enter this den until it is forced to reset.\ <br>
* **Blue Beam**\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FlpYZ02vCvNI542mDR6sF%2Fmax%20den%203.png?alt=media\&token=fe4abae3-965b-47ca-a5d0-0fc39c4b248b)\
  If the beam color of the Max Raid Den is blue, that means this den contains a Calyrex that has already been saved to this den. While the beam of this den remains blue, you will always encounter the same exact Calyrex each time you enter this den until it is forced to reset.\ <br>
* **No Beam**\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FNTvl5P9CFCYY7BWdF66G%2Fmax%20den%201.png?alt=media\&token=04e7e2f7-3597-4091-9410-abbc574a47d0)\
  If there is no beam coming out of the Max Raid Den, that means this den is empty and contains no Pokemon. You will be unable to enter this den until it has been reset through some means.
  {% endtab %}

{% tab title="Tera Raids" %}
This is an example of what a Tera Raid Den event looks like.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fb7kpCB2x7pRwH4Ntw1Hf%2Ftera%20event.JPG?alt=media&#x26;token=fa1dd9a9-b5e3-4db2-abef-21b5ae5536b8" alt="" width="506"><figcaption><p>Example of a Tera Raid event.</p></figcaption></figure>

Note that Tera Raid Dens take up 2x2 tiles worth of space during actual gameplay, so be mindful of where you place the event. Any event given the name `TeraRaidDen` will automatically load the following graphic to be displayed during gameplay, so no graphic should be manually set for the event.

The Raid Den graphic will automatically update and display differently depending on the current state of the Raid Den. Here are the different states a Tera Raid Den may be in:

* **Light Blue Crystals (Sparkling)**\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FlCbiXJh9oZarC90D0vCH%2Ftera%20den%204.png?alt=media\&token=7f3803a4-1119-4d79-9949-e46f055cd711)\
  If the crystals of the Tera Raid Den are light blue and sparkling, that means this den contains an unknown Pokemon to battle. Sparkles will be displayed when the den has been reset with a new Pokemon to encounter.\ <br>
* **Light Blue Crystals (Not Sparkling)**\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FchoUOdkmA3gjlhGMtRmL%2Ftera%20den%202.png?alt=media\&token=aef4737b-d327-4afd-ad5b-d4ea0df43eb1)\
  If the crystal color of the Tera Raid Den is light blue with no sparkles, that means this den contains a known Pokemon that has already been saved to this den. While the crystals of this den remain in this state, you will always encounter the same exact Pokemon each time you enter this den until it is forced to reset.\ <br>
* **Dark Blue Crystals**\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FSrmwitohRstMcyiToee3%2Ftera%20den%203.png?alt=media\&token=58d44a4c-c142-4e01-bd84-db5c16c27496)\
  If the crystal color of the Tera Raid Den is dark blue, that means this den contains a known Paradox Pokemon or a Pokemon in a special Terastal form that has already been saved to this den. While the crystals of this den remain in this state, you will always encounter the same exact Pokemon each time you enter this den until it is forced to reset.\ <br>
* **Colorless Crystals**\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FPYFaWGAy7vKybXOTApR5%2Ftera%20den%201.png?alt=media\&token=a6556519-fa5f-4485-82b1-d8b1a82e6504)\
  If the crystals of the Tera Raid Den are colorless, that means this den is empty and contains no Pokemon. You will be unable to enter this den until it has been reset through some means.
  {% endtab %}

{% tab title="Online Raids" %}
As the developer, you have the ability to distribute special Raid Den events to your players over the internet. This is done by setting up all of the data for your raid distribution in a [**Pastebin**](https://pastebin.com/) link. If you're familiar with how to set up Mystery Gifts to your players, it's a somewhat similar idea to that.

{% hint style="warning" %}
**Raid Den Availability**

* Only one Raid Den distribution may be active at a time.
* When a Raid Den distribution is live, any Raid Den that the player accesses of a particular type will have a 1 in 3 chance of generating the distributed Raid Den. For example, if you distribute a Tera Raid Den, then all Tera Raid Dens the player accesses may generate the distributed Tera Raid.
* If you don't want a particular Raid Den to ever generate a distributed den, you may enter `:online ⇒ false` in the rules hash for that Raid Den event. This will flag this den so that it isn't able to read data sent over the internet.
* If you want a particular Raid Den to *always* generate a distributed den if one is available, you may enter `:online ⇒ true` in the rules hash for that Raid Den event. This will flag this den so that it always prioritizes data sent over the internet, if any is available.
* If the Raid Den being distributed has a fixed `RaidRank` set, only players that have an appropriate number of badges for that raid rank will be able to encounter this distribution. For example, if you distribute a 5-star Raid Den, only players with 8+ badges will be able to encounter this distribution.
  {% endhint %}

***

<mark style="background-color:orange;">**Pastebin Setup**</mark>

Setting up an online raid distribution is easy. All you have to do is follow the steps below before releasing your game:

1. Go to [**www.pastebin.com**](https://pastebin.com/), and click the green button at the top of the page that says **+ paste** to start a new paste.\ <br>
2. In the text box, enter all of the information you want for your online distribution. This includes all of the attributes the raid Pokemon should have, as well as all of the settings for this raid battle.\ <br>
3. Once you're done with your paste, click "Create New Paste" to save it.\ <br>
4. Once saved, click the "raw" button in the row of buttons above your paste, and it will bring you to a blank webpage that displays nothing but the contents of your paste. Copy the URL of this webpage.\ <br>
5. Go into the Settings file of this plugin. You will see a constant named `LIVE_RAID_EVENT_URL`. Delete the existing string that is set here by default, and paste your copied URL here as a string instead.\ <br>
6. Done! From now on, anything that this URL links to will be the content that is distributed to your players. If you ever want to end distributing any Raid Den data over the internet, you just have to delete all of the content in your paste and replace it with a single character. This is because Pastebin doesn't allow you to save an empty paste, so just replace it with any character as a placeholder.

***

<mark style="background-color:orange;">**Pastebin Content**</mark>

The information entered for your Raid Den distribution is entered similarly to the way you would enter information in most PBS files. This means that you **don't** need to enter quotation marks for strings, brackets for arrays, or colons for symbols.

Here is an example of a basic Raid Den distribution:

```
Species = CHARIZARD
AbilityIndex = 2
Moves = DRAGONPULSE,FLAMETHROWER,SOLARBEAM,AIRSLASH
Shiny = true
RaidRank = 5
RaidStyle = Basic
RaidLoot = CHARCOAL,1
```

This will distribute a 5-star Basic Raid Den vs. Charizard. This Charizard will be shiny and have its Hidden Ability; as well as having the moves Dragon Pulse, Flamethrower, Solar Beam, and Air Slash. In addition, one piece of Charcoal will be added to this Raid Den's loot table.

In the tables below, I'll list every possible criteria you may enter when setting up an online Raid Den distribution. I'll break this down into two groups of criteria: Pokemon attributes, and Raid attributes.

***

<mark style="background-color:orange;">**Pokemon Attributes**</mark>

These are settings that alter the attributes of the actual Pokemon that will be found within the distributed Raid Den. Note that `Species` is the only mandatory data required. All other data is optional.

<table><thead><tr><th width="177">Data</th><th width="145">Value</th><th>Description</th></tr></thead><tbody><tr><td><code>Species</code></td><td>Species ID</td><td>Sets the species for this raid Pokemon. This setting is mandatory.</td></tr><tr><td><code>Form</code></td><td>Integer</td><td>Sets the form number of this raid Pokemon.</td></tr><tr><td><code>Gender</code></td><td>String</td><td>Sets the gender of this raid Pokemon. Enter either <code>0</code>, <code>M</code>, or <code>Male</code> for male, or <code>1</code>, <code>F</code>, or <code>Female</code> for female.</td></tr><tr><td><code>AbilityIndex</code></td><td>Integer</td><td>Sets the ability index of this raid Pokemon.</td></tr><tr><td><code>Moves</code></td><td>Array</td><td>Sets the moves of this raid Pokemon by entering an array of Move ID's.</td></tr><tr><td><code>Item</code></td><td>Item ID</td><td>Sets the held item of this raid Pokemon.</td></tr><tr><td><code>Nature</code></td><td>Nature ID</td><td>Sets the nature of this raid Pokemon.</td></tr><tr><td><code>IV</code></td><td>Array</td><td>Sets the IV's of this raid Pokemon. Set to an array to set the IV values of each stat, or a single number to set the IV's of all stats to that number.</td></tr><tr><td><code>EV</code></td><td>Array</td><td>Sets the EV's of this raid Pokemon. Set to an array to set the EV values of each stat, or a single number to set the EV's of all stats to that number.</td></tr><tr><td><code>Shiny</code></td><td>Boolean</td><td>Sets whether this raid Pokemon is shiny.</td></tr><tr><td><code>SuperShiny</code></td><td>Boolean</td><td>Sets whether this raid Pokemon is super shiny.</td></tr><tr><td><code>HPLevel</code></td><td>Integer</td><td>Sets the wild boss HP scaling for this raid Pokemon. Only set this if you want to override the natural boss HP scaling that this den would normally use. Refer to the "Wild Boss Attributes" section for details.</td></tr><tr><td><code>Immunities</code></td><td>Array</td><td>Sets various wild boss immunities. Note that this will not replace any existing boss immunities that raid Pokemon naturally have; this can only be used to add additional immunities. Refer to the "Wild Boss Attributes" section for details.</td></tr><tr><td><code>Memento</code></td><td>Ribbon ID</td><td>This can only be set if the <a href="https://eeveeexpo.com/resources/1381/"><strong>Improved Mementos</strong></a> plugin is installed. Sets a memento on the raid Pokemon. If the memento grants the Pokemon a title, this title will be displayed above its HP bar in battle.</td></tr><tr><td><code>Scale</code></td><td>Integer (0-255)</td><td>This can only be set if the <a href="https://eeveeexpo.com/resources/1381/"><strong>Improved Mementos</strong></a> plugin is installed. Sets the raid Pokemon's size value.</td></tr><tr><td><code>GmaxFactor</code></td><td>Boolean</td><td>This can only be set if the <a href="https://eeveeexpo.com/resources/1495/"><strong>Dynamax</strong></a> plugin is installed. Sets whether or not the raid Pokemon has G-Max Factor.</td></tr><tr><td><code>TeraType</code></td><td>Type ID</td><td>This can only be set if the <a href="https://eeveeexpo.com/resources/1476/"><strong>Terastallization</strong></a> plugin is installed. Sets a specific Tera type for the raid Pokemon.</td></tr></tbody></table>

***

<mark style="background-color:orange;">**Raid Attributes**</mark>

These are settings that alter the attributes of the distributed Raid Den itself. Note that all of this data is entirely optional.

<table><thead><tr><th width="216">Data</th><th width="125">Value</th><th>Description</th></tr></thead><tbody><tr><td><code>RaidStyle</code></td><td>Raid Type ID</td><td>Sets the specific type of Raid Den to distribute. If omitted, this is always assumed to be a <code>Basic</code> Raid Den by default.</td></tr><tr><td><code>RaidRank</code></td><td>Integer (1-7)</td><td>Sets the difficulty rank of this Raid Den. If omitted, the raid rank will naturally be determined by the <code>Species</code> entered.</td></tr><tr><td><code>RaidSize</code></td><td>Integer (1-3)</td><td>Sets the number of battlers the player can send out in this raid battle. This is set to the value of <code>RAID_BASE_PARTY_SIZE</code> in the plugin Settings by default. This setting is ignored if the <code>RaidPartner</code> setting is used.</td></tr><tr><td><code>RaidPartner</code></td><td>Array</td><td>Sets a partner trainer that should accompany the player in this raid battle. This is set as an array containing a Trainer Type ID, followed by the trainer's name and version number. Optionally, you may also include <code>true</code> if you wish for this trainer to appear in battle exactly as defined in the <code>trainers.txt</code> PBS file (instead of scaling to fit the raid).</td></tr><tr><td><code>RaidTurns</code></td><td>Integer</td><td>Sets the turn counter used in this raid battle. If omitted, the natural turn counter that this raid battle would normally have is set. Set to <code>-1</code> to disable the turn counter entirely.</td></tr><tr><td><code>RaidKOs</code></td><td>Integer</td><td>Sets the KO counter used in this raid battle. If omitted, the natural KO counter that this raid battle would normally have is set. Set to <code>-1</code> to disable the KO counter entirely.</td></tr><tr><td><code>RaidShield</code></td><td>Integer</td><td>Sets the amount of HP the raid Pokemon's raid shield will have. If omitted, the natural amount of shield HP the raid Pokemon would normally have is set. Set to <code>-1</code> to disable the raid shield entirely.</td></tr><tr><td><code>RaidActions</code></td><td>Array</td><td>Overrides the natural extra raid actions the raid Pokemon may utilize during this raid battle. Set as an array containing any of the following to set the desired raid actions:<br><code>:reset_drops</code><br><code>:reset_boosts</code><br><code>:drain_cheer</code></td></tr><tr><td><code>RaidSupportMoves</code></td><td>Array</td><td>Overrides the natural extra support moves the raid Pokemon may select from during this raid battle. Set as an array of Move ID's to set the desired moves.</td></tr><tr><td><code>RaidSpreadMoves</code></td><td>Array</td><td>Overrides the natural extra spread moves the raid Pokemon may select from during this raid battle. Set as an array of Move ID's to set the desired moves.</td></tr><tr><td><code>RaidLoot</code></td><td>Array</td><td>Includes additional bonus rewards to appear in this Raid Den's loot table. This is entered as an array containing an Item ID followed by the quantity of that item to reward. You may add as many pairs of items and quantities as you'd like.</td></tr></tbody></table>
{% endtab %}
{% endtabs %}

***

<mark style="background-color:orange;">**Raid Den Entry Screen**</mark>

When interacting with a Raid Den, you will be asked to save your game prior to the species within being revealed. If you accept, the species will be decided and saved to that den event. Once saved, this den will not generate a new Pokemon until the current one has been defeated or captured, or if the Raid Den has been forced to reset.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F4BRXbRGyTJ0mzsiFvAv0%2F%5B2024-11-28%5D%2008_21_18.116.png?alt=media&#x26;token=1645291c-cf26-4e0a-ad13-045c516345cb" alt="" width="384"><figcaption><p>Example of a Basic Raid Den entry screen.</p></figcaption></figure>

Once the Raid Den species has been decided, the raid entry screen will be displayed. This screen will display a variety of information such as the silhouette of the raid Pokemon, the conditions of this raid battle, and the overall difficulty of the raid indicated by star count.

<details>

<summary>General Displays</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FA0JQCoyieoCRJhZGs5Ml%2F%5B2024-11-28%5D%2008_21_18.117.png?alt=media&#x26;token=d1ac2ff1-bf8b-4d22-a9af-c32f00ba29c0" alt="" data-size="original">

Every entry screen for a Raid Den will display general information that will give you an overall synopsis of what kind of challenge you can expect from this Raid Den. This includes the name of this specific type of Raid Den, the number of stars indicating its difficulty, and the silhouette and typing of the Pokemon you can expect to find inside.

The den name and visual style of the screen will also differ to reflect the specific type of Raid Den this is. Here are the other display styles used for each type of Raid Den:

* **Ultra Raid Den**\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FzTYpRuL6hhEsR9XTx92l%2F%5B2024-11-29%5D%2011_23_05.669.png?alt=media\&token=1e61f4b9-b95e-4d7d-a691-790145712998)
* **Max Raid Den**\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FjDnJF3Obr3IyakAKWGL3%2F%5B2024-11-29%5D%2011_23_13.797.png?alt=media\&token=299624a5-c658-44e9-9852-5a8bf508820d)
* **Tera Raid Den**\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FJbZqyDuwNxkEGVzZ4ihR%2F%5B2024-11-29%5D%2012_48_40.247.png?alt=media\&token=1e582b56-55a9-410c-b155-3123fc0525e4)

***

<mark style="background-color:orange;">**Raid Ranks**</mark>

Below the Raid Den name, you will see a row of 1-7 stars, depending on the raid. These stars indicate the raid's rank, which determines the overall difficulty of this Raid Den. Rank 1 raids are the easiest raids, with rank 5 being the most challenging raids that you can naturally find.

By default, rank 6 raids are exclusively used by Legendary Pokemon, but will never generate naturally unless you manually set the `:rank` to 6 in the den event's rules hash, or if you manually set a legendary species as the raid Pokemon.

Rank 7 raids are the most challenging possible raid rank. Similarly to rank 6 raids, rank 7 raids will never naturally generate, and can only be encountered if you manually set the den's `:rank` to 7.

Note that any Pokemon species that is capable of appearing in raid battles can be forced to appear in any raid rank. However, if no species is manually forced to appear, then only species that are naturally capable of appearing in the specified raid rank will be generated. For example, Mewtwo is exclusively found in rank 6 raids naturally, but you can force Mewtwo to be encountered in a rank 1 raid if you manually set the species and rank of a specific Raid Den.

Below, I'll list out each raid rank and describe when they become naturally available, and what the level ranges may be for the raid Pokemon encountered inside those raids.

* **Rank 1**\
  Naturally Available: Badges 0-7\
  Raid Pokemon Level: 10-15\ <br>
* **Rank 2**\
  Naturally Available: Badges 0-7\
  Raid Pokemon Level: 20-25\ <br>
* **Rank 3**\
  Naturally Available: Badges 3+\
  Raid Pokemon Level: 30-35\ <br>
* **Rank 4**\
  Naturally Available: Badges 6+\
  Raid Pokemon Level: 40-45\ <br>
* **Rank 5**\
  Naturally Available: Badges 8+\
  Raid Pokemon Level: 65-70\ <br>
* **Rank 6**\
  Naturally Available: ---\
  Raid Pokemon Level: 75-80\ <br>
* **Rank 7**\
  Naturally Available: ---\
  Raid Pokemon Level: 100

</details>

<details>

<summary>Raid Battle Conditions</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FIROGBDzRR9WsZWRqira7%2F%5B2024-11-28%5D%2008_21_18.118.png?alt=media&#x26;token=8e0ed53e-45a9-424d-b308-554bbc4b606e" alt="" data-size="original">

In the bottom left quadrant of the Raid Den entry screen will be where the specific battle conditions for this raid battle will be displayed. This will typically display the number of turns you will have to complete the raid, and/or the number of times your Pokemon will be allowed to be KO'd before the raid is considered a loss.

If you manually edit or disable these counters for a specific Raid Den, this will be reflected in the text that is displayed here. If the turn counter and the KO counter are both disabled for this Raid Den, then a generic placeholder message will be displayed here instead.

</details>

<details>

<summary>Battle Participants</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FAQYJm5XZ2kUVEmXb8L7e%2F%5B2024-11-28%5D%2008_21_18.119.png?alt=media&#x26;token=599c1d48-5a2b-4f68-98ab-f74815032c79" alt="" data-size="original">

In the bottom right quadrant of the Raid Den entry screen will be where all participating Pokemon in this raid battle will be displayed. This can display 1-3 Pokemon, depending on the raid settings and other conditions. This will always display your lead Pokemon by default, but you can select other party members to participate instead by selecting the "Change Party" option.

By default, raid battles will always assume to be fought in a 3v1 format, so you will have the option to select 3 Pokemon here. However, there may be various reasons why the raid would accept fewer participants:

* The `RAID_BASE_PARTY_SIZE` in the plugin settings is set to a smaller default party size.
* This particular Raid Den has a `:size` value set in the rules hash to a smaller party size.
* The player has fewer able Pokemon in their party than required by the raid.
* This particular Raid Den has a `:partner` set in the rules hash, forcing it to be a 2v1 battle instead.

***

<mark style="background-color:orange;">**Partner Participants**</mark>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FfnqVDJPbM3Nhrm6wABHc%2F%5B2024-11-29%5D%2011_22_51.853.png?alt=media&#x26;token=e7603c41-d75e-4fbb-b501-e284fb84f494" alt="" data-size="original">

When a raid partner trainer is set to participate with you in a Raid Den, then the entry screen will display a little differently to reflect this. Icons for both the player and the partner trainer will be displayed, with the Pokemon they will be bringing to the raid displayed next to each trainer.&#x20;

Both trainers will only be allowed to bring a single Pokemon with them into the raid battle. The partner trainer's Pokemon cannot be changed, but you will be allowed to select a specific Pokemon to bring like normal.

For more details related to raid partners, check out the "Raid: Battle Mechanics" subsection of this guide.

</details>

<details>

<summary>Battlefield Conditions</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FhdniHwhXHuYCYucy5Yqj%2F%5B2024-11-28%5D%2008_23_03.460.png?alt=media&#x26;token=100d90e1-a5a1-445f-90bd-1a0c5d112cb5" alt="" data-size="original">

Sometimes there may be an additional display in the top right corner of the raid entry screen. This display will have various icons displayed which will indicate special battlefield conditions that will be in play during this raid battle. These conditions include weather, terrain, and the battle environment.

These conditions will be displayed if there is an effect in play that changes the default values for one or more of these conditions. For example, when you are on a map with the `:Storm` weather in play on the overworld, then this will make it so that the Rain weather condition and Electric Terrain will be permanently in play during any battle on this map. This will be carried over into raid battles too, so the Raid Den entry screen will display these icons to reflect that.

Another way this might be applied is through the use of the <mark style="background-color:green;">"weather"</mark>, <mark style="background-color:green;">"terrain"</mark>, and/or <mark style="background-color:green;">"environment"</mark> battle rules. If you manually set one of these rules to change one or more of the default battlefield conditions, then this will be represented in the Raid Den entry screen.

Below, I'll showcase the icons for each battlefield condition, and what they represent.

***

<mark style="background-color:orange;">**Weather Icons**</mark>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FdUbr0CQ6R9snJyKmnRwl%2Fweather_icons.png?alt=media&#x26;token=42540b7e-9d85-45df-977f-c775f4367ea9" alt="" data-size="original">

From left to right, these icons indicate the following weather conditions:

* None (no weather)
* Sun or Harsh Sun
* Rain or Heavy Rain
* Hail or Snow
* Sandstorm
* Strong Winds
* Shadow Sky

Note that icons are present for Primordial weather conditions despite Primordial weather being unable to be set normally. These icons are just here as placeholder.

***

<mark style="background-color:orange;">**Terrain Icons**</mark>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FdPMhZEGWrZYSYoLGzIvA%2Fterrain_icons.png?alt=media&#x26;token=422ea5e9-f217-42f2-9fe5-f509199eb731" alt="" data-size="original">

From left to right, these icons indicate the following battle terrain conditions:

* None (no terrain)
* Grassy Terrain
* Electric Terrain
* Misty Terrain
* Psychic Terrain

***

<mark style="background-color:orange;">**Environment Icons**</mark>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fcnm8GzpxQxkheeSFeBM0%2Fenviron_icons.png?alt=media&#x26;token=efd4f352-e8a1-41a4-a1d0-9b5106181c2a" alt="" data-size="original">

From left to right, these icons indicate the following environments:

* None (urban areas, interiors)
* Grass or Tall Grass
* Forest or Forest Grass
* Moving Water or Still Water
* Underwater
* Puddle
* Sand
* Rock
* Cave
* Volcano
* Graveyard
* Snow or Ice
* Sky
* Space
* Ultra Space

Note that most Raid Dens take place in the Cave environment by default, unless a rule is in place that manually alters this. The one exception is Ultra Raids, which take place in the Ultra Space environment by default.

***

<mark style="background-color:orange;">**Adding Custom Icons**</mark>

If your game has any custom battlefield conditions that you'd like to be represented by this plugin, you may add custom icons for these conditions in the folder:

```
Graphics/Plugins/Raid Battles/Raid Dens/Field Icons
```

In here, you can add your condition by naming the file based on the ID of that condition with either `weather_`, `terrain_`, or `environ_` as a prefix to the filename, depending on the type of condition it is.

For example, if you created a new terrain called "Lava Terrain" with the ID of `:Lava`, then your new icon would have to be named `terrain_Lava`.

Note that all icons should be 28x28 pixels large to properly fit in the UI.

</details>

<details>

<summary>Other Icons</summary>

In some situations, there may be additional icons that appear just above the selection window of a Raid Den's entry screen, in the upper right quadrant. These icons indicate specific data about this particular Raid Den.

Note that it's possible for multiple icons to appear here at once if more than one conditions are met.

***

<mark style="background-color:orange;">**Bonus Loot Icon**</mark>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FR9kGw2bkwgUsqiw1pfNc%2F%5B2024-12-02%5D%2006_44_22.139.png?alt=media&#x26;token=977ee55c-5411-4021-9361-952607f70171" alt="" data-size="original">

If this particular Raid Den has had extra rewards added to its loot table with the `:loot` property in the den event's rule hash, then this icon will appear to indicate that this den yields exclusive rewards.

***

<mark style="background-color:orange;">**Online Event Icon**</mark>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FJ0LoTR8xO3m6Xiqo08CO%2F%5B2024-12-02%5D%2008_49_41.128.png?alt=media&#x26;token=b04dca9c-2e1c-49fb-89c2-a95cb2dd71b7" alt="" data-size="original">

This icon will appear if the specific Pokemon found in this den is being distributed over the internet via an online event, rather than being naturally generated. Online raid events override whatever Pokemon the particular den would normally spawn.

***

<mark style="background-color:orange;">**Z-Crystal Icon**</mark>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FXhSuGXjEDURX8Z58bY1V%2F%5B2024-11-29%5D%2012_40_16.302.png?alt=media&#x26;token=82b317b1-898c-4547-bfe7-23370c929acf" alt="" data-size="original">

In Ultra Raid Dens specifically, the icon for the specific Z-Crystal that the raid Pokemon will be holding will be displayed in this region of the den's entry screen. This will allow you to prepare for the raid better, as you will have a more general idea of what sort of Z-Moves you can expect to have to deal with during this fight.

***

<mark style="background-color:orange;">**Gigantamax Icon**</mark>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FK21AzGVWruY2zRHzsfcQ%2F%5B2024-11-29%5D%2012_40_23.121.png?alt=media&#x26;token=c73ea805-e9dd-4745-a4a4-6dcd9411eb01" alt="" data-size="original">

In Max Raid Dens specifically, you may occasionally encounter a den with the G-Max Factor icon in this region of the den's entry screen. This icon will indicate that the raid Pokemon encountered in this den will be in its Gigantamax form.

***

<mark style="background-color:orange;">**Tera Type Icon**</mark>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FsuUdJj8fFCaLpeeClErp%2F%5B2024-11-29%5D%2012_45_58.895.png?alt=media&#x26;token=5ccb77ec-d568-4d2b-a0d7-c52a10a2591e" alt="" data-size="original">

In Tera Raid Dens specifically, the icon for the specific Tera type that the raid Pokemon will have will be displayed in this region of the den's entry screen. This will allow you to prepare for the raid batter, as you will know which type the Terastallized Pokemon will be when encountered.

</details>

***

<mark style="background-color:orange;">**Raid Den Rewards Screen**</mark>

Upon exiting a Raid Den, you will be immediately presented with the raid rewards screen. Depending on the outcome of the raid battle, this window will display various information. If you successfully cleared the raid, you will be granted several rewards that are randomly generated based on the specific raid's reward table. If you captured the raid Pokemon, extra information about the captured Pokemon will be displayed, too.&#x20;

If you failed to clear the raid however, no rewards will be granted.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FbKAWGWA5OXHcyPaM6l4H%2F%5B2024-11-28%5D%2014_44_54.436.png?alt=media&#x26;token=84cfcda9-6720-4cf7-bbb4-f8b70a711eb4" alt="" width="384"><figcaption><p>Example of a Basic Raid Den rewards screen.</p></figcaption></figure>

Below, I'll explain all of the rewards that may be possible to obtain through clearing Raid Dens.

<details>

<summary>Base Reward Tables</summary>

Each raid will grant rewards based on a particular loot table that is generated for that raid. The exact list of rewards and quantities for each item will be random, but follow a general pattern based on the difficulty of the raid.

Generally speaking, the rewards yielded by each raid rank is cumulative with the previous ranks. So for example, a 4-star raid will grant all the same rewards found in ranks 1-3, plus the additional rewards granted by a rank 4 raid. However, the quantities of each item rewarded will be dramatically increased based on the rank of the raid. Lower-ranked raids may only yield 1-3 of each item, while higher-ranked raids may yield as much as 10-25+, depending on the item.

Below, I'll list out every item you may hope to find in a raid's loot table, and what raid ranks you can expect to start seeing those items appear as rewards.

***

<mark style="background-color:yellow;">**Base Rewards**</mark>

* Exp. Candy XS
* Exp. Candy S
* EV-Reducing Berry (Random)
* EV-Increasing Feather (Random)

<mark style="background-color:yellow;">**Raid Ranks 3+**</mark>

* Exp. Candy M
* Rare Candy
* TM/TR (Random; based on raid Pokemon's typing; only 1)
* EV Vitamin (Random)
* PP Up/PP Max (Low odds; only 1)
* Ability Capsule/Ability Patch (Low odds; only 1)
* Low-value sell item (Low odds; only 1)

<mark style="background-color:yellow;">**Raid Ranks 4+**</mark>

* Exp. Candy L (High odds)
* Nature Mint (Random; only 1)
* High-value sell item (Low odds; only 1)

<mark style="background-color:yellow;">**Raid Ranks 5+**</mark>

* Exp. Candy L (Guaranteed)
* Exp. Candy XL (High odds)

<mark style="background-color:yellow;">**Raid Ranks 6+**</mark>

* Exp. Candy XL (Guaranteed)
* Very high-value sell item (Low odds)

</details>

<details>

<summary>Raid-Specific Rewards</summary>

Some rewards are only administered when clearing a certain type of raid. Below, I'll list the specific items that may be earned as rewards in certain types of raids.

***

<mark style="background-color:orange;">**Ultra Raid Dens**</mark>

* <mark style="background-color:yellow;">**Z-Booster**</mark>\
  This item is guaranteed to appear in an Ultra Raid Den's loot table if the raid Pokemon is Necrozma.

***

<mark style="background-color:orange;">**Max Raid Dens**</mark>

* <mark style="background-color:yellow;">**Dynamax Candy**</mark>\
  This item is guaranteed to appear in a Max Raid Den's loot table. The quantity depends on the raid rank.<br>
* <mark style="background-color:yellow;">**Max Soup**</mark>\
  This item has a 50% chance of appearing in a Max Raid Den's loot table if the raid Pokemon was in Gigantamax form.<br>
* <mark style="background-color:yellow;">**Max Honey**</mark>\
  This item is guaranteed to appear in a Max Raid Den's loot table if the raid Pokemon is Vespiquen.<br>
* <mark style="background-color:yellow;">**Max Mushrooms**</mark>\
  This item is guaranteed to appear in a Max Raid Den's loot table if the raid Pokemon is Parasect, Breloom, Amoongus, Shiinotic, or Toedscruel.<br>
* <mark style="background-color:yellow;">**Wishing Star**</mark>\
  This item is guaranteed to appear in a Max Raid Den's loot table if the raid Pokemon is Eternatus.

***

<mark style="background-color:orange;">**Tera Raid Dens**</mark>

* <mark style="background-color:yellow;">**Tera Shards**</mark>\
  These items are guaranteed to appear in a Tera Raid Den's loot table. The specific type of shard depends on the raid Pokemon's Tera type. The quantity depends on the raid rank. If the player has the Glimmering Charm key item in their inventory, the number of Tera Shards awarded will be dramatically increased.<br>
* <mark style="background-color:yellow;">**Mystery Tera Jewel**</mark>\
  This item has a low chance to appear in a Tera Raid Den's loot table.<br>
* <mark style="background-color:yellow;">**Radiant Tera Jewel**</mark>\
  This item is guaranteed to appear in a Tera Raid Den's loot table if the raid Pokemon is Terapagos.

Note that any TM or TR rewards earned from Tera Raid Dens will be randomly decided based on the raid Pokemon's Tera type instead of their natural typing.

</details>

<details>

<summary>Conditional Rewards</summary>

Certain rewards may only appear in a raid's loot table depending on certain battlefield conditions that were in play during the battle. These are the same conditions outlined under "Battlefield Conditions" in the "Raid Den Entry Screen" section above.

It's quite rare for these items to drop from a raid, and when they do, you will only obtain one of each item that drops. These items are more for flavor to match the theme of the raid; so some of them are valuable, while others may be useless. The quality of the items weren't considered when assigning them.

***

<mark style="background-color:orange;">**Weather-Based Rewards**</mark>

* Heat Rock (Sun)
* Damp Rock (Rain)
* Icy Rock (Hail/Snow)
* Smooth Rock (Sandstorm)
* Life Orb (Shadow Sky)
* Smoke Ball (Fog; not in Essentials by default)

***

<mark style="background-color:orange;">**Terrain-Based Rewards**</mark>

* Electric Seed (Electric Terrain)
* Grassy Seed (Grassy Terrain)
* Misty Seed (Misty Terrain)
* Psychic Seed (Psychic Terrain)

***

<mark style="background-color:orange;">**Environment-Based Rewards**</mark>

* Cell Battery (None)
* Miracle Seed (Grass)
* Absorb Bulb (Tall Grass)
* Mystic Water (Moving Water)
* Fresh Water (Still Water)
* Light Clay (Puddle)
* Shoal Shell (Underwater)
* Luminous Moss (Cave)
* Hard Stone (Rock)
* Soft Sand (Sand)
* Shed Shell (Forest)
* Silver Powder (Forest Grass)
* Snowball (Snow)
* Never-melt Ice (Ice)
* Charcoal (Volcano)
* Rare Bone (Graveyard)
* Pretty Feather (Sky)
* Stardust (Space)
* Comet Shard (Ultra Space)

</details>

<details>

<summary>Bonus Rewards</summary>

You may set additional rewards that appear in a specific Raid Den's loot table by setting the `:loot` key in the rule hash used in `pbRaidDen`. This can be set either to an item ID, or an array of item ID's and quantities for each item. You can use this to customize the rewards granted by a specific Raid Den.

For example:

```
:loot ⇒ :NUGGET
```

This will reward the player 1 Nugget for clearing the Raid Den. If you'd like to set a specific number of Nuggets, you can instead set this to something like this:

```
:loot ⇒ [:NUGGET, 5]
```

This would reward 5 Nuggets, instead. You can add as many additional item rewards as you'd like in this manner. Here's a more extreme example:

```
:loot => [:NUGGET, 5, :ENIGMABERRY, 8 :SACREDASH, 1, :ABILITYCAPSULE, 10] 
```

This would reward 5 Nuggets, 8 Enigma Berries, 1 Sacred Ash, and 10 Ability Capsules. Note that these additional rewards will always be granted on top of the base rewards that clearing the raid would normally grant.

If you include bonus rewards through this manner that would already be normally granted by the raid as a base reward, then the additional quantities you manually included here will just be added to the total quantity granted to the player.&#x20;

</details>

***

<mark style="background-color:orange;">**Resetting a Raid Den**</mark>

Once the Pokemon within a Raid Den has been captured or defeated, that den is considered "clear," and will now appear empty. If so, you will no longer be able to interact with that den to initiate a new raid battle until the den has been reset.

Raid Dens may be reset through various means, which I'll outline below.

<details>

<summary>Natural Reset</summary>

Raid Dens will naturally reset each day when the device's clock reaches midnight. If so, all Raid Dens on all maps will generate a new Pokemon to encounter. This includes empty dens as well as dens that have an existing Pokemon saved to them.

</details>

<details>

<summary>Manual Reset</summary>

In *Pokemon Sword & Shield*, you had the ability to manually reset a Max Raid Den by consuming a Wishing Piece from your inventory, and tossing it into the den to lure a new raid Pokemon to battle. This feature did not return for Tera Raid Dens in *Pokemon Scarlet & Violet*, but I chose to include this feature in this plugin and apply it to all Raid Den types.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fkbfc4UY61L9BZeO2zu0O%2Fraid%20bait.gif?alt=media&#x26;token=bf5b9891-edca-4a2d-ace5-9706dd8c0907" alt="" data-size="original">

Instead of Wishing Pieces, I introduced a more generic item called "Raid Bait" that may be tossed into any type of Raid Den to manually reset it and force a new raid Pokemon to appear. As long as you have at least 1 serving of Raid Bait in your inventory, you will be able to reset any den you wish.

Note that while playing in debug mode, you can manually reset any Raid Den by holding `CTRL` while interacting with a den. This will allow you to reset the den in the same way as show above, but without consuming any Raid Bait, or without even needing the item in your inventory.

</details>

<details>

<summary>Debug Reset</summary>

Finally, there is a third way of resetting Raid Dens while playing in debug mode. In the debug menu, navigate to "Deluxe plugin settings..." and then to "Other plugin settings..." and then "Raid settings...". When selected, you can choose to manually empty or reset all Raid Dens.&#x20;

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FZ2DkFJighJXcWoQLZFPp%2F%5B2024-12-01%5D%2008_48_50.555.png?alt=media&#x26;token=ed0aab5c-533a-4e4a-bd44-99ca52bad19b" alt="" data-size="original">

This will affect every single Raid Den event on every map in your game, so keep that in mind when using these options.

</details>

Page 74:

# Raid: Raid Adventures

Raid Adventures are a special game mode inspired by Dynamax Adventures, which were originally introduced in *Pokemon Sword & Shield*'s Crown Tundra DLC. In this mode, the player navigated a lair by selecting pathways to take where they would encounter multiple Raid Pokemon in consecutive Raid battles. However, the player was forced to use a rental party during these fights, but could replace party members with the Raid Pokemon they captured along the way. At the end of the lair, a legendary Pokemon awaited the player.

In this plugin, the Adventures mode has been greatly expanded and made into its own unique game mode that supports any Raid type, not just Dynamax. Each Adventure takes place on a map that is broken up into a grid of squares. Each square on the grid is referred to as a "tile", and there are a variety of different tile types. Whenever the player moves onto a new tile, the effects of that tile are triggered. The goal of a Raid Adventure is to reach the lair's boss Pokemon and capture or defeat them to clear the lair.

***

<mark style="background-color:orange;">**Adventure Styles**</mark>

Just like with Raid Dens, Raid Adventures can be challenged in a variety of different styles that highlight certain battle gimmicks. Below, I'll cover all of the Adventure styles that are supported by default.

<details>

<summary>Raid Adventure</summary>

These are the default basic style of Adventure. During these Adventures, you will encounter a series of Basic Raid battles with random wild Pokemon. The boss found within the lair will always be a random legendary Pokemon.

Any Pokemon with the `Legendary` flag in its PBS data who is also found in `RaidRanks` 6 is qualified to appear as the boss during a Raid Adventure.

The type of each Raid Pokemon found in the lair will be displayed under their silhouette. If the Pokemon has multiple types, then a random one is selected to be displayed. This can be used to help you determine which path to take based on what your current party matches up best with.

</details>

<details>

<summary>Ultra Adventure</summary>

These are a style of Adventure that is built around the Z-Move mechanic. During these Adventures, you will encounter a series of Ultra Raid battles with random wild Pokemon. The boss found within the lair will always be either Solgaleo, Lunala, Ultra Necrozma, or a random Ultra Beast species.

Any Pokemon with the `UltraBeast` flag in its PBS data who is also found in `RaidRanks` 6 is qualified to appear as the boss during a Raid Adventure. Note that any Pokemon encountered during an Ultra Adventure will be in its Ultra Burst form, if it has one (such as Necrozma).

Note that if the `FILTER_ADVENTURE_STYLES_BY_GENERATION` setting is set to `true`, only species and forms introduced in Generation 7 will naturally appear in the lair.

The held Z-Crystal of each Raid Pokemon found in the lair will be displayed under their silhouette. This can be used to help you determine which path to take based on what your current party matches up best with.

</details>

<details>

<summary>Dynamax Adventure</summary>

These are a style of Adventure that is built around the Dynamax mechanic. During these Adventures, you will encounter a series of Max Raid battles with random wild Pokemon. The boss found within the lair will always be a random legendary Pokemon.

Any Pokemon with the `Legendary` flag in its PBS data who is also found in `RaidRanks` 6 is qualified to appear as the boss during a Raid Adventure. Note that any Pokemon encountered during a Dynamax Adventure may also be found in its Gigantamax form, if it has one. Any species with an Eternamax form, however, will always be found in that form (such as Eternatus).

Note that if the `FILTER_ADVENTURE_STYLES_BY_GENERATION` setting is set to `true`, only species and forms introduced in Generation 8 will naturally appear in the lair.

The type of each Raid Pokemon found in the lair will be displayed under their silhouette. If the Pokemon has multiple types, then a random one is selected to be displayed. This can be used to help you determine which path to take based on what your current party matches up best with.

</details>

<details>

<summary>Terastal Adventure</summary>

These are a style of Adventure that is built around the Terastallization mechanic. During these Adventures, you will encounter a series of Tera Raid battles with random wild Pokemon. The boss found within the lair will always be either Terapagos, Ogerpon, or a random Paradox species.

Any Pokemon with the `Paradox` flag in its PBS data who is also found in `RaidRanks` 6 is qualified to appear as the boss during a Raid Adventure. Note that any Pokemon encountered during a Terastal Adventure will be in its Terastal form, if it has one (such as Terapagos/Ogerpon).

Note that if the `FILTER_ADVENTURE_STYLES_BY_GENERATION` setting is set to `true`, only species and forms introduced in Generation 9 will naturally appear in the lair.

The Tera type of each Raid Pokemon found in the lair will be displayed under their silhouette. This can be used to help you determine which path to take based on what your current party matches up best with.

</details>

***

<mark style="background-color:orange;">**Adventure Modes**</mark>

When attempting a Raid Adventure, there may be certain modes that you unlock as you play that can alter the way future Adventures play out. Below, I'll go over the various modes that can be unlocked or selected for your Adventures.

<details>

<summary>Normal Adventure</summary>

This is a standard Adventure that takes place on a map of your choosing. This is the only mode available to the player by default.

</details>

<details>

<summary>Saved Adventure Routes</summary>

If you ever make it to the boss of a lair but are ultimately unable to defeat them, you will be given the option to save the route to that particular boss Pokemon so that they may be challenged again in a future attempt.

If so, the next time you initiate an Adventure of the same style that you found that boss in, you will be given the option to play a special Adventure where you are guaranteed to encounter that Pokemon as a boss again, instead of having the boss randomized. This can be useful if you encountered a species you really want to capture, but just didn't have the right party or strategy the first time around.

You can only save up to three routes per Adventure style. If you want to save a new route while you already have three saved, you will be asked if you'd like to delete an old one to make room. If you successfully clear a saved route, that route will automatically be deleted from your saved routes.

Note that while you are guaranteed to encounter the same boss species again while playing through a saved route, the rest of the Pokemon encountered in the lair will still be randomized, and not the same ones found the first time around.

</details>

<details>

<summary>Endless Mode</summary>

After the player successfully clears a Normal Adventure for the first time, they will automatically unlock Endless Mode. Once Endless Mode is unlocked, the option to play in this mode will appear whenever you initiate an Adventure.

While playing in Endless Mode, the Adventure will not end after defeating the lair's boss. Instead, the map will reset, and entirely new Pokemon will be randomly generated to repopulate the lair. Each reset counts as a new "floor" of the lair, which will be kept track of in the top right corner of the screen.

Your Adventure doesn't end until you run out of hearts or manually quit the Adventure. Whenever you reach a new floor that you've never gotten to before, a new record will be set. This record can be viewed by you at any time, and will display the floor number, the number of battles you cleared, and the party you used to reach that floor with.

</details>

<details>

<summary>Darkness Mode</summary>

After the player successfully sets a new record in Endless Mode for the first time, they will automatically unlock Darkness Mode. Unlike Endless Mode, however, Darkness Mode is not selectable by the player. Instead, every Adventure the player initiates may randomly be in Darkness Mode.

While playing in Darkness Mode, there will be limited visibility while exploring the lair. Only a small circle of visible space surrounding the player will be displayed, while the rest of the lair will be covered in total darkness. This provides an extra challenge, since navigating the lair will be more difficult when you can't properly see which paths lead where, or what the next Raid Pokemon might be.

However, each time a Raid Pokemon is defeated, the radius of visible space will increase slightly. The more Raid Pokemon you defeat, the more you will be able to see what you're doing. This adds extra incentive to winning more battles while playing in this mode. Another way to increase your visibility is by collecting Flares, which may be lying around the map.

Note that it's possible for Endless and Darkness Modes to stack with each other, allowing you to play an Endless Adventure with the additional Darkness Mode handicap. While playing with both modes active, the player's visibility will reset to its lowest value each time a new floor is reached and the map resets. So each floor will remain just as challenging as the last.

</details>

Page 75:

# Raid: Adventure Maps

An Adventure Map is the map the player traverses on during a Raid Adventure. There can be multiple different maps that the player can explore, each with different backgrounds, layouts, and tiles. In this section, I'll cover everything related to Adventure Maps and the different tiles that may be found on them.

***

<mark style="background-color:orange;">**Adventure Maps**</mark>

Each Adventure Map is comprised of two things - a background image and PBS data. The data for an Adventure Map is defined and stored in the `AdventureMap` class in the `GameData` module. Below, I'll describe everything related to the structure and creation of Adventure Maps.

<details>

<summary>Map Background</summary>

The backgrounds used for Adventure Maps are all stored in the file `Graphics/Plugins/Raid Battles/Adventures/Maps`. By default, three background styles are provided.

Adventure Maps can technically be any size you want the background image to be, though the width and height of the image should always be a multiple of 32. I wouldn't recommend making a map that exceeds 1024x1024 pixels however, as anything larger than that may potentially start to break certain visuals on the map.

</details>

<details>

<summary>Map Properties</summary>

All of the data related to a map, such as its name and what tiles appear on it are saved to a PBS file named `adventure_maps.txt`. This is a unique PBS file added by this plugin, and contains with it the data for three demo maps included with this plugin. I'll briefly cover the properties an Adventure Map may have stored in this PBS file:<br>

* `ID`\
  This is simply a number that acts as the ID for this map. No two maps can share the same ID number.<br>
* `Name`\
  This is a string that acts as the display name for this map. A map's name is displayed when beginning an Adventure on that map, and may appear in other UI's or choice selections.<br>
* `Filename`\
  This is the filename of the background image this map should use. Refer to the "Map Background" section above for the location and specifications of map background images.<br>
* `Description`\
  This is a brief bit of flavor text describing the characteristics of this map. This isn't displayed anywhere by default, so what you enter here doesn't really matter. But, it's there in case you want to display this text somewhere.<br>
* `DarknessChance`\
  This determines the odds of this map randomly forcing the player to explore it in Darkness Mode. For example, entering `10` here will make it 10% likely that each time the player begins an Adventure on this map, it will be in Darkness Mode. If you want a map to *always* be played in Darkness Mode, set this to `100`. If you want a map to *never* randomly trigger Darkness Mode, set this to `0`.<br>
* `Dimensions`\
  This determines the width and height of the map, in tiles. Each tile is 32 pixels, so a map 10 tiles wide would translate to 360 pixels.<br>
* `PlayerStart`\
  This determines the tile coordinates that the player is standing on when beginning an Adventure on this map. This is entered as a string of four digits. The first two digits determine the player's coordinates on the X-axis, while the last two digits determine the player's coordinates on the Y-axis. So for example, an entry of `0826` would mean the player begins an Adventure on this map on tile that is 8 tiles to the right, and 26 tiles down, starting from the top-left corner of the map.<br>
* `Pathways`\
  This is an array of tile coordinates that designate where every Pathway tile on the map is placed. There is no limit to how many Pathway tiles can be entered here.<br>
* `Battles`\
  This is an array of tile coordinates that designate where every Battle tile on the map is placed. There must always be exactly 11 Battle tiles per map. The final coordinates entered in this array designates the coordinates of the Adventure's boss Battle tile.<br>
* `Tile`\
  This determines data for all other tiles on the map that aren't a Pathway or Battle tile. You can have as many Tile lines as you'd like. Each Tile line is an array that must contain the ID of the specific tile this should be, followed by the coordinates for this tile to occupy. \
  \
  You may also include `true` as an optional third entry in this array if you'd like this tile to be affected by Switch tiles (note that not every tile may be eligible for this). Otherwise, leave this blank.\
  \
  For Warp tiles specifically, a fourth entry must be entered that designates the coordinates of another Warp tile on this map that this tile will send the player to.

</details>

<details>

<summary>Creating or Editing a Map</summary>

If you'd like to create your own custom Adventure map, you may do so by opening the debug menu and locating the Adventure Map Editor. This can be found by navigating to "Deluxe plugin settings...", followed by "Raid settings..." and then select "Edit Adventure maps".

The Adventure Map editor is quite robust, and will allow you to select an ID, name, background, and other information for your map, as well as manually placing tiles down. Once you've completed your map, you must playtest it to ensure that it's clearable before it can be saved.

</details>

***

<mark style="background-color:orange;">**Adventure Map Tiles**</mark>

Adventure Maps are broken up into 32x32 pixel squares called "tiles". Each tile the player lands on has its own properties, and may trigger something when stepped on. These tiles can be broken up into several categories. Below, I'll outline each category of tile, and describe all of the tiles of those type.

<details>

<summary>Landmark Tiles</summary>

These are tiles that are integral to the functionality of an Adventure, and will likely always be present, regardless of map.<br>

* **Pathway**\
  These are plain while squares that designate a walkable path for the player to follow. The player can continue moving in any direction, as long as there is a pathway tile for them to continue on. If the player ever reaches a dead end pathway, they will immediately turn around and begin traveling in the opposite direction that they came from.<br>
* **Start Point**\
  This tile is a star icon which indicates the direction the player will begin moving in when the Adventure begins. Wherever this tile is on the map, the player's icon will pick the direction that brings it the closest to this icon, and begin traveling in that direction. Each map must have exactly one Start Point tile.<br>
* **Battle**\
  This tile is a Poke Ball icon which indicates that passing over this tile will initiate a raid battle with a Pokemon. During gameplay, the actual Pokemon found will be represented by a silhouette of the Pokemon found on this tile. Each map must have exactly 11 Battle tiles, with the first one being the weakest Pokemon found in the lair, and the eleventh being the boss Pokemon of the lair.<br>
* **Crossroad**\
  This tile is a blue circle with paths for each cardinal direction cut out, forming an intersection. Passing over this tile will halt the player's movement, and give the player the chance to select a new direction to move in. The directions the player is given to select from are determined by the walkable paths available to the player. During the selection process, the player also has the options to check their party, scan the map to plan out their route, or prematurely end their Adventure.

</details>

<details>

<summary>Directional Tiles</summary>

These are tiles that are directly related to altering the player's movement while navigating the map. <br>

* **Turn North**\
  These are up-pointing arrows that indicate that the player will automatically be forced to travel north when passed over, regardless of whatever direction they were moving in previously.<br>
* **Turn South**\
  These are down-pointing arrows that indicate that the player will automatically be forced to travel south when passed over, regardless of whatever direction they were moving in previously.<br>
* **Turn West**\
  These are left-pointing arrows that indicate that the player will automatically be forced to travel west when passed over, regardless of whatever direction they were moving in previously.<br>
* **Turn East**\
  These are right-pointing arrows that indicate that the player will automatically be forced to travel east when passed over, regardless of whatever direction they were moving in previously.<br>
* **Random Turn**\
  These are question marks with arrows pointed in each cardinal direction. These indicate that the player will automatically be forced to travel in a random direction when passed over, regardless of whatever direction they were moving in previously. Note that the dirction that the player was already moving in can never be one of the randomly chosen directions.<br>
* **Reverse Turn**\
  These are two arrows pointing back at each other, which indicate that the player will automatically be forced to travel in the opposite direction from the one they were just move in.

</details>

<details>

<summary>Object Tiles</summary>

These are tiles containing some kind of object or obstacle that the player must interact with when passed over.<br>

* **Door**\
  These are locked doors which prevent further movement on this path, unless the player has acquired a Key that can be used to unlock it. Unlocking a Door tile consumes one of the player's total Key count. If the player cannot unlock the door, they will be forced to turn around and return in the direction they came from. Once a Door is cleared however, it will be removed from the map and the player will be able to travel freely on that tile from then on.<br>
* **Switch**\
  These are levers that can be toggled ON or OFF whenever passed over by the player. By default, all Switch tiles are set to the OFF position. When set to the ON position, there may be hidden tiles on the map that are revealed. However, toggling a Switch back to the OFF position will make these revealed tiles hidden again.<br>
* **Warp**\
  These are warp points that will teleport the player to a linked warp point elsewhere on the map. Every warp point is linked to another warp point, so these can be used to fast travel to different locations.<br>
* **Portal**\
  These are a type of warp point that can only ever teleport the player back to the initial starting point of a lair. These essentially reset the player back to the very beginning of the Adventure, but without resetting any of the map progress.<br>
* **Teleporter**\
  These are another type of fast travel tile that allows the player to teleport back to a previously visited Crossroad tile. Unlike with Warp or Portal tiles, the player has full control in selecting where a Teleporter tile may send them. Note that if the player hasn't visited any Crossroad tiles yet, a Teleporter tile cannot be used.<br>
* **Roadblock**\
  These are tiles represented with a yellow caution logo, which indicate a hazardous route or obstacle in the player's path. There are many different varieties of roadblocks the player may encounter; such as a deep chasm that requires a Flying-type Pokemon to lift the player across, or a massive boulder that only a Pokemon with heightened Attack can move aside. The type of challenge presented by each Roadblock is randomized, but can be overcome if a Pokemon in the player's Adventure party meets certain needed requirements. If the player doesn't have any Pokemon that can overcome the Roadblock, the player will be forced to turn around and travel back in the direction they came from. Once a Roadblock is cleared however, it will be removed from the map and the player will be able to travel freely on that tile from then on.<br>
* **Hidden Trap**\
  These tiles a completely invisible to the player during normal gameplay, and will appear as if they are just normal Pathway tiles. While in debug mode, however, Hidden Traps will be visible, and be represented by opaque purple caution logos. When the player passes over a Hidden Trap, a random hazardous event may trigger that puts the player in harm's way. A random Pokemon in their Adventure party will spring forth to try and protect them, and may take damage or be inflicted with a status condition as a result. Sometimes you may luck out, however, and the Pokemon may be completely immune or avoid the effects of the trap. Once a Hidden Trap is cleared however, it will be removed from the map and the player will be able to travel freely on that tile from then on.

</details>

<details>

<summary>Collectable Tiles</summary>

These are tiles that contain some kind of content that the player can pick up and utilize to assist them during the Adventure. Once a collectable tile has been used or consumed, it will be removed from the map and the player will not be able to collect it again.<br>

* **Berries**\
  These tiles contain a pile of berries that, when passed over by the player, can be fed to the player's Adventure party to restore up to 50% of the max HP of each party member. If the player's party are all already at full HP, the player will not consume the berries on this tile.<br>
* **Flare**\
  These tiles contain a flare that, when passed over by the player, can be lit to increase visibility within a Dark Mode lair. Flare tiles are only available during Dark Mode Adventures, and will not appear on a map otherwise.<br>
* **Key**\
  These tiles contain a key that, when passed over by the player, will increase the player's total key count. Keys can be used to unlock Door and Chest tiles located elsewhere on the map.<br>
* **Chest**\
  When passed over by a player, the player may use a collected key to unlock the chest to reveal the contents hidden inside. Chests may contain a variety of items such as Exp. Candies and other useful items that will be rewarded to the player upon completing the Adventure. Unlocking a Chest requires the player have at least one Key, but it does not consume the key. If the player doesn't have any keys to unlock the chest, they will leave the chest behind and continue on their path.

</details>

<details>

<summary>Character Tiles</summary>

These are tiles occupied by an NPC that may offer you a variety of services during your Adventure. Most of these tiles may be revisited over and over to re-utilize these services if necessary.<br>

* **Assistant**\
  Assistants will help you by offering a new, randomized Rental Pokemon to add to your party in exchange for one of your existing Pokemon. This service can be useful when you need to change up your party before facing the next battle. The Rental Pokemon offered by Assistants are often of higher quality than those offered to you at the start of the Adventure.<br>
* **Item Vendor**\
  Item Vendors have a stock of items to share with you and equip to your Adventure party. These items can power up your party to make the battles you encounter a little easier, or to help in keeping your party healthy. The pool of items offered by Item Vendors will often be catered to the kind of Pokemon you have in your party. Note that Item Vendors may not appear in Ultra Raids specifically, due to all Pokemon in an Ultra Adventure already holding Z-Crystals.<br>
* **Stat Trainer**\
  Stat Trainers offer EV-training services that allows you to alter the EV spreads of the Pokemon in your Adventure party. This can help you fine-tune your Pokemon to suit your strategy and optimize them for the battles ahead.<br>
* **Move Tutor**\
  Move Tutors offer you move learning services that allows you to adjust the movesets of the Pokemon in your Adventure party. The tutor will offer 3 random moves that may be learned by each Pokemon in the party, and you can select one out of those three moves to teach.<br>
* **Nurse**\
  Nurses will offer to fully heal the HP/PP and status condition of all Pokemon in your Adventure party. Unlike most Character tiles, Nurses will leave the map once encountered, and may not be interacted with again.<br>
* **Mystic**\
  Mystics will offer to fully heal the player's heart counter, which will allow you to survive in the lair for longer. If the player's heart counter is already full, the Mystic will remain on the map while the player continues onwards. If the Mystic's services are utilized, however, they will leave the map and may not be interacted with again.<br>
* **Mystery NPC**\
  Mystery NPC's, when encountered, will randomly offer the services of either an Assistant, Item Vendor, Stat Trainer, Move Tutor, Nurse, or Mystic. Regardless of which service is provided, the Mystery NPC will leave the map afterwards, and may not be interacted with again.<br>
* **Researcher**\
  Researchers may only be found during Ultra, Dynamax, or Terastal Adventures. If so, they will offer you a service specific to the type of Adventure you're in. In Ultra Adventures, Researchers will offer you new Z-Crystals to attach to your party. In Dynamax Adventures, Researchers will randomly boost the Dynamax Levels of your party by 2-4 levels. In Terastal Adventures, Researchers will offer to change the Tera types of the party.<br>
* **Partner**\
  A Partner trainer are fellow Pokemon trainers who offer to accompany you in battle during the Adventure. When a Partner trainer is with you, this will make all raid battles be fought in a 2v1 format, rather than a 3v1. The difficulty of the raid battles will be scaled down slightly to accommodate the smaller battle size, and the player's total heart counter will increase to accommodate for the AI's Pokemon. \
  \
  Having a Partner with you may help reduce the overall difficulty of the raid in some circumstances; especially if the player has an underwhelming party for the Adventure. The player may only have one Partner with them at a time. If another Partner is encountered, the player will be asked to choose which Partner they'd like to accompany them. \
  \
  By default, there are two varieties of Partner trainers available - Brendan (`:PartnerA`) and May (`:PartnerB`).

</details>

Page 76:

# Raid: Adventure Call

<mark style="background-color:orange;">**Accessing a Raid Adventure**</mark>

To begin a Raid Adventure, you must simply run the script `RaidAdventure.start` in an event. This will begin an NPC dialogue event where they will ask you if you would like to participate in an Adventure, and allow you to choose various settings before entering.

Although just using `RaidAdventure.start` is enough to set up an Adventure, you can modify this script if you'd like by adding a hash as an argument which may contain any of the following:

<table><thead><tr><th width="153">Key</th><th width="165">Value</th><th>Description</th></tr></thead><tbody><tr><td><code>:mapID</code></td><td>Adventure Map ID</td><td>Sets the specific Adventure Map for this Adventure. Loads the default Adventure Map (0) if not set.</td></tr><tr><td><code>:style</code></td><td>Raid Type ID</td><td>Sets the specific style of Adventure. This can be set to <code>:Ultra</code>, <code>:Max</code>, or <code>:Tera</code>. Defaults to <code>:Basic</code> if not set.</td></tr><tr><td><code>:gender</code></td><td>Integer (0-2)</td><td>Sets gendered text color for the Adventure setup dialogue. Set to <code>0</code> for blue text (male), or <code>1</code> for red text (female). Sets the default text color if not set.</td></tr><tr><td><code>:boss</code></td><td>Species ID</td><td>Sets a species ID to force a specific species to appear as the end boss for this Adventure. Random by default.</td></tr><tr><td><code>:party</code></td><td>Array</td><td>Set an array containing a series of Pokemon objects or species ID's to use as your rental party during this Adventure. If set, the Rental selection menu will be skipped.</td></tr><tr><td><code>:endless</code></td><td>Boolean</td><td>Forces the Adventure to be played in Endless Mode when set to true, regardless if the mode has been unlocked yet. False by default.</td></tr><tr><td><code>:darkness</code></td><td>Boolean</td><td>Forces the Adventure to be played in Darkness Mode when set to true, regardless if the mode has been unlocked yet. False by default.</td></tr></tbody></table>

By using these keys, you can tweak a specific Adventure event to operate in some unique ways. For example:

```
RaidAdventure.start({
  :style  => :Tera,
  :gender => 1,
  :boss   => :OGERPON
})
```

This will set up a Terastal Adventure where Ogerpon is guaranteed to appear as the final end boss of the Adventure. The NPC dialogue for this particular event will use red text, indicating that the speaker is female.

***

<mark style="background-color:orange;">**Alternate Adventure Call**</mark>

If you'd like to get into an Adventure immediately, without any NPC dialogue, you may do so by using `RaidAdventure.start_core`, instead. This script functions identically to `RaidAdventure.start` except that it skips all of the NPC speech and dialogue trees.

The same exact arguments can be entered in a hash as shown in the table above. The only difference is that the :gender key no longer does anything here, since there isn't any NPC dialogue to display.

Page 77:

# Raid: Battle Mechanics

As of the time of this plugin's release, raid battles have appeared in the main series in two distinct forms: Max Raids and Tera Raids; both of which feature slightly different rules and mechanics. For the purposes of this plugin, certain elements of both raid styles have been blended together to create the core of how raid battles operate.

This means that the mechanics of raid battles featured in this plugin won't accurately emulate how any particular style of raid battles functions 100%. Instead, a sort of hybrid type of raid is implemented that takes the most sensible elements of both raid types. For example, the Tera Raids featured in *Pokemon Scarlet & Violet* don't follow the traditional turn based battle system and the raid timer utilizes actual in-game time rather than being based on a turn counter. This wouldn't be practical to reproduce in Essentials, so elements of Max Raid battles are used here instead. However, for other elements, things may resemble Tera Raids more than how they functioned in Max Raids.

Essentially, I borrowed elements of each raid style based on whichever one made more practical sense, or whichever seemed to make for a more fun experience overall. In this section, I'll go over the overall structure of raid battles featured in this plugin.

***

<details>

<summary>Raid Battle Rules</summary>

Raid Battles operate under very specific rules, so many of the existing battle rules are utilized to emulate a raid battle experience. The following rules will *always* be enabled during a raid battle, and cannot be altered even if you input a contradicting battle rule to disable them:

* <mark style="background-color:green;">"canLose"</mark>
* <mark style="background-color:green;">"cannotRun"</mark>
* <mark style="background-color:green;">"noExp"</mark>
* <mark style="background-color:green;">"noMoney"</mark>
* <mark style="background-color:green;">"disablePokeBalls"</mark>
* <mark style="background-color:green;">"1v1"</mark> or <mark style="background-color:green;">"2v1"</mark> or <mark style="background-color:green;">"3v1"</mark>, etc. (depends on the raid)
* <mark style="background-color:green;">"raidStyleCapture"</mark>
* <mark style="background-color:green;">"tempParty"</mark> (Raid Dens only)
* <mark style="background-color:green;">"cheerMode"</mark>
* <mark style="background-color:green;">"noZMoves"</mark>
* <mark style="background-color:green;">"noDynamax"</mark>
* <mark style="background-color:green;">"noTerastallize"</mark>
* <mark style="background-color:green;">"noSOSBattle"</mark>

In addition, the following battle rules will always be *disabled* during a raid battle, even if you input a contradicting battle rule to enable them:

* <mark style="background-color:green;">"lowHealthBGM"</mark> (unless <mark style="background-color:green;">"battleBGM"</mark> is set)
* <mark style="background-color:green;">"alwaysCapture"</mark>
* <mark style="background-color:green;">"neverCapture"</mark>
* <mark style="background-color:green;">"wildMegaEvolution"</mark>
* <mark style="background-color:green;">"wildZMoves"</mark>
* <mark style="background-color:green;">"wildUltraBurst"</mark>
* <mark style="background-color:green;">"wildDynamax"</mark>
* <mark style="background-color:green;">"wildTerastallize"</mark>
* <mark style="background-color:green;">"totemBattle"</mark>

Lastly, the following battle rules will be set by the raid by default, but they *can* be overwritten with your own rules if you'd like to alter them:

* <mark style="background-color:green;">"backdrop"</mark>
* <mark style="background-color:green;">"base"</mark>
* <mark style="background-color:green;">"environment"</mark>
* <mark style="background-color:green;">"battleIntroText"</mark>
* <mark style="background-color:green;">"setSlideSprite"</mark>
* <mark style="background-color:green;">"databoxStyle"</mark>
* <mark style="background-color:green;">"battleBGM"</mark>

Any other battle rule not listed in this section should function like normal.

</details>

<details>

<summary>Raid Pokemon Attributes</summary>

Pokemon that are encountered in raids will have very different base attributes compared to other wild Pokemon you would normally encounter. Below are some of the attributes you can expect to generate differently for raid battles.

* <mark style="background-color:yellow;">**Boosted HP**</mark>\
  Raid Pokemon will always have boosted HP totals that exceed the normal ranges. How large this boost is scales based on the difficulty of the raid, and may fluctuate depending on the type as raid as well. For more details on boosted HP, refer to the "Wild Boss Attributes" section of this guide.\ <br>
* <mark style="background-color:yellow;">**Immunities**</mark>\
  Raid Pokemon will always have the following wild boss immunities applied:\
  `:FLINCH`, `:PPLOSS`, `:ITEMREMOVAL`, `:OHKO`, `:SELFKO`, `:ESCAPE`\
  For more details on boss immunities, refer to the "Wild Boss Attributes" section of this guide.\ <br>
* <mark style="background-color:yellow;">**IV's**</mark>\
  Raid Pokemon will always have at least one perfect IV when encountered. The number of perfect IV's a raid Pokemon will have scales based on the difficulty of the raid. For example, a raid with only 1-2 stars will only generate a Pokemon with one perfect IV, while a 7-star raid will generate a Pokemon with flawless IV's in every stat. The more stars a raid has, the more perfect IV's the raid Pokemon will have.\ <br>
* <mark style="background-color:yellow;">**Hidden Abilities**</mark>\
  Raid Pokemon will sometimes generate with their Hidden Abilities when encountered, depending on the difficulty of the raid. Only Pokemon encountered in 3-star raids or higher have a chance of generating with their Hidden Ability. The more stars a raid has, the more likely it is that the raid Pokemon will have their Hidden Ability.\ <br>
* <mark style="background-color:yellow;">**Moves**</mark>\
  Raid Pokemon will generate with randomized move sets that will generate based on the type of raid they appear in. Typically, a raid Pokemon will always generate with at least one or two reliable STAB moves, one non-STAB move for coverage, and a status move that provides some kind of utility. The type of raid battle can drastically alter these move sets, however. For example, the moves generated for a Tera Raid will be geared towards utilizing the raid Pokemon's Tera Type, while an Ultra Raid will be geared towards utilizing the raid Pokemon's held Z-Crystal.\ <br>
* <mark style="background-color:yellow;">**Form**</mark>\
  Depending on the species and the raid type, the raid Pokemon may be forced into a certain form during the raid battle. For example, Necrozma will always appear in Ultra Burst form when encountered in an Ultra Raid, and species that have special Terastal forms such as Ogerpon and Terapagos will always appear in those forms when encountered in a Tera Raid.\ <br>
* <mark style="background-color:yellow;">**Held Item**</mark>\
  In Ultra Raid battles specifically, the raid Pokemon will always generate holding a random Z-Crystal. The specific Z-Crystal held will always be one that is compatible with at least one of their damaging moves. If the raid Pokemon is a species that has access to an exclusive Z-Move, they will always generate holding that particular Z-Crystal. If the raid Pokemon has an Ultra Burst form, such as Necrozma, then they will instead always be holding the item that allows them to enter Ultra Burst form.\ <br>
* <mark style="background-color:yellow;">**Tera Type**</mark>\
  In Tera Raid battles specifically, the raid Pokemon will generate with a completely random Tera Type in 3-star raids or higher, if able. In lower raid ranks, their Tera Type will generate normally.

Note that you can still use the  <mark style="background-color:green;">"editWildPokemon"</mark> rule to override all of the attributes listed above that the raid Pokemon would normally generate with. However, in the case of boss immunities, the immunities listed above will *always* be granted to the raid Pokemon. You can grant them *additional* immunities if you'd like, but the ones listed above will always be present.

***

<mark style="background-color:orange;">**Captured Raid Pokemon**</mark>

After capturing a wild Pokemon, you are usually prompted to give it a nickname and, depending on your settings, can even decide whether to add it to your party or to your PC. When capturing a raid Pokemon however, these prompts are entirely skipped. A captured raid Pokemon will simply be sent to your PC immediately upon capture.

In addition, many attributes of the captured raid Pokemon may differ from the attributes it had during battle. Here are some attributes that may be changed upon capture:

* <mark style="background-color:yellow;">**Level**</mark>\
  The highest level a raid Pokemon can possibly be upon capture is Lv. 75. However, it's possible for a raid Pokemon to exceed this level during the actual battle. In these cases, the raid Pokemon's level will be scaled down to Lv. 75 after capturing it.\ <br>
* <mark style="background-color:yellow;">**HP**</mark>\
  Raid Pokemon have greatly expanded HP pools during battle. Upon capture however, these totals are scaled back down to their normal values.\ <br>
* <mark style="background-color:yellow;">**Moves**</mark>\
  Raid Pokemon generate with randomized move sets that are geared towards making them a challenging encounter during battle. However, once they are captured, its move set will revert to whatever moves it would normally have at its current level.\ <br>
* <mark style="background-color:yellow;">**Form**</mark>\
  Depending on the species and the raid type, the raid Pokemon may be forced into a certain form during the raid battle. For example, Necrozma will always appear in Ultra Burst form during an Ultra Raid. After capture however, it will be forced to revert to its base form.\ <br>
* <mark style="background-color:yellow;">**Held Item**</mark>\
  In Ultra Raid battles specifically, the raid Pokemon will always be holding a Z-Crystal in order for it to use Z-Moves during the battle. After capture however, any held Z-Crystals will be removed.\ <br>
* <mark style="background-color:yellow;">**Dynamax Level**</mark>\
  In Max Raid battles specifically, the raid Pokemon will always have a maxed out Dynamax Level for the purposes of simpler HP calculations during the raid battle. After capture however, the captured Pokemon's Dynamax Level will be scaled down to an appropriate level based on the difficulty of the raid.

</details>

<details>

<summary>Battle Visuals</summary>

Raid battles utilize unique visuals that set them apart from your typical wild battle. Below I'll describe the different visual changes implemented by raid battles.

***

<mark style="background-color:orange;">**Databox Style**</mark>

By default, raid battles will automatically enable the `:Long` databox style, which will change how battler's databoxes will appear in battle. This style gives the raid Pokemon a long HP bar that stretches across the top of the screen, making them feel more like genuine boss fights.

Note that you can still implement a different databox style if you wish by using the <mark style="background-color:green;">"databoxStyle"</mark> battle rule, but you cannot disable databox styles for raid battles altogether. For more information about databox styles, refer to the Battle Visuals subsection within the "Deluxe Battle Rules" section of this guide.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FJhNFH3Zj3vUSd2zmtptF%2F%5B2024-11-30%5D%2007_23_56.602.png?alt=media&#x26;token=1683d9a1-0d92-40e8-8b01-de44f4dbca17" alt="" data-size="original">

Something to take note of is that when databox styles are enabled in a raid battle, any Z-Crystals held by battlers will have their icons displayed next to that battler's HP bar. This is particularly useful in Ultra Raid battles, as it will remind you what sort of Z-Moves the raid Pokemon will be using, as well as reminding you what Z-Moves each of your own Pokemon may have access to without having to recheck the Summary screen.

***

<mark style="background-color:orange;">**Background and Bases**</mark>

By default, raid battles will utilize the specific background and base graphics defined in that specific raid type's data. Refer to the "Raid: Properties" subsection for more information in where and how this is defined. Each raid type has different graphics defined in its data.

Here's the graphics used for each style:

* **Basic Raids**\
  Implements the `"cave3"` background and bases found in vanilla Essentials.\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FfBZ7Je1dV6UjmyXSR9xy%2F%5B2024-11-27%5D%2017_45_38.873.png?alt=media\&token=3aad66ff-4231-4291-81b1-68f9346b98e9)<br>
* **Ultra Raids**\
  Implements the `"raid_ultra"` background and bases added by this plugin.\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FZhqjQe6L8IyVsamU3yru%2F%5B2024-11-27%5D%2017_46_46.896.png?alt=media\&token=d81c4b94-132b-4cf0-a4d0-4a6c53c2b0ff)<br>
* **Max Raids**\
  Implements the `"raid_max"` background and bases added by this plugin.\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F5KDmQaFqvpLlgLeTd10R%2F%5B2024-11-27%5D%2017_47_32.903.png?alt=media\&token=01d7324a-8397-4335-a931-0484fdadc848)<br>
* **Tera Raids**\
  Implements the `"raid_tera"` background and bases added by this plugin.\
  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FKytS7wRK6RsUlHN4jwCW%2F%5B2024-11-27%5D%2017_48_14.809.png?alt=media\&token=8f26282c-0205-44cb-972b-ced5cb94f710)

Note that these graphics are just what are used as the default for each raid type, so they can still be manually overwritten for specific raid battles through the use of the <mark style="background-color:green;">"backdrop"</mark> and <mark style="background-color:green;">"base"</mark> battle rules.

Also note that if you set a custom environment for a raid battle with the <mark style="background-color:green;">"environment"</mark> battle rule, the graphics used for the battle will also automatically change to use graphics that reflect that environment type. For example, setting the environment to `:Snow` will implement the snow background and snow bases. By default, all raid battles are assumed to take place in the `:Cave` environment except for Ultra Raids, which take place in the `:UltraSpace` environment instead.

</details>

<details>

<summary>General Mechanics</summary>

Certain elements of a raid battle will differ from how you would expect them to work during a normal battle.

***

<mark style="background-color:orange;">**Battle Size**</mark>

By default, all raid battles are assumed to be fought as a 3v1 battle, with the player sending out three Pokemon against the one raid Pokemon. This is manually set in the plugin Settings file with `RAID_BASE_PARTY_SIZE`, which is set to 3 by default. You can change this value if you'd like to set the default party size on the player's side or 2 or 1 instead.

Note however that regardless of what `RAID_BASE_PARTY_SIZE` is set to, raid battles might automatically adjust the battle size if necessary. For example, if the battle size is set to 3, but the player has fewer than three able Pokemon that can participate, the battle size will automatically shrink down to suit the player's party.

Also note that if the player has a partner trainer manually set to accompany them in this raid battle with the `:partner` setting, the battle size will automatically adjust to a 2v1 format, with both the player and partner sending out a single Pokemon each.

Finally, it is possible to manually set the battle size for a raid by setting `:size` to your desired value in the rule hash when setting up a raid event.

***

<mark style="background-color:orange;">**Fainted Battlers**</mark>

Typically, when a Pokemon faints in battle, it remains fainted unless an effect of an item or move is used to revive them. However, this works differently in raid battles.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FleMsDsIQSdLQBSfompuD%2F%5B2024-11-27%5D%2020_17_11.851.png?alt=media&#x26;token=c349b1be-563b-4b51-b87f-5c1fb6b114c1" alt="" data-size="original">

When a trainer's Pokemon faints in a raid battle, it will spend one turn off of the field. On the following turn, it will be fully revived and be ready to send out once again. This is because trainers participate in raid battles with a limited party, so fainting is treated more like a temporary set back than a permanent loss.

Note however, that you will still lose the raid if every battler on your side of the field are all fainted simultaneously with no other healthy Pokemon in reserve to send out.

***

<mark style="background-color:orange;">**Battle Gimmicks**</mark>

When you enter a normal battle with an eligible battle gimmick available, such as Z-Moves, Dynamax, or Terastallization, you are typically able to use those gimmicks immediately whenever you choose. However, this may work differently during a raid battle.

Depending on the type of raid battle you're in, these mechanics may require charging through the use of cheers before they may be used, or may be disabled from use entirely. Below, I'll go over each type of battle gimmick, and when and where they are available to be used.

* <mark style="background-color:yellow;">**Mega Evolution**</mark>\
  Disabled in all raid battles except Basic Raids. Usable immediately, if available.\ <br>
* <mark style="background-color:yellow;">**Ultra Burst**</mark>\
  Disabled in all raid battles except Ultra Raids. Usable immediately, if available.\ <br>
* <mark style="background-color:yellow;">**Z-Moves**</mark>\
  Disabled in all raid battles except Ultra Raids. However, Z-Moves will not be available for a trainer until the <mark style="background-color:red;">"Let's use Z-Power!"</mark> cheer is used to charge the trainer's Z-Ring. This can be done multiple times per battle.\ <br>
* <mark style="background-color:yellow;">**Dynamax**</mark>\
  Disabled in all raid battles except Max Raids. However, Dynamax will not be available for a trainer until the <mark style="background-color:red;">"Let's Dynamax!"</mark> cheer is used to charge the trainer's Dynamax Band. This can be done multiple times per battle.\ <br>
* <mark style="background-color:yellow;">**Terastallization**</mark>\
  Disabled in all raid battles except Tera Raids. However, Terastallization will not be available for a trainer until the <mark style="background-color:red;">"Let's Terastallize!"</mark> cheer is used to charge the trainer's Tera Orb. This can be done multiple times per battle.

***

<mark style="background-color:orange;">**Cheering**</mark>

While in a raid battle, a new menu command called "Cheer" will replace the usual "Run" command. Cheers can be used to afford your party a variety of buffs during a raid battle, heal your battlers, recharge certain battle gimmicks, and more.

Cheers can be instrumental to your success in a raid, allowing you to make impossible comebacks or allow you to swiftly clear a raid with efficiency. Never forget to consider this tool during a raid battle.

The cheer mechanic is quite in depth, and thus it's deserving of its own section to fully explain. Please refer to the "Cheer Mechanics" subsection of this guide for a full breakdown of cheers.

</details>

<details>

<summary>Partner Trainers</summary>

When entering a raid battle, any partner trainer the player has following them will not participate in the battle. However, the player can still have a partner participate in the raid battle along side them if `:partner` is set to a particular trainer in the rule hash of the raid event.

After the raid battle is concluded, any partner trainer that aided in battle will be removed, and the player's original partner trainer will be restored, if any.

When setting a partner trainer for a raid, the `:partner` setting should be set to an array that contains the following:

* A trainer type ID.
* The name of a particular trainer.
* The version number of this trainer (optional; 0 by default).
* An optional setting of `true` if you wish for this trainer to participate exactly as they appear in their PBS data (optional; `false` by default).

<mark style="background-color:red;">**Please note that, as always, partner trainers MUST have a proper back sprite located in**</mark> <mark style="background-color:red;"></mark><mark style="background-color:red;">`Graphics/Trainers`</mark><mark style="background-color:red;">**. If they do not have a back sprite, the game will immediately crash at the start of battle. This is how Essentials works generally, this isn't a plugin issue!**</mark>

***

<mark style="background-color:orange;">**Partner Attributes**</mark>

When a partner trainer participates in a raid battle along side you, they may not appear exactly as they are set up in your PBS file. Partner trainers will automatically scale their party and inventories to match the specific raid battle that they are participating in. This includes the items they have, the size of their party, as well as the attributes of their particular Pokemon.

Below, I'll go over in detail all of the attributes of a trainer that may be changed when participating in a raid battle as your partner. Note that if you do not wish for a partner trainer's attributes to be changed, you can simply set `true` as a fourth element in the `:partner` array setting, as described above.

***

<mark style="background-color:orange;">**Partner Inventory**</mark>

When a partner trainer participates in a raid battle, they will not have any items in their inventory that have been set in their PBS data. Instead, they will be given a new inventory based on the particular type of raid battle they are participating in:

* <mark style="background-color:yellow;">**Basic Raid**</mark>\
  The partner is given no items.\ <br>
* <mark style="background-color:yellow;">**Ultra Raid**</mark>\
  The partner is given a Z-Ring.\ <br>
* <mark style="background-color:yellow;">**Max Raid**</mark>\
  The partner is given a Dynamax Band.\ <br>
* <mark style="background-color:yellow;">**Tera Raid**</mark>\
  The partner is given a Tera Orb.

***

<mark style="background-color:orange;">**Partner Party**</mark>

When a partner participates in a raid battle, they will only bring a single Pokemon with them to the battle. This will always be whatever Pokemon appears last in their lineup as defined in their PBS data, as this is always assumed to be their ace.

The properties of this Pokemon that they bring to the raid battle may also be altered based on the criteria of the raid battle they're participating in.

* <mark style="background-color:yellow;">**Level**</mark>\
  The level of their Pokemon will automatically scale to match the difficulty of the raid they are participating in.\ <br>
* <mark style="background-color:yellow;">**Moves**</mark>\
  The moves of their Pokemon will be automatically adjusted to make them competitive in a raid environment, and to make use of special gimmicks of the raid, such as Z-Moves and Tera Types.\ <br>
* <mark style="background-color:yellow;">**Held Item**</mark>\
  The held item of their Pokemon may be adjusted based on the type of raid they are participating in. For example, if participating in an Ultra Raid, the trainer's Pokemon will be automatically given a Z-Crystal to use that is compatible with their move set. In all raid types, Mega Stones will be removed if the Pokemon is holding one.

</details>

<details>

<summary>Altered Move Mechanics</summary>

While in a raid battle, certain moves may no longer work as they normally would. Below, I'll list all moves with function codes that will behave differently during raid battles.

* Move functions that will always fail when used by *any* battler during a raid battle:
  * Perish Song
  * Sky Drop\ <br>
* Move functions that will always fail when targeting a raid Pokemon:
  * Super Fang/Nature's Madness
  * Spite
  * Roar/Whirlwind
  * Horn Drill/Guillotine
  * Fissure
  * Sheer Cold\ <br>
* Move functions that will always fail when used by the raid Pokemon itself:
  * Destiny Bond
  * Substitute
  * Self-Destruct/Explosion/Misty Explosion
  * Final Gambit
  * Memento
  * Healing Wish
  * Lunar Dance
  * Teleport\ <br>
* Move functions that will not trigger their effects when used on the raid Pokemon:
  * All moves that may cause flinching
  * Pluck/Bug Bite
  * Incinerate
  * Knock Off
  * Thief/Covet
  * Dragon Tail/Circle Throw
  * Eerie Spell
  * Grudge

***

<mark style="background-color:orange;">**Special Move Behaviors**</mark>

In addition to the above changes, two additional categories of moves are reworked to behave differently in specific ways when used by a raid Pokemon.

* **Belch**\
  Raid Pokemon ignore the berry consumption requirement in order to use this move.\ <br>
* **Semi-Invulnerable moves** (Fly, Dig, Dive, etc.)\
  Two-turn attacks that put the user in a semi-invulnerable state will skip their charging turn when used by a raid Pokemon. All other two-turn attacks that do not have a semi-invulnerable turn (Solar Beam, Sky Attack, etc.) will function like normal.

</details>

<details>

<summary>Raid Turn/KO Counters</summary>

When participating in a raid battle, there may be up to two different counters displayed near the raid Pokemon's databox. Each of these counters track specific things in the raid, and will count down to zero. If either of these counters reach zero before defeating the raid Pokemon, you will fail the raid and be prematurely ejected from the battle.

***

<mark style="background-color:orange;">**Turn Counter**</mark>

This tracks the number of turns spent in the raid. At the start of a raid battle, this counter starts at a specific number, which is usually scaled based on the difficulty of the raid, among other factors. With each passing turn, this counter is reduced by 1. The goal is to try and defeat the raid Pokemon as quickly as possible, before the counter reaches zero and you are kicked from the raid.

The raid's Turn Counter may effect other mechanics as well, such as when the raid Pokemon will trigger certain moves or actions. It isn't usually possible to increase the raid's turn counter, though there are some conditions that may make this possible, such as using certain cheers.

The base number of turns used for raid battles is defined in the plugin Settings file with `RAID_BASE_TURN_LIMIT`, so you may edit this if you wish to change the base number of turns for all raids. Note however, that this is just the *base* value, so raids will still naturally scale this base number based on raid difficulty and other factors.&#x20;

It is possible to manually set the turn counter for a raid, however, by setting `:turn_count` to your desired value in the rule hash when setting up a raid event. If you set `:turn_count => nil`, then the turn counter will be disabled and not appear at all.

***

<mark style="background-color:orange;">**KO Counter**</mark>

This tracks the number of times an ally Pokemon is KO'd during a raid. At the start of a raid battle, this counter starts at a specific number, which is usually scaled based on the number of ally Pokemon participating in the raid, among other factors. Each time an ally Pokemon is KO'd, this counter is reduced by 1. The goal is to try and defeat the raid Pokemon before they can KO too many of your Pokemon and you are kicked from the raid.

It usually isn't possible to increase the raid's KO counter, though there are some conditions that may make this possible, such as using certain cheers.

The base number of KO's used for raid battles is defined in the plugin Settings file with `RAID_BASE_KNOCK_OUTS`, so you may edit this if you wish to change the base number of KO's for all raids. Note however, that this is just the *base* value, so raids will still naturally scale this base number based on raid difficulty and other factors.&#x20;

It is possible to manually set the KO counter for a raid, however, by setting `:ko_count` to your desired value in the rule hash when setting up a raid event. If you set `:ko_count => nil`, then the KO counter will be disabled and not appear at all.

</details>

<details>

<summary>Raid Shields</summary>

Whenever a raid Pokemon takes damage from a direct attack that would lower their HP to 50% of their max HP or less, their HP will hit a threshold that will then trigger a raid shield to appear and cure the raid Pokemon of any status conditions.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FfzB1t8f5SrlUWZl9OzVT%2Fshield.gif?alt=media&#x26;token=7b7a7f3f-ec65-45f2-af35-31ab6856e6cd" alt="" data-size="original">

While behind a raid shield, the raid Pokemon becomes immune to all status moves and will drastically reduce the damage it takes from all direct attacks. Defeating a raid Pokemon while it is in this state will become nearly impossible. The only way to overcome this is to deplete their raid shield's HP in order to break it and make the raid Pokemon vulnerable again.

***

<mark style="background-color:orange;">**Raid Shield HP**</mark>

A raid shield's HP is indicated by the number of pink bars that appear under the raid Pokemon's normal HP bar. Each pink bar is considered 1 shield HP. The amount of shield HP a raid Pokemon may have scales based on the difficulty of the raid, up to a maximum of 8 HP.

Note that it is possible to manually set the amount of shield HP a raid Pokemon will have by setting `:shield_hp` to your desired value in the rule hash when setting up a raid event. If you set `:shield_hp => nil`, then the raid Pokemon will be disabled from summoning a raid shield at all.

***

<mark style="background-color:orange;">**Breaking Raid Shields**</mark>

In order to break a raid Pokemon's shield, you must reduce their shield HP to zero. This is done by attacking the raid Pokemon with damaging moves. However, the amount of shield HP damage the raid Pokemon takes from certain attacks differs based on the type of raid battle you're in.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FaDfbrsvSvXGhfjzmWmHI%2Fshield%20break.gif?alt=media&#x26;token=50cd0027-ced5-4855-a427-4bd89254c09f" alt="" data-size="original">

Note that only the final hit of multi-hit moves will count when dealing damage to a raid shield. If playing in debug mode, you can hold down `CTRL` when damaging a raid shield to fully deplete the raid Pokemon's shield HP in a single hit.&#x20;

* <mark style="background-color:yellow;">**Basic Raid**</mark>\
  Any damaging move will remove 1 bar of shield HP.\ <br>
* <mark style="background-color:yellow;">**Ultra Raid**</mark>\
  Any damaging move will remove 1 bar of shield HP. However, any Z-Moves will instead remove 3 bars of shield HP. If the attacker happens to be in Ultra Burst form, they will remove 1 additional bar of shield HP with regular attacks.\ <br>
* <mark style="background-color:yellow;">**Max Raid**</mark>\
  Any damaging move will remove 1 bar of shield HP. However, any Max Moves or G-Max Moves will instead remove 2 bars of shield HP.\ <br>
* <mark style="background-color:yellow;">**Tera Raid**</mark>\
  Any damaging move used by a Terastallized battler will remove 1 bar of shield HP. If the Terastallized battler uses a move that is boosted by their Tera Type, they will remove 1 additional bar of shield HP. If the type of the used move also matches one of the Terastallized battler's original types, it will remove 1 more additional bar of shield HP. These effects can all stack to remove 3 bars of shield HP per hit.\
  \
  However, non-Terastallized battlers will only be able to remove 1 bar of shield HP at a time, and only with moves that are super effective on the raid Pokemon. All other moves will deal no damage to the raid Pokemon's shield HP.

Note that you can boost the amount of shield damage you deal with all attacks by an additional 1 bar of shield HP by using the Lvl. 3 <mark style="background-color:red;">"Go all-out!"</mark> cheer during a raid battle. This bonus will only last for three turns, however, so timing this just right is necessary.

Once enough damage is dealt to reduce a raid Pokemon's shield HP to zero, the shield will be broken, and the raid Pokemon will lose all of its benefits. When a raid shield breaks, the raid Pokemon will lose a portion of its HP, and its Defense and Special Defense stats will be reduced by 2 stages. Take advantage of this vulnerable state by pelting them with your strongest moves.

</details>

<details>

<summary>Extra Actions</summary>

During a raid battle, the raid Pokemon may perform additional actions that break the conventions of a normal battle. These actions are triggered at particular thresholds during the battle, so they are somewhat predictable if you learn when and where they will trigger.

Below, I'll explain the effects of each extra action, when you can expect them to trigger, and how to manually set, disable, or alter them.

* <mark style="background-color:yellow;">**Reset Stat Drops**</mark>
  * **Effect:** The raid Pokemon releases a wave of energy that cures any status condition it may currently have and negates any of its negative stat changes.
  * **Trigger:** The raid Pokemon's HP drops to 40% of its max HP or lower, or the raid turn counter reaches 40% or below the raid's initial turn count. Triggers once per battle.
  * **Setting:** All raid Pokemon in 3-star raids or higher will use this extra action by default. However, you can remove this action from being used during a raid entirely by **not** including `:reset_drops` in the `:extra_actions` array in the rules hash of the raid event.\ <br>
* <mark style="background-color:yellow;">**Reset Stat Boosts**</mark>
  * **Effect:** The raid Pokemon releases a wave of energy that negates the Abilities (Gastro Acid effect) and any positive stat changes of all Pokemon on the player's side of the field.
  * **Trigger:** The raid Pokemon's HP drops to 60% of its max HP or lower, or the raid turn counter reaches 60% or below the raid's initial turn count. Triggers once per battle.
  * **Setting:** All raid Pokemon in 4-star raids or higher will use this extra action by default. However, you can remove this action from being used during a raid entirely by **not** including `:reset_boosts` in the `:extra_actions` array in the rules hash of the raid event.\ <br>
* <mark style="background-color:yellow;">**Drain Cheer Level**</mark>
  * **Effect:** The raid Pokemon releases a wave of energy that reduces the current cheer level of all trainers by 1. If a trainer selected to use a cheer on the same turn this occurs, the effect of their cheer will change to reflect the effect of their new cheer level.
  * **Trigger:** The raid Pokemon's HP drops to 50% of its max HP or lower, or the raid turn counter reaches 50% or below the raid's initial turn count. Triggers once per battle.
  * **Setting:** All raid Pokemon in 5-star raids or higher will use this extra action by default. However, you can remove this action from being used during a raid entirely by **not** including `:drain_cheer` in the `:extra_actions` array in the rules hash of the raid event.\ <br>
* <mark style="background-color:yellow;">**Double Attack Phase**</mark>
  * **Effect:** The raid Pokemon enters a phase where it will use a second attack immediately after using a move. The second attack is selected randomly out of the moves in its move set, but it will never pick the same move that it used for its first attack (unless it only has one move). If the raid Pokemon is Dynamaxed, the second move it uses will be decided from its base move set, not its Max Moves.
  * **Trigger:** The raid Pokemon's HP drops to 40% of its max HP or lower, or the raid turn counter reaches 40% or below the raid's initial turn count. Once the raid Pokemon enters this double attack phase, it will continue to use two attacks per turn for the remainder of the battle. Note that it is possible for this effect to stack with other extra actions that may cause the raid Pokemon to use more than one attack per turn.
  * **Setting:** All raid Pokemon will use this extra raid action by default, if able. Unlike other extra actions, it cannot be manually set or disabled.\ <br>
* <mark style="background-color:yellow;">**Additional Support Move**</mark>
  * **Effect:** The raid Pokemon uses a status move that provides some utility or support prior to using the move it would regularly use this turn. This support move will be an additional move that isn't included in its base move set, and is instead selected out of all possible support moves the raid Pokemon could potentially learn. The AI will select the best move among these to use. Examples of the types of moves that fit under this category would be moves like Reflect, Sunny Day, and Mist.
  * **Trigger:** This always triggers on the raid Pokemon's very first turn, and then triggers a second time once the raid turn counter reaches 50% or below the raid's initial turn count. This may only trigger twice per battle. This won't trigger at all if the raid Pokemon isn't capable of learning any eligible support moves. Note that it is possible for this effect to stack with other extra actions that may cause the raid Pokemon to use more than one attack per turn.
  * **Setting:** All raid Pokemon will use this extra action by default, if able. However, you can manually set which specific support moves you'd like a raid Pokemon to select from by setting `:support_moves` to an array of your desired move ID's in the rules hash of the raid event. If you don't want the raid Pokemon to use additional support moves at all, just set this to `nil` instead.\ <br>
* <mark style="background-color:yellow;">**Additional Spread Moves**</mark>
  * **Effect:** The raid Pokemon uses a spread move that can hit multiple targets prior to using the move it would regularly use this turn. This spread move will be an additional move that isn't included in its base move set, and is instead selected out of all possible spread moves the raid Pokemon could potentially learn. The AI will select the best move among these to use. Examples of the types of moves that fit under this category would be moves like Surf, Earthquake, and Icy Wind.
  * **Trigger:** This always triggers on every turn that the raid Pokemon has an active raid shield, and at no other point during the battle. This won't trigger at all if the raid Pokemon isn't capable of learning any eligible spread moves. Note that it is possible for this effect to stack with other extra actions that may cause the raid Pokemon to use more than one attack per turn. Since this only triggers when a raid shield is active, these moves will never trigger during a raid battle if raid shields have been disabled.
  * **Setting:** All raid Pokemon will use this extra action by default, if able. However, you can manually set which specific spread moves you'd like a raid Pokemon to select from by setting `:spread_moves` to an array of your desired move ID's in the rules hash of the raid event. If you don't want the raid Pokemon to use additional spread moves at all, just set this to `nil` instead.

</details>

<details>

<summary>Raid-Specific Mechanics</summary>

<mark style="background-color:orange;">**Max Raid Battles**</mark>

During a Max Raid battle, the raid Pokemon will use moves from their base move set for the first four turns of the battle. Beginning on the fifth turn, the raid Pokemon will begin exclusively using the Max Move and/or G-Max Move equivalents of their base move set, instead. This will persist for the remainder of the battle.

Note however, that once the raid Pokemon begins its Double Attack Phase, the second move it selects each turn will be selected from its base move set, not its Max Moves. So once it reaches this phase, the raid Pokemon will be using one Max Move and one regular move each turn.

***

<mark style="background-color:orange;">**Ultra Raid Battles**</mark>

During an Ultra Raid battle, the raid Pokemon will be able to launch a Z-Powered version of one of their base moves at any point, based on their held Z-Crystal. However, unlike normal circumstances, the raid Pokemon will be able to periodically replenish their ability to use Z-Moves during the battle, allowing them to launch multiple Z-Moves per battle.

While in an Ultra Raid battle, the specific Z-Crystal each battler is holding will also be displayed next to their HP bars. This makes it easier to tell at a glance the types of Z-Moves you can expect from the opponent, and which Z-Moves each ally Pokemon may have access to.

</details>

Page 78:

# Raid: Cheer Mechanics

Both types of raid battles featured in *Pokemon Sword & Shield* and *Pokemon Scarlet & Violet* introduced a new battle mechanic called Cheers. While in a raid battle, the Cheer command would replace the usual Run command, and would allow you to power up ally Pokemon to give you an edge during the raid. Each iteration of the cheer mechanic functioned differently, but for the purposes of this plugin, the version of the mechanic found in *Scarlet & Violet* is what's used as the model.

With that said, the cheer mechanics in this plugin work quite differently from the official games, so I will go over the details of how everything works in this section below.

{% hint style="info" %}
**Fleeing From Battle**

Note that since the Cheer command will replace Run, you will not be able to flee from battle when the Cheer command is enabled, regardless if you should normally be able to. However, if you're playing in debug mode, holding the `CTRL` key while selecting Cheer will still allow you to flee.
{% endhint %}

***

<mark style="background-color:orange;">**Cheer Overview**</mark>

While the cheer command is based loosely on how it is implemented in *Pokemon Scarlet & Violet*, a lot of the mechanics behind it have been much more fleshed out in this plugin to allow it to stand on its own as its own game mechanic, even outside of raid battles.

Below, I'll go into detail about the general workings of the Cheer mechanics in this plugin.

<details>

<summary>Cheer Battles</summary>

A cheer battle is simply any battle where the cheer mechanic is enabled to be used. By default, all raid battles will have the cheer mechanic enabled, so all raid battles also count as cheer battles.

However, even though cheer mechanics only exist during raids in the main series, this plugin allows you to flag any battle as a cheer battle if you'd like. This will allow you to use the effects of cheers during standard wild or even trainer battles. You can enable this through the use of the <mark style="background-color:green;">"cheerBattle"</mark> Battle Rule. More details on this rule can be found in the "Raid: Battle Rules" subsection of this guide.

Note that while in a cheer battle, *all* trainers have the ability to use cheer mechanics, including both partners and foes. The AI for each trainer will determine if and when they utilize any cheers during battle.

</details>

<details>

<summary>Cheer Menu</summary>

The Cheer command replaces the Run command during a cheer battle. When you select this command, you will be given a list of four possible cheers to choose from, similar to move selection.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FPxkYrVr9o5vQzTsz4U5A%2Fcheering.gif?alt=media&#x26;token=e9384e66-be9e-440a-baa6-ad981c341612" alt="" data-size="original">

A brief description of the effect of each cheer will be displayed in the top right of the cheer menu. In the top left, the trainer's current cheer level will be displayed, which determines the strength and effects of each type of cheer.

Once a cheer has been selected, the trainer will us that battler's turn to cheer on the team, granting them the effects of the selected cheer. Cheer commands have higher priority than moves, and will activate before any Pokemon on the field attacks. However, cheers have less priority than actions such as switching, using items, or using special actions such as Mega Evolution.

Each trainer can only select one cheer to use per turn. In a double or triple battle, the trainer will not be able to select the Cheer command at all with their second or third Pokemon if they already selected a cheer to use with a previous Pokemon.

</details>

<details>

<summary>Cheer Mode</summary>

While there are only four different selectable slots in the cheer menu during battle, the list of selectable cheer commands may differ depending on the "cheer mode" of a particular battle. A cheer mode is a number that is assigned at the start of the battle that determines which list of cheers should be available to trainers during this battle.

By default, the first three slots in the cheer menu will be the same for all battles, regardless of cheer mode. These cheers will include:

* <mark style="background-color:red;">"Go all-out!"</mark>
* <mark style="background-color:red;">"Hang tough!"</mark>
* <mark style="background-color:red;">"Heal up!"</mark>

However, the fourth slot may be radically different based on the mode. Here are all of the cheer modes included by default, and the cheer that they add to the cheer menu:

* <mark style="background-color:yellow;">**Mode 0**</mark>\
  This is the default mode used for normal wild/trainer battles.\
  The fourth command in the cheer menu is set to the <mark style="background-color:red;">"Turn the tables!"</mark> cheer.\ <br>
* <mark style="background-color:yellow;">**Mode 1**</mark>\
  This is the mode used specifically for Basic Raids.\
  The fourth command in the cheer menu is set to the <mark style="background-color:red;">"Keep it going!"</mark> cheer.\ <br>
* <mark style="background-color:yellow;">**Mode 2**</mark>\
  This is the mode used specifically for Ultra Raids.\
  The fourth command in the cheer menu is set to the <mark style="background-color:red;">"Let's use Z-Power!"</mark> cheer.\ <br>
* <mark style="background-color:yellow;">**Mode 3**</mark>\
  This is the mode used specifically for Max Raids.\
  The fourth command in the cheer menu is set to the <mark style="background-color:red;">"Let's Dynamax!"</mark> cheer.\ <br>
* <mark style="background-color:yellow;">**Mode 4**</mark>\
  This is the mode used specifically for Tera Raids.\
  The fourth command in the cheer menu is set to the <mark style="background-color:red;">"Let's Terastallize!"</mark> cheer.

Cheer modes will all be handled for you automatically, so you never have to worry about setting a specific mode for a specific battle. Generally speaking, if you enter a raid battle, the corresponding mode that relates to the type of raid battle you engaged in will automatically be set. If you enter a non-raid battle, then the default cheer mode will be set.

However, if you really want to manually set a specific cheer mode for a certain battle for some reason, you may do so with the <mark style="background-color:green;">"cheerMode"</mark> Battle Rule. This will allow you to flag the next battle with the specific cheer mode you want, which will allow you to control the specific  cheers that will be displayed in the cheer menu. You can refer to the "Raid: Battle Rules" subsection in this guide for more details on this rule.

</details>

<details>

<summary>Cheer Level</summary>

While participating in a cheer battle, each trainer will start with a cheer level of 0. At the end of each trainer's turn, their cheer level will increase by 1, up to a maximum of 3. No cheer is selectable when a trainer's cheer level is at zero, so you must wait at least until the second turn in a battle before any cheers are even usable.

The strength and effects of each cheer may change depending on the trainer's cheer level upon using a cheer. For example, using the <mark style="background-color:red;">"Heal up!"</mark> cheer when the trainer's cheer level is at 1 may restore 25% of each ally's max HP. However, using the same cheer when the trainer's cheer level is at the maximum may fully restore the HP of all ally Pokemon, as well as restoring their status.&#x20;

Sometimes you're better off holding out on using a cheer and saving it for when you've reached a higher cheer level for stronger effects. Other times, it may be useful to spend a cheer right away if you're in a tight spot.&#x20;

Once a cheer is used however, the trainer's cheer level is reset back to 0, and won't start increasing again until the end of the following turn. So there is no benefit to holding on to your cheer level once it reaches the maximum level of 3.

***

<mark style="background-color:orange;">**Viewing Cheer Level**</mark>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FJzGUSAqPvjwlP9lidPYx%2F%5B2024-11-27%5D%2018_59_13.363.png?alt=media&#x26;token=b86b5d8c-f7f0-4755-bcc5-46effcb66a90" alt="" data-size="original">

To view your current cheer level, just select the Cheer command to open the cheer menu. Your cheer level will be displayed in the top left corner of this menu.

***

<mark style="background-color:orange;">**Manually Changing Cheer Level**</mark>

While playing in debug mode, you can manually set a particular trainer's current cheer level by opening the debug menu.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fszbg2hJ9t065bzIZgqEg%2Fdebug.gif?alt=media&#x26;token=c9e56b09-5140-4036-8e45-a192f6089a76" alt="" data-size="original">

Just select "Trainer options..." and scroll to the bottom and select "Cheer Levels." This will allow you to manually set the desired cheer level for each trainer.

</details>

***

<mark style="background-color:orange;">**Cheer Commands**</mark>

There are several different types of cheers that you can choose from after selecting the Cheer command in battle. Below, I'll go into detail of the effects of each cheer, and the conditions in which they may appear or be used.

<details>

<summary><mark style="background-color:red;"><strong>"Go all-out!"</strong></mark></summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F1rPWqab10chHQup08UAd%2F%5B2024-11-27%5D%2018_59_13.363.png?alt=media&#x26;token=5ea49d4f-55cd-4a6f-ae81-f9a72b87249a" alt="" data-size="original">

This is the standard offense-focused cheer, usable in all cheer modes. The strength and effectiveness of this cheer is based on the trainer's cheer level upon using it.

* <mark style="background-color:yellow;">**Cheer Lvl 1**</mark>\
  Places an effect on the user's side of the field for three turns that increases the damage dealt with all moves used by 50%. This stacks with other effects, such as Helping Hand.\ <br>
* <mark style="background-color:yellow;">**Cheer Lvl 2**</mark>\
  Places an effect on the user's side of the field for three turns that increases the added effect chance of all moves used by battlers on the user's side to 100%. In addition, all moves used by battlers on the user's side also have a 100% chance to critically hit. This effect ignores all other effects that would normally negate added effects or critical hits from triggering, such as the Shield Dust or Battle Armor abilities.\ <br>
* <mark style="background-color:yellow;">**Cheer Lvl 3**</mark>\
  Places an effect on the user's side of the field for three turns that allows all battlers on the user's side to bypass the foe's attempts to negate or reduce damage from incoming attacks. This includes the effects of Reflect, Light Screen, Aurora Veil, Substitute, and all Protect-like moves. Essentially, all battlers under this effect have the combined effects of the Infiltrator and Unseen Fist abilities.\
  \
  During raid battle in particular, this cheer will also make it easier to break the opposing raid Pokemon's raid shield.

</details>

<details>

<summary><mark style="background-color:red;"><strong>"Hang tough!"</strong></mark></summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FK1f0qW6UcEknGmEpV4Aq%2F%5B2024-11-27%5D%2019_06_53.353.png?alt=media&#x26;token=0b6bd089-ac15-4b79-8afc-ab1c8126fa2b" alt="" data-size="original">

This is the standard defense-focused cheer, usable in all cheer modes. The strength and effectiveness of this cheer is based on the trainer's cheer level upon using it.

* <mark style="background-color:yellow;">**Cheer Lvl 1**</mark>\
  Places an effect on the user's side of the field for three turns that decreases the damage taken from all incoming attacks by 50%. This stacks with other effects, such as Reflect and Light Screen.\ <br>
* <mark style="background-color:yellow;">**Cheer Lvl 2**</mark>\
  Places an effect on the user's side of the field for three turns that totally negates the foe's chances of triggering an added effect or a critical hit with any incoming attacks. This  will even override the foe's own <mark style="background-color:red;">"Go all-out"</mark> cheer effects that would otherwise boost these odds to 100%.\ <br>
* <mark style="background-color:yellow;">**Cheer Lvl 3**</mark>\
  Places an effect on the user's side of the field for three turns that causes all battlers on the user's side to endure damage from incoming attacks with 1 HP if they would otherwise be KO'd by the attack.

</details>

<details>

<summary><mark style="background-color:red;"><strong>"Heal up!"</strong></mark></summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F7bUZW4JM4UUIfG6AUzUz%2F%5B2024-11-27%5D%2019_06_56.714.png?alt=media&#x26;token=4dad6e03-c1d1-4151-a820-b57c618e6122" alt="" data-size="original">

This is the standard healing-focused cheer, usable in all cheer modes. The strength and effectiveness of this cheer is based on the trainer's cheer level upon using it.

* <mark style="background-color:yellow;">**Cheer Lvl 1**</mark>\
  All battlers on the user's side recover 25% of their max HP, except for those under the Heal Block effect.\ <br>
* <mark style="background-color:yellow;">**Cheer Lvl 2**</mark>\
  All battlers on the user's side recover 50% of their max HP, except for those under the Heal Block effect. Each battler's status is also cured, and are also cured of confusion, infatuation, and Curse.\ <br>
* <mark style="background-color:yellow;">**Cheer Lvl 3**</mark>\
  All battlers on the user's side recover 100% of their max HP, except for those under the Heal Block effect. Each battler's status is also cured, and are also cured of confusion, infatuation, and Curse. In addition, each battler is also granted a Wish that will restore 50% of their max HP to the Pokemon occupying their position on the following turn.

</details>

<details>

<summary><mark style="background-color:red;"><strong>"Turn the tables!"</strong></mark></summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F3UYJHtJb1ZnuKNHuJoQQ%2F%5B2024-11-27%5D%2019_11_23.372.png?alt=media&#x26;token=b8bacf0d-b22f-427e-bc8a-7d7e7468fda5" alt="" data-size="original">

This is a cheer designed to reverse and counter certain effects during battle, usable in non-raid battles (cheer mode 0). The strength and effectiveness of this cheer is based on the trainer's cheer level upon using it.

* <mark style="background-color:yellow;">**Cheer Lvl 1**</mark>\
  Reverses the stat stages of all battlers on the field. All stat boosts become equivalent stat drops, and all stat drops become equivalent stat boosts. Similar to the move Topsy Turvey.\ <br>
* <mark style="background-color:yellow;">**Cheer Lvl 2**</mark>\
  Swaps the effects currently active on both sides of the field. For example, if Tailwind is in effect on the opponent's side, it will be swapped to the user's side instead. Similar to the move Court Change. Note that all field effects applied by the <mark style="background-color:red;">"Go all-out!"</mark> and <mark style="background-color:red;">"Hang tough!"</mark> cheers count as field effects, so you can use this cheer to steal the opponent's offensive and/or defensive cheer effects.\ <br>
* <mark style="background-color:yellow;">**Cheer Lvl 3**</mark>\
  Removes the Heal Block effect from all battlers on the user's side and also applies the Heal Block effect on all battlers on the opposing side for 3 turns each. This effectively prevents the opposing side from being able to use the full effects of the <mark style="background-color:red;">"Heal up!"</mark> cheer for several turns, while ensuring your side will be able to use it without fail.

</details>

<details>

<summary><mark style="background-color:red;"><strong>"Keep it going!"</strong></mark></summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FY0T9xp8MTUfun54IAItD%2F%5B2024-11-27%5D%2019_07_16.393.png?alt=media&#x26;token=099ff937-7a79-4d70-8adb-aa58d2486d95" alt="" data-size="original">

This is a cheer designed to extend the raid timers, usable in Basic Raids. (cheer mode 1). The strength and effectiveness of this cheer is based on the trainer's cheer level upon using it. However, unlike most cheers, this cheer requires the trainer's cheer level to be at least 2 before it will do anything.

* <mark style="background-color:yellow;">**Cheer Lvl 1**</mark>\
  This cheer will fail and have no effect.\ <br>
* <mark style="background-color:yellow;">**Cheer Lvl 2**</mark>\
  Extends the raid's Turn Counter by a few turns, allowing you to stay in the raid for longer. The number of turns gained scales depending on the number of ally Pokemon participating in the raid. No effect if the raid doesn't have a Turn Counter.\ <br>
* <mark style="background-color:yellow;">**Cheer Lvl 3**</mark>\
  Extends the raid's KO Counter by 1, allowing you to survive in the raid for longer. Also increases the raid's Turn Counter by a few turns as well. The number of turns gained scales depending on the number of ally Pokemon participating in the raid. No effect if the raid doesn't have a KO Counter or a Turn Counter.

</details>

<details>

<summary><mark style="background-color:red;"><strong>"Let's use Z-Power!"</strong></mark></summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fq2FccUBlnnt82FqOirFP%2F%5B2024-11-27%5D%2019_08_41.659.png?alt=media&#x26;token=6658449d-7f73-45d1-b45e-42e7dbbbcc5a" alt="" data-size="original">

This is a cheer designed to replenish the trainer's Z-Ring, usable in Ultra Raids (cheer mode 2). Unlike most other cheers, this cheer doesn't scale in power with the trainer's cheer level. Instead, the cheer is completely unusable until the trainer's cheer level has reached its maximum.

* <mark style="background-color:yellow;">**Cheer Lvl 1 & 2**</mark>\
  This cheer will fail and have no effect.\ <br>
* <mark style="background-color:yellow;">**Cheer Lvl 3**</mark>\
  The trainer's Z-Ring is recharged with Z-Power energy, allowing them to use a Z-Move. This can be used multiple times in a battle, allowing you to bypass the once-per-battle rule that using Z-Moves usually impose. This cheer will fail if the trainer doesn't have a Z-Ring, or if their Z-Ring is already charged.

Note that when battling in an Ultra Raid, all trainers start off the battle with their Z-Rings depleted of energy. This means that the only way to use Z-Moves during an Ultra Raid is to wait for at least 3 consecutive turns for a trainer's cheer level to reach its maximum. If so, they'll be able to use this cheer to charge up their Z-Ring. Using cheers prior to this may be immediately useful, but it will delay how long the trainer will have to wait before Z-Moves will become available.

</details>

<details>

<summary><mark style="background-color:red;"><strong>"Let's Dynamax!"</strong></mark></summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fe3qMME0aFyVgZ7y2pCWE%2F%5B2024-11-27%5D%2019_09_32.715.png?alt=media&#x26;token=d0c79364-2cc0-498c-a9f9-519ddab2cb33" alt="" data-size="original">

This is a cheer designed to replenish the trainer's Dynamax Band, usable in Max Raids (cheer mode 3). Unlike most other cheers, this cheer doesn't scale in power with the trainer's cheer level. Instead, the cheer is completely unusable until the trainer's cheer level has reached its maximum.

* <mark style="background-color:yellow;">**Cheer Lvl 1 & 2**</mark>\
  This cheer will fail and have no effect.\ <br>
* <mark style="background-color:yellow;">**Cheer Lvl 3**</mark>\
  The trainer's Dynamax Band is recharged with Dynamax energy, allowing them to Dynamax one of their Pokemon. This can be used multiple times in a battle, allowing you to bypass the once-per-battle rule that using Dynamax usually imposes. This cheer will fail if the trainer doesn't have a Dynamax Band, or if their Dynamax Band is already charged. This cheer will also fail if any battler on the user's side (including any owned by a partner trainer) is currently Dynamaxed already, as only one Pokemon on the player's side can be Dynamaxed at a time. This cheer will also fail if an ally trainer is able to use Dynamax first, to prevent multiple trainers from Dynamaxing simultaneously.

Note that when battling in a Max Raid, all trainers start off the battle with their Dynamax Bands depleted of energy. This means that the only way to use Dynamax during a Max Raid is to wait for at least 3 consecutive turns for a trainer's cheer level to reach its maximum. If so, they'll be able to use this cheer to charge up their Dynamax Band. Using cheers prior to this may be immediately useful, but it will delay how long the trainer will have to wait before Dynamax will become available.

</details>

<details>

<summary><mark style="background-color:red;"><strong>"Let's Terastallize!"</strong></mark></summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FOtPcU1BeFOzTtUl3lDcR%2F%5B2024-11-27%5D%2019_10_24.787.png?alt=media&#x26;token=16b66624-7bf3-4f53-ac1b-cb5d1c9aaa96" alt="" data-size="original">

This is a cheer designed to replenish the trainer's Tera Orb, usable in Tera Raids (cheer mode 4). Unlike most other cheers, this cheer doesn't scale in power with the trainer's cheer level. Instead, the cheer is completely unusable until the trainer's cheer level has reached its maximum.

* <mark style="background-color:yellow;">**Cheer Lvl 1 & 2**</mark>\
  This cheer will fail and have no effect.\ <br>
* <mark style="background-color:yellow;">**Cheer Lvl 3**</mark>\
  The trainer's Tera Orb is recharged with Terastal energy, allowing them to Terastallize one of their Pokemon. This can be used multiple times in a battle, allowing you to bypass the once-per-battle rule that using Terastallization usually imposes. This cheer will fail if the trainer doesn't have a Tera Orb, or if their Tera Orb is already charged. This cheer will also fail if the trainer already owns a battler on the field that is currently Terastallized. However, unlike Dynamax, two ally trainers can each have a Terastallized Pokemon on the field simultaneously, so this cheer *won't* fail if another trainer is capable of Terastallizing first.

Note that when battling in a Tera Raid, all trainers start off the battle with their Tera Orbs depleted of energy. This means that the only way to use Terastallization during a Tera Raid is to wait for at least 3 consecutive turns for a trainer's cheer level to reach its maximum. If so, they'll be able to use this cheer to charge up their Tera Orb. Using cheers prior to this may be immediately useful, but it will delay how long the trainer will have to wait before Terastallization will become available.

</details>

***

<mark style="background-color:orange;">**Creating Custom Cheers**</mark>

This plugin implements cheers by introducing a brand new class in the `GameData` module called `Cheer`. This `Cheer` class is where each specific type of cheer is registered to appear in the cheer menu in battle. Below, I'll give a brief overview of the anatomy of a cheer, which may make it clearer on how you might go about adding your own custom cheers.

Note that this isn't meant to be a comprehensive guide on *how* to make your own cheers, just an overview on how cheers have been implemented in this plugin to give you an idea of how it's designed to work.

<details>

<summary>Cheer Class</summary>

The data structure for the Cheer class can be found by opening the plugin scripts and opening the file `[003] Cheering/[000] Cheer Data`.

In here, you will find the Cheer class, along with each registered cheer that is added by this plugin by default. Each cheer contains the following data:

* `:id`\
  The symbol ID related to this specific cheer.\ <br>
* `:name`\
  The display name used for this cheer. This is never really used anywhere, but it's here for the sake of being consistent with other game data classes.\ <br>
* `:icon_position`\
  This refers to the specific button icon used for this cheer when displayed in the cheer menu. The specific graphic that this refers to is named `cursor_cheer`, and is located in `Graphics/Plugins/Raid Battles/Battle`.\ <br>
* `:command_index`\
  This refers to the specific button "slot" or index that this cheer's button should appear in. For example, index 0 refers to the top left button slot, and index 3 refers to the bottom right button slot. You can use this to set the position that each button slot each cheer command should appear in.\ <br>
* `:mode`\
  This refers to the specific "cheer mode" that this particular cheer will appear in. By default, all cheers are assumed to appear in all cheer modes unless they are specifically assigned to appear in only specific modes. For example, the `:BasicRaid` cheer is set to `:mode` 1, so that cheer can only appear when the cheer mode is set to 1, and won't appear otherwise.\ <br>
* `:cheer_text`\
  This sets the specific text that will appear for this cheer when displaying text on the buttons in the cheer menu, or during battle text messages. For example, the `:Healing` cheer's text is <mark style="background-color:red;">"Heal up!"</mark>, which is displayed both on the button and in battle messages.\ <br>
* `:description`\
  This sets the description text of a cheer's effects in the upper right side of the cheer menu while the cursor is hovering on that particular cheer's button. This data is set as an array, so you can set different descriptions for the cheer for each cheer level. Note that level 0 still counts as a cheer level, despite no cheer commands being usable when the cheer level is zero.

</details>

<details>

<summary>Cheer Handlers</summary>

The effects of each specific cheer is implemented through the use of a cheer handler, similar to how the effects of most items and abilities are implemented through the use of handlers. If you're familiar with those, then you'll more or less understand how to make your own cheers.

All cheer handlers are implemented in the plugin scripts located in the file `[003] Cheering/[003] Cheer Handlers`.

Each handler utilizes the following procs: `|cheer, side, owner, battler, battle|`

Most of these are self-explanatory, but I'll go over each to clarify things.

* <mark style="background-color:yellow;">**cheer**</mark>\
  The ID of this specific cheer.\ <br>
* <mark style="background-color:yellow;">**side**</mark>\
  The index of the particular side of the field that is triggering this cheer (0 = ally, 1 = foe).\ <br>
* <mark style="background-color:yellow;">**owner**</mark>\
  The index of the particular trainer that is triggering this cheer.\ <br>
* <mark style="background-color:yellow;">**battler**</mark>\
  The specific battler object who's turn is being used to trigger this cheer.\ <br>
* <mark style="background-color:yellow;">**battle**</mark>\
  The overall battle class.

Note that if you want to obtain the current cheer level of the specific trainer who is using this cheer, you can combine several of these procs to return this data, like so:

```
battle.cheerLevel[side][owner]
```

You can use this to implement different effects for each cheer level of a particular cheer.

</details>

<details>

<summary>Cheer AI Handlers</summary>

AI trainers may also use cheer commands during a cheer battle. The way they determine if, when, and how they should used a particular cheer depends on how well that particular cheer scores when the AI tallies up the scores of all of its options, similar to how move scoring works. If you're familiar with AI move scores, then you'll more or less understand how to make your own cheer AI.

All cheer handlers are implemented in the plugin scripts located in the file `[003] Cheering/[005] Cheer AI Handlers`.

However, there are two types of AI handlers. A generic handler, that applies general score changes to the cheer mechanic overall; and cheer-specific handlers, which score the utility of each particular cheer the AI can use. I'll go over each below.

***

<mark style="background-color:orange;">**GeneralCheerScore**</mark>

This is the general cheer score handler that applies to all cheers. You can technically make as many of these handlers as you like, but I simply made a single one of these handlers by default that uses the ID `:cheer_general`.

This handler tweaks the AI so that it will ignore using a certain cheer if an ally trainer has already selected a similar cheer. For example, if the player selects the "Heal up!" cheer, this handler will make it so that an AI partner will not consider using their own "Heal up!" cheer, because it would be redundant. This handler will also encourage the AI to rack up a higher cheer level before using a cheer, rather than using them immediately.

This handler utilizes the following procs: `|score, cheer, idxCheer, cheer_lvl, ai, battle|`

Most of these are self-explanatory, but I'll go over each to clarify things.

* <mark style="background-color:yellow;">**score**</mark>\
  The base score for this cheer.\ <br>
* <mark style="background-color:yellow;">**cheer**</mark>\
  The ID of this specific cheer.\ <br>
* <mark style="background-color:yellow;">**idxCheer**</mark>\
  The command index of this specific cheer.\ <br>
* <mark style="background-color:yellow;">**cheer\_lvl**</mark>\
  The current cheer level of the particular trainer that may use this cheer.\ <br>
* <mark style="background-color:yellow;">**ai**</mark>\
  The overall AI class.\ <br>
* <mark style="background-color:yellow;">**battle**</mark>\
  The overall battle class.

***

<mark style="background-color:orange;">**CheerEffectScore**</mark>

This is the handler used to score the effects of individual cheers. Each cheer has its own AI handler for scoring moves, just as they have their own handlers for implementing their effects.

Each handler utilizes the following procs: `|cheer, score, cheer_lvl, ai, battle|`

These procs are identical to the ones outlined above in the <mark style="background-color:orange;">GeneralCheerScore</mark> section, with the lone exception being that the `idxCheer` proc isn't included here. Besides that, all of the remaining procs are utilized in the same way.

</details>

Page 79:

# Raid: Animations

Various animations are included with this plugin both in battle and in the overworld. In this subsection, I'll go over all of the animations added by this plugin.

***

<mark style="background-color:orange;">**Battle Transitions**</mark>

Each type of raid battle has its own unique battle transition animation that showcases the raid species. TheAse animations first show a blackened silhouette and then gradually reveal the hidden species. The animation for each raid type is identical apart from the background elements that appear behind the Pokemon sprite.

<div><figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F9hsQYSJZKYRznBeD1Aiw%2Fbasic.gif?alt=media&#x26;token=cfea865b-45d2-48c2-9e72-8a02a3fba222" alt=""><figcaption><p>Example of a Basic Raid battle transition.</p></figcaption></figure> <figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fy1eZlSOvtPUEIvMit9bY%2Fultra.gif?alt=media&#x26;token=139e46e4-aa62-4459-ac54-16e68855443c" alt=""><figcaption><p>Example of an Ultra Raid battle transition.</p></figcaption></figure></div>

<div><figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FQjedMIKR1sDSSd8ea8gA%2Fmax.gif?alt=media&#x26;token=9992f2cd-00e5-490a-a298-0c7ad3bd4ee3" alt=""><figcaption><p>Example of a Max Raid battle transition.</p></figcaption></figure> <figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FuPVZThTwJIGCSqkmEVaQ%2Ftera.gif?alt=media&#x26;token=53dc06fb-53c4-4cb1-b1eb-5879094122a4" alt=""><figcaption><p>Example of a Tera Raid battle transition.</p></figcaption></figure></div>

***

<mark style="background-color:orange;">**Raid Battle Animations**</mark>

There are various animations specifically used during raid battles related to certain raid mechanics. Here are all of the raid-exclusive animations that you can expect to see:

***

<mark style="background-color:yellow;">**Raid Shield Animations**</mark>

There are several animations related to a raid Pokemon's raid shield. One that animates a shield when it is first summoned, another when it takes damage, and another which is used when the raid shield is broken.

<div align="left"><figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FKKFXvxMjrnKkGFdo8SSR%2Fshield.gif?alt=media&#x26;token=b07ecb85-97ae-49f5-b294-1529deaed0bd" alt="" width="383"><figcaption><p>Animations for initiating, damaging, and destroying a raid shield.</p></figcaption></figure></div>

***

<mark style="background-color:yellow;">**Extra Raid Action Animation**</mark>

Whenever a raid Pokemon performs an extra raid action, an animation will play to indicate this. The animation will be a simple ring of energy that extends outwards from the raid Pokemon.

<div align="left" data-full-width="false"><figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Ff6oK4cwh4oDhsGvJYoVJ%2Faction.gif?alt=media&#x26;token=b464b78d-6f01-43d5-b458-be8880e2a647" alt="" width="383"><figcaption><p>Animation indicating an extra raid action is being used.</p></figcaption></figure></div>

***

<mark style="background-color:yellow;">**Raid Failure Animation**</mark>

Whenever you are prematurely kicked out of a raid battle due to one of the raid counters reaching zero before you defeated the raid Pokemon, an animation will play to indicate that you've been blown out of the raid. This animation is the same as the flee animation used for wild Pokemon, except it will show all Pokemon on your side of the field fleeing simultaneously instead.

<div align="left"><figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FolSVA2wILetuL9mrzEhG%2Fflee.gif?alt=media&#x26;token=b20c25af-58fc-47fe-a103-9695882b32a4" alt="" width="383"><figcaption><p>Animation used when the player is prematurely blown out of a den.</p></figcaption></figure></div>

Page 80:

# Raid: Battle Rules

This plugin adds additional battle rules related to the Cheer mechanic.

<details>

<summary><mark style="background-color:green;"><strong>"cheerBattle"</strong></mark></summary>

This rule enables all trainers to use cheers in this battle, even if the battle is not a raid battle. The specific cheer mode that this rule enables will be automatically determined based on the type of battle the player participates in. If you set a specific cheer mode with the <mark style="background-color:green;">"cheerMode"</mark> rule listed below, you don't need to set this rule.

This is entered as `setBattleRule("cheerBattle")`

</details>

<details>

<summary><mark style="background-color:green;"><strong>"cheerMode"</strong></mark></summary>

This rule allows you to set a specific cheer mode to be used for this battle. When setting a cheer mode with this rule, there is no need to use the <mark style="background-color:green;">"cheerBattle"</mark> rule, as this rule will already enable a cheer battle when set.

This is entered as `setBattleRule("cheerMode", Integer)`, where "Integer" is the number of the desired cheer mode you would like to set. For more information on cheer modes, check out the "Raid: Cheer Mechanics" subsection of this guide.

</details>

Page 81:

# Raid: Mid-Battle Scripting

This plugin adds various new keys to be used by the Deluxe Battle Kit's mid-battle scripting functionality.

***

<mark style="background-color:orange;">**Trigger Keys**</mark>

These are keys which trigger at various points of a raid battle, or when cheer commands are used.

* <mark style="background-color:purple;">**"BeforeCheer"**</mark>\
  Triggers before a trainer uses a cheer.
* <mark style="background-color:purple;">**"AfterCheer"**</mark>\
  Triggers after a trainer successfully used a cheer.
* <mark style="background-color:purple;">**"FailedCheer"**</mark>\
  Triggers after a trainer's cheer failed.

{% hint style="info" %}
Trigger Extensions: You may extend these triggers with a cheer ID or species ID to specify that they should only trigger when a specific cheer was selected, or when the turn of a specific battler's species is used for the selected cheer. For example, <mark style="background-color:purple;">"BeforeCheer\_Healing"</mark> would trigger only when the <mark style="background-color:red;">"Heal up!"</mark> cheer was selected, where <mark style="background-color:purple;">"AfterCheer\_PIKACHU"</mark> would only trigger after a cheer was used on a Pikachu's turn.
{% endhint %}

* <mark style="background-color:purple;">**"CheerLevel"**</mark>\
  Triggers whenever a trainer's cheer level increases.

{% hint style="info" %}
Trigger Extensions: You may extend this trigger with a number to specify that this should trigger only when a trainer's cheer level increases to a certain level. For example, <mark style="background-color:purple;">"CheerLevel\_3"</mark> would only trigger when a trainer's cheer level reaches level 3.
{% endhint %}

* <mark style="background-color:purple;">**"RaidShieldStart"**</mark>\
  Triggers whenever the raid Pokemon summons a raid shield.
* <mark style="background-color:purple;">**"RaidShieldDamaged"**</mark>\
  Triggers whenever the raid Pokemon's raid shield takes damage without breaking.
* <mark style="background-color:purple;">**"RaidShieldBroken"**</mark>\
  Triggers whenever the raid Pokemon's raid shield is broken.

{% hint style="danger" %}
Trigger Extensions: Since these keys can only ever trigger for the opponent, these are not compatible with "user" extensions, such as <mark style="background-color:orange;">"\_player</mark>*<mark style="background-color:orange;">"</mark> or <mark style="background-color:orange;">"\_</mark>*<mark style="background-color:orange;">foe"</mark>.
{% endhint %}

***

<mark style="background-color:orange;">**Command Keys**</mark>

These are keys which trigger certain actions related to raid battles, such as forcing a trainer to use a cheer, or changing certain raid elements such raid shields and counters.

<details>

<summary><mark style="background-color:blue;"><strong>"setCheerLv"</strong></mark><strong> ⇒ </strong><mark style="background-color:yellow;"><strong>Integer</strong></mark></summary>

Changes a trainer's cheer level to a desired value. This is set as an integer ranging from 0-3. If this is set on the same turn that a trainer has selected to use a cheer (but prior to that cheer being used), the effects of their selected cheer will reflect their new cheer level.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"useCheer"</strong></mark><strong> ⇒ </strong><mark style="background-color:yellow;"><strong>Symbol</strong></mark></summary>

Forces a battler's turn to be used by their trainer to use a particular cheer instead. This will override whatever the normally selected commands for that battler's turn would have otherwise been. This won't work if the battler has already moved on the turn this has been triggered, or before any commands have been selected.

This is entered as a particular cheer ID. For example, setting this to `:Offense` will register the <mark style="background-color:red;">"Go all-out!"</mark> cheer to be used.&#x20;

If you enter an ID for a cheer that is not usable in this cheer mode, then the cheer for the current mode that shares the same command index will be used instead. For example, both the `:MaxRaid` and `:TeraRaid` cheers share the same cheer menu index (3), but are only usable in cheer modes 3 and 4, respectively. This means that if you try to set this command to `:TeraRaid` while in cheer mode 3 (a Max Raid battle), the trainer will not try to use the <mark style="background-color:red;">"Let's Terastallize!"</mark> cheer, but will instead try to use the <mark style="background-color:red;">"Let's Dynamax!"</mark> cheer.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"raidCounter"</strong></mark><strong> ⇒ </strong><mark style="background-color:yellow;"><strong>Array</strong></mark></summary>

Changes the current value of one of the raid counters. This is set as an array, where the first value is either symbols `:turn_count` or `:ko_count`, depending on which counter you're attempting to change. The second value must be a positive or negative integer, depending on whether you want to add or subtract from the values of these respective counters.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"raidAction"</strong></mark><strong> ⇒ </strong><mark style="background-color:yellow;"><strong>Symbol</strong></mark></summary>

Forces a raid Pokemon to perform a special raid action. This must be entered as one of the following symbols:

* `:reset_drops`\
  Forces the raid Pokemon to unleash a wave of energy that negates any of its own stat drops, as well as curing any status conditions it may have.<br>
* `:reset_boosts`\
  Forces the raid Pokemon to unleash a wave of energy that suppresses the Abilities and negates any stat boosts for the Pokemon on your side of the field.<br>
* `:drain_cheer`\
  Forces the raid Pokemon to unleash a wave of energy that reduces the cheer level of all trainers by one.

Forcing one of these extra actions in this way will not consume the raid Pokemon's natural "once-per-battle" usage of these mechanics. So, they may still naturally use these at the appropriate times regardless of how many times you force them to occur through this manner.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"raidShield"</strong></mark><strong> ⇒ </strong><mark style="background-color:yellow;"><strong>Integer</strong></mark></summary>

This can be used to give an opposing Pokemon a raid shield, or to alter the state of an existing one. Note that this can be done on any opponent, not just Raid Pokemon. So normal wild Pokemon or opposing trainer's Pokemon may be compatible with this.

When set to a positive number:

* Opponent doesn't have a shield: Grants a Raid shield with a number of bars equal to the inputted amount.
* Opponent already has a shield: Increases the amount of bars the shield has by the inputted amount.

When set to a negative number:

* Opponent doesn't have a shield: Nothing happens.
* Opponent already has a shield: Reduces the amount of bars the shield has by the inputted amount.

</details>

Page 82:

# Z-Power

[**Eevee Expo Link**](https://eeveeexpo.com/resources/1478/)

[**PokeCommunity Link**](https://www.pokecommunity.com/threads/z-power-dbk-add-on-v21-1.526137/#post-10797987)

[**Download Link**](https://www.mediafire.com/file/cn1q3s848rjy72x/Z-Power.zip/file)

This plugin builds upon the Deluxe Battle Kit to add the Z-Power battle mechanics introduced in *Pokemon Sun & Moon*. This includes both Z-Moves and Ultra Burst. All functionality for these mechanics have been replicated in this plugin, and will work along side other battle gimmicks such as Mega Evolution without issue. In the following subsections, I'll go over specific areas of this plugin in more detail. Below, I'll go over general plugin functionality.

***

<mark style="background-color:orange;">**Z-Power Availability**</mark>

Once this plugin is installed, all Z-Power mechanics will be available to use right out of the gate. However, there are some criteria that must be met in order for the option to use them to appear in battle. Below I'll go over all the factors for Z-Move and Ultra Burst eligibility, how to disable their availability, and various other settings related to its use.

<details>

<summary>General</summary>

<mark style="background-color:yellow;">**Z-Moves**</mark>

Z-Moves are available by default after installation. However, if you would like to disable the Z-Move mechanic entirely at any point, you may do so by using a game switch.&#x20;

In the plugin settings, there is a setting named `NO_ZMOVE` which stores the switch number used for disabling Z-Moves. This is saved as switch number `64` by default, but please renumber this if this conflicts with an existing game switch that you use.

If this switch is turned on, then Z-Moves will be disabled for all trainers and Pokemon until the switch is turned back off. If you're playing in debug mode, you can easily toggle this switch on and off by going into the debug menu and opening the "Deluxe plugin settings..." menu, and then selecting "Toggle Z-Moves."

***

<mark style="background-color:yellow;">**Ultra Burst**</mark>

Ultra Burst is available by default after installation. However, if you would like to disable the Ultra Burst mechanic entirely at any point, you may do so by using a game switch.&#x20;

In the plugin settings, there is a setting named `NO_ULTRA_BURST` which stores the switch number used for disabling Z-Moves. This is saved as switch number `65` by default, but please renumber this if this conflicts with an existing game switch that you use.

If this switch is turned on, then Ultra Burst will be disabled for all trainers and Pokemon until the switch is turned back off. If you're playing in debug mode, you can easily toggle this switch on and off by going into the debug menu and opening the "Deluxe plugin settings..." menu, and then selecting "Toggle Ultra Burst."

***

<mark style="background-color:yellow;">**Debug Battle Options**</mark>

While playing in debug mode, you can manually edit the Z-Move or Ultra Burst options for trainers. To do so, open the debug menu while in battle (F9), and navigate to "Trainer options..." where you'll find options to toggle the availability for Z-Moves and Ultra Burst for each trainer.

</details>

<details>

<summary>Player</summary>

<mark style="background-color:yellow;">**Z-Ring**</mark>

To use a Z-Power mechanic yourself, you'll first need to have an item in your inventory that unlocks the ability to use it. Any item given the `ZRing` flag in its PBS data will be considered a Z-Ring, which will allow you to use Z-Power. By default, this plugin adds the Z-Ring introduced in *Pokemon Sun & Moon*, as well as the Z-Power Ring introduced in *Pokemon Ultra Sun & Ultra Moon*. Feel free to create your own custom Z-Ring items, too. Having any one of these items in your inventory will allow you to use both Z-Moves and Ultra Burst.

In addition, while playing in debug mode you may also hold `CTRL` while opening the Fight menu to force the Z-Move or Ultra Burst button to appear even if you have already used either mechanic already during this battle.

***

<mark style="background-color:yellow;">**Held Item**</mark>

In addition to the trainer's Z-Ring, the specific Pokemon that wants to use Z-Power must also be holding a compatible item, like how Mega Evolution works. For Z-Moves, the Pokemon must be holding a compatible Z-Crystal which will upgrade one or more of the moves in their moveset into a Z-Move. More on this is covered in the "Z-Moves" subsection.

For Ultra Burst, the Pokemon must be holding a specific item which allows for Ultra Burst. The specific item can vary from species to species. By default, the only item that allows for Ultra Burst is Ultranecrozium Z, which also doubles as a Z-Crystal to be used by Necrozma. More on this is covered in the "Ultra Burst" subsection.

***

<mark style="background-color:yellow;">**Z-Booster**</mark>

This plugin introduces a completely custom item not found in the original *Pokemon Sun & Moon* called the Z-Booster. This is a unique item that may replenish your Z-Ring during battle, allowing you to use Z-Moves an additional time during the same battle. Using this item in battle uses up the player's entire turn in order to try and keep it (sorta) balanced, so this will use up the turn for all of your Pokemon even if you have more than one Pokemon to issue commands to.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FBTbIbdL0pJmRPMZ23C1e%2Fdemo66.gif?alt=media&#x26;token=6cc66e02-15e7-43fe-aaba-54f8fabd3f0b" alt="" data-size="original">

This is intended to be a "just for fun" item, and not to be used seriously, but it's there if you'd like to make use of it. Note this only replenishes the ability to use Z-Moves, not Ultra Burst.

</details>

<details>

<summary>NPC Trainers</summary>

<mark style="background-color:yellow;">**Trainer Requirements**</mark>

Other trainers may utilize Z-Power too, whether they're opponents or partners. The requirements for this are the same as for the player, they are simply set up differently. Like with the player, the NPC trainer must be given an eligible Z-Ring in their inventory, and the Pokemon who you would like them to use a Z-Power mechanic with must be holding the appropriate compatible item.

If the conditions are met, then the trainer will be able to utilize Z-Power. For Ultra Burst, this will simply happen as soon as the trainer is capable of using it. For Z-Moves however, the trainer will decide to use a Z-Move using the same AI as they would use to decide to use any other move. For example, if a Z-Move would have no effect or deal less damage or be less beneficial than one of their regular moves, the AI is unlikely to select it.

</details>

<details>

<summary>Wild Pokemon</summary>

Z-Power may also be utilized by wild Pokemon, without the need of a trainer or a Z-Ring. These wild battles work a little differently than a standard wild battle.

***

<mark style="background-color:yellow;">**Z-Powered Battles**</mark>

When encountered, a wild Z-Powered Pokemon will immediately gain an aura boost at the start of battle, before any commands can even be entered. This grants the Pokemon +1 in each of its main stats, and grant it the ability to use Z-Moves. When this happens, the Pokemon will become uncatchable until you remove their aura by lowering their HP to a certain threshold (1/6th of their max HP). Any damage dealt by direct attacks cannot exceed this threshold until the wild Pokemon's Z-Powered aura is removed.&#x20;

While this aura is active, the wild Pokemon will be able to use Z-Powered moves as it pleases. Each time it does so, there will be a two turn cooldown before its aura regenerates and its ability to use Z-Moves will be replenished again. This will happen continuously until the Pokemon reaches its damage threshold and its aura fades.

Once this aura is removed however, the Pokemon's raised stats will return to normal and it will become catchable again like a regular wild Pokemon.\
\
To set up battles against wild Z-Powered Pokemon, you may do so by using the <mark style="background-color:green;">"wildZMoves"</mark> Battle Rule.

***

<mark style="background-color:yellow;">**Ultra Battles**</mark>

When encountered, the wild Pokemon will immediately Ultra Burst at the start of battle, before any commands can even be entered. Doing so will also grant them an aura boost, granting them +1 to all of their main stats. When this happens, the Pokemon will become uncatchable until you force them to exit their Ultra Burst form by lowering their HP to a certain threshold (1/6th of their max HP). Any damage dealt by direct attacks cannot exceed this threshold until the wild Pokemon reverts to its original form. If so, the Pokemon's raised stats will return to normal and it will become catchable again like a regular wild Pokemon.\
\
To set up battles against wild Ultra Pokemon, you may do so by using the <mark style="background-color:green;">"wildUltraBurst"</mark> Battle Rule.

***

If the wild Pokemon is ineligible to use the intended Z-Power mechanic for some reason, nothing will happen and the battle will just be a standard wild battle.

</details>

***

<mark style="background-color:orange;">**Z-Power Counts**</mark>

Essentials internally keeps track of a variety of the player's game statistics. One of those statistics is how many times the player has used Mega Evolution. To keep Z-Power in line with this, I've added trackers which will keep count of various statistics related to Z-Moves and Ultra Burst, too.

Below are all of the new statistics tracked by this plugin, and how to call them.

* **Named Z-Move count**\
  This plugin keeps count of how many times the player has used a generic or exclusive Z-Move. This can be called with the script `$stats.named_zmove_count`.<br>
* **Z-Powered status move count**\
  This plugin keeps count of how many times the player has used the Z-Powered version of a status move. This can be called with the script `$stats.status_zmove_count`.<br>
* **Total Z-Move count**\
  This plugin keeps count of how many times the player has used any type of Z-Move, whether it be a generic Z-Move, an exclusive one, or a Z-Powered status move. This can be called with the script `$stats.total_zmove_count`.<br>
* **Wild Z-Power battles won**\
  This plugin keeps count of how many battles the player has won against wild Z-Powered Pokemon. A "win" counts as either defeating or capturing the Pokemon to end the battle. This can be called with the script `$stats.wild_zpower_battles_won`.<br>
* **Ultra Burst count**\
  This plugin keeps count of how many times the player has used Ultra Burst. This can be called with the script `$stats.ultra_burst_count`.<br>
* **Wild Ultra battles won**\
  This plugin keeps count of how many battles the player has won against wild Ultra Pokemon. A "win" counts as either defeating or capturing the Pokemon to end the battle. This can be called with the script `$stats.wild_ultra_battles_won`.

Page 83:

# Z-Power: Z-Moves

A Pokemon may use a Z-Move in battle as long as it's holding a Z-Crystal and has a compatible move for that crystal. Below, I'll explain each variety of Z-Move in detail, as well as cover everything related to Z-Crystals.

***

<mark style="background-color:orange;">**PBS Data**</mark>

Upon installing the plugin for the first time, you *must* recompile your game. This is not an optional step. This will update all of your relevant PBS files with the necessary data. If you're unaware of how to recompile your game, simply hold down the `CTRL` key while the game is loading in debug mode and the game window is in focus.

<details>

<summary>Installation Details</summary>

If done correctly, your game should recompile. However, you will also notice lines of yellow text above the recompiled files, like this:

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F0IcHawR17o6TD4u64EGN%2FCapture.JPG?alt=media&#x26;token=9e3cb452-1c03-4fdf-a2dc-d1396fdad751" alt="Yellow text in the debug console." data-size="original">

This indicates that the appropriate data have been added to the following PBS files:

* `moves.txt`
* `moves_Gen_9_Pack.txt` (if the Gen 9 Pack is installed)

This will only occur the first time you install the plugin. If you for whatever reason ever need to re-apply the data this plugin adds to these PBS files, you can force this to happen again by holding the `SHIFT` key while loading your game in debug mode. This will recompile all your plugins, and the data will be re-added by this plugin as if it was your first time installing.

</details>

In addition to the changes made to existing files, this plugin adds two new PBS files.

* `moves_zpower.txt`\
  This file contains all of the Z-Moves added by this plugin. If you design any new custom Z-Moves, it should be added to this file.<br>
* `items_zpower.txt`\
  This file contains all of the Z-Rings as well as Z-Crystals added by this plugin. If you design any new items of this type, they should be added to this file.

***

<mark style="background-color:orange;">**Z-Crystals**</mark>

Z-Crystals are items used to unlock a Pokemon's Z-Moves when held. However, a Z-Crystal has two different forms in practice. A "bag" form which act as key items that cannot be tossed or sold, and a "hold-able" form, which are disposable and infinite in supply.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fhw9dI09SrL5xAxmtTBFY%2F%5B2024-02-05%5D%2012_17_06.916.png?alt=media&#x26;token=86c01815-ab4d-41c4-8c24-10af5406ab96" alt="" width="384"><figcaption><p>The Z-Crystal pocket in the bag.</p></figcaption></figure>

***

<mark style="background-color:yellow;">**Z-Crystal Pocket**</mark>

Z-Crystals are stored in their own exclusive pocket in the bag. This Z-Crystal pocket will automatically be added to your game. Essentials has 8 bag pockets by default, so the Z-Crystal pocket is assigned to the 9th bag slot to accommodate this, and all graphics provided by this plugin assume that this will be the case. If your bag has more or fewer than 8 pockets, you may have to edit the graphics in the following folders:

* In `Graphics/Icons`...
  * bagPocket9
* In `Graphics/UI/Bag`...
  * bag\_9
  * bag\_9\_f
  * bg\_9

However, if you wish to edit which pocket the Z-Crystal pocket is assigned to, you may do so by opening the plugin settings and setting `ZCRYSTAL_BAG_POCKET` to your desired bag slot number. For example, if you want Z-Crystals to replace the mail pocket, which is pocket number 6 normally, then you would set `ZCRYSTAL_BAG_POCKET = 6`. You don't have to change any of the pocket data for your Z-Crystals in the PBS data, the plugin will always ignore this data and simply assign Z-Crystals to whichever pocket is listed in this setting.

Note however that any time you change this setting, you must recompile your game for the changes to take effect. It's also advised that you clear the player's existing bag of all items with the debug tools afterwards, because it may be necessary to reset the position of all items. You will also have to manually edit your bag pocket sprites to display the correct Z-Crystal pocket icon if you assign the Z-Crystal pocket to anything besides pocket 9.

Another thing to note is that you can also use the `ZCRYSTAL_BAG_POCKET_NAME` setting to assign a different name to the Z-Crystal pocket, if you please. By default, the name of this pocket is simply set to "Z-Crystals."

If you have the [**Bag Screen with interactable Party**](https://www.pokecommunity.com/threads/bag-screen-with-interactable-party-v21.454607/#post-10376289) plugin installed, the bag UI will automatically update to include the Z-Crystal pocket if this pocket is assigned to pocket number 9. If you want to assign this to a different pocket however, you'll have to manually edit your sprites to display the Z-Crystal bag icon for the right pocket.

***

<mark style="background-color:yellow;">**Equipping Z-Crystals**</mark>

Since Z-Crystals are considered key items, they cannot be removed from your bag. This means they cannot simply be given to a Pokemon to hold like a normal held item. Instead, you have to "use" a Z-Crystal like you would other key items, such as the Bicycle. When a Z-Crystal is used, it spawns a shard of itself which can be given to a Pokemon in your party.

If a particular Z-Crystal is compatible with a Pokemon, they will be given a piece of it to hold. Note that you may still have a Pokemon hold a Z-Crystal even if they are not compatible with it, but there will be a message which indicates its incompatibility.

***

<mark style="background-color:yellow;">**Z-Crystal Displays**</mark>

Z-Crystals have two different types of description text to account for the fact that there are slight differences between the "bag" form and "held" form of the items. To display the "bag" description, you may call this as you would with any item by using `Item.description`, where `Item` is the specific item object you want the description of. However, if you want to display the secondary "held" item description, you may do so with `Item.held_description`. Note that if the specific item does not have a held description, the normal description will be displayed instead. So there is no harm calling this with any item.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FhilFmST9PJUG2DWdwGdE%2F%5B2024-02-06%5D%2006_38_00.489.png?alt=media&#x26;token=edaadeb2-2566-4481-bbab-d2df0c8de9ad" alt="" width="384"><figcaption><p>How a held Z-Crystal differs from other held item icons.</p></figcaption></figure>

One last thing to note is that while a Pokemon is holding a Z-Crystal, a Z-Crystal icon will be displayed instead of the usual held item icon. This is similar to how Mega Stones work.

***

<mark style="background-color:orange;">**Z-Moves**</mark>

A Z-Move is a general term for a move that is unlocked when powering up one of the user's base moves with Z-Power. However, there's actually three different varieties of Z-Move, and each one is set up and handled a bit differently.

<details>

<summary>Generic Z-Moves</summary>

Each of the 18 base types in the game have their own corresponding Z-Crystal which transforms any offensive move of that type into a generic Z-Move. For example, when the Z-Crystal Normalium Z is held by a Pokemon, all of its damaging-dealing Normal-type moves can be converted into the Z-Move Breakneck Blitz.

```
[BREAKNECKBLITZ]
Name = Breakneck Blitz
Type = NORMAL
Category = Physical
Power = 1
Accuracy = 0
TotalPP = 1
Target = NearOther
Flags = ZMove_NORMAL,CannotMetronome
Description = The user builds up its momentum using its Z-Power and crashes into the target at full speed.
```

Here's an example of how Breakneck Blitz is set up in the `moves_zpower.txt` PBS file. This is mostly set up like any other move, but there are a few key things to note:

* The category you set for any Z-Move ***doesn't matter***. By default, all of them are set to Physical. However, in practice, what you set doesn't make any difference since the category will always be inherited from the base move, unless it's a status move.
* Generic Z-Moves ***must*** have a Power of 1. This is what allows the move's power to scale depending on what the base move was. For example, if converting a high base power move like Hyper Beam into this Z-Move, it'll have a much higher power than if the base move was Tackle.
* All Z-Moves ***must*** have an Accuracy of 0. This allows it to ignore Accuracy checks.
* All Z-Moves ***must*** have a TotalPP of 1.
* All Z-Moves ***must*** have the `CannotMetronome` flag.
* Generic Z-Moves ***must*** have the `ZMove_TYPE` flag, where `TYPE` is the ID of the specific type of move this Z-Move will replace. This type should ***always*** be the same type as the Z-Move's type.&#x20;

Now that we have an example of a generic Z-Move, we need a specific Z-Crystal which unlocks it.

```
[NORMALIUMZ]
Name = Normalium Z
NamePlural = Normalium Z
Pocket = 9
Price = 0
FieldUse = OnPokemon
Flags = KeyItem,ZCrystal
Move = BREAKNECKBLITZ
Description = It converts Z-Power into crystals that upgrade Normal-type moves to Normal-type Z-Moves.
HeldDescription = This is a crystallized form of Z-Power. It upgrades Normal-type moves to Z-Moves.
```

Above is an example of how Normalium-Z is set up in the `items_zpower.txt` PBS file. This is mostly set up like any other item, but there are a few key things to note:

* Every Z-Crystal ***must*** have `FieldUse = OnPokemon`, so that it may be used from the bag.
* Every Z-Crystal ***must*** have the ID of the specific move it unlocks entered in the `Move` field. This move ***must*** be flagged as a Z-Move.
* Every Z-Crystal ***must*** have the `ZCrystal` flag as well as the `KeyItem` flag.
* Every Z-Crystal is stored in their own exclusive bag `Pocket`. This plugin uses pocket 9 for all Z-Crystals by default. However, whatever is set here in the PBS data actually ***doesn't matter***, because Z-Crystals are hardcoded to automatically fill whatever the last pocket is in the player's bag, which will always be the Z-Crystal pocket.
* Every Z-Crystal ***should*** have a description and a `HeldDescription`. The normal description is used to describe the "master" Z-Crystal when viewed in the bag. The held description is used to describe the individual shard that was spawned from the bag crystal that was given to a Pokemon to hold. This description isn't displayed anywhere by default, but you may use this if you have a custom Summary UI that can display held item descriptions.

</details>

<details>

<summary>Exclusive Z-Moves</summary>

Some Z-Moves are exclusive to certain species when using a particular move. For example, a Snorlax holding the Z-Crystal Snorlium Z may upgrade the move Giga Impact to the Z-Move Pulverizing Pancake.

```
[PULVERIZINGPANCAKE]
Name = Pulverizing Pancake
Type = NORMAL
Category = Physical
Power = 210
Accuracy = 0
TotalPP = 1
Target = NearOther
Flags = ZMove,Contact,CannotMetronome
Description = Snorlax moves its enormous body energetically and attacks the target with full force.
```

Here's an example of how Pulverizing Pancake is set up in the `moves_zpower.txt` PBS file. This is mostly set up like a generic Z-Move, but there are a few key things to note:

* Unlike generic Z-Moves, exclusive Z-Moves ***can*** have a set Power. These moves are not meant to scale their power based on the original move, so you can set whatever power you wish for these moves. If you set it to 1 however, its power will scale like generic Z-Moves do.
* Unlike generic Z-Moves, you ***can*** make an exclusive Z-Move a status move. For example, the Z-Move Extreme Evoboost is a status move even though its base move is Last Resort, which is a damage-dealing move. Make sure to set the `Target` of the Z-Move appropriately if you wish to do this.
* Unlike generic Z-Moves, exclusive Z-Moves ***must*** have the `ZMove` flag without a type ID attached.

Now that we have an example of an exclusive Z-Move, we need a specific Z-Crystal which unlocks it.

```
[SNORLIUMZ]
Name = Snorlium Z
NamePlural = Snorlium Z
Pocket = 9
Price = 0
FieldUse = OnPokemon
Flags = KeyItem,ZCrystal
Move = PULVERIZINGPANCAKE
Description = It converts Z-Power into crystals that upgrade Snorlax's Giga Impact to an exclusive Z-Move.
HeldDescription = This is a crystallized form of Z-Power. It upgrades Snorlax's Giga Impact to a Z-Move.
ZCombo = GIGAIMPACT,SNORLAX
```

Above is an example of how Snorlium Z is set up in the `items_zpower.txt` PBS file. This is mostly set up like a generic Z-Crystal, but there are a few key things to note:

* The `ZCombo` field is ***required*** on Z-Crystals that unlock exclusive Z-Moves. This field must contain at least two entries:
  * The ID of the specific move that acts as the base move for the exclusive Z-Move this Z-Crystal unlocks. This must ***always*** be the first entry on this line.
  * The ID of the specific species that this Z-Crystal is exclusive to. This is usually only one species or form ID, but you can add as many additional ones as you like if this Z-Move should be exclusive to multiple species or forms.
* Exclusive Z-Crystals that should be usable by all forms of the entered species can be given the flag `UsableByAllForms`. This will allow all Pokemon of that species to be compatible with this Z-Crystal, regardless of form.

</details>

<details>

<summary>Z-Powered Status Moves</summary>

Status moves can enjoy benefits from Z-Power even though they aren't converted into a generic or exclusive Z-Move. Instead, status moves are simply powered up to grant additional effects on top of their natural one.&#x20;

For example, if a Normal-type status move like Growl is given Z-Power through the use of Normalium Z, the user will be able to use Z-Growl. This will boost the user's Defense by 1 stage on top of Growl's normal effect.

There are a variety of different possible effects that a status move can be given through Z-Power. Each Z-Powered effect is given to a status move by giving that move a particular flag in its PBS data. Below, I'll list every possible type of Z-Power that may be given to a status move, and the flag that is used to grant that Z-Power.

Each of the below flags are entered as `ZPower_FLAG`, where `FLAG` can be any one of the following:

* `HealUser`\
  When a status move with this flag is used with Z-Power, it will fully restore the HP of the user prior to using its natural effects. For example, using Z-Belly Drum will fully restore the user's HP before using its base effect.<br>
* `HealSwitch`\
  When a status move with this flag is used with Z-Power, it will fully restore the HP of an incoming party member. For example, using Z-Parting Shot will apply an effect on the user's position. Once the user switches out to a new Pokemon due to the effects of Parting Shot, the switched-in Pokemon will trigger the effect and become fully healed.<br>
* `FollowMe`\
  When a status move with this flag is used with Z-Power, it will make the user the center of attention and redirect all attacks to itself as if it used Follow Me. For example, Z-Destiny Bond will force the opponent to direct their attacks at the user upon setting up the Destiny Bond.<br>
* `CriticalHit`\
  When a status move with this flag is used with Z-Power, it will boost the user's critical hit ratio by two stages, as if it's under the Focus Energy effect. For example, using Z-Tailwind will grant the user +2 critical hit stages on top of its normal effects.<br>
* `ResetStats`\
  When a status move with this flag is used with Z-Power, it will neutralize any of the user's lowered stat stages. For example, using Z-Recover will return all of the user's lowered stats to normal on top of its normal healing effect.<br>
* <mark style="background-color:yellow;">Stat Boosting Flags</mark>\
  In addition to the above flags, you may also set up a Z-Power flag that boosts the user's stats by a number of stages. Each stat ID is a valid flag, which is then followed by the number of stages.\
  \
  For example, the move Splash has the flag `ZPower_ATTACK_3`. This means when you use Z-Splash, the move will grant +3 Attack. You can do this for any stat which can be raised in battle, including `ACCURACY` and `EVASION`.\
  \
  Finally, if you would like a Z-Powered status move to raise all of the user's main stats a number of stages, you may do so by using `AllStats` instead of a stat ID. For example, the move Celebrate has the flag `ZPower_AllStats_1`. This means using Z-Celebrate will raise all of the user's main stats by 1 stage each.

***

Every official status move in Essentials has been given one of the Z-Power flags described above to make them function as they did in *Pokemon Sun & Moon*. For any new moves introduced in later gens that don't have any official Z-Powered effects, they were given flags that makes the most sense for that move to have by looking at the Z-Powered effects that similar moves were given.

For example, the move Obstruct did not exist in Sun & Moon. However, it has been given the flag `ZPower_ResetStats` in this plugin because all Protect-like moves had this Z-Powered effect in Sun & Moon, so it's safe to assume Obstruct would have worked the same if it existed at that time.

However, there are a handful of rare status moves that are exempt from being given any Z-Powered effects. The following status moves were not given any Z-Power flags:

* Healing Wish
* Lunar Dance
* Metronome
* Nature Power
* Assist

This is due to the specific ways in which these moves work. The moves Healing Wish and Lunar Dance do not grant any Z-Powered effects simply because any effects that these moves could be given would be entirely irrelevant. Boosting the user in some way is pointless, since the moves force the user to faint anyway. For the other listed moves, the reason they don't grant any effects is because these moves simply use the Z-Powered versions of the moves that they call. For example, if Nature Power calls the move Tri Attack, it will simply use the generic Normal-type Z-Move instead, Breakneck Blitz.

</details>

<details>

<summary>Coding custom Z-Move effects</summary>

If you decide you want to create your own custom Z-Moves that have some sort of effect, this is done the same way you would code the move function for any other regular move. However, there is one key difference. A typical battle move is defined in the class `Battle::Move`. Z-Moves however use a subclass of this called `Battle::ZMove`.

This means that when you are coding a move function, this is the class you need to use, rather than `Battle::Move`. For example, here's the move function for the Z-Move Genesis Supernova, which sets up Psychic Terrain after dealing damage:

<pre class="language-ruby"><code class="lang-ruby"><strong>class Battle::ZMove::DamageTargetStartPsychicTerrain &#x3C; Battle::Move
</strong>  def pbAdditionalEffect(user, target)
    @battle.pbStartTerrain(user, :Psychic)
  end
end
</code></pre>

You'll see that `class Battle::ZMove` is what's used here prior to the move's function code. This is required for Z-Moves. However, Z-Moves can access everything from the normal `Battle::Move` class, so you can still use this as a subclass as needed.

Because of this, it's possible to just inherit all of the attributes of a regular move's function code. For example, this is what the function for the Z-Move Searing Sunrise Smash looks like, which has the effect of ignoring the target's ability:

```ruby
class Battle::ZMove::IgnoreTargetAbility < Battle::Move::IgnoreTargetAbility
end
```

You'll notice that no actual code is required for this function code. That's because `Battle::ZMove::IgnoreTargetAbility` simply inherits all of the same functionality as the base `Battle::Move` version, so there's no reason to rewrite any of the code. You can simply set the function for the base move as the subclass for this Z-Move to inherit all of its features.

It's worth keeping the above in mind when coding your own Z-Moves, as this can save you a lot of extra redundant work.

</details>

Page 84:

# Z-Power: Ultra Burst

Ultra Burst is a unique form-changing mechanic similar to Mega Evolution which only Necrozma has access to when in its Dusk Mane or Dawn Wings form. This mechanic is interwoven with the Z-Power phenomenon, as the item that Necrozma requires to enter Ultra Burst form is also a Z-Crystal which allows it to use its exclusive Z-Move, Light That Burns the Sky.

<figure><img src="https://i.imgur.com/JSGpTBu.gif" alt="" width="375"><figcaption><p>Necrozma changing forms with Ultra Burst.</p></figcaption></figure>

The Ultra Burst mechanic has been replicated by this plugin. However, the mechanic has been generalized so that it's possible for it to be utilized by other species besides Necrozma. Below, I'll explain how Ultra Burst forms can be set up.

***

<mark style="background-color:orange;">**Ultra Item**</mark>

For a Pokemon to enter Ultra Burst form, it needs to be holding a compatible item that allows for it to Ultra Burst. Let's make a custom item to allow Charizard to enter an Ultra Burst form, because Charizard can always use *more* forms, right?

```
[ULTRAZARDIUM]
Name = Ultrazardium
NamePlural = Ultrazardiums
Pocket = 1
Price = 0
Description = When held by Charizard, it can enter Ultra Burst form!
```

Here, we've created a new item called Ultrazardium. This is a normal held item that appears in the primary bag slot. Nothing special needs to be set for this item. It just needs to be capable of being held by a Pokemon.

***

<mark style="background-color:orange;">**Ultra Form**</mark>

Once you have your item set, next you need to create the actual form that you want your Pokemon to Ultra Burst into. For the sake of example, let's make Charizard's Ultra form use form 4.

So in `pokemon_forms.txt`, we would enter our new Ultra form for Charizard. This form can have whatever properties you want, like any other form would. Different stats, different typing, etc. However, to allow Charizard to actually enter this form via Ultra Burst, we'll need to code our own Multiple Forms handler.

To do so, you can open your Essentials script and place this at the bottom of the `FormHandlers` section.

```ruby
MultipleForms.register(:CHARIZARD, {
  "getUltraForm" => proc { |pkmn|
    next 4
  },
  "getUnUltraForm" => proc { |pkmn|
    next 0
  },
  "getUltraItem" => proc { |pkmn|
    next :ULTRAZARDIUM if pkmn.form == 0
  }
})
```

* The `"getUltraForm"` key determines which form Charizard will transform into when it uses Ultra Burst. The line `next 4` makes it so in this scenario, Charizard will change into form 4 when it Ultra Bursts, which is the form that we entered in `pokemon_forms.txt`.
* The `"getUnUltraForm"` key determines which form Charizard should revert to once Ultra Burst ends. The line `next 0` makes it so in this scenario, Charizard will revert to its base form when it leaves Ultra Burst form.
* The `"getUltraItem"` key determines which held item should be checked for in order for Charizard to be eligible to Ultra Burst. The line `next :ULTRAZARDIUM` makes it so in this scenario, Charizard will only be capable of using Ultra Burst while it holds the new item we made earlier, Ultrazardium. The `if form == 0` on this line ensures that this is only checked for when Charizard is in its base form, to prevent other forms of Charizard from using Ultra Burst.

Now, whenever Charizard enters battle in its base form while holding an Ultrazardium, it'll be able to use Ultra Burst to enter its Ultra Burst form. This is a very simplistic example, but it gets the idea across. You can expand upon this from here and make something far more complex with multiple different forms that are capable of using Ultra Burst if you wish, like how Necrozma works.

{% hint style="warning" %} <mark style="color:orange;">**Important!**</mark>\
If the species you want to make an Ultra form for already has an existing multiple forms handler elsewhere, the two handlers may overwrite one another. You can't have more than one handler for a single species at a time. Use CTRL + F to search the `FormHandlers` script for the species you want to make a form for first, to make sure an existing handler isn't already present.

If a handler does already exist, you'll have to add your Ultra form keys to the existing handler, instead of making a new one.
{% endhint %}

***

<mark style="background-color:orange;">**Pokedex Data Page Compatibility**</mark>

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fo0c3zS580l8C7wHU6PJj%2F%5B2024-02-05%5D%2012_11_30.726.png?alt=media&#x26;token=0f4ad5c3-ed42-471d-881a-badcc730d3b5" alt="" width="384"><figcaption><p>The Data page for Ultra Necrozma.</p></figcaption></figure>

The [**Pokedex Data Page**](https://www.pokecommunity.com/threads/in-depth-pokedex-data-page-v21-1.500459/#post-10659145) plugin allows for Ultra Burst Forms to have unique displays in the data page of the Pokedex. If you'd like your custom Ultra form to be displayed in this way too, you can add an additional key to the form handler. Let's build off of the example above to demonstrate this.

```ruby
MultipleForms.register(:CHARIZARD, {
  "getUltraForm" => proc { |pkmn|
    next 4
  },
  "getUnUltraForm" => proc { |pkmn|
    next 0
  },
  "getUltraItem" => proc { |pkmn|
    next :ULTRAZARDIUM if pkmn.form == 0
  },
  "getDataPageInfo" => proc { |pkmn|
    next [pkmn.form, 0, :ULTRAZARDIUM] if pkmn.form == 4
  }
})
```

Here, we've added a third key called `"getDataPageInfo"`. This is what is needed for compatibility with the data page. The array in `next [pkmn.form, 0, :ULTRAZARDIUM]` needs to contain three elements:

* The Pokemon's current form. This can always just be set as `pkmn.form` to accomplish this.
* The form that the Pokemon reverts to once Ultra Burst ends. In our example, this is form 0.
* The ID of the Ultra item required for this Pokemon to Ultra Burst.

Finally, the `if pkmn.form == 4` part of the line makes it so that this information is only returned when Charizard is in form 4, which is its Ultra Burst form. This is what prevents this data from displaying when viewing any one of Charizard's other forms. This might be far more complex depending on the specific form handler you set up, but this is a general example of how this may be done.&#x20;

Page 85:

# Z-Power: Animations

The Deluxe Battle Kit incorporates various animation utilities which it uses to animate Mega Evolution and Primal Reversion. This plugin utilizes these same utilities to implement new animations for both Z-Moves and Ultra Burst that are built in the same animation style.

There's a bit to explain about these animations and how they work, so I'll provide a break down of everything in this section.

{% hint style="info" %}
Note: If you already have an existing Z-Move animation which is stored as a Common animation named `"ZMove"`, that animation will take priority over the animation added by this plugin. The same is true for the Ultra Burst animation if a common animation named `"UltraBurst"` exists. This means that there's no risk of your animations being overwritten or ignored, nor do you need to change anything to make this plugin compatible.
{% endhint %}

***

<mark style="background-color:orange;">**Trainer Z-Power**</mark>

<mark style="background-color:yellow;">**Z-Moves**</mark>

Z-Moves typically require a trainer with a Z-Ring and a Pokemon holding a compatible Z-Crystal. If so, the option to use the Z-Powered version of the Pokemon's moves will appear in battle. When a compatible move is selected, the Z-Move animation will play.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FqHLkii1aKGE15G3JHaGH%2Fdemo62.gif?alt=media&#x26;token=ca9170df-c3d4-46c0-9b55-478a618c4555" alt="" width="381"><figcaption><p>A Z-Move being triggered on the player's side.</p></figcaption></figure>

There will be slight differences in the animation based on which side of the field the Pokemon using the Z-Move is on. Pokemon on the player's side of the field will face right, and their trainer will slide in from off screen on the left. If the Pokemon is on the opponent's side of the field, they will face left and their trainer will slide in from off screen on the right. This helps distinguish if the Z-Move is being used by friend or foe during the animation.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FGeT26UkCoDnZnWErf2EY%2Fdemo63.gif?alt=media&#x26;token=3aea34be-c6d3-4aeb-ae9b-54088d6c3645" alt="" width="381"><figcaption><p>A Z-Move being triggered on the opponent's side.</p></figcaption></figure>

Z-Move animations will always display the trainer's Z-Ring above the trainer during the animation. The trainer's item may not always be the same, however. The Z-Ring is the default item used, but it's possible to give trainers unique items that trigger Z-Power. If you create unique Z-Power items for a trainer to utilize along with the necessary sprites, then the sprite for that unique item will appear in this animation instead of the default Z-Ring.

***

<mark style="background-color:yellow;">**Z-Move Titles**</mark>

![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FCrpuC7ymi2mdWKTE9lZQ%2F%5B2024-02-05%5D%2012_54_54.383.png?alt=media\&token=dd70e6e5-e46c-47a0-9029-2f5afc3b7061)  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fhq9Gn3y8Ndo4tkCXi3Vj%2F%5B2024-02-05%5D%2012_55_06.134.png?alt=media\&token=7b8f8ea5-a822-450e-82d6-27c327bcb8c7)

Each generic and exclusive Z-Move has its own title, and will display this as part of the Z-Move animation if a graphic for that Z-Move's title is available. These titles are stored in `Graphics/Plugins/Deluxe Battle Kit/Z-Power/Z-Titles`. The filename for each title is the same as that Z-Move's ID in its PBS data. If you design a custom Z-Move and wish to design a title for that Z-Move to appear on screen during the Z-Move animation, you may add the graphic for that title here. The animation will automatically recognize it, so no coding is required to make it appear.

Note that Z-Powered status moves do not display titles during this animation.

***

<mark style="background-color:yellow;">**Ultra Burst**</mark>

As with Z-Moves, triggering Ultra Burst typically requires a trainer with a Z-Ring, and a Pokemon holding an item that allows for it to Ultra Burst. If so, the option to use Ultra Burst will appear in battle. When selected, the Ultra Burst animation will play.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FAZgkQyqZi43e2cZHFH4Y%2Fdemo61.gif?alt=media&#x26;token=91d99368-e273-4b10-8b84-b547382ed039" alt="" width="381"><figcaption><p>Necrozma using Ultra Burst.</p></figcaption></figure>

Unlike with the Z-Move animation however, the trainer will not appear on screen during the Ultra Burst animation. This is because the trainer is not involved in the Ultra Burst process, unlike with other mechanics such as Mega Evolution and Z-Moves. At least, that is what is implied by the Ultra Burst animation in *Pokemon Ultra Sun & Ultra Moon*, where the trainer never appears during the animation. Despite this, the Pokemon using Ultra Burst will still face either to the right or the left depending on whether they are on the player's or opponent's side, respectively.

***

<mark style="background-color:orange;">**Wild Z-Power**</mark>

Typically, wild Pokemon are incapable of using Z-Power. This is because a trainer with a corresponding Z-Ring is required. However, this plugin includes a feature that allows wild Pokemon to use Z-Power on their own without a trainer, by utilizing the <mark style="background-color:green;">"wildZMove"</mark> Battle Rule to allow for Z-Moves, or <mark style="background-color:green;">"wildUltraBurst"</mark> to allow for Ultra Burst (more details on this can be found in the "Z-Power: Battle Rules" subsection). This bypasses the Z-Ring requirement, allowing the wild Pokemon to use Z-Power.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FqZFRR8RqE7ZeDYVp1im5%2Fdemo64.gif?alt=media&#x26;token=3f1ffeda-7ab2-46d4-8597-969911c370cf" alt="" width="381"><figcaption><p>Z-Move animation when used by a wild Pokemon.</p></figcaption></figure>

The animations for Z-Moves is mostly the same when used by wild Pokemon. The only obvious difference is that no trainer slides on screen during the animation, since no trainer exists. The wild Ultra Burst animation however is identical to the normal Ultra Burst animation, since no trainer slides on screen for that animation regardless.

***

<mark style="background-color:orange;">**Animation Utilities**</mark>

<mark style="background-color:yellow;">**Skipping Animations**</mark>

You may have noticed in the examples above that during the Z-Power animations a button prompt on the bottom left-hand corner of the screen appears. This "skip" button indicates that you can cut the animation short by pressing the `ACTION` key. Pressing it will immediately end the animation, allowing you to get right back to the battle if you grow tired of sitting through these animations.

<mark style="background-color:yellow;">**Turning Off Animations**</mark>

If you want to turn these animations off entirely, there are two ways to accomplish this. First, you may do so by turning off battle animations completely in the Options menu.&#x20;

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FwOMVVwf7z58G4TSKSGM6%2F%5B2024-01-12%5D%2011_58_20.948.png?alt=media&#x26;token=36cd6063-28d1-4886-9f6e-49bbf7642b8f" alt="" width="384"><figcaption><p>Battle animations in the Options menu.</p></figcaption></figure>

If so, this animation will also be turned off. For Z-Moves, this will disable the entire animation the same way that all move animations are disabled. For Ultra Burst however, it will instead be replaced with a generic "quick-change" animation which happens instantaneously.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F5fqvXNoaX7lcYW91EDQx%2Fdemo65.gif?alt=media&#x26;token=44364e14-7124-4688-82a3-0617eaec0060" alt="" width="381"><figcaption><p>Quick-change animation.</p></figcaption></figure>

The second way to turn off the animations would be to open the settings file in this plugin. Here, you'll find the settings `SHOW_ZMOVE_ANIM` and `SHOW_ULTRA_ANIM`. If you set these to `false`,  this will permanently shut off the animations for Z-Moves and Ultra Burst, respectively. For Ultra Burst, the quick-change animation above will still be used however, even when battle animations are turned on.

***

<mark style="background-color:orange;">**Ultra Icon**</mark>

When a Pokemon is in Ultra Burst form, and icon will be displayed next to their databoxe to indicate this. This is similar to icons for other mechanics such as Mega Evolution and Primal Reversion.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FJsqjefrZrQgpXQW1FNnB%2F%5B2024-02-05%5D%2012_35_27.989.png?alt=media&#x26;token=55e5592d-dc65-4d34-9226-7f212910b0ed" alt="" width="384"><figcaption><p>Example of the Ultra Burst icon.</p></figcaption></figure>

Page 86:

# Z-Power: Battle Rules

These are new battle rules added by this plugin related to Z-Power.

<details>

<summary><mark style="background-color:green;">"wildZMoves"</mark></summary>

You can use this rule to flag wild Pokemon encountered in this battle as capable of using Z-Powered moves, even though they don't have a trainer with a Z-Ring. Wild Z-Powered Pokemon will gain an aura boost which grants them +1 to each of their main stats immediately upon being encountered, prior to any commands even being entered. The Z-Powered Pokemon will then be able to use Z-Moves for the duration of this battle. Every two turns after the wild Pokemon used a Z-Move, their aura will regenerate their Z-Power, allowing them to use another Z-Move. This will persist until the Z-Powered Pokemon reaches a damage threshold where its aura fades.

The <mark style="background-color:green;">"midbattleScript"</mark> Battle Rule is ignored when this rule is enabled, since these battles use their own midbattle script to apply damage thresholds on the Z-Powered Pokemon.&#x20;

This is entered as `setBattleRule("wildZMoves")`

When this rule is enabled, the <mark style="background-color:green;">"disablePokeBalls"</mark> Battle Rule id also enabled. This will persist until the wild Z-Powered Pokemon reaches its damage threshold and its Z-Powered aura fades. After which, Poke Balls will become useable again.

If the SOS Battles plugin is installed, the <mark style="background-color:green;">"SOSBattle"</mark> and <mark style="background-color:green;">"totemBattle"</mark> rules are ignored and turned turned off for this battle.

</details>

<details>

<summary><mark style="background-color:green;">"noZMoves"</mark></summary>

You can use this rule to disable the ability to use Z-Moves for certain trainers in this battle, even if they meet all the criteria otherwise. You can disable this for the player's side of the field, the opponent's, or for all trainers.\
\
This is entered as `setBattleRule("noZMoves", Symbol)`, where "Symbol" can be any one of the following:

* <mark style="background-color:yellow;">:Player</mark>\
  All trainers on the player's side will be unable to use Z-Moves.
* <mark style="background-color:yellow;">:Opponent</mark>\
  All trainers on the opponent's side will be unable to use Z-Moves.
* <mark style="background-color:yellow;">:All</mark>\
  All trainers on both sides in this battle will be unable to use Z-Moves.

</details>

<details>

<summary><mark style="background-color:green;">"wildUltraBurst"</mark></summary>

You can use this rule to flag wild Pokemon encountered in this battle as capable of using Ultra Burst, even though they don't have a trainer with a Z-Ring. Wild Pokemon will always Ultra Burst immediately upon being encountered, prior to any commands even being entered. If so, the Ultra Pokemon will gain an aura boost, which grants them +1 to each of their main stats. The <mark style="background-color:green;">"midbattleScript"</mark> Battle Rule is ignored when this rule is enabled, since wild Ultra Battles use their own midbattle script to apply damage thresholds on the Ultra Pokemon.&#x20;

This is entered as `setBattleRule("wildUltraBurst")`

When this rule is enabled, the <mark style="background-color:green;">"disablePokeBalls"</mark> Battle Rule id also enabled. This will persist until the wild Ultra Pokemon reaches its damage threshold and its Ultra Burst state ends. After which, Poke Balls will become useable again.

If the SOS Battles plugin is installed, the <mark style="background-color:green;">"SOSBattle"</mark> and <mark style="background-color:green;">"totemBattle"</mark> rules are ignored and turned turned off for this battle.

</details>

<details>

<summary><mark style="background-color:green;">"noUltraBurst"</mark></summary>

You can use this rule to disable the ability to use Ultra Burst for certain trainers in this battle, even if they meet all the criteria otherwise. You can disable this for the player's side of the field, the opponent's, or for all trainers.\
\
This is entered as `setBattleRule("noUltraBurst", Symbol)`, where "Symbol" can be any one of the following:

* <mark style="background-color:yellow;">:Player</mark>\
  All trainers on the player's side will be unable to use Ultra Burst.
* <mark style="background-color:yellow;">:Opponent</mark>\
  All trainers on the opponent's side will be unable to use Ultra Burst.
* <mark style="background-color:yellow;">:All</mark>\
  All trainers on both sides in this battle will be unable to use Ultra Burst.

</details>

Page 87:

# Z-Power: Mid-Battle Scripting

This plugin adds various new keys to be used by the Deluxe Battle Kit's mid-battle scripting functionality.

***

<mark style="background-color:orange;">**Trigger Keys**</mark>

These are keys which trigger upon a battler utilizing Z-Power or its various mechanics.

* <mark style="background-color:purple;">**"BeforeZMove"**</mark>\
  Triggers right before a battler's selected generic or exclusive Z-Move is about to be executed.<br>
* <mark style="background-color:purple;">**"BeforeZStatus"**</mark>\
  Triggers right before a battler's selected Z-Powered status move is about to be executed.

{% hint style="info" %}
Trigger Extensions: You may extend these keys with a species ID or type ID to specify that they should only trigger when a specific species is about to use a Z-Powered move, or when a Z-Powered move of a specific type is about to be used. For example, <mark style="background-color:purple;">"BeforeZMove\_RAICHU"</mark> would trigger only when a Raichu is about to use a Z-Move, where <mark style="background-color:purple;">"BeforeZStatus\_PSYCHIC"</mark> would trigger only when a Psychic-type status move is about to be used with a Z-Powered effect.

Both triggers also accept an ID of a specific move as well, for example <mark style="background-color:purple;">"BeforeZMove\_CATASTROPIKA"</mark> would only trigger when the Z-Move Catastropika is about to be used, while <mark style="background-color:purple;">"BeforeZStatus\_MEMENTO"</mark> would only trigger when the move Memento is about to be used with a Z-Powered effect.&#x20;
{% endhint %}

* <mark style="background-color:purple;">**"BeforeUltraBurst"**</mark>\
  Triggers when a battler is going to use Ultra Burst this turn, but before that Pokemon actually Ultra Bursts.<br>
* <mark style="background-color:purple;">**"AfterUltraBurst"**</mark>\
  Triggers after a battler successfully uses Ultra Burst.

{% hint style="info" %}
Trigger Extensions: You may extend these keys with a species ID or a type ID to specify that they should only trigger when a specific species or species of a specific type triggers Ultra Burst. For example, <mark style="background-color:purple;">"BeforeUltraBurst\_NECROZMA"</mark> would trigger only when a Necrozma is about to Ultra Burst, where <mark style="background-color:purple;">"AfterUltraBurst\_DRAGON"</mark> would trigger only after a Pokemon has become a Dragon-type after using Ultra Burst.
{% endhint %}

***

<mark style="background-color:orange;">**Command Keys**</mark>

These are keys which trigger certain actions related to Z-Powered mechanics to take place during battle, such as forcing a trainer to use a Z-Move, or disabling Ultra Burst.

<details>

<summary><mark style="background-color:blue;">"useZMove"</mark> => <mark style="background-color:yellow;">Boolean or String</mark></summary>

Forces the battler to use a Z-Move when set to `true`, as long as they are able to. If set to a string instead, you can customize a message that will display upon this Z-Move triggering. Note that this can even be used to force a wild Pokemon to use a Z-Move, as long as they are capable of it.\
\
Like with using Z-Moves naturally, you can only use this to force a Pokemon to use a Z-Move prior to them using their move that turn. So setting this to happen at the end of a round for example would do nothing, since the Pokemon's move has already been executed by that point. Because of this, you can only really use this key during the actual battle phase prior to the Pokemon executing its move, such as with the <mark style="background-color:purple;">"RoundStartAttack"</mark> or <mark style="background-color:purple;">"TurnStart"</mark> Trigger Keys. This also won't do anything if a different action with this battler has been chosen, such as switching it out or using an item.

Also note that you cannot use this to control which Z-Move the selected Pokemon will use, just that it will use the Z-Powered version of whatever normal move it has selected if it's possible to do so. You can combine this with the <mark style="background-color:blue;">"useMove"</mark> Command Key however to first select the specific base move the Pokemon should use, and then use <mark style="background-color:blue;">"useZMove"</mark> to convert that base move into its Z-Move equivalent.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"disableZMoves"</strong></mark> => <mark style="background-color:yellow;">Boolean</mark></summary>

Toggles the availability of Z-Moves for the owner of the battler. If set to `true`, Z-Moves will be disabled for this trainer. If set to `false`, Z-Moves will no longer be disabled, allowing this trainer to use it again even if they've already used a Z-Move prior in this battle.

</details>

<details>

<summary><mark style="background-color:blue;">"ultraBurst"</mark> => <mark style="background-color:yellow;">Boolean or String</mark></summary>

Forces the battler to Ultra Burst their Pokemon when set to `true`, as long as they are able to. If set to a string instead, you can customize a message that will display upon this Ultra Burst triggering. Note that this can even be used to force a wild Pokemon to Ultra Burst, as long as they are capable of it.\
\
Unlike using Ultra Burst naturally, you can use this to force it to happen at any point in battle, even at the end of the turn or after the battler has already attacked. This cannot happen if a different action with this battler has been chosen however, such as switching it out or using an item.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"disableUltra"</strong></mark> => <mark style="background-color:yellow;">Boolean</mark></summary>

Toggles the availability of Ultra Burst for the owner of the battler. If set to `true`, Ultra Burst will be disabled for this trainer. If set to `false`, Ultra Burst will no longer be disabled, allowing this trainer to use it again even if they've already used Ultra Burst prior in this battle.

</details>

***

<mark style="background-color:orange;">**Hardcoding**</mark>

Here's a list of methods and/or properties that you might want to reference when hardcoding a midbattle script, since this plugin adds a lot of new custom content which you may need to call on to make certain things happen:

<details>

<summary>Battle Class</summary>

* `pbHasZRing?(idxBattler)`\
  Returns true if the trainer who owns the battler at index `idxBattler` has an item in their inventory flagged as a Z-Ring.<br>
* `pbGetZRingName(idxBattler)`\
  Returns the name of the specific item in a trainer's inventory flagged as a Z-Ring. The specific trainer's inventory checked for is the one who owns the battler at index `idxBattler`.
* `pbCanZMove?(idxBattler)`\
  Returns true if the battler at index `idxBattler` is capable of using a Z-Move.<br>
* `pbCanUltraBurst?(idxBattler)`\
  Returns true if the battler at index `idxBattler` is capable of using Ultra Burst.<br>
* `pbUltraBurst(idxBattler)`\
  Begins the Ultra Burst process for the battler at index `idxBattler`.

</details>

<details>

<summary>Battle::Battler Class</summary>

* `hasZMove?`\
  Returns true if this battler has a compatible Z-Move and is capable of using it.<br>
* `hasCompatibleZMove?(baseMove)`\
  Returns true if this battler has a compatible Z-Move. If `baseMove` is set to a specific battle move, this returns true only if the battler is capable of converting it into a compatible Z-Move. If `baseMove` is omitted or set as nil, this returns true if any move in the battler's moveset can be successfully converted into a compatible Z-Move.<br>
* `display_zmoves`\
  This converts all of the battler's moves into their compatible Z-Move equivalents. This can also be used to display Z-Moves in the player's Fight menu.<br>
* `ultra?`\
  Returns true if this battler is in Ultra Burst form.
* `hasUltra?`\
  Returns true if this battler is capable of using Ultra Burst.<br>
* `unUltra`\
  Forces a battler's Ultra Burst state to end, and reverts them back to their original form.

</details>

Page 88:

# Dynamax

[**Eevee Expo Link**](https://eeveeexpo.com/resources/1495/)

[**PokeCommunity Link**](https://www.pokecommunity.com/threads/dynamax-dbk-add-on-v21-1.526509/#post-10803103)

[**Download Link**](https://www.mediafire.com/file/qfd3hd9xj2nj7g2/Dynamax.zip/file)

This plugin builds upon the Deluxe Battle Kit to add the Dynamax mechanic introduced in *Pokemon Sword & Shield*. All functionality for this mechanic has been replicated in this plugin, and will work along side other battle gimmicks such as Mega Evolution without issue. In the following subsections, I'll go over specific areas of this plugin in more detail. Below, I'll go over general plugin functionality.

***

<mark style="background-color:orange;">**Dynamax Availability**</mark>

Once this plugin is installed, Dynamax will be available to use right out of the gate. However, there are some criteria that must be met in order for the option to use it to appear in battle. Below I'll go over all the factors for Dynamax eligibility, how to disable its availability, and various other settings related to its use.

<details>

<summary>General</summary>

Dynamax is available by default after installation. However, if you would like to disable the Dynamax mechanic entirely at any point, you may do so by using a game switch.&#x20;

In the plugin settings, there is a setting named `NO_DYNAMAX` which stores the switch number used for disabling Dynamax. This is saved as switch number `66` by default, but please renumber this if this conflicts with an existing game switch that you use.

If this switch is turned on, then Dynamax will be disabled for all trainers and Pokemon until the switch is turned back off. If you're playing in debug mode, you can easily toggle this switch on and off by going into the debug menu and opening the "Deluxe plugin settings..." menu, and then selecting "Toggle Dynamax."

***

<mark style="background-color:yellow;">**Map Eligibility**</mark>

Unlike other battle gimmicks, Dynamax is unique in that it is only available while the user is near a Power Spot. A Power Spot is a special area where Dynamax energy is present for Pokemon to draw from. In Sword & Shield, Power Spots were limited to battle arenas (where the Gyms, Battle Tower, and Pokemon League were built upon) and raid dens.

To emulate this mechanic, this plugin allows you to give any map the `PowerSpot` flag in its metadata in the `map_metadata.txt` PBS file. Any map given this flag will be considered a Power Spot, and allow for Dynamax to be used during battle. By default, this plugin will automatically flag the following Essentials example maps as Power Spots:

* Cedolan Gym (map 10)
* Pokémon League (map 37)
* Battle Tower (map 56)
* Battle Palace (map 59)
* Battle Arena (map 61)
* Battle Factory (map 64)

If you would like to make Dynamax a universal mechanic that can be used on any map, then instead of using map flags, you may simply turn on a switch to enable this. In the plugin settings, there is a setting named `DYNAMAX_ON_ANY_MAP` which stores the switch number used to automatically consider all maps in the game as Power Spots. This is saved as switch number `67` by default, but please renumber this is this conflicts with an existing game switch that you use.

If this switch is turned on, every map will be considered a Power Spot, and thus support Dynamax. If you're playing in debug mode, you can easily toggle this switch on and off by going into the debug menu and opening the "Deluxe plugin settings..." menu, and then selecting the toggle within the "Dynamax settings..." menu.

***

<mark style="background-color:yellow;">**Battle Eligibility**</mark>

By default, Dynamax is a mechanic that may only be used by a trainer during trainer battles or raids. It cannot normally be used during regular wild battles, just as it functioned in Sword & Shield. However, this plugin can allow you to enable Dynamax for wild battles through the use of a switch.

In the plugin settings, there is a setting named `DYNAMAX_IN_WILD_BATTLES` which stores the switch number used for enabling Dynamax during wild battles. This is saved as switch number `68` by default, but please renumber this is this conflicts with an existing game switch that you use.

If this switch is turned on, then Dynamax will be available for any trainer on the player's side during wild battles, as long as all other conditions required for Dynamax are met. If you're playing in debug mode, you can easily toggle this switch on and off by going into the debug menu and opening the "Deluxe plugin settings..." menu, and then selecting the toggle within the "Dynamax settings..." menu.

***

<mark style="background-color:yellow;">**Pokemon Requirements**</mark>

By default, all Pokemon are capable of using Dynamax if all the necessary requirements to utilize the mechanic are met. However, there are some exceptions. The following are all of the reasons why a Pokemon may be unable to use Dynamax:

* The Pokemon is a Shadow Pokemon.
* The Pokemon is already Dynamaxed.
* The Pokemon is in Mega form, or meets all the criteria for Mega Evolution.
* The Pokemon is in Primal form, or meets all the criteria for Primal Reversion.
* The Pokemon is holding a Z-Crystal and is capable of using an eligible Z-Move.
* The Pokemon is in Ultra Burst form, or meets all the criteria for Ultra Burst.
* The Pokemon is Terastallized.
* The Pokemon is currently the host of another Pokemon with the Commander ability.
* The Pokemon has been manually flagged as unable to use Dynamax.
* The Pokemon is a member of a species that has been given the `CannotDynamax` flag in its PBS data. By default, Zacian & Zamazenta will always have this flag.

Note that if a Pokemon is copying the appearance of another species who cannot Dynamax (such as Zacian or Zamazenta) through effects such as Transform, Imposter, or Illusion, then the transformed Pokemon will also be unable to Dynamax. This is also true if transformed into a species that may only Dynamax by entering a special Eternamax form, such as Eternatus.

If you would like to flag a specific Pokemon as unable to use Dynamax, you may do so by setting `Pokemon.dynamax_able = false`, where `Pokemon` is the specific Pokemon object that you'd like to flag.&#x20;

While playing in debug mode, this can also be done for the player's Pokemon by opening a Pokemon's debug options and selecting "Plugin attributes..." at the bottom of the list, and then selecting "Dynamax..." From here, you can select "Set eligibility" to toggle the Pokemon's ability to use Dynamax.&#x20;

If you would like to flag an entire species as unable to use Dynamax instead of just a specific Pokemon, you may also do this by giving that species the `CannotDynamax` flag in its PBS data.

Note that in any case where a Pokemon is unable to use Dynamax, it will be considered as having no Dynamax Level or G-Max Factor, and so this will be hidden from all displays that would show this information.

***

<mark style="background-color:yellow;">**Debug Battle Options**</mark>

While playing in debug mode, you can manually edit Dynamax options for trainers and Pokemon. To do so, open the debug menu while in battle (F9), and navigate to "Trainer options..." and then "Dynamax." You'll be able to toggle Dynamax availability for each trainer from here.

If you'd like to edit the Dynamax attributes of specific battlers or party members, you may also do this by navigating to a specific Pokemon from the "Battlers..." or "Pokemon teams" options, and then scrolling down to the "Dynamax values" option for that Pokemon.

</details>

<details>

<summary>Player</summary>

<mark style="background-color:yellow;">**Dynamax Band**</mark>

To use the Dynamax mechanic yourself, you'll first need to have an item in your inventory that unlocks the ability to use it. Any item given the `DynamaxBand` flag in its PBS data will be considered a Dynamax Band, which will allow you to use Dynamax. By default, this plugin adds the Dynamax Band introduced in *Pokemon Sword & Shield*. Feel free to create your own custom Dynamax Band items, too.

In addition, while playing in debug mode you may also hold `CTRL` while opening the Fight menu to force the Dynamax button to appear even if you have already used the mechanic during this battle.

***

<mark style="background-color:yellow;">**Wishing Star**</mark>

This plugin also adds the Wishing Star item from Sword & Shield. In those games, this was simply a key item that didn't have any inherent utility. However, this plugin revamps this item with a custom battle function not found in the original games. This provides unique functionality that may replenish your Dynamax Band during battle, allowing you to use Dynamax an additional time during the same battle. Using this item in battle uses up the player's entire turn in order to try and keep it (sorta) balanced, so this will use up the turn for all of your Pokemon even if you have more than one Pokemon to issue commands to.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FY7lSV5vYq745N21Ca92O%2Fdemo70.gif?alt=media&#x26;token=23f8bd76-ee4f-44ef-a277-7e1449262fe1" alt="" data-size="original">

This is intended to be a "just for fun" item, and not to be used seriously, but it's there if you'd like to make use of it.

</details>

<details>

<summary>NPC Trainers</summary>

<mark style="background-color:yellow;">**Trainer Requirements**</mark>

Other trainers may utilize Dynamax too, whether they're opponents or partners. The requirements for this are the same as for the player, they are simply set up differently. Like with the player, the NPC trainer must be given an eligible Dynamax Band in their inventory in order to use Dynamax.

The Pokemon eligible to be Dynamaxed by an NPC trainer all follow the same rules as for the player. This means that any Pokemon in an NPC trainer's party which is considered an "exception" will not be considered for Dynamax. If you'd like to flag certain members of an NPC's party as ineligible for Dynamax, you may do so by setting `NoDynamax = true` for that Pokemon in the trainer's PBS data. This may also be done within the in-game trainer editor while playing in debug mode.

This setting can be useful if the trainer has a certain Pokemon in their party that would be entirely wasteful to use Dynamax on due to not being able to enjoy the benefits of the HP boost (Shedinja, for example), or because changing their moves might actually screw up some sort of specific strategy you have in mind for that trainer to use. You can also use this setting to force a trainer to only consider Dynamax for a certain member in their party by flagging all other members besides the one you want them to Dynamax with this flag.

***

<mark style="background-color:yellow;">**Dynamax AI**</mark>

The Pokemon that an NPC trainer will Dynamax will be automatically determined by the trainer's AI. How effective this is depends on the skill level of each particular trainer. Below, I'll give a general description of how each trainer skill level will handle how to utilize Dynamax.

Note that Trainers who are given the `ReserveLastPokemon` flag in their PBS data will always save Dynamax for their final Pokemon, no matter what. This behavior will override what their natural AI behavior would otherwise be.

* **"Low" skilled trainers** (skill < 32)\
  Typically, the lowest skilled trainers will only ever consider how to use Dynamax offensively. This means if using Dynamax would give them an immediate offensive advantage due to dealing more raw damage to one of the currently active targets on the field, then they will use it.<br>
* **"Medium" skilled trainers** (skill >= 32)\
  Medium skilled trainers will also only consider Dynamax offensively, however they will gauge this across their entire party. So if Dynamax would give them an advantage, but there's another Pokemon in their party which would gain a substantially higher advantage from Dynamax, then they will hold off on using it until they send out that Pokemon. This calculation is constantly checked each turn, so which Pokemon would be "best" to use Dynamax on may constantly change as the battle state progresses.<br>
* **"High" skilled trainers** (skill >= 48)\
  High skill trainers will consider Dynamax both offensively and defensively, and across their entire party. If they have determined that their active Pokemon would gain the most overall benefit from Dynamax when considering both offense and defense, then they'll choose to Dynamax that Pokemon.<br>
* **"Best" skilled trainers** (skill = 100+)\
  Trainers with the highest skill level will naturally be given the `ReserveLastPokemon` flag. Any trainer with this skill flag will always save Dynamax for their final Pokemon, no matter what. This will typically include trainers such as Gym Leaders and Elite Four members. If you choose to disable this flag for a trainer with this skill level, then their AI behavior will default to how "high" skilled trainers function.

For trainers of all skill levels, if they are down to their final Pokemon and have still yet to use Dynamax in this battle for some reason, then they may use it out of desperation even if it's not particularly advantageous. The will still avoid using it however if it would put them in a dramatically worse position, though (depending on their AI).

</details>

<details>

<summary>Wild Pokemon</summary>

Dynamax may also be utilized by wild Pokemon, without the need of a trainer or a Dynamax Band. These wild Dynamax battles work a little differently than a standard wild battle.

When encountered, a wild Pokemon will immediately Dynamax at the start of battle, before any commands can even be entered. While the Pokemon is Dynamaxed, it cannot be captured. Unlike normal Dynamax, this will not expire after a certain number of turns. Instead,  the wild Pokemon's Dynamax will only end when their HP falls to a certain threshold (1/6th of their max HP). Any damage dealt by direct attacks cannot exceed this threshold until the wild Pokemon's Dynamax ends. When removed, the Pokemon will become catchable again like a normal wild Pokemon.

If the wild Pokemon is ineligible to use Dynamax for some reason, nothing will happen and the battle will just be a standard wild battle.\
\
To set up battles against wild Dynamax Pokemon, you may do so by using the <mark style="background-color:green;">"wildDynamax"</mark> Battle Rule.

</details>

***

<mark style="background-color:orange;">**Dynamax Counts**</mark>

Essentials internally keeps track of a variety of the player's game statistics. One of those statistics is how many times the player has used Mega Evolution. To keep Dynamax in line with this, I've added trackers which will keep count of various statistics related to Dynamax, too.

Below are all of the new statistics tracked by this plugin, and how to call them.

* **Dynamax count**\
  This plugin keeps count of how many times the player has Dynamaxed a Pokemon in battle. This can be called with the script `$stats.dynamax_count`.<br>
* **Gigantamax count**\
  This plugin keeps count of how many times the player has Gigantamaxed a Pokemon in battle. This can be called with the script `$stats.gigantamax_count`.<br>
* **Total Dynamax levels gained**\
  This plugin keeps count of how many times the player has increased their Pokemon's Dynamax levels through the use of Dynamax Candies. This can be called with the script `$stats.total_dynamax_lvls_gained`.<br>
* **Total number of times G-Max Factor was given**\
  This plugin keeps count of how many times the player has given the Gigantamax Factor to their Pokemon through the use of Max Soup. This can be called with the script `$stats.total_gmax_factors_given`.<br>
* **Wild Dynamax battles won**\
  This plugin keeps count of how many battles the player has won against wild Dynamax Pokemon. A "win" counts as either defeating or capturing the Pokemon to end the battle. This can be called with the script `$stats.wild_dynamax_battles_won`.

Page 89:

# Dynamax: Properties

The Dynamax mechanic introduces new settings and properties that can be edited and manipulated to change various aspects of Dynamax. In this subsection, I'll briefly explain each of these properties, what they do, and how you may set them.

***

<mark style="background-color:orange;">**General Settings and Properties**</mark>

<details>

<summary>Dynamax Turns</summary>

Dynamax is unique from other mechanics in that it only lasts for a limited number of turns before expiring. In *Pokemon Sword & Shield*, Dynamax would typically only last for 3 turns. Though, unlike the original games, you are able to control how many turns you wish Dynamax to last.

In the plugin settings, there is a setting named `DYNAMAX_TURNS` which stores the number of turns that Dynamax will last before expiring. This is set to 3 by default, like how it works in the original games. However, you can tweak this if you feel like changing how this works by setting a different number of turns. If you'd like for Dynamax to last for an infinite number of turns, you may simply set this to -1 instead.

Note that regardless of how many turns you set this to, Dynamax will always automatically end whenever a Pokemon switches out or faints, or at the end of battle.

</details>

<details>

<summary>Dynamax Size &#x26; Metrics</summary>

When a Pokemon Dynamaxes, it becomes giant-sized. This plugin represents this by enlarging the Pokemon's sprites and icons by 50%. Doing so however will obviously shift the position of the Pokemon's sprites during battle. To address this, each Pokemon sprite requires its own separate metrics data for Dynamax in the `pokemon_metrics.txt` PBS file.

Here's an example of a Pokemon with Dynamax metrics:

```
[BULBASAUR]
BackSprite = -4,0
FrontSprite = -1,26
ShadowX = 0
ShadowSize = 2
DmaxBackSprite = 0,0
DmaxFrontSprite = 0,41
DmaxShadowX = 0
```

You'll notice three new lines of data for each species:

* `DmaxBackSprite`\
  This sets the metrics for this species' back sprite while Dynamaxed.
* `DmaxFrontSprite`\
  This sets the metrics for this species' front sprite while Dynamaxed.
* `DmaxShadowX`\
  This sets the X coordinates for this species' shadow sprite while Dynamaxed.

If a species doesn't have any of the above Dynamax metrics set, it will simply default to using its normal non-Dynamax metrics while Dynamaxed. However, this plugin automatically adds the appropriate Dynamax metrics for every species found in base Essentials, as well as any species added by the Generation 9 Pack. If you have any custom species or forms of your own though, you may have to add your own Dynamax metrics for those species.

Note that Dynamax metrics will be automatically added to all official species upon first installing this plugin. If you'd like to ever restore all of your Dynamax metrics to these default values, hold `Shift` upon compiling your game to reapply these metrics. This will overwrite all of your changes, so please keep that in mind.

***

<mark style="background-color:yellow;">**Editing Dynamax Metrics**</mark>

To set the Dynamax metrics for a species or form, you may do so by either manually entering them in `pokemon_metrics.txt`, or you may do so with an in-game editor while playing in debug mode. However, you don't use the normal metrics editor that you would typically use. Instead, you need to navigate to the "Deluxe plugin settings..." option in the debug menu, and select the option "Dynamax metrics..."

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FYp3zQZYzZjahK7MYG73P%2F%5B2024-02-22%5D%2008_14_57.830.png?alt=media&#x26;token=95953e18-8d2b-41f6-bf65-82afd7ea36d2" alt="" data-size="original">

In here, you will find two options to allow you to customize each species' Dynamax metrics:

* **Edit Dynamax metrics**\
  This option will allow you to manually adjust the position of the Dynamax sprites of every species and form.<br>
* **Auto-set Dynamax metrics**\
  This option will automatically set the recommended Dynamax metrics of every species and form. Don't use this haphazardly though, because it isn't perfect and will set all species to the ground and won't distinguish between those that are meant to be airborne. This is mostly to be used as a tool to give you a good starting point if your game has mostly original species or sprites and you need to make Dynamax metrics for all of them from scratch.\
  \
  Note that using this option will take a long time before it's done, since it has to perform this action for every single Pokemon sprite in the game. So don't think your game crashed if it remains frozen for a few minutes. Be patient and give it time.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FLmEfRRUHhuSKNkIrQ6pT%2F%5B2024-02-22%5D%2008_15_08.798.png?alt=media&#x26;token=9ad05296-f70c-4f0d-abc4-5fb9abfb9aca" alt="" data-size="original">

When selecting either of these options, you will be asked what style of back sprites you're using in your game. If you're using full back sprites (like those provided in the Gen 8 or Gen 9 Packs), please select the Gen 5 style option. If you're using cut off back sprites (like those provided in Essentials by default), please select the Gen 4 style option. This will change how back sprites are automatically aligned when using any auto-set option.

***

<mark style="background-color:yellow;">**Disabling Enlarged Sprites**</mark>

If you don't like the way sprites look when enlarged by Dynamax, you can disable this feature entirely. This can be done by opening the plugin settings and setting `SHOW_DYNAMAX_SIZE` to `false`. If so, this will turn off Pokemon sprites from enlarging while Dynamaxed, and they will remain normal-sized.

While this feature is turned off, Pokemon will no longer use their Dynamax metrics for anything, and these metrics will be entirely ignored. Because of this, the debug Dynamax metrics options will no longer work, and fail to do anything if you try to access them.

</details>

<details>

<summary>Dynamax Overlays</summary>

When a Pokemon Dynamaxes, they are covered in a red aura to indicate the use of Dynamax energy. This plugin replicates this by placing a transparent red overlay over the Dynamaxed Pokemon's sprites and icons.

However, certain species may need to utilize a different overlay while Dynamaxed. For example, Calyrex doesn't utilize typical Dynamax energy to enter a Dynamax form. Instead, it uses its own power. Because of this, the overlay used for Calyrex isn't the usual red color, but instead blue.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FsrrRArik50D29exOSQbC%2F%5B2024-02-22%5D%2008_16_13.294.png?alt=media&#x26;token=890b6671-0a98-4f39-b7d1-4c4e1a9cbf5c" alt="" data-size="original"> ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FbqgEHfmJknpzVajx4iLB%2F%5B2024-02-22%5D%2008_17_27.693.png?alt=media\&token=40405710-efeb-49c3-87fc-ab7c4fc72a5a)

To replicate this, this plugin allows you to set unique overlays to be used for certain species. These overlay graphics should be added to the folder `Graphics/Plugins/Dynamax/Patterns`, and should be named by entering the species ID of the species you want that overlay to display over.

For example, Calyrex's blue overlay is entered here in this folder with the name `CALYREX`. So whenever Calyrex enters its Dynamax form, this overlay will be displayed over its sprites instead of the typical red one.

If no species-specific overlay is found in this folder, then the Pokemon will always just use the overlay named `dynamax` by default.

***

<mark style="background-color:yellow;">**Animating Dynamax Overlays**</mark>

The overlay displayed on Dynamax sprites is a pattern than can actually move around in a loop, creating an animation of sorts. By default, this overlay will scroll to the left, creating a cloudy moving effect.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FXDyUTP40f8qQxGkrJgWT%2Fdynamax.gif?alt=media&#x26;token=5b82d150-467a-4bca-abe5-efb1b200bb38" alt="" data-size="original">

To edit how this pattern moves, you simply have to open the plugin Settings and find the setting `DYNAMAX_PATTERN_MOVEMENT`. You will see that this is set to an array containing two symbols.

The first element in this array corresponds to how the overlay animates along the X-axis. The second element in this array corresponds to how the overlay animates along the Y-axis. By combining different settings for each axis, you can control how the pattern moves.

If you'd prefer that the pattern is a still image that doesn't animate, then you would just set this as `[:none, :none]` to prevent any movement on either axis.

***

<mark style="background-color:yellow;">**Disabling Dynamax Overlays**</mark>

If you don't like the way sprites look when covered by a Dynamax overlay, you can disable this feature entirely. This can be done by opening the plugin settings and setting `SHOW_DYNAMAX_OVERLAY` to `false`. If so, this will turn off Pokemon sprites from displaying any overlay while Dynamaxed, and they will remain their normal color.

</details>

<details>

<summary>Dynamax Shadows</summary>

When a Pokemon Dynamaxes, the shadow sprite that appears below them will change. Instead of their typical black shadow, they will instead cast a giant red shadow to indicate their Dynamax form.

Certain species can have unique shadow sprites while Dynamaxed, however. For example, Calyrex doesn't utilize typical Dynamax energy to enter a Dynamax form. Instead, it uses its own power. Because of this, the Dynamax energy surrounding Calyrex isn't the usual red color, but is instead blue.

To replicate this, this plugin allows you to set unique shadow sprites to be displayed for certain species. These sprites should be added to the folder `Graphics/Pokemon/Shadow`, and should be named by entering the species ID plus `_dmax` at the end of its file name.

For example, Calyrex's blue shadow is entered here in this folder with the name `CALYREX_dmax`. So whenever Calyrex enters its Dynamax form, this shadow sprite will be displayed below it instead of the typical red one.

</details>

***

<mark style="background-color:orange;">**Dynamax Levels**</mark>

Every Pokemon capable of using Dynamax will have a Dynamax level. This determines how much the Pokemon's HP will be boosted while Dynamaxed. Every 1 Dynamax level increases the amount of HP the Pokemon will gain while Dynamaxed by 5%. At a Dynamax level of 0, the Pokemon's HP will increase by 50%. At the maximum Dynamax level of 10, the Pokemon's HP will become doubled while Dynamaxed.

Below, I'll describe the different methods of manipulating a Pokemon's Dynamax level.

<details>

<summary>General</summary>

If you ever need to check the Dynamax level of any defined Pokemon object through a script, you may do so by using the script `Pokemon.dynamax_lvl`, where Pokemon is the specific Pokemon object you are checking. If you'd like to manually set this Pokemon's Dynamax level to a specific level, you can simply set this to a number from 0-10, such as `Pokemon.dynamax_lvl = 5`.

</details>

<details>

<summary>Player's Pokemon</summary>

To increase the Dynamax level of your own Pokemon, you must feed them Dynamax Candies. Each Dynamax candy you feed a Pokemon will increase its Dynamax level by 1. However, this plugin also introduces a custom item not found in the original Sword & Shield called Dynamax Candy XL. This is a super-sized candy that will instantly set a Pokemon's Dynamax level to the maximum of 10, regardless of their current level.

While playing in debug mode, you may also manually set the Dynamax level of a Pokemon by opening its debug options in the party menu, scrolling down to "Plugin attributes...", selecting "Dynamax...", and then selecting "Set Dynamax Level."

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FqXvl6GOul1SkMe4sjjmy%2F%5B2024-02-22%5D%2008_20_29.766.png?alt=media&#x26;token=82973e69-da31-4362-a273-bb63d6f0a351" alt="" data-size="original">

You may view your Pokemon's current Dynamax level within the stats page of the Summary screen, above their item slot. Note that if the Pokemon is incapable of using Dynamax, their Dynamax level information will be hidden.

</details>

<details>

<summary>NPC Trainer's Pokemon</summary>

By default, the Dynamax level for an NPC's trainer's Pokemon will always be set to zero. However, you can set specific Dynamax levels for each of a trainer's Pokemon by setting `DynamaxLv = #` for a specified Pokemon in `trainers.txt`, where `#` is the value to be used for that Pokemon's Dynamax level. This may also be done within the in-game trainer editor.

</details>

<details>

<summary>Wild Pokemon</summary>

Wild Pokemon can have their Dynamax levels edited in the same way any other Pokemon can have their attributes edited, which is described in the "General" section above.

However, you may also set a specific Dynamax level for wild Pokemon by utilizing the <mark style="background-color:green;">"editWildPokemon"</mark> Battle Rule along with all of its variants introduced by the Deluxe Battle Kit. This can be done by setting up this rule as a hash, and entering `:dynamax_lvl => #` within this hash for the desired Pokemon where `#` is the number want to set this wild Pokemon's Dynamax level to.

For example, if you want to set a wild Pikachu's Dynamax level to 8, you could implement it as such:

```ruby
setBattleRule("editWildPokemon", {
  :dynamax_lvl => 8
})
WildBattle.start(:PIKACHU, 25)
```

For more information on this Battle Rule, refer to the "Deluxe Battle Rules" section of the tutorial.

</details>

***

<mark style="background-color:orange;">**G-Max Factor**</mark>

Certain species have a unique Gigantamax form which they will transform into when they Dynamax. However, this will only occur if the Pokemon has G-Max Factor. Otherwise, they will just Dynamax normally instead of changing forms. Any Pokemon can technically be given G-Max Factor. However, this attribute doesn't do anything unless the species has a Gigantamax form.

Below, I'll describe all of the different methods of giving a Pokemon G-Max Factor.

<details>

<summary>General</summary>

If you ever need to use a script to check whether or not a defined Pokemon object has G-Max Factor, you may do so by using the script `Pokemon.gmax_factor?`, where `Pokemon` is the specific Pokemon object you are checking. If you'd like to manually set this Pokemon's G-Max Factor, you can simply set this to true or false, such as `Pokemon.gmax_factor = true`.

</details>

<details>

<summary>Player's Pokemon</summary>

To set G-Max Factor on your own Pokemon, you can do so by feeding them Max Soup. While Max Soup wasn't an actual item in the original Sword & Shield, this plugin implements it as a consumable item that you can use on your Pokemon. Only species that have the potential to Gigantamax can consume Max Soup, so the item will fail to do anything if used on a species without one. If Max Soup is used on a Pokemon that already has G-Max Factor, then this will remove that Pokemon's G-Max Factor.

While playing in debug mode, you may also manually set a Pokemon's G-Max Factor by opening its debug options in the party menu, scrolling down to "Plugin attributes...", selecting "Dynamax...", and then selecting "Set G-Max Factor."

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F7RRpD0NPtqcTvZXT6p0X%2F%5B2024-02-22%5D%2008_20_43.917.png?alt=media&#x26;token=9f6a1611-ec73-4507-8ab5-56ca1aa38d20" alt="" data-size="original"> ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FdSYKAO8GHXOYvizLxgWA%2F%5B2024-02-22%5D%2008_20_51.182.png?alt=media\&token=49d52a0e-a046-419d-a834-c2d214e50326)

If your Pokemon has G-Max Factor, an icon will indicate if they have it in their Summary, in the same area where status condition and Pokerus is displayed. G-Max Factor will be displayed in the PC storage UI as well. However, if you would like to hide this display in the storage screen, you may do so by opening the plugin settings and setting `STORAGE_GMAX_FACTOR` to `false`.

Note that if the Pokemon is incapable of using Dynamax, their G-Max Factor information will never be displayed anywhere.

</details>

<details>

<summary>NPC Trainer's Pokemon</summary>

By default, NPC's trainer's Pokemon will never have G-Max Factor. However, you can give a trainer's Pokemon G-Max Factor by setting `Gigantamax = true` for a specified Pokemon in `trainers.txt`. This will flag the Pokemon as having G-Max Factor so that it may Gigantamax if the trainer decides to Dynamax this Pokemon. This may also be done within the in-game trainer editor.

</details>

<details>

<summary>Wild Pokemon</summary>

Wild Pokemon can have their G-Max Factor edited in the same way any other Pokemon can have their attributes edited, which is described in the "General" section above.

However, you may also set G-Max Factor for wild Pokemon by utilizing the <mark style="background-color:green;">"editWildPokemon"</mark> Battle Rule along with all of its variants introduced by the Deluxe Battle Kit. This can be done by setting up this rule as a hash, and entering `:gmax_factor => true` within this hash for the desired Pokemon.

For example, if you want to set G-Max Factor on a wild Pikachu, you could implement it as such:

```ruby
setBattleRule("editWildPokemon", {
  :gmax_factor => true
})
WildBattle.start(:PIKACHU, 25)
```

For more information on this Battle Rule, refer to the "Deluxe Battle Rules" section of the tutorial.

</details>

Page 90:

# Dynamax: Move Data

When a Pokemon Dynamaxes, all of its base moves are replaced with Max Moves. The specific Max Moves the Pokemon's moves convert into depends on the type of the original move. In this subsection, I'll go over everything related to Max Moves as well as other move data related to Dynamax.

***

<mark style="background-color:orange;">**PBS Data**</mark>

Upon installing the plugin for the first time, you *must* recompile your game. This is not an optional step. This will update all of your relevant PBS files with the necessary data. If you're unaware of how to recompile your game, simply hold down the `CTRL` key while the game is loading in debug mode and the game window is in focus.

<details>

<summary>Installation Details</summary>

If done correctly, your game should recompile. However, you will also notice lines of yellow text above the recompiled files, like this:

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FlTHKCd1qWKU4U5OfrAnt%2FCapture.JPG?alt=media&#x26;token=0e84aca6-15d3-45e0-af2d-e7fab6fead62" alt="Yellow text in the debug console." data-size="original">

This indicates that the appropriate data have been added to the following PBS files:

* `map_metadata.txt`
* `moves.txt`
* `pokemon.txt`
* `pokemon_forms.txt`
* `pokemon_metrics.txt`
* `pokemon_metrics_Gen_9_Pack.txt` (if the Gen 9 Pack is installed)

Most of these changes will only occur the first time you install the plugin. If you for whatever reason ever need to re-apply the data this plugin adds to these PBS files, you can force this to happen again by holding the `SHIFT` key while loading your game in debug mode. This will recompile all your plugins, and the data will be re-added by this plugin as if it was your first time installing.

</details>

In addition to the changes made to existing files, this plugin adds several new PBS files.

* `items_dynamax.txt`
* `moves_dynamax.txt`
* `pokemon_forms_gmax.txt`
* `pokemon_metrics_gmax.txt`

The `moves_dynamax.txt` file is where all of the Max Moves introduced by this plugin are stored. If you're adding any of your own custom Max Moves, you may do so there.

***

<mark style="background-color:orange;">**Max Moves**</mark>

When a Pokemon is Dynamaxed, all of their base moves that deal damage are converted into Max Moves based on the type of each move. Any of the user's status moves are instead converted into the move Max Guard.

If the Pokemon is Gigantamaxed however, then moves of a specific type may be converted into a G-Max Move instead. G-Max Moves are functionally identical to a Max Move, except they often have unique effects instead of the typical Max Move of that type.

Below, I'll go over each kind of Max Move and how they are set up.

<details>

<summary>Max Moves</summary>

Each of the 18 base types in the game have their own corresponding generic Max Move that any offensive move of that type will be converted into when Dynamaxed. For example, when a Pokemon is Dynamaxed, all of its damaging-dealing Normal-type moves will be converted into the Max Move known as Max Strike.

```
[MAXSTRIKE]
Name = Max Strike
Type = NORMAL
Category = Physical
Power = 1
Accuracy = 0
TotalPP = 1
Target = NearFoe
FunctionCode = LowerTargetSideSpeed1
Flags = DynamaxMove_NORMAL,CannotMetronome
Description = A Normal-type attack Dynamax Pokémon use. This lowers the target's Speed stat.
```

Here's an example of how Max Strike is set up in the `moves_dynamax.txt` PBS file. This is mostly set up like any other move, but there are a few key things to note:

* The `Category` you set for any Max Move ***doesn't matter***. By default, all of them are set to Physical. However, in practice, what you set doesn't make any difference since the category will always be inherited from the base move.
* Generic Max Moves ***must*** have a `Power` of 1. This is what allows the move's power to scale depending on what the base move was. For example, if converting a high base power move like Hyper Beam into this Max Move, it'll have a much higher power than if the base move was Tackle.
* All Max Moves ***must*** have an `Accuracy` of 0. This allows it to ignore Accuracy checks.
* The `TotalPP` set for any Max Move ***doesn't matter***. This is because the PP for each Max Move will always be inherited from the base move.
* All Max Moves ***must*** have the `CannotMetronome` flag.
* Generic Max Moves ***must*** have the `DynamaxMove_TYPE` flag, where `TYPE` is the ID of the specific type of move this Max Move will replace. This type should ***always*** be the same type as the Max Move's type.

***

<mark style="background-color:yellow;">**Max Guard**</mark>

Instead of converting into a generic Max Move when Dynamaxed, all of the user's status moves will instead be converted into the move Max Guard. This is a unique Max Move that functions as a Protect move. However, unlike other Protect variants, this move will even block the effects of other Max Moves, which other Protect moves cannot fully negate.

However, there is a small list of moves that may bypass Max Guard. Any status move with the function code `TrapTargetInBattle` will not be blocked by Max Guard. By default, these moves include:

* Mean Look
* Block
* Spider Web

In addition, any move with the function code `RemoveProtections` will hit through Max Guard. However, this will not remove the protection effect of Max Guard, unlike when used on other protection moves. Similarly, any move with the function code `IgnoreProtections` will also bypass Max Guard entirely. By default, these moves include:

* Feint
* G-Max One Blow
* G-Max Rapid Flow

Finally, any move that is given the flag `IgnoresMaxGuard` will be able to fully ignore Max Guard's protection, too. Here's a list of all moves that are given this flag by default:

* Decorate
* Role Play
* Perish Song

Any other move not listed above as exceptions will be fully negated by Max Guard, even if they would normally hit through Protect, such as Hyper Drill or Mighty Cleave. If you want to allow a move to bypass Max Guard, you simply have to give it the `IgnoresMaxGuard` flag.

</details>

<details>

<summary>G-Max Moves</summary>

Some Max Moves are exclusive to certain species that are only available when that species is in Gigantamax form. This variant of Max Moves are known as G-Max Moves. For example, when a Rillaboom with G-Max Factor uses Dynamax, it will instead enter its Gigantamax form and its damage-dealing Grass-type moves will all be converted to the the exclusive G-Max Move known as G-Max Drum Solo.

```
[GMAXDRUMSOLO]
Name = G-Max Drum Solo
Type = GRASS
Category = Physical
Power = 160
Accuracy = 0
TotalPP = 1
Target = NearFoe
FunctionCode = IgnoreTargetAbility
Flags = GmaxMove,CannotMetronome
Description = A G-Max Move used by G-Max Rillaboom. Ignores opponent's Abilities that would reduce damage.
```

Here's an example of how G-Max Drum Solo is set up in the `moves_dynamax.txt` PBS file. This is mostly set up like a generic Max Move, but there are a few key things to note:

* Unlike generic Max Moves, exclusive G-Max Moves ***can*** have a set `Power`, if you wish. Certain G-Max Moves such as this one have a set power regardless of what the base move's power was. If you set it to 1 however, its power will scale like generic Max Moves do.
* Unlike generic Max Moves, exclusive G-Max Moves ***must*** have the `GmaxMove` flag without a type ID attached.

Now that we have an example of an exclusive G-Max Move, we need to actually give this move to a Gigantamax form to allow that form to use it. This is done by entering this move ID in the PBS data in that form's entry by using the `GmaxMove` field.

```
[RILLABOOM,1]
FormName = Gigantamax
Height = 28.0
Pokedex = Gigantamax energy has caused Rillaboom's stump to grow into a drum set that resembles a forest.
GmaxMove = GMAXDRUMSOLO
```

As seen here, Rillaboom's G-Max form has the field `GmaxMove = GMAXDRUMSOLO`. This is what allows it to have this exclusive G-Max Move replace its other Grass-type moves when it enters Gigantamax form. More details on how to set up these forms can be found in the subsection "Dynamax: Form Data."

</details>

<details>

<summary>Max Move power scaling</summary>

All Max Moves that have a `Power` set to 1 in their PBS data will scale their damage based on the power of the base move that is being converted into that Max Move. This converted power can never be higher than 150, and never lower than 90.

However, there are exceptions to this. Certain types of Max Moves actually have their converted power reduced due to the fact that the effects of these moves would be too powerful if combined with a high-powered move. For example, Fighting-type moves converted into Max Knuckle would increase the Attack stat of the user and their allies after each use. If this was stacked on top of a high base power, this would be absurdly strong.

To address this, Game Freak implemented a feature where Fighting-type and Poison-type Max Moves will significantly tone down the way these types of Max Moves scale their power in comparison to other types. For these types of moves, the converted power can never be higher than 100, and never lower than 70.

This mechanic has been replicated by this plugin. However, you have the ability to completely customize which types of Max Moves will be scaled down, and which types won't. This is handled with the plugin setting `DYNAMAX_TYPES_TO_WEAKEN`.

This setting is an array which can contain any number of type ID's you'd like. Any type ID entered here will have their power scaling reduced when converted into a Max Move. By default, the only types entered here are `:FIGHTING` and `:POISON`, to mirror how this worked in Sword & Shield. But you're free to add or remove whichever types you want in this array if you'd like to customize the way certain types scale their power as Max Moves.

</details>

<details>

<summary>Coding custom Max Move effects</summary>

If you decide you want to create your own custom Max Move that have some sort of effect, this is done the same way you would code the move function for any other regular move. However, there is one key difference. A typical battle move is defined in the class `Battle::Move`. All Max Moves however use a subclass of this called `Battle::DynamaxMove`.

This means that when you are coding a move function, this is the class you need to use, rather than `Battle::Move`. For example, here's the move function for Max Guard:

```ruby
class Battle::DynamaxMove::ProtectUserEvenFromDynamaxMoves < Battle::Move::ProtectMove
  def initialize(battle, move)
    super
    @effect = PBEffects::MaxGuard
  end
end
```

You'll see that `class Battle::DynamaxMove` is what's used here prior to the move's function code. This is required for Max Moves. However, Max Moves can access everything from the normal `Battle::Move` class, so you can still use this as a subclass as needed.

Because of this, it's possible to just inherit all of the attributes of a regular move's function code. As shown in the above example, Max Guard uses the subclass `Battle::Move::ProtectMove`, allowing it to inherit all of the traits that all other Protect moves have.

***

<mark style="background-color:orange;">**Generic Max Move Classes**</mark>

Many generic Max Moves share similar types of effects such as raising the stats for allies, lowering the stats of foes, or applying status effects. Because of this, it was much simpler to create generic move classes for these effects, rather than reinvent the wheel each time.

Below, I'll describe each generic move class that may be used as a subclass for Max Moves.

***

<mark style="background-color:yellow;">**Base Class**</mark>

`Battle::DynamaxMove::Move`

This class is the base class used for all Max Moves that are not inheriting its effects from another move (like the Max Guard example above), or not inheriting its effects from another generic Max Move class listed below. All this class is used for is making sure the effects of a Max Move should go off when `def pbEffectAfterAllHits` is used, which is the main method all Max Moves should be using to apply their effects.

Here's an example of this below, with the move Max Overgrowth.

```ruby
class Battle::DynamaxMove::DamageTargetStartGrassyTerrain < Battle::DynamaxMove::Move
  def pbEffectAfterAllHits(user, target)
    return if !super
    @battle.pbStartTerrain(user, :Grassy)
  end
end
```

Here, the line `return if !super` is used to make sure Max Overgrowth does not apply Grassy Terrain if it should not be able to. This super can only be used because the subclass `Battle::DynamaxMove::Move` is being used for this move.&#x20;

***

<mark style="background-color:yellow;">**Raising Stats on the User's Side**</mark>

`Battle::DynamaxMove::UserSideStatUpMove`

This class handles all Max Moves that raises the stats of all Pokemon on the user's side of the field, such as the move Max Knuckle, which can be seen below.

```ruby
class Battle::DynamaxMove::RaiseUserSideAtk1 < Battle::DynamaxMove::UserSideStatUpMove
  def initialize(battle, move)
    super
    @statUp = [:ATTACK, 1]
  end
end
```

Note that you can enter as many stat ID's in these arrays as you wish set the number of stages to whatever you wish. However, all default Max Moves that use this move class only increase a single stat by 1 stage.

***

<mark style="background-color:yellow;">**Lowering Stats on the Target's Side**</mark>

`Battle::DynamaxMove::TargetSideStatDownMove`

This class handles all Max Moves that lower the stats of all Pokemon on the target's side of the field, such as the move G-Max Foamburst, which can be seen below.

```ruby
class Battle::DynamaxMove::LowerTargetSideSpeed2 < Battle::DynamaxMove::TargetSideStatDownMove
  def initialize(battle, move)
    super
    @statDown = [:SPEED, 2]
  end
end
```

Note that you can enter as many stat ID's in these arrays as you wish set the number of stages to whatever you wish. However, all default Max Moves that use this move class only increase a single stat, and usually only by 1 stage.

***

<mark style="background-color:yellow;">**Inflicting Status Conditions on the Target's Side**</mark>

`Battle::DynamaxMove::TargetSideStatusEffectMove`

This class handles all Max Moves that inflict status conditions on all Pokemon on the target's side of the field, such as the move G-Max Volt Crash, which can be seen below.

```ruby
class Battle::DynamaxMove::ParalyzeTargetSide < Battle::DynamaxMove::TargetSideStatusEffectMove
  def initialize(battle, move)
    super
    @statuses = [:PARALYSIS]
  end
end
```

Note that the array here can accept multiple status conditions. If so, a random status within that array will be chosen for each opposing Pokemon. You may also input the symbols `:TOXIC`, `:CONFUSION`, or `:ATTRACT` in these arrays to inflict those conditions as well.

</details>

***

<mark style="background-color:orange;">**Anti-Dynamax Moves**</mark>

In *Pokemon Sword & Shield*, some moves had a unique property in that they would have their power doubled specifically when dealing damage to a Dynamaxed target. By default, the following moves have this property:

* Behemoth Blade
* Behemoth Bash
* Dynamax Cannon

This plugin replicates this by giving these moves the function code `DoubleDamageOnDynamaxTargets`. If you have any moves that you'd like to have this property as well, you may do so by giving that move this function code. Note however that Pokemon in an Eternamax form ignore this property, and will not take double damage despite being Dynamaxed.

Page 91:

# Dynamax: Form Data

Gigantamax is a unique variant of Dynamax that allows certain species to transform into a Gigantamax form upon Dynamaxing. Any Pokemon with G-Max Factor that has a compatible G-Max form can Gigantamax. Below, I'll explain how Gigantamax forms are set up.

***

<mark style="background-color:orange;">**Gigantamax Forms**</mark>

Gigantamax forms are implemented as ordinary forms, which means they can be set up identically to how any other form would be set up in the `pokemon_forms.txt` PBS file. However, his plugin adds its own file called `pokemon_forms_gmax.txt` which specifically adds all the Gigantamax forms introduced in *Pokemon Sword & Shield*, so you may continue adding additional forms to this file if you wish.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FtYNeAuUwM3rOUMPKvV5R%2Fdemo76.gif?alt=media&#x26;token=ed831537-0d78-4e74-934f-94ddfd4794c7" alt="" width="381"><figcaption><p>Pikachu and Meowth entering Gigantamax form.</p></figcaption></figure>

Below, I'll go over the basics for adding a Gigantamax form.

<details>

<summary>G-Max form for a base species</summary>

If you want to add a G-Max form for the base form of a species, you don't really have to do anything much different than you would for any other form. Here's an example of one:

```
[RILLABOOM,1]
FormName = Gigantamax
Height = 28.0
Pokedex = Gigantamax energy has caused Rillaboom's stump to grow into a drum set that resembles a forest.
GmaxMove = GMAXDRUMSOLO
```

This is Rillaboom's G-Max form. A G-Max form only needs a few unique pieces of data that may differ from its base form:

* `FormName`\
  This can usually just be "Gigantamax", or whatever you want to name the form. For example, Urshifu has two different G-Max forms, so it uses more specific form names for its G-Max forms than the others do.<br>
* `Height`\
  G-Max forms are kaiju-sized, so keep this in mind when deciding what their height should be. This is purely cosmetic however, since a Pokemon's height is only ever displayed in the Pokedex. The weight for a G-Max form doesn't need to be set, since the weight for all G-Max forms will always just be displayed as "????.?" in the Pokedex, anyway.
* `Pokedex`\
  A G-Max form should typically have different Pokedex entries than its base form. But this is up to you. All dex entries for G-Max forms added by this plugin have entries from Sword & Shield.<br>
* `GmaxMove`\
  This is the only line of data that is actually ***required*** for each G-Max form. This determines the exclusive G-Max Move this form will have access to when it Gigantamaxes. If you do not give your G-Max form a G-Max Move, it will not be considered a G-Max form and no Pokemon will be able to Gigantamax into this form. Note that each G-Max form can only have a single G-Max move, however, multiple G-Max forms may all share the same G-Max Move.

</details>

<details>

<summary>G-Max form for another form</summary>

Sometimes, you may want to give a specific form of a species their own G-Max form. For example, Urshifu has two different G-Max forms. One G-Max form for its Single Strike style, and another G-Max form for its Rapid Strike style, as seen below:

```
[URSHIFU,2]
FormName = Gigantamax Single Strike Style
Height = 29.0
Pokedex = The energy released by this Pokémon's fists forms shock waves that can blow away Dynamax Pokémon in just one hit.
GmaxMove = GMAXONEBLOW
#-------------------------------
[URSHIFU,3]
FormName = Gigantamax Rapid Strike Style
Types = FIGHTING,WATER
Moves = 0,SURGINGSTRIKES,1,FOCUSENERGY,1,ENDURE,1,ROCKSMASH,1,AQUAJET,1,LEER,12,AERIALACE,16,SCARYFACE,20,HEADBUTT,24,BRICKBREAK,28,DETECT,32,BULKUP,36,IRONHEAD,40,DYNAMICPUNCH,44,COUNTER,48,CLOSECOMBAT,52,FOCUSPUNCH
Height = 26.0
Pokedex = As it waits for the right moment to unleash its Gigantamax power, this Pokémon maintains a perfect one-legged stance. It won't even twitch.
GmaxMove = GMAXRAPIDFLOW
UngmaxForm = 1
```

If this is the case, you can differentiate your G-Max forms by using the line `UngmaxForm`. This will allow you to assign the base form that this G-Max form is linked to. By default, all species with a G-Max form will always assume that the base form linked to a G-Max form is form 0, the base form of the species. However, with `UngmaxForm`, you can set this to whatever form you want.&#x20;

As seen in the above example, Single Strike Urshifu (form 0) will Gigantamax into `[URSHIFU,2]`. While Rapid Strike Urshifu (form 1) will Gigantamax into `[URSHIFU,3]`. This is because `[URSHIFU,3]` sets form 1 as its `UngmaxForm`, while `[URSHIFU,2]` doesn't set this data at all, so it's assumed that its `UngmaxForm` is form 0.

G-Max forms that are meant to be linked to other forms besides the base form need to inherit the same attributes as the form entered as their `UngmaxForm`. This is because every new form will always inherit the traits of the base form of the species if none are entered. So that's why `[URSHIFU,3]` requires that its types and moves be entered here (which are identical to Rapid Strike Urshifu), while `[URSHIFU,2]` doesn't require this, since Single Strike Urshifu is the base form of the species.

</details>

<details>

<summary>G-Max forms shared by multiple forms</summary>

Sometimes, you may want a single G-Max form that multiple forms of a single species can all Gigantamax into. There's two ways to go about this, depending on the situation.

***

<mark style="background-color:yellow;">**Cosmetic-Only Forms**</mark> (Aka, the Alcremie Method)

If a species has multiple cosmetic forms but you want all of those possible forms to share the same Gigantamax form, you don't have to make a separate G-Max form for each individual form. Instead, you may simply give the base species the `AllFormsShareGmax` flag.

For example, Alcremie has over 60 unique cosmetic forms. Normally, if you wanted all of its forms to Gigantamax into its G-Max form, you would have to make a different G-Max form for each form. This would obviously be an extremely tedious task with 60+ forms to make an individual G-Max form for. So to get around this, Alcremie is simply given the `AllFormsShareGmax` flag in the PBS data for the base species. This flag makes it so that every form of Alcremie will all Gigantamax into the same form that base Alcremie can Gigantamax into.

This can be very useful and save you a lot of time if you have a species with numerous cosmetic forms.

***

<mark style="background-color:yellow;">**Forms With Differences**</mark> (Aka, the Toxtricity Method)

If a species has multiple forms with different characteristics, but you want all of those forms to share the same Gigantamax form, then you'll have to create different G-Max forms for each form. This is similar to the Urshifu example shown earlier in this section.

However, because you want the forms to share the *same* G-Max form, rather than Urshifu who has *different* G-Max forms, this is set up slightly differently.

```
[TOXTRICITY,2]
FormName = Gigantamax
Height = 24.0
Pokedex = Out of control after its own poison penetrated its brain, it tears across the land in a rampage, contaminating the earth with toxic sweat.
GmaxMove = GMAXSTUNSHOCK
#-------------------------------
[TOXTRICITY,3]
PokedexForm = 2
Abilities = PUNKROCK,MINUS
Moves = 0,SPARK,1,LEER,1,GROWL,1,ACID,1,THUNDERSHOCK,1,FLAIL,1,ACIDSPRAY,1,BELCH,1,NOBLEROAR,1,NUZZLE,1,TEARFULLOOK,4,CHARGE,8,SHOCKWAVE,12,SCARYFACE,16,TAUNT,24,SCREECH,28,SWAGGER,32,TOXIC,36,DISCHARGE,40,POISONJAB,44,OVERDRIVE,48,BOOMBURST,52,MAGNETICFLUX
GmaxMove = GMAXSTUNSHOCK
UngmaxForm = 1
```

Here's an example of how Toxtricity's G-Max forms are set up. Like Urshifu, Toxtricity has two different forms with different characteristics. However, both its Amped Form and Lowkey Form can Gigantamax into the same G-Max form. To accomplish this, we have to create separate G-Max entries for each of Toxtricity's forms, as seen above.

However, since the forms need to appear identical (even though they are technically different forms), we have to implement things in a specific way.

* The first G-Max form entry should be set up the same as you would set up any other G-Max form.
* All subsequent G-Max form entries for this species should not have `FormName`, `Height`, `Weight`, or `Pokedex` data. This is because these lines of data are only relevant to the Pokedex, and this form shouldn't appear in the Pokedex at all to maintain the illusion that it's a single G-Max form.
* All subsequent G-Max form entries for this species should all have the `PokedexForm` data set to whatever form number the initial G-Max form has. In this example, the initial G-Max form for Toxtricity is form 2, thus this data for all other G-Max entries for this species need to have `PokedexForm = 2`. This will allow it so that all of these subsequent forms will be hidden in the Pokedex.
* The `GmaxMove` property for each G-Max form entry for this species should all be identical. You can technically have different G-Max Moves for each variation if you wish, but in that case it would make more sense to me to just make them separate forms, like Urshifu's G-Max forms.
* The `UngmaxForm` property for each G-Max form entry for this species should link to the base form that it should revert back into when Gigantamax ends.
* All other relevant data for each form should be inherited from the base form. For example, Lowkey Form Toxtricity has different abilities and moves than Amped Form Toxtricity, thus the G-Max form for Lowkey form needs to inherit these unique properties. &#x20;

</details>

***

<mark style="background-color:orange;">**Eternamax Forms**</mark>

Eternamax is another unique variant of Dynamax that only a single species is capable of: Eternatus. In *Pokemon Sword & Shield*, Eternatus was only capable of entering this form during the final post-game battle in the story. This form is totally inaccessible to the player, and was specifically designed as a boss-only encounter. However, this plugin allows you to use this form if you wish, though it can only be accessed under very specific conditions.&#x20;

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FGpbF9AxutydgcdU7ZhdA%2Fdemo77.gif?alt=media&#x26;token=4e97511f-9333-492a-a957-9752a2a08db1" alt="" width="381"><figcaption><p>Eternatus entering its Eternamax form.</p></figcaption></figure>

Below, I'll go over how you can access this special Eternamax form, and how you may make your own.

<details>

<summary>Accessing Eternamax forms</summary>

Pokemon who have an Eternamax form cannot Dynamax under normal conditions, even if all the requirements are met. They are more or less considered a non-Dynamaxable species unless they're on a map that is specifically flagged as an `EternaSpot`. An Eterna Spot is a similar concept to a Power Spot, except Eterna Spots do not allow for Dynamaxing. Instead, all an Eterna Spot does is allow Pokemon with an Eternamax form to use Dynamax, if all other conditions are met.

If so, when the Pokemon with an Eternamax form uses Dynamax, it will change into its Eternamax form. Unlike Gigantamax, this doesn't require G-Max Factor or any other special kind of trigger. The Pokemon will simply always enter this form when it Dynamaxes, but it will never be able to Dynamax unless it's specifically on a map with the `EternaSpot` flag.&#x20;

</details>

<details>

<summary>Making an Eternamax form</summary>

To make an Eternamax form, you'll need to set up several things. First, you need to actually create your form. Let's look at how this plugin implements Eternatus's Eternamax form as an example.

```
[ETERNATUS,1]
FormName = Eternamax
BaseStats = 255,115,250,130,125,250
Height = 100.0
Shape = Serpentine
Pokedex = Infinite amounts of energy pour from this Pokémon's enlarged core, warping the surrounding space-time.
```

To allow Eternatus to actually enter this form when it uses Dynamax however, we'll need a Multiple Forms handler, as seen below.

```
MultipleForms.register(:ETERNATUS, {
  "getEternamaxForm" => proc { |pkmn|
    next 1
  },
  "getUnmaxForm" => proc { |pkmn|
    next 0
  }
})
```

* The `"getEternamaxForm"` key determines which form Eternatus will transform into when it Dynamaxes. The line `next 1` makes it so in this scenario, Eternatus will change into form 1 when it Dynamaxes, which is the same form that entered for its Eternamax form in `pokemon_forms.txt`.
* The `"getUnmaxForm"` key determines which form Eternatus should revert to once its Dynamax ends. The line `next 0` makes it so in this scenario, Eternatus will revert to its base form when it leaves the Dynamax state.

</details>

<details>

<summary>Pokedex Data Page compatibility</summary>

The [**Pokedex Data Page**](https://www.pokecommunity.com/threads/in-depth-pokedex-data-page-v21-1.500459/#post-10659145) plugin allows for Eternamax forms to have unique displays in the data page of the Pokedex. You don't have to worry about Gigantamax forms, because those forms will be added automatically, so there is nothing extra you need to do for their displays.

Eternamax forms, however, cannot be automatically detected. To allow for this, you can add an additional key to the form handler for that Eternamax form. Here's how this additional key is set in Eternatus's form handler:

```ruby
MultipleForms.register(:ETERNATUS, {
  "getEternamaxForm" => proc { |pkmn|
    next 1
  },
  "getUnmaxForm" => proc { |pkmn|
    next 0
  },
  "getDataPageInfo" => proc { |pkmn|
    next [pkmn.form, 0] if pkmn.form == 1
  }
})
```

Here, there's an additional key called `"getDataPageInfo"`. This is what is needed for compatibility with the data page. The array in `next [pkmn.form, 0]` needs to contain two elements:

* The Pokemon's current form. This can always just be set as `pkmn.form` to accomplish this.
* The form that the Pokemon reverts to once it leaves Eternamax form. In the example above, this is form 0.

Finally, the `if pkmn.form == 1` part of the line makes it so that this information is only returned when Eternatus is in form 1, which is its Eternamax form. This is what prevents this data from displaying when viewing any one of Eternatus's other forms.

</details>

Page 92:

# Dynamax: Animations

The Deluxe Battle Kit incorporates various animation utilities which it uses to animate Mega Evolution and Primal Reversion. This plugin utilizes these same utilities to implement a new animation for Dynamax that is built in the same animation style.

There's a bit to explain about these animations and how they work, so I'll provide a break down of everything in this section.

{% hint style="info" %}
Note: If you already have an existing Dynamax animation which is stored as a Common animation named `"Dynamax"`, that animation will take priority over the animation added by this plugin. This means that there's no risk of your animation being overwritten or ignored, nor do you need to change anything to make this plugin compatible.
{% endhint %}

***

<mark style="background-color:orange;">**Trainer Dynamax**</mark>

Dynamax typically requires a trainer with a Dynamax Band and an eligible Pokemon while on a Power Spot. If so, the option to Dynamax that Pokemon will appear in battle. When triggered, the Dynamax animation will play.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FzYT5dvVOZxZTWAWUzjyH%2Fdemo71.gif?alt=media&#x26;token=1f641100-a49d-4441-84e9-a27ddf8c1a00" alt="" width="381"><figcaption><p>Dynamax on the player's side.</p></figcaption></figure>

There will be slight differences in the animation based on which side of the field the Dynamaxed Pokemon is on. Pokemon on the player's side of the field will face right, and their trainer will slide in from off screen on the left. If the Pokemon is on the opponent's side of the field, they will face left and their trainer will slide in from off screen on the right. This helps distinguish if the Dynamaxed Pokemon is friend or foe during the animation.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FwXRme5v3aCW7WImF6BCJ%2Fdemo72.gif?alt=media&#x26;token=35608acd-ea51-4995-9b80-7170f9bc98fe" alt="" width="381"><figcaption><p>Dynamax on the opponent's side.</p></figcaption></figure>

Dynamax animations will always display the trainer's Dynamax Band above the trainer during the animation. The trainer's item may not always be the same, however. The Dynamax Band is the default item used, but it's possible to give trainers unique items that trigger Dynamax. If you create unique Dynamax items for a trainer to utilize along with the necessary sprites, then the sprite for that unique item will appear in this animation instead of the default Dynamax Band.

***

<mark style="background-color:orange;">**Wild Dynamax**</mark>

Typically, wild Pokemon are incapable of Dynamaxing. This is because a trainer with a corresponding Dynamax Band is required. However, this plugin includes a feature that allows wild Pokemon to Dynamax on their own without a trainer, by utilizing the <mark style="background-color:green;">"wildDynamax"</mark> Battle Rule (more details on this can be found in the "Dynamax: Battle Rules" subsection). This bypasses the Dynamax Band requirement, allowing the wild Pokemon to Dynamax.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fr5mqAl6HuASJwAXRSeVn%2Fdemo73.gif?alt=media&#x26;token=81df049d-6ee6-4433-b19f-86e23e9b2fcc" alt="" width="381"><figcaption><p>Wild Dynamax animation.</p></figcaption></figure>

The animation for wild Dynamax is very different, since the trainer and the user's Poke Ball play a prominent role in the standard animation. Because of this, the Dynamax animation used for wild Pokemon is much more simplified.

***

<mark style="background-color:orange;">**Animation Utilities**</mark>

<mark style="background-color:yellow;">**Skipping Animations**</mark>

You may have noticed in the examples above that during the Dynamax animation, a button prompt on the bottom left-hand corner of the screen appears. This "skip" button indicates that you can cut the animation short by pressing the `Action` key. Pressing it will immediately end the animation, allowing you to get right back to the battle if you grow tired of sitting through these animations.

<mark style="background-color:yellow;">**Turning Off Animations**</mark>

If you want to turn these animations off entirely, there are two ways to accomplish this. First, you may do so by turning off battle animations completely in the Options menu.&#x20;

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FwOMVVwf7z58G4TSKSGM6%2F%5B2024-01-12%5D%2011_58_20.948.png?alt=media&#x26;token=36cd6063-28d1-4886-9f6e-49bbf7642b8f" alt="" width="384"><figcaption><p>Battle animations in the Options menu.</p></figcaption></figure>

If so, this animation will also be turned off. Instead, the trainer will simply recall their Pokemon and send them back out in Dynamax form, implying that the entire Dynamax process is simply happening off screen. New lines of battle text will be also be displayed to indicate this.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FBvvajap2U51cVX2UGQYn%2Fdemo74.gif?alt=media&#x26;token=9fe38436-5e4e-477a-bd3f-dea16cd84fd0" alt="" width="381"><figcaption><p>Simple recall animation for Dynamax.</p></figcaption></figure>

For wild Pokemon in particular, they will instead use a generic "quick-change" animation which happens instantaneously.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FcwpYdBnl3UK5yw1yKA8z%2Fdemo75.gif?alt=media&#x26;token=a6ca6abd-2723-4f7f-ac56-6c6494828324" alt="" width="381"><figcaption><p>Quick-change animation.</p></figcaption></figure>

The second way to turn off the animation would be to open the settings file in this plugin. Here, you'll find the setting `SHOW_DYNAMAX_ANIM`. If you set this to `false`,  the Dynamax animation will be shut off permanently, and will be replaced with the above examples, even when battle animations are turned on.

***

<mark style="background-color:orange;">**Dynamax Icon**</mark>

When a Pokemon is Dynamaxed, an icon will be displayed next to their databox to indicate this. This is similar to icons for other mechanics such as Mega Evolution and Primal Reversion.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FZkgY9EwyUVmOdgQVughD%2F%5B2024-02-22%5D%2019_13_03.454.png?alt=media&#x26;token=8b158c89-73cf-4a0c-b5c5-76e40e07a42d" alt="" width="384"><figcaption><p>Example of the Dynamax icon.</p></figcaption></figure>

Page 93:

# Dynamax: Battle Rules

These are new battle rules added by this plugin related to Dynamax.

<details>

<summary><mark style="background-color:green;">"wildDynamax"</mark></summary>

You can use this rule to flag wild Pokemon encountered in this battle as capable of using Dynamax, even though they don't have a trainer with a Dynamax Band. Wild Pokemon will always Dynamax immediately upon being encountered, prior to any commands even being entered. This Dynamax state will be different from the standard Dynamax, as it will last an indefinite number of turns and never expire until the Pokemon is in a weak enough state.\
\
This is entered as `setBattleRule("wildDynamax")`

When this rule is enabled, the <mark style="background-color:green;">"disablePokeBalls"</mark> Battle Rule is also enabled. This will persist until the wild Dynamax Pokemon reaches its damage threshold and its Dynamax state ends. After which, Poke Balls will become useable again.

If the SOS Battles plugin is installed, the <mark style="background-color:green;">"SOSBattle"</mark> and <mark style="background-color:green;">"totemBattle"</mark> rules are ignored and turned turned off for this battle.

</details>

<details>

<summary><mark style="background-color:green;">"noDynamax"</mark></summary>

You can use this rule to disable the ability to use Dynamax for certain trainers in this battle, even if they meet all the criteria otherwise. You can disable this for the player's side of the field, the opponent's, or for all trainers.\
\
This is entered as `setBattleRule("noDynamax", Symbol)`, where "Symbol" can be any one of the following:

* <mark style="background-color:yellow;">:Player</mark>\
  All trainers on the player's side will be unable to use Dynamax.
* <mark style="background-color:yellow;">:Opponent</mark>\
  All trainers on the opponent's side will be unable to use Dynamax.
* <mark style="background-color:yellow;">:All</mark>\
  All trainers on both sides in this battle will be unable to use Dynamax.

</details>

Page 94:

# Dynamax: Mid-Battle Scripting

This plugin adds various new keys to be used by the Deluxe Battle Kit's mid-battle scripting functionality.

***

<mark style="background-color:orange;">**Trigger Keys**</mark>

These are keys which trigger upon a battler utilizing Dynamax.

* <mark style="background-color:purple;">**"BeforeDynamax"**</mark>\
  Triggers when a battler is going to Dynamax this turn, but before that Pokemon actually Dynamaxes.<br>
* <mark style="background-color:purple;">**"BeforeGigantamax"**</mark>\
  Triggers when a battler is going to Gigantamax this turn, but before that Pokemon actually Gigantamaxes.<br>
* <mark style="background-color:purple;">**"AfterDynamax"**</mark>\
  Triggers after a battler successfully Dynamaxes.<br>
* <mark style="background-color:purple;">**"AfterGigantamax"**</mark>\
  Triggers after a battler successfully Gigantamaxes.

{% hint style="info" %}
Trigger Extensions: You may extend these keys with a species ID or a type ID to specify that they should only trigger when a specific species or species of a specific type triggers Dynamax. For example, <mark style="background-color:purple;">"BeforeDynamax\_PIKACHU"</mark> would trigger only when a Pikachu is about to Dynamax, where <mark style="background-color:purple;">"AfterGigantamax\_ELECTRIC"</mark> would trigger only after an Electric-type has Gigantamaxed.
{% endhint %}

***

<mark style="background-color:orange;">**Command Keys**</mark>

These are keys which trigger certain actions related to Dynamax to take place during battle, such as forcing a trainer to use Dynamax, or disabling its use.

<details>

<summary><mark style="background-color:blue;">"dynamax"</mark> => <mark style="background-color:yellow;">Boolean or String</mark></summary>

Forces the battler to Dynamax when set to `true`, as long as they are able to. If set to a string instead, you can customize a message that will display upon this Dynamax triggering. Note that this can even be used to force a wild Pokemon to Dynamax, as long as they are capable of it. If the Pokemon is forced to Dynamax prior to using their move that turn, their selected move will be converted to the Dynamaxed version of that move.\
\
Unlike using Dynamax naturally, you can use this to force it to happen at any point in battle, even at the end of the turn or after the battler has already attacked. This cannot happen if a different action with this battler has been chosen however, such as switching it out or using an item.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"disableDynamax"</strong></mark> => <mark style="background-color:yellow;">Boolean</mark></summary>

Toggles the availability of Dynamax for the owner of the battler. If set to `true`, Dynamax will be disabled for this trainer. If set to `false`, Dynamax will no longer be disabled, allowing this trainer to use it again even if they've already used Dynamax earlier in this battle.

</details>

***

<mark style="background-color:orange;">**Hardcoding**</mark>

Here's a list of methods and/or properties that you might want to reference when hardcoding a midbattle script, since this plugin adds a lot of new custom content which you may need to call on to make certain things happen:

<details>

<summary>Battle Class</summary>

* `pbHasDynamaxBand?(idxBattler)`\
  Returns true if the trainer who owns the battler at index `idxBattler` has an item in their inventory flagged as a Dynamax Band.<br>
* `pbGetDynamaxBandName(idxBattler)`\
  Returns the name of the specific item in a trainer's inventory flagged as a Dynamax Band. The specific trainer's inventory checked for is the one who owns the battler at index `idxBattler`.
* `pbCanDynamax?(idxBattler)`\
  Returns true if the battler at index `idxBattler` is capable of using Dynamax.
* `pbDynamax(idxBattler)`\
  Begins the Dynamax process for the battler at index `idxBattler`.

</details>

<details>

<summary>Battle::Battler Class</summary>

* `dynamax?`\
  Returns true if this battler is in the Dynamax state.<br>
* `gmax?`\
  Returns true if this battler is currently Gigantamaxed.<br>
* `emax?`\
  Returns true if this battler is currently Eternamaxed.<br>
* `dynamax_able?`\
  Returns true if this battler is not flagged in some way as being ineligible for Dynamax.<br>
* `gmax_factor?`\
  Returns true if this battler has G-Max Factor.
* `hasDynamax?`\
  Returns true if this battler meets all of the necessary conditions to use Dynamax.<br>
* `hasGmax?`\
  Returns true if this battler has a Gigantamax form.<br>
* `hasEmax?`\
  Returns true if this battler has an Eternamax form.<br>
* `unDynamax`\
  Forces a battler's Dynamax state to end, and reverts them back to their original form if necessary.<br>
* `display_dynamax_moves`\
  This converts all of the battler's moves into their compatible Max Move equivalents to be displayed in the Fight menu.

</details>

Page 95:

# Terastallization

[**Eevee Expo Link**](https://eeveeexpo.com/resources/1476/)

[**PokeCommunity Link**](https://www.pokecommunity.com/threads/terastallization-dbk-add-on-v21-1.525945/#post-10795127)

[**Download Link**](https://www.mediafire.com/file/8q5gh9u8sbeu9eu/Terastallization.zip/file)

This plugin builds upon the Deluxe Battle Kit to add the Terastallization battle mechanic introduced in *Pokemon Scarlet & Violet*. All functionality for this mechanic has been replicated in this plugin, and will work along side other battle gimmicks such as Mega Evolution without issue. In the following subsections, I'll go over specific areas of this plugin in more detail. Below, I'll go over general plugin functionality.

***

<mark style="background-color:orange;">**Terastal Availability**</mark>

Once this plugin is installed, Terastallization will be available to use right out of the gate. However, there are some criteria that must be met in order for the option to Terastallize to appear in battle. Below I'll go over all the factors for Terastallization eligibility, how to disable its availability, and various other settings related to its use.

<details>

<summary>General</summary>

Terastallization is available by default after installation. However, if you would like to disable the Terstallization mechanic entirely at any point, you may do so by using a game switch.&#x20;

In the plugin settings, there is a setting named `NO_TERASTALLIZE` which stores the switch number used for disabling Terstallization. This is saved as switch number `69` by default, but please renumber this if this conflicts with an existing game switch that you use.

If this switch is turned on, then Terstallization will be disabled for all trainers and Pokemon until the switch is turned back off. If you're plaing in debug mode, you can easily toggle this switch on and off by going into the debug menu and opening the "Deluxe plugin settings..." menu, and then selecting "Toggle Terastallization."

***

<mark style="background-color:yellow;">**Pokemon Requirements**</mark>

By default, all Pokemon are capable of Terastallization if the trainer meets the necessary requirements to utilize the mechanic. However, there are some exceptions. The following are all of the reasons why a Pokemon may be unable to Terastallize:

* The Pokemon is a Shadow Pokemon.
* The Pokemon is already Terastallized.
* The Pokemon is in Mega form, or meets all the criteria for Mega Evolution.
* The Pokemon is in Primal form, or meets all the criteria for Primal Reversion.
* The Pokemon is holding a Z-Crystal and is capable of using an eligible Z-Move.
* The Pokemon is in Ultra Burst form, or meets all the criteria for Ultra Burst.
* The Pokemon is in Dynamax form, or on a map that supports Dynamax and meets all the criteria for Dynamax.
* The Pokemon is Transformed into a species that has a unique Terastal form that cannot be duplicated.
* The Pokemon has a unique Terastal form, but is currently Transformed into a different species that would prevent it from entering that unique form.
* The Pokemon somehow doesn't have a Tera Type.
* The Pokemon has been manually flagged as unable to use Terastallization.
* The Pokemon is a member of a species that has been given the `CannotTerastallize` flag in its PBS data.

Note that if a Pokemon with Illusion is disguised as a species with a unique Terastal form, such as Ogerpon, its Illusion will automatically end if it attempts to Terastallize while disguised as that species. The Illusion will also fail to activate if the Pokemon in the player's last party slot is Terastallized into a unique Terastal form.

If you would like to flag a specific Pokemon as unable to use Terastallization, you may do so by setting `Pokemon.terastal_able = false`, where `Pokemon` is the specific Pokemon object that you'd like to flag.&#x20;

While playing in debug mode, this can also be done for the player's Pokemon by opening a Pokemon's debug options and selecting "Plugin attributes..." at the bottom of the list, and then selecting "Terastal..." From here, you can select "Set eligibility" to toggle the Pokemon's ability to use Terastallization.&#x20;

If you would like to flag an entire species as unable to use Terastallization instead of just a specific Pokemon, you may also do this by giving that species the `CannotTerastallize` flag in its PBS data.

Note that in any case where a Pokemon is unable to use Terastallization, it will be considered as having no Tera Type, and so this will be hidden from all displays that would show it.

***

<mark style="background-color:yellow;">**Debug Battle Options**</mark>

While playing in debug mode, you can manually edit Terastal options for trainers and Pokemon. To do so, open the debug menu while in battle (F9), and navigate to "Trainer options..." and then "Terastallization." You'll be able to toggle Terastallization availability for each trainer from here.

If you'd like to edit the Terastal attributes of specific battlers or party members, you may also do this by navigating to a specific Pokemon from the "Battlers..." or "Pokemon teams" options, and then scrolling down to the "Terastal values" option for that Pokemon.

</details>

<details>

<summary>Player</summary>

<mark style="background-color:yellow;">**Tera Orb**</mark>

To use Terastallization yourself, you'll first need to have an item in your inventory that unlocks the ability to use it. Any item given the `TeraOrb` flag in its PBS data will be considered a Tera Orb, which will allow you to Terastallize. By default, this plugin adds the Tera Orb introduced in *Pokemon Scarlet & Violet*. Feel free to create your own custom Tera items, too.\
\
In addition, the player also requires that their Tera Orb be charged in order to use Terastallization. The player's Tera Orb is depleted upon each use, and must be recharged between uses. You can recharge your Tera Orb by healing at a Pokemon Center. If you're currently on a map that is flagged as `AreaZero` in its map metadata, your Tera Orb will have infinite charge and won't require recharging.\
\
While playing in Debug mode, new options related to the player's Tera Orb will be added to the "Deluxe plugin settings..." in the debug menu. These can be found in the "Terastal settings..." option.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FmwbWlKeZYhpwEMFGJ9Rk%2F%5B2024-02-20%5D%2012_17_47.602.png?alt=media&#x26;token=8cb3c17a-8b0d-4b16-8aa9-cf0be1fa329a" alt="" data-size="original"> ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FcHVnbO5YljVsRcmVmcmf%2F%5B2024-02-20%5D%2012_17_50.113.png?alt=media\&token=25764c09-f86c-408e-89fc-c1e40d97fb9a)

* **Player's Tera Orb is charged**\
  This allows you to toggle the player's Tera Orb between a charged and uncharged state.
* **Tera Orb has infinite charge**\
  This allows you to toggle whether or not the player's Tera Orb requires charging between uses, or remains in a permanent charged state. This relies on a game switch to toggle on or off. This game switch is saved in the plugin settings as `TERA_ORB_ALWAYS_CHARGED`, and is set to game switch number `70` by default. Please renumber this if it conflicts with an existing switch number you use.

In addition, while playing in debug mode you may also hold `CTRL` while Terastallizing to keep your Tera Orb charged, or even hold the `CTRL` key while opening the Fight menu to force the Terastallization button to appear even if your Tera Orb is uncharged.

***

<mark style="background-color:yellow;">**Radiant Tera Jewel**</mark>

This plugin introduces a completely custom item not found in the original Pokemon Scarlet & Violet called the Radiant Tera Jewel. This is a unique item that may replenish your Tera Orb's charge during battle, allowing you to Terastallize an additional time during the same battle. Using this item in battle uses up the player's entire turn in order to try and keep it (sorta) balanced, so this will use up the turn for all of your Pokemon even if you have more than one Pokemon to issue commands to.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FdbA5b94pKAnKNJuwgXeY%2Fdemo46.gif?alt=media&#x26;token=447251ae-c818-467d-80c3-ba44aa960d32" alt="" data-size="original">

This is intended to be a "just for fun" item, and not to be used seriously, but it's there if you'd like to make use of it.

</details>

<details>

<summary>NPC Trainers</summary>

<mark style="background-color:yellow;">**Trainer Requirements**</mark>

Other trainers may utilize Terastallization too, whether they're opponents or partners. The requirements for this are the same as for the player, they are simply set up differently. Like with the player, the NPC trainer must be given an eligible Tera Orb in their inventory in order to use Terastallization. However, unlike the player, Tera Orbs owned by NPC trainers are always considered "charged", and don't require recharging between uses.

The Pokemon eligible to be Terastallized by an NPC trainer all follow the same rules as for the player. This means that any Pokemon in an NPC trainer's party which is considered an "exception" will not be considered for Terastallization. If you'd like to flag certain members of an NPC's party as ineligible for Terastallization, you may do so by setting `NoTera = true` for that Pokemon in the trainer's PBS data. This may also be done within the in-game trainer editor while playing in debug mode.

This setting can be useful if the trainer has a certain Pokemon in their party that would be entirely wasteful to use Terastallization on due to not having any offensive capabilities, or because changing their type might actually screw up some sort of specific strategy you have in mind for that trainer to use. You can also use this setting to force a trainer to only consider Terastallization for a certain member in their party by flagging all other members besides the one you want them to Terastallize with this flag.

***

<mark style="background-color:yellow;">**Terastal AI**</mark>

The Pokemon that an NPC trainer will Terastallize will be automatically determined by the trainer's AI. How effective this is depends on the skill level of each particular trainer. Below, I'll give a general description of how each trainer skill level will handle how to utilize Terastallization.

Note that Trainers who are given the `ReserveLastPokemon` flag in their PBS data will always save Terastallization for their final Pokemon, no matter what. This behavior will override what their natural AI behavior would otherwise be.

* **"Low" skilled trainers** (skill < 32)\
  Typically, the lowest skilled trainers will only ever consider how to use Terastallization offensively. This means if using Terastallization would give them an immediate offensive advantage due to dealing more raw damage to one of the currently active targets on the field, then they will use it.<br>
* **"Medium" skilled trainers** (skill >= 32)\
  Medium skilled trainers will also only consider Terastallization offensively, however they will gauge this across their entire party. So if Terastallization would give them an advantage, but there's another Pokemon in their party which would gain a substantially higher offensive advantage from Terastallization, then they will hold off on using it until they send out that Pokemon. This calculation is constantly checked each turn, so which Pokemon would be "best" to use Terastallization on may constantly change as the battle state progresses.<br>
* **"High" skilled trainers** (skill >= 48)\
  High skill trainers will consider Terastallization both offensively and defensively, and across their entire party. So if they calculate that Terastallization would grant them an advantage offensively, they will weigh this against how much this would cost them defensively. They'll calculate this for each member of their party, as well. If they have determined that their active Pokemon would gain a substantial offensive or defensive advantage from Terastallization, and that that this advantage in one area isn't outweighed by the cost of the other, then they'll choose to Terastallize that Pokemon.<br>
* **"Best" skilled trainers** (skill = 100+)\
  Trainers with the highest skill level will naturally be given the `ReserveLastPokemon` flag. Any trainer with this skill flag will always save Terastallization for their final Pokemon, no matter what. This will typically include trainers such as Gym Leaders and Elite Four members. If you choose to disable this flag for a trainer with this skill level, then their AI behavior will default to how "high" skilled trainers function.

For trainers of all skill levels, if they are down to their final Pokemon and have still yet to use Terastallization in this battle for some reason, then they may use it out of desperation even if it's not particularly advantageous. The will still avoid using it however if it would put them in a dramatically worse position, though (depending on their AI).

</details>

<details>

<summary>Wild Pokemon</summary>

Terastallization may also be utilized by wild Pokemon, without the need of a trainer or a Tera Orb. These wild Tera battles replicate how they work in *Pokemon Scarlet & Violet*, so they work a little differently than a standard wild battle.

When encountered, a wild Tera Pokemon will immediately Terastallize at the start of battle, before any commands can even be entered. When this happens, the Pokemon will become uncatchable until you break their Terastallization by lowering their HP to a certain threshold (1/6th of their max HP). Any damage dealt by direct attacks cannot exceed this threshold until the wild Pokemon's Terastallization is removed. When removed, the Pokemon will become catchable again like a normal wild Pokemon.

If the wild Pokemon is ineligible to use Terastallization for some reason, nothing will happen and the battle will just be a standard wild battle.\
\
To set up battles against wild Tera Pokemon, you may do so by using the <mark style="background-color:green;">"wildTerastallize"</mark> Battle Rule.

</details>

***

<mark style="background-color:orange;">**Terastal Count**</mark>

Essentials internally keeps track of a variety of the player's game statistics. One of those statistics is how many times the player has used Mega Evolution. To keep Terastallization in line with this, I've added trackers which will keep count of various statistics related to Terastallization, too.

Below are all of the new statistics tracked by this plugin, and how to call them.

* **Terastallization count**\
  This plugin keeps count of how many times the player has Terastallized. This can be called with the script `$stats.terastallize_count`.<br>
* **Wild Tera battles won**\
  This plugin keeps count of how many battles the player has won against wild Tera Pokemon. A "win" counts as either defeating or capturing the Pokemon to end the battle. This can be called with the script `$stats.wild_tera_battles_won`.<br>
* **Tera types changed**\
  This plugin keeps count of how many times the player has changes the Tera Type of their Pokemon. This only considers legitimate methods of changing Types through the use of Tera Shards, or other items which may change a Pokemon's Tera Type. Changing this through debug shortcuts or by hardcoding the change through a script will not count. This can be called with the script `$stats.total_tera_types_changed`.

Page 96:

# Terastal: Tera Types

A Pokemon's Tera Type determines the type it will change into when it Terastallizes. By default, the Tera Type of all Pokemon match their base typing. If the Pokemon has multiple types, then its Tera Type is randomly decided among one of its base types.

This subsection will go over all features and mechanics related to a Pokemon's Tera Type.

***

<mark style="background-color:orange;">**Setting Tera Types**</mark>

A Pokemon is assigned a Tera Type upon creation. However, for most Pokemon, this Tera Type isn't fixed and can be freely changed. This plugin allows you to set and edit a Pokemon's Tera Type in a variety of ways, though the particular way in which you may do this depends on whether the Pokemon is owned by the player or not.

Below, I'll go over all mechanics related to checking, setting or changing a Pokemon's Tera Type.

<details>

<summary>General</summary>

If you ever need to check the Tera Type of any defined Pokemon object through a script, you may do so by using the script `Pokemon.tera_type`, where `Pokemon` is the specific Pokemon object you are checking.&#x20;

This will return the type ID of that Pokemon's Tera Type. You may also manually set a Tera Type for this Pokemon object by using the script `Pokemon.tera_type = TYPE`, where `TYPE` is the ID of the specific type you want to set as that Pokemon object's Tera Type. You can use this to set specific Tera Types for wild or gifted Pokemon by creating the Pokemon objects first, and then editing their attributes in this way before initiating a wild battle with them or giving them to the player.

</details>

<details>

<summary>Player's Pokemon</summary>

The player can change the Tera Type of their Pokemon at any time by the use of Tera Shards. Tera Shards are items introduced in *Pokemon Scarlet & Violet* that could be given to an NPC in order for them to change a Pokemon's Tera Type into one that matched the type of that particular Tera Shard.

To simplify this, I removed the need for an NPC and simply made it so that using the Tera Shard items directly on your Pokemon will allow them to change Tera Types. However, I did retain the steep cost that *Scarlet & Violet* imposes, meaning that you'll need 50 of a particular type of shard in order to change a Pokemon's Tera Type.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FI88Z9b65cJJ5vN1VfsWR%2Fdemo47.gif?alt=media&#x26;token=5cb2c7ff-f06c-446f-80c3-ace6891c6025" alt="" data-size="original">

However, there is a setting provided by the plugin that allows you to change this if you're unhappy with the amount of Tera Shards required. In the settings file, you may set `TERA_SHARDS_REQUIRED` to whatever amount you want if you'd like to customize the number of shards required to change Tera Types.

In addition to Tera Shards, two additional custom items are added by this plugin to give you alternative ways of changing a Pokemon's Tera Type.

* **Mystery Tera Jewel**\
  When used on a Pokemon, this will change its Tera Type to a completely random type.
* **Master Tera Jewel**\
  When used on a Pokemon, this will allow you to manually select the exact Tera Type you wish to give it.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FWDiuhZ6OXX6uWIkQ8PnR%2Fdemo48.gif?alt=media&#x26;token=e87abf3d-475e-4b7f-8164-1bc87832ea0c" alt="" data-size="original">

When playing in debug mode, you can manually adjust a Pokemon's Tera Type at any time. This can be done by going into that Pokemon's debug menu in the party screen and selecting "Plugin attributes..." at the bottom of the list. From here, select "Terastal..." and then "Set Tera type" to set a new Tera Type.

***

<mark style="background-color:yellow;">**Checking for Tera Type**</mark>

If you need to check whether or not the player has a Pokemon in their party that has a particular Tera Type, you may do so by using the script:

```
$player.has_pokemon_tera_type?(type)
```

This will return true if the player has any Pokemon in their party with a Tera Type that matches the type ID entered in the `type` argument.

***

<mark style="background-color:yellow;">**Viewing Tera Types**</mark>

The player can view their Pokemon's Tera Type at any time by viewing the Summary page of that Pokemon. In here, you'll see the Pokemon's Tera Type displayed next to their base typing. If you would like to hide this display for some reason, you may do so within the plugin settings by setting `SUMMARY_TERA_TYPES` to `false`.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fr5TCPt2fVa57NtMwxaKU%2F%5B2024-01-26%5D%2011_18_36.649.png?alt=media&#x26;token=c8d04a42-7627-46d6-bae0-a86f2e9d021d" alt="" data-size="original">

Additionally, a Pokemon's Tera Type will also be displayed in the PC while viewing your Pokemon in storage. If you would like to hide this display, you may do so as well by setting `STORAGE_TERA_TYPES` to `false` in the plugin settings.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fo5sO0DfuQT2PCj8AZOUV%2F%5B2024-01-26%5D%2011_18_47.067.png?alt=media&#x26;token=88b1e66f-4592-4924-b68b-f94ea7109d09" alt="" data-size="original">

If you have the [**Enhanced Battle UI**](https://reliccastle.com/resources/1472/) plugin installed, you will also be able to see each battler's Tera Type in battle by viewing a battler's info page.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FYqR1w5UfUWnxRK47AaL1%2F%5B2024-01-26%5D%2011_19_24.394.png?alt=media&#x26;token=8e005929-4735-41d3-b12a-21e785bf5077" alt="" data-size="original">

</details>

<details>

<summary>NPC Trainer's Pokemon</summary>

The Tera Types of NPC trainer's Pokemon will naturally generate in the same way it does for any other Pokemon. However, you may set specific Tera Types for these Pokemon if you wish in that trainer's PBS data.

This can be done by setting `TeraType = TYPE` for the desired Pokemon, where `TYPE` is the ID for the specific type you want that Pokemon's Tera Type to be. This may also be done within the in-game trainer editor while playing in debug mode.

</details>

<details>

<summary>Wild Pokemon</summary>

Wild Pokemon can have their Tera Types edited in the same way any other Pokemon can have its attributes edited, which is described in the "General" section above.

However, you may also set a specific Tera Type for wild Pokemon by utilizing the <mark style="background-color:green;">"editWildPokemon"</mark> Battle Rule along with all of its variants introduced by the Deluxe Battle Kit. This can be done by setting up this rule as a hash, and entering `:tera_type => TYPE` within this hash for the desired Pokemon where `TYPE` is the ID of the specific type you want to set as that wild Pokemon's Tera Type.

For example, if you want to set a wild Flygon's Tera Type to Bug, you could implement it as such:

```ruby
setBattleRule("editWildPokemon", {
  :tera_type => :BUG
})
WildBattle.start(:FLYGON, 50)
```

For more information on this Battle Rule, refer to the "Deluxe Battle Rules" section of the tutorial.

</details>

<details>

<summary>Unchangeable Tera Types</summary>

While a Pokemon's Tera Type can be changed in most scenarios, there are certain species that may have a set Tera Type that cannot be changed or randomized at all. In *Pokemon Scarlet & Violet*, there are only two Pokemon which behave in this way. One is Ogerpon, which was introduced in the *Teal Mask* DLC, and the other is Terapagos, which was introduced in the *Indigo Disk* DLC. Neither of these species appear in Essentials by default, but if you have the [**Generation 9 Pack**](https://www.mediafire.com/file/ec07q2f29rdl1a5/Generation_9_Pack_v3.2.2.rar/file) installed, then both species will be present with this functionality already built in.

If you would like to customize your own species with a set Tera Type which may not be changed, you may do so be giving that species the flag `TeraType_TYPE` in its PBS data, where `TYPE` is the ID of the specific type you want that species' Tera Type to be.

For example, Teal Mask Ogerpon has the `TeraType_GRASS` flag set in its PBS data. This means that in this form, Ogerpon's Tera Type will always be Grass, and it may never be changed. However, Hearthflame Mask Ogerpon has the flag `TeraType_FIRE`, which means that in this form its Tera Type will always be Fire, and may never be changed.

You can use this flag if you want to lock certain species into specific Tera Types for some reason that cannot be altered in-game in any way.

</details>

<details>

<summary>Randomized Tera Types</summary>

If you would like Pokemon to generate with a random Tera Type instead of one that is always inherited from their base typing, there are some settings you may utilize to accomplish this. Note that when randomizing a Pokemon's Tera Type through any of the below methods, the Stellar type may never be randomly chosen.

***

<mark style="background-color:yellow;">**Randomizing Tera Types for Specific Pokemon**</mark>

If you only want to randomize the Tera Type of a particular Pokemon, you may do so by editing that Pokemon's Tera Type as you normally would, and setting it to `:Random` instead of a type ID.

For example, if you were to manually set a Tera Type on a particular Pokemon object through a script in the way outlined in the "General" section above, then you would set `Pokemon.tera_type = :Random`. If you'd like to set a random Tera Type on a wild Pokemon through the use of the <mark style="background-color:green;">"editWildPokemon"</mark> Battle Rule, then that may look something like this:

```ruby
setBattleRule("editWildPokemon", {
  :tera_type => :Random
})
WildBattle.start(:DITTO, 50)
```

***

<mark style="background-color:yellow;">**Randomizing Tera Types for a Single Species**</mark>

If you want all members of a particular species or form to always generate with a random Tera Type, then you may do so by utilizing the `TeraType_TYPE` flag, as described in the "Unchangeable Tera Types" section above. Except, instead of `TYPE` being a type ID, you would simply set it to `Random` instead.

For example, if you gave a species or form the flag `TeraType_Random`, then all Pokemon of that species or form would always generate with a randomized Tera Type. Note however that once this randomized Tera Type is set upon creation, it may never be changed.

***

<mark style="background-color:yellow;">**Randomizing Tera Types for All Possible Species**</mark>

If you want all possible Pokemon to spawn with a random Tera Type, this may also be done by turning on a specific switch. In the plugin settings, there is a setting named `RANDOMIZED_TERA_TYPES` which stores the switch number used for randomizing all Tera Types. This is saved as switch number `71` by default, but please renumber this if this conflicts with an existing game switch that you use.

If this switch is turned on, than all new Pokemon generated once that switch is activated will spawn with entirely random Tera Types. While playing in debug mode, you may quickly toggle this setting by going into the "Deluxe plugin settings..." of the debug menu and selecting "Terastal settings..." option. In here, you'll find on option called "Randomize Pokemon Tera types", which will allow you to toggle this feature.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FmwbWlKeZYhpwEMFGJ9Rk%2F%5B2024-02-20%5D%2012_17_47.602.png?alt=media&#x26;token=8cb3c17a-8b0d-4b16-8aa9-cf0be1fa329a" alt="" data-size="original">  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FpkyX44VzwnrtRmCoQLvy%2F%5B2024-02-20%5D%2012_32_57.842.png?alt=media\&token=ab2833af-30a4-425d-80bb-c37a9c040b69)

</details>

***

<mark style="background-color:orange;">**Stellar Tera Type**</mark>

In the Indigo Disk DLC for *Pokemon Scarlet & Violet*, a brand new 19th type was introduced called the Stellar type. This is a highly unique type in that no Pokemon has this type naturally, it may only be set as a Tera Type that Pokemon can Terastallize into. However, while a Pokemon is Terastallized into this type, they retain the defensive capabilities of their typing prior to Terastallizing, and only gain the offensive bonuses of this type.

The Stellar type has no weaknesses, resistances, or immunities, and it doesn't deal Super Effective damage against any other type. It is perfectly neutral in that regard. However, Stellar-type moves will deal Super Effective damage on Terastallized targets, regardless of their typing. However, the only Stellar-type moves available are the moves Tera Blast and Tera Starstorm, but only when the user is Terastallized into the Stellar-type.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FP1kjPrDfDn4A8dlmo4fH%2F%5B2024-01-26%5D%2011_21_36.258.png?alt=media&#x26;token=31564259-d735-4d56-9ec1-45fbc068cc75" alt="" width="384"><figcaption><p>Terastallization button for Tera Stellar.</p></figcaption></figure>

This plugin adds this new Stellar type to Essentials, with all of its mechanics in tact. The PBS data and graphics for this type are automatically included upon installation. However, keep in mind that this new type assumes you don't have any custom types implemented in your game. So if you do, you will likely have to edit the type numbering in their PBS data, as well as editing the `types` graphic located in `Graphics/UI`, and the `icon_types` graphic found in `Graphics/UI/Pokedex`.

Note that even though this plugin doesn't utilize the Stellar type for anything beyond its Terastallization mechanics, you're free to use this type however you please. So it's totally possible to create your own custom Stellar-type Pokemon or Stellar-type moves. However, this plugin does exclude Stellar from being a viable Hidden Power type.

***

<mark style="background-color:orange;">**Adding Support For New Types**</mark>

If your game includes custom types that aren't included in Essentials by default, you may need to edit some things in order for this plugin to work correctly. In `Graphics/Plugins/Terastallization`, you will find two images. One is labeled `cursor_tera`, and another labeled `tera_types`. The former is used for displaying the specific button used to Terastallize into that type, while the latter is used for displaying the actual icon for that Tera Type in various UI's.

For each custom type in your game, you must add a button and type icon to these images. Even if the custom type is flagged as `IsPseudoType = true` in its PBS data (like the `:QMARKS` type is), it requires its own button/icon added in the correct order to ensure the count is correct and the image won't be cut improperly when displaying these sprites.

As a quick reference, the dimensions for each button in `cursor_tera` must be <mark style="background-color:yellow;">150x46</mark>. The dimensions for each Tera Type icon in `tera_types` must be <mark style="background-color:yellow;">32x32</mark>.

***

<mark style="background-color:orange;">**Moves That Utilize Tera Type**</mark>

<mark style="background-color:yellow;">**Tera Blast**</mark>

The move Tera Blast is implemented by this plugin. This move's type changes to match whatever the user's Tera Type is while the user is Terastallized. This move is near-universal, and can be learned by mostly every Pokemon in the game.&#x20;

Because of this, manually adding the move to each species' learnset in their PBS data would be far too tedious. So instead, this plugin just assumes all Pokemon can learn the move via TM or Tutor. However, there are a few exceptions. The following species cannot be taught Tera Blast via TM or Tutor:

* Magikarp
* Ditto
* Smeagle
* Unown
* Wobbuffet
* Wynaut

These species are all blacklisted from being taught the move. Note that Smeargle can still learn the move through Sketch, it simply cannot be taught the move as a traditional tutor move. If you would like to add more species to this blacklist, you may do so in the plugin settings by adding the ID of the species you want to blacklist to the `TERABLAST_BANLIST` array.

{% hint style="info" %}
**Tera Starstorm**

Note that this plugin *does* add all the necessary functionality for the move Tera Starstorm, but the move itself is not provided in this plugin. This is due to the move only being learnable by Terapagos, which isn't found in Essentials by default.

However, if you have the [**Generation 9 Pack**](https://eeveeexpo.com/resources/1101/) installed, both Terapagos and Tera Starstorm will be added to your game, and will use this plugin to function as intended.
{% endhint %}

Page 97:

# Terastal: Tera Forms

With the introduction of the Teal Mask and Indigo Disk DLC for *Pokemon Scarlet & Violet*, new Terastal forms were introduced for Ogerpon and Terapagos, respectively. These unique forms are only accessible when these species Terastallize.&#x20;

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FMbZGg36Rk1aU3MyWQ4a9%2Fdemo52.gif?alt=media&#x26;token=98dbb00c-00ec-4e88-8580-9c2face03368" alt="" width="381"><figcaption><p>Ogerpon and Terapagos Tera forms.</p></figcaption></figure>

These are the only two Pokemon who have these Terastal Forms, however it's possible to make your own forms if you'd like. In this subsection, I'll briefly walk through an example of creating a Pokemon with a custom Terastal form.

***

<mark style="background-color:orange;">**Creating a Terastal Form**</mark>

To make a Terastal form, you'll need to set up several things. First, you need to actually create your form. Let's make a Terastal form for Charizard, since it's kinda shocking that Game Freak hasn't already made one for it. For the sake of example, let's make this Terastal form use form 4.

So in `pokemon_forms.txt`, we would enter our new Terastal form for Charizard. This form can have whatever properties you want, like any other form would. Different stats, different typing, etc. To allow Charizard to actually enter this form when Terastallizing however, we'll need to code our own Multiple Forms handler.

To do so, you can open your Essentials script and place this at the bottom of the `FormHandlers` section.

```ruby
MultipleForms.register(:CHARIZARD, {
  "getTerastalForm" => proc { |pkmn|
    next 4
  },
  "getUnTerastalForm" => proc { |pkmn|
    next 0
  }
})
```

* The `"getTerastalForm"` key determines which form Charizard will transform into when it Terastallizes. The line `next 4` makes it so in this scenario, Charizard will change into form 4 when it Terastallizes, which is the form that we entered in `pokemon_forms.txt`.
* The `"getUnTerastalForm"` key determines which form Charizard should revert to once Terastallization ends. The line `next 0` makes it so in this scenario, Charizard will revert to its base form when it leaves the Terastal state.

Now, whenever Charizard Terastallizes, it'll transform into its Terastal form. This is a very simplistic example, but it gets the idea across. You can expand upon this from here and make something far more complex with multiple different Terastal forms if you wish, like how Ogerpon works.

{% hint style="warning" %} <mark style="color:orange;">**Important!**</mark>\
If the species you want to make a Terastal form for already has an existing multiple forms handler elsewhere, the two handlers may overwrite one another. You can't have more than one handler for a single species at a time. Use CTRL + F to search the `FormHandlers` script for the species you want to make a form for first, to make sure an existing handler isn't already present.

If a handler does already exist, you'll have to add your Terastal form keys to the existing handler, instead of making a new one.
{% endhint %}

***

<mark style="background-color:orange;">**Pokedex Data Page Compatibility**</mark>

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fnp0AGhTuedBtFqM5WQk7%2F%5B2024-01-28%5D%2010_54_11.479.png?alt=media&#x26;token=9660b723-223f-401d-bc47-2ee32e575d09" alt="" width="384"><figcaption><p>The Data page for one of Ogerpon's Terastal forms.</p></figcaption></figure>

The [**Pokedex Data Page**](https://www.pokecommunity.com/threads/in-depth-pokedex-data-page-v21-1.500459/#post-10659145) plugin allows for Terastal Forms to have unique displays in the data page of the Pokedex. If you'd like your custom Terastal Form to be displayed in this way too, you can add an additional key to the form handler. Let's build off of the example above to demonstrate this.

```ruby
MultipleForms.register(:CHARIZARD, {
  "getTerastalForm" => proc { |pkmn|
    next 4
  },
  "getUnTerastalForm" => proc { |pkmn|
    next 0
  },
  "getDataPageInfo" => proc { |pkmn|
    next [pkmn.form, 0] if pkmn.form == 4
  }
})
```

Here, we've added a third key called `"getDataPageInfo"`. This is what is needed for compatibility with the data page. The array in `next [pkmn.form, 0]` needs to contain up to three elements:

* The Pokemon's current form. This can always just be set as `pkmn.form` to accomplish this.
* The form that the Pokemon reverts to once Terastallization ends. In our example, this is form 0.
* \[Optional] The ID of any unique item the Pokemon should be holding for this form, if any. Terastallization doesn't require a held item, so this isn't really necessary. But your custom Terastal form may require one, so you may enter one if it does.

Finally, the `if pkmn.form == 4` part of the line makes it so that this information is only returned when Charizard is in form 4, which is its Terastal form. This is what prevents this data from displaying when viewing any one of Charizard's other forms. This might be far more complex depending on the specific form handler you set up, but this is a general example of how this may be done.&#x20;

Page 99:

# Terastal: Animations

The Deluxe Battle Kit incorporates various animation utilities which it uses to animate Mega Evolution and Primal Reversion. This plugin utilizes these same utilities to implement a new animation for Terastallization that is built in the same animation style.

There's a bit to explain about these animations and how they work, so I'll provide a break down of everything in this section.

{% hint style="info" %}
Note: If you already have an existing Terastallization animation which is stored as a Common animation named `"Terastallization"`, that animation will take priority over the animation added by this plugin. This means that there's no risk of your animation being overwritten or ignored, nor do you need to change anything to make this plugin compatible.
{% endhint %}

***

<mark style="background-color:orange;">**Trainer Terastallization**</mark>

Terastallization typically requires a trainer with a Tera Orb and a Pokemon with a Tera Type to Terastallize into. If so, the option to Terastallize that Pokemon will appear in battle. When triggered, the Terastallization animation will play.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F8qF9bk69IKDB0R4P1ji4%2Fdemo50.gif?alt=media&#x26;token=a392e623-51bb-4fdf-954d-2ac667e0c040" alt="" width="381"><figcaption><p>Terastallization on the player's side.</p></figcaption></figure>

There will be slight differences in the animation based on which side of the field the Terastallized Pokemon is on. Pokemon on the player's side of the field will face right, and their trainer will slide in from off screen on the left. If the Pokemon is on the opponent's side of the field, they will face left and their trainer will slide in from off screen on the right. This helps distinguish if the Terastallized Pokemon is friend or foe during the animation.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FiTl3rcZyJQ0m80o5Xo3H%2Fdemo49.gif?alt=media&#x26;token=3e7d93eb-02c0-495b-acf5-204f82b6d24b" alt="" width="381"><figcaption><p>Terastallization on the opponent's side.</p></figcaption></figure>

Terastal Animations will always display the trainer's Tera Orb above the trainer during the animation. The trainer's item may not always be the same, however. The Tera Orb is the default item used, but it's possible to give trainers unique items that trigger Terastallization. If you create unique Tera items for a trainer to utilize along with the necessary sprites, then the sprite for that unique item will appear in this animation instead of the default Tera Orb.

***

<mark style="background-color:orange;">**Wild Terastallization**</mark>

Typically, wild Pokemon are incapable of Terastallizing. This is because a trainer with a corresponding Tera Orb is required. However, this plugin includes a feature that allows wild Pokemon to Terastallize on their own without a trainer, by utilizing the <mark style="background-color:green;">"wildTerastallize"</mark> Battle Rule (more details on this can be found in the "Terastal: Battle Rules" subsection). This bypasses the Tera Orb requirement, allowing the wild Pokemon to Terastallize.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F7Ntu3nTHUxZjnuPSJZA2%2Fdemo51.gif?alt=media&#x26;token=fe147921-43be-4aeb-804c-fd9549082584" alt="" width="381"><figcaption><p>Wild Terastallization animation.</p></figcaption></figure>

The animation for wild Terastallization is mostly the same. The only obvious difference is that no trainer slides on screen during the animation, since no trainer exists.

***

<mark style="background-color:orange;">**Animation Utilities**</mark>

<mark style="background-color:yellow;">**Skipping Animations**</mark>

You may have noticed in the examples above that during the Terastal animation, a button prompt on the bottom left-hand corner of the screen appears. This "skip" button indicates that you can cut the animation short by pressing the `ACTION` key. Pressing it will immediately end the animation, allowing you to get right back to the battle if you grow tired of sitting through these animations.

<mark style="background-color:yellow;">**Turning Off Animations**</mark>

If you want to turn these animations off entirely, there are two ways to accomplish this. First, you may do so by turning off battle animations completely in the Options menu.&#x20;

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FwOMVVwf7z58G4TSKSGM6%2F%5B2024-01-12%5D%2011_58_20.948.png?alt=media&#x26;token=36cd6063-28d1-4886-9f6e-49bbf7642b8f" alt="" width="384"><figcaption><p>Battle animations in the Options menu.</p></figcaption></figure>

If so, this animation will also be turned off. Instead, it'll be replaced with a generic "quick-change" animation which happens instantaneously.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FePzUFbCkbPLwJGKXlvqB%2Fdemo54.gif?alt=media&#x26;token=d6be105e-cea7-400f-b021-c07a383c6cfc" alt="" width="381"><figcaption><p>Quick-change animation.</p></figcaption></figure>

The second way to turn off the animation would be to open the settings file in this plugin. Here, you'll find the setting `SHOW_TERA_ANIM`. If you set this to `false`,  the Terastal animation will be shut off permanently, and will be replaced with the quick-change animation above, even when battle animations are turned on.

***

<mark style="background-color:orange;">**Other Animations**</mark>

There are some additional animations added by this plugin related to Terastallization.

<mark style="background-color:yellow;">**Tera Break**</mark>

This is the animation used when a Pokemon's Terastallization is forcefully ended. This may only happen if a Terastallized Pokemon is KO'd, or if a wild Tera Pokemon reaches a certain HP threshold where their Terastallization state is abruptly ended. If so, their crystallized form will "shatter" and break off of the Pokemon. It's a simple animation, but it helps to emphasize a more dramatic end to the Terastal state than simply fading away as it does in most other scenarios.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F8nVOnGSr5cLiGhpUemzF%2Fdemo55.gif?alt=media&#x26;token=4772ef5a-82fc-4de1-99be-fedc0dbdc662" alt="" width="381"><figcaption><p>Example of a Tera Break animation.</p></figcaption></figure>

<mark style="background-color:yellow;">**Tera Burst**</mark>

This animation is used whenever a Pokemon in a Terastal state is about to execute a damage-dealing move that is receiving a power boost due to Terastallization. For example, if a Pokemon has Terastallized into a Fire-type, moves used by that Pokemon that deal Fire-type damage will display this animation before use. This is even true if the move isn't Fire-type naturally, but has been turned into a Fire-type move due to an effect, such as Tera Blast.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FhO7klNdqD8JTLKdwd9nA%2Fdemo56.gif?alt=media&#x26;token=72caf413-1e85-4211-ab1f-2c8b59f05c38" alt="" width="381"><figcaption><p>Example of a Tera Burst animation.</p></figcaption></figure>

Note that if the user is Terastallized into the Stellar-type, this animation will play whenever their selected move is being boosted by the Stellar type. This can happen once per type in a single battle. The only exception to this is Terapagos, who's moves are boosted indefinitely while Terastallized into the Stellar type, so it will always play this animation.

***

<mark style="background-color:orange;">**Tera Visuals**</mark>

<mark style="background-color:yellow;">**Tera Type Icons**</mark>

When a Pokemon Terastallizes, the Tera Type icon of their new type will be displayed next to their databoxes, similar to icons for other mechanics such as Mega Evolution and Primal Reversion. This will allow the player to see the current type of all Terastallized Pokemon at all times, since no Tera hats are displayed here, unlike in Scarlet & Violet.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fc2wQnMMvUYSeL0w1t2HH%2F%5B2024-01-26%5D%2011_29_27.067.png?alt=media&#x26;token=85ddea7d-fe44-4e36-b1df-91341e0c8fe8" alt="" width="384"><figcaption><p>Example of Tera Type icons.</p></figcaption></figure>

<mark style="background-color:yellow;">**Terastal Overlays**</mark>

While in the Terastal state, a Pokemon's sprite will be overlayed with a crystallized pattern. This color of this pattern will reflect their current type while Terastallized. If you would rather turn this pattern off and display the Pokemon's sprites normally, you may do so by setting `SHOW_TERA_OVERLAY` to `false` in the plugin settings.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FQB2stranJslMGdS9Sbyj%2F%5B2024-01-26%5D%2011_30_57.074.png?alt=media&#x26;token=cfb59fc3-f976-4f77-b81b-86d9d69e9d28" alt="" width="384"><figcaption><p>Example of a Tera crystal overlay.</p></figcaption></figure>

Each Tera type has its own colored overlay pattern. These can be found in `Graphics/Plugins/Terastallization/Patterns`, and are named `tera_pattern_TYPE`, where `TYPE` is the ID of the Tera type for that overlay. If you add a custom Tera type without an overlay pattern, then the default white overlay will be used instead, which is the same pattern used for Tera Normal.

<mark style="background-color:yellow;">**Animating Terastal Overlays**</mark>

The overlay displayed on Terastal sprites is a pattern than can actually move around in a loop, creating an animation of sorts. By default, this overlay will scroll to the right in an erratic fashion, creating a shimmery effect.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FRTIp7LmHsDyBJPKbiA8s%2Fterastal.gif?alt=media&#x26;token=a1bd2a33-e1bc-45c6-bde4-1ef99cb78c06" alt="" width="382"><figcaption><p>Example of an animated terastal pattern.</p></figcaption></figure>

To edit how this pattern moves, you simply have to open the plugin Settings and find the setting `TERASTAL_PATTERN_MOVEMENT`. You will see that this is set to an array containing two symbols.

The first element in this array corresponds to how the overlay animates along the X-axis. The second element in this array corresponds to how the overlay animates along the Y-axis. By combining different settings for each axis, you can control how the pattern moves.

If you'd prefer that the pattern is a still image that doesn't animate, then you would just set this as `[:none, :none]` to prevent any movement on either axis.

Page 100:

# Terastal: Battle Rules

These are new battle rules added by this plugin related to Terastallization.

<details>

<summary><mark style="background-color:green;">"wildTerastallize"</mark></summary>

You can use this rule to flag wild Pokemon encountered in this battle as capable of using Terastallization, even though they don't have a trainer with a Tera Orb. Wild Pokemon will always Terastallize immediately upon being encountered, prior to any commands even being entered. The <mark style="background-color:green;">"midbattleScript"</mark> Battle Rule is ignored when this rule is enabled, since wild Tera Battles use their own midbattle script to apply damage thresholds on the Tera Pokemon.&#x20;

This is entered as `setBattleRule("wildTerastallize")`

When this rule is enabled, the <mark style="background-color:green;">"disablePokeBalls"</mark> Battle Rule id also enabled. This will persist until the wild Tera Pokemon reaches its damage threshold and its Terastallization state ends. After which, Poke Balls will become useable again.

If the SOS Battles plugin is installed, the <mark style="background-color:green;">"SOSBattle"</mark> and <mark style="background-color:green;">"totemBattle"</mark> rules are ignored and turned turned off for this battle.

</details>

<details>

<summary><mark style="background-color:green;">"noTerastallize"</mark></summary>

You can use this rule to disable the ability to use Terastallization for certain trainers in this battle, even if they meet all the criteria otherwise. You can disable this for the player's side of the field, the opponent's, or for all trainers.\
\
This is entered as `setBattleRule("noTerastallize", Symbol)`, where "Symbol" can be any one of the following:

* <mark style="background-color:yellow;">:Player</mark>\
  All trainers on the player's side will be unable to use Terastallization.
* <mark style="background-color:yellow;">:Opponent</mark>\
  All trainers on the opponent's side will be unable to use Terastallization.
* <mark style="background-color:yellow;">:All</mark>\
  All trainers on both sides in this battle will be unable to use Terastallization.

</details>

Page 101:

# Terastal: Mid-Battle Scripting

This plugin adds various new keys to be used by the Deluxe Battle Kit's mid-battle scripting functionality.

***

<mark style="background-color:orange;">**Trigger Keys**</mark>

These are keys which trigger upon a battler utilizing Terastallization or its mechanics.

* <mark style="background-color:purple;">**"BeforeTerastallize"**</mark>\
  Triggers when a battler is going to Terastallize this turn, but before that Pokemon actually Terastallizes.<br>
* <mark style="background-color:purple;">**"AfterTerastallize"**</mark>\
  Triggers after a battler successfully Terastallizes.<br>
* <mark style="background-color:purple;">**"BeforeTeraMove"**</mark>\
  Triggers right before a battler's selected move boosted by Terastallization is about to be executed.

{% hint style="info" %}
Trigger Extensions 1: You may extend these keys with a species ID or a type ID to specify that they should only trigger when Terastallizing a specific species, or species with a specific Tera Type. For example, <mark style="background-color:purple;">"BeforeTerastallize\_OGERPON"</mark> would trigger only when an Ogerpon is about to Terastallize, where <mark style="background-color:purple;">"AfterTerastallize\_STELLAR"</mark> would trigger only after a Pokemon has Terastallized into the Stellar-type.
{% endhint %}

{% hint style="info" %}
Trigger Extensions 2: For the <mark style="background-color:purple;">"BeforeTeraMove"</mark> key specifically, you can also use a move ID to specify a specific move. For example, <mark style="background-color:purple;">"BeforeTeraMove\_TERABLAST"</mark> would only trigger before the move Tera Blast is used, but only if the move is being boosted by Terastallization.
{% endhint %}

***

<mark style="background-color:orange;">**Command Keys**</mark>

These are keys which trigger certain actions related to Terastallization to take place during battle, such as forcing a trainer to Terastallize, or disabling its use.

<details>

<summary><mark style="background-color:blue;"><strong>"terastallize"</strong></mark><strong> => </strong><mark style="background-color:yellow;"><strong>Boolean or String</strong></mark></summary>

Forces the battler to Terastallize when set to `true`, as long as they are able to. If set to a string instead, you can customize a message that will display upon this Terastallization triggering. Note that this can even be used to force a wild Pokemon to Terastallize, as long as they are capable of it.\
\
Unlike natural Terastallization, you can use this to force Terastallization to happen at any point in battle, even at the end of the turn or after the battler has already attacked. This cannot happen if a different action with this battler has been chosen however, such as switching it out or using an item.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"disableTera"</strong></mark><strong> => </strong><mark style="background-color:yellow;"><strong>Boolean</strong></mark></summary>

Toggles the availability of Terastallization for the owner of the battler. If set to `true`, Terastallization will be disabled for this trainer. If set to `false`, Terastallization will no longer be disabled, allowing this trainer to use it again even if they've already used Terastallization prior in this battle.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"battlerTeraType"</strong></mark><strong> =>  </strong><mark style="background-color:yellow;"><strong>Symbol</strong></mark></summary>

Changes the Tera type of a battler. This must be set to a valid type ID, such as `:FIRE`. This won't do anything if the battler already has the entered Tera type, or if the entered type ID is flagged as a pseudo-type, such as `:QMARKS`. Pokemon who are locked into a specific Tera type (such as Ogerpon and Terapagos) will not have their Tera types changed.

Note that this change in Tera type is permanent, and will persist outside of battle for player-owned Pokemon.

</details>

***

<mark style="background-color:orange;">**Hardcoding**</mark>

Here's a list of methods and/or properties that you might want to reference when hardcoding a midbattle script, since this plugin adds a lot of new custom content which you may need to call on to make certain things happen:

<details>

<summary>Battle Class</summary>

* `pbHasTeraOrb?(idxBattler)`\
  Returns true if the trainer who owns the battler at index `idxBattler` has an item in their inventory that allows for Terastallization.<br>
* `pbGetTeraOrbName(idxBattler)`\
  Returns the name of the specific item in a trainer's inventory that allows for Terastallization. The specific trainer's inventory checked for is the one who owns the battler at index `idxBattler`.
* `pbCanTerastallize?(idxBattler)`\
  Returns true if the battler at index `idxBattler` is capable of Terastallizing.<br>
* `pbTerastallize(idxBattler)`\
  Begins the Terastallization process for the battler at index `idxBattler`.

</details>

<details>

<summary>Battle::Battler Class</summary>

* `tera?`\
  Returns true if this battler is Terastallized.<br>
* `tera_form?`\
  Returns true if this battler is Terastallized into a unique Tera Form.<br>
* `hasTera?`\
  Returns true if this battler is capable of using Terastallization.<br>
* `unTera(break)`\
  Forces a battler's Terastallization state to end. If the `break` argument is set to true, the battler's Terastallization will end with a dramatic Tera Break animation, instead of simply fading away.&#x20;

</details>

Page 102:

# Improved Item AI

[**Eevee Expo Link**](https://eeveeexpo.com/resources/1537/)

[**PokeCommunity Link**](https://www.pokecommunity.com/threads/improved-item-ai-dbk-add-on-v21-1.529639/#post-10844983)

[**Download Link**](https://www.mediafire.com/file/6qilhl4q2jlui69/Improved_Item_AI.zip/file)

This plugin builds upon the Deluxe Battle Kit to improve upon the AI when it comes to using items from the inventory. This will generally allow AI trainers to use items more intelligently and less wastefully. AI trainers will now also consider using items to restore HP, PP, or cure the status conditions of their entire party, and not just their active Pokemon.

This also expands upon the types of items the AI is able to use in battle, allowing them to access all of the same items that the player would be able to use. This means you can give NPC's more unique items that they normally wouldn't know how to use, such as Ethers, Guard Spec. or even more obscure things like the Poke Flute.

***

<mark style="background-color:orange;">**AI Item Scores**</mark>

This plugin overhauls how the AI determines to use items by implementing a "scoring" system that works very similarly to how the AI scores moves to determine which to use. While playing in debug mode, you can even turn on battle logging to be able to view the AI's decision making in regards to items within the game console.

In the plugin file `[001] Battle_AI`, you will find the following settings:

```ruby
ITEM_FAIL_SCORE    = 20
ITEM_USELESS_SCORE = 60
ITEM_BASE_SCORE    = 100
```

These are what determines the base values the AI utilizes when it comes to scoring moves. These are identical values used for move calculation, and works similarly here. You may adjust these to your liking.

***

<mark style="background-color:orange;">**Item Utilities**</mark>

This plugin adds several scripting utilities to the Battle class that may be used to make coding your own AI handlers a bit easier. Below I'll cover each new method included:

<details>

<summary>Utilities</summary>

* `pbItemHealsHP?(item, onlyHP = false)`\
  This returns true if the `item` ID entered is a healing item. This includes any item included in the `HP_HEAL_ITEMS` hash or the `FULL_RESTORE_ITEMS` array in the `AI_UseItem` section in Essentials. If `onlyHP` is set to true, then this will only return true if the item heals HP only with no other effects (basically, this would exclude Full Restore items).<br>
* `pbItemCuresStatus?(item, oneStatus = false)`\
  This returns true if the `item` ID entered is an item that cures status conditions. This includes any item included in the `ONE_STATUS_CURE_ITEMS` or `ALL_STATUS_CURE_ITEMS` arrays in the `AI_UseItem` section in Essentials. If `oneStatus` is set to true, then this will only return true if the item only heals one particular status condition (basically, this would exclude Full Heal items).<br>
* `pbItemRaisesStats?(item, oneStat = false)`\
  This returns true if the `item` ID entered is an item that raises a battler's stats. This includes any item included in the `ONE_STAT_RAISE_ITEMS` hash or the `ALL_STATS_RAISE_ITEMS` array in the `AI_UseItem` section in Essentials. If `oneStat` is set to true, then this will only return true if the item only raises one particular stat (basically, this would exclude items like Max Mushrooms).<br>
* `pbItemRevivesFainted?(item)`\
  This returns true if the `item` ID entered is an item that revives fainted Pokemon. This includes any item included in the `REVIVE_ITEMS` hash in the `AI_UseItem` section in Essentials.<br>
* `pbItemRestoresPP?(item, mode = 0)`\
  This returns true if the `item` ID entered is an item that restores PP. This includes any item included in the `PP_HEAL_ITEMS` or `ALL_MOVE_PP_HEAL_ITEMS` hashes in the `[001] Battle_AI` file in this plugin. If `mode` is set to 1, then this will only return true for Ether-like items that only restore the PP for a single move. If `mode` is set to 2, then this will only return true for Elixir-like items that restore the PP for all moves. Otherwise, this will return true if the item is either.<br>
* `pbGetItemValue(item, itemType)`\
  Returns the value of the entered `item` ID. The "value" of an item is based on what symbol is entered as the item's `itemType`.
  * When `:potion`, the item's value is how much HP it heals.
  * When `:ether`, the item's value is how much PP it restores to a single move.
  * When `:elixir`, the item's value if how much PP is restored to all moves.
  * When `:stats`, the item's value is how many stages this item increases a stat by.
  * When `:revive`, the item's value is a 7 if the item fully revives, and a 5 otherwise.<br>
* `pbHasHealingItem?(idxBattler, healAmt, itemType)`\
  Returns true if the trainer who owns the battler with the entered index `idxBattler` has a healing item in their inventory of a certain `itemType` that heals less than `healAmt`. This can be used to check if a trainer has weaker healing items in their inventory, or a healing item that restores less than a certain value.\
  \
  The `itemType` is set to `:potion` by default, which checks specifically for HP restoring items. However, you can set this to `:ether` or `:elixir` instead, if you want to check for specific types of PP restoring items rather than HP. The `healAmt` is set to 1000 by default, which is enough to cover every healing item in the game (since things like Max Potion have a healing value of 999).

</details>

Page 103:

# Item AI: Handlers

The AI for each individual item is implemented modularly, similar to how the AI for individual moves is implemented in base Essentials. You can create your own AI item handler for any item you want that is usable in battle. However, the type of handler you need to use varies based on that specific item's `BattleUse` property, which is set in the `items.txt` PBS file.

There are three different types of handlers that can be set for specific items, and a fourth handler which can be set for more general application. I will outline the specifics of each handler type below.

Note that the AI skill level of a particular trainer can significantly change the performance of each handler.

***

<mark style="background-color:orange;">**Handler: PokemonItemEffectScore**</mark>

This is the handler used for items that have `BattleUse = OnPokemon` set in their PBS data. Items with this type of battle use can be used on both active battlers and party Pokemon in reserve. This is the most common way an item can be used in battle, so this is the most commonly used handler.

Below are all of the items that use this handler, and a general description of how the AI is scripted to use them. If you want to see specific examples of this type of AI item handler, they can be found in the plugin file named `[002] OnPokemon Handlers`.

<details>

<summary>HP Healing Items</summary>

This includes all items included in the `HP_HEAL_ITEMS` hash located in `AI_UseItem` in base Essentials. The AI will typically not care to use these items if the Pokemon in their party are still healthy and have roughly 55% of their HP or more remaining. Otherwise, the AI will score the value of using any particular healing item by calculating how much HP the item would recover vs how much wasted healing the item would do.

For example, if a Pokemon's HP is at 40/100, using a Hyper Potion would be wasteful since Hyper Potions heal 120 HP, meaning that 60 points of healing would be wasted on healing this Pokemon. If the AI has access to something like a Super Potion in their inventory, then they will be more incentivized to use that item instead, since it only heals 50-60 HP which would not result in any waste.

Generally, healing will be prioritized more on active battlers if any are predicted to faint this turn due to indirect damage such as through statuses like Poison, or other effects. Depending on the AI's skill level, it will also prioritize healing if the only valid target to heal is their final remaining Pokemon in their party.&#x20;

Pokemon that have any attributes that would prefer higher HP will also cause the AI to be more likely to heal them. These attributes include things like having moves that deal more damage based on how high the user's HP is (Water Spout, Eruption, Final Gambit, etc), held items that only trigger at full HP (Focus Sash), abilities that only trigger at full HP (Multiscale, Sturdy, etc), or if the Pokemon is below half HP and they have an ability that can re-trigger each time their HP falls below half (Berserk, Anger Shell) or an an ability like Defeatist that weakens them if their HP is low.

Here's a list of every item that uses this AI:

* Potion
* Super Potion
* Hyper Potion
* Max Potion
* Full Restore
* Berry Juice
* Sweet Heart
* Fresh Water
* Soda Pop
* Lemonade
* Moomoo Milk
* Oran Berry
* Sitrus Berry
* Energy Powder
* Energy Root
* Rage Candy Bar (depending on Generation)

Note that for the Full Restore in particular, this item is treated as a combination of a Max Potion and a Full Heal. So the AI calculations for both of these items are combined when determining whether or not to use one. If using a Full Restore would both recover HP and also heal a status condition at the same time, then it will be more highly prioritized. If using a Full Restore would only heal HP, then it will be less prioritized compared to the other items on this list.

</details>

<details>

<summary>Single Status Cure Items</summary>

This includes all items included in the `ONE_STATUS_CURE_ITEMS` array located in `AI_UseItem` in base Essentials. The AI for these items will differ based on which status condition is being healed.

Generally speaking, the AI will not waste using these items on a Pokemon who is already holding an item that will trigger to cure their current status condition (such as status cure berries), or if they have an ability that may do the same. It will also not waste these items if the Pokemon would actually prefer to keep its status condition for some reason, such as if it's powered up by an ability like Guts or Toxic Boost, or receives passive benefits from it through abilities like Poison Heal. If the status condition deals indirect damage, but the Pokemon is immune to indirect damage thanks to the Magic Guard ability, then the AI will not waste the items healing the condition. \
\
The AI will also be less incentivized to use these items if the battler or its ally partner has an ability that may prematurely end its status condition, such as Shed Skin, Healer, or Natural Cure, or if the battler has the Hydration ability in the rain. This is also true if the Pokemon is an active battler and already has moves that can cure its status condition (Refresh, Rest, Heal Bell, etc.), or has a move that actually prefers to keep its condition (Facade).

Finally, if the Pokemon is a battler with low HP or is predicted to faint this round due to the indirect damage of a status condition, then the AI will be more likely to want to cure the condition. If the status condition affects one of the battler's stats, such as Burn does with Attack or Paralysis does with Speed, then the AI is more likely to want to cure this condition if that stat is worthwhile to the battler.

Here's a list of every item that uses this AI:

* Awakening
* Chesto Berry
* Blue Flute
* Antidote
* Pecha Berry
* Burn Heal
* Rawst Berry
* Paralyze Heal
* Cheri Berry
* Ice Heal
* Aspear Berry

Note that when the Blue Flute in particular is used on an active battler, there is an additional check to see if the battler has the Soundproof ability. If so, the AI will be unable to use this item to cure the Sleep condition.

</details>

<details>

<summary>Full Status Cure Items</summary>

This includes all items included in the `ALL_STATUS_CURE_ITEMS` array located in `AI_UseItem` in base Essentials. The AI for these items are identical to the single status cure items in the above section, except it will change based on the specific status condition.

Additionally, full status cure items may also heal confusion, which is also calculated by the AI when factoring in the total score. Typically, the AI will be less incentivized to use a full status cure item if they already have a single status cure item that can be used to cure the specific status instead. However, if the Pokemon is a battler who suffers from both a status condition and confusion at the same time, then the full status cure item will be prioritized more.

Here's a list of every item that uses this AI:

* Full Heal
* Full Restore
* Lava Cookie
* Old Gateau
* Castelia Cone
* Lumiose Galette
* Shalour Sable
* Big Malasada
* Pewter Crunchies
* Lum Berry
* Heal Powder
* Rage Candy Bar (depending on Generation)

Note that for the Full Restore in particular, this item is treated as a combination of a Max Potion and a Full Heal. So the AI calculations for both of these items are combined when determining whether or not to use one. If using a Full Restore would both recover HP and also heal a status condition at the same time, then it will be more highly prioritized. If using a Full Restore would only cure a status condition, then it will be less prioritized compared to the other items on this list.

</details>

<details>

<summary>Revival Items</summary>

This includes all items included in the `REVIVE_ITEMS` hash located in `AI_UseItem` in base Essentials. The AI behind using these items are comparatively simple compared to other items, as they will never be used unless the trainer has fainted Pokemon to revive. If so, they will have a high likelihood to use a revival item, especially if they're down to their last Pokemon, or the opponent has more remaining Pokemon than they do. Max Revive-like items that fully revive a Pokemon tend to be more highly prioritized.

If the AI has a relatively high skill and have multiple fainted Pokemon to revive, it will score each fainted Pokemon to revive based on how useful their moves would be versus the current opponents. For example, if there are two possible Pokemon to revive but one of them have moves that would deal Super Effective damage against the current opposing battlers, then that Pokemon is more likely to be revived than the other.

Here's a list of every item that uses this AI:

* Revive
* Max Revive
* Revival Herb
* Max Honey

</details>

<details>

<summary>PP Recovery Items</summary>

This includes all items included in the `PP_HEAL_ITEMS` and `ALL_MOVE_PP_HEAL_ITEMS` hashs located in `[001] Battle_AI` in this plugin's files. The AI will typically not care to use these items unless one of their Pokemon's moves have ran out of PP. If so, the AI will score the value of restoring PP to that move based on how much overall PP this would restore. If a Pokemon has multiple moves with PP worth restoring, it'll score each move individually to consider which is most worth restoring PP to.&#x20;

Depending on the AI's skill level, status moves will generally be less desirable to restore PP to than damage-dealing moves. Also, the AI will be less incentivized to restore PP to Pokemon who have low HP, especially if their are HP healing items that could be used instead. If the Pokemon is an active battler and is predicted to faint this round anyway due to indirect damage, then the AI will not bother using PP recovery items at all.

Here's a list of every item that uses this AI:

* Ether
* Max Ether
* Leppa Berry
* Hopo Berry (Gen 9 Pack)
* Elixir
* Max Elixir

</details>

***

<mark style="background-color:orange;">**Handler: BattlerItemEffectScore**</mark>

This is the handler used for items that have `BattleUse = OnBattler` set in their PBS data. Items with this type of battle use can only be used on an active battler owned by the trainer. This is used almost exclusively by X Items that boost a battler's stats, though there are a few other oddball items that also use this.

Below are all of the items that use this handler, and a general description of how the AI is scripted to use them. If you want to see specific examples of this type of AI item handler, they can be found in the plugin file named `[003] OnBattler Handlers`.

<details>

<summary>Stat Boosting Items</summary>

This includes all items included in both the `ONE_STAT_RAISE_ITEMS` and `ALL_STATS_RAISE_ITEMS` hashes located in `AI_UseItem` in base Essentials. The AI will generally want to use these items if the stat boost they grant would be relevant and useful to one of their active battlers. If the stat boost wouldn't be of any use, such as an Attack boost on a battler with only special moves, then the AI won't waste the item. The battler's current HP is also factored in when deciding to use a stat boosting item, as it would be pointless to use one on a battler who is unlikely to survive another hit, or is predicted to faint this turn anyway due to indirect damage.

If there are other scenarios where boosting a stat would be pointless or detrimental, such as if the foe has the Unaware ability or the user has the Contrary ability, then the AI will also not consider using the item. The AI will generally be less incentivized to use a stat boosting item if any of the opposing battlers have a move that could negate, steal, or invert the stat boost (Haze, Topsy Turvey, Psych Up, etc.), or have a move that will become more threatening with heightened stats (Punishment). If the user is under some effect or has some item/ability that prevents stat loss however (Mist, Clear Body, Clear Amulet, etc.), the AI will be more incentivized to use a stat boosting item since the battler is less likely to have it lowered again.

Generally speaking, if the battler already has a move in that can raise a particular stat, then the AI will be less incentivized to use an item on them that boosts that stat. This is especially true if the battler has a move that raises multiple stats at once.

Here's a list of every item that uses this AI:

* X Attack
* X Defense
* X Sp. Atk
* X Sp. Def
* X Speed
* X Accuracy
* Max Mushrooms

Note that the improved versions of each X item that boost stats by 2, 3, or 6 stages also use this same AI. The number of stages the items boost by are factored in when deciding which to use. More stages are always better, unless the user is already nearly at the stat cap and any additional stages would be wasted.

The Max Mushrooms item uses this same AI too, but it runs the calculation 5 times for each of the main battle stats. It then combines the value of raising each worthwhile stat to determine its overall value.

</details>

<details>

<summary>Critical Hit Boosting Items</summary>

The AI will generally want to use these items on a battler if that battler is capable of utilizing a heightened critical hit ratio. This means that if the battler has no usable damage-dealing moves, then the AI won't bother using the item on them. This is also true if the battler would gain no benefit from the heightened crit ratio due to already stacking effects that guarantee a critical hit (Super Luck ability, critical hit boosting item, etc.).

The battler's current HP is also factored in when deciding to use a critical hit boosting item, as it would be pointless to use one on a battler who is unlikely to survive another hit, or is predicted to faint this turn anyway due to indirect damage. The AI will be incentivized to use the item on a battler if that battler's offensive stats have been lowered, as a critical hit would allow them to bypass those stat drops. The AI will also be more incentivized to use the item if the battler has moves or effects that can benefit from the heightened critical hit chance, such as the Sniper ability.

However, if the AI sees that the opposing Pokemon have an effect or ability that negates critical hits altogether (Lucky Chant, Battle Armor), or an ability that benefits them when critically hit (Anger Point), then the AI will be less incentivized to use the item. If the battler already has a move that can boost their own critical hit ratio, the AI will also be less incentivized to use the item. This is also true if the battler already has access to a move that is guaranteed to deal critical hits anyway (Frost Breath, Storm Throw), or if they have moves that deal fixed damage and cannot ever deal a critical hit.

Here's a list of every item that uses this AI:

* Dire Hit
* Dire Hit 2
* Dire Hit 3

Note that the number of stages these items boost the battler's critical hit ratio by are factored in when deciding which to use. More stages are always better, unless the user is already nearly +3 and any additional stages would be wasted.

</details>

<details>

<summary>Confusion Curing Items</summary>

The AI will generally want to use these items on a battler if that battler is confused. However, the AI won't bother if the battler is holding an item or has an ability that will already cure their confusion. This is also true if the battler is predicted to faint this round anyway due to indirect damage.

Generally speaking, the more remaining turns of confusion the battler has left, the more incentivized the AI will be to cure it with these items. This is even more likely if the battler's Attack stat has been raised, since this means it may suffer even more self-inflicted damage from confusion. The AI will also be more incentivized to use these items if the battler is suffering additional conditions that may prevent it from acting, such as Paralysis or infatuation. The AI will be slightly less incentivized to cure confusion if the battler has an ability that prefers that the user is confused, such as the Tangled Feet ability.

Here's a list of every item that uses this AI:

* Persim Berry
* Yellow Flute

Note that when the Yellow Flute in particular is used on an active battler, there is an additional check to see if the battler has the Soundproof ability. If so, the AI will be unable to use this item to cure confusion.

</details>

<details>

<summary>Red Flute</summary>

The AI will generally want to use this item on a battler if that battler is infatuated. However, the AI won't bother if the battler is holding an item or has an ability that will already cure their infatuation. This is also true if the battler is predicted to faint this round anyway due to indirect damage. The AI will be more incentivized to use these items if the battler is suffering additional conditions that may prevent it from acting, such as Paralysis or confusion.

If the selected battler has the Soundproof ability, this item will be unable to be used on them, and thus the AI will disregard using it.

</details>

***

<mark style="background-color:orange;">**Handler: ItemEffectScore**</mark>

This is the handler used for items that have `BattleUse = Direct` set in their PBS data. Items with this type of battle use don't target any Pokemon at all, and are instead just applied generally. These types of items have the widest potential of effects due to this, although very few items that function in this way are present in the series.

Below are all of the items that use this handler, and a general description of how the AI is scripted to use them. If you want to see specific examples of this type of AI item handler, they can be found in the plugin file named `[004] Direct Handlers`.

<details>

<summary>Guard Spec.</summary>

The AI will generally have a slight desire to use this item whenever it's available. However, the AI won't bother using it at all if the Mist effect is already in play on their side of the field.

The AI will generally be less incentivized to use this item if any of their active battlers have the Defiant or Competitive abilities, as this item would prevent them from triggering. However, the AI will be more incentivized to use this item if it detects any moves on the opponent's active battlers that could lower stats, or if any of the AI's active battlers have had any of their stats changed previously.

</details>

<details>

<summary>Poke Flute</summary>

This item uses the exact same AI as the status cure AI used for the Blue Flute. However, the Poke Flute calculates this score for each active battler on the field, including foes. It then calculates what the total value would be for waking up each sleeping Pokemon and combines the total score to determine the value of using this item.

Waking up ally battlers is almost always considered beneficial, unless the battler would prefer to stay asleep for some reason. While waking up foes is almost always considered detrimental, unless the foe would prefer to stay asleep for some reason.

</details>

<details>

<summary>Plugin Exclusive Items</summary>

This plugin includes AI handlers for several items added by other add-on plugins. These include:

* Z-Booster (Z-Power add-on)
* Wishing Star (Dynamax add-on)
* Radiant Tera Jewel (Terastallization add-on)

If any of the above items are available in your game, AI trainers will now be capable of using them, too. Generally speaking, the AI will not bother to use any of these items if they are incapable of using the specific mechanic linked to each item for some reason. They will be incentivized to use them however, if their are remaining Pokemon in their party who would be capable of utilizing the mechanic linked to that item.

</details>

***

<mark style="background-color:orange;">**Handler: GeneralItemScore**</mark>

This handler is different from the ones listed above in that this isn't used for any one particular item. Instead, this handler is applied more generally and tweaks the AI's calculation for each item it scores after running one of the other handlers above. You can use these types of handlers to influence how the specific AI trainer behaves more generally when it comes to items.

By default, this plugin only contains one such handler, which uses the ID `:inventory_count`. This handler incentivizes the AI's used of an item based on how many copies of that item they have left in their inventory. More copies means the AI is more encouraged to use that item, while less copies means it'll be encouraged to use them more conservatively.

There's no real limit in how this handler can be used, though. For instance, if you wanted to make a specific trainer type have a certain type of behavior that you want reflected in how they use items, you can use this handler to accomplish this.

Below are just some basic examples of ideas you could incorporate using this handler.

<details>

<summary>Example 1</summary>

Let's say you wanted to make it so that a certain type of "rich kid" trainer type would be more likely to use items in battle, because you wanted to express that they're wealthy and don't care about wasting money. Here's a basic example of a handler you could make to emphasize this:

```ruby
Battle::AI::Handlers::GeneralItemScore.add(:rich_trainer,
  proc { |score, item, ai, battle|
    next score if score <= Battle::AI::ITEM_USELESS_SCORE
    trainers = (ai.trainer.side == 0) ? battle.player : battle.opponent
    trainer = trainers[ai.trainer.trainer_index]
    base_money = trainer.base_money
    if base_money >= 160
      old_score = score
      score += 20 
      PBDebug.log_score_change(score - old_score, "prefers to use item because trainer is rich")
    end
    next score
  }
)
```

Now, with this `:rich_trainer` handler, any trainer type who has a `BaseMoney` value of 160 or higher in the `trainer_type.txt` PBS file will have 20 points added to their overall item scores for all items in their inventory. This means that these trainers will be more encouraged to use items generally when compared to others.

</details>

<details>

<summary>Example 2</summary>

Let's say you want to make a trainer that has healing items in their inventory, but you want them to behave in a way where they will save all of their healing items for their final Pokemon. One way you could do that is by giving that trainer type a flag that you can later check with this handler.

```ruby
Battle::AI::Handlers::GeneralItemScore.add(:reserve_healing_items,
  proc { |score, item, ai, battle|
    next score if !battle.pbItemHealsHP?(item)
    if ai.trainer.has_skill_flag?("ReserveHealingItems")
      remaining_count = battle.pbTeamAbleNonActiveCount(ai.user.index)
      if remaining_count > 0
        old_score = score
        score = Battle::AI::ITEM_FAIL_SCORE
        PBDebug.log_score_change(score - old_score, "fails because of trainer's flag (ReserveHealingItems)")
      end		
    end
    next score
  }
)
```

Now, with this `:reserve_healing_items` handler, whenever the AI wants to use a healing item, it will check if the trainer has the `"ReserveHealingItems"` flag. If so, the AI will disregard using those healing items unless it's down to its last Pokemon.

</details>

Page 104:

# Wonder Launcher

[**Eevee Expo Link**](https://eeveeexpo.com/resources/1538/)

[**PokeCommunity Link**](https://www.pokecommunity.com/threads/wonder-launcher-dbk-add-on-v21-1.529640/#post-10844985)

[**Download Link**](https://www.mediafire.com/file/za6gonky4rymaeh/Wonder_Launcher.zip/file)

This plugin builds upon the Deluxe Battle Kit to add the Wonder Launcher functionality to your trainer battles. The Wonder Launcher was a feature that was introduced in *Pokemon Black & White*. In these games, you had the ability to queue for special PvP battles online where players had the ability to use items from their inventory during a competitive match - a first in the series.

However, these were not ordinary items from your bag. Instead, each player was given a special set inventory of items that could be launched onto the battlefield. These included typical healing items such as Potions, Revives, and status cures, as well as X items that would boost a Pokemon's stats. Additionally, each player had to earn the right to use one of these items during battle by spending a number of points relative to the quality of the selected item; points which were earned at the start of each turn. This plugin aims to replicate this mechanic which will allow you to participate in Wonder Launcher battles against NPC trainers in Essentials.

In the following subsections, I'll go into detail about the various aspects and features of this plugin.

***

<mark style="background-color:orange;">**General Plugin Utilities**</mark>

<details>

<summary>Enabling Wonder Launcher battles</summary>

You can enable the Wonder Launcher globally for all trainer battles by default by using a switch. The switch number used for this can be found by going into this plugin's files and opening the Settings file.

Here, you will find a setting called `WONDER_LAUNCHER_SWITCH`. This is where the switch number used to toggle Wonder Launcher battles on or off is stored. By default, this switch number is set to `72`, but please set this to whatever switch number you want if this overlaps with an existing switch that you are using elsewhere. While playing in debug mode, you can quickly toggle this switch by going to "Deluxe plugin settings..." in the debug menu, and using the "Toggle Wonder Launcher" setting.

Once your preferred switch number is set and you turn this switch on in-game, all trainer battles will use the Wonder Launcher.

If you ever want to turn this feature off and disable the Wonder Launcher mechanic for all trainer battles, you can do so by simply turning this game switch off again.

</details>

<details>

<summary>Customizing Launcher Points (LP)</summary>

<mark style="background-color:yellow;">**LP Gains**</mark>

During a Wonder Launcher battle, each trainer gains LP at the start of each turn. By default, this is only a single point per turn. However, you can customize the number of points gained each turn in the plugin Settings by setting `WONDER_LAUNCHER_POINTS_PER_TURN` to your desired amount.

***

<mark style="background-color:yellow;">**Maximum LP**</mark>

Each trainer can only carry a max number of LP before they will no longer gain any more. By default, this is capped at 14 points. However, you can customize what the max number of points should be in the plugin Settings by setting `WONDER_LAUNCHER_MAX_POINTS` to your desired amount.

***

<mark style="background-color:yellow;">**LP Splash Bars**</mark>

During a Wonder Launcher battle, a splash bar will appear on screen each time a trainer's LP totals change to indicate what their current totals are. Because LP is gained at the start of each turn, this also means that these splash bars will appear on screen for each trainer at the start of each turn. If you dislike this and don't want this to display every turn, you can simply disable it by opening the plugin Settings and setting `SHOW_LAUNCHER_SPLASH_EACH_TURN` to `false`.

</details>

***

<mark style="background-color:orange;">**Wonder Launcher Count**</mark>

Essentials internally keeps track of a variety of the player's game statistics. I've added trackers which will keep count of various statistics related to the Wonder Launcher, too.

Below are all of the new statistics tracked by this plugin, and how to call them.

* **Launched item count**\
  This plugin keeps count of how many times the player has spent LP to launch an item with the Wonder Launcher. This can be called with the script `$stats.wonder_launcher_item_count`.<br>
* **Wonder Launcher battles won**\
  This plugin keeps count of how many Wonder Launcher battles the player has won. This can be called with the script `$stats.wonder_launcher_battles_won`.

Page 105:

# Launcher: Plugin Overview

When the Wonder Launcher is enabled, all trainer's inventories are swapped out with a temporary Wonder Launcher inventory. Unlike the player's usual inventory, Wonder Launcher inventories only have two "pockets" - a Medicine pocket which include all basic Potions, Revives, Ether/Elixirs, and status cures; as well as a Battle pocket which include all X items, Dire Hit, Guard Spec., and a few exclusive Wonder Launcher items.

These items are all infinite in supply, however they may only be used by expending a number of points. Below, I'll go into detail about Wonder Launcher mechanics.

{% hint style="info" %}
**Item Limit**

Note that unlike in *Pokemon Black & White*, you may only launch an item with the Wonder Launcher once per turn. This means that in double or triple battles, only one of your Pokemon's turns can be used to launch an item, and you'll be prevented from selecting another item that turn. This limitation has been set both for balance reasons due to certain Launcher items being buffed, and also to simplify the battle AI.
{% endhint %}

***

<mark style="background-color:orange;">**Enabling a Wonder Launcher Battle**</mark>

To even enter a Wonder Launcher battle, you must first enable these types of battles to occur. Only trainer battles may be fought as Wonder Launcher battles, so wild battles will never be affected even if the feature is turned on.

By default, the Wonder Launcher feature will be disabled for all trainer battles. To enable it, this can be done in one of two ways.

<details>

<summary>Battle Rule</summary>

You may set the <mark style="background-color:green;">**"wonderLauncher"**</mark> Battle Rule prior to a trainer battle to enable the Wonder Launcher for that battle only. More on this is covered in the "Launcher: Battle Rules" subsection.

</details>

<details>

<summary>Game Switch</summary>

When enabled with a switch, you can enable the Wonder Launcher globally for all trainer battles by default. The switch number used for this can be found by going into this plugin's files and opening the Settings file.

Here, you will find a setting called `WONDER_LAUNCHER_SWITCH`. This is where the switch number used to toggle Wonder Launcher battles on or off is stored. By default, this switch number is set to `72`, but please set this to whatever switch number you want if this overlaps with an existing switch that you are using elsewhere. While playing in debug mode, you can quickly toggle this switch by going to "Deluxe plugin settings..." in the debug menu, and using the "Toggle Wonder Launcher" setting.

Once your preferred switch number is set and you turn this switch on in-game, all trainer battles will use the Wonder Launcher.

If you ever want to turn this feature off and disable the Wonder Launcher mechanic for all trainer battles, you can do so by simply turning this game switch off again.

</details>

***

<mark style="background-color:orange;">**Launcher Points**</mark>

Launcher Points, or "LP" for short, is the currency required to Launch items onto the battlefield during a Wonder Launcher battle. Each item in your Wonder Launcher inventory requires a certain number of points to use, relative to the quality of the item. Each trainer gains LP at the start of each turn. Deciding whether to stock up on LP for stronger items or to use LP immediately for a head start is part of the strategy of Wonder Launcher battles.

<details>

<summary>Accruing LP</summary>

<mark style="background-color:yellow;">**LP Gains**</mark>

Each trainer gains LP at the start of each turn. By default, this will only be 1 LP per turn, however you may change this to a different value if you wish by opening the plugin Settings and changing `WONDER_LAUNCHER_POINTS_PER_TURN` to a different amount.

If a trainer has less remaining Pokemon on the battlefield than the opponent, they will gain an additional +1 LP per turn. Obviously, this is only really relevant in double or triple battles. This gives the losing trainer a chance for a comeback by saving up for a Revive item faster.

***

<mark style="background-color:yellow;">**Maximum LP**</mark>

Each trainer can only hold a maximum of 14 LP by default. After which, any additional LP gains will go to waste. However, you may change this max LP cap if you wish by opening the plugin Settings and changing `WONDER_LAUNCHER_MAX_POINTS` to a different amount. Note however, that all UI displays related to the Wonder Launcher are designed with the default cap in mind, so you may have to manually adjusts some visuals if you decide to exceed this default limit.

***

<mark style="background-color:yellow;">**Debug Options**</mark>

Finally, while playing in debug mode, you can manually assign the current LP totals of any trainer during battle by opening the debug menu, selecting "Trainer options..." and selecting "Launcher Points" to assign the LP for each trainer.&#x20;

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FJ5MdioDusve6Z7qIbsno%2F%5B2024-06-26%5D%2012_41_53.566.png?alt=media&#x26;token=0e89d70c-31a2-48be-ab76-e8a042ffaeff" alt="" data-size="original">  ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FW0NHCCwNPcIc3j4yLlZI%2F%5B2024-06-26%5D%2012_41_11.742.png?alt=media\&token=d01c3132-4311-450d-8b1f-3c0f39fde74f)

If you select the "Wonder Launcher" option, you can completely disable the ability to accrue or spend any LP at all for each trainer.

</details>

<details>

<summary>Spending LP</summary>

To actually use the LP you gain to launch items, you have to select an item from your Wonder Launcher inventory. This can be done by selecting the LAUNCH command in the command menu, which replaces the normal BAG command option during Wonder Launcher battles.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fj2flaJ2hNxSocxbh7VJR%2F%5B2024-06-26%5D%2012_40_42.992.png?alt=media&#x26;token=64076996-d128-4ca4-a131-97a0693f65d9" alt="" data-size="original">

When you open the Wonder Launcher inventory, you'll notice that there's some slight differences to the normal inventory screen. There are only two viewable "pockets" in this inventory - Medicine and Battle items. Both of these types of items function identically to their normal equivalents, though there are a few key differences.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fu59zcKIiBfvz9t3bJPm8%2F%5B2024-06-26%5D%2012_46_27.392.png?alt=media&#x26;token=a72761f0-b343-4102-915e-1c7f7c5670aa" alt="" data-size="original">

Firstly, you'll notice that while scrolling through these item lists, there isn't a quantity listed for each item. This is because items in the Wonder Launcher inventory are infinite in supply. Instead, the LP cost required will be listed next to each item. In order to use a listed item in this inventory, you need to have enough accrued LP to spend on them.

On the left side of the screen, a unique window will be shown that displays the player's Current LP. This will be displayed as a gauge with several blue pips that indicate your total LP count thus far. While your cursor is hovered over an item, this meter will display red pips which indicate just how much of your LP the highlighted item would consume when used. This quickly gives you a visual indication of the cost of each item, and how many points you'd have remaining after its use.

</details>

<details>

<summary>Battle Visuals</summary>

During a Wonder Launcher battle, each trainer's LP will be tracked visually with a splash bar that will appear on screen whenever a trainer's LP totals change, such as when they Launch items. This helps indicate each trainer's current remaining LP total. These bars will display the name of the trainer, as well as a character icon (if one is available) to distinguish which trainer's LP you are viewing.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FY1uT757h5o4vaAiIZDMM%2Flauncher.gif?alt=media&#x26;token=1ca36abe-7cdc-479f-80fb-1a2a6ac85c76" alt="" data-size="original">

Since LP is gained at the start of each turn, this means these bars will appear on screen at the start of each turn for each trainer as well. If you dislike this or find it annoying to display each turn, you may disable this by opening the plugin Settings and setting `SHOW_LAUNCHER_SPLASH_EACH_TURN` to `false`.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fd0oLiFDganqC4vBRXnVS%2Fpointgain.gif?alt=media&#x26;token=73968b55-b509-4ddb-b659-d480b129608a" alt="" data-size="original">

Note that LP bars will linger on screen for about 2 seconds each time they slide in. However, pressing the `USE` button while they linger will force them to hide immediately, so you can speed this animation up in this way.

If you happen to have the Enhanced Battle UI add-on plugin installed, you can view all trainer's current LP  at any point during command selection by opening the battler selection menu with the `JUMPUP` (A) key. If so, each trainer's LP totals will appear parallel to their party ball icons.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FeN4u9zlwsp9GKS401t7q%2F%5B2024-06-26%5D%2012_42_15.103.png?alt=media&#x26;token=a46ee6f7-a87e-490c-8da4-617646d3f97c" alt="" data-size="original">

</details>

***

<mark style="background-color:orange;">**Wonder Launcher Inventory**</mark>

The stock of items available to each trainer in a Wonder Launcher battle is generally the same and have an infinite supply. These items will replace whatever inventory the trainer would normally have in a regular battle.

Note however that even while in a Wonder Launcher battle, all trainers will still retain any Key Items that would be in their normal inventories, they just won't be visible during the battle. So you can still give trainers items such as a Mega Ring and have them use Mega Evolution during a Wonder Launcher battle, even though their normal inventories are replaced with the Wonder Launcher inventory.

Below, I'll list all possible items that will appear in a trainer's Wonder Launcher inventory by default.

{% tabs %}
{% tab title="Medicinal Items" %}
These are all of the items that will appear in the Medicine pocket of the Wonder Launcher inventory by default.

<table><thead><tr><th width="188">Item</th><th width="102" align="center">LP Cost</th><th width="130" align="center">Target</th><th>Effect</th></tr></thead><tbody><tr><td>Potion</td><td align="center">2</td><td align="center">User Party</td><td>Heals 20 HP.</td></tr><tr><td>Super Potion</td><td align="center">4</td><td align="center">User Party</td><td>Heals 60 HP.</td></tr><tr><td>Hyper Potion</td><td align="center">8</td><td align="center">User Party</td><td>Heals 120 HP.</td></tr><tr><td>Max Potion</td><td align="center">10</td><td align="center">User Party</td><td>Heals all HP.</td></tr><tr><td>Full Restore</td><td align="center">13</td><td align="center">User Party</td><td>Heals all HP and status.</td></tr><tr><td>Awakening</td><td align="center">4</td><td align="center">User Party</td><td>Cures Sleep.</td></tr><tr><td>Antidote</td><td align="center">4</td><td align="center">User Party</td><td>Cures Poison.</td></tr><tr><td>Burn Heal</td><td align="center">4</td><td align="center">User Party</td><td>Cures Burn.</td></tr><tr><td>Paralyze Heal</td><td align="center">4</td><td align="center">User Party</td><td>Cures Paralysis.</td></tr><tr><td>Ice Heal</td><td align="center">4</td><td align="center">User Party</td><td>Cures Freeze.</td></tr><tr><td>Full Heal</td><td align="center">5</td><td align="center">User Party</td><td>Cures status and confusion.</td></tr><tr><td>Revive</td><td align="center">11</td><td align="center">User Party</td><td>Revives with half HP.</td></tr><tr><td>Max Revive</td><td align="center">14</td><td align="center">User Party</td><td>Revives with full HP.</td></tr><tr><td>Ether</td><td align="center">4</td><td align="center">User Party</td><td>Restores a move's PP by 10.</td></tr><tr><td>Max Ether</td><td align="center">6</td><td align="center">User Party</td><td>Fully restores a move's PP.</td></tr><tr><td>Elixir</td><td align="center">8</td><td align="center">User Party</td><td>Restores all move PP by 10.</td></tr><tr><td>Max Elixir</td><td align="center">10</td><td align="center">User Party</td><td>Fully restores all move PP.</td></tr></tbody></table>

{% hint style="info" %}
**PP Healing Items**

In the original Wonder Launcher battles in *Pokemon Black & White*, PP healing items such as Ethers and Elixirs were not included as Wonder Launcher items, even though data for these are found in the code. For the purposes of this plugin, I chose to include them anyway and gave them LP costs that I thought would be appropriate based on the other items.
{% endhint %}
{% endtab %}

{% tab title="Battle Items" %}
These are all of the items that will appear in the Battle pocket of the Wonder Launcher inventory by default. The X \<Stat> items listed here is just a placeholder to refer to all of the X Items for each stat (X Attack, X Defense, etc.).

<table><thead><tr><th width="188">Item</th><th width="102" align="center">LP Cost</th><th width="130" align="center">Target</th><th>Effect</th></tr></thead><tbody><tr><td>X &#x3C;Stat></td><td align="center">3</td><td align="center">User Battler</td><td>Increases &#x3C;Stat> by 1 stage.</td></tr><tr><td>X &#x3C;Stat> 2</td><td align="center">5</td><td align="center">User Battler</td><td>Increases &#x3C;Stat> by 2 stages.</td></tr><tr><td>X &#x3C;Stat> 3</td><td align="center">7</td><td align="center">User Battler</td><td>Increases &#x3C;Stat> by 3 stages.</td></tr><tr><td>X &#x3C;Stat> 6</td><td align="center">12</td><td align="center">User Battler</td><td>Increases &#x3C;Stat> by 6 stages.</td></tr><tr><td>Dire Hit</td><td align="center">3</td><td align="center">User Battler</td><td>Increases critical hit ratio by 1 stage.</td></tr><tr><td>Dire Hit 2</td><td align="center">5</td><td align="center">User Battler</td><td>Increases critical hit ratio by 2 stages.</td></tr><tr><td>Dire Hit 3</td><td align="center">7</td><td align="center">User Battler</td><td>Increases critical hit ratio by 3 stages.</td></tr><tr><td>Guard Spec.</td><td align="center">3</td><td align="center">User Side</td><td>Starts the Mist effect on the user's side.</td></tr><tr><td>Reset Urge</td><td align="center">9</td><td align="center">Any Battler</td><td>Resets a target's stat changes.</td></tr><tr><td>Ability Urge</td><td align="center">3</td><td align="center">Any Battler</td><td>Reactivates a target's ability.</td></tr><tr><td>Item Urge</td><td align="center">2</td><td align="center">Any Battler</td><td>Forces a target's held item to trigger.</td></tr><tr><td>Item Drop</td><td align="center">6</td><td align="center">Any Battler</td><td>Removes a target's held item.</td></tr></tbody></table>

{% hint style="info" %}
**X \<Stat> Items**

Something to note with X \<Stat> items is that in later gens (Gen 7 onwards), these items were changed so that they grant +2 stages to a stat, rather than +1. For the purposes of Wonder Launcher battles, this makes these items completely redundant with the X \<Stat> 2 items, as they would now effectively do the same thing. Because of this, the base X \<Stat> items will not appear in the Wonder Launcher inventory if Essential's `MECHANICS_GENERATION` setting is set to Gen 7 or higher.

If you'd like them to still appear regardless of generation, you could also set `X_STAT_ITEMS_RAISE_BY_TWO_STAGES` to `false` in Essentials.
{% endhint %}

{% hint style="info" %}
**"Urge" Items**\
In the original Wonder Launcher battles in *Pokemon Black & White*, the various "Urge" items (Reset Urge, Ability Urge, Item Urge, Item Drop) could only target one of the trainer's own active battlers, similar to X Items.

However, I thought that this was too limiting and made them too niche to ever want to really use. So for the purposes of this plugin, I've changed it so that these items can be used to target *any* battler on the field, including opponents.

This can open up some new strategies, such as resetting an opponent's increased stat stages (Reset Urge), forcing them to re-trigger an ability if it would benefit you in some way (Ability Urge), or forcing them to trigger an item earlier than they wanted to, or to drop the item altogether (Item Urge, Item Drop).
{% endhint %}
{% endtab %}

{% tab title="Plugin-Exclusive Items" %}
These items will also appear in the Battle pocket of the Wonder Launcher inventory, but only under certain conditions when certain add-on plugins are installed.

<table><thead><tr><th width="188">Item</th><th width="102" align="center">LP Cost</th><th width="130" align="center">Target</th><th>Effect</th></tr></thead><tbody><tr><td>Z-Booster</td><td align="center">7</td><td align="center">User Trainer</td><td>Only appears if the trainer has an eligible Z-Ring.<br>When used, replenishes the trainer's Z-Ring so that they may use a Z-Move again.</td></tr><tr><td>Wishing Star</td><td align="center">7</td><td align="center">User Trainer</td><td>Only appears if the trainer has an eligible Dynamax Band.<br>When used, replenishes the trainer's Dynamax Band so that they may use Dynamax again.</td></tr><tr><td>Radiant Tera Jewel</td><td align="center">7</td><td align="center">User Trainer</td><td>Only appears if the trainer has an eligible Tera Orb.<br>When used, replenishes the trainer's Tera Orb so that they may use Terastallization again.</td></tr></tbody></table>
{% endtab %}
{% endtabs %}

***

<mark style="background-color:orange;">**Item Details**</mark>

Certain items used with the Wonder Launcher have specific mechanics that I'll outline below.

<details>

<summary>Item Urge</summary>

This item can target any battler on the field to force that target to consume its held item to immediately use its effects. However, this is only limited to certain items that do something when consumed. The following are all of the items that can be potentially triggered via an Item Urge:

* Oran Berry
* Sitrus Berry
* Berry Juice
* Enigma Berry
* Aguav Berry
* Figy Berry
* Iapapa Berry
* Mago Berry
* Wiki Berry
* Pecha Berry
* Chesto Berry
* Cheri Berry
* Rawst Berry
* Aspear Berry
* Persim Berry
* Lum Berry
* Leppa Berry
* Hopo Berry (Gen 9 Pack)
* Liechi Berry
* Ganlon Berry
* Kee Berry
* Petaya Berry
* Apicot Berry
* Maranga Berry
* Salac Berry
* Starf Berry
* Lansat Berry
* Micle Berry
* White Herb
* Mental Herb

Note that some of these items can only be feasibly triggered with an Item Urge in very specific scenarios.

</details>

<details>

<summary>Ability Urge</summary>

This item can target any battler on the field to force that target to retrigger its ability. However, this is only limited to certain abilities that trigger upon switch-in. The following are all of the abilities that can be potentially triggered via an Ability Urge:

* Download
* Intimidate
* Intrepid Sword
* Dauntless Shield
* Pastel Veil
* Screen Cleaner
* Curious Medicine
* Drizzle
* Drought
* Snow Warning
* Sand Stream
* Desolate Land
* Primordial Sea
* Delta Stream
* Grassy Surge
* Electric Surge
* Psychic Surge
* Misty Surge
* Forewarn (player-side only)
* Anticipation (player-side only)
* Frisk (player-side only)
* Costar (Gen 9 Pack)
* Wind Rider (Gen 9 Pack)
* Orichalcum Pulse (Gen 9 Pack)
* Hadron Engine (Gen 9 Pack)
* Supersweet Syrup (Gen 9 Pack)
* Hospitality (Gen 9 Pack)
* Embody Aspect (Gen 9 Pack)
* Teraform Zero (Gen 9 Pack)

Note that some of these abilities can only be feasibly triggered with an Ability Urge in very specific scenarios. If the Gen 9 Pack is installed, some abilities may have a new once-per-battle or once-per-switch-in limitation that would prevent them from being triggered with an Ability Urge a second time.

</details>

Page 106:

# Launcher: PBS Data

Upon installing the plugin for the first time, you *must* recompile your game. This is not an optional step. This will update all of your relevant PBS files with the necessary data. If you're unaware of how to recompile your game, simply hold down the `CTRL` key while the game is loading in debug mode and the game window is in focus.

<details>

<summary>Installation Details</summary>

If done correctly, your game should recompile. However, you will also notice lines of yellow text above the recompiled files, like this:

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FvRtVCdSEO5GdvB1Bczff%2FCapture.JPG?alt=media&#x26;token=cbdae94b-cbf5-44b6-93e4-acb842d3e75c" alt="" data-size="original">

This indicates that the appropriate data have been added to the following PBS files:

* `items.txt`
* `items_dynamax.txt` (if Dynamax add-on is installed)
* `items_terastal.txt` (if Terastallization add-on is installed)
* `items_zpower.txt` (if Z-Power add-on is installed)

This will only occur the first time you install the plugin. If you for whatever reason ever need to re-apply the data this plugin adds to these PBS files, you can force this to happen again by holding the `SHIFT` key while loading your game in debug mode. This will recompile all your plugins, and the data will be re-added by this plugin as if it was your first time installing.

</details>

{% hint style="info" %}
Note: Because this plugin adds new PBS data to your files, it is highly recommended that you make back ups of the PBS files listed above prior to installing this plugin. Also, keep in mind that if you ever choose to uninstall this plugin, you'll need to replace these PBS files with your backups, since the data added by this plugin will no longer be readable by Essentials without this plugin installed.
{% endhint %}

***

<mark style="background-color:orange;">**Item PBS Data**</mark>

This plugin adds new lines of data that you may add to items in your `items.txt` PBS file.

<details>

<summary><mark style="background-color:red;"><strong>LauncherPoints</strong></mark><strong> = </strong><mark style="background-color:yellow;"><strong>Integer</strong></mark></summary>

This is what allows for an item to be considered compatible with the Wonder Launcher, and will allow it to appear in a trainer's Wonder Launcher inventories. The integer that this is set to will determine how much LP is required to launch this item in Wonder Launcher battles.

By default, all items have their `LauncherPoints` set to 0. Any item that has this set to a number higher than zero will be considered a Wonder Launcher-compatible item. Note that the Wonder Launcher inventory has only two "pockets" by default - Medicine (pocket 2) and Battle items (pocket 7). So any custom Wonder Launcher items you want to add should also be items that appear in one of those two pockets.

</details>

<details>

<summary><mark style="background-color:red;"><strong>LauncherUse</strong></mark><strong> = </strong><mark style="background-color:yellow;"><strong>OnTarget</strong></mark></summary>

This is what determines what targets are valid for this item to be used on during Wonder Launcher battles. You should almost never need to actually set this line on any item, since this properly naturally just inherits the same value as the `BattleUse` property.

The only time you should ever need to set this is if you're making a custom battle item that can be used to target any battler on the field, including opponents. If so, you should set `OnTarget` as the value for this property. If so, this item will be able to target any battler when used in battle. The only items that utilize this are the various "Urge" items, such as the Reset Urge, Ability Urge, Item Urge and Item Drop items.

If for some reason you want to create a custom battle item that has different targetting functionality during Wonder Launcher battles than it does during regular battles, you can also  set this to any of the values that the `BattleUse` property accepts.

In summary, here are all of the values that the `LauncherUse` property can accept:

* `OnPokemon`\
  Used by Potions, status cures, Revives, most medicine.<br>
* `OnMove`\
  Used only by Ethers and Max Ethers.<br>
* `OnBattler`\
  Used by X Items, Persim Berry, Red Flute, etc.<br>
* `OnFoe`\
  Used only by Poke Balls.<br>
* `Direct`\
  Used by Guard Spec., Poke Flute, Poke Doll, etc.<br>
* `OnTarget`\
  Used by Reset Urge, Ability Urge, Item Urge and Item Drop.

</details>

Page 107:

# Launcher: Battle Rules

This plugin adds additional battle rules related to the Wonder Launcher mechanic.

<details>

<summary><mark style="background-color:green;">"wonderLauncher"</mark></summary>

This rule enables the Wonder Launcher features in this trainer battle, if the Wonder Launcher switch isn't currently enabled. This can be used to set specific trainer battles to use the Wonder Launcher mechanic while keeping the mechanic disabled otherwise.\
\
This is entered as `setBattleRule("wonderLauncher")`

</details>

<details>

<summary><mark style="background-color:green;">"noWonderLauncher"</mark></summary>

This rule disables the Wonder Launcher mechanic in this trainer battle, and have it play out as a normal battle. This can be used toggle the feature off for certain trainer battles, even if the Wonder Launcher mechanic is enabled by default.\
\
This is entered as `setBattleRule("noWonderLauncher")`

</details>

Page 108:

# Launcher: Mid-Battle Scripting

This plugin adds various new keys to be used by the Deluxe Battle Kit's mid-battle scripting functionality.

***

<mark style="background-color:orange;">**Trigger Keys**</mark>

These are keys which trigger at various points when a trainer's total LP changes.

* <mark style="background-color:purple;">**"TrainerGainedLP"**</mark>\
  Triggers when a trainer's LP total increases.<br>
* <mark style="background-color:purple;">**"TrainerLostLP"**</mark>\
  Triggers when a trainer's LP total decreases

***

<mark style="background-color:orange;">**Command Keys**</mark>

These are keys which trigger certain actions during Wonder Launcher battles.

<details>

<summary><mark style="background-color:blue;">"setLP"</mark> => <mark style="background-color:yellow;">Integer or Array</mark></summary>

This may be used to manipulate the total LP a trainer has. When set as an integer, that number will be added to the total LP total of whichever trainer owns the Pokemon who triggered this midbattle key.

If set as an array, you can input two numbers - the first of which is the number of LP points to add, and the second number being the index number of a particular battler. Whichever trainers owns the Pokemon at that index will have their LP increased by the value of that first number.

</details>

<details>

<summary><mark style="background-color:blue;">"disableLP"</mark> => <mark style="background-color:yellow;">Boolean</mark></summary>

Toggles the ability of a trainer to gain, spend, or accrue any LP during this battle. If set to `true`, a trainer's LP will be locked and disabled. When set to `false`, this flag is removed, allowing the trainer to gain and use LP again, if they are able to.

</details>

***

<mark style="background-color:orange;">**Hardcoding**</mark>

Here's a list of methods and/or properties that you might want to reference when hardcoding a midbattle script, since this plugin adds a lot of new custom content which you may need to call on to make certain things happen:

<details>

<summary>Battle Class</summary>

* `launcherBattle?`\
  Returns true if the current battle is a Wonder Launcher battle and returns false otherwise.<br>
* `pbCanUseLauncher?(idxBattler)`\
  Returns true if the trainer who owns the battler at the entered index is capable of using the Wonder Launcher.<br>
* `pbToggleLauncher(idxBattler, toggle = nil)`\
  Toggles the ability to use the Wonder Launcher for the trainer who owns the battler at the entered index. Set `toggle` to true or false to set whether the trainer's ability to launch items on or off, respectively. If you leave `toggle` as nil, then the trainer's launcher availability will just be inverted from its current availability.<br>
* `pbIncreaseLauncherPoints(idxBattler, points, showBar = false)`\
  Increases the LP of the trainer who owns the battler at the entered index. Set `points` to the value you want to raise the trainer's LP by. If `showBar` is set to true, then the trainer's LP splash bar will animate upon increasing LP. If left false, LP will be increased silently.<br>
* `pbReduceLauncherPoints(idxBattler, item, showBar = false)`\
  Reduces the LP of the trainer who owns the battler at the entered index. Set `item` to an eligible launcher item to reduce the trainer's LP by that item's LP cost. If `showBar` is set to true, then the trainer's LP splash bar will animate upon reducing LP. If left false, LP will be increased silently.<br>
* `pbSetLauncherItems(idxSide, idxTrainer)`\
  Replaces a trainer's inventory with the Wonder Launcher inventory. Set `idxSide` to the index of the side of the field that the target trainer is on (0 for player side, 1 for foes), and `idxTrainer` to the index of that specific trainer on that side.

</details>

Page 109:

# Animated Pokemon System

[**Eevee Expo Link**](https://eeveeexpo.com/resources/1544/)

[**PokeCommunity Link**](https://www.pokecommunity.com/threads/animated-pokemon-system-dbk-add-on-v21-1.530417/#post-10857535)

[**Download Link**](https://www.mediafire.com/file/vmo4mlhwloria5r/Animated_Pokemon_System.zip/file) **\[PLUGIN]**\
[**Download Link**](https://www.mediafire.com/file/0rlnz04eezvv3cj/Animated_Pokemon_Sprites.zip/file) **\[SPRITES]**

{% hint style="warning" %}
**Installation**

The download link for this plugin is split into two parts - one for the actual plugin scripts, and a separate link just for the Pokemon sprites themselves. I've chosen to split these into separate downloads so that it won't be necessary to redownload all 9,000+ sprites each time a new update for the plugin scripts is released.
{% endhint %}

This plugin builds upon the Deluxe Battle Kit to implement fully animated Pokemon sprites for all species up to Gen 9 DLC. This isn't merely a sprite pack however, as it implements a variety of features and animations that utilize several functions of the Deluxe Battle Kit and other supported plugins. This plugin builds off of the code that was formerly part of the Generation 8 Pack by Golisopod User, which itself was built off of EBDX by Luka S.J.

In addition to providing the actual sprites for every species, (including shiny sprites, icons, shiny icons, and footprints), this plugin also implements several key features that I'll briefly outline below. More details for each feature may be found in later subsections of this guide.

* Sprite scaling settings.
* Animation speed settings.
* Animated shadow sprites.
* Super shiny hues.
* Mosaic-style form change animations.
* Substitute doll animations.
* Status conditions place a colored overlay on Pokemon sprites.
* Animations for sprites can be changed or affected by certain conditions.
* Moves that put the user in a semi-invulnerable state (Fly, Dig, etc.) properly hides the user's sprite.
* Improved metrics options.
* An overhauled and improved Sprite Editor.
* Midbattle Scripting features.

***

<mark style="background-color:orange;">**Enabling Animated Sprites**</mark>

By default, Pokemon sprites will be animated upon installing this plugin, as long as you have the appropriate sprite strips for that species. If you only have static sprites, the plugin will still work fine. However, you may need to adjust the scaling and other metrics for those sprites.

If you or the player want to disable animated sprites for any reason, you may do so in the in-game Options menu.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FheOeqyuhwvH50HHklFVH%2F%5B2024-08-02%5D%2009_05_08.523.png?alt=media&#x26;token=43ab60a0-7246-4cec-b11b-8dc372feba8d" alt="" width="384"><figcaption><p>Animated Sprites setting in the Options menu.</p></figcaption></figure>

When set to "Off", all Pokemon sprites will no longer animate and return to being static sprites. However, all the other features of this plugin will still remain in tact even if the sprites no longer animate.

{% hint style="info" %}
**Sprite Bobbing in Battle**

In vanilla Essentials, the player's Pokemon sprites will "bob" up and down during command selection in battle. This is used to help the player determine which Pokemon they're selecting actions for.

However, this feature doesn't translate well when Pokemon sprites are animating, as it's hard to tell if the bobbing is just part of the sprite's animation or not. Because of this, the sprite bobbing is automatically turned off. However, if sprite animations are turned off via the Options menu as described above, the sprite bobbing will be re-enabled automatically.&#x20;
{% endhint %}

Page 110:

# Animated: Pokemon Sprites

The species sprites used by this plugin are long strips which contain each frame of the entire animation. The dimensions for these strips must always be broken up into squares. So for example, if you have a sprite 96 pixels tall that has 10 frames of animation, then the final dimensions for this sprite strip must be 960x96 so that each "frame" of this strip is a perfect square (96x96).

As long as your strips produce perfect squares for each frame, there is no set sizes that are required for your sprites. They can be as large or as small as you'd like, as long as they follow the square rule.

***

<mark style="background-color:orange;">**Sprite Scaling**</mark>

As mentioned above, there are no limitations on how small or how large your sprites may be. The reason for this is because this plugin includes sprite scaling features that allow you to scale up or scale down any Pokemon sprite to your liking. This means that no matter what size your sprites are, they can be modified to fit within your game without having to manually edit the individual sprite itself.

There are two ways to affect sprite scaling. I'll cover both methods below.

<details>

<summary>Sprite Scaling through Settings</summary>

In the plugin Settings file, you will see the following two settings:\
`FRONT_BATTLER_SPRITE_SCALE` and `BACK_BATTLER_SPRITE_SCALE`.

As you can imagine, these control the overall sprite scaling for all Front and Back sprites, and act as the default scaling values for all Pokemon sprites. Back sprites will typically have a higher scaling than Front sprites in order to produce the effect of battlers on your side of the field appearing "closer" than those that are further away.

By changing the scaling for these options, you can change the overall sprite scaling for all Pokemon sprites in the game. Note that this does affect *all* Pokemon sprites at once, so these settings should only be used if you want to affect the overall scaling of sprites globally, as opposed to individual sprites. If you only want to affect the sprite scaling of a particular sprite, refer to the PBS method of scaling sprites.

</details>

<details>

<summary>Sprite Scaling through PBS</summary>

Sometimes you may only want to change the scaling applied to a specific sprite. This can easily be accomplished by editing the metrics for that species' sprites in the various `pokemon_metrics.txt` PBS files.

In these files, each species will have `BackSprite` and `FrontSprite` parameters, followed by at least two numbers. The first number correlates to the X-axis coordinates for the species' sprite in battle, while the second correlates to the Y-axis coordinates.

However, this plugin allows a third number to be entered for both parameters which controls the scaling of that specific sprite. For example, these are the parameters set for Bulbasaur by default:

```ruby
[BULBASAUR]
BackSprite = 4,0
FrontSprite = 0,2
```

However, you may add a third additional number for both parameters to control the scaling for each sprite, like so:

```ruby
[BULBASAUR]
BackSprite = 4,0,4
FrontSprite = 0,2,5
```

This would make it so Bulbasaur's Back sprite would be scaled up by 4x, while its Front sprite would be scaled up by 5x. This would override whatever sprite scaling settings were entered in `FRONT_BATTLER_SPRITE_SCALE` or `BACK_BATTLER_SPRITE_SCALE` in the plugin Settings.

Note that if you set the sprite scaling for a sprite that is already equal to the default value set in the plugin Settings, it will be treated as if you entered nothing, and the third number you entered here will not be saved whenever your PBS files are forced to update.

Also note that these sprite scaling metrics may also be applied via the debug mode Sprite Editor, the same way all metrics data can be edited. But I'll go over more on that in its own subsection.

</details>

***

<mark style="background-color:orange;">**Animation Speed**</mark>

There are no minimum requirements for how long your sprite strips may be for each species. This means that some Pokemon may have really long animations, while others may have really short ones with only a few frames. This can cause some inconsistency issues however as one species may appear to animate abnormally "faster" than another simply due to a dramatic difference in length of their sprite strips.

To address this issue, this plugin implements methods of editing the animation speed for your sprite strips so that you can try to make everything look as visually consistent with each other as possible. To accomplish this, each Front and Back sprite is given an animation speed value that can be set to any one of these numbers:

* 0: No animation (static sprite)
* 1: Fast animation
* 2: Normal animation
* 3: Slow animation
* 4: Very slow animation

By default, all sprites have an animation speed value of 2, which is the normal speed. However, there are two ways in which you may change the speed at which sprite strips animate, which I'll outline below.

<details>

<summary>Animation Speed through Settings</summary>

In the plugin Settings file, you will see the following setting:\
`ANIMATION_FRAME_DELAY` which is set to 90 by default.

This controls the overall speed at which all sprites animate by delaying each new "frame" of a sprite strip from appearing for a fraction of a second. This is calculated by taking the Animation Speed value of that sprite (speed), dividing it by 2, and then multiplying that by the number set in `ANIMATION_FRAME_DELAY` (delay). This final number is then divided by 1,000 to determine how many thousandths of a second of delay should be applied before each animation frame.

This leaves us with a simple equation of `((speed / 2) * delay) / 1,000`. Let's run this calculation with a typical sprite that has a "Normal" animation speed value (2), and with the default frame delay (90).

```
((2 / 2) * 90) / 1,000 = 0.09
```

Two divided by itself is 1, and 90 multiplied by 1 is 90. Divide 90 by 1,000 and you get 0.09. This means that for any sprite with normal animation speeds, there will be a 0.09 second delay between each "frame" of the animation.

Now let's try running the same equation with a sprite with a "Fast" animation speed value (1).

```
((1 / 2) * 90) / 1,000 = 0.045
```

One divided by two is 0.5, and 90 multiplied by 0.5 is 45. Divide 45 by 1,000 and you get 0.045, which is half the number we calculated prior. Now it becomes clear why sprites with a fast animation speed will appear to animate "faster", since there is half as many fractions of a second delay between each frame of the sprite strip vs the "normal" speed that must wait 0.09 seconds. In essence, sprites with the "fast" speed value will animate twice as fast. The same logic applies in reverse for sprites that are set to slower speeds.

Now that we understand how sprite animation speeds are calculated, it becomes clear how the `ANIMATION_FRAME_DELAY` setting can be used to edit the overall speed of all of your Pokemon sprites. If you want your sprites to animate faster overall, then all you would need to do is reduce the number of this setting to your liking. If you want to slow down how your sprites animate, you would just need to increase this number. Although, I would personally try to use increments of 30, just to keep things consistent. But you can realistically set this to whatever amount of delay that you want.

Keep in mind however that editing this option will affect the animation speeds for *all* Pokemon sprites at once. So this setting should only be used if you want to affect the overall speed of sprites globally, as opposed to individual sprites. If you only want to affect the animation speed of a particular sprite, refer to the PBS method below.

</details>

<details>

<summary>Animation Speed through PBS</summary>

Sometimes you may only want to change the animation speed of a specific sprite. This can easily be accomplished by editing the metrics for that species' sprites in the various `pokemon_metrics.txt` PBS files.

These files now accept a brand new optional metric parameter called `AnimationSpeed`. This may be set to a single number, or an array of two numbers. If set to a single number, this allows you to adjust the animation speed value for all sprites used by that species.

For example, these are some of the parameters set for Greninja by default:

```
[GRENINJA]
BackSprite = -3,20
FrontSprite = 2,11
AnimationSpeed = 1
```

As seen here, Greninja's `AnimationSpeed` is set to 1, which is correlates to the "fast" animation speed. This means that both Greninja's front and back sprites will animate at this speed. However, what if Greninja's front and back sprite strips were of different lengths, and thus animated at different rates? Setting a universal animation speed for both sprites wouldn't be practical, as one would animate at a different speed than the other.

To resolve this issue, you can set `AnimationSpeed` to an array of two numbers, like so:

```
[FENNEKIN]
BackSprite = 0,3
FrontSprite = -2,3
AnimationSpeed = 1,2
```

In this example, `AnimationSpeed` is set to two numbers. In this scenario, the first number would correspond to the animation speed of the Back sprite, while the second number would correspond to the animation speed of the Front sprite. This means Fennekin's back sprite would animate at the "fast" speed (1), while its Front sprite will animate using the normal speed value (2). By setting the animation speed in this way, you can separately edit the speeds at which the sprites of a single species animate.

Note that the `AnimationSpeed` parameter is completely optional, and does not need to be set on every species, unlike some other parameters. Any species that doesn't have `AnimationSpeed` set in their PBS data will just default to the "normal" animation speed value of 2. If you set the animation speed for both the front and back sprites of a species equal to this default value, it will be treated as if you entered nothing, and it will not be saved whenever your PBS files are forced to update.

Also note that this animation speed metric may also be applied via the debug mode Sprite Editor, the same way all metrics data can be edited. But I'll go over more on that in its own subsection.

</details>

***

<mark style="background-color:orange;">**Shadow Sprites**</mark>

While a Pokemon sprite is animating in battle, the shadow sprite that appears underneath them will also animate to reflect the Pokemon's movement. This is entirely different than the standard graphics that are utilized as shadows, which are just generic circles that appear beneath the Pokemon.

Instead, this is implemented by creating a copy of the Pokemon's sprite and modifying it to appear greyed out, stretched, and transparent. However, it will still animate exactly as the normal sprite does, following the Pokemon's actions exactly.

Sprites on both sides of the field have shadow sprites. However, since the shadows for the Pokemon on the player's side of the field would be completely hidden by the default battle UI anyway, shadows on the player's side are turned off by default. If you have a custom battle UI where you may have space available to display these sprites, then you may turn them back on by opening the plugin Settings and setting `SHOW_PLAYER_SIDE_SHADOW_SPRITES` to `true`.

You may also set a variety of metrics related to a Pokemon's shadow sprite. I'll cover this in more detail below.

<details>

<summary>Shadow Sprite Metrics</summary>

The shadow sprite for each species can be tweaked to set the coordinates in which they appear, as well as their overall size and visibility. This can easily be accomplished by editing the metrics for that species' sprites in the various `pokemon_metrics.txt` PBS files.

There are two parameters which can control elements of a Pokemon's shadow sprite. These are the `ShadowSprite` parameter and the optional `ShadowSize`. The `ShadowX` parameter which is present in Essentials by default is no longer used, and no longer serves a function. It can still be set in the PBS files without causing errors, but it will not do anything and will not be saved whenever your PBS files are forced to update.

***

<mark style="background-color:orange;">**ShadowSprite**</mark>

This is a new parameter introduced by this plugin that contains all of the necessary metrics related to a Pokemon's shadow. This parameter must be set to an array of three numbers.&#x20;

The first number in this array corresponds to the X-axis coordinates of the shadow sprite. Note that this one number controls where both the front and back sprite shadows appear on the X-axis. This is done by simply mirroring the position of the front sprite's coordinates, since the shadows appear opposite each other. For example, if the front sprite's X value is set to 2, then the back sprite's X value is equivalent to -2. Because of this, only one entry is required for this coordinate, and you don't need separate values for front/back sprites.

The second number in this array corresponds to the Y-axis coordinates of the shadow of the back sprite. Note that since shadows for back sprites are unlikely to ever be viewable by the player due to UI covering it up, it's rarely that important what this value is set to.

Lastly, the third number entered in this array corresponds to the Y-axis coordinates of the shadow of the front sprite. This is probably the most relevant value to set in terms of getting a Pokemon's shadow to appear in the proper place.

***

<mark style="background-color:orange;">**ShadowSize**</mark>

While this parameter exists in base Essentials by default, it has been reworked to be used by this plugin in slightly different ways. First of all, this parameter is no longer required to be set, and is completely optional. If not set, it will just always be assumed that this is given the default value of 1.

Next, this parameter has been updated to accept more values. Previously, this could only be set to 0-3, corresponding to the size of the shadow graphic to use. Now, this can range between -9 to 9. In addition, this will no longer determine which graphic to use for the Pokemon's shadow. Instead, this will control the sprite scaling used for the Pokemon's shadow. The higher this number is, the larger the Pokemon's shadow will appear. The lower this number, the smaller the shadow will appear.

Note however that if this parameter is set to 0, this will count as having the Pokemon's shadow being "hidden", and no shadow will appear underneath the Pokemon in battle. You can use this setting if a species would make more sense not to display a shadow for some reason.&#x20;

</details>

Page 111:

# Animated: Dynamic Sprite Effects

There are a variety of conditions that may alter how a sprite appears or animates both in and out of battle. In this subsection, I'll go over various conditions that may affect your sprites.

***

<mark style="background-color:orange;">**Battle Animations**</mark>

<details>

<summary>Mosaic Form Changes &#x26; Transformations</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F8BXrERwVJWrUdaKoUbXp%2Fmosaic.gif?alt=media&#x26;token=fa46c1e5-8108-479d-9a67-2da317faef7e" alt="" data-size="original">

In base Essentials, Pokemon that change forms in battle will do so abruptly by instantly changing sprites without any sort of visual effect. This plugin implements a new sprite feature that adds a bit more visual flair to these instances by utilizing a mosaic effect.&#x20;

This is the same effect used in the PC Storage UI when viewing Pokemon. When navigating through a PC box, the displayed sprite of the selected Pokemon will briefly pixelate before loading in the sprite of the new Pokemon your cursor is over. This plugin borrows this code and reapplies it to battler sprites so that the same effect occurs when a Pokemon changes form.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FH9crHGXkTt6HYLFlEFz0%2Fmosaic2.gif?alt=media&#x26;token=b43493b0-806f-4e33-bbad-13c68049c7d8" alt="" data-size="original">

In addition, this effect will also apply to Pokemon who change into a different species through the use of Transform or Imposter, or Pokemon under the effects of Illusion who are revealed when the effect ends.

</details>

<details>

<summary>Animations for the Semi-Invulnerable State</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FgbTeqMmGGYR1q5fYxBCR%2Fvanish.gif?alt=media&#x26;token=207a7e91-affc-4796-a49c-e9541f381c8d" alt="" data-size="original">

When using a move that puts the user in a semi-invulnerable state for one turn, such as Fly, Dig, Dive, and others; the user's sprite will now vanish off screen for the duration of this semi-invulnerable state.

Note that while the user is in this state and its sprite is hidden from view, animations that would normally apply to the user's sprite will be skipped and not display. This includes things like indirect damage from things like Poison or Burn, or animations for moves that can bypass this state.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F4fGMPviFMZFe7lnhDqqH%2Fvanish2.gif?alt=media&#x26;token=7fc5a400-4ae7-4129-be52-187e764c021b" alt="" data-size="original">

For the moves that send the user high in the air during their semi-invulnerable turn, their shadow sprite will not disappear. Instead, it will shrink during this turn to imply that the user is casting a shadow from way up in the sky. This effect will occur specifically for the moves Fly, Bounce and Sky Drop. Note that in Sky Drop's case in particular, this effect applies to both the Sky Drop user and the target that the user is lifting.

</details>

<details>

<summary>Animations for the Substitute Doll</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F3ARMBULU0Nx69PjVhOmC%2Fsubstitute.gif?alt=media&#x26;token=51ae51ff-4d6f-45ad-9346-5278934b79a5" alt="" data-size="original">

By default, Essentials doesn't include any graphics or animations related to the move Substitute. This means that whenever a Pokemon is under the effects of this move, they will still appear on screen normally, and there won't be any visual indication that the Pokemon is under its effects.

This plugin addresses this issue by including its own graphics and animations related to displaying the Substitute doll. Now, when the move Substitute is used (and Shed Tail, if the Gen 9 Pack is installed), the user will summon a Substitute doll that will take their place in battle for the duration of the effect.

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FotDNOVlKQ9UvLVgQSX9g%2Fsubstitute2.gif?alt=media&#x26;token=f151f84d-1056-4d60-96a8-a0293633f46f" alt="" data-size="original">

Whenever the Pokemon uses a move, changes form, or transforms, it will briefly swap back into the battlefield and then swap back out with the Substitute doll upon completing that action. If the Substitute is broken, it will animate differently and simply fade away before the original Pokemon swaps back in.

***

<mark style="background-color:orange;">**Implementing Substitute Doll Animations**</mark>

If you have any new moves or custom effects that apply the Substitute effect on a battler, or should show/hide the Substitute doll if one is displayed, you will have to manually include the code that triggers these animations.&#x20;

To do this, you may use the following `Battle::Scene` script:

```ruby
pbAnimateSubstitute(idxBattler, mode, delay = false)
```

This will automatically animate the Substitute doll for the index of the battler that is set with `idxBattler`. The type of animation that plays depends on what you set with `mode`. There four possible settings you can enter here:

* `:create`\
  Calls the animation related to the initial creation of the Substitute doll.
* `:show`\
  Calls the animation where the Substitute doll swaps in and the battler swaps out.
* `:hide`\
  Calls the animation where the battler swaps in and the Substitute doll swaps out.
* `:broken`\
  Calls the animation where the Substitute doll breaks and fades away.

Lastly, if the `delay` argument is set to `true`, the game will delay calling the animation for 1 second before it starts. This isn't necessary however, and you can simply omit this in most cases.

***

<mark style="background-color:orange;">**Substitute Doll Metrics**</mark>

Just like with any ordinary Pokemon sprite, the Substitute doll sprite appears on screen based on the metrics set for that sprite. However, unlike actual Pokemon species, there is no entry for these metrics in the traditional metrics PBS files.

Instead, these are stored in the array `SUBSTITUTE_DOLL_METRICS` in the plugin Settings. The first number entered in this array corresponds to the Y-axis coordinates of the Substitute doll's back sprite, while the second number corresponds to the Y-axis coordinates of the front sprite.

Note that X-axis coordinates aren't included. This is because the Substitute doll will just always appear in the center of the battle base, so there's no need to customize this metric.

</details>

<details>

<summary>Species-Specific Battle Animations</summary>

Certain species have uniquely implemented animations that trigger under specific circumstances. These are implemented using a global midbattle script so that they can apply at all times in every battle.

***

<mark style="background-color:orange;">**Sudowoodo**</mark>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FyRafLDwWMNRXkwh3VTE6%2Fsudowoodo.gif?alt=media&#x26;token=4e13e75d-565e-4170-8b7b-b98cc6b4996b" alt="" data-size="original">

Sudowoodo's entire gimmick is that it's pretending to imitate a tree. Because of this, it doesn't make much sense that it should be constantly moving about with an animation. So in order for it to fit more with its character, I decided to give this species an `AnimationSpeed` metric of zero, which means it will remain completely still and not animate at all in battle.

However, you can still see Sudowoodo animate under specific conditions. If a Sudowoodo is struck by a Water-type move that deals super effective damage, the targeted Sudowoodo will briefly drop the act and wiggle around for a second, as if it's reacting negatively to the water and trying to shake it off. This is meant as a fun little easter egg reminiscent of how it reacts when sprinkled with watering can when encountered in the Johto games.

***

<mark style="background-color:orange;">**Klink Family**</mark>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FKCjh2uMs7DhxgdyEDYES%2Fklang.gif?alt=media&#x26;token=a6803eb4-4085-4d40-9c6c-e5f76b074390" alt="" data-size="original">

The entire Klink family line (Klink, Klang, and Klinklang) have a small animation quirk related to the move Shift Gear. After any member of this family uses this move in battle, their animations will begin playing in reverse. This is a fun little easter egg meant to indicate that these Pokemon are literally "shifting gears" by rotating in the opposite direction after this move is used. If the move is used a second time, their animation will reverse once again, meaning that their animation will return to spinning in their original direction.

This subtle animation effect will only occur when Shift Gear is used by one of these species, and will not occur if used by any other species.

</details>

***

<mark style="background-color:orange;">**Conditional Animation Effects**</mark>

<details>

<summary>Status Effect Pattern Overlays</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FmFBvSYpMrGcxlWxmylYk%2Fstatus.gif?alt=media&#x26;token=8ec83d55-60e2-4d4b-9379-e04d1af82d90" alt="" data-size="original">

This plugin implements a new visual feature that applies an overlay pattern on the sprites of Pokemon who are under the effect of certain status conditions. This will apply a coloration effect on the sprite related to the status effect it's suffering from that will repeatedly fade in and out. This will be displayed both in and out of battle.

Note that the Sleep status is the exception here, and will not apply and colorization effect to sprites. The same is true for the Drowsy status, if you have that installed. If you have the Frostbite status installed, this status will use the same colored overlay as the Frozen status.

</details>

<details>

<summary>Altered Animation Speeds</summary>

While the animation speed of a Pokemon's sprite is based on its `AnimationSpeed` metrics by default, it is possible for this speed to be altered both in and out of battle by various conditions.

***

<mark style="background-color:orange;">**Low HP**</mark>

If the Pokemon's total remaining HP is less than or equal to 25% of its max HP, the rate at which its sprite animate will be slowed down by 2x.

This effect will not stack with other effects that may alter animation speeds.

***

<mark style="background-color:orange;">**Status Conditions**</mark>

Certain status conditions may alter the rate at which a Pokemon's sprites animate.

* Paralysis: Slows animation speed down by 2x. (Same for Drowsy status if installed)
* Sleep: Slows animation speed down by 3x.
* Frozen: Completely stops the Pokemon from animating at all.

This effect will not stack with other effects that may alter animation speeds.

***

<mark style="background-color:orange;">**Speed Stages**</mark>

In battle, the number of stages a Pokemon's Speed has been altered by may affect the animation speed of its sprites. For every stage of speed increased, its sprites will animate roughly 5% faster, up to a rough total of a 30% increase at +6 stages. This works the same in reverse for lowered Speed stages, which will slow down the animation speed of its sprites by roughly 5% per lowered stage.

This effect will not stack with other effects that may alter animation speeds.

***

<mark style="background-color:orange;">**Mid-Battle Scripting**</mark>

You may forcibly set the animation speed of a Pokemon's sprite utilizing the <mark style="background-color:blue;">"spriteSpeed"</mark> midbattle command. More information on this is covered in the "Mid-Battle Scripting" subsection for this plugin.

This effect will not stack with other effects that may alter animation speeds.

</details>

<details>

<summary>Backwards Animations</summary>

If a Pokemon becomes confused or infatuated during battle, its sprites will begin animating in reverse for the duration of these effects to indicate the Pokemon's disorientation. This is a very subtle effect and is something you probably wouldn't even notice unless you're specifically looking for it. However, it's more noticeable on some species than others.

For example it's easier to tell that a Pokemon like Klink is animating in reverse, since its gears will begin spinning in the opposite direction.

</details>

<details>

<summary>Super Shiny Hues</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fx464c9tIjcy2nZsHrMZj%2F%5B2024-07-26%5D%2011_04_51.672.png?alt=media&#x26;token=7eb79fb0-1c23-4716-a30c-91adf7fa144a" alt="" data-size="original"> ![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F6cKZn7qc2hI814yHYxnn%2F%5B2024-07-26%5D%2011_05_08.664.png?alt=media\&token=3294cb33-91ad-4859-b81e-4c05d3d33656)

By default, Essentials includes the ability to find Super Shiny Pokemon. Super Shinies are just rarer variants of shiny Pokemon that utilize different sparkle animations starting in *Pokemon Sword & Shield*. However, there is no inherent visual difference between shiny and Super Shiny Pokemon in Essentials, so it's impossible for the player to ever tell the difference between them.

This plugin implements a new feature however that allows shiny and Super Shiny Pokemon to have visual differences by applying different hues to the sprites of Super Shiny Pokemon. This effectively gives every species an additional possible color variant that may be obtained.

By default, this Super Shiny hue is completely randomized for every species and form, and will re-randomize every time you recompile the game. However, if you wish to set specific hues for certain species or forms, you may do so by adding a new parameter to that Pokemon's metrics in the various `pokemon_metrics.txt` PBS files.

These files now accept a brand new optional metric parameter called `SuperShinyHue`. This can be set to a number ranging from -255 to 255, and that number will correspond to the hue that is used to recolor the Super Shiny sprites of that species. This will override whatever randomized hue would be normally generated, allowing you to customize and set exactly how you'd like specific Super Shiny Pokemon to look like.

Also note that this Super Shiny hue may also be applied via the debug mode Sprite Editor, the same way all metrics data can be edited. But I'll go over more on that in its own subsection.

</details>

<details>

<summary>Spinda Spot Patterns</summary>

Spinda is a unique case, since its sprite is able to have randomly generated spots. This causes a lot of problems with animating Spinda, since its spots will always be in a different place, and thus impossible to know how to animate.

Because of this, this plugin dedicates a ton of complex coding and work-arounds just to get Spinda to work. However, a few liberties have been taken that stray from the main series a bit to accomplish this.

The only way to have Spinda's spots to animate properly is to "track" Spinda's movement during its animation and draw the spots on every frame of the sprite that match up with how much Spinda has moved from one frame to the next. This is extremely tricky to do, since it's so sprite-specific. How I've managed to implement this is to simply track Spinda's mouth during its animation. Its mouth is a unique color on Spinda's sprite that is the same color in its shiny version too. This makes it easy to track by simply checking the color of each pixel within a certain bounds of the sprite. If the color of that pixel does not match Spinda's mouth color, then we know the sprite must have moved. If so, the code calculates how many pixels Spinda's mouth has moved since the last frame of its animation, and then shifts where the spots should be drawn based on the difference in movement.

This works all well and good...for Spinda's face. Spinda's ears however, animate completely independently from its face, so the same logic can't be used to place spots on its ears like they can be on its face. There's simply no way to do this, so I've decided to just change how Spinda's spot patterns generate so that they just no longer appear on its ears. Because of this, Spinda will have completely different looking spot patterns on its animated sprite than it would otherwise normally have prior to installing this plugin. So any Spinda purists out there should keep that in mind.

In addition, I've also decided to just turn off displaying spots on Spinda's back sprite altogether. The new sprite patterns just simply do not display well on the back sprite and are much harder to match up with the animation. So all Spinda will unfortunately look identical when viewed from behind.

</details>

Page 112:

# Animated: UI Sprites

Displaying animated sprites in various Pokemon UI's such as the Summary, Pokedex, or PC Storage can be quite a challenge, since it's difficult to tell how a sprite may clip with various UI elements as it moves around. Because of this, much attention has been put to optimizing how sprites will appear in these displays.

Below, I'll go over all of the mechanics and features related to displaying animated sprites in the default game UI's.

***

<details>

<summary>Sprite Auto-Positioner</summary>

The sprites contained in the sprite pack contain various fan-made sprites made by many different artists. Because of this, many of the image sizes and positioning used are very inconsistent, since there wasn't any uniform process in creating them. This causes a lot of headaches when it comes to implementing a universal way of displaying these sprites in UI's, as the coordinates used to display one sprite won't necessarily correlate to displaying another one optimally. This leads to many sprites being completely cut off or overlapping the UI in awkward ways.

To address this, I've implemented a feature in this plugin that will automatically calculate the ideal positioning for each sprite. This is done by calculating how much empty space there is above, below, and to both sides of a sprite; and then calculating where the approximate "center" of the actual sprite should be based on those values. Once the center is determined, it figures out where to plot the sprite on the UI from there.

This all happens automatically, so there's nothing you need to do on your end. However, you can still fine-tune how specific species may appear, which I'll go over below.

</details>

<details>

<summary>Fine-Tuning UI Positions</summary>

While the plugin's auto-positioner functions work well for 95% of sprites, there are a few exceptions where it's still not enough to ideally display a sprite in the UI.&#x20;

For example, Lugia has a very tall sprite due to how its wings flag, despite its actual body being quite low in its sprite's animation. So when the auto-positioner code determines where the "center" of that sprite should be, it ends up selecting some point that's much higher than Lugia's actual body, so what ends up displaying in UI's is mostly Lugia's wings, with its body being shifted much lower on screen. This isn't ideal, as the majority of the sprite ends up being obscured or clipping with the UI.

To address this, I've added a method of manually fine-tuning the UI positions. In the plugin's Settings file, you will find a hash named `POKEMON_UI_METRICS`. In this hash, each key will correspond to the species ID of a particular Pokemon, and the value of those keys will be set to an array containing two numbers.

```
:LUGIA => [0, -26],
```

Here's the entry found in this hash for Lugia, as mentioned above. This is what's used to manually fine-tune how Lugia's sprite will be displayed in UI's in-game. The first number in the array here corresponds to how many pixels its sprite should be shifted along the X-axis, while the second number corresponds to how it should shift along the Y-axis. In this example, you can see that Lugia's sprite isn't shifted on the X-axis at all, but it is moved upwards quite a bit so that you can actually see its full body when viewed in various in-game UI's.

You can use this hash to manually edit how any species or form will appear when displayed in UI's. So feel free to add, remove, or edit any species you wish.

</details>

<details>

<summary>UI Constrictions</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F3u5725uzdDDtWkWXLQQZ%2Fstakataka.gif?alt=media&#x26;token=c73dabb1-2ac1-4b55-9335-2485bd83d061" alt="" data-size="original">

Because animated sprites move around, they're much harder to comfortably display in various UI's in a universal way, since many of them may often clip with certain UI elements in unintended ways that can make your UI's look messy. To address this, this plugin implements a method in which to constrict sprites so that they will be cut off if they exceed a certain bounds within the UI.

This effects all of the default Essentials UI's that display Pokemon sprites. This includes the Summary, PC Storage, and the Pokedex. If you overhauled these UI's in your game so that they use different layouts, you may have to edit the plugin scripts to set different boundaries for sprite constriction.

If there are other custom UI's you've added to your game that display Pokemon sprites where you'd want to implement sprite constricting, you may do so by setting the following attribute on that sprite:

```ruby
sprite.display_values = [x, y, constrictX, constrictY]
```

This will determine how a sprite should be displayed and constricted in your UI. The X and Y values should simply be set to the X and Y coordinates that the sprite should normally be displayed at. The `constrictX` value should be set to how wide the boundaries of the constriction should be around the sprite, where `constrictY` should be set to how tall the boundary should be. Note that you may omit `constrictY` if you'd like, in which case the boundary for both width and height will just be set to the same value, making a perfect square.

Note that if you do not want this sprite constriction enabled in the UI's for your game, you can disable the entire feature by setting `CONSTRICT_POKEMON_SPRITES` to `false` in the plugin Settings.

</details>

<details>

<summary>Flipping Sprites in the Summary</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FSWFNXMx10KpE2cxV5bB2%2Fflip.gif?alt=media&#x26;token=d5dfae72-7b50-4436-bb66-e1835707b25f" alt="" data-size="original">

In vanilla Essentials, pressing the `ACTION` (Z) key while viewing a Pokemon's Summary page will play the cry of that Pokemon. However, if the [**Modular UI Scenes**](https://eeveeexpo.com/resources/1325/) plugin is installed, pressing this key will also "flip" the Pokemon's sprite, allowing you to view its back sprite in the Summary.

When combined with this plugin however, you will be able to view the full animated back sprite of the Pokemon without any scaling magnifying the sprite, or any battle UI elements obstructing your view. This is the only way to get a full unmodified view of a Pokemon's animated back sprite during normal gameplay, so I thought I'd mention it here even though it's not technically a feature of this plugin specifically.

</details>

Page 113:

# Animated: Sprite Editor

This plugin completely overhauls various metrics parameters, as well as adding entirely new parameters while also removing the need for old ones. This means that the metrics files used for these sprites are totally unique to this plugin, and won't be compatible with vanilla Essentials.

This also means that these metric files are also not inherently compatible with Essentials' default Sprite Editor found in the debug menu. To address this, this plugin entirely overhauls the code for the Sprite Editor; making it compatible with the new metrics data this plugin adds while also implementing a ton of new quality of life features to make editing sprites far more convenient than before.

In this subsection, I'll go over all of the metric files included by this plugin and how they differ from the base files, and all of the new features and components of the improved Sprite Editor.

***

<mark style="background-color:orange;">**PBS Data**</mark>

Upon installing the plugin for the first time, you *must* recompile your game. This is not an optional step. This will update all of your relevant PBS files with the necessary data. If you're unaware of how to recompile your game, simply hold down the `CTRL` key while the game is loading in debug mode and the game window is in focus.

Below, I'll cover all of the metric files included in this plugin, as well as how they differ from Essentials' vanilla metrics files.

<details>

<summary>Plugin Metrics Files</summary>

This plugin adds and/or replaces the following metric files in your game:

* `pokemon_metrics.txt`
* `pokemon_metrics_forms.txt`
* `pokemon_metrics_female.txt`
* `pokemon_metrics_gmax.txt`
* `pokemon_metrics_Gen_9_Pack.txt`

Unlike the metrics found in vanilla Essentials, these are split up for better organization. The first file is your typical metrics file, and will contain metrics for every species up to Generation 8. The second file however, is specifically used for Pokemon forms. This keeps the main metrics file more orderly and less cluttered.

The third file is used specifically for female sprites used by species that have gender differences between male and females, but don't count as separate forms. For example, male and female Sneasel have different sprites, but aren't different forms. Thus, the metrics for female Sneasel will appear in this file, as it's not a base species found in `pokemon_metrics.txt`, but also not a form that would be found in `pokemon_metrics_forms.txt`.

The last two files here are to maintain compatibility with other plugins that add specific species and forms. Specifically, the `pokemon_metrics_gmax.txt` file is implemented to retain compatibility with the [**Dynamax**](https://eeveeexpo.com/resources/1495/) plugin, while the `pokemon_metrics_Gen_9_Pack.txt` file is to retain compatibility with the [**Generation 9 Pack**](https://eeveeexpo.com/resources/1101/) plugin.

If you don't have the Generation 9 Pack installed in your game, then you should delete the `pokemon_metrics_Gen_9_Pack.txt` file when installing.

</details>

<details>

<summary>Female-Exclusive Metrics</summary>

<mark style="background-color:orange;">**Overview**</mark>

In vanilla Essentials, only species or forms of species can have metrics set for their sprites. However, there is a more obscure class of Pokemon that don't neatly fit into either category of "base species" or "forms" in regards to sprites. These are species that have female-specific sprites, but don't have actual female forms.

For example, Meowstic has two forms; a base form which is considered "male", and form 1 which is considered "female." Because each gender uses a different form number, it's easy to set metrics for both the male and female forms of Meowstic.

However, a Pokemon like Unfezant only has a base form. Yet, it has wildly different sprites based on whether it's male or female. These sprites do not count as different "forms", and are instead added by simply adding `_female` to the end of the sprite's file name.

These female sprites are put in an awkward position where they can't be given their own unique metrics in vanilla Essentials since they will always just use the same metrics as the base male sprite because there is no form number assigned to them. This plugin resolves this issue by allowing you to create metrics data that can be exclusively used by female sprites.

***

<mark style="background-color:orange;">**Implementation**</mark>

Whenever you recompile your game, this plugin will read the sprite files for each species. If it discovers that a species has sprites that includes `_female` in their filename, that species will be automatically given the `"HasGenderedSprites"` flag.

Species with this flag can now have separate metrics implemented specifically for the female version of its sprites that will not overlap with the metrics used for its default male sprites.

Actually setting metrics for female sprites is implemented in the same exact way as any other metrics. The only difference is that in addition to inputting a form number, the word female must now also be included in the ID for that metrics entry.

Here's an example of the metrics for both male and female Unfezant:

```ruby
[UNFEZANT]
BackSprite = -12,29
FrontSprite = 8,5
ShadowSprite = 2,14,4
#-------------------------------
[UNFEZANT,,female]
BackSprite = -15,35
FrontSprite = 11,5
ShadowSprite = 2,5,4
```

As you can see, the second entry includes two additional elements in the array to form its ID besides just the species ID. The second element is the form for this species' metrics (which is blank in this case, since it's still the base form), and a new third element which can be entered which is simply the word "female." This is what flags this metrics entry to be considered as a separate entry from male Unfezant.

While the "form" element will usually be blank, there are scenarios where you may have a form of a species who itself has gender differences. For example, Sneasel is a unique case where both base Sneasel and Hisuian Sneasel (form 1) have separate gendered sprites for both forms. In these cases, paying attention to the "form" element actually matters.

Metrics for base Sneasel and female Sneasel:

```
[SNEASEL]
BackSprite = 3,20
FrontSprite = -2,7
ShadowSprite = 0,0,0
#-------------------------------
[SNEASEL,,female]
BackSprite = 6,18
FrontSprite = -3,6
ShadowSprite = 1,0,0
```

Metrics for Hisuian Sneasel and female Hisuian Sneasel:

```
[SNEASEL,1]
BackSprite = 2,37
FrontSprite = 4,27
ShadowSprite = 1,-11,-8
AnimationSpeed = 1
#-------------------------------
[SNEASEL,1,female]
BackSprite = 3,16
FrontSprite = -2,8
ShadowSprite = 1,5,0
```

Note that metrics for female sprites may also be entered via the Sprite Editor in debug mode. So you don't have to worry about how to enter metrics manually in the PBS files if you're confused by any of the above.

</details>

<details>

<summary>Changes to Existing Metric Parameters</summary>

Many of the parameters found in the vanilla `pokemon_metrics.txt` file have been tweaked for compatibility with animated Pokemon sprites.

* `BackSprite`\
  This parameter now accepts a third number that corresponds to the level of scaling that should be applied to this sprite. If no third number is entered, it is assumed to be equal to the number entered as `BACK_BATTLER_SPRITE_SCALE` in the plugin Settings.<br>
* `FrontSprite`\
  This parameter now accepts a third number that corresponds to the level of scaling that should be applied to this sprite. If no third number is entered, it is assumed to be equal to the number entered as `FRONT_BATTLER_SPRITE_SCALE` in the plugin Settings.<br>
* `ShadowX`\
  This parameter is no longer used, and serves no purpose. Nothing bad will happen if you manually enter a value for this parameter in the metrics PBS files, but it won't do anything and will not be saved upon compiling or rewriting PBS files.<br>
* `ShadowSize`\
  This parameter is now optional, and will not cause any issues if omitted from a species' metrics data. This can now be set to any number ranging from -9 to 9 to control the scaling applied to the species' shadow sprites. If set to 0, this species will have no visible shadow.

</details>

<details>

<summary>Newly-Added Metric Parameters</summary>

Several new parameters have been added to be used by the various metrics PBS files for compatibility with animated Pokemon sprites.

* `ShadowPosition`\
  This is a new required parameter that sets the positioning of a species' shadow sprites in battle. This is set as an array of three numbers. The first number corresponds to the X-axis coordinates of the shadow sprite, while the next two numbers correspond to the Y-axis coordinates of the back and front shadow sprites, respectively.<br>
* `AnimationSpeed`\
  This is a new optional parameter that sets the animation speed for a species' sprites. This is set either as a single number to set the animation speed for both the front and back sprites to the same value, or as an array of two numbers to set the animation speed separately for the back and front sprite, respectively. The numbers entered may range from 0-4. If this parameter is omitted, the animation speed for both sprites is assumed to be set at the default value of 2.<br>
* `SuperShinyHue`\
  This is a new optional parameter that sets the hue for the species' Super Shiny sprites. This is set as a number that can range from -255 to 255. If this parameter is omitted, the Super Shiny hue selected for each species and form will be completely randomized. This randomized hue will be re-randomized each time you compile the game.

</details>

***

<mark style="background-color:orange;">**Sprite Editor**</mark>

If you're unaware, accessing the Sprite Editor can be done by opening the debug menu and navigating to "PBS file editors..." From here, select "Edit pokemon\_metrics.txt" to open the Sprite Editor.

Once open, you'll have a list of all available species to you in alphabetical order to scroll through. Each species you highlight will display its sprites on screen to indicate how they will appear during battle. If you select a species, a list of options will appear which will allow you to customize the battle metrics for this species to tweak how they should be displayed to your liking.

However, there's a variety of noteworthy changes to the Sprite Editor implemented by this plugin that I will outline below.

<details>

<summary>Search Navigation</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FjoDnfR0wqAEJlfieCFtJ%2Feditor.gif?alt=media&#x26;token=927eecaa-c935-494e-87f9-767f1ddecbd6" alt="" data-size="original">

In the default Sprite Editor, the only way to navigate the species list is by pressing or holding the Up/Down arrow keys, or by pressing the `JUMPUP` (A) or `JUMPDOWN` (S) keys to scroll through entire pages at once.

However, because there may be as many as 1,500+ species and forms to scroll through, this method of navigating the menu can be extremely tedious and time consuming. Especially if you only need to edit a specific species.

To address this, this plugin implements a new feature that allows you to manually type in a species to search for. By pressing the `ACTION` (Z) key while the species menu is open, a window will pop up on screen that will allow you to manually type text into. If you enter the name of the desired species you're looking for in this search bar, your cursor will automatically jump to the first species in the list that matches the name you entered. Note that capitalization is irrelevant, so typing in all lowercase is fine.

However, you don't necessarily need to type the entire name of a species. Any text you enter here will search the entire species list for the first species that is even a partial match to what you typed, and move your cursor to that species.&#x20;

For example, if you only typed in the letters "chu" into the search bar, the menu cursor will find the first species in the list that contains "chu" in its name, which in this case would be Pichu. If you typed in only the letters "pi", then the menu cursor will jump to the first species in the list that contains "pi" in its name, which would be Caterpie.

You can use this shorthand to quickly search for specific species without having to type out the entire name every time. For example, just typing the ":" symbol in the search bar will always jump straight to Type:Null, since that's the only species in the entire list that has the ":" symbol in its name.

</details>

<details>

<summary>Species Icons</summary>

The first immediate change you may notice is that the menu icon of the species you're currently viewing will now be displayed in the upper left corner of the screen. This doesn't provide any functional use, but it's displayed here more as a matter of convenience so that you may view all sprites related to a species in once place.&#x20;

This can prove useful in situations where you're adding a ton of new sprites to your game for custom species, as you'll be able to more easily catch if you accidentally overlooked adding an appropriate menu icon for that new species, or if you named one of the sprites incorrectly.

</details>

<details>

<summary>Female Sprites</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FRHXg3eA1iTT43HBW5JeT%2Feditor2.gif?alt=media&#x26;token=59ec2d28-cd5f-4a79-9043-130fe3cce1f3" alt="" data-size="original">

Typically, the Sprite Editor will only display unique species or forms of species in the list of all possible sprites to view. However, this doesn't take into account species that have unique female-specific sprites that aren't tied to a form.

For example, Indeedee has unique forms based on its gender, so the Sprite Editor will list Indeedee and Indeedee (form 1) as separate entries, as form 1 is its female form. However, a species like Pyroar has very different looking male and female sprites, but the female version isn't considered a unique form. Hence, it will not appear in the Sprite Editor.

This makes it impossible to set separate metrics for female sprites on species that have different sprites based on gender which aren't tied to unique forms. However, this plugin overhauls the metrics system so that this is now possible.

When scrolling through the species list in the Sprite Editor, you will now see species entries with a (F) next to their name. Any entry that has this are female-exclusive sprites for that species. You may edit the metrics for these sprites, and they will be saved as separate entries from their default male sprites. You can use this to implement wildly different sprites for different genders of the same species, complete with their own metrics.

</details>

<details>

<summary>Shiny Sprite Toggling</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fua5QGZTyOAaOmGC1sSv6%2Feditor3.gif?alt=media&#x26;token=f0d86241-b5d8-4409-9b80-24b17579e685" alt="" data-size="original">

While viewing the species list or selecting a menu option for a species, you may now press the `SPECIAL` (D) key to toggle between the normal, shiny, or super shiny sprites for that species. While viewing the shiny or super shiny variants, a menu box will appear on the lower left half of the screen indicating which variants you're looking at.

While a shiny variant is toggled, all sprites displayed for all species will display that variant instead of their normal sprites. This includes the menu icon sprites in the top left corner of the screen.

You can use this feature to check out how the shiny variants of each species will appear in-game, as well as viewing the type of hues the super shiny variants of a species will have.

</details>

<details>

<summary>Improved Metrics: Ally &#x26; Enemy</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FaUWhOaok4iSt0XAK0bpQ%2Feditor4.gif?alt=media&#x26;token=fa4f6a4c-2811-4631-8d38-253a048bd304" alt="" data-size="original">

Typically, when selecting the "Set Ally Position" or "Set Enemy Position" options, you are given the ability to set the X and Y axis coordinates for each respective sprite. This is indicated by a window in the top left corner of the screen that lists the values of these two coordinates. The X axis value may be edited with the Left/Right arrow keys, while Y axis value may be edited with the Up/Down arrow keys.

However, you will notice that this plugin now introduces a third number listed after the X and Y values. This third number relates to the scaling being applied to the particular sprite that you're editing.

To decrease the scaling applied to a sprite, you may press the `JUMPUP` (A) key. This will lower the scaling value, and decrease the overall size of the sprite. To increase the scaling applied to a sprite, you may press the `JUMPDOWN` (S) key. This will raise the scaling value, and increase the overall size of the sprite. The maximum scaling that can be applied to a sprite is 10, and the minimum scaling possible is 1.

You may use this feature to customize the scaling applied to an individual sprite, rather than relying on the `FRONT_BATTLER_SPRITE_SCALE` or `BACK_BATTLER_SPRITE_SCALE` plugin settings that affect all sprites globally.

</details>

<details>

<summary>Improved Metrics: Shadow Position</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FpPnH2pZbWu25mdMREOFO%2Feditor5.gif?alt=media&#x26;token=b066687e-0ac9-4b0e-881a-82bf69a787d7" alt="" data-size="original">

In vanilla Essentials, this option was only used to set the X axis coordinates of the Front sprite's shadow. However, because shadows are implemented entirely differently by this plugin and no longer use generic dark circles, this option is now much more robust than before.

In the top left corner of the screen, a window will now display three different coordinate values related to shadow positions.&#x20;

The first value corresponds to the X-axis coordinates of the shadow sprites, and can be adjusted with the Left/Right arrow keys. Note that this value applies to both the shadow cast by the Front *and* Back sprites simultaneously. The way this works is that whatever X value is set for the Front sprite is simply inverted for the Back sprite. For example, if you set the X value for the Front sprite's shadow to 5, then the value for the Back sprite's shadow will automatically be set to -5. This causes both sprites to be perfectly mirrored, so there is really no reason to have a separate X value to manually set for the Back sprite shadow.

The second value corresponds to the Y-axis coordinate of the shadow cast by the Back sprite, and can be adjusted with the `JUMPUP` (A) and `JUMPDOWN` (S) keys. Note that the Back sprite shadow will be entirely hidden during battle by default, and will likely be completely obscured by the default battle UI even if you enabled visibility. So whatever value set here will very rarely matter. But it's available to set if you wish.

The third and final value corresponds to the Y-axis coordinate of the shadow cast by the Front sprite, and can be adjusted with the Up/Down arrow keys. This is typically the value that actually matters most in terms of visibility and having the shadows display correctly.

***

<mark style="background-color:orange;">**Shadow Size**</mark>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fga6MKW9j1WSpXOLGenz4%2Feditor6.gif?alt=media&#x26;token=c1ef35a4-4c53-48f8-962d-fee908a58c9c" alt="" data-size="original">

In vanilla Essentials, there is a second menu option called "Set Shadow Size" that allows you to set which generic shadow circle should appear beneath the Front sprite out of 3 possible size options. Because shadows are now cast dynamically and no longer used these generic shadow options, there is no longer a use for this setting.

However, there still may be rare scenarios where you may want to increase or decrease the scaling applied to the shadow cast by a Pokemon. If you would like to do so, you can press the `ACTION` (Z) key while editing the Shadow Position of a sprite to toggle to setting the Shadow Size.

While in this mode, you may use the Up/Down keys to increase or decrease the amount of scaling applied to the shadow sprites of a species. By default, all species use a sprite scaling of 1, but this can be changed to be as high as 9, or as low as -9.

Note that if you set the Sprite Size of the shadow sprites to 0, this will count as having no shadow, and the shadow sprites for this species will be completely hidden in battle.

</details>

<details>

<summary>New Metrics: Animation Speed</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FovAOuXzGuiQDzQCFYt4H%2Feditor7.gif?alt=media&#x26;token=9f925da3-2cd0-41a9-8de1-ee12014a9f27" alt="" data-size="original">

A brand new option in the menu list is added by this plugin called "Set Animation Speed." This will allow you to adjust the speed at which a species' sprites will animate when viewed.

When selected, a new window will be displayed with a new list of options to choose from. These options include the following:

* Still
* Fast
* Normal
* Slow
* Slowest

When you navigate through this list, both of the displayed sprites will update to show you what they would look like when animating at the highlighted speed. When you select one of these options, you will be open yet another new menu of options that contains the choices of "Both", "Ally", and "Enemy".

When "Both" is selected, the selected animation speed will be applied to both the Front and Back sprites of this species. When "Ally" is selected, the selected animation speed will only be applied to the Back sprite. And lastly, if "Enemy" is selected, the selected animation speed will only be applied to the Front sprite.

During this process, there will be a window displayed in the bottom left portion of the screen that will display the set speeds for both sprites, so you will always have an indication of which speed has been set to each sprite.

</details>

<details>

<summary>New Metrics: Super Shiny Hue</summary>

<img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FhWmRAGSbsbd6AxH5ez2Y%2Feditor8.gif?alt=media&#x26;token=266b355c-cfbe-4ad2-ad5a-0f748dc65150" alt="" data-size="original">

A brand new option in the menu list is added by this plugin called "Set Super Shiny Hue." This will allow you to adjust and set the specific hue which is applied to the sprites of super shiny Pokemon of the viewed species or form.

When selected, a window will appear in the top left corner of the screen displaying the current Super Shiny Hue of the species, and the sprites displayed will automatically toggle to their super shiny variants.

You can press or hold the Up/Down arrow keys to increase or decrease the value of this species' Super Shiny Hue by 1. Or, you may press or hold the Left/Right arrow keys to increase or decrease this value by increments of 10 instead.

The value of a hue cannot exceed 255, and cannot be lower than -255, so the values will cap at those extremes. Once you've settled on a hue value you like, you can just confirm the selection to set it.

</details>

Page 114:

# Animated: Mid-Battle Scripting

<mark style="background-color:orange;">**Command Keys**</mark>

These are keys which trigger certain actions related to animated Pokemon sprites.

<details>

<summary><mark style="background-color:blue;">"spriteSpeed"</mark> => <mark style="background-color:yellow;">Integer</mark></summary>

Forces a battler's sprite to animate at the entered speed. This must be set to an integer ranging from 0-4.

* 0: No animation (static sprite)
* 1: Fast animation
* 2: Normal animation
* 3: Slow animation
* 4: Very slow animation

</details>

<details>

<summary><mark style="background-color:blue;">"spriteReverse"</mark> => <mark style="background-color:yellow;">Boolean</mark></summary>

Forces a battler's sprite to begin animating backwards. This must be set to either `true` to begin animating in reverse, or `false` to return to its original animation.

</details>

<details>

<summary><mark style="background-color:blue;">"spriteHue"</mark> => <mark style="background-color:yellow;">Integer</mark></summary>

Forces a battler's sprite to change hue. This must be set to a number ranging from -255 to 255 to set the desired hue.

</details>

***

<mark style="background-color:orange;">**Hardcoding**</mark>

Here's a list of methods and/or properties that you might want to reference when hardcoding a midbattle script, since this plugin adds a lot of new custom content which you may need to call on to make certain things happen:

<details>

<summary>GameData::Species</summary>

* `has_gendered_sprites?`\
  Returns true if the species has the `"HasGenderedSprites"` flag, which is automatically assigned if the species has female-exclusive sprites that aren't tied to a form.<br>
* `shows_shadow?(back = false)`\
  Returns true if the species' sprites should cast a viewable shadow. This will only return false when a species has its `ShadowSize` metrics set to 0, or if `back` is true and the `SHOW_PLAYER_SIDE_SHADOW_SPRITES` plugin setting is disabled.

</details>

<details>

<summary>GameData::SpeciesMetrics</summary>

* `back_sprite_scale`\
  Returns the scaling applied to a species' back sprite.<br>
* `front_sprite_scale`\
  Returns the scaling applied to a species' front sprite.<br>
* `back_sprite_speed`\
  Returns the animation speed applied to a species' back sprite.<br>
* `front_sprite_speed`\
  Returns the animation speed applied to a species' front sprite.<br>
* `sprite_super_hue`\
  Returns the Super Shiny hue applied to a species' sprites.<br>
* `get_random_hue`\
  Re-randomizes the Super Shiny hue applied to a species' sprites if one has not been set.<br>
* `shows_shadow?(back = false)`\
  Returns true if the species' sprites should cast a viewable shadow. This will only return false when a species has its `ShadowSize` metrics set to 0, or if `back` is true and the `SHOW_PLAYER_SIDE_SHADOW_SPRITES` plugin setting is disabled.

</details>

<details>

<summary>Battle::Scene class</summary>

* `pbGetBattlerSprites(idxBattler)`\
  Returns the sprite and shadow sprite objects of the bounder found at the index idxBattler.<br>
* `pbAnimateSubstitute(idxBattler, mode, delay = false)`\
  Animates the Substitute doll for the battler found at the index `idxBattler`. Details on this method can be found in the "Dynamic Sprite Effects" subsection in the write-up related to the Substitute Doll. <br>
* `pbUpdateSubstituteSprite(battler, mode)`\
  Updates the state of the Substitute doll for the battler found at the index `idxBattler`, but without playing any animations. The mode argument functions the same way as it does for the `pbAnimateSubstitute` method.

</details>

<details>

<summary>Battle::Battler class</summary>

* `airborneOffScreen?`\
  Returns true if the battler's sprite is currently hidden due to being in the middle of a two-turn attack that sends the user airborne (Fly, Bounce, Sky Drop).<br>
* `vanishedOffScreen?(ignoreAirborne = false)`\
  Returns true if the battler's sprite is currently hidden due to being in the middle of a two-turn attack that puts the user in a semi-invulnerable state. If `ignoreAirborne` is true, this will not return true if the battler's shadow is still visible due to being airborne during their semi-invulnerable phase.

</details>

<details>

<summary>Battle::Scene::BattlerSprite class</summary>

* `speed`\
  Sets the animation speed of a battler's sprite, overriding its natural speed. This can be a value ranging from 0-4.<br>
* `reversed`\
  Toggles whether the battler's sprite should animate in reverse or not. This is set to false by default.<br>
* `hue`\
  Sets the hue of a battler's sprite. This can be a value ranging from -255 to 255. This cannot be overwritten if the battler's hue is already being altered due to being Super Shiny.

</details>

Page 115:

# Animated Trainer Intros

[**Eevee Expo Link**](https://eeveeexpo.com/resources/1667/)

[**PokeCommunity Link**](https://www.pokecommunity.com/threads/animated-trainer-intros-dbk-add-on-v21-1.535934/#post-10927205)

[**Download Link**](https://www.mediafire.com/file/hfqiviurodsuigl/Animated_Trainer_Intros.zip/file)

This plugin builds upon the Deluxe Battle Kit to implement animated trainer intros for all trainers who had them that appeared in *Pokemon Heart Gold & Soul Silver*, *Pokemon Platinum*, *Pokemon Black & White,* and their sequels. This isn't merely a sprite pack however, as it implements a variety of features and that utilize several functions of the Deluxe Battle Kit and other supported plugins. This plugin builds off of the code that is used to animate Pokemon sprites in the Animated Pokemon System plugin, which itself was built off of EBDX by Luka S.J.

In addition to providing the actual sprites for every trainer with animated intros, this plugin also provides all trainer mugshots that were used across all of the games within generations 4 and 5. Below, I'll list all of the sprites that are added or replaced by this plugin.

***

<mark style="background-color:orange;">**Trainer Front Sprites**</mark>

All trainer sprites included in Essentials by default are from Gen 3 - specifically FRLG, which are smaller in size compared to the trainers in the Gen 4 & 5 games. This makes them visually inconsistent with the trainer sprites from later gens. To resolve this, I included replacement sprites for ALL of the default trainer classes found in Essentials.

The replaced sprites roughly fit into three categories:

* An animated sprite strip for that trainer class found in either Gen 4 or 5.
* If no animated sprite for that trainer class exists, a single-frame sprite from Gen 4 or 5 is included instead.
* If the trainer class doesn't have an animated OR a single-frame sprite found in either Gen 4 or 5, then a resized version of the same exact FRLG sprite is included.

Some trainer classes got renamed between generations (for instance, "Cool Trainers" became "Ace Trainers"), so in those cases I just kept the Gen 3 class names while giving them the newer-gen sprites. Other trainer classes simply never returned in the series after Gen 3, so they have no equivalents in later gens. In these rare cases, these sprites are simply replaced with classes that are somewhat related. For instance, the sprite used for the "Engineer" class is replaced with the sprite used in HGSS for the "Worker" class, which looks similar.

In some cases, there simply are no sprites from the Gen 4 or 5 games that can be used to replace the Gen 3 trainer sprites. This is mostly true for player characters, such as Brendan, May, and Leaf, or specific characters, such as Agatha. In these cases, the same sprite that Essentials uses by default is kept, since there is no alternative. However, these sprites are still resized to be compatible with this plugin out of the box. Keep in mind that they won't look consistent next to the newer sprites.

In addition to all of the replaced sprites, this plugin also includes many new sprites for trainer classes not found in Essentials by default. Here are all of the new trainer classes and sprites added by this plugin:

<details>

<summary>New Trainer Front Sprites</summary>

* Scientist (Female)
* Pokemon Breeder (Male)
* Backpacker (Male/Female)
* Poke Fan (Male/Female)
* Preschooler (Male/Female)
* Nursery Aide
* School Kid (Male/Female)
* Rich Boy
* Socialite
* Parasol Lady
* Clerk (Male/Female)
* Clerk (Alternate Male)
* Janitor
* Maid
* Baker
* Waiter
* Waitress
* Doctor
* Nurse
* Worker
* Worker (Snowy version)
* Depot Agent
* Pilot
* Police Man
* Hooligans
* Guitarist
* Musician
* Dancer
* Artist
* Harlequin
* Cyclist (Male/Female)
* Smasher
* Striker
* Infielder
* Hoopster
* Linebacker
* Backers (Male/Female)
* Veteran (Male/Female)
* Rocket Admin Archer
* Rocket Admin Ariana
* Rocket Admin Petrel
* Rocket Admin Photon
* Team Galactic (Male/Female)
* Galactic Boss
* Team Plasma (BW outfit) (Male/Female)
* Team Plasma (BW2 outfit) (Male/Female)
* Team Plasma Rood
* Team Plasma Zinzolin
* Plasma Boss (BW outfit)
* Plasma Boss (BW2 outfit)
* Shadow Triad
* Professor Juniper
* Pokemon Trainer Ethan
* Pokemon Trainer Lyra
* Pokemon Trainer Lucas (DP outfit)
* Pokemon Trainer Lucas (Platinum outfit)
* Pokemon Trainer Dawn (DP outfit)
* Pokemon Trainer Dawn (Platinum outfit)
* Pokemon Trainer Hilbert
* Pokemon Trainer Hilbert (Wonder Launcher)
* Pokemon Trainer Hilda
* Pokemon Trainer Hilda (Wonder Launcher)
* Pokemon Trainer Nate
* Pokemon Trainer Nate (Wonder Launcher)
* Pokemon Trainer Rosa
* Pokemon Trainer Rosa (Wonder Launcher)
* Pokemon Trainer Silver
* Pokemon Trainer Wally
* Pokemon Trainer Barry (DP outfit)
* Pokemon Trainer Barry (Platinum outfit)
* Pokemon Trainer Bianca (BW outfit)
* Pokemon Trainer Bianca (BW2 outfit)
* Pokemon Trainer Cheren (BW outfit)
* Pokemon Trainer Hugh
* Pokemon Trainer Colress
* Pokemon Trainer N
* Pokemon Trainer Mira
* Pokemon Trainer Marley
* Pokemon Trainer Buck
* Pokemon Trainer Cheryl
* Pokemon Trainer Riley
* Gym Leader Janine
* Gym Leader Falkner
* Gym Leader Bugsy
* Gym Leader Whitney
* Gym Leader Morty
* Gym Leader Chuck
* Gym Leader Jasmine
* Gym Leader Pryce
* Gym Leader Clair
* Gym Leader Roxanne
* Gym Leader Brawly
* Gym Leader Wattson
* Gym Leader Flannery
* Gym Leader Norman
* Gym Leader Winona
* Gym Leader Tate
* Gym Leader Liza
* Gym Leader Wallace
* Gym Leader Juan
* Gym Leader Roark
* Gym Leader Gardenia
* Gym Leader Maylene
* Gym Leader Crasher Wake
* Gym Leader Fantina
* Gym Leader Byron
* Gym Leader Candice
* Gym Leader Volkner
* Gym Leader Cilan
* Gym Leader Chili
* Gym Leader Cress
* Gym Leader Cheren
* Gym Leader Lenora
* Gym Leader Roxie
* Gym Leader Burgh
* Gym Leader Elesa (BW outfit)
* Gym Leader Elesa (BW2 outfit)
* Gym Leader Clay
* Gym Leader Skyla
* Gym Leader Brycen
* Gym Leader Drayden
* Gym Leader Iris
* Gym Leader Marlon
* Elite Four Will
* Elite Four Karen
* Elite Four Aaron
* Elite Four Bertha
* Elite Four Flint
* Elite Four Lucian
* Elite Four Shauntal
* Elite Four Marshal
* Elite Four Grimsley
* Elite Four Caitlin
* Champion Steven
* Champion Cynthia
* Champion Alder
* Champion Iris
* Tower Tycoon Palmer
* Factory Head Thorton
* Arcade Star Dahlia
* Castle Valet Darach
* Hall Matron Argenta
* Subway Boss Ingo
* Subway Boss Emmet
* Boss Trainer Benga

In addition to all of the above, the following sprites have been added that were used in Poke Star Studios in *Pokemon Black & White 2*.

* Mo-Cap Actor
* Masked Man (Brycen-Man)
* Battleship (Brycen-Jet)
* Mecha Cop
* Invader (Alien)
* UFO (Alien ship)
* Magical Maid
* Black Belt (Reskin)
* Transporter Machine
* Magic Queen
* Plush Doll
* Giantess
* Old Statue
* Haunted Kid (Preschooler F)
* Haunted Man (Janitor)
* Haunted Man (Gentleman)
* Red Fog

</details>

***

<mark style="background-color:orange;">**Trainer Back Sprites**</mark>

None of the trainer back sprites included in Essentials by default are replaced by this plugin. However, this plugin does ADD many new trainer back sprites, pulling from various games. All trainer back sprites that have appeared in the series from Gen 3-5 are included in this plugin.

Note, however, that the size of trainer back sprites are not consistent between generations. The size and dimensions of these sprites are all different between Gens 3, 4, and 5. Because of this, I had to manually cut and resize all of these sprites to try and "fit" the ball throwing animation as best as possible. However, I did include folders containing all of the unedited Gen 4 and 5 back sprites, if you wish you use them for whatever reason.

Below is a list of every new trainer back sprite added by this plugin.

<details>

<summary>New Trainer Back Sprites</summary>

* Old Man (FRLG)
* Poke Dude (FRLG)
* Rival Wally (RSE)
* Champion Steven (RSE)
* Player Lucas (DP)
* Player Lucas (Platinum)
* Player Dawn (DP)
* Player Dawn (Platinum)
* Rival Barry (DP)
* Rival Barry (Platinum)
* Partner Cheryl (DPP)
* Partner Mira (DPP)
* Partner Riley (DPP)
* Partner Marley (DPP)
* Partner Buck (DPP)
* Player Ethan (HGSS)
* Player Lyra (HGSS)
* Rival Silver (HGSS)
* Champion Lance (HGSS)
* Player Hilbert (BW)
* Player Hilbert - Wonder Launcher (BW)
* Player Hilda (BW)
* Player Hilda - Wonder Launcher (BW)
* Professor Juniper (BW)
* Rival Cheren (BW)
* Player Nate (BW2)
* Player Nate - Wonder Launcher (BW2)
* Player Rosa (BW2)
* Player Rosa - Wonder Launcher (BW2)
* Bianca (BW2)
* Rival Hugh (BW2)
* Gym Leader Cheren (BW2)
* Gym Leader Cilan (BW2)
* Gym Leader Chili (BW2)
* Gym Leader Cress (BW2)

</details>

***

<mark style="background-color:orange;">**Trainer Mugshots**</mark>

Starting in Gen 4, important or prominent trainers that you battle will have special battle transitions featuring a mugshot of their face. Essentials contains a few of these mugshots by default for Kanto Gym Leaders and a few others. However, this plugin adds ALL of the remaining trainer mugshots from all of the Gen 4 & 5 games.

Below are all of the new mugshots added by this plugin.

<details>

<summary>New Trainer Mugshots</summary>

* Pokemon Trainer Lucas (Platinum)
* Pokemon Trainer Dawn (Platinum)
* Pokemon Trainer Silver (HGSS)
* Pokemon Trainer Hilbert (BW)
* Pokemon Trainer Hilda (BW)
* Pokemon Trainer Nate - Full Body (BW2)
* Pokemon Trainer Rosa - Full Body (BW2)
* Pokemon Trainer Cheren (BW)
* Pokemon Trainer Bianca (BW)
* Pokemon Trainer N (BW)
* Pokemon Trainer Colress (BW)
* Team Rocket Admin Archer (HGSS)
* Team Rocket Admin Ariana (HGSS)
* Team Rocket Admin Proton (HGSS)
* Team Plasma Boss Ghetsis (BW)
* Team Plasma Boss Ghetsis (BW2)
* Gym Leader Janine (HGSS)
* Gym Leader Falkner (HGSS)
* Gym Leader Bugsy (HGSS)
* Gym Leader Whitney (HGSS)
* Gym Leader Morty (HGSS)
* Gym Leader Chuck (HGSS)&#x20;
* Gym Leader Jasmine (HGSS)
* Gym Leader Pryce (HGSS)
* Gym Leader Clair (HGSS)
* Gym Leader Roark (Platinum)
* Gym Leader Gardenia (Platinum)
* Gym Leader Maylene (Platinum)
* Gym Leader Crasher Wake (Platinum)
* Gym Leader Fantina (Platinum)
* Gym Leader Byron (Platinum)
* Gym Leader Candice (Platinum)
* Gym Leader Volkner (Platinum)
* Gym Leader Cilan (BW)
* Gym Leader Chili (BW)
* Gym Leader Cress (BW)
* Gym Leader Cheren (BW2)
* Gym Leader Lenora (BW)
* Gym Leader Roxie (BW2)
* Gym Leader Burgh (BW)
* Gym Leader Elesa (BW)
* Gym Leader Elesa (BW2)
* Gym Leader Clay (BW)
* Gym Leader Skyla (BW)
* Gym Leader Brycen (BW)
* Gym Leader Drayden (BW)
* Gym Leader Iris (BW)
* Gym Leader Marlon (BW2)
* Elite Four Will (HGSS)
* Elite Four Bruno (HGSS)
* Elite Four Karen (HGSS)
* Champion Lance (HGSS)
* Elite Four Aaron (Platinum)
* Elite Four Bertha (Platinum)
* Elite Four Flint (Platinum)
* Elite Four Lucian (Platinum)
* Champion Cynthia (Platinum)
* Elite Four Shauntal (BW)
* Elite Four Marshal (BW)
* Elite Four Grimsley (BW)
* Elite Four Caitlin (BW)
* Champion Alder (BW)
* Champion Iris - Face (BW2)
* Champion Iris - Full body (BW2)
* Tower Tycoon Palmer (Platinum)
* Factory Head Thorton (Platinum)
* Arcade Star Dahlia (Platinum)
* Castle Valet Darach (Platinum)
* Hall Matron Argenta (Platinum)
* Boss Trainer Benga (BW2)

</details>

Page 116:

# Intros: Trainer Sprites

The trainer sprites used by this plugin are long strips which contain each frame of the trainer's entire intro animation. The dimensions for these strips must always be broken up into squares. So for example, if you have a sprite 96 pixels tall that has 10 frames of animation, then the final dimensions for this sprite strip must be 960x96 so that each "frame" of this strip is a perfect square (96x96).

As long as your strips produce perfect squares for each frame, there is no set sizes that are required for your sprites. They can be as large or as small as you'd like, as long as they follow the square rule.

***

<mark style="background-color:orange;">**Sprite Scaling**</mark>

As mentioned above, there are no limitations on how small or how large your sprites may be. The reason for this is because this plugin includes sprite scaling features that allow you to scale up or scale down any trainer sprite to your liking. This means that no matter what size your sprites are, they can be modified to fit within your game without having to manually edit the individual sprite itself.

There are two ways to affect sprite scaling. I'll cover both methods below.

<details>

<summary>Sprite Scaling through Settings</summary>

In the plugin Settings file, you will see the `TRAINER_SPRITE_SCALE`  setting. This controls the overall sprite scaling for all trainer sprites, and acts as the default scaling value. Note that this scaling property only affects front sprites for trainers; any back sprites that a trainer may have is completely unaffected by this and will just display normally.

By changing the scaling value, you can change the overall sprite scaling for all trainer sprites in the game. Note that this does affect *all* trainer sprites at once, so this setting should only be used if you want to affect the overall scaling of sprites globally, as opposed to individual sprites. If you only want to affect the sprite scaling of a particular sprite, refer to the PBS method of scaling sprites.

By default, `TRAINER_SPRITE_SCALE` is set to 2, which means all trainer sprites will be displayed twice as large in-game. This is the default setting because all trainer sprites provided by this pack are much smaller in size than the ones included within Essentials by default.

</details>

<details>

<summary>Sprite Scaling through PBS</summary>

Sometimes you may only want to change the scaling applied to a specific sprite. This can easily be accomplished by editing the values of the sprite of that particular Trainer Type in the various `trainer_types.txt` PBS files.

In these files, a new line of data may be added to a trainer type called `SpriteScale`. This can be set to a number to set the level of sprite scaling applied to this trainer type's sprite. If set to 1, the trainer will display without any scaling. If set to 2, the trainer's sprite will be doubled in size. If set to 3, it will be tripled in size, etc.

The level of scaling set here for a particular trainer type will override whatever the default value set with `TRAINER_SPRITE_SCALE` would normally be.

Note that if you set the sprite scaling for a sprite that is already equal to the default value set in `TRAINER_SPRITE_SCALE`, it will be treated as if you entered nothing, and the number you entered here will not be saved whenever your PBS files are forced to update.

Also note that these sprite scaling metrics may also be applied via debug mode through a special trainer sprite editor. But I'll go over more on that in its own subsection.

</details>

***

<mark style="background-color:orange;">**Animation Speed**</mark>

There are no minimum requirements for how long your sprite strips may be for each trainer. Some trainers may have only 3 or 4 frames of animation, while others may have dozens. This means that some trainers may have really long animations, while others may have really short ones.

However, regardless of the number of frames in a trainer's animation, all trainer sprites will complete their intro animations within the same amount of time. This is to keep all trainer intros consistent with one another, so that they always take up the same amount of time at the start of a battle regardless of how long their sprite strips are.

The exact amount of time trainer intros take is controlled with the plugin Setting `TRAINER_ANIMATION_SPEED`. This sets the number of seconds a trainer's intro animation should last before completing. By default, this is set to 1.5, meaning all trainers will complete their entire intro in one and a half seconds at the start of the battle. You can adjust this to your liking if you'd prefer trainers to take longer or shorter to animate at the start of battle.

Note that the number set here should always be a float number, meaning it should always include a decimal place. For example, if you would like to set the trainer intros to last 2 seconds, you would set this value to `2.0`, *not* just `2`.

***

<mark style="background-color:orange;">**Shadow Sprites**</mark>

In vanilla Essentials, trainers do not cast any shadows on the battlefield, unlike Pokemon sprites. However, this plugin makes it so that trainers will cast shadows when they appear in battle, and these shadows will even animate along with the trainer.

This is implemented by creating a copy of the trainer's sprite and modifying it to appear greyed out, stretched, and transparent. However, it will still animate exactly as the normal sprite does, following the trainer's actions exactly.

The shadow sprite for each trainer type can be tweaked to set the coordinates in which they appear, as well as their visibility. This can easily be accomplished by adding new lines of data for that particular Trainer Type in the various `trainer_types.txt` PBS files.

<details>

<summary>Shadow Sprite Metrics</summary>

There are two parameters which can control elements of a trainer's shadow sprite. These are the `ShadowXY` and the `HideShadow` parameters. Note that both of these parameters are completely optional.

***

<mark style="background-color:orange;">**ShadowXY**</mark>

This is a new parameter introduced by this plugin that adjusts the X and Y values of a trainer's shadow sprite. By default, a trainer's shadow will be set to appear in the same coordinates as the trainer sprite itself is displayed. For many trainer sprites, this is usually "close enough", and doesn't require major tweaks. However, some trainer shadows may need to be adjusted a bit to look right, so that's where this setting comes in.

The first number in this array corresponds to how many pixels to shift the trainer's shadow sprite on the X-axis. The second number in this array corresponds to how many pixels the trainer's shadow sprite will be shifted on the Y-axis. If no shifting is required on one of these axis, you can simply set that value to 0.

***

<mark style="background-color:orange;">**HideShadow**</mark>

This is a new parameter introduced by this plugin that adjusts the visibility of a trainer's shadow sprite. This can simply be set to `true` or `false`. However, it is always assumed by default that a trainer will display its shadow, so setting this to `false` is never necessary. The only time you would need to set this parameter is if you *don't* want a particular trainer type to display a shadow in battle. In which case, you would set the line `HideShadow = true`.

</details>

***

<mark style="background-color:orange;">**Sprite Hues**</mark>

This plugin allows you to modify the hue of a trainer's sprites so that you can tweak their coloration. This can give you a way of making a variety of different trainer types that all share the same sprite, but utilize different colors. This can help you cut down on having to make duplicate sprites.

Note that setting a hue for a particular trainer type will affect all sprites for that trainer, including their front sprite, back sprite (if any), and their mugshots (if any). Their overworld sprite, however, will not be affected.

You can easily set a hue for a trainer by adding new lines of data for that particular Trainer Type in the various `trainer_types.txt` PBS files. To so so, you can simply add the line `SpriteHue` and set it to a number between -255 to 255. By default, all trainers are assumed to have a hue of 0.

Page 117:

# Intros: Sprite Editor

This plugin adds a new editor that allows you to quickly edit your trainer sprites. This is similar to the Pokemon metrics editor, but specifically for trainer sprites.

In this subsection, I will go over all of the features of this new trainer sprite editor.

***

<mark style="background-color:orange;">**Accessing the Trainer Sprite Editor**</mark>

In vanilla Essentials, you can edit the properties of trainer types by accessing the debug menu and selecting "PBS file editors..." and then selecting "Edit trainer\_types.txt." However, this plugin expands this editor so that you may now also edit your trainer sprites.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FooT1rano1Oj448CUMyfK%2F%5B2025-04-16%5D%2017_20_32.120.png?alt=media&#x26;token=081a1ac2-5a88-4fad-a874-0da1de8e1e48" alt="" width="384"><figcaption><p>The trainer type editor now has two editors to choose from.</p></figcaption></figure>

When selecting to edit the `trainer_types.txt` PBS file, you will now be presented with two options to choose from, rather than immediately being taken to the properties editor. These options will be called "Edit properties", which will take you to the usual editor, while the second option will be called "Edit sprites", which will open the trainer sprite editor.

***

<mark style="background-color:orange;">**Navigating the Sprite Editor**</mark>

Once inside the editor, you can select a specific trainer type from the list and edit the properties of that sprite. Below, I'll explain how to navigate this menu, and what you can expect to see displayed for each trainer type.

<details>

<summary>Menu Navigation</summary>

In the editor menu, the names of ever trainer type in your game will be displayed alphabetically. The gender of each trainer type will be displayed as part of the trainer type's name, if they have one. In addition, any trainer type that has an ID with an underscore in it will display the text after that underscore next to that trainer type's name, in parentheses.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FNz0LP8QwKiFKtkd41PsT%2F%5B2025-04-17%5D%2013_34_48.076.png?alt=media&#x26;token=4e32d361-01ea-4141-a55c-5bed80708c3a" alt="" width="384"><figcaption><p>Trainer type names listed in the sprite editor.</p></figcaption></figure>

For example, `:LEADER_Brawly` will display in this editor as `Gym Leader ♂ (Brawly)`. This makes it easier to navigate to the exact trainer type you want to edit, since many different trainer types may share the same display name (such as Gym Leaders, or various "Pokemon Trainers").

While scrolling through this list of trainer types, each one will play their intro animation when they appear on screen. If you want to quickly scroll through the list, you can use the `JUMPUP (A)` and `JUMPDOWN (S)` keys to scroll through entire pages at once.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FQckOHusGRKjmMDqACcbd%2FAnimation2.gif?alt=media&#x26;token=8d9e3e0e-7e00-42eb-bc8e-00cae21933d6" alt="" width="375"><figcaption><p>Jumping to a specific trainer sprite using the search bar.</p></figcaption></figure>

If you'd like an even quicker method of navigation, pressing the `ACTION (Z)` key will pull up a window and allow you to type in the name of a specific trainer type you'd like to immediately jump to. This search bar isn't case sensitive, and it also accepts partial matches, so you don't have to accurately type out the full name as displayed in the menu. For example, just typing in "gym" will immediately jump to the first Gym Leader sprite in the menu.

</details>

<details>

<summary>Sprite Displays</summary>

For each trainer type found in the editor, a variety of different sprites may be displayed. This makes it easy at a glance to check all of the relevant sprites in your game related to each trainer type.

***

<mark style="background-color:orange;">**Front Sprite**</mark>

The front sprite and shadow for the trainer type will be displayed on the foe's side of the screen in the same position that it will appear during battle. If this trainer has a sprite strip, it will animate and play its intro animation. If no front sprite for this trainer type exists in `Graphics/Trainers`, then the placeholder question mark sprite will be displayed, similar to Pokemon sprites.

![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F2HYJAb2NAyEnKOyfKIGb%2F%5B2025-04-17%5D%2013_42_32.290.png?alt=media\&token=da5d808a-8e6f-4b99-8ed4-37d1717f4dc7)![](https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2F47DemmZPNTQjEc9la0iL%2F%5B2025-04-17%5D%2013_40_23.161.png?alt=media\&token=db7eac79-16c8-4f88-a8dd-d291b875fdeb)

***

<mark style="background-color:orange;">**Back Sprite**</mark>

If the selected trainer type has a back sprite located in `Graphics/Trainers`, then this will be displayed on the player's side of the screen in the same position that it will appear during battle. Unlike front sprites, the trainer's back sprite will not animate when displayed here.

Most trainers don't have back sprites, so no placeholder is used here if one isn't found.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FjJGVX6eiviDTGvW4Ubos%2F%5B2025-04-17%5D%2013_41_05.142.png?alt=media&#x26;token=81019e13-6947-42bc-af5b-a1ccd30d2d42" alt="" width="384"><figcaption></figcaption></figure>

***

<mark style="background-color:orange;">**Overworld Sprite**</mark>

If the selected trainer type has an overworld sprite located in `Graphics/Characters`, then this will be displayed in the top left corner of the screen.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FAMSSRm1yHW7ikdlruyzb%2F%5B2025-04-17%5D%2013_41_45.857.png?alt=media&#x26;token=526cf7ff-89ad-4fdb-843e-80761f398bb1" alt="" width="384"><figcaption></figcaption></figure>

***

<mark style="background-color:orange;">**Mugshot Sprite**</mark>

If the selected trainer type has a mugshot sprite located in Graphics/Transitions, then this will be displayed in the upper left quadrant of the screen, to the right of where the overworld sprite would be. Only mugshot sprites that begin with `hgss_vs_`, `vsE4_`, `rocket_`, or `vsTrainer_` in their file names will be searched for.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FryvPihwr3sttQUwOyn97%2F%5B2025-04-17%5D%2013_41_18.226.png?alt=media&#x26;token=65ae9bcc-8996-4f9a-aba1-a3be7ae2cc52" alt="" width="384"><figcaption></figcaption></figure>

</details>

***

<mark style="background-color:orange;">**Command Menu**</mark>

When you select a highlighted trainer type in the main menu, a new command window will open up with a variety of options to select from. These options will allow you to edit how these sprites will be displayed in battle. Below, I'll explain the functions for each option found in this command menu.

<details>

<summary>Replay Animation</summary>

When selected, the front sprite for this trainer type will replay its animation from the beginning. You can use this to view this animation as many times as you like. If you select this while viewing a trainer sprite that doesn't have an animation, nothing will happen.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FFOonLrfiHJUbDsZIvUvA%2FAnimation2.gif?alt=media&#x26;token=43a0a031-434f-4c21-87f7-068cde49aa70" alt="" width="563"><figcaption><p>Replaying the sprite animation.</p></figcaption></figure>

</details>

<details>

<summary>Set Sprite Scaling</summary>

This option will allow you to set the sprite scaling that should be applied to the front sprite of this trainer type. Use the arrow keys to increase or decrease the amount of scaling applied. Note that any scaling applied to the trainer sprite will automatically be applied to its shadow, too.

The lowest amount of scaling a sprite may have is 1 (no scaling), while the most amount of scaling a sprite may have is 10 (ten times larger).

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FMUSi8zOq9FtnpjJ36Qiv%2FAnimation2.gif?alt=media&#x26;token=e8407989-eaa9-41c2-9ef4-2b0b71e74cfb" alt="" width="563"><figcaption><p>Editing the scaling applied to a trainer sprite.</p></figcaption></figure>

</details>

<details>

<summary>Set Shadow Position</summary>

This option will allow you to set the metrics for the shadow cast by the front sprite of this trainer type. Use the `LEFT/RIGHT` arrow keys to move the shadow along the X axis, and the `UP/DOWN` arrow keys to move the shadow along the Y axis.

Note that if a trainer type is flagged to not cast any shadow, then these metrics cannot be edited.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FMnhSjjatF1k3GibkHHoE%2FAnimation2.gif?alt=media&#x26;token=79b5766e-ba38-4e4a-9c13-e768c2cde11f" alt="" width="563"><figcaption><p>Editing the shadow positioning of trainer sprites.</p></figcaption></figure>

</details>

<details>

<summary>Set Shadow Visibility</summary>

This option allows you to toggle whether or not this trainer type casts a shadow or not. Press the `USE` key to toggle the trainer's shadow on or off. When you've made your decision, press the `BACK` key to return to the command menu, and you will be prompted if you want to save your decision.

Note that whenever you turn off a trainer type's shadow, the metrics for that shadow is reset.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FQ66DulIaTMMmQSnTmiOF%2FAnimation2.gif?alt=media&#x26;token=b981dad9-bfd4-4cbe-84b2-d98de357b46a" alt="" width="563"><figcaption><p>Editing the shadow visibility of a trainer sprite.</p></figcaption></figure>

</details>

<details>

<summary>Set Sprite Hue</summary>

This option allows you to set a hue to apply to this trainer type's sprites. Use the `UP/DOWN` keys to increase or decrease the hue by 1, respectively. For a quicker method, you can use the `RIGHT/LEFT` keys to increase or decrease the hue by 10.

Note that when a hue is applied, this hue will not just apply to the trainer's front sprite, but to its back sprite and mugshot as well (if they have any). You can use hues to create variant trainer types that all utilize the same sprite, but with different hues. This may eliminate the need for including several redundant sprites.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FG3KdByzcuCIkozrBqe6X%2FAnimation2.gif?alt=media&#x26;token=6154211e-f06e-425b-8cf7-84f18129dcf1" alt="" width="563"><figcaption><p>Editing the hue applied to a trainer's sprites.</p></figcaption></figure>

</details>

Page 118:

# Intros: UI Sprites

Trainer sprites may also be set to animate in various UI's that are displayed out of battle. There are only a few places where trainer sprites are displayed during gameplay, though there are a few that are exclusive to debug mode editors.

***

<mark style="background-color:orange;">**Trainer Card**</mark>

When viewing the player's Trainer Card, the trainer sprite used for the player will animate. Note that Gen 4 & 5 trainer sprites are slightly taller than the Gen 3 sprites, so they may not perfectly fit within the bounds of the Gen 3-style UI.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FQI5EA3lJrCKNzMzq91mu%2FAnimation2.gif?alt=media&#x26;token=98fda3d4-e614-408f-8f9d-d40c914f9c08" alt="" width="375"><figcaption><p>The player's animated sprite on the Trainer Card UI.</p></figcaption></figure>

By default, the only player sprite characters that have animations are Red, Hilbert/Hilda, and Nate/Rosa. Any other player characters will only have still sprites.

***

<mark style="background-color:orange;">**Hall of Fame**</mark>

Whenever the player defeats the Champion as inducted into the Hall of Fame, the player's trainer sprite will slide on screen during the congratulations message. While this is happening, the trainer's sprite will play its animation.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FZccbNXLsrihroUsiyvab%2FAnimation2.gif?alt=media&#x26;token=af63e771-c4bb-4228-89f8-1ba7fcce2dbe" alt="" width="375"><figcaption><p>The player's sprite animated during Hall of Fame induction.</p></figcaption></figure>

By default, the only player sprite characters that have animations are Red, Hilbert/Hilda, and Nate/Rosa. Any other player characters will only have still sprites.

***

<mark style="background-color:orange;">**Trainer Editors**</mark>

While playing in debug mode, you can scroll through lists of various trainers when editing the `trainers.txt` or `trainer_types.txt` PBS files. On the right side of the screen, the sprites used for each trainer will be displayed. The intro animations of each trainer can be viewed while scrolling through these lists.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FrakWKidmU6XAOWEqEy1E%2FAnimation2.gif?alt=media&#x26;token=0d8db1b9-2f16-4529-bf2b-a1b464c6898a" alt="" width="375"><figcaption><p>Animated trainer sprits in the debug editors.</p></figcaption></figure>

Note that some trainer sprites are very large or have awkward orientations, so the trainer may not always appear exactly centered. This issue should never occur during actual battles, however.

Page 119:

# Intros: Battle Transitions

By default, Essentials includes various battle transitions that may display the mugshot of specific trainers when initiating battle with them. This plugin includes new mugshots for all trainers from the Gen 4 & 5 games that had them.

***

<mark style="background-color:orange;">**Improvements to Mugshot Transitions**</mark>

In order for mugshot transitions to work, you usually need additional bar graphics and such unique to each specific trainer type for the animations to work. This plugin edits these transition animations so that they will still work even if these bar graphics are missing by just falling back on a generic bar sprite that all trainers will use if a specific one isn't present. This can cut down on the amount of clutter in your graphics folder if you don't really need any specialized bar graphics for a particular trainer.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fh7yBwuGkUf4w53AGW0kp%2FAnimation2.gif?alt=media&#x26;token=9f5601d3-941c-4b91-8e03-0609d8e93775" alt="" width="375"><figcaption><p>Various trainer mugshots using non-specific bar graphics</p></figcaption></figure>

In addition, trainer mugshots will now also inherit any specific hues that have been set for a trainer in the `trainer_types.txt` PBS file. So you don't have to create duplicate images for different trainer classes if you made one with a custom hue set.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2FUfajvhis4hcnAWBBENPU%2FAnimation2.gif?alt=media&#x26;token=610d4c53-9f83-42a3-9602-cd78ba939429" alt="" width="375"><figcaption><p>Trainer mugshots inherit any hues set for the trainer sprite.</p></figcaption></figure>

***

<mark style="background-color:orange;">**Vs. Champion Transition**</mark>

This plugin also adds a brand new mugshot transition that is inspired by the Champion battle transition used in *Pokemon Black & White 2* vs Champion Iris. In these games, a unique full-body shot of both trainers is displayed.

<figure><img src="https://2153694798-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FvzqYxbzoSOVtGkOgfRUQ%2Fuploads%2Fk66AkH0dJsbGGxVO3ite%2FAnimation.gif?alt=media&#x26;token=8700ece3-185d-4188-a5cb-452e650e94b6" alt="" width="563"><figcaption><p>Champion Iris' battle transition, replicated from Pokemon B2W2</p></figcaption></figure>

By default, the only trainer types which have a full-body sprite like these are Nate/Rosa for the player, and Champion Iris. But if you would like to include your own custom sprites to use for this transition, you may add them to the `Graphics/Transitions` folder. The graphics for each trainer must be named `champion_vs_` followed by the ID of that particular trainer type. For example, `champion_vs_POKEMONTRAINER_Nate`.

Page 120:

# Intros: Mid-Battle Scripting

This plugin adds various new keys to be used by the Deluxe Battle Kit's mid-battle scripting functionality.

***

<mark style="background-color:orange;">**Command Keys**</mark>

These are keys which trigger a trainer sprite's intro animation to replay before or after midbattle speech.

<details>

<summary><mark style="background-color:blue;"><strong>"setAnimSpeaker"</strong></mark><strong> ⇒ </strong><mark style="background-color:yellow;"><strong>Integer, Symbol, or Array</strong></mark></summary>

This command functions identically to the <mark style="background-color:blue;">"setSpeaker"</mark> command found in the Mid-Battle Scripting section of the base guide of the Deluxe Battle Kit, so please refer to that command for everything you need to know in using this command.

The only difference between the two is that using <mark style="background-color:blue;">"setSpeaker"</mark> will slide a still sprite of a trainer on screen to speak, while <mark style="background-color:blue;">"setAnimSpeaker"</mark> will slide a speaker on screen who will play their intro animation prior to speaking.

Note that if you set this as an array, you can add `:Reversed` as the last entry in the array to make the speaker's animation play in reverse prior to speaking. Depending on the animation, this may allow you to suggest different things prior to the trainer speaking.

</details>

<details>

<summary><mark style="background-color:blue;"><strong>"hideAnimSpeaker"</strong></mark><strong> ⇒ </strong><mark style="background-color:yellow;"><strong>Boolean or Symbol</strong></mark></summary>

This can be used if you want to force a trainer to slide off screen after their speech ends, but you want them to play their intro animation first before leaving. To do this, you simply have to set this command to `true`.

However, if you instead set this to `:Reversed`, the trainer will play their intro animation in reverse prior to sliding off screen. Depending on the animation, this may allow you to suggest different things prior to the trainer leaving.

</details>

***

<mark style="background-color:orange;">**Hardcoding**</mark>

Here's a list of methods and/or properties that you might want to reference when hardcoding a midbattle script, since this plugin adds a lot of new custom content which you may need to call on to make certain things happen:

<details>

<summary><strong>GameData::TrainerType</strong></summary>

* `trainer_sprite_scale`\
  Returns the amount of scaling applied to the front sprite of this trainer type.<br>
* `trainer_sprite_hue`\
  Returns the hue value applied to this trainer type's sprites.<br>
* `shows_shadow?`\
  Returns true if this trainer type should display a shadow during battle.

</details>

<details>

<summary><strong>Battle::Scene</strong></summary>

* `pbShowAnimatedSpeaker(1, nil, reversed = false, id = nil)`\
  Used to slide a trainer sprite on screen and play their intro animation prior to speaking. The first two arguments should probably always be `1` and `nil`, as there's no reason to need to set these differently in the majority of cases. The `reversed` argument is false by default, but you may set this to `true` if you want the trainer's intro animation to play backwards. The `id` argument can be the index of the battler who's owner you want to slide on screen to speak, or an ID of a particular trainer type that you want to appear on screen. If no ID is set, the owner of the first battler on the foe's side will default as the speaker.<br>
* `pbHideAnimatedSpeaker(reversed = false)`\
  Used to animate a speaker's on-screen sprite after speaking and then sliding them off screen after their animation completes. You can set `reversed` to `true` if you want this animation to play backwards before leaving the screen. By default, this value is set to false.

</details>
