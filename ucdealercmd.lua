CommandPack("usedCarDealer", "Kartikeya P. Malimath", {
    {
         command = "transfervehicle",
         format = "**transfervehicle** #sellerID# #buyerID# #Plate# ",
         help = "Transfer vehicle ownership",
         usage = "/transfervehicle [sellerID] [buyerID] [Plate]",
         hidden = true, -- Prevents the message from being shown in chat
         cb = function(source,_,_,args)
                Sellerfrom = args[1] --From (the Seller or vehicle Owner)
                buyerto = args[2] -- To (The buyer)
                
                if(GetPlayerName(tonumber(args[1])) && GetPlayerName(tonumber(args[2])))then
                        
                else
                        
                    TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
                    return
                end
                
                
                local plate1 = args[3]
                
              
                if plate1 ~= nil then plate01 = plate1 else plate01 = "" end
              
              
                local plate = plate01

                
                SellerSteamID = GetPlayerIdentifiers(Sellerfrom)
                SellerSteam = SellerSteamID[1]
                sellerID = ESX.GetPlayerFromId(Sellerfrom).identifier
                sellerName = ESX.GetPlayerFromId(Sellerfrom).name

                buyerSteamID = GetPlayerIdentifiers(args[2])
                buyerSteamName = ESX.GetPlayerFromId(args[2]).name
                buyerSteam = buyerSteamID[1]
                
                MySQL.Async.fetchAll(
                    'SELECT * FROM owned_vehicles WHERE plate = @plate',
                    {
                        ['@plate'] = plate
                    },
                    function(result)
                        if result[1] ~= nil then
                            local playerName = ESX.GetPlayerFromIdentifier(result[1].owner).identifier
                            local pName = ESX.GetPlayerFromIdentifier(result[1].owner).name
                            CarOwner = playerName
                            print("Car Transfer ", sellerID, CarOwner)
                            if sellerID == CarOwner then
                                print("Transfered")
                                
                                data = {}
                                    TriggerClientEvent('chatMessage', buyerto, "^4Vehicle with the plate ^*^1" .. plate .. "^r^4was transfered to you by: ^*^2" .. sellerName)
                         
                                    MySQL.Sync.execute("UPDATE owned_vehicles SET owner=@owner WHERE plate=@plate", {['@owner'] = buyerSteam, ['@plate'] = plate})
                                    TriggerClientEvent('chatMessage', Sellerfrom, "^4You have ^*^3transfered^0^4 your vehicle with the plate ^*^1" .. plate .. "\" ^r^4to ^*^2".. buyerSteamName)
                            else
                                print("Did not transfer")
                                TriggerClientEvent('chatMessage', Sellerfrom, "^*^1You do not own the vehicle")
                                TriggerClientEvent('chatMessage', buyerto, "^*^1",sellerName," Doesnot own this vehicle")
                            end
                        else
                            TriggerClientEvent('chatMessage', Sellerfrom, "^1^*ERROR: ^r^0This vehicle plate does not exist or the plate was incorrectly written.")
                            TriggerClientEvent('chatMessage', buyerto, "^1^*ERROR: ^r^0This vehicle plate does not exist or the plate was incorrectly written.")
                        end
                    
                    end
                )
                
            end,
            --end

     },
     {
         command = "vehinfo",
         format = "**Vehicle Info: ** #Plate# #Owner# #vehicle# ",
         help = "Check vehicle information",
         usage = "/vehinfo [plate]",
         hidden = true, -- Prevents the message from being shown in chat
         cb = function(source,_,_,args)
            local plate = args[1]
            MySQL.Async.fetchAll(
                'SELECT * FROM owned_vehicles WHERE plate = @plate',
                {
                    ['@plate'] = plate
                },
                function(result)
                    if result[1] ~= nil then
                        local playerName = ESX.GetPlayerFromIdentifier(result[1].owner).identifier
                        local pName = ESX.GetPlayerFromIdentifier(result[1].owner).name
                        local pvehicle = result[1].vehicle
                        local vtype = result[1].type
                        CarOwner = playerName
                        TriggerClientEvent('chatMessage', source, "^4Plate : ^*^1",plate," ^4|| Owner : ^*^1",pName," ^4|| Model : ^*^1",pvehicle," ^4|| Type : ^*^1",vtype)      
                    else
                        TriggerClientEvent('chatMessage', source, "^1^*ERROR: ^r^0This vehicle plate does not exist or the plate was incorrectly written.")
                    end
                
                end
            )
     }
}, 
{
    -- Default values, if one is not specified for the command
    -- We don't need to specify any default values here for this example
    prereq = function(source)
        if SETTINGS.use_esx then
            local xPlayer = ESX.GetPlayerFromId(source)
            return xPlayer.job.name == 'usedCarDealer'
        end
        return false
    end,
    noperm = "You are not a used car dealer!",
})