function love.run()
    if love.load then love.load(love.parsedGameArguments, love.rawGameArguments) end

    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end

    -- Main loop time.
    return function()
        -- Process events.
        if love.event then
            love.event.pump()
            for name, a,b,c,d,e,f in love.event.poll() do
                if name == "quit" then
                    if not love.quit or not love.quit() then
                        return a or 0, b
                    end
                end
                love.handlers[name](a,b,c,d,e,f)
            end
        end

        -- Update dt, as we'll be passing it to update
        local dt = love.timer and love.timer.step() or 0

        -- Call update and draw
        if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

        --if love.graphics and love.graphics.isActive() then
        --	love.graphics.origin()
        --	love.graphics.clear(love.graphics.getBackgroundColor())

        --	if love.draw then love.draw() end

        --	love.graphics.present()
        --end

        if love.timer then love.timer.sleep(0.1) end
    end
end

local servelove = require("src")
local server = servelove.NewServer("0.0.0.0", 5000)

server:Route("/ping", function(request, response)
    return "true"
end)

--[[
server:Route("/ping/<key>/<penis>", function(request, response)
    return request:GetUrlArgs("key") .. "____" .. request:GetUrlArgs("penis")
end)
local switch = true
server:Route("/auth", function()
    return "Hey!"
end, function()
    switch = not switch
    return switch
end)
server:Route("/profiler", function()
    return server:PrintProfiler()
end)
server:RouteFolder("src", nil, "assets")
]]


server:Route("/SetCookie", function(query, response)     -- Whenever someone visits /Hello, they get "World!" as a reply
    response:SetCookie(query:GetUrlEncoded("key"), query:GetUrlEncoded("value"))
    return "Success!"
end)
server:Route("/GetCookies", function(query, response)
    local s = ""
    for k, var in pairs(query:GetCookies()) do
        s = s .. k .. ": " .. var .. "\n"
    end
    s = s .. "\n\n"
    for k, var in pairs(query:GetHeaders()) do
        s = s .. k .. ": " .. var .. "\n"
    end
    return s
end)



--server:RouteFolder("", "raw_file")


server:Verbose("DEBUG")
server:StartProfiler()
server:Certificate("/home/vboxuser/test/bruh/certificate.crt")
server:PrivateKey("/home/vboxuser/test/bruh/private.key")
server:Run()