# ClearCodeTutorials


Godot Valley tutorial mash up. 
Started with farming tutorial from the Ultimate Godot Tutorial and adapted the Godot Valley tutorial to it.

If anyone stumbles on this, these issues are from my own learning path and should not reflect on the tutorial I am following:

THERE ARE ISSUES THAT I NEED TO CORRECT.  WHEN CREATING THIS REPOSITORY THE GRAPHICS FOLDER ENDED UP AS GRAPHICS/CHARACTERS AND ALL THE OTHER FOLDERS UNDER GRAPHICS GOT STUCK UNDER CHARACTERS. WHEN DOWNLOADING, MOVE ALL THE FOLDERS UNDER CHARACTERS UP ONE LEVEL TO GRAPHICS.

DIFFERENCES NOTED BETWEEN VERSIONS:

Character animation frames updated to reflect Godot Valley character.

No global enums or data files. These enums are created within each associated file, such as plant.gd (I did expand the Globals folder though)

Changed the physics layer on terrain from the water tile to the edges of the grass tiles.

No resource node used.  This requires another signal to be connected using emit_signal("signalName") instead of emit_changed("signalName), and connected to the game script in a standard way.

Instead of a flash sprite that can be utilized for several things, I stayed with the flash shader for the tree and blobs.  No plant flash right now.

Blob hit does not need the tool enum for ax or sword.

Took an idea for random weather from the Udemy course, adapted it to randomly change the forecast and update weather.

Trying to get the blobs to attack the plants without the plant resource was tricky.  I probably have way too many death/dying signals at this point, and I'm not entirely sure how I got it to work, but it works.  In order to get the plant info boxes to update in real time without a level_reset(), I called plant_info_container.update_all() in the game _process loop.

In the collision layers, I have terrain, player, plants, enemies, and characters.  When I got to the raycast section, it was needed to help separate out the interactions

CURRENT ISSUES WORKING:

HOUSE WALL TILEMAP IS NOT APPLYING CORRECTLY

The cat glitches out when interacting from some sides

There is currently an animation for seed that is activated with the spacebar, and the same animation when you plant a seed with "F".  This redundancy needs to be reconciled.  Plan to get rid of "F" plant action and just have planting as a regular action.  Hopefully this will simplify future game controller integration?

Reworking blobs. Blobs will spawn on top of the same spawn point.  Trying to figure out logic to prevent that.

Discovered that apples reappear over a stump after a certain time, and don't always go back to if partially picked (unless it added a third in the same place).

If a plant is placed on an already watered spot, the water spot goes away.  Not a huge issue because the sprinkler will recover, just a glitch.




