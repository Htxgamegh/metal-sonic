
function createBox(name,x,y,width,height,color,alpha,cam)
    local succ,err = pcall(function()
        makeLuaSprite(name,'',x,y)
        makeGraphic(name,width,height,color)
        setProperty(name..'.alpha', alpha)
        addLuaSprite(name,true)
        setObjectCamera(name,cam)
        -- debugPrint(name..' has been created')
    end)
    if not succ then debugPrint(err) end
end

function tweenBox(name,alpha, dur,ease)
    local succ,err = pcall(function()
        doTweenAlpha(name..'tween',name,alpha,dur,ease)
        -- debugPrint(name..' has been tweened')
    end)
    if not succ then debugPrint(err) end
end
local curCountdown = ''
local countdownArray = {'ready','set','go'}

function createCountdown(num)
    local succ,err = pcall(function()
        makeLuaSprite(countdownArray[num],countdownArray[num], 0, 0)
    addLuaSprite(countdownArray[num], true)
    setObjectCamera(countdownArray[num], 'hud')
    curCountdown = countdownArray[num]
    runTimer(countdownArray[num]..'timer',stepCrochet*0.002)
    screenCenter(countdownArray[num])
    end)
    if not succ then debugPrint(err) end
end

function onTimerCompleted(tag)
    if tag == curCountdown..'timer' then
        doTweenAlpha('h'..curCountdown,curCountdown,0,stepCrochet*0.002)
    end
end

-- now
local beatFloat = 0

function onCreatePost()
    luaDebugMode = true
    beatFloat = crochet
    createBox('blackbox',0,0,1600,1200,'000000',1,'hud')
    local succ,err = pcall(function()
        tweenBox('blackbox',0,6)
    end)
    if not succ then debugPrint(err) end
end

local curCamZoom = 0

function onCreate()
    curCamZoom = getProperty('defaultCamZoom')
    setProperty("skipCountdown",true)
end

function onSongStart()
    setProperty('defaultCamZoom', 1)
end

local curbeatArray =        {32,64,66,80,140,272,328,336,464,520,524,560,576,592,624,652}
local curbeatTweenArray =   {32,64,66,68,72,76,80,140,144,272,328,332,336,464,520,524,524,528,560,576,592,624,652,656}

-- HARDCODING
local boxArray = {
    {'whitbox',0,0,1600,1200,'ffffff',1,'hud'},
    {'whitbox',0,0,1600,1200,'ffffff',1,'hud'},
    {'warningbox',-700,-300,3000,1500,'FF0000',0,'game'},
    {'warningbox',0,-0,1600,1200,'FF0000',1,'hud'},
    {'whitbox',-700,-300,3000,1500,'ffffff',0,'game'},
    {'blackebox',0,0,1600,1200,'000000',1,'hud'},
    {'warningbox',-700,-300,3000,1500,'FF0000',0,'game'},
    {'whitbox',0,0,1600,1200,'ffffff',1,'hud'},
    {'whitbox',0,0,1600,1200,'ffffff',1,'hud'},
    {'blackebox',0,0,1600,1200,'000000',0,'hud'},
    {'whitbox',0,0,1600,1200,'ffffff',0,'hud'},
    {'whitbox',0,0,1600,1200,'ffffff',1,'hud'},
    {'whitbox',-700,-300,3000,1500,'ffffff',0,'game'},
    {'whitbox',0,0,1600,1200,'ffffff',1,'hud'},
    {'blackebox',0,0,1600,1200,'000000',1,'hud'},
    {'whitbox',-700,-300,3000,1500,'ffffff',0,'game'}
}
local tweenArray = {
    {'whitbox',0,1},
    {'whitbox',0,1},
    {'warningbox',0.5,1,'circInOut'},
    {'warningbox',0,1,'circInOut'},
    {'warningbox',0.5,1,'circInOut'},
    {'warningbox',0,1,'circInOut'},
    {'warningbox',0,2},
    {'whitbox',1,1},
    {'whitbox',0,2},
    {'blackebox',0,1.5},
    {'warningbox',0.5,1.2,'circInOut'},
    {'warningbox',0,1.2,'circInOut'},
    {'whitbox',0,1},
    {'whitbox',0,1},
    {'blackebox',0.6,1},
    {'blackebox',0,1},
    {'whitbox',1,1.2},
    {'whitbox',0,2},
    {'whitbox',0,4},
    {'whitbox',1,4},
    {'whitbox',0,2},
    {'blackebox',0,2},
    {'whitbox',1,1},
    {'whitbox',0,2}
}

function lerp(a,b,t) return a * (1-t) + b * t end

function onBeatHit()
    if curBeat >= 671 then -- 671
        endSong(false)
        addHaxeLibrary('MusicBeatState')
        addHaxeLibrary('CreditsState')
        addHaxeLibrary('FlxG','flixel')
        runHaxeCode([[
            FlxG.sound.playMusic(Paths.music('freakyMenu'));
            MusicBeatState.switchState(new CreditsState());
            ]]);
    end
    if curBeat >= 29 and curBeat <= 31 then
        for i = 1,3 do
            if curBeat == 28 + i then
                createCountdown(i)
            end
        end
    end

if getPropertyFromClass('ClientPrefs','flashing') then
    for beat = 1, #curbeatArray do
        if curbeatArray[beat] == curBeat then
            createBox(boxArray[beat][1],boxArray[beat][2],boxArray[beat][3],boxArray[beat][4],boxArray[beat][5],boxArray[beat][6],boxArray[beat][7],boxArray[beat][8])
        end
    end

    for beat = 1, #curbeatTweenArray do
        if curbeatTweenArray[beat] == curBeat then
            tweenBox(tweenArray[beat][1],tweenArray[beat][2],tweenArray[beat][3])
        end
    end

    if curbeatArray[1] == curBeat or curbeatArray[8] == curBeat then
        setProperty('blackgradient.visible',false)
    elseif curbeatArray[6] == curBeat or curBeat == 592 then
        setProperty('blackgradient.visible',true)
    end
end
end

function onUpdatePost(elapsed)
    if curBeat >= 32 then
        songPos = getPropertyFromClass('Conductor', 'songPosition');
        currentBeat = (songPos / 1000) * (bpm / 30)
        setPropertyFromClass('flixel.FlxG','save.data.getZOOM', 0.78 + 0.05 * math.sin((currentBeat*0.25)*math.pi))
        setPropertyFromClass('flixel.FlxG','save.data.dadzoomer', getPropertyFromClass('flixel.FlxG','save.data.getZOOM') - 0.1)
        setPropertyFromClass('flixel.FlxG','save.data.bfzoomer', getPropertyFromClass('flixel.FlxG','save.data.getZOOM') + 0.05)
    elseif curBeat >= 28 and curBeat <= 32 then
        setPropertyFromClass('flixel.FlxG','save.data.getZOOM', 0.6)
        setPropertyFromClass('flixel.FlxG','save.data.dadzoomer', getPropertyFromClass('flixel.FlxG','save.data.getZOOM') - 0.1)
        setPropertyFromClass('flixel.FlxG','save.data.bfzoomer', getPropertyFromClass('flixel.FlxG','save.data.getZOOM') + 0.05)
    else
        setPropertyFromClass('flixel.FlxG','save.data.getZOOM', 0.9)
        setPropertyFromClass('flixel.FlxG','save.data.dadzoomer', getPropertyFromClass('flixel.FlxG','save.data.getZOOM') - 0.1)
        setPropertyFromClass('flixel.FlxG','save.data.bfzoomer', getPropertyFromClass('flixel.FlxG','save.data.getZOOM') - 0.2)
    end
end