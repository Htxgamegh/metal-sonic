function onCreate()
	-- background shit
	-- -1300 -800
	makeLuaSprite('sky1', 'background/sky1', -1300, -800);
	setScrollFactor('sky1', 0.5, 0.5);
	--setGraphicSize('sky1', getProperty('sky1.width') * 6, getProperty('sky1.height') * 6)
	setScrollFactor('water', 0.9, 0.9);
	makeLuaSprite('water', 'background/water', -1300, -800);
	--setGraphicSize('water', getProperty('water.width') * 6, getProperty('water.height') * 6)

	makeLuaSprite('cliff', 'background/cliff', -1300, -800);
	--setGraphicSize('cliff', getProperty('cliff.width') * 6, getProperty('cliff.height') * 6)

	makeLuaSprite('gradient', 'background/gradiento', -1300, 0);
	setGraphicSize('gradient', getProperty('gradient.width') * 1.2, getProperty('gradient.height') * 1.2)
	setScrollFactor('gradient', 0.1, 0.1);
	setProperty('gradient.alpha', 0)
	addLuaSprite('sky1', false);
	addLuaSprite('water', false);
	addLuaSprite('cliff', false);
	addLuaSprite('gradient', true);
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end