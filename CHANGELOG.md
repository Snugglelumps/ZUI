# ZUI Addon Changelog
___
## 0. Initial system created  
This is the phase where I build stuff, hate it, and rebuild it. There is way too much to enumerate, here are the highlights.

#### 0.1 Proof of concept for minimap formatting

#### 0.2 Proof of concept for making pretty rectangles, ended up changing the scope of the project adding this idea of "anchors." Not an original idea I know lol.

#### 0.3 Anchored the chat frame to one side, and details to the other
* Struggled to get the frames to anchor when I wanted, made a debug ui so I could change the anchor dims on the fly

#### 0.4 Added a settings panel, basically the first full rewrite

#### 0.5 Learned what namespaces were, basically another full rewrite
* Then I learned that I was leaving rogue frames and exposed globals literally everywhere, more rewrite...
* I also finally established a scheme initialization via triggers, `ADDON_LOADED == "ZUI"` for settings, `PLAYER_LOGIN` for everything else.

#### 0.6 Looked into the minimap formatting so it can be toggled. 
* It cant, not really. I wanted to avoid /reload, but you cant unhook a function, so /reload it is

#### 0.7 COMMENTS, so many comments. Also made `INDEX.md`
* Then I deleted INDEX.md, I added it to the README.md

___
## 1. ~~ZUI~~ Launched
* Disabled debug, and removed erroneous debugging lines

## 1.1 SnugUI it is, ZUI was taken lol.
* Fixed a nil compare in the anchor dimension logic, improved the logic to bound based off UIParent dims.
* Moved global dropdown frames into namespace
* Completed namespace rename
* New table structure for namespace settings
* Added QOL panel and new quest item bar feature

## 1.2 
* Rebuilt minimap
* Ready for GitHub Actions

## 1.2 2 -- Electric Boogaloo a.k.a 1.23
* Rebuilt minimap, its... fine. The SnugUI map is cool, attempts at "rebuilding" the blizzard one failed. The idea here is that I can toggle between the "blizzard" map and my own without a reload. Technically it would toggle to a recreation of the blizzard map because blizzard only builds their map once, on /reload, the thing I'm trying to avoid. It fails, a lot. The issue is how blizzard parents their frames against the minimap cluster, it is NOT intuitive. Perhaps I will try again in the future, for now you're stuck with /reload to swap back to the blizzard minimap, soz.
* actually ready for GitHub Actions, messed up the yml (or I guess yaml, thanks John) literally 20 times, well 19, the last one worked.

## 1.24
* Fixed the yml again. I... somehow lost the changes that fixed it. It worked, in Github actions, I see the parameters in the log, yet, those parameters never existed as per Github's history, or my local history. I'm new at this, clearly.
* Annotations added for minimap.lua and init.lua
* reformatted DATA.md to DATA as per Johns "recommendation."

## 1.25
* Rebuild Tabwords. They are now frames, well buttons. We now just iterate over the tabs on each hook, make a frame for each tab, reuse when we can. Those frames hold all of our scripting and text.