# ZUI Addon Changelog  
_Last updated: 2025-06-28_
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