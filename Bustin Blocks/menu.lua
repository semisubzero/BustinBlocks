----------------------------------------------------------------------------------
--
-- menu.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard")
store = require("store")
local gameNetwork = require("gameNetwork")
local scene = storyboard.newScene()
local points = 0

-- File reading and writing functions
-- Write all data to file
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

-- called after the "init" request has completed
function initCallback( event )
    if event.data then
        loggedIntoGC = true
    else
        loggedIntoGC = false
        native.showAlert( "Failed logging in to gamecenter", "Check your internet connection", { "OK" } )
    end
end

onSystem = function( event )
    if(event.type == "applicationSuspend")then
		print("suspended")

	end

	if(event.type == "applicationStart")then
		gameNetwork.init( "gamecenter", initCallback )
        return true
    end
end
Runtime:addEventListener("system",onSystem)

gameNetwork.init("gamecenter",initCallback)
-- Read all data from file
function ReadAll()
	local path = system.pathForFile( "thesefools.wtf", system.DocumentsDirectory )
	local fh = io.open(path, "r")
	
	--Read if free
	Free = fh:read("*n")
	-- Read points
	points = fh:read("*n")
	-- Read whats purchased
	-- Extras
	haveConcrete = fh:read("*n")
	haveSpeed15 = fh:read("*n")
	haveSpeed2 = fh:read("*n")
	haveFancy = fh:read("*n")
	haveClassy = fh:read("*n")
	haveAncient = fh:read("*n")
	havePixel = fh:read("*n")
	haveWornOut = fh:read("*n")
	haveElement = fh:read("*n")
	haveMinimal = fh:read("*n")
	haveJapanese = fh:read("*n")
	-- Powerups
	haveStopTimeToggle = fh:read("*n")
	haveBombToggle = fh:read("*n")
	haveRainbowToggle = fh:read("*n")
	haveBonusToggle = fh:read("*n")
	-- Themes
	haveWornOutTheme = fh:read("*n")
	havePencilDrawn = fh:read("*n")
	haveBlackOut = fh:read("*n")
	haveMinimalTheme = fh:read("*n")
	-- CurrentTheme
	CurrentTheme = fh:read("*n")
	-- CurrentBlocks
	CurrentBlocks = fh:read("*n")
	-- Speed
	CurrentSpeed = fh:read("*n")
	-- Powerups
	StopTimeToggle = fh:read("*n")
	BombToggle = fh:read("*n")
	RainbowToggle = fh:read("*n")
	BonusToggle = fh:read("*n")
	Concrete = fh:read("*n")
	
	-- Close the file reader
	io.close(fh)
end

