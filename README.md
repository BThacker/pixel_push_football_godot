# pixel_push_football_godot
Scripts from the production version of pixel push football (android , ios) 
This code is not *good* or even well written in a lot of cases.  
What this code is, is functional. I wrote the main game in less than 5 months.  
This is a testament to how easy Godot and GDscript are to pick up, but I by no means applied 
best practices or even good practices in a lot of cases.   

With that said the game logic is very stable and almost entirely bug free from a logic standpoint. 
When designing a game for younger children / young adults, accounting for literally any and every button press becomes challenging as a single dev without a QA team. 

As I built this game as a project to learn godot, my knowledge and style changed multiple times throughout the development cycle.
My later games are much more "defined" when it comes to style and technique, this was very experimental in various situations and did not take full advantage of all that GODOT and GDSCript had to offer. I would find myself learning new techniques and apply it going forward, but leaving the stable code in place from before. 

This is mostly just an example of how much code can be involved in even a small game release. 

I will go back and try to add more comments and information on the code if time allows. I noticed after reading some of the code again that some of the comments aren't still relevant but as it sits this is the exact logic in the 2.20 release. 

You can't do anything functional from this code as the project files and assets are missing, but I think someone
might still get some value from it. 


Pixel Push Football can be downloaded from:
https://apps.apple.com/us/app/pixel-push-football/id1495268406
https://play.google.com/store/apps/details?id=io.bltinteractive.pixelpushfootball&hl=en_US&gl=US


# reference 
main.gd = main game controller and logic  
game_event_control.gd = giant case switch I used to try and organize common events in the game  
menu_control.gd = I had no idea how to do UI so this is ridiculous and bloated (but functional)  
rubick.gd = the AI for the computer  
tournament.gd - Entirety of the tournament mode, this was added as a suggestion from a review after the game launched  

