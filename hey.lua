if getgenv and type(getgenv) == "function" then
    local genv = getgenv()
    if type(genv.gethwid) == "function" then
        genv.gethwid = function()
            return "C3E4DE16-6C7B-4302-82E8-E1AE92502489"
        end
    end
end
