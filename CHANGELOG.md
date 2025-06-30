


# ZUI Addon Changelog  
_Last updated: 2025-06-28_
___
## 1. Initial system created  
This is the phase where I build stuff, hate it, and rebuild it. There is way too much to enumerate, here are the highlights.

#### 1.1 Proof of concept for minimap formatting

#### 1.2 Proof of concept for making pretty rectangles, ended up changing the scope of the project adding this idea of "anchors." Not an original idea I know lol.

#### 1.3 Anchored the chat frame to one side, and details to the other
* Struggled to get the frames to anchor when I wanted, made a debug ui so I could change the anchor dims on the fly

#### 1.4 Added a settings panel, basically the first full rewrite

#### 1.5 Learned what namespaces were, basically another full rewrite
* Then I learned that I was leaving rogue frames and exposed globals literally everywhere, more rewrite...
* I also finally established a scheme initialization via triggers, `ADDON_LOADED == "ZUI"` for settings, `PLAYER_LOGIN` for everything else.

#### 1.6 Looked into the minimap formatting so it can be toggled. 
* It cant, not really. I wanted to avoid /reload, but you cant unhook a function, so /reload it is

#### 1.7 COMMENTS, so many comments. Also made `INDEX.md`


___
## 2. ZUI Launched
* Disabled debug, and removed erroneous debugging lines
* Reformatted file structure in preparation for direct to distributor pipeline