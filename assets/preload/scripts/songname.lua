function onCreate()
	--creates the bar's object
	makeLuaSprite('songbar','songbar',-72,522)
	addLuaSprite('songbar','true')
	setScrollFactor('songbar',0,0);
	setObjectCamera('songbar','hud');
	
	--creates the song name text
	makeLuaText('songname',songName,300,getProperty('songbar.x') + 100,560)
	addLuaText('songname')
	setTextFont('songname','fnf.ttf')
	setTextSize('songname','27')
	setTextAlignment('songname','left')
	setObjectOrder('songbar',2)
	setObjectOrder('songname',3)
	
	--runs the timer for the bar and text to move off the screen
	runTimer('sair',2.5)
	
end

--makes the bar and text move off the screen
function onTimerCompleted(sair)
	doTweenX('saindo1','songbar',-526,1,'cubeInOut')
	doTweenX('saindo2','songname',-526,1,'cubeInOut')
end