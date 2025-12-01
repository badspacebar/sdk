--[[

    net.get(url, callback)
        Takes an url, calls the callback with .body data or nil if unsuccessful
        Automatically retries until success/400+ error
    net.update(name, type, url, done)
        Reads an MD5SUM file on the server and downloads all mismatching files
        Input:
            - name of the module
            - type ["lib", "lua"]
            - base url of the files on your host
            - callback(bool), optional, will proc with true if anything was updated
        Example .sh to generate such file:
            #!/bin/bash
            cd /your/folder/for/the/script/
            find . -type f -print0 | xargs -0 md5sum > /tmp/MD5SUM; mv /tmp/MD5SUM ./MD5SUM
            chmod 644 ./MD5SUM
        Example .lua to generate such file:
            local path = hanbot.libpath .. "/DivineLib/"
            local tree = module.generate_tree("DivineLib", path)
            for _, data in pairs(tree) do
                if type(data) == "table" then
                    tree = data;break
                end
            end
            local file = io.open(path .. "MD5SUM", "w")
            for i, v in pairs(tree) do
                file:write(v .. '  ./' .. i .. '\n')
            end
            file:close()

]]
local isRiot = hanbot.isRiot
local net;net = {
    __updates = {},
    try_callback = function(name, callback, anyUpdate)
        if not net.__updates[name] then
            net.__updates[name] = {
                function()
                    if net.__updates[name].__timer < os.clock() then
                        if not net.__updates[name].__elapsed then
                            net.__updates[name].__elapsed = true
                            if callback then
                                callback(anyUpdate)
                            end
                        end
                        cb.remove(net.__updates[name][1])
                    end
                end,
                __timer = os.clock() + 1
            }
            cb.add(cb.tick, net.__updates[name][1])
        end
    end,
    get = function(url, c)
        local f;f = function()
            local data, _, _ = network.send(url, { method = 'GET' })
            if type(data) == 'table' then
                if data.code == "200" then
                    if c then
                        c(data.body)
                    end
                    cb.remove(f)
                    return
                elseif tonumber(data.code) >= 400 then
                    if c then
                        c(nil)
                    end
                    cb.remove(f)
                end
            elseif data == false then
                if c then
                    c(nil)
                end
                cb.remove(f)
            end
        end
        cb.add(cb.tick, f)
    end,
    update = function(name, ltype, url, callback)
        local dir = hanbot.shardpath .. "/"
        module.create_shard_directory('')
        net.get(url .. "ShardMD5SUM", function(data)
            if data then
                local anyUpdate = false
                for line in data:gmatch("([^\r\n]*)[\r\n]") do
                    if line:len() > 0 then
                        local onlinemd5 = line:sub(1, 32)
                        local filePath = line:sub(37)
                        if not filePath:find"MD5SUM" and filePath == name .. (ltype == "lua" and ".obj" or ".lib") then
                            if onlinemd5 ~= md5.file(dir .. filePath) then
                                print((isRiot and "Changed file, downloading" or "更改文件，下载") .. ":\t" .. dir .. filePath)
                                network.download_file(url .. filePath .. '?' .. os.time(), dir .. filePath)
                                anyUpdate = true
                                return callback(true)
                            end
                            return callback()
                        end
                    end
                end
                net.try_callback(name, callback, anyUpdate)
            else
                if module.is_anyshard(name) then
                    print((isRiot and "Could not Update: " or "无法更新：") .. name)
                    return callback()
                end
                local tree
                dir = hanbot[ltype .. "path"] .. "/" .. name .. "/"
                if ltype == "sprite" then
                    module.create_sprite_directory(name)
                    tree = module.generate_sprite_tree(dir, true)
                    return
                else
                    tree = module.generate_tree(name, true)
                end
                if not tree then
                    print((isRiot and "Could not Update: " or "无法更新：") .. name)
                    return callback()
                end
                for _, data in pairs(tree) do
                    if type(data) == "table" then
                        tree = data
                        local any = false
                        for __, ___ in pairs(data) do
                            any = true
                        end
                        if not any then
                            print(isRiot and "Empty directory, skipping update." or "空目录，跳过更新。")
                            return callback()
                        end
                        break
                    end
                end
                net.get(url .. "MD5SUM", function(data)
                    if data then
                        local anyUpdate = false
                        for line in data:gmatch("([^\r\n]*)[\r\n]") do
                            local onlinemd5 = line:sub(1, 32)
                            line = line:sub(37)
                            local pos, tail, filePath = line:find("/"), tree, ""
                            while pos do
                                local path = line:sub(1, pos - 1)
                                tail, filePath, line = tail[path] or {}, filePath .. path .. "/", line:sub(pos + 1)
                                pos = line:find("/")
                            end
                            if tail and tail[line] then
                                filePath = filePath .. line
                                if onlinemd5 ~= tail[line] and not filePath:find("header.lua") then
                                    print((isRiot and "Changed file, downloading" or "更改文件，下载") .. ":\t" .. dir .. filePath)
                                    network.download_file(url .. filePath .. '?' .. os.time(), dir .. filePath)
                                    anyUpdate = true
                                end
                            elseif line:find("%.lua") then
                                module.create_directory(name, filePath)
                                filePath = filePath .. line
                                print((isRiot and "New file, downloading" or "新文件，下载") .. ":\t" .. dir .. filePath)
                                network.download_file(url .. filePath .. '?' .. os.time(), dir .. filePath)
                                anyUpdate = true
                            elseif line:find("%.png") then
                            elseif line:find("%.json") then
                                -- [[ TO DO ]]
                            end
                        end
                        net.try_callback(name, callback, anyUpdate)
                    else
                        print((isRiot and "File could not be retrieved: " or "无法检索文件：") .. url .. "MD5SUM")
                        if callback then
                            callback()
                        end
                    end
                end)
            end
        end)
    end
}return net