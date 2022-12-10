function to_hex(rgb)
    local hexadecimal = '' -- yeah ignore

    for key, value in pairs(rgb) do
        local hex = ''

        while (value > 0) do
            local index = math.fmod(value, 16) + 1
            value = math.floor(value / 16)
            hex = string.sub('0123456789ABCDEF', index, index) .. hex            
        end

        if (string.len(hex) == 0) then
            hex = '00'
        elseif (string.len(hex) == 1) then
            hex = '0'  ..  hex
        end

        hexadecimal = hexadecimal .. hex
    end

    return hexadecimal
end --[[ Cherry on the Psych Engine Discord showed me the script
		(If you recognized the script and know who made it please DM me)! ]]--

function lerp(a,b,t) return a * (1-t) + b * t end
-- me modifying so that the trail become invisible when disabled
-- rorutop

trailEnabledDad = false
trailEnabledGF = false
trailEnabledBF = false
timerStartedDad = false
timerStartedGF = false
timerStartedBF = false

local trailLength = (lowQuality and 3 or 5)
local trailDelay = (lowQuality and 0.5 or 0.05)

local isDefColorDad = true
local isDefColorGF = true
local isDefColorBF = true
local defaultColorDad
local defaultColorGF
local defaultColorBF
function onUpdatePost(elapsed)
	defaultColorDad = to_hex(getProperty('dad.healthColorArray'))
	defaultColorGF = 'a5004d' -- Health bar color can't be grabbed (default a5004d)
	defaultColorBF = to_hex(getProperty('boyfriend.healthColorArray'))

	-- For grabing icon color please input custom colors here.
	if gfName ~= '' then
		defaultColorGF = 'a5004d'
	--[[elseif gfName == 'example' then
		defaultColorGF = '00FFFF']]-- if you don't understand the example please tell me I'll make a video or smth idk.
	end

	if isDefColorDad == true then
		colorDad = defaultColorDad
	else
		-- Blank on Purpose
	end
	if isDefColorGF == true then
		colorGF = defaultColorGF
	else
		-- Blank on Purpose
	end
	if isDefColorBF == true then
		colorBF = defaultColorBF
	else
		-- Blank on Purpose
	end
	--debugPrint(getProperty('dad.cameras'))
end

function onEvent(name, value1, value2)

	if name == 'Toggle FlxTrail' then
		
		-- Dad
		if value1 == 'dad' and value2 == 'on' then
			if not timerStartedDad then
				runTimer('timerTrailDad', trailDelay, 0)
				timerStartedDad = true
			end
			trailEnabledDad = true
			curTrailDad = 0
		elseif value1 == 'dad' and value2 == 'off' then
			trailEnabledDad = false
		end
		
		-- GF
		if value1 == 'gf' and value2 == 'on' then
			if not timerStartedGF then
				runTimer('timerTrailGF', trailDelay, 0)
				timerStartedGF = true
			end
			trailEnabledGF = true
			curTrailGF = 0
		elseif value1 == 'gf' and value2 == 'off' then
			trailEnabledGF = false
		end
		
		-- BF
		if value1 == 'bf' and value2 == 'on' then
			if not timerStartedBF then
				runTimer('timerTrailBF', trailDelay, 0)
				timerStartedBF = true
			end
			trailEnabledBF = true
			curTrailBF = 0
		elseif value1 == 'bf' and value2 == 'off' then
			trailEnabledBF = false
		end
		
		if value1 == 'all' and value2 == 'on' then
			triggerEvent('Toggle FlxTrail', 'dad', 'on')
			triggerEvent('Toggle FlxTrail', 'gf', 'on')
			triggerEvent('Toggle FlxTrail', 'bf', 'on')
			--[[if not timerStartedDad or not timerStartedGF or not timerStartedBF then
				runTimer('timerTrailDad', trailDelay, 0)
				timerStartedDad = true
				runTimer('timerTrailGF', trailDelay, 0)
				timerStartedGF = true
				runTimer('timerTrailBF', trailDelay, 0)
				timerStartedBF = true
			end
			trailEnabledDad = true
			curTrailDad = 0
			trailEnabledGF = true
			curTrailGF = 0
			trailEnabledBF = true
			curTrailBF = 0]]
		elseif value1 == 'all' and value2 == 'off' then
			triggerEvent('Toggle FlxTrail', 'dad', 'off')
			triggerEvent('Toggle FlxTrail', 'gf', 'off')
			triggerEvent('Toggle FlxTrail', 'bf', 'off')
			--[[trailEnabledDad = false
			trailEnabledGF = false
			trailEnabledBF = false]]
		end
		
	end
	
	if name == 'Change FlxTrail Color' then
		
		-- Dad
		if value1 == 'dad' and value2 == 'default' then
			isDefColorDad = true
		elseif value1 == 'dad' and value2 ~= 'default' then
			isDefColorDad = false
			
			-- GF
		elseif value1 == 'gf' and value2 == 'default' then
			isDefColorGF = true
		elseif value1 == 'gf' and value2 ~= 'default' then
			isDefColorGF = false
			
			-- BF
		elseif value1 == 'bf' and value2 == 'default' then
			isDefColorBF = true
		elseif value1 == 'bf' and value2 ~= 'default' then
			isDefColorBF = false
		end
		
		-- Took forever to work properly
		if value1 == 'dad' then
			colorDad = value2
		elseif value1 == 'gf' then
			colorGF = value2
		elseif value1 == 'bf' then
			colorBF = value2
		end
		
	end

