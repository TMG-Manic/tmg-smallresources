local jobs = {}
local lastProcessedMinute = -1

local function GetTime()
    local timestamp = os.time()
    local dateTable = os.date('*t', timestamp)
    
    return {
        day = tonumber(dateTable.wday), 
        hour = tonumber(dateTable.hour), 
        min = tonumber(dateTable.min)
    }
end

local function CheckTimes(day, hour, min)
    if lastProcessedMinute == min then return end
    lastProcessedMinute = min

    for i = 1, #jobs do
        local data = jobs[i]
        if data and data.hour == hour and data.min == min then
            print(string.format("^5[TMG]^7 Temporal Pulse: Executing Job ID %s (Window: %02d:%02d)", i, hour, min))
            if type(data.cb) == "function" then
                data.cb(day, hour, min)
            end
        end
    end
end


exports("CreateTimedJob", function(hour, min, cb)
    if type(hour) == "number" and type(min) == "number" and type(cb) == "function" then
        local jobID = #jobs + 1
        jobs[jobID] = {
            min = min,
            hour = hour,
            cb = cb
        }
        
        print(string.format("^5[TMG]^7 Temporal Registry: Job %s scheduled for %02d:%02d", jobID, hour, min))
        return jobID
    else
        print("^1[TMG Error]^7 Invalid arguments for 'CreateTimedJob' pulse.")
        return nil
    end
end)

exports("ForceRunTimedJob", function(idx)
    if jobs[idx] then
        local time = GetTime()
        print(string.format("^5[TMG]^7 Temporal Override: Manual pulse triggered for Job %s", idx))
        jobs[idx].cb(time.day, time.hour, time.min)
    end
end)

exports("StopTimedJob", function(idx)
    if jobs[idx] then
        jobs[idx] = nil
        print(string.format("^5[TMG]^7 Temporal Registry: Job %s has been terminated.", idx))
    end
end)


CreateThread(function()
    print("^5[TMG]^7 Temporal Engine Initialized. Monitoring BSON time-vectors...")
    while true do
        local time = GetTime()
        CheckTimes(time.day, time.hour, time.min)
        Wait(30000) 
    end
end)
