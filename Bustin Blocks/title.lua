----------------------------------------------------------------------------------
--
-- title.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

----------------------------------------------------------------------------------
-- 
--	NOTE:
--	
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	--display.setDefault("fillColor",0,0,0)
	number = 0
	Title = {}
	Title[0] = display.newImage("title0.png",true)
	Title[1] = display.newImage("title1.png",true)
	Title[2] = display.newImage("title2.png",true)
	Title[3] = display.newImage("title3.png",true)
	Title[4] = display.newImage("title4.png",true)
	Title[5] = display.newImage("title5.png",true)
	Title[6] = display.newImage("title6.png",true)
	Title[7] = display.newImage("title7.png",true)
	Title[8] = display.newImage("title8.png",true)
	Title[9] = display.newImage("title9.png",true)
	Title[10] = display.newImage("title10.png",true)
	Title[11] = display.newImage("title11.png",true)
	Title[12] = display.newImage("title12.png",true)
	Title[13] = display.newImage("title13.png",true)
	Title[14] = display.newImage("title14.png",true)
	Title[15] = display.newImage("title15.png",true)
	group:insert(Title[0])
	for i = 1,15 do
		group:insert(Title[i])
		Title[i].isVisible = false
	end
	
	function move(event)

		Title[number].isVisible = false
		Title[number+1].isVisible = true
		number = number+1
		
		if(number == 15)then
			for i = 0,14 do
				Title[i].isVisible = false
			end
			Title[15].isVisible = true
			storyboard.gotoScene("menu")
		end

	end
	thetimer = timer.performWithDelay(80,move,15)
	
	function tapperthing(event)
		for i = 0,14 do
			Title[i].isVisible = false
		end
		Title[15].isVisible = true
		storyboard.gotoScene("menu")
	end
	Runtime:addEventListener("tap",tapperthing)
end

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
	Runtime:removeEventListener("tap",tapperthing)
	timer.cancel(thetimer)
	for i = 0,15 do
		Title[i] = nil
	end
	number = nil
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