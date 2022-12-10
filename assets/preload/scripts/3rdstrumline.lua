--[[
	CREDITS:
		- ShadowMario: made a multi-character script (from which I took animation offset)
		- Superpowers04: Helped with optimizing some code
		- MorenoTheCappuccinoChugger: Helped with note syncing (previous version on my youtube channel was off-sync)
		- BombasticTom (that's me!): Did most of the code.
--]]

animationsList = {}

local defaultstrumy
local songPosition

local safeZoneOffset

local isStrummin = false

local player3 = 'hoodie' -- Change this to your LUA character

function makeAnimationList(object)
	animationsList[0] = 'keyArrow' -- idle
	animationsList[1] = 'keyConfirm' -- key confirmed
	animationsList[2] = 'keyPressed' -- key miss
end

offsets = {};

function makeOffset(object)
	offsets[0] = {x=36, y=36}
	offsets[1] = {x=63, y=59}
	offsets[2] = {x=34, y=34}
end

function onCreatePost()

	safeZoneOffset = getPropertyFromClass('Conductor', 'safeZoneOffset') / 10

	defaultstrumy = 50

	if not downscroll then
		defaultstrumy = screenHeight - 150
	end

	directions = {'left', 'down', 'up', 'right'}
	
	makeAnimationList('strum')
	makeOffset('strum')

	for i=1, #directions do
		makeAnimatedLuaSprite('strum'..directions[i], 'NOTE_assets', getPropertyFromGroup('opponentStrums', i-1, 'x') + 322 --[[ screenWidth / 2 - 2*177 + 105 * i--]], defaultstrumy)

		addAnimationByPrefix('strum'..directions[i], 'keyConfirm', directions[i]..' confirm', 24, false)
		addAnimationByPrefix('strum'..directions[i], 'keyPressed', directions[i]..' press', 24, false)
		addAnimationByPrefix('strum'..directions[i], 'keyArrow', 'arrow'..directions[i]:upper(), 24, false)

		setObjectCamera('strum'..directions[i], 'camHUD')
		scaleObject('strum'..directions[i], 0.68, 0.68)
		
		setProperty('strum'..directions[i]..'.alpha', 0)
		
		addLuaSprite('strum'..directions[i])

		if middlescroll then
			setProperty('strum'..directions[i]..'.visible', false)
		end

		playAnimation('strum'..directions[i], 0, true)
	end
end

function playAnimation(characterName, animId, forced) -- thank you shadowmario :imp:
	-- 0 = keyArrow
	-- 1 = keyConfirm
	-- 2 = keyPressed

	local animName = animationsList[animId]

	objectPlayAnimation(characterName, animName, forced); -- this part is easily broke if you use objectPlayAnim (I have no idea why its like this)
	
	setProperty(characterName..'.offset.x', offsets[animId].x);
	setProperty(characterName..'.offset.y', offsets[animId].y);
	
	if animId == 1 then
		runTimer('stopanim'..characterName, 0.1)
	end
end

function onTimerCompleted(tag)
	if(string.sub(tag,1,8) == "stopanim") then
        	playAnimation(string.sub(tag,9), 0, true)
    	end
end

function onBeatHit()
	if curBeat%2 == 0 then
		objectPlayAnimation(player3, 'idle', true)
		setProperty(player3..'.offset.x', 0)
		setProperty(player3..'.offset.y', 0)
	end
end

function onUpdatePost()

	setProperty('iconP1.x', screenWidth - 160)
	setProperty('iconP2.x', 0)

	songPosition = getPropertyFromClass('Conductor', 'songPosition')

	-- NOTE: IF YOU WANT TO ADD STUFF THAT'LL UPDATE ONUPDATEPOST, PUT THEM BEFORE THE GAME COUNTS ALL 3RD STRUM NOTES

	for i=0, getProperty('notes.length')-1 do
		if getPropertyFromGroup('notes', i, 'noteType') == 'plr3' then

			if not isStrummin then
				return
			end	

			local noteX = getPropertyFromGroup('notes', i, 'x');
			local noteY = getPropertyFromGroup('notes', i, 'y');

			setPropertyFromGroup('notes', i, 'ignoreNote', true)	

			hitbox = 45;
			local isSustainNote = getPropertyFromGroup('notes', i, 'isSustainNote');
			
			local noteData = getPropertyFromGroup('notes', i, 'noteData');
			
			strumY = getProperty('strum'..directions[noteData + 1]..'.y')	

			noteX = getProperty('strum'..directions[noteData + 1]..'.x')
			local noteStrumTime = getPropertyFromGroup('notes', i, 'strumTime')
			
			local hitMult = 1
			if isSustainNote then
				noteX = noteX + 37;
				hitMult = 0.5
			end

			if downscroll then
				noteY = strumY + 0.45 * (songPosition - noteStrumTime) * getProperty('songSpeed')
			else
				noteY = strumY - 0.45 * (songPosition - noteStrumTime) * getProperty('songSpeed')
			end
			
			setPropertyFromGroup('notes', i, 'x', noteX)
			setPropertyFromGroup('notes', i, 'y', noteY)
			
			if (noteStrumTime > songPosition - safeZoneOffset and noteStrumTime < songPosition + (safeZoneOffset * hitMult)) then
				removeFromGroup('notes', i)
				playAnimation('strum'..directions[noteData+1], 1, false)

				objectPlayAnimation(player3, 'sing'..directions[noteData+1]:upper(), true);
				setProperty(player3..'.offset.x', offsets[player3]['sing'..directions[noteData+1]:upper()].x)
				setProperty(player3..'.offset.y', offsets[player3]['sing'..directions[noteData+1]:upper()].y)
			end
			
		end
	end
end

function tobool(val)
	if val:lower() =='true' then
		return true
	else
		return false
	end
end

function onEvent(n, v1, v2)
	if n == '3rdstrum' then
		isStrummin = tobool(v1)
		if tobool(v1) then
			for strum=1, #directions do
				if downscroll then 
					setProperty('strum'..directions[strum]..'.y', defaultstrumy-50) 
				else 
					setProperty('strum'..directions[strum]..'.y', defaultstrumy+50) 
				end
			
				doTweenY('strumTweening'..strum, 'strum'..directions[strum], defaultstrumy, 0.35 + 0.1*strum, 'quadInOut')
				doTweenAlpha('strumAlphaTweening'..strum, 'strum'..directions[strum], 1, 0.35 + 0.05*strum, 'easeInOut')
			end
		else
			for strum=1, #directions do
				if downscroll then
					doTweenY('strumTweening'..strum, 'strum'..directions[math.abs(strum-5)], defaultstrumy-100, 0.35 + 0.1*strum, 'quadInOut')
				else
					doTweenY('strumTweening'..strum, 'strum'..directions[math.abs(strum-5)], defaultstrumy+100, 0.35 + 0.1*strum, 'quadInOut')
				end
				doTweenAlpha('strumAlphaTweening'..strum, 'strum'..directions[math.abs(strum-5)], 0, 0.35 + 0.05*strum, 'easeInOut')
				
			end
		end
	end
end