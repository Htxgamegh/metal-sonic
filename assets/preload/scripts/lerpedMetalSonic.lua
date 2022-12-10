function lerp(a,b,t) return a * (1-t) + b * t end

local function outCirc(t, b, c, d)
    t = t / d - 1
    return(c * math.sqrt(1 - math.pow(t, 2)) + b)
  end

local anims = {'idle','singLEFT', 'singDOWN', 'singUP', 'singRIGHT'}
local animNumX = {}
local animNumY = {}

function onCreatePost()
    local succ,err = pcall(function()
        dadX = getProperty('dad.x')
        dadY = getProperty('dad.y')
        animNumX = {dadX ,dadX - 80, dadX, dadX, dadX + 100}
        animNumY = {dadY ,dadY, songName ~= 'error' and (dadY + 150) or dadY + 20, dadY - 150, dadY}
    end)
    if not succ then debugPrint(err) end

end
local enable = false
function opponentNoteHit(id, dir, nt, sus)
    if not sus then
    enable = true
    runTimer('disable',songName ~= 'error' and stepCrochet*0.0007 or stepCrochet*0.0012)
    end
end

function onTimerCompleted(tag)
    if tag == 'disable' then
        enable = false
    end
end

function lerpMovement(elapsed)
    for i = 1, #anims do
        songPos = getPropertyFromClass('Conductor', 'songPosition');
        currentBeat = (songPos / 1000) * (bpm / 30)
        currentBeat2 = (songPos / 1000) * (bpm / 60)
        if getProperty('dad.animation.curAnim.name') == anims[i] then
            beginVal = {getProperty('dad.x'), getProperty('dad.y')}
            endVal = {animNumX[i], animNumY[i]}
            change = {endVal[1] - beginVal[1], endVal[2] - beginVal[2]}
            duration = 1
            if not enable then
                beginVal = {getProperty('dad.x'), getProperty('dad.y')}
                endVal = {animNumX[1], animNumY[1]}
                change = {endVal[1] - beginVal[1], endVal[2] - beginVal[2]}
                    if (curBeat >= 128 and curBeat <= 158 or curBeat >= 320 and curBeat <= 350) and string.lower(songName) == 'steel-plated' then
                        sin = 150 * math.sin((currentBeat2 * 0.25) * math.pi)
                        cos = 50 * math.cos((currentBeat * 0.25) * math.pi)
                    else
                        sin = 25 * math.sin((currentBeat2 * 0.25) * math.pi)
                        cos = 10 * math.cos((currentBeat * 0.25) * math.pi)
                    end
                    x = songName ~= 'error' and animNumX[1] + sin or 0
                    y = songName ~= 'error' and animNumY[1] + cos or 0
                    --setProperty('boyfriend.x',lerp(getProperty('boyfriend.x'),getProperty('boyfriend.x') + sin, elapsed * 8))
                    --setProperty('boyfriend.y',lerp(getProperty('boyfriend.y'),getProperty('boyfriend.y') + cos, elapsed * 8))
                    -- goofy ahh bf

                setProperty('dad.x',lerp(getProperty('dad.x'),outCirc(duration/4,beginVal[1],change[1],duration) + x, elapsed * 8))
                setProperty('dad.y',lerp(getProperty('dad.y'),outCirc(duration/4,beginVal[2],change[2],duration) + y, elapsed * 8))
            elseif enable then
                setProperty('dad.x',lerp(getProperty('dad.x'),outCirc(duration/4,beginVal[1],change[1],duration), elapsed * 4))
                setProperty('dad.y',lerp(getProperty('dad.y'),outCirc(duration/4,beginVal[2],change[2],duration), elapsed * 4))
            end
        end
    end
end

function onUpdatePost(elapsed)
    if string.lower(dadName) == 'metalsonic' or string.lower(dadName) == 'brokenmetal' then
    lerpMovement(elapsed)
    songPos = getPropertyFromClass('Conductor', 'songPosition');
    currentBeat = (songPos / 1000) * (bpm / 30)
    currentBeat2 = (songPos / 1000) * (bpm / 60)
    if string.lower(dadName) == 'metalsonic' then
        setProperty('iconP2.offset.x', 10 * math.sin((currentBeat2 * 0.25) * math.pi))
        setProperty('iconP2.offset.y', 10 - 5 * math.sin((currentBeat * 0.25) * math.pi))
    end
    end

end