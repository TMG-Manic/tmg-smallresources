local isRecording = false

RegisterCommand('record', function()
    if isRecording then 
        TMGCore.Functions.Notify("Already recording!", "error")
        return 
    end

    isRecording = true
    StartRecording(1)
    TMGCore.Functions.Notify(Lang:t('editor.started'), 'success')
end, false)

RegisterCommand('clip', function()
    StartRecording(0)
end, false)

RegisterCommand('saveclip', function()
    if not isRecording then return end
    
    StopRecordingAndSaveClip()
    isRecording = false
    TMGCore.Functions.Notify(Lang:t('editor.save'), 'success')
end, false)

RegisterCommand('delclip', function()
    StopRecordingAndDiscardClip()
    isRecording = false
    TMGCore.Functions.Notify(Lang:t('editor.delete'), 'error')
end, false)

RegisterCommand('editor', function()
    local ped = PlayerPedId()
    
    if IsEntityDead(ped) or IsPedCuffed(ped) or isProcessing then
        TMGCore.Functions.Notify("You cannot open the editor right now.", "error")
        return
    end
    TMGCore.Functions.Notify(Lang:t('editor.editor'), 'primary')
    
    Wait(500)
    if isRecording then StopRecordingAndSaveClip() end
    
    ActivateRockstarEditor()
end, false)