-- Initialize the store and load products
	function loadProductsCallBack(event)
		print("Showing products", #event.products)
		for i=1,#event.products do
			local currentItem = event.products[i]
			print(currentItem.title)
			print(currentItem.description)
			print(currentItem.price)
			print(currentItem.productIdentifier)
		end
		print("Showing invalid products",#event.invalidProducts)

		for i = 1,#event.products do
			print(event.invalidProducts[i])
		end
	end

	arrayOfProductIdentifiers = 
	{
		"com.hazardsoftware.BustinBlocks.BuyPoints"
	}
	store.loadProducts(arrayOfProductIdentifiers,loadProductsCallBack)

	function transactionCallback( event )
        local transaction = event.transaction
        if transaction.state == "purchased" then
        		points = points + 3000
				WriteAll()
                native.showAlert("Success!","Transaction Successful!",{"Woo!"})
 
        elseif  transaction.state == "restored" then
        		native.showAlert("Restore","Restoring previous purchase",{"ok"})
                print("Transaction restored (from previous session)")
                print("productIdentifier", transaction.productIdentifier)
                print("receipt", transaction.receipt)
                print("transactionIdentifier", transaction.identifier)
                print("date", transaction.date)
                print("originalReceipt", transaction.originalReceipt)
                print("originalTransactionIdentifier", transaction.originalIdentifier)
                print("originalDate", transaction.originalDate)
 
        elseif transaction.state == "cancelled" then
                print("User cancelled transaction")
                native.showAlert("Failed","Transaction cancelled",{"ok"})
 
        elseif transaction.state == "failed" then
                print("Transaction failed, type:", transaction.errorType, transaction.errorString)
                native.showAlert(transaction.errorString,transaction.errorType,{"Darn"})
 
        else
                print("unknown event")
                native.showAlert("!?","Unknown event",{"Ok"})
        end
 
        -- Once we are done with a transaction, call this to tell the store
        -- we are done with the transaction.
        -- If you are providing downloadable content, wait to call this until
        -- after the download completes.
        store.finishTransaction( transaction )
	end
 
	store.init( transactionCallback )

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
	
	PurchasePressed = false
	EnabledPressed = false
	DisabledPressed = false
	Cost = 0
	StoreTile = 0
	ammount = 0
	PurchaseSound = audio.loadSound("PurchaseSound.wav")
	if(PreviousScene == 3)then
		storyboard.removeScene("title")
	elseif(PreviousScene == isClassy)then
		storyboard.purgeScene("classy")
		storyboard.removeScene("classy")
	elseif(PreviousScene == isClassic)then
		storyboard.purgeScene("slide")
		storyboard.removeScene("slide")
		storyboard.removeScene("slide")
	end
-----------------------
-- Read data file
-----------------------
	
	local path = system.pathForFile( "thesefools.wtf", system.DocumentsDirectory )
	local fh = io.open(path, "r")
	if(fh)then
		print("File opened!")
		io.close(fh)
		ReadAll()
	else
		print("File not found, attmpting to create a new one")
		WriteAll()
	end

-----------------------
-- Load Images
-----------------------

-- Load Background Tiles
	Background = {}
	
	Background[0] = display.newImage("background1.png",-display.contentWidth*1.5,0,true)
	Background[1] = display.newImage("background2.png",0,0,true)
	Background[2] = display.newImage("background3.png",display.contentWidth*1.5,0,true)
	--Background[3] = display.newImage("background4.png",display.contentWidth*3,0,true)
	
	group:insert(Background[0])
	group:insert(Background[1])
	group:insert(Background[2])
	--group:insert(Background[3])
	
-- End load Backgrounds
	
-- Load Menu Tile Images

	MenuTile = {}
	MenuTile[Main] = display.newImage("Main.png",true)
	MenuTile[Tutorial] = display.newImage("Tutorial1.png",-display.contentWidth,0,true)
	MenuTile[Sound] = display.newImage("Store.png",0,display.contentHeight,true)
	MenuTile[Slide] = display.newImage("Slide.png",0,-display.contentHeight,true)
	MenuTile[Slide2] = display.newImage("Slide2.png",display.contentWidth,0,true)
	MenuTile[Tutorial2] = display.newImage("Tutorial2.png",-display.contentWidth,display.contentHeight,true)
	MenuTile[Tutorial3] = display.newImage("Tutorial3.png",-display.contentWidth,2*display.contentHeight,true)
	
	group:insert(MenuTile[Main])
	group:insert(MenuTile[Tutorial])
	group:insert(MenuTile[Sound])
	group:insert(MenuTile[Slide])
	group:insert(MenuTile[Slide2])
	group:insert(MenuTile[Tutorial2])
	group:insert(MenuTile[Tutorial3])
	
-- End Menu Tiles

-- load the tutorial screens
	
	TutorialClassic = {}
	function loadTutorialClassic()
		TutorialClassic[0] = display.newImage("TutorialClassic1.png",MenuTile[Tutorial].x,MenuTile[Tutorial].y,true)
		group:insert(TutorialClassic[0])
		TutorialClassic[0].isVisible = true
		for i = 2,3 do
			TutorialClassic[i-1] = display.newImage("TutorialClassic"..i..".png",MenuTile[Tutorial].x,MenuTile[Tutorial].y,true)
			group:insert(TutorialClassic[i-1])
			TutorialClassic[i-1].isVisible = false
		end
	end
	function unloadTutorialClassic()
		for i = 1,3 do
			group:remove(TutorialClassic[i-1])
			TutorialClassic[i-1] = nil
		end
	end
	
	TutorialClassy = {}
	function loadTutorialClassy()
		TutorialClassy[0] = display.newImage("TutorialClassy1.png",MenuTile[Tutorial2].x,MenuTile[Tutorial2].y,true)
		group:insert(TutorialClassy[0])
		TutorialClassy[0].isVisible = true
		for i = 2,6 do
			TutorialClassy[i-1] = display.newImage("TutorialClassy"..i..".png",MenuTile[Tutorial2].x,MenuTile[Tutorial2].y,true)
			group:insert(TutorialClassy[i-1])
			TutorialClassy.isVisible = false
		end
	end
	function unloadTutorialClassy()
		for i = 1,6 do
			group:remove(TutorialClassy[i-1])
			TutorialClassy[i-1] = nil
		end
	end
	
-------------
-- VERSION
-------------

	--VERSION = display.newText(Version,0,0,nil,30)
	--VERSION:setTextColor(0,0,0)
	
	
---------------------------
-- Load all store images
---------------------------

	Extras = {}
	Extras[0] = display.newImage("Extra1.png",0,display.contentHeight,true)
	group:insert(Extras[0])
	ExtrasTitle = display.newImage("ExtrasTitle.png",true)
	group:insert(ExtrasTitle)

	function loadExtras()
		
		-- Load Extras
		for i = 2,12 do
			Extras[i-1] = display.newImage("Extra"..i..".png",display.contentWidth*(i-1),display.contentHeight,true)
			group:insert(Extras[i-1])
		end
	end
	function unloadExtras()
		for i = 2,12 do
			group:remove(Extras[i-1])
			Extras[i-1] = nil
		end
	end

	-- Powerups array
	Powerups = {}
	Powerups[0] = display.newImage("PowerUp1.png",0,display.contentHeight,true)
	group:insert(Powerups[0])
	PowerupsTitle = display.newImage("PowerUpsTitle.png",true)
	group:insert(PowerupsTitle)
	
	function loadPowerups()
		-- Load Powerups
		for i = 2,5 do
			Powerups[i-1] = display.newImage("PowerUp"..i..".png",display.contentWidth*(i-1),display.contentHeight,true)
			group:insert(Powerups[i-1])
		end
	end
	function unloadPowerups()
		for i = 2,5 do
			group:remove(Powerups[i-1])
			Powerups[i-1] = nil
		end
	end
	-- Themes array
	Themes = {}
	Themes[0] = display.newImage("Theme1.png",0,display.contentHeight,true)
	group:insert(Themes[0])
	ThemesTitle = display.newImage("ThemesTitle.png",true)
	group:insert(ThemesTitle)
	
	function loadThemes()
		for i = 2,5 do
			Themes[i-1] = display.newImage("Theme"..i..".png",display.contentWidth*(i-1),display.contentHeight,true)
			group:insert(Themes[i-1])
		end
	end
	function unloadThemes()
		for i = 2,5 do
			group:remove(Themes[i-1])
			Themes[i-1] = nil
		end
	end
------------------------
-- End store images
------------------------

-- RandomThings
	PurchaseButton = display.newImage("PurchaseButton.png",500,405)
	PurchaseButton.isVisible = false

	PurchaseButtonPressed = display.newImage("PurchaseButtonClicked.png",500,405)
	PurchaseButtonPressed.isVisible = false

	YourPoints = display.newText("Your Points:",625,10,nil,30)
	YourPoints:setTextColor(0,0,0)
	group:insert(YourPoints)

	Quantity = display.newText("You have: ",30,430,nil,40)
	Quantity:setTextColor(0,0,0)
	group:insert(Quantity)
	Quantity.isVisible = false

	YourPoints.isVisible = false
	DisplayPoints = display.newText(points,625,45,nil,30)
	group:insert(DisplayPoints)
	DisplayPoints:setTextColor(0,0,0)
	DisplayPoints.isVisible = false
	StoreEnabled = display.newImage("StoreEnabled.png",500,405,true)
	StoreDisabled = display.newImage("StoreDisabled.png",500,405,true)
	group:insert(StoreEnabled)
	group:insert(StoreDisabled)
	StoreEnabled.isVisible = false
	StoreDisabled.isVisible = false
	Price = display.newText("Price: "..Cost,40,400,nil,40)
	Price:setTextColor(0,0,0)
	group:insert(Price)
	Price.isVisible = false
-- Purchase Button Listener

	local function Purchase(event)
		if(event.phase == "began")then
			PurchaseButtonPressed.isVisible = true
			media.playEventSound("ButtonClick.wav")
		elseif(event.phase == "ended")then
			PurchaseButtonPressed.isVisible = false
			PurchasePressed = true
		end
	end
	PurchaseButton:addEventListener("touch",Purchase)
	
	local function StoreEnableButton(event)
	media.playEventSound("ButtonClick.wav")
		EnabledPressed = true
	end
	StoreEnabled:addEventListener("tap",StoreEnableButton)
	
	local function StoreDisableButton(event)
	media.playEventSound("ButtonClick.wav")
		DisabledPressed = true
	end
	StoreDisabled:addEventListener("tap",StoreDisableButton)
	
	HighScoresButton = display.newImage("HighScoresButton.png",300,140,true)
	group:insert(HighScoresButton)
	-- HighScoresButton Listener
	function HighScoresListener(event)
	media.playEventSound("ButtonClick.wav")
		if(loggedIntoGC == true)then
			gameNetwork.request("loadScores",
			{
				leaderboard = 
				{
					category = "BustinBlocksHighScores",
					playerScope = "Global",
					timeScope = "Week",
					range = {1,25}
				},
				listener = requestCallback
			})
			gameNetwork.show("leaderboards",{leaderboard = {timeScope = "Week"}})
		else
			native.showAlert("Alert!","You must be logged into Game Center",{"ok"})
		end
		print("HighScoresTapped")
	end
	HighScoresButton:addEventListener("tap",HighScoresListener)
	
	SoundFXOnButton = display.newImage("SoundFXOn.png",450,300)
	SoundFXOffButton = display.newImage("SoundFXOff.png",450,300)
	group:insert(SoundFXOnButton)
	group:insert(SoundFXOffButton)
	SoundMusicOnButton = display.newImage("MusicOn.png")
	SoundMusicOffButton = display.newImage("MusicOff.png")
	group:insert(SoundMusicOnButton)
	group:insert(SoundMusicOffButton)

	if(SoundFX == true)then
		SoundFXOnButton.isVisible = true
	else
		SoundFXOnButton.isVisible = false
	end	
	
	if(SoundMusic == true)then
		SoundMusicOnButton.isVisible = true
	else
		SoundMusicOnButton.isVisible = false
	end
	
	function SoundFXTap(event)
	media.playEventSound("ButtonClick.wav")
		if(SoundFX == true)then
			SoundFX = false
			SoundFXOnButton.isVisible = false
		else
			SoundFX = true
			SoundFXOnButton.isVisible = true
		end
		
	end
	SoundFXOffButton:addEventListener("tap",SoundFXTap)
	
	function SoundMusicTap(event)
	media.playEventSound("ButtonClick.wav")
		if(SoundMusic == true)then
			SoundMusic = false
			SoundMusicOnButton.isVisible = false
		else
			SoundMusic = true
			SoundMusicOnButton.isVisible = true
		end
	end
	SoundMusicOffButton:addEventListener("tap",SoundMusicTap)
end

-- Draw background colors before overlay
ExtrasButton = display.newImage("ExtrasButton.png",true)
ExtrasButton.isVisible = false
ThemesButton = display.newImage("ThemesButton.png",true)
ThemesButton.isVisible = false
--Selection buttons
StoreExtrasButton = display.newImage("StoreExtrasButton.png",true)
StorePowerUpsButton = display.newImage("StorePowerupsButton.png",true)
StoreThemesButton = display.newImage("StoreThemesButton.png",true)
--Selection Presses
PowerUpsButton = display.newImage("PowerUpsButton.png",true)
PowerUpsButton.isVisible = false

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
end


-- Called Every Frame
local function update(event)

local BGDirection
local Left, Right, Up, Down = 1,2,3,4

-- Move the Background
	for i = 0,2 do
		-- Subtract 1 from each background position
		Background[i].x = Background[i].x - 2
		-- If background reaches end of left buffer-lifetime
		if(Background[i].x <= -display.contentWidth*2)then
			-- Set its position to the rightmost buffer start
			Background[i].x = display.contentWidth*2
		end
	end
-- End Move Background

----------------------
-- Move Menu
----------------------

	-- Main Movements
	if(CurrentTile == Main)then
		-- From Classy
		if(MenuTile[Main].x < display.contentWidth/2)then
			MenuTile[Main].x = MenuTile[Main].x + 32
		-- From Tutorial
		elseif(MenuTile[Main].x > display.contentWidth/2)then
			MenuTile[Main].x = MenuTile[Main].x - 32
		-- From Store
		elseif(MenuTile[Main].y < display.contentHeight/2)then
			MenuTile[Main].y = MenuTile[Main].y + 20
		-- From Classic
		elseif(MenuTile[Main].y > display.contentHeight/2)then
			MenuTile[Main].y = MenuTile[Main].y - 20
		end
		
	-- Tutorial Movements
	-- From Main
	elseif(CurrentTile == Tutorial)then
		if(MenuTile[Main].x < display.contentWidth*1.5)then
			MenuTile[Main].x = MenuTile[Main].x + 32
		elseif(MenuTile[Tutorial].y < display.contentHeight*.5)then
			MenuTile[Tutorial].y = MenuTile[Tutorial].y + 20
		end
	elseif(CurrentTile == Tutorial2)then
		if(MenuTile[Tutorial].y > -display.contentHeight*.5)then
			MenuTile[Tutorial].y = MenuTile[Tutorial].y - 20
		elseif(MenuTile[Tutorial].y < -display.contentHeight*.5)then
			MenuTile[Tutorial].y = MenuTile[Tutorial].y + 20
		end
	elseif(CurrentTile == Tutorial3)then
		if(MenuTile[Tutorial].y > -display.contentHeight*1.5)then
			MenuTile[Tutorial].y = MenuTile[Tutorial].y - 20
		end
	
	-- Slide Movements
	-- From Main
	elseif(CurrentTile == Slide)then
		if(MenuTile[Main].y < display.contentHeight*1.5)then
			MenuTile[Main].y = MenuTile[Main].y + 20
		end
	elseif(CurrentTile == Easy2)then
		if(MenuTile[Main].y < display.contentHeight*2.5)then
			storyboard.gotoScene("slide")
		end
	elseif(CurrentTile == Medium2)then
		if(MenuTile[Main].x > -display.contentWidth/2)then
			storyboard.gotoScene("slide")
		end
	elseif(CurrentTile == Hard2)then
		if(MenuTile[Main].x < display.contentWidth*1.5)then
			storyboard.gotoScene("slide")
		end
	-- Slide2 Movements
	-- From Main
	elseif(CurrentTile == Slide2)then
		if(MenuTile[Main].x > -display.contentWidth/2)then
			MenuTile[Main].x = MenuTile[Main].x - 32
		end
	elseif(CurrentTile == Easy)then
		if(MenuTile[Main].y < display.contentHeight*1.5)then
			MenuTile[Main].y = MenuTile[Main].y + 20
			storyboard.gotoScene("classy")
		end
	elseif(CurrentTile == Medium)then
		if(MenuTile[Main].x > -display.contentWidth*1.5)then
			MenuTile[Main].x = MenuTile[Main].x - 32
			storyboard.gotoScene("classy")
		end
	elseif(CurrentTile == Hard)then
		if(MenuTile[Main].y > -display.contentHeight/2)then
			MenuTile[Main].y = MenuTile[Main].y - 20
			storyboard.gotoScene("classy")
		end
		
	-- Sound Movements
	-- From Main
	elseif(CurrentTile == Sound)then
		if(MenuTile[Main].y > -display.contentHeight/2)then
			MenuTile[Main].y = MenuTile[Main].y - 20
		elseif(MenuTile[Main].y < -display.contentHeight/2)then
			MenuTile[Main].y = MenuTile[Main].y + 20
		end
		if(Extras[0].y < display.contentHeight*1.5)then
			Extras[0].y = Extras[0].y + 20
		end
		if(Powerups[0].y < display.contentHeight*1.5)then
			Powerups[0].y = Powerups[0].y + 20
		end
		if(Themes[0].y < display.contentHeight*1.5)then
			Themes[0].y = Themes[0].y + 20
		end
		
	-- Store Movements
	
	-- Extras Movements
	elseif(CurrentTile == Extras)then
		if(MenuTile[Main].y > -display.contentHeight*1.5)then
			MenuTile[Main].y = MenuTile[Main].y - 20
		end
		if(Extras[0].y > display.contentHeight/2)then
			Extras[0].y = Extras[0].y - 20
		end
		if(Extras[0].x > display.contentWidth/2 -(StoreTile*display.contentWidth))then
			Extras[0].x = Extras[0].x - 32
			
		elseif(Extras[0].x < display.contentWidth/2 - (StoreTile*display.contentWidth))then
			Extras[0].x = Extras[0].x + 32
		end
		
	-- Powerups Movements
	elseif(CurrentTile == Powerups)then
		if(MenuTile[Main].y > -display.contentHeight*1.5)then
			MenuTile[Main].y = MenuTile[Main].y - 20
		end
		if(Powerups[0].y > display.contentHeight/2)then
			Powerups[0].y = Powerups[0].y - 20
		end
		if(Powerups[0].x > display.contentWidth/2 - (StoreTile*display.contentWidth))then
			Powerups[0].x = Powerups[0].x - 32
			
		elseif(Powerups[0].x < display.contentWidth/2 - (StoreTile*display.contentWidth))then
			Powerups[0].x = Powerups[0].x + 32
		end
		
	-- Themes Movements
	elseif(CurrentTile == Themes)then
		if(MenuTile[Main].y > -display.contentHeight*1.5)then
			MenuTile[Main].y = MenuTile[Main].y - 20
		end
		if(Themes[0].y > display.contentHeight/2)then
			Themes[0].y = Themes[0].y - 20
		end
		
		if(Themes[0].x > display.contentWidth/2 - (StoreTile*display.contentWidth))then
			Themes[0].x = Themes[0].x - 32
			
		elseif(Themes[0].x < display.contentWidth/2 - (StoreTile*display.contentWidth))then
			Themes[0].x = Themes[0].x + 32
		end
		
	end
-------------------------
-- End Move Menu
-------------------------

-- Update all tile positions relative to main tile
	-- Tutorial Tile
	MenuTile[Tutorial].x = MenuTile[Main].x - display.contentWidth
	MenuTile[Tutorial2].y = MenuTile[Tutorial].y + display.contentHeight
	MenuTile[Tutorial2].x = MenuTile[Tutorial].x
	MenuTile[Tutorial3].y = MenuTile[Tutorial].y + display.contentHeight*2
	MenuTile[Tutorial3].x = MenuTile[Tutorial].x
	-- Slide2 Tile
	MenuTile[Slide2].x = MenuTile[Main].x + display.contentWidth
	MenuTile[Slide2].y = MenuTile[Main].y
	-- Sound Tile
	MenuTile[Sound].x = MenuTile[Main].x
	MenuTile[Sound].y = MenuTile[Main].y + display.contentHeight
	-- Slide Tile
	MenuTile[Slide].x = MenuTile[Main].x
	MenuTile[Slide].y = MenuTile[Main].y - display.contentHeight
	-- Tutorials
	-- Tutorial Classic
	if(CurrentTile == Tutorial)then
		for i = 0,2 do
			TutorialClassic[i].x = MenuTile[Tutorial].x
			TutorialClassic[i].y = MenuTile[Tutorial].y - 10
		end
	elseif(CurrentTile == Tutorial2)then
		for i = 0,5 do
			TutorialClassy[i].x = MenuTile[Tutorial2].x
			TutorialClassy[i].y = MenuTile[Tutorial2].y - 10
		end
	end
-- End updating tile positions
-- Update Store buttons
	StoreExtrasButton.y = MenuTile[Sound].y - (2*display.contentHeight)/7
	StoreExtrasButton.x = MenuTile[Sound].x
	
	StorePowerUpsButton.y = MenuTile[Sound].y
	StorePowerUpsButton.x = MenuTile[Sound].x
	
	StoreThemesButton.y = MenuTile[Sound].y + (2*display.contentHeight)/7
	StoreThemesButton.x = MenuTile[Sound].x
	
	
	ExtrasButton.y = StoreExtrasButton.y
	ExtrasButton.x = StoreExtrasButton.x
	
	PowerUpsButton.y = StorePowerUpsButton.y
	PowerUpsButton.x = StorePowerUpsButton.x
	
	ThemesButton.y = StoreThemesButton.y
	ThemesButton.x = StoreThemesButton.x

-- update buttons and stuff
	SoundFXOnButton.x = MenuTile[Main].x + 120
	SoundFXOnButton.y = MenuTile[Main].y + 80
	SoundFXOffButton.x = SoundFXOnButton.x
	SoundFXOffButton.y = SoundFXOnButton.y
	SoundMusicOnButton.x = MenuTile[Main].x - 120
	SoundMusicOnButton.y = MenuTile[Main].y + 80
	SoundMusicOffButton.x = SoundMusicOnButton.x
	SoundMusicOffButton.y = SoundMusicOnButton.y
	HighScoresButton.x = MenuTile[Main].x
	HighScoresButton.y = MenuTile[Main].y - 80
-- Update all background images
	for i = 0,3 do
		if(BGDirection == Up)then
			Background[i].y = Background[i].y - 20
		elseif(BGDirection == Down)then
			Background[i].y = Background[i].y + 20
		elseif(BGDirection == Left)then
			for j = 0,20 do
				Background[i].x = Background[i].x - 1
				-- If background reaches end of left buffer-lifetime
				if(Background[i].x <= -display.contentWidth*3)then
					-- Set its position to the rightmost buffer start
					Background[i].x = display.contentWidth*3
				end
			end
		elseif(BGDirection == Right)then
			Background[i].x = Background[i].x + 20
		end
	end
		
-- Update all store pages
	ExtrasTitle.y = Extras[0].y - 190
	PowerupsTitle.y = Powerups[0].y - 190
	ThemesTitle.y = Themes[0].y - 190
	if(CurrentTile == Extras)then
		for i = 1,11 do
			Extras[i].x = Extras[0].x + display.contentWidth*i
			Extras[i].y = Extras[0].y
		end
	elseif(CurrentTile == Powerups)then
		for i = 1,4 do
			Powerups[i].x = Powerups[0].x + display.contentWidth*i
			Powerups[i].y = Powerups[0].y
		end
	elseif(CurrentTile == Themes)then	
		for i = 1,4 do
			Themes[i].x = Themes[0].x + display.contentWidth*i
			Themes[i].y = Themes[0].y
		end	
	end
	
------------------------
-- All the store logic
------------------------

	Price.text = "Price: "..Cost

	Quantity.text = "You have: "..ammount
	DisplayPoints.text = points
	if(CurrentTile == Extras)then
		-- Concrete
		if(StoreTile == 0)then
			if(haveConcrete == 0)then
				PurchaseButton.isVisible = true
				StoreDisabled.isVisible = false
				StoreEnabled.isVisible = false
				Cost = 150
				if(PurchasePressed == true)then
					if((points - Cost) >= 0)then
						if(SoundFX == true)then
							audio.play(PurchaseSound)
						end
						points = points - Cost
						haveConcrete = 1
						WriteAll()
						PurchasePressed = false
					else
						native.showAlert( "Not enough points", "You don't have enough points to buy this!", { "OK" } )
						PurchasePressed = false
					end
				end
			else
				if(Concrete == 0)then
					StoreDisabled.isVisible = true
					StoreEnabled.isVisible = false
				else
					StoreEnabled.isVisible = true
					StoreDisabled.isVisible = false
				end
				if(EnabledPressed == true)then
					Concrete = 0
					EnabledPressed = false
					WriteAll()
				end
				if(DisabledPressed == true)then
					Concrete = 1
					DisabledPressed = false
					WriteAll()
				end
				PurchaseButton.isVisible = false
				Price.isVisible = false
			end
		-- Speed 1.5
		elseif(StoreTile == 1)then
			if(haveSpeed15 == 0)then
				PurchaseButton.isVisible = true
				StoreDisabled.isVisible = false
				StoreEnabled.isVisible = false
				Cost = 120
				if(PurchasePressed == true)then
					if((points - Cost) >= 0)then
						points = points - Cost
						if(SoundFX == true)then
							audio.play(PurchaseSound)
						end
						haveSpeed15 = 1
						WriteAll()
						PurchasePressed = false
					else
						native.showAlert( "Not enough points", "You don't have enough points to buy this!", { "OK" } )
						PurchasePressed = false
					end
				end
			else
				if(CurrentSpeed ~= Speed15)then
					StoreDisabled.isVisible = true
					StoreEnabled.isVisible = false
				else
					StoreEnabled.isVisible = true
					StoreDisabled.isVisible = false
				end
				if(EnabledPressed == true)then
					CurrentSpeed = Normal
					EnabledPressed = false
					WriteAll()
				end
				if(DisabledPressed == true)then
					CurrentSpeed = Speed15
					DisabledPressed = false
					WriteAll()
				end
				PurchaseButton.isVisible = false
				Price.isVisible = false
			end
		-- Speed 2
		elseif(StoreTile == 2)then
			if(haveSpeed2 == 0)then
				PurchaseButton.isVisible = true
				StoreDisabled.isVisible = false
				StoreEnabled.isVisible = false
				Cost = 120
				if(PurchasePressed == true)then
					if((points - Cost) >= 0)then
						if(SoundFX == true)then
							audio.play(PurchaseSound)
						end
						points = points - Cost
						haveSpeed2 = 1
						WriteAll()
						PurchasePressed = false
					else
						native.showAlert( "Not enough points", "You don't have enough points to buy this!", { "OK" } )
						PurchasePressed = false
					end
				end
			else
				if(CurrentSpeed ~= Speed2)then
					StoreDisabled.isVisible = true
					StoreEnabled.isVisible = false
				else
					StoreEnabled.isVisible = true
					StoreDisabled.isVisible = false
				end
				if(EnabledPressed == true)then
					CurrentSpeed = Normal
					EnabledPressed = false
					WriteAll()
				end
				if(DisabledPressed == true)then
					CurrentSpeed = Speed2
					DisabledPressed = false
					WriteAll()
				end
				PurchaseButton.isVisible = false
				Price.isVisible = false
			end
		-- Fancy
		elseif(StoreTile == 3)then
			if(haveFancy == 0)then
				PurchaseButton.isVisible = true
				StoreDisabled.isVisible = false
				StoreEnabled.isVisible = false
				Cost = 100
				if(PurchasePressed == true)then
					if((points - Cost) >= 0)then
						points = points - Cost
						if(SoundFX == true)then
							audio.play(PurchaseSound)
						end
						haveFancy = 1
						WriteAll()
						PurchasePressed = false
					else
						native.showAlert( "Not enough points", "You don't have enough points to buy this!", { "OK" } )
						PurchasePressed = false
					end
				end
			else
				if(CurrentBlocks ~= Fancy)then
					StoreDisabled.isVisible = true
					StoreEnabled.isVisible = false
				else
					StoreEnabled.isVisible = true
					StoreDisabled.isVisible = false
				end
				if(EnabledPressed == true)then
					CurrentBlocks = Normal
					EnabledPressed = false
					WriteAll()
				end
				if(DisabledPressed == true)then
					CurrentBlocks = Fancy
					DisabledPressed = false
					WriteAll()
				end
				PurchaseButton.isVisible = false
				Price.isVisible = false
			end
		-- Classy
		elseif(StoreTile == 4)then
			if(haveClassy == 0)then
				PurchaseButton.isVisible = true
				StoreDisabled.isVisible = false
				StoreEnabled.isVisible = false
				Cost = 100
				if(PurchasePressed == true)then
					if((points - Cost) >= 0)then
						points = points - Cost
						if(SoundFX == true)then
							audio.play(PurchaseSound)
						end
						haveClassy = 1
						WriteAll()
						PurchasePressed = false
					else
						native.showAlert( "Not enough points", "You don't have enough points to buy this!", { "OK" } )
						PurchasePressed = false
					end
				end
			else
				if(CurrentBlocks ~= Classy)then
					StoreDisabled.isVisible = true
					StoreEnabled.isVisible = false
				else
					StoreEnabled.isVisible = true
					StoreDisabled.isVisible = false
				end
				if(EnabledPressed == true)then
					CurrentBlocks = Normal
					EnabledPressed = false
					WriteAll()
				end
				if(DisabledPressed == true)then
					CurrentBlocks = Classy
					DisabledPressed = false
					WriteAll()
				end
				PurchaseButton.isVisible = false
				Price.isVisible = false
			end
		-- Ancient
		elseif(StoreTile == 5)then
			if(haveAncient == 0)then
				PurchaseButton.isVisible = true
				StoreDisabled.isVisible = false
				StoreEnabled.isVisible = false
				Cost = 100
				if(PurchasePressed == true)then
					if((points - Cost) >= 0)then
						points = points - Cost
						if(SoundFX == true)then
							audio.play(PurchaseSound)
						end
						haveAncient = 1
						WriteAll()
						PurchasePressed = false
					else
						native.showAlert( "Not enough points", "You don't have enough points to buy this!", { "OK" } )
						PurchasePressed = false
					end
				end
			else
				if(CurrentBlocks ~= Ancient)then
					StoreDisabled.isVisible = true
					StoreEnabled.isVisible = false
				else
					StoreEnabled.isVisible = true
					StoreDisabled.isVisible = false
				end
				if(EnabledPressed == true)then
					CurrentBlocks = Normal
					EnabledPressed = false
					WriteAll()
				end
				if(DisabledPressed == true)then
					CurrentBlocks = Ancient
					DisabledPressed = false
					WriteAll()
				end
				PurchaseButton.isVisible = false
				Price.isVisible = false
			end
		-- Pixel
		elseif(StoreTile == 6)then
			if(havePixel == 0)then
				PurchaseButton.isVisible = true
				StoreDisabled.isVisible = false
				StoreEnabled.isVisible = false
				Cost = 100
				if(PurchasePressed == true)then
					if((points - Cost) >= 0)then
						points = points - Cost
						if(SoundFX == true)then
							audio.play(PurchaseSound)
						end
						havePixel = 1
						WriteAll()
						PurchasePressed = false
					else
						native.showAlert( "Not enough points", "You don't have enough points to buy this!", { "OK" } )
						PurchasePressed = false
					end
				end
			else
				if(CurrentBlocks ~= Pixel)then
					StoreDisabled.isVisible = true
					StoreEnabled.isVisible = false
				else
					StoreEnabled.isVisible = true
					StoreDisabled.isVisible = false
				end
				if(EnabledPressed == true)then
					CurrentBlocks = Normal
					EnabledPressed = false
					WriteAll()
				end
				if(DisabledPressed == true)then
					CurrentBlocks = Pixel
					DisabledPressed = false
					WriteAll()
				end
				PurchaseButton.isVisible = false
				Price.isVisible = false
			end
		-- WornOut
		elseif(StoreTile == 7)then
			if(haveWornOut == 0)then
				PurchaseButton.isVisible = true
				StoreDisabled.isVisible = false
				StoreEnabled.isVisible = false
				Cost = 100
				if(PurchasePressed == true)then
					if((points - Cost) >= 0)then
						points = points - Cost
						if(SoundFX == true)then
							audio.play(PurchaseSound)
						end
						haveWornOut = 1
						WriteAll()
						PurchasePressed = false
					else
						native.showAlert( "Not enough points", "You don't have enough points to buy this!", { "OK" } )
						PurchasePressed = false
					end
				end
			else
				if(CurrentBlocks ~= WornOut)then
					StoreDisabled.isVisible = true
					StoreEnabled.isVisible = false
				else
					StoreEnabled.isVisible = true
					StoreDisabled.isVisible = false
				end
				if(EnabledPressed == true)then
					CurrentBlocks = Normal
					EnabledPressed = false
					WriteAll()
				end
				if(DisabledPressed == true)then
					CurrentBlocks = WornOut
					DisabledPressed = false
					WriteAll()
				end
				PurchaseButton.isVisible = false
				Price.isVisible = false
			end
		-- Element
		elseif(StoreTile == 8)then
			if(haveElement == 0)then
				PurchaseButton.isVisible = true
				StoreDisabled.isVisible = false
				StoreEnabled.isVisible = false
				Cost = 100
				if(PurchasePressed == true)then
					if((points - Cost) >= 0)then
						points = points - Cost
						if(SoundFX == true)then
							audio.play(PurchaseSound)
						end
						haveElement = 1
						WriteAll()
						PurchasePressed = false
					else
						native.showAlert( "Not enough points", "You don't have enough points to buy this!", { "OK" } )
						PurchasePressed = false
					end
				end
			else
				if(CurrentBlocks ~= Element)then
					StoreDisabled.isVisible = true
					StoreEnabled.isVisible = false
				else
					StoreEnabled.isVisible = true
					StoreDisabled.isVisible = false
				end
				if(EnabledPressed == true)then
					CurrentBlocks = Normal
					EnabledPressed = false
					WriteAll()
				end
				if(DisabledPressed == true)then
					CurrentBlocks = Element
					DisabledPressed = false
					WriteAll()
				end
				PurchaseButton.isVisible = false
				Price.isVisible = false
			end
		-- Minimal
		elseif(StoreTile == 9)then
			if(haveMinimal == 0)then
				PurchaseButton.isVisible = true
				StoreDisabled.isVisible = false
				StoreEnabled.isVisible = false
				Cost = 100
				if(PurchasePressed == true)then
					if((points - Cost) >= 0)then
						points = points - Cost
						if(SoundFX == true)then
							audio.play(PurchaseSound)
						end
						haveMinimal = 1
						WriteAll()
						PurchasePressed = false
					else
						native.showAlert( "Not enough points", "You don't have enough points to buy this!", { "OK" } )
						PurchasePressed = false
					end
				end
			else
				if(CurrentBlocks ~= Minimal)then
					StoreDisabled.isVisible = true
					StoreEnabled.isVisible = false
				else
					StoreEnabled.isVisible = true
					StoreDisabled.isVisible = false
				end
				if(EnabledPressed == true)then
					CurrentBlocks = Normal
					EnabledPressed = false
					WriteAll()
				end
				if(DisabledPressed == true)then
					CurrentBlocks = Minimal
					DisabledPressed = false
					WriteAll()
				end
				PurchaseButton.isVisible = false
				Price.isVisible = false
			end
		-- Japanese
		elseif(StoreTile == 10)then
			if(haveJapanese == 0)then
				PurchaseButton.isVisible = true
				StoreDisabled.isVisible = false
				StoreEnabled.isVisible = false
				Cost = 100
				if(PurchasePressed == true)then
					if((points - Cost) >= 0)then
						points = points - Cost
						if(SoundFX == true)then
							audio.play(PurchaseSound)
						end
						haveJapanese = 1
						WriteAll()
						PurchasePressed = false
					else
						native.showAlert( "Not enough points", "You don't have enough points to buy this!", { "OK" } )
						PurchasePressed = false
					end
				end
			else
				if(CurrentBlocks ~= Japanese)then
					StoreDisabled.isVisible = true
					StoreEnabled.isVisible = false
				else
					StoreEnabled.isVisible = true
					StoreDisabled.isVisible = false
				end
				if(EnabledPressed == true)then
					CurrentBlocks = Normal
					EnabledPressed = false
					WriteAll()
				end
				if(DisabledPressed == true)then
					CurrentBlocks = Japanese
					DisabledPressed = false
					WriteAll()
				end
				PurchaseButton.isVisible = false
				Price.isVisible = false
			end
		elseif(StoreTile == 11)then
			Cost = "$0.99"
			PurchaseButton.isVisible = true
			StoreDisabled.isVisible = false
			StoreEnabled.isVisible = false
			if(PurchasePressed == true)then
				if(store.canMakePurchases == true)then
					store.purchase({"BuyPoints"})
				else
					native.showAlert("Purchases Disabled","Purchases are disabled for this device, enable them in settings to purchase this item.",{"Ok"})
				end
				PurchasePressed = false
			end
		end
	elseif(CurrentTile == Powerups)then
		-- Stop Time
		if(StoreTile == 0)then
			PurchaseButton.isVisible = true
			Quantity.isVisible = true
			StoreDisabled.isVisible = false
			StoreEnabled.isVisible = false
			Cost = 150
			ammount = StopTimeToggle
			if(PurchasePressed == true)then
				if((points - Cost) >= 0)then
					points = points - Cost
					if(SoundFX == true)then
						audio.play(PurchaseSound)
					end
					haveStopTimeToggle = 1
					StopTimeToggle = StopTimeToggle + 1
					WriteAll()
					PurchasePressed = false
				else
					native.showAlert( "Not enough points", "You don't have enough points to buy this!", { "OK" } )
					PurchasePressed = false
				end
			end
		-- Bomb
		elseif(StoreTile == 1)then
			PurchaseButton.isVisible = true
			Quantity.isVisible = true
			StoreDisabled.isVisible = false
			StoreEnabled.isVisible = false
			Cost = 150
			ammount = BombToggle
			if(PurchasePressed == true)then
				if((points - Cost) >= 0)then
					points = points - Cost
					if(SoundFX == true)then
						audio.play(PurchaseSound)
					end
					haveBombToggle = 1
					BombToggle = BombToggle + 1
					WriteAll()
					PurchasePressed = false
				else
					native.showAlert( "Not enough points", "You don't have enough points to buy this!", { "OK" } )
					PurchasePressed = false
				end
			end
		-- Rainbow Block
		elseif(StoreTile == 2)then
			PurchaseButton.isVisible = true
			Quantity.isVisible = true
			StoreDisabled.isVisible = false
			StoreEnabled.isVisible = false
			Cost = 100
			ammount = RainbowToggle
			if(PurchasePressed == true)then
				if((points - Cost) >= 0)then
					points = points - Cost
					if(SoundFX == true)then
						audio.play(PurchaseSound)
					end
					haveRainbowToggle = 1
					RainbowToggle = RainbowToggle + 1
					WriteAll()
					PurchasePressed = false
				else
					native.showAlert( "Not enough points", "You don't have enough points to buy this!", { "OK" } )
					PurchasePressed = false
				end
			end
		-- Bonus
		elseif(StoreTile == 3)then
			Quantity.isVisible = false
			if(haveBonusToggle == 0)then
				PurchaseButton.isVisible = true
				StoreDisabled.isVisible = false
				StoreEnabled.isVisible = false
				Cost = 400
				if(PurchasePressed == true)then
					if((points - Cost) >= 0)then
						points = points - Cost
						if(SoundFX == true)then
							audio.play(PurchaseSound)
						end
						haveBonusToggle = 1
						WriteAll()
						PurchasePressed = false
					else
						native.showAlert( "Not enough points", "You don't have enough points to buy this!", { "OK" } )
						PurchasePressed = false
					end
				end
			else
				if(BonusToggle == 0)then
					StoreDisabled.isVisible = true
					StoreEnabled.isVisible = false
				else
					StoreEnabled.isVisible = true
					StoreDisabled.isVisible = false
				end
				if(EnabledPressed == true)then
					BonusToggle = 0
					EnabledPressed = false
					WriteAll()
				end
				if(DisabledPressed == true)then
					BonusToggle = 1
					DisabledPressed = false
					WriteAll()
				end
				PurchaseButton.isVisible = false
				Price.isVisible = false
			end
		elseif(StoreTile == 4)then
			Cost = "$0.99"
			PurchaseButton.isVisible = true
			StoreDisabled.isVisible = false
			Quantity.isVisible = false
			StoreEnabled.isVisible = false
			if(PurchasePressed == true)then
				if(store.canMakePurchases == true)then
					store.purchase({"BuyPoints"})
				else
					native.showAlert("Purchases Disabled","Purchases are disabled for this device, enable them in settings to purchase this item.",{"Ok"})
				end
				PurchasePressed = false
			end
		end
	elseif(CurrentTile == Themes)then
		-- WornOut
		if(StoreTile == 0)then
			if(haveWornOutTheme == 0)then
				PurchaseButton.isVisible = true
				StoreDisabled.isVisible = false
				StoreEnabled.isVisible = false
				Cost = 150
				if(PurchasePressed == true)then
					if((points - Cost) >= 0)then
						points = points - Cost
						if(SoundFX == true)then
							audio.play(PurchaseSound)
						end
						haveWornOutTheme = 1
						WriteAll()
						PurchasePressed = false
					else
						native.showAlert( "Not enough points", "You don't have enough points to buy this!", { "OK" } )
						PurchasePressed = false
					end
				end
			else
				if(CurrentTheme ~= WornOutTheme)then
					StoreDisabled.isVisible = true
					StoreEnabled.isVisible = false
				else
					StoreEnabled.isVisible = true
					StoreDisabled.isVisible = false
				end
				if(EnabledPressed == true)then
					CurrentTheme = Normal
					EnabledPressed = false
					WriteAll()
				end
				if(DisabledPressed == true)then
					CurrentTheme = WornOutTheme
					DisabledPressed = false
					WriteAll()
				end
				PurchaseButton.isVisible = false
				Price.isVisible = false
			end
		-- Pencil Drawn
		elseif(StoreTile == 1)then
			if(havePencilDrawn == 0)then
				PurchaseButton.isVisible = true
				StoreDisabled.isVisible = false
				StoreEnabled.isVisible = false
				Cost = 150
				if(PurchasePressed == true)then
					if((points - Cost) >= 0)then
						points = points - Cost
						if(SoundFX == true)then
							audio.play(PurchaseSound)
						end
						havePencilDrawn = 1
						WriteAll()
						PurchasePressed = false
					else
						native.showAlert( "Not enough points", "You don't have enough points to buy this!", { "OK" } ) 
						PurchasePressed = false
					end
				end
			else
				if(CurrentTheme ~= PencilDrawn)then
					StoreDisabled.isVisible = true
					StoreEnabled.isVisible = false
				else
					StoreEnabled.isVisible = true
					StoreDisabled.isVisible = false
				end
				if(EnabledPressed == true)then
					CurrentTheme = Normal
					EnabledPressed = false
					WriteAll()
				end
				if(DisabledPressed == true)then
					CurrentTheme = PencilDrawn
					DisabledPressed = false
					WriteAll()
				end
				PurchaseButton.isVisible = false
				Price.isVisible = false
			end
		-- BlackOut
		elseif(StoreTile == 2)then
			if(haveBlackOut == 0)then
				PurchaseButton.isVisible = true
				StoreDisabled.isVisible = false
				StoreEnabled.isVisible = false
				Cost = 150
				if(PurchasePressed == true)then
					if((points - Cost) >= 0)then
						points = points - Cost
						if(SoundFX == true)then
							audio.play(PurchaseSound)
						end
						haveBlackOut = 1
						WriteAll()
						PurchasePressed = false
					else
						native.showAlert( "Not enough points", "You don't have enough points to buy this!", { "OK" } )
						PurchasePressed = false
					end
				end
			else
				if(CurrentTheme ~= BlackOut)then
					StoreDisabled.isVisible = true
					StoreEnabled.isVisible = false
				else
					StoreEnabled.isVisible = true
					StoreDisabled.isVisible = false
				end
				if(EnabledPressed == true)then
					CurrentTheme = Normal
					EnabledPressed = false
					WriteAll()
				end
				if(DisabledPressed == true)then
					CurrentTheme = BlackOut
					DisabledPressed = false
					WriteAll()
				end
				PurchaseButton.isVisible = false
				Price.isVisible = false
			end
		-- Minimal
		elseif(StoreTile == 3)then
			if(haveMinimalTheme == 0)then
				PurchaseButton.isVisible = true
				StoreDisabled.isVisible = false
				StoreEnabled.isVisible = false
				Cost = 150
				if(PurchasePressed == true)then
					if((points - Cost) >= 0)then
						points = points - Cost
						if(SoundFX == true)then
							audio.play(PurchaseSound)
						end
						haveMinimalTheme = 1
						WriteAll()
						PurchasePressed = false
					else
						native.showAlert( "Not enough points", "You don't have enough points to buy this!", { "OK" } )
						PurchasePressed = false
					end
				end
			else
				if(CurrentTheme ~= MinimalTheme)then
					StoreDisabled.isVisible = true
					StoreEnabled.isVisible = false
				else
					StoreEnabled.isVisible = true
					StoreDisabled.isVisible = false
				end
				if(EnabledPressed == true)then
					CurrentTheme = Normal
					EnabledPressed = false
					WriteAll()
				end
				if(DisabledPressed == true)then
					CurrentTheme = MinimalTheme
					DisabledPressed = false
					WriteAll()
				end
				PurchaseButton.isVisible = false
				Price.isVisible = false
			end
		elseif(StoreTile == 4)then
			Cost = "$0.99"
			PurchaseButton.isVisible = true
			StoreDisabled.isVisible = false
			StoreEnabled.isVisible = false
			if(PurchasePressed == true)then
				if(store.canMakePurchases == true)then
					store.purchase({"BuyPoints"})
				else
					native.showAlert("Purchases Disabled","Purchases are disabled for this device, enable them in settings to purchase this item.",{"Ok"})
				end
				PurchasePressed = false
			end
		end
	end

------------------------
-- End the store logic
------------------------
end
Runtime:addEventListener("enterFrame",update)

local function NextTutorial(event)
	-- iterate over the tutorial screens and show the next frame
	changed = false
	-- Tutorial Classy
	if(CurrentTile == Tutorial2)then
		for i = 0,5 do
			if(i == 5 and changed == false)then
				TutorialClassy[5].isVisible = false
				TutorialClassy[0].isVisible = true
				changed = true
			end
			if(TutorialClassy[i].isVisible == true and changed == false)then
				TutorialClassy[i].isVisible = false
				TutorialClassy[i+1].isVisible = true
				changed = true
			end
		end
		
	
	-- Tutorial Classic
	elseif(CurrentTile == Tutorial)then
		for i = 0,2 do
			if(i == 2 and changed == false)then
				TutorialClassic[2].isVisible = false
				TutorialClassic[0].isVisible = true
				changed = true
			end
			if(TutorialClassic[i].isVisible == true and changed == false)then
				TutorialClassic[i].isVisible = false
				TutorialClassic[i+1].isVisible = true
				changed = true
			end
		end
	end
end
tutorialtimer = timer.performWithDelay(500,NextTutorial,0)

-- Called when user touches the screen
local function Swipe(event)
-- Declare local variables
	local Direction = -1
	local Left, Right, Up, Down, None = 0,1,2,3,-1
	local DistanceX
	local DistanceY

	
-- Find direction of swipe
	-- If user lifts finger
	if(event.phase == "ended")then
	-- Reset buttons just incase
	ThemesButton.isVisible = false
	PowerUpsButton.isVisible = false
	ExtrasButton.isVisible = false
	PurchaseButtonPressed.isVisible = false
	-- Find Distances
		-- Find x distance
		DistanceX = event.x - event.xStart
		-- Find y distance
		DistanceY = event.y - event.yStart
		
		-- Set Direction
		-- If y distance is greater than x distance
		if(math.abs(DistanceY) - math.abs(DistanceX) > 0)then
			-- and If y distance was in a positive direction
			if(DistanceY > 40)then
				Direction = Down -- Swiped Down
			elseif(DistanceY < -40)then
				Direction = Up -- Swiped Up
			else
				-- Tapped animation goes here
			end
			
		-- If x distance is greater
		else
			--and x distance is in a positive direction
			if(DistanceX > 40)then
				Direction = Right -- Swiped Right
			elseif(DistanceX < -40)then
				Direction = Left -- Swiped Left
			else
				-- Tapped animation goes here
			end
		end -- End Set Direction
		
		
	-- Set new CurrentTile based on Direction
		--------------------
		-- Main Actions
		--------------------
		if(CurrentTile == Main)then
		
			if(Direction == Left)then
					CurrentTile = Slide2
					
			elseif(Direction == Right)then
				CurrentTile = Tutorial 
				loadTutorialClassic()
				
			elseif(Direction == Up)then
				CurrentTile = Sound
			
			elseif(Direction == Down)then
				CurrentTile = Slide
			end
		
		---------------------
		-- Tutorial1 Actions
		---------------------
		elseif(CurrentTile == Tutorial)then
		
			if(Direction == Left)then
				CurrentTile = Main
				unloadTutorialClassic()
			
			elseif(Direction == Up)then
				CurrentTile = Tutorial2
				unloadTutorialClassic()
				loadTutorialClassy()
			end
		
		---------------------
		-- Tutorial2 Actions
		--------------------
		
		elseif(CurrentTile == Tutorial2)then
		
			if(Direction == Left)then
				CurrentTile = Main
				unloadTutorialClassy()
			
			elseif(Direction == Up)then
				CurrentTile = Tutorial3
				unloadTutorialClassy()
				
			elseif(Direction == Down)then
				unloadTutorialClassy()
				loadTutorialClassic()
				CurrentTile = Tutorial
				
			end
			
		--------------------
		-- Tutorial3 Actions
		--------------------
		
		elseif(CurrentTile == Tutorial3)then
		
			if(Direction == Left)then
				CurrentTile = Main
				
			elseif(Direction == Down)then
				CurrentTile = Tutorial2
				loadTutorialClassy()
			end
		
		---------------------
		-- Slide2 Actions
		---------------------
		elseif(CurrentTile == Slide2)then
		
			if(Direction == Down)then
				CurrentTile = Easy
				
			elseif(Direction == Left)then
				CurrentTile = Medium
			
			elseif(Direction == Up)then
				CurrentTile = Hard
				
			elseif(Direction == Right)then
				CurrentTile = Main
			end
			
		------------------------
		-- Slide Actions
		------------------------
		elseif(CurrentTile == Slide)then
		
			if(Direction == Up)then
				CurrentTile = Main
				
			elseif(Direction == Left)then
				CurrentTile = Medium2
				
			elseif(Direction == Right)then
				CurrentTile = Hard2
				
			elseif(Direction == Down)then
				CurrentTile = Easy2
			end
		
		--------------------
		-- Sound Actions
		--------------------
		elseif(CurrentTile == Sound)then
			
			if(Direction == Down)then
				CurrentTile = Main
			end		
			
		---------------------
		-- Store Actions
		---------------------
		
		elseif(CurrentTile == Extras)then
			if(Direction == Down)then
				CurrentTile = Sound
				PurchaseButton.isVisible = false
				DisplayPoints.isVisible = false
				YourPoints.isVisible = false
				Price.isVisible = false
				Quantity.isVisible = false
				StoreEnabled.isVisible = false
				StoreDisabled.isVisible = false
				unloadExtras()
				
			elseif(Direction == Left)then
				if(StoreTile ~= 11)then
					StoreTile = StoreTile + 1
					Price.isVisible = true
				end
			
			elseif(Direction == Right)then
				if(StoreTile ~= 0)then
					StoreTile = StoreTile - 1
					Price.isVisible = true
				end
			end
		elseif(CurrentTile == Powerups)then
			if(Direction == Down)then
				CurrentTile = Sound
				PurchaseButton.isVisible = false
				DisplayPoints.isVisible = false
				YourPoints.isVisible = false
				Price.isVisible = false
				Quantity.isVisible = false
				StoreEnabled.isVisible = false
				StoreDisabled.isVisible = false
				unloadPowerups()
				
			elseif(Direction == Left)then
				if(StoreTile ~= 4)then
					StoreTile = StoreTile + 1
					Price.isVisible = true
				end
			elseif(Direction == Right)then
				if(StoreTile ~= 0)then
					StoreTile = StoreTile - 1
					Price.isVisible = true
				end
			end
		elseif(CurrentTile == Themes)then
			if(Direction == Down)then
				CurrentTile = Sound
				PurchaseButton.isVisible = false
				DisplayPoints.isVisible = false
				YourPoints.isVisible = false
				Price.isVisible = false
				Quantity.isVisible = false
				StoreEnabled.isVisible = false
				StoreDisabled.isVisible = false
				unloadThemes()
				
			elseif(Direction == Left)then
				if(StoreTile ~= 4)then
					StoreTile = StoreTile + 1
					Price.isVisible = true
				end
			elseif(Direction == Right)then
				if(StoreTile ~= 0)then
					StoreTile = StoreTile - 1
					Price.isVisible = true
				end
			end
		end -- End Actions
	end -- End Checking if finger was lifted
end -- End Swipe Function
Runtime:addEventListener("touch",Swipe)

-- Store button event listeners
local function ExtrasTap(event)
	if(event.phase == "began")then
		ExtrasButton.isVisible = true
		media.playEventSound("ButtonClick.wav")
	end
	if(event.phase == "ended")then
		ExtrasButton.isVisible = false
		CurrentTile = Extras
		StoreTile = 0
		Price.isVisible = true
		DisplayPoints.isVisible = true
		YourPoints.isVisible = true
		loadExtras()
	end
end
StoreExtrasButton:addEventListener("touch",ExtrasTap)
local function PowerupsTap(event)
	if(event.phase == "began")then
		PowerUpsButton.isVisible = true
		media.playEventSound("ButtonClick.wav")
	end
	if(event.phase == "ended")then
		PowerUpsButton.isVisible = false
		CurrentTile = Powerups
		StoreTile = 0
		Price.isVisible = true
		DisplayPoints.isVisible = true
		YourPoints.isVisible = true
		loadPowerups()
	end
end
StorePowerUpsButton:addEventListener("touch",PowerupsTap)
local function ThemesTap(event)
	if(event.phase == "began")then
		ThemesButton.isVisible = true
		media.playEventSound("ButtonClick.wav")
	end 		
	if(event.phase == "ended")then
		ThemesButton.isVisible = false
		CurrentTile = Themes
		StoreTile = 0
		Price.isVisible = true
		DisplayPoints.isVisible = true
		YourPoints.isVisible = true
		loadThemes()
	end
end
StoreThemesButton:addEventListener("touch",ThemesTap)


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	Runtime:removeEventListener("enterFrame",update)
	Runtime:removeEventListener("touch",Swipe)
	Runtime:removeEventListener("touch",ThemesTap)
	Runtime:removeEventListener("touch",PowerupsTap)
	Runtime:removeEventListener("touch",ExtrasTap)
	Runtime:removeEventListener("tap",SoundTap)
	timer.cancel(tutorialtimer)
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