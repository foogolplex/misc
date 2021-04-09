rednet.open("back")
term.clear()
term.setCursorPos(1, 1)

print("version 0.1")

function split(s, delimiter)
    result = {}
    for token in string.gmatch(s, "%a+") do
        table.insert(result, token)
    end
    return result
end

function printUsage()
    print("Usage: ")
    print("connect <server name>")
    print("put <file name>")
    print("sls")
    print("get <file name>")
    print("delete <file name>")
    print("quit/exit/q")
    print("For more info: help <command>")
end

function help(command)
    if command == "help" then
        print("Shows proper usage of a command and explains what it does.")
        print("Usage: help <command>")
    elseif command == "connect" then
        print("Connects the client to a server if possible.")
        print("Usage: connect <server hostname under ftp>")
    elseif command == "put" then
        print("Saves a file to the connected server (must use connect before this, type \"help connect\" for more info).")
        print("Usage: put <file name>")
    elseif command == "clear" then
        print("Clears the terminal.")
    elseif command == "quit" or command == "exit" or command == "q" then
        print("I'll let you deduce this one.")
    else
        print("This command doesn't exist.")
    end
end
server_id = 0
function main()
    while 1
    do   
        io.write("ftp> ")
    
        user_input = read()
        user_input = user_input .. " "
    
        --delimit input
        dinput = {}
        dinput = split(user_input, " ")
    
        --check if first arg is a valid command
        is_command = false
        commands = {"clear", "connect", "put", "quit", "exit", "q", "help", "get", "sls", "delete"}
        for i, v in ipairs(commands)
        do
            if dinput[1] == v then
                is_command = true
                break
            end
        end

        if is_command == true or table.getn(dinput) == 0 then
            if dinput[1] == "clear" and table.getn(dinput) == 1 then
                term.clear()
                term.setCursorPos(1, 1)

            elseif dinput[1] == "connect" and table.getn(dinput) == 2 then
                server_name = dinput[2]
                server_id = rednet.lookup("ftp", server_name)
                print("server id : ", server_id)

            elseif dinput[1] == "put" and table.getn(dinput) == 2 then
                filename = dinput[2]
                file = fs.open(filename, "r")
                filedata = {}
                
                if file == nil then
                    print("File not found.")
                else
                    repeat
                        line = file.readLine()
                        table.insert(filedata, line)
                    until line == nil
                    print("sending to: ", server_id)
                    rednet.send(server_id, filedata, "put")
                    rednet.send(server_id, filename, "ftp_name")
                end
            
            elseif dinput[1] == "sls" and table.getn(dinput) == 1 then
                rednet.send(server_id, "", "sls")
                local senderId, message = rednet.receive(2)

                if senderId == server_id then
                    i = 1
                    repeat
                        line = message[i]
                        print(line)
                        i = i + 1
                    until line == nil
                else
                    print("Not connected to an ftp server")
                end
            
            elseif dinput[1] == "get" and table.getn(dinput) == 2 then
                filename = dinput[2]
                rednet.send(server_id, "", "get")
                rednet.send(server_id, filename, "ftp_name")
                print("waiting")
                local id, msg, protocol = rednet.receive("get")
                print("received")
                if msg == "file doesn't exist" then
                    print(msg)
                --elseif fs.exists(filename) == true then
                --    print("file already exists with that name")
                elseif protocol == "get" then
                    local file = fs.open(filename, "w")
                    i = 1
                    repeat
                        local line = msg[i]
                        print(line)
                        file.writeLine(line)
                        i = i + 1
                    until line == nil
                    file.close()
                end

            elseif dinput[1] == "delete" and table.getn(dinput) == 2 then
                filename = dinput[2]
                rednet.send(server_id, "", "delete")
                rednet.send(server_id, filename, "ftp_name")
                local id, msg = rednet.receive("delete")
                print(msg)

            elseif (dinput[1] == "quit" or dinput[0] == "q" or dinput[1] == "exit") and table.getn(dinput) == 1 then
                return 0
            
            elseif dinput[1] == "help" and table.getn(dinput) == 1 then
                printUsage()

            elseif dinput[1] == "help" and table.getn(dinput) == 2 then
                help(dinput[2])

            elseif table.getn(dinput) == 0 then
                io.write("")

            else
                print("Incorrect grammar, type \"help <command name>\" to learn the correct grammar.")
            end
        else
            printUsage()
        end
    end
end 
main()
