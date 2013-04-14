----------------------------------------------------------------------------------
--
-- Slide.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local gameNetwork = require("gameNetwork")
local scene = storyboard.newScene()
local Score = 0
local Multiplier = 1
local x = "Multiplier  x"
local MoveDelay = 2500
SpeedCount = 0
if(CurrentSpeed == Speed15)then
	SpeedMultiplier = .75
elseif(CurrentSpeed == Speed2)then
	SpeedMultiplier = .5
else
	SpeedMultiplier = 1
end
local function WriteAll()
	local path = system.pathForFile( "thesefools.wtf", system.DocumentsDirectory )
	local fh = io.open(path, "w")
	
	if(fh)then
		print("Writing data to file")
		-- Write Free
		fh:write(Free.." ")
		-- Write points
		fh:write(points.." ")
		-- Write whats purchased
		-- Extras
		fh:write(haveConcrete.." ")
		fh:write(haveSpeed15.." ")
		fh:write(haveSpeed2.." ")
		fh:write(haveFancy.." ")
		fh:write(haveClassy.." ")
		fh:write(haveAncient.." ")
		fh:write(havePixel.." ")
		fh:write(haveWornOut.." ")
		fh:write(haveElement.." ")
		fh:write(haveMinimal.." ")
		fh:write(haveJapanese.." ")
		-- Powerups
		fh:write(haveStopTimeToggle.." ")
		fh:write(haveBombToggle.." ")
		fh:write(haveRainbowToggle.." ")
		fh:write(haveBonusToggle.." ")
		-- Themes
		fh:write(haveWornOutTheme.." ")
		fh:write(havePencilDrawn.." ")
		fh:write(haveBlackOut.." ")
		fh:write(haveMinimalTheme.." ")
		-- Current Theme
		fh:write(CurrentTheme.." ")
		-- CurrentBlocks
		fh:write(CurrentBlocks.." ")
		-- Speed
		fh:write(CurrentSpeed.." ")
		-- Powerups
		fh:write(StopTimeToggle.." ")
		fh:write(BombToggle.." ")
		fh:write(RainbowToggle.." ")
		fh:write(BonusToggle.." ")
		fh:write(Concrete)
	else
		print("Error writing data")
	end
	-- Close the file reader.
	io.close(fh)
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	storyboard.removeScene("menu")
	PreviousScene = isClassic
	buttonshow = false
	gotomenu = false
	resume = false
	logoshow = true
	writescore = false
	gameover = false
	paused = false
	StopTime = false
	local group = self.view
	local borderheight = 90
	local slotwidth = 100
	local slotheight = 100
	None, Black, Bomb, Time, Rainbow, RedBonus, GreenBonus, BlueBonus, YellowBonus, Red, Green, Blue, Yellow = 0,1,2,3,4,5,6,7,8,9,10,11,12
			
	
---------------------
-- Set difficulty
---------------------
	if(CurrentTile == Easy2)then
		difficulty = Green
	elseif(CurrentTile == Medium2)then
		difficulty = Blue
	elseif(CurrentTile == Hard2)then
		difficulty = Yellow
	end
	
--------------------
-- Load Sounds
--------------------
	
	-- If another app/iPod is playing background music, then allow that music to continue playing
	if audio.getSessionProperty( audio.OtherAudioIsPlaying  ) == 1 then 
		audio.setSessionProperty(audio.MixMode, audio.AmbientMixMode)
	end
	
	if(SoundMusic == true)then
		-- Music
		local Selection = math.random(1,4)
		if(Selection == 1)then
			Punos = audio.loadStream("Music 1.mp3")
		elseif(Selection == 2)then
			Punos = audio.loadStream("Music 2.mp3")
		elseif(Selection == 3)then
			Punos = audio.loadStream("Music 3.mp3")
		elseif(Selection == 4)then
			Punos = audio.loadStream("Music 4.mp3")
		end
		audio.play(Punos,{loops = -1})
	end	
	
	if(SoundFX == true)then
		-- Misc Game sounds
		pointSound = audio.loadSound("matchSound.mp3")
		failSound = audio.loadSound("errorSound1.mp3")
		Explosion = audio.loadSound("Explosion.mp3")
		SlowSound = audio.loadSound("SlowSound.mp3")
		FastSound = audio.loadSound("SlowSoundReverse.mp3")
	end
------------------------
-- End loading sounds
------------------------

