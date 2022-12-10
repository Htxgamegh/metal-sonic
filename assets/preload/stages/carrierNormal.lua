function onCreate()
	-- background shit
	makeLuaSprite('stageback', 'background/eggcarriernormalbg', -1300, -700);
	setScrollFactor('stageback', 0.79, 0.9);
	
	makeLuaSprite('stagefront', 'background/eggcarriernormalfg', -1300, -700);
	setScrollFactor('stagefront', 0.9, 1);

	addLuaSprite('stageback', false);
	addLuaSprite('stagefront', false);
	
end