rednet.open("back")
rednet.host("ftp", "testserver")

while 1 do
    id, msg, protocol = rednet.receive()
    print("sender id : ", id, " || sender message: ", msg, " || message protocol: ",protocol)
    if protocol == "sls" then
        rednet.send(id, fs.list(""), "sls")
    elseif protocol == "put" then
        local nid, nmsg = rednet.receive("ftp_name")
        if nid == id then
            local file = fs.open(nmsg, "w")
        
            i = 1
            repeat
                local line = msg[i]
                file.writeLine(line)
                i = i + 1
            until line == nil
            file.close()
        end
    elseif protocol == "get" then
        local nid, nmsg = rednet.receive("ftp_name")
        if nid == id and fs.exists(nmsg) == true then
            local file = fs.open(nmsg, "r")
            filedata = {}

            i = 1
            repeat
                local line = file.readLine()
                print(line)
                table.insert(filedata, line)
                i = i + 1
            until line == nil
            file.close()
            rednet.send(id, filedata, "get")
            print("sent: ", nmsg)
        else
            rednet.send(id, "file doesn't exit", "get")
        end
    elseif protocol == "delete" then
        local nid, nmsg = rednet.receive("ftp_name")
        if nid == id then
            fs.delete(nmsg)
            rednet.send(id, "file deleted", "delete")
        else
            rednet.send(id, "file doesn't exist", "delete")
        end
    end
end
