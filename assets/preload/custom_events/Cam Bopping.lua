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
local camBopNum = 0
local zoomBeat = 0
local bool = false
function onEvent(name, value1, value2)
    if name == 'Cam Bopping' then
        local array1 = mysplit(value1, ',')
        if string.lower(array1[2]) ~= 'instant' then
            zoomBeat = tonumber(array1[1])
            camBopNum = tonumber(array1[3]);
        else
            bopInstant(tonumber(array1[1]))
        end
        if value2 == 'true' then
            bool = true
        else
            bool = false
        end
    end
end

function bop()
    setPropertyFromClass('flixel.FlxG', 'camera.zoom', getPropertyFromClass('flixel.FlxG', 'camera.zoom') + zoomBeat)
    setProperty('camHUD.zoom', zoomBeat / 2 + getProperty('camHUD.zoom'))
end

function bopInstant(zoomVal)
    if getProperty('camZooming') then
        setPropertyFromClass('flixel.FlxG', 'camera.zoom', getPropertyFromClass('flixel.FlxG', 'camera.zoom') + zoomVal )
        setProperty('camHUD.zoom', zoomVal / 2 + getProperty('camHUD.zoom'))
    end
end

function onStepHit()
    dumCam = math.floor(camBopNum * 4)
    if curStep % dumCam == 0 and getProperty('camZooming') and bool then
        bop()
    end
end