end

function onCountdownTick(counter)
	if counter == 0 then
		triggerEvent('Change FlxTrail Color', 'dad', 'default')
		triggerEvent('Change FlxTrail Color', 'gf', 'default')
		triggerEvent('Change FlxTrail Color', 'bf', 'default')
	end
end

function onSongEnd()
	triggerEvent('Toggle FlxTrail', 'all', 'off')
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'timerTrailDad' then
		createTrailFrame('Dad')
	elseif tag == 'timerTrailGF' then
		createTrailFrame('GF')
	elseif tag == 'timerTrailBF' then
		createTrailFrame('BF')
	end
end

curTrailDad = 0
curTrailGF = 0
curTrailBF = 0
local missedBF
local missedGF
function createTrailFrame(tag)
	num = 0
	color = -1
	image = ''
	frame = 'BF idle dance'
	x = 0
	y = 0
	scaleX = 0
	scaleY = 0
	scrollX = 0
	scrollY = 0
	offsetX = 0
	offsetY = 0
	flipX = false
	flipY = false
	alpha = 0.6
	visible = true
	--cam = ''
	antialiasing = false

	if colorDad == 'default' then
		colorDad = defaultColorDad
	elseif colorGF == 'default' then
		colorGF = defaultColorGF
	elseif colorBF == 'default' then
		colorBF = defaultColorBF
	end

	local bfOrder = getObjectOrder('boyfriendGroup')
	local gfOrder = getObjectOrder('gfGroup')
	local dadOrder = getObjectOrder('dadGroup')
	if tag == 'BF' then
		num = curTrailBF
		curTrailBF = curTrailBF + 1
		if trailEnabledBF then
			setObjectOrder('psychicTrail', bfOrder)
			color = getColorFromHex(colorBF)
			image = getProperty('boyfriend.imageFile')
			frame = getProperty('boyfriend.animation.frameName')
			x = getProperty('boyfriend.x')
			y = getProperty('boyfriend.y')
			scaleX = getProperty('boyfriend.scale.x')
			scaleY = getProperty('boyfriend.scale.y') 
			scrollX = getProperty('boyfriend.scrollFactor.x')
			scrollY = getProperty('boyfriend.scrollFactor.y')
			offsetX = getProperty('boyfriend.offset.x')
			offsetY = getProperty('boyfriend.offset.y')
			flipX = getProperty('boyfriend.flipX')
			flipY = getProperty('boyfriend.flipY')
			antialiasing = getProperty('boyfriend.antialiasing')
		end
	elseif tag == 'GF' then
		num = curTrailGF
		curTrailGF = curTrailGF + 1
		if trailEnabledGF then
			setObjectOrder('psychicTrail', gfOrder)
			color = getColorFromHex(colorGF)
			image = getProperty('gf.imageFile')
			frame = getProperty('gf.animation.frameName')
			x = getProperty('gf.x')
			y = getProperty('gf.y')
			scaleX = getProperty('gf.scale.x')
			scaleY = getProperty('gf.scale.y')
			scrollX = getProperty('gf.scrollFactor.x')
			scrollY = getProperty('gf.scrollFactor.y')
			offsetX = getProperty('gf.offset.x')
			offsetY = getProperty('gf.offset.y')
			flipX = getProperty('gf.flipX')
			flipY = getProperty('gf.flipY')
			antialiasing = getProperty('gf.antialiasing')
		end
	elseif tag == 'Dad' then
		num = curTrailDad
		curTrailDad = curTrailDad + 1
		if trailEnabledDad then
			setObjectOrder('psychicTrail', dadOrder)
			color = getColorFromHex(colorDad)
			image = getProperty('dad.imageFile')
			frame = getProperty('dad.animation.frameName')
			x = getProperty('dad.x')
			y = getProperty('dad.y')
			scaleX = getProperty('dad.scale.x')
			scaleY = getProperty('dad.scale.y')
			scrollX = getProperty('dad.scrollFactor.x')
			scrollY = getProperty('dad.scrollFactor.y')
			offsetX = getProperty('dad.offset.x')
			offsetY = getProperty('dad.offset.y')
			flipX = getProperty('dad.flipX')
			flipY = getProperty('dad.flipY')
			antialiasing = getProperty('dad.antialiasing')
		end
	end
	
	if num - trailLength + 1 >= 0 then
		for i = (num - trailLength + 1), (num - 1) do
			setProperty('psychicTrail' .. tag .. i .. '.alpha', getProperty('psychicTrail' .. tag .. i .. '.alpha') - ((tag == 'BF' and missedBF == true) and 2 or (tag == 'GF' and missedGF == true) or trailLength * 0.01))
		end
	end
	if not trailEnabledDad then
		for i = 0, curTrailDad do
			setProperty('psychicTrail' .. tag .. i .. '.alpha', getProperty('psychicTrail' .. tag .. i .. '.alpha') - ((tag == 'BF' and missedBF == true) and 2 or (tag == 'GF' and missedGF == true) or trailLength * 0.01))
		end
	end
	removeLuaSprite('psychicTrail' .. tag .. (num - trailLength))
	
	if not (image == '') then
		trailTag = 'psychicTrail' .. tag .. num
		makeAnimatedLuaSprite(trailTag, image, x, y)
		setProperty(trailTag .. '.offset.x', offsetX)
		setProperty(trailTag .. '.offset.y', offsetY)
		setProperty(trailTag .. '.scale.x', scaleX)
		setProperty(trailTag .. '.scale.y', scaleY)
		setProperty(trailTag .. '.flipX', flipX)
		setProperty(trailTag .. '.flipY', flipY)
		setProperty(trailTag .. '.antialiasing', antialiasing)
		setProperty(trailTag .. '.alpha', 0.6)
		setProperty(trailTag .. '.color', color)
		setScrollFactor(trailTag, scrollX, scrollY)
		setObjectOrder(trailTag, ((tag == 'BF' and bfOrder - 0.1) or (tag == 'GF' and gfOrder - 0.1) or (tag == 'Dad' and dadOrder - 0.1)))
		setBlendMode(trailTag, 'add')
		addAnimationByPrefix(trailTag, 'stuff', frame, 0, false)
		addLuaSprite(trailTag, false)
	end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
	missedBF = false
	if noteType == 'GF Sing' or gfSection == true then
		missedGF = false
	end
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'GF Sing' or gfSection == true then
		missedGF = false
	end
end

function noteMiss(id, noteData, noteType, isSustainNote)
	missedBF = true
	if noteType == 'GF Sing' or gfSection == true then
		missedGF = false
	end
end