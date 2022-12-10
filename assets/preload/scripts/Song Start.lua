local bOffset = 100
local fuckGOBACK = true
local downscrollnum = 550

spriteArray = {'graygrap', 'blackgrap', 'watermark', 'songPlaying'}
xOffsetArray = {995, 1000, 1000, 1000}

function onCreate()
    if downscroll then
        downscrollnum = -50
    end

        makeLuaSprite('graygrap', '', 1500 - bOffset, 570 - downscrollnum)
        makeGraphic('graygrap', 320, 80, 'de3f2c')
        addLuaSprite('graygrap', false)

        makeLuaSprite('blackgrap', '', 1500- bOffset, 580- downscrollnum)
        makeGraphic('blackgrap', 300, 70, '000000')
        addLuaSprite('blackgrap', false)
        
        makeLuaText('watermark', 'Bad Future', 0, 1500- bOffset, 580- downscrollnum)
        addLuaText('watermark', false)
        setTextFont('watermark', "vcr.ttf")
        setTextSize('watermark', 16)
        setProperty('watermark.alpha', 0)

        makeLuaText('songPlaying', 'Playing - '..songName, 0, 1500- bOffset, 600- downscrollnum)
        addLuaText('songPlaying', false)
        setTextFont('songPlaying', "vcr.ttf")
        setTextSize('songPlaying', 20)
        setProperty('songPlaying.alpha', 0)

        setObjectCamera('graygrap', 'other')
        setObjectCamera('blackgrap', 'other')
        setObjectCamera('watermark', 'other')
        setObjectCamera('songPlaying', 'other')
        setObjectCamera('songPlayingsub', 'other')

    for i = 1, 4 do
        iNum = i / 4
    runTimer('tweenSong'..i, 2 + iNum)
    end
    for i = 1, 2 do
        iNum2 = i / 9
        if fuckGOBACK then
            runTimer('goBACK'..i, 7.7 + iNum2)
        end
    end
    for i = 3,4 do
        iNum2 = i / 7
        if fuckGOBACK then
            runTimer('goBACK'..i, 7 + iNum2)
            end
    end
end

function onTimerCompleted(tag)
    for i = 1, #spriteArray do
    if tag == 'tweenSong'..i then
        doTweenX('fd'..i, spriteArray[i], xOffsetArray[i], 1, 'circInOut')
        for a = 3, 4 do
            doTweenAlpha('alpha'..a, spriteArray[a], 1, 1, 'circInOut')
        end
    end
    if tag == 'goBACK'..i then
        doTweenX('fd'..i, spriteArray[i], 1500 - bOffset, 0.4, 'circInOut')
        for a = 3, 4 do
            doTweenAlpha('alpha'..a, spriteArray[a], 0, 0.3, 'circInOut')
        end
    end
end
end

-- inspired by sir top hat