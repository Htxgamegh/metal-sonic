local placements = {
    {'Steel-Plated', -800, -200},
    {'Error', -800, -200},
    {'Tutorial-sunset', -1000, -100}
} 
-- 1: SONG NAME
-- 2. X AXIS POS
-- 3. Y AXIS POS

function lerp(a,b,t) return a * (1-t) + b * t end

local w = 0
local originY = 0

function mysplit (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

local bopNum = 0
local heightBeat = 1255

local randomColor = {}
local calledColor = {}

function onCreate()
    local song = string.lower(songName)
    for i = 1, #placements do
        if song == string.lower(placements[i][1]) then
            makeLuaSprite('gradient','background/gradiento',placements[i][2],placements[i][3])
        end
    end
    setGraphicSize(getProperty('gradient.width') * 3, getProperty('gradient.height') * 2)
    addLuaSprite('gradient', true)
    w = getProperty('gradient.width')
    originY = getProperty('gradient.y')
    --setObjectOrder('gradient',getObjectOrder('gfGroup') - 0.5)
    setProperty('gradient.alpha', 0)

    randomColor = {getColorFromHex('ffff3d'), getColorFromHex('fa4848'), getColorFromHex('ff3072')}
    calledColor = {'ffff3d', 'fa4848','ff3072'}
end
local color = ''
local valuetwo = false
local enabledInstantShit = false

local boolArrays = {['isBump'] = false, ['isOpacity'] = false, ['addColorToArray'] = false, ['removeColorFromArray'] = false, ['callColorFromArray'] = false,['turnOffGradient'] = false}

function switchGradient(switch)
    for i,v in pairs(switch) do
        boolArrays[v] = not boolArrays[v]
    end
    if boolArrays['callColorFromArray'] then
        for i = 1, #calledColor do
            debugPrint('Color '..i..': '..calledColor[i])
        end
        boolArrays['callColorFromArray'] = false
    end
end

function changeGradientColor(color)
    for i,v in pairs(color) do
        if boolArrays['addColorToArray'] then
            table.insert(randomColor, getColorFromHex(v))
            table.insert(calledColor, v)
        elseif boolArrays['removeColorFromArray'] then
            table.remove(randomColor, tonumber(v))
            table.remove(calledColor, tonumber(v))
        end
    end
    boolArrays['addColorToArray'] = false
    boolArrays['removeColorFromArray'] = false
end


function onEvent(name, value1, value2)
    if name == 'Gradient Bop' then
        shid = mysplit(tostring(value2), "'")
        local array1 = mysplit(value1, ',')
        if array1[2] ~= nil then
        switchGradient(mysplit(tostring(array1[2]), "'"))
        changeGradientColor(mysplit(tostring(value2), ','))
        end
            if array1[3] ~= nil then
                if string.len(value2) < 1 then
                    valuetwo = false
                else
                    valuetwo = true
                    color = shid[1]
                end
                heightBeat = tonumber(array1[1])
                bopNum = tonumber(array1[3]);
            else
                if not (boolArrays['addColorToArray'] or boolArrays['removeColorFromArray'] or boolArrays['callColorFromArray']) then
                if array1[1] ~= nil then
                    local boole = false
                    if string.len(value2) < 1 then
                        boole = false
                    else
                        boole = true
                    end
                    enabledInstantShit = true
                    bopInstant(tonumber(array1[1]),boole,shid[1])
                end
                end
            end
    end
end

function bop()
if getPropertyFromClass('ClientPrefs','flashing') then
    setGraphicSize('gradient',w * 2, heightBeat)
    setProperty('gradient.y', originY - (heightBeat - 1255))
    setProperty('gradient.alpha', 1)
    if (not boolArrays['addColorToArray'] or not boolArrays['removeColorFromArray'] or not boolArrays['callColorFromArray']) then
        if (valuetwo == false) then
            random = getRandomInt(1, #randomColor)
            setProperty('gradient.color', randomColor[random])
        else
            newhex = getColorFromHex(color)
            setProperty('gradient.color',newhex)
        end
    end
end
end

function bopInstant(heightVal, val, curcolor)
    if getPropertyFromClass('ClientPrefs','flashing') then
        setGraphicSize('gradient',w * 2, heightVal)
        setProperty('gradient.y', originY - (heightVal - 1255))
        setProperty('gradient.alpha', 1)
        if (not boolArrays['addColorToArray'] or not boolArrays['removeColorFromArray'] or not boolArrays['callColorFromArray']) then
            if (val == false) then
                random = getRandomInt(1, #randomColor)
                setProperty('gradient.color', randomColor[random])
            else
                setProperty('gradient.color',getColorFromHex(curcolor))
            end
        end
        runTimer('disableInstantShit', stepCrochet * 0.0008)
    end
end

function onStepHit()
    num = math.floor(bopNum * 4)
    if curStep % num == 0 and not enabledInstantShit then
        bop()
    end
end

function onUpdate(elapsed)
    if boolArrays['isBump'] then
        setGraphicSize('gradient',w * 2, lerp(getProperty('gradient.height'), 5, elapsed * 3))
        setProperty('gradient.y', lerp(getProperty('gradient.y'), originY + 1250, elapsed * 3))
    end
    if boolArrays['isOpacity'] then
        setProperty('gradient.alpha', lerp(getProperty('gradient.alpha'), 0, elapsed * 4))
    end
    if boolArrays['turnOffGradient'] then
        if getProperty('gradient.alpha') ~= (0 or nil) then
            setProperty('gradient.alpha',0)
        else
            boolArrays['turnOffGradient'] = false
        end
    end
end

function onTimerCompleted(tag)
    if tag == 'disableInstantShit' then
        enabledInstantShit = false
    end
end