local t = {print = function(self, ...) print(...) return self end}
t:print(123) ---rer
:print("cheefkief")

do
    return
end

local servelove = require("src")
local server = servelove.NewServer("0.0.0.0", 5000)

--[[
server:Route("/ping", function(request, response)
    return "true"
end)
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
server:Run()