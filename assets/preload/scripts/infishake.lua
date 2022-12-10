--If you want a enemy to shake the screen when singing, rename this file to "script.lua" and go to mods/data/(song) and put the script on the song's folder.
--Script by BBpanzu, taken from the whitty mod.

function opponentNoteHit()

triggerEvent('Screen Shake','1,0.006')

end