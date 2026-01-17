# ClearCodeTutorials


Godot Valley tutorial mash up. 
Started with farming tutorial from the Ultimate Godot Tutorial and adapted the Godot Valley tutorial to it.

If anyone stumbles on this, these issues are from my own learning path and should not reflect on the tutorial I am following:

THERE ARE A COUPLE ISSUES THAT I WILL NEED TO CORRECT.  FIRST, THE TV AND BED SCENES NEED TO BE ADDED TO A CHARACTERS FOLDER IN THE SCENES FOLDER. SECOND, WHEN CREATING THIS REPOSITORY THE GRAPHICS FOLDER ENDED UP AS GRAPHICS/CHARACTERS AND ALL THE OTHER FOLDERS UNDER GRAPHICS GOT STUCK UNDER CHARACTERS. WHEN DOWNLOADING, MOVE ALL THE FOLDERS UNDER CHARACTERS UP ONE LEVEL TO GRAPHICS. TV AND BED SCRIPTS ARE MISSING OR BROKEN.

Differences noted betweeen the two additions:
Character animation frames updated to reflect Godot Valley character.
No global enums or data files. These enums are created within each associated file, such as plant.gd (I did expand the Globals folder though)
Changed the physics layer on terrain from the water tile to the edges of the grass tiles.
No resource node used.  This requires another signal to be connected using emit_signal("signalName") instead of emit_changed("signalName), and connected to the game script in a standard way.
Instead of a flash sprite that can be utilized for several things, I stayed with the flash shader for the tree and blobs.  No plant flash right now.
Took an idea for random weather from the Udemy course, adapted it to randomly change the forecast and update weather.

Current issues working:
HOUSE WALL TILEMAP IS NOT APPLYING CORRECTLY
There is currently an animation for seed that is activated with the spacebar, and the same animation when you plant a seed with "F".  This redundancy needs to be reconciled.  Plan to get rid of "F" plant action and just have planting as a regular action.  Hopefully this will simplify future game controller integration?
The blobs were created to attack the player.  Oops. The blob code will need to be totally reworked.  
