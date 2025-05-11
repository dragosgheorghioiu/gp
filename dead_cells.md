# Dead Cells Procedural Generation Presentation
Slide 2
- Un joc de actiune 2D dezvoltat de Motion Twin si Evil Empire si publicat de
Motion Twin, Dead Cells este disponibil pe toate platformele inclusiv pe PC,
Mac, Linux, console si mobile
- Este un rogue-lite cu numeroase elemente inspirate din genul de jocuri
metroidvania, gen renumit pentru lumile vaste si interconectate pe care acesta
le dispune

Slide 3
- The main problem was to decide between hand crafting and generation because
the metroidvania genre is known for handmade level designs
- First iterations of the game started as handmade, but they quickly realised
it was too much for the team

Slide 4
- The devs where scared of No Man's Sky and what happened to it "after recent
high profile procedural generation controversies" No Man's Sky release date -
August 9, 2016 First public build - May 10, 2017  

Slide 5
Used for three main things:
- easier for the devs to create more content
- the player should always be able to adapt to various situations
- replay value

Slide 6
- Spelunky was one of the main inspirations (some handmade level design ==
framework for the generation)
- The first version of the level generator took one week to make -> not so good
results, too chaotic, it would to try to generate the whole map
- A dev of the team tried to make in two weeks one thousand rooms -> good
results because they were made by hand
- The team decided to work on different types of rooms for one month instead on
working on the generator for one month

- One of the other inspirations was Left For Dead, the devs tried to have their
own verison of the AI Director system they wanted to give the player the feeling of having peaks and valleys

## Level generation algorithm
- The maps are always connected the same
- The rooms are mainly hand connected
- Each level is represented as a graph that is manually designed
- As explained by Sebastien Bernard, the algorithm works by brute forcing
    - each room has some entrances and some exits
    - will try to stick rooms at random until one that has a matching entrace
    fits

There are 6 steps:
1. The fixed elements are placed first(they are the same for every seed):
    - number of special rooms for each level (treasure, merchants)
    - how the levels are connected
    - where the progression keys are stored
2. The devs design a bunch of handmade rooms
    - used CastleDB to design these chunks which is an (open source static
    database and works like a any spreadsheet editor except that each sheet has
    a data model)
    - the rooms are stored with some additional information about them(number
    of exits and entrances and the type of room)
    - each room is part of a single biome: the rooms in the sewers are not the
    rooms used for the prison level
3. The concept graph of each level is created
    - schematic visual display of the layout of the tile inside a biome ->
    nodes
    - the first nodes placed are the entrance and the exit to the level
    - second step is to add the special room (treasure, merchants)
    - the combat and exploration tiles are added last
    - it represents a set of instruction for the level generator:
        - length of the level
        - nearest exit
        - number of special tiles
4. For each node, the algorithm tires a random room from the current biome and
testes to see if it complies:
    - location
    - number of entrances
    - type
5. The enemies are placed:
    - for each level there is decided a number of enemies per tile 
    - each type of enemy has constraints and parameters
    - stronger enemies may count for 10 tiles
    - some can be used only once per tile
6. The loot of the level (couldn' t find anything about this)

## Wave function collapse
- This approach was too slow for underpowered hardware like the Nintendo Switch
so it is safe to assume that the current version uses some kind of wave
function collapse according to this forum post -
https://deepnight.net/tutorial/the-level-design-of-dead-cells-a-hybrid-approach/
- Complex topic, will only scratch the surface
- The Github description says the following: "This program generates bitmaps
that are locally similar to the input bitmap."
- Local similarity can be defined by two conditions:
    - C1 The output should contain only those NxN patterns of pixels that are
    present in the input
    - Weak C2 Probability to meet a particular pattern in the output should be
    close to the density of such patterns in the input.
- WFC initializes output bitmap in a completely unobserved state, where each
pixel value is in superposition of colors of the input bitmap (so if the input
was black & white then the unobserved states are shown in different shades of
grey). The coefficients in these superpositions are real numbers, not complex
numbers, so it doesn't do the actual quantum mechanics, but it was inspired by
QM. Then the program goes into the observation-propagation cycle:
    - On each observation step an NxN region is chosen among the unobserved
    which has the lowest Shannon entropy. This region's state then collapses
    into a definite state according to its coefficients and the distribution of
    NxN patterns in the input. 
    - On each propagation step new information gained from the collapse on the
    previous step propagates through the output. After the collapse of a
    neighboring region, the valid patterns for adjacent regions are
    constrained. This happens because the neighboring regions must now fit with
    the newly collapsed pattern, respecting the constraints or rules defined by
    the input data.


## Bibliography 
How Dead Cells Cheated to Make the Game More Fun | War Stories | Ars Technica - https://www.youtube.com/watch?v=Uv5NwboDDhk Building the Level
Design of a procedurally generated Metroidvania: a hybrid -
https://deepnight.net/tutorial/the-level-design-of-dead-cells-a-hybrid-approach/
Let's talk about procedural generation - VLOG 2 - Mars 2017 -
https://www.youtube.com/watch?v=tyMrRW-Li_I
