-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require ("storyboard")
local gameNetwork = require ("gameNetwork")
_G.loggedIntoGC = false

-- Hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- load title.lua
storyboard.gotoScene("title (2)")

_G.Main, Tutorial, Sound, Slide, Slide2, Easy, Medium, Hard, Easy2, Medium2, Hard2, Tutorial2, Tutorial3, Powerups, Extras, Themes = 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
_G.CurrentTile = Main
_G.SoundFX = true
_G.SoundMusic = true
_G.isClassy,isClassic = 0,1
_G.PreviousScene = 3
-- Themes
_G.Normal, WornOutTheme, PencilDrawn, BlackOut, MinimalTheme = 0,1,2,3,4
_G.CurrentTheme = Normal
-- Extras
_G.Concrete = 0
_G.Speed15, Speed2 = 1,2
_G.CurrentSpeed = Normal
_G.Fancy, Classy, Ancient, Pixel, WornOut, Element, Minimal, Japanese = 1,2,3,4,5,6,7,8
_G.CurrentBlocks = Normal
-- PowerUps
_G.StopTimeToggle, BombToggle, RainbowToggle, BonusToggle = 0,0,0,0
_G.Free = 1
-- Whats Purchased?
-- Extras
_G.haveConcrete, haveSpeed15, haveSpeed2, haveFancy, haveClassy, haveAncient, havePixel, haveWornOut, haveElement, haveMinimal, haveJapanese = 0,0,0,0,0,0,0,0,0,0,0
-- Powerups
_G.haveStopTimeToggle, haveBombToggle, haveRainbowToggle, haveBonusToggle = 0,0,0,0
-- Themes
_G.haveWornOutTheme, havePencilDrawn, haveBlackOut, haveMinimalTheme = 0,0,0,0
_G.Version = "Bustin_Blocks_Beta 0.9.3"

--[[ How data file is organized.
- Free or paid
- Points
- PurchasedStuff
- Currently Selected Theme
- Currently Selected Block Theme
- Currently Selected Speed
- Currently Selected Powerups & Concrete
--]]
