function onCreatePost()
	-- background shit
	makeLuaSprite('stageback', 'background/eggcarriererrorbg', -1300, -700);
	setScrollFactor('stageback', 0.79, 0.9);
	
	makeLuaSprite('stagefront', 'background/eggcarriererrorfg', -1300, -700);
	setScrollFactor('stagefront', 0.9, 1);

	makeLuaSprite('blackgradient', 'background/black', 0, 0);
	setObjectCamera('blackgradient','hud')

	addLuaSprite('stageback', false);
	addLuaSprite('stagefront', false);
	if getPropertyFromClass('ClientPrefs','flashing') then
	addLuaSprite('blackgradient',true)
	end
	
end