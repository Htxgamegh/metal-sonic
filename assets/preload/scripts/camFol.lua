local charName = {}
local charPosX = {}
local charPosY = {}
local xx = 0
local yy = 0
local xx2 = 0
local yy2 = 0
local fastenCam = true
local dadZoom = 0
local bfZoom = 0
local offseto = 20

function onCreate()
    setPropertyFromClass('flixel.FlxG','save.data.getZOOM', getProperty('defaultCamZoom'))
    setPropertyFromClass('flixel.FlxG','save.data.dadzoomer', getProperty('defaultCamZoom') - 0.1)
    setPropertyFromClass('flixel.FlxG','save.data.bfzoomer', getProperty('defaultCamZoom') + 0.05)
    setPropertyFromClass('flixel.FlxG','save.data.setFollowBool', true)

    if fastenCam then
        setProperty('cameraSpeed', 2)
    end
end
function makePos()
    charName[1] = 'gf_sunset'
    charName[2] = 'bf_sunset'
    charName[3] = 'bf'
    charName[4] = 'metalsonic'
    charName[5] = 'brokenmetal'

    charPosX[1] = getProperty('dad.x') + 310
    charPosX[2] = getProperty('boyfriend.x') + 90
    charPosX[3] = getProperty('boyfriend.x') + 90
    charPosX[4] = getProperty('dad.x') + 350
    charPosX[5] = getProperty('dad.x') + 350

    charPosY[1] = getProperty('dad.y') + 200;
    charPosY[2] = getProperty('boyfriend.y') + 80;
    charPosY[3] = getProperty('boyfriend.y') + 80;
    charPosY[4] = getProperty('dad.y') + 400;
    charPosY[5] = getProperty('dad.y') + 350;
end

function onUpdate(elapsed)
    setProperty('camZooming', true);
makePos()
for i = 0,#charName do
    if dadName == charName[i] then
        xx = charPosX[i]
        yy = charPosY[i]
    end
    if boyfriendName == charName[i] then
        xx2 = charPosX[i]
        yy2 = charPosY[i]
    end
end
    -- HAHA STOELN FROM VANDALIZATION
    if getPropertyFromClass('flixel.FlxG','save.data.setFollowBool') then
    if mustHitSection == false then
        setProperty('defaultCamZoom', getPropertyFromClass('flixel.FlxG','save.data.dadzoomer'))
        if getProperty('dad.animation.curAnim.name') == 'singLEFT' then
        triggerEvent('Camera Follow Pos',xx-offseto,yy)
        elseif getProperty('dad.animation.curAnim.name') == 'singRIGHT' then
        triggerEvent('Camera Follow Pos',xx+offseto,yy)
        elseif getProperty('dad.animation.curAnim.name') == 'singUP' then
        triggerEvent('Camera Follow Pos',xx,yy-offseto)
        elseif getProperty('dad.animation.curAnim.name') == 'singDOWN' then
        triggerEvent('Camera Follow Pos',xx,yy+offseto)
        elseif getProperty('dad.animation.curAnim.name') == 'singLEFT-alt' then
        triggerEvent('Camera Follow Pos',xx-offseto,yy)
        elseif getProperty('dad.animation.curAnim.name') == 'singRIGHT-alt' then
        triggerEvent('Camera Follow Pos',xx+offseto,yy)
        elseif getProperty('dad.animation.curAnim.name') == 'singUP-alt' then
        triggerEvent('Camera Follow Pos',xx,yy-offseto)
        elseif getProperty('dad.animation.curAnim.name') == 'singDOWN-alt' then
        triggerEvent('Camera Follow Pos',xx,yy+offseto)
        else
        triggerEvent('Camera Follow Pos',xx,yy)
        end
        else
        setProperty('defaultCamZoom',  getPropertyFromClass('flixel.FlxG','save.data.bfzoomer'))
        if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
        triggerEvent('Camera Follow Pos',xx2-offseto,yy2)
        elseif getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
        triggerEvent('Camera Follow Pos',xx2+offseto,yy2)
        elseif getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
        triggerEvent('Camera Follow Pos',xx2,yy2-offseto)
        elseif getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
        triggerEvent('Camera Follow Pos',xx2,yy2+offseto)
        else
        triggerEvent('Camera Follow Pos',xx2,yy2)
        end
    end
end
    -- end --
end