--------------------
-- Load Images
--------------------
	
	if(CurrentTheme == Normal)then
		Background = display.newImage("Background.png",true)
	elseif(CurrentTheme == WornOutTheme)then
		Background = display.newImage("BackgroundWornout.png",true)
	elseif(CurrentTheme == PencilDrawn)then
		Background = display.newImage("BackgroundPencil.png",true)
	elseif(CurrentTheme == MinimalTheme)then
		Background = display.newImage("BackgroundMinimal.png",true)
	elseif(CurrentTheme == BlackOut)then
		Background = display.newImage("BackgroundBlack.png",true)
	end
	group:insert(Background)
	logo = display.newImage("PauseLogo.png",534,410)
	group:insert(logo)

	-- Score
	displayscore = display.newText(Score,50,22.5,nil,40)
	group:insert(displayscore)
	
	lives = 2 -- Holds data for lives
	ShowLife = {} -- display object for lives
	-- Draw positions for lives
	for i = 0,lives do
		ShowLife[i] = display.newImage("livesTwo.png",(display.contentWidth - 50*i - 50)-20,10) -- I don't remember what these values mean, but they work
		group:insert(ShowLife[i])
	end
	
-------------------------------
-- Load Block Colors Array
-------------------------------

	Colors = {} -- initial array
	for row = 0,7 do
		Colors[row] = {} -- add 2nd dimension 
		for column = 0,2 do
			Colors[row][column] = {} -- add 3rd dimension
			for color = 1,difficulty do 
				if(color == Red)then
					if(CurrentBlocks == Fancy)then
						Colors[row][column][color] = display.newImage("RedFancy.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Classy)then
						Colors[row][column][color] = display.newImage("RedClassy.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Ancient)then
						Colors[row][column][color] = display.newImage("RedAncient.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Pixel)then
						Colors[row][column][color] = display.newImage("RedPixel.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == WornOut)then
						Colors[row][column][color] = display.newImage("RedRock.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Element)then
						Colors[row][column][color] = display.newImage("RedElement.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Minimal)then
						Colors[row][column][color] = display.newImage("RedMinimal.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Japanese)then
						Colors[row][column][color] = display.newImage("RedJapanese.png",row*slotwidth,(column*slotheight) + borderheight)
					else
						Colors[row][column][color] = display.newImage("Red.png",row*slotwidth,(column*slotheight) + borderheight)
					end
				elseif(color == Green)then
					if(CurrentBlocks == Fancy)then
						Colors[row][column][color] = display.newImage("GreenFancy.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Classy)then
						Colors[row][column][color] = display.newImage("GreenClassy.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Ancient)then
						Colors[row][column][color] = display.newImage("GreenAncient.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Pixel)then
						Colors[row][column][color] = display.newImage("GreenPixel.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == WornOut)then
						Colors[row][column][color] = display.newImage("GreenRock.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Element)then
						Colors[row][column][color] = display.newImage("GreenElement.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Minimal)then
						Colors[row][column][color] = display.newImage("GreenMinimal.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Japanese)then
						Colors[row][column][color] = display.newImage("GreenJapanese.png",row*slotwidth,(column*slotheight) + borderheight)
					else
						Colors[row][column][color] = display.newImage("Green.png",row*slotwidth,(column*slotheight) + borderheight)
					end
				elseif(color == Blue)then
					if(CurrentBlocks == Fancy)then
						Colors[row][column][color] = display.newImage("BlueFancy.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Classy)then
						Colors[row][column][color] = display.newImage("BlueClassy.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Ancient)then
						Colors[row][column][color] = display.newImage("BlueAncient.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Pixel)then
						Colors[row][column][color] = display.newImage("BluePixel.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == WornOut)then
						Colors[row][column][color] = display.newImage("BlueRock.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Element)then
						Colors[row][column][color] = display.newImage("BlueElement.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Minimal)then
						Colors[row][column][color] = display.newImage("BlueMinimal.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Japanese)then
						Colors[row][column][color] = display.newImage("BlueJapanese.png",row*slotwidth,(column*slotheight) + borderheight)
					else
						Colors[row][column][color] = display.newImage("Blue.png",row*slotwidth,(column*slotheight) + borderheight)
					end
				elseif(color == Yellow)then
					if(CurrentBlocks == Fancy)then
						Colors[row][column][color] = display.newImage("YellowFancy.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Classy)then
						Colors[row][column][color] = display.newImage("YellowClassy.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Ancient)then
						Colors[row][column][color] = display.newImage("YellowAncient.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Pixel)then
						Colors[row][column][color] = display.newImage("YellowPixel.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == WornOut)then
						Colors[row][column][color] = display.newImage("YellowRock.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Element)then
						Colors[row][column][color] = display.newImage("YellowElement.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Minimal)then
						Colors[row][column][color] = display.newImage("YellowMinimal.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Japanese)then
						Colors[row][column][color] = display.newImage("YellowJapanese.png",row*slotwidth,(column*slotheight) + borderheight)
					else
						Colors[row][column][color] = display.newImage("Yellow.png",row*slotwidth,(column*slotheight) + borderheight)
					end
				elseif(color == Black)then
					if(CurrentBlocks == Fancy)then
						Colors[row][column][color] = display.newImage("BlackFancy.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Classy)then
						Colors[row][column][color] = display.newImage("BlackClassy.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Ancient)then
						Colors[row][column][color] = display.newImage("BlackAncient.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Pixel)then
						Colors[row][column][color] = display.newImage("BlackPixel.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == WornOut)then
						Colors[row][column][color] = display.newImage("BlackRock.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Element)then
						Colors[row][column][color] = display.newImage("BlackElement.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Minimal)then
						Colors[row][column][color] = display.newImage("BlackMinimal.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Japanese)then
						Colors[row][column][color] = display.newImage("BlackJapanese.png",row*slotwidth,(column*slotheight) + borderheight)
					else
						Colors[row][column][color] = display.newImage("Black.png",row*slotwidth,(column*slotheight) + borderheight)
					end
				elseif(color == Bomb)then
					if(CurrentBlocks == Fancy)then
						Colors[row][column][color] = display.newImage("BombBlock.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Classy)then
						Colors[row][column][color] = display.newImage("BombBlockClassy.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Ancient)then
						Colors[row][column][color] = display.newImage("BombBlockAncient.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Pixel)then
						Colors[row][column][color] = display.newImage("BombBlockPixel.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == WornOut)then
						Colors[row][column][color] = display.newImage("BombBlockRock.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Element)then
						Colors[row][column][color] = display.newImage("BombBlockElement.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Minimal)then
						Colors[row][column][color] = display.newImage("BombBlockMinimal.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Japanese)then
						Colors[row][column][color] = display.newImage("BombBlockJapanese.png",row*slotwidth,(column*slotheight) + borderheight)
					else
						Colors[row][column][color] = display.newImage("BombBlock.png",row*slotwidth,(column*slotheight) + borderheight)
					end
				elseif(color == Time)then
					if(CurrentBlocks == Fancy)then
						Colors[row][column][color] = display.newImage("TimeBlock.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Classy)then
						Colors[row][column][color] = display.newImage("TimeBlockClassy.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Ancient)then
						Colors[row][column][color] = display.newImage("TimeBlockAncient.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Pixel)then
						Colors[row][column][color] = display.newImage("TimeBlockPixel.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == WornOut)then
						Colors[row][column][color] = display.newImage("TimeBlockRock.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Element)then
						Colors[row][column][color] = display.newImage("TimeBlockElement.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Minimal)then
						Colors[row][column][color] = display.newImage("TimeBlockMinimal.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Japanese)then
						Colors[row][column][color] = display.newImage("TimeBlockJapanese.png",row*slotwidth,(column*slotheight) + borderheight)
					else
						Colors[row][column][color] = display.newImage("TimeBlock.png",row*slotwidth,(column*slotheight) + borderheight)
					end
				elseif(color == Rainbow)then
					if(CurrentBlocks == Fancy)then
						Colors[row][column][color] = display.newImage("RainbowBlock.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Classy)then
						Colors[row][column][color] = display.newImage("RainbowBlockClassy.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Ancient)then
						Colors[row][column][color] = display.newImage("RainbowBlockAncient.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Pixel)then
						Colors[row][column][color] = display.newImage("RainbowBlockPixel.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == WornOut)then
						Colors[row][column][color] = display.newImage("RainbowBlockRock.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Element)then
						Colors[row][column][color] = display.newImage("RainbowBlockElement.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Minimal)then
						Colors[row][column][color] = display.newImage("RainbowBlockMinimal.png",row*slotwidth,(column*slotheight) + borderheight)
					elseif(CurrentBlocks == Japanese)then
						Colors[row][column][color] = display.newImage("RainbowBlockJapanese.png",row*slotwidth,(column*slotheight) + borderheight)
					else
						Colors[row][column][color] = display.newImage("RainbowBlock.png",row*slotwidth,(column*slotheight) + borderheight)
					end
				elseif(color == RedBonus)then
					Colors[row][column][color] = display.newImage("RedBonusGlow2.png",row*slotwidth,(column*slotheight) + borderheight)
				elseif(color == GreenBonus)then
					Colors[row][column][color] = display.newImage("GreenBonusGlow2.png",row*slotwidth,(column*slotheight) + borderheight)
				elseif(color == BlueBonus)then
					Colors[row][column][color] = display.newImage("BlueBonusGlow2.png",row*slotwidth,(column*slotheight) + borderheight)
				elseif(color == YellowBonus)then
					Colors[row][column][color] = display.newImage("YellowBonusGlow2.png",row*slotwidth,(column*slotheight) + borderheight)
				end
				Colors[row][column][color].isVisible = false
				group:insert(Colors[row][column][color])
			end
		end
	end
-------------------------
-- End Color Array
-------------------------

-------------------------
-- Create Data Array
-------------------------
	
	-- 2 dimensional array to hold data of slots
	data = {} 
	for row = 0,8 do
		data[row] = {}
		for column = 0,2 do
			data[row][column] = 0
		end
	end
	
----------------------------
-- End Create Data Array
----------------------------

----------------------
-- Generate first set
----------------------

	set = {}
	
	if(difficulty == Green)then
		for i = 0,5 do
			set[i] = Red
		end			
		for i = 6,11 do
			set[i] = Green
		end
		if(BonusToggle == 1)then
			if(math.random(1,100) <= 15)then
				set[0] = RedBonus
			end
			if(math.random(1,100) <= 15)then
				set[6] = GreenBonus
			end
		end
	elseif(difficulty == Blue)then
		for i = 0,3 do
			set[i] = Red
		end
		for i = 4,7 do
			set[i] = Green
		end
		for i = 8,11 do
			set[i] = Blue
		end
		if(BonusToggle == 1)then
			if(math.random(1,100) <= 15)then
				set[0] = RedBonus
			end
			if(math.random(1,100) <= 15)then
				set[4] = GreenBonus
			end
			if(math.random(1,100) <= 15)then
				set[8] = BlueBonus
			end
		end
	elseif(difficulty == Yellow)then
		for i = 0,2 do
			set[i] = Red
		end
		for i = 3,5 do
			set[i] = Green
		end
		for i = 6,8 do
			set[i] = Blue
		end
		for i = 9,11 do
			set[i] = Yellow
		end
		if(BonusToggle == 1)then
			if(math.random(1,100) <= 15)then
				set[0] = RedBonus
			end
			if(math.random(1,100) <= 15)then
				set[3] = GreenBonus
			end
			if(math.random(1,100) <= 15)then
				set[6] = BlueBonus
			end
			if(math.random(1,100) <= 15)then
				set[9] = YellowBonus
			end
		end
	end
	-- Chance to spawn a bomb
	if(BombToggle == 1)then
		if(math.random(1,100) <= 25)then
			set[7] = Bomb
		end
	end
	if(StopTimeToggle == 1)then
		if(math.random(1,100) <= 25)then
			set[1] = Time
		end
	end
	if(RainbowToggle == 1)then
		if(math.random(1,100) <= 25)then
			set[11] = Rainbow
		end
	end
	if(Concrete == 1)then
		if(math.random(1,100) <= 10)then
			set[2] = Black
		end
	end
	
	-- Match Box
	matchbox = display.newImage("matchBox.png",0,76) -- magic number that aligns the matchbox correctly
	Gameoverbg = display.newImage("gameoverBackground.png",-800,display.contentHeight*.3,true)
	Gameovertxt = display.newImage("gameoverText.png",800,display.contentHeight*.3,true)
	
	group:insert(matchbox)
	group:insert(Gameoverbg)
	group:insert(Gameovertxt)
	
	Menubutton = display.newImage("PauseMainMenuButton.png",40, 300)
	group:insert(Menubutton)
	Menubuttonpressed = display.newImage("PauseMainMenuButtonPressed.png",40,300)
	group:insert(Menubuttonpressed)
	Menubutton.x = display.contentWidth/2
	Menubuttonpressed.x = Menubutton.x
	Menubutton.isVisible = false
	Menubuttonpressed.isVisible = false
	
	-- pause buttons

	--PauseImage = display.newImage("PauseLogo.png",200,95)
	--PauseImage.isVisible = false
	--group:insert(--PauseImage)
	
	PauseResume = display.newImage("PauseResumeButton.png",40,200)
	group:insert(PauseResume)
	PauseResume.isVisible = false
	PauseResumePressed = display.newImage("PauseResumeButtonPressed.png",0,200)
	PauseResumePressed.isVisible = false
	group:insert(PauseResumePressed)
	--PauseResume.x = display.contentWidth/2
	PauseResumePressed.x = PauseResume.x
	
	PauseMenuButton = display.newImage("PauseMainMenuButton.png",40,300)
	PauseMenuButton.isVisible = false
	group:insert(PauseMenuButton)
	PauseMenuButtonPressed = display.newImage("PauseMainMenuButtonPressed.png",40,300)
	PauseMenuButtonPressed.isVisible = false
	group:insert(PauseMenuButtonPressed)
	--PauseMenuButton.x = display.contentWidth/2
	PauseMenuButtonPressed.x = PauseMenuButton.x
	
	function pause(event)
		if(paused == false)then
			paused = true
			audio.pause(Punos)
			media.playEventSound("ButtonClick.wav")
			--PauseImage.isVisible = true
			PauseResume.isVisible = true
			PauseMenuButton.isVisible = true
			print("Paused")
		end
	end
	logo:addEventListener("tap",pause)
	
	function pauseResume(event)
		if(event.phase == "began")then
			PauseResumePressed.isVisible = true
			media.playEventSound("ButtonClick.wav")
		end
		if(event.phase == "ended")then
			resume = true
		end
	end
	PauseResume:addEventListener("touch",pauseResume)
	
	function pauseMenu(event)
		if(event.phase == "began")then
			PauseMenuButtonPressed.isVisible = true
			media.playEventSound("ButtonClick.wav")
		elseif(event.phase == "ended")then
			CurrentTile = Main
			if(gameover == false)then
				local path = system.pathForFile( "thesefools.wtf", system.DocumentsDirectory )
				local fh = io.open(path, "r")
				Free = fh:read("*n")
				points = Score + fh:read("*n")
				WriteAll()
			end
			storyboard.gotoScene("menu")
		end
	end
	PauseMenuButton:addEventListener("touch",pauseMenu)
	
	Flare = display.newRect(0,0,display.contentWidth,display.contentHeight)
	Flare.alpha = 0
	
	function ConcreteEnabled(event)
		for row = 0,7 do
			for column = 0,3 do
				if(data[row][column] == Black)then
					data[row][column] = 0
				end
			end
		end
		timer.pause(ConcreteTimer)
	end
	ConcreteTimer = timer.performWithDelay(10000,ConcreteEnabled,0)
	timer.pause(ConcreteTimer)
end

-- create a function to handle all of the system events
local onSystem = function( event )
    if event.type == "applicationSuspend" then
        paused = true
		audio.pause(Punos)
		--PauseImage.isVisible = true
		PauseResume.isVisible = true
		PauseMenuButton.isVisible = true
		print("Paused")
    end
end
-- setup a system event listener
Runtime:addEventListener( "system", onSystem )

-- Called on user touch
local function touched(event)
	if(event.phase == "ended")then
		PauseResumePressed.isVisible = false
		PauseMenuButtonPressed.isVisible = false
	end
	if(gameover == false and paused == false)then
	-- If player begins touch
		if(event.phase == "began")then
		-- Create previous x and y positions
			xPrevious = math.floor(event.xStart/100)
			yPrevious = math.floor((event.yStart - 90)/100)
		elseif(event.phase == "moved")then
			newX = math.floor(event.x/100)
			newY = math.floor((event.y - 90)/100)
			changex = math.abs(newX - xPrevious)
			changey = math.abs(newY - yPrevious)
			if(newY > -1 and newY < 4)then
				-- If the previous touched square is not empty and is not the leftmost column
				if(data[xPrevious][yPrevious] ~= 0 and xPrevious ~= 0)then
					-- if the moved into square is empty and is not the leftmost column or rightmost column
					if(data[newX][newY] == 0 and newX ~= 0 and newX ~= 8 and newY ~= 3)then
					if(changex <= 1 and changey <= 1)then
						-- move the data from the previous square into the new square
						data[newX][newY] = data[xPrevious][yPrevious]
						-- Set previous square to empty
						data[xPrevious][yPrevious] = 0
						xPrevious = math.floor(event.x/100)
						yPrevious = math.floor((event.y - 90)/100)
						-- Set the new spot to visible
						Colors[newX][newY][data[newX][newY]].isVisible = true
						for color = 1,difficulty do
							Colors[xPrevious][yPrevious][color].isVisible = false
						end
					end
					end
				end
			end
		end
	end
end
Runtime:addEventListener("touch",touched)

-- Makes tapping powerups work.
local function tapping(event)
	tappedx = math.floor(event.x/100)
	tappedy = math.floor((event.y - 90)/100)
	if(data[tappedx][tappedy] == Bomb)then
		audio.play(Explosion)
		Flare.alpha = 1
		transition.to(Flare,{time = 1000,alpha = 0,oncomplete })
		for row = 0,8 do
			for column = 0,2 do
				if(data[row][column] ~= 0)then
					Score = (Score+1)
				end
				data[row][column] = 0
			end
		end
	end		
	if(data[tappedx][tappedy] == Time)then
		StopTime = true
		audio.pause(Punos)
		audio.play(SlowSound)
		timer.resume(TimeStopTimer)
		print("Stopped Time")
		data[tappedx][tappedy] = 0
	end
end
Runtime:addEventListener("tap",tapping)
local function TimeGo(event)
	audio.play(FastSound)
	timer.resume(MusicTimer)
	timer.pause(TimeStopTimer)
end
TimeStopTimer = timer.performWithDelay(5000,TimeGo,0)
timer.pause(TimeStopTimer)
local function ContinueMusic(event)
	StopTime = false
	audio.resume(Punos)
	timer.pause(MusicTimer)
end
MusicTimer = timer.performWithDelay(1500,ContinueMusic,0)
timer.pause(MusicTimer)

-- Called every frame
local function frame(event)
	displayscore.text = Score
	if(resume == true)then
		--PauseImage.isVisible = false
		PauseResume.isVisible = false
		PauseResumePressed.isVisible = false
		PauseMenuButton.isVisible = false
		audio.resume(Punos)
		paused = false
		resume = false
	end
	-- If its time to increase the game speed
	if(moved == false and math.floor(Score/10) > SpeedCount)then
		SpeedCount = SpeedCount + 1
		MoveDelay = (2500 - (100*SpeedCount))
		Delay._delay = MoveDelay*SpeedMultiplier
		moved = true
	end
	
	if(gotomenu == true)then
		CurrentTile = Main
		if(gameover == false)then
			local path = system.pathForFile( "thesefools.wtf", system.DocumentsDirectory )
			local fh = io.open(path, "r")
			Free = fh:read("*n")
			points = Score + fh:read("*n")
			WriteAll()
		end
		storyboard.gotoScene("menu")
	end
	
	-- If game is over
	if(lives <= -1)then
		gameover = true
		-- and Game Over screen isn't positioned
		-- Position Stripe Background
		if(Gameoverbg.x < 400)then
			Gameoverbg.x = Gameoverbg.x + 40
		end
		-- Position Text Foreground
		if(Gameovertxt.x > 400)then
				Gameovertxt.x = Gameovertxt.x - 40
		end
		if(buttonshow == false)then
			Menubutton.isVisible = true
			buttonshow = true
		end
		if(logoshow == true) then
			logo.isVisible = false
			logoshow = false
		end
		local function MenuPress(event)
			if(event.phase == "began")then
				Menubuttonpressed.isVisible = true
			elseif(event.phase == "ended")then
				Menubutton.isVisible = true
				Menubuttonpressed.isVisible = false
				gotomenu = true
			end
		end
		Menubutton:addEventListener("touch",MenuPress)
		if(writescore == false)then
			local path = system.pathForFile( "thesefools.wtf", system.DocumentsDirectory )
			local fh = io.open(path, "r")
			Free = fh:read("*n")
			points = Score + fh:read("*n")
			WriteAll()
			writescore = true
			if(loggedIntoGC == true)then
				gameNetwork.request("setHighScore", 
					{
						localPlayerScore = {category = "BustinBlocksHighScores", value = Score}
					})
			end
		end			
	end
	-- set all visibility to false
	for row = 0,7 do
		for column = 0,2 do
			for color = 1,difficulty  do
				if(Colors[row][column][color].isVisible == true)then
					Colors[row][column][color].isVisible = false
				end
			end
		end
	end
	
	-- Refresh visible colors
	
	for row = 0,7 do
		for column = 0,2 do
			for color = 1,difficulty do
				if(data[row][column] == color)then
					Colors[row][column][color].isVisible = true
				end
			end
		end
	end
end
Runtime:addEventListener("enterFrame", frame)

-- Called every cube movement interval
local function interval(event)
-- If player still has lives
	if (gameover == false and paused == false and StopTime == false)then
	
	-- Spawn blocks	
	
	-- check for an empty array
	empty = true
	for i = 0,11 do
		if(set[i] ~= 0)then
			empty = false
		end
	end
	-- if block array is empty, fill it up again
	if(empty == true)then
		if(difficulty == Green)then
			for i = 0,5 do
				set[i] = Red
			end			
			for i = 6,11 do
				set[i] = Green
			end
			if(BonusToggle == 1)then
				if(math.random(1,100) <= 15)then
					set[0] = RedBonus
				end
				if(math.random(1,100) <= 15)then
					set[6] = GreenBonus
				end
			end
		elseif(difficulty == Blue)then
			for i = 0,3 do
				set[i] = Red
			end
			for i = 4,7 do
				set[i] = Green
			end
			for i = 8,11 do
				set[i] = Blue
			end
			if(BonusToggle == 1)then
				if(math.random(1,100) <= 15)then
					set[0] = RedBonus
				end
				if(math.random(1,100) <= 15)then
					set[4] = GreenBonus
				end
				if(math.random(1,100) <= 15)then
					set[8] = BlueBonus
				end
			end
		elseif(difficulty == Yellow)then
			for i = 0,2 do
				set[i] = Red
			end
			for i = 3,5 do
				set[i] = Green
			end
			for i = 6,8 do
				set[i] = Blue
			end
			for i = 9,11 do
				set[i] = Yellow
			end
			if(BonusToggle == 1)then
				if(math.random(1,100) <= 15)then
					set[0] = RedBonus
				end
				if(math.random(1,100) <= 15)then
					set[3] = GreenBonus
				end
				if(math.random(1,100) <= 15)then
					set[6] = BlueBonus
				end
				if(math.random(1,100) <= 15)then
					set[9] = YellowBonus
				end
			end
		end
		-- Chance to spawn a bomb
		if(BombToggle == 1)then
			if(math.random(1,100) <= 25)then
				set[7] = Bomb
			end
		end
		if(StopTimeToggle == 1)then
			if(math.random(1,100) <= 25)then
				set[1] = Time
			end
		end
		if(RainbowToggle == 1)then
			if(math.random(1,100) <= 25)then
				set[11] = Rainbow
			end
		end
		if(Concrete == 1)then
			if(math.random(1,100) <= 10)then
				set[2] = Black
			end
		end
	end
	
	-- Pick which block to spawn a block on
	selection = math.random(1,3)
	-- pick if one or two blocks will be spawned.
	if(math.random(1,2) == 2)then
	-- If 2 blocks are to be spawned.
		Color1 = None
		Color2 = None
		while(Color1 == None)do
			number = math.random(0,11)
			Color1 = set[number]
			set[number] = 0
		end
		
		-- check for an empty array
		empty = true
		for i = 0,11 do
			if(set[i] ~= 0)then
				empty = false
			end
		end
		
		-- if block array is empty, fill it up again
		if(empty == true)then
			if(difficulty == Green)then
				for i = 0,5 do
					set[i] = Red
				end			
				for i = 6,11 do
					set[i] = Green
				end
			if(BonusToggle == 1)then
				if(math.random(1,100) <= 15)then
					set[0] = RedBonus
				end
				if(math.random(1,100) <= 15)then
					set[6] = GreenBonus
				end
			end
		elseif(difficulty == Blue)then
			for i = 0,3 do
				set[i] = Red
			end
			for i = 4,7 do
				set[i] = Green
			end
			for i = 8,11 do
				set[i] = Blue
			end
			if(BonusToggle == 1)then
				if(math.random(1,100) <= 15)then
					set[0] = RedBonus
				end
				if(math.random(1,100) <= 15)then
					set[4] = GreenBonus
				end
				if(math.random(1,100) <= 15)then
					set[8] = BlueBonus
				end
			end
		elseif(difficulty == Yellow)then
			for i = 0,2 do
				set[i] = Red
			end
			for i = 3,5 do
				set[i] = Green
			end
			for i = 6,8 do
				set[i] = Blue
			end
			for i = 9,11 do
				set[i] = Yellow
			end
			if(BonusToggle == 1)then
				if(math.random(1,100) <= 15)then
					set[0] = RedBonus
				end
				if(math.random(1,100) <= 15)then
					set[3] = GreenBonus
				end
				if(math.random(1,100) <= 15)then
					set[6] = BlueBonus
				end
				if(math.random(1,100) <= 15)then
					set[9] = YellowBonus
				end
			end
		end
		-- Chance to spawn a bomb
		if(BombToggle == 1)then
			if(math.random(1,100) <= 25)then
				set[7] = Bomb
			end
		end
		if(StopTimeToggle == 1)then
			if(math.random(1,100) <= 25)then
				set[1] = Time
			end
		end
		if(RainbowToggle == 1)then
			if(math.random(1,100) <= 25)then
				set[11] = Rainbow
			end
		end
		if(Concrete == 1)then
			if(math.random(1,100) <= 10)then
				set[2] = Black
			end
		end
	end
		
		while(Color2 == None)do
			number = math.random(0,11)
			Color2 = set[number]
			set[number] = 0
		end
		if(Color1 == Black)then
			timer.resume(ConcreteTimer)
		end
		if(Color2 == Black)then
			timer.resume(ConcreteTimer)
		end
		-- if its to be spawned on the top space.
		if(selection == 1)then
			data[8][0] = Color1
			data[8][1] = Color2
			
		elseif(selection == 2)then
			data[8][1] = Color1
			data[8][2] = Color2
			
		else
			data[8][2] = Color1
			data[8][0] = Color2
		end
	else
	-- if one is to be spawned
		Color1 = None
		
		while(Color1 == None)do
			number = math.random(0,11)
			Color1 = set[number]
			set[number] = 0
		end
		
		if(selection == 1)then
			data[8][0] = Color1
		elseif(selection == 2)then
			data[8][1] = Color1
		else
			data[8][2] = Color1
		end
	end
	-- Iterate over arrays and move left
		for row = 1,8 do
			for column = 0,2 do
				data[row-1][column] = data[row][column]
				data[row][column] = 0
				if(data[row-1][column] == nil)then
					data[row-1][column] = 0
				end
				if(data[row][column] == nil)then
					data[row][column] = 0
				end
			end
		end
		if(xPrevious ~= nil)then
			xPrevious = xPrevious - 1
		end
	
	-- Check Score Column 
	isMatch = true
	isBonus = false
	if(data[0][0] ~= 0 or data[0][1] ~= 0 or data[0][2] ~= 0)then
		if(data[0][0] ~= 0 and data[0][0] ~= RedBonus and data[0][0] ~= GreenBonus and data[0][0] ~= BlueBonus and data[0][0] ~= YellowBonus and data[0][0] ~= Rainbow)then
			check = data[0][0]
		elseif(data[0][1] ~= 0 and data[0][1] ~= RedBonus and data[0][1] ~= GreenBonus and data[0][1] ~= BlueBonus and data[0][1] ~= YellowBonus and data[0][1] ~= Rainbow)then
			check = data[0][1]
		elseif(data[0][2] ~= 0 and data[0][2] ~= RedBonus and data[0][2] ~= GreenBonus and data[0][2] ~= BlueBonus and data[0][2] ~= YellowBonus and data[0][2] ~= Rainbow)then
			check = data[0][2]
		else
			check = data[0][0]
		end
		for column = 0,2 do
			if(data[0][column] ~= check and data[0][column] ~= Rainbow and data[0][column] ~= (check - 4))then
				isMatch = false
			end
			if(data[0][column] == RedBonus or data[0][column] == GreenBonus or data[0][column] == BlueBonus or data[0][column] == YellowBonus)then
				isBonus = true
			end
			if(data[0][column] == 0)then
				isMatch = false
			end
		end
		if(isBonus == true and isMatch ==  true)then
			Score = Score + 8
			audio.play(pointSound)
			moved = false
		elseif(isMatch == true)then
			Score = Score + 5
			if(Multiplier < 5)then
				Multiplier = Multiplier + 1
			end
			audio.play(pointSound)
			moved = false
		elseif(isMatch == false)then
			-- If mismatched blocks
			if(lives >= 0)then
				audio.play(failSound)
				-- Clear the screen after lost life
				for i = 0,8 do
					for c = 0,2 do
						data[i][c] = 0
					end
				end
				-- turn a life invisible
				ShowLife[lives].isVisible = false
				-- subtract a life
				lives = lives - 1
				Multiplier = 1
			end
		end
		-- Update Score
		displayscore.text = Score
		-- Update Multiplier
		--displaymultiplier.text = Multiplier
	end
	end
	-- set all visibility to false
	for row = 0,7 do
		for column = 0,2 do
			for color = 1,difficulty  do
				if(Colors[row][column][color].isVisible == true)then
					Colors[row][column][color].isVisible = false
				end
			end
		end
	end
	
	-- Refresh visible colors
	
	for row = 0,7 do
		for column = 0,2 do
			for color = 1,difficulty do
				if(data[row][column] == color)then -- if color is red
					Colors[row][column][color].isVisible = true
				end
			end
		end
	end
end
Delay = timer.performWithDelay(MoveDelay*SpeedMultiplier,interval,0)
-- Changes timer delay: Delay._delay = 2000

local function handleLowMemory( event )
    print( "memory warning received!" )
end 
Runtime:addEventListener( "memoryWarning", handleLowMemory )

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	Runtime:removeEventListener("enterFrame",frame)
	Runtime:removeEventListener("touch",touched)
	Runtime:removeEventListener("memoryWarning",handleLowMemory)
	timer.cancel(Delay)
	audio.stop(Punos)
	audio.dispose(Punos)
	Punos = nil
	audio.dispose(pointSound)
	pointSound = nil
	audio.dispose(failSound)
	failSound = nil
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	
	-----------------------------------------------------------------------------
	
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )
-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )
-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )
-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )
---------------------------------------------------------------------------------
return scene