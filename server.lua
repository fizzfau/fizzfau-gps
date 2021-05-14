ESX = nil
local Units = {}
TriggerEvent('esx:getSharedObject', function(obj) 
	ESX = obj 
end)

ESX.RegisterUsableItem("gps", function(source)
    local player = ESX.GetPlayerFromId(source)
    for k,v in pairs(Config.Jobs) do
        if player.job.name == k then
            if Units[source] == nil then
                TriggerEvent("fizzfau-gps:connectGps", source)
            else
                TriggerEvent("fizzfau-gps:dropGPS", source)
            end
            break
        end
    end
end)

ESX.RegisterServerCallback("fizzfau-gps:getData", function(source, cb)
    for k,v in pairs(Units) do
        if v.ped then
            Units[k].coords = GetEntityCoords(v.ped)
            Units[k].inVehicle = GetVehiclePedIsIn(v.ped, false) ~= 0
        end
    end
    cb(Units)
end)

RegisterServerEvent("fizzfau-gps:dropGPS")
AddEventHandler("fizzfau-gps:dropGPS", function(_source)
    local src = _source or source
    if Units[src] ~= nil then
        Units[src] = nil
        TriggerClientEvent("notification", src, Config.Locales["gps_closed"], 'error')
        TriggerClientEvent("fizzfau-gps:client:dropGPS", -1, src)
    end
end)

RegisterServerEvent("fizzfau-gps:connectGps")
AddEventHandler("fizzfau-gps:connectGps", function(_source)
    local src = _source or source
    local player = ESX.GetPlayerFromId(src)
    local count = player.GetItemByName("gps").count
    if count ~= nil and count > 0 then
        Units[player.source] = {
            ped = GetPlayerPed(src),
            job = player.job.name,
            code = Config.Codes[player.identifier],
            -- name = player.get("firstName").. " " ..player.get("lastName")
            name = player.PlayerData.firstname.. " " ..player.PlayerData.lastname
        }
        TriggerClientEvent("notification", src, Config.Locales["gps_opened"], "inform")

        TriggerClientEvent("fizzfau-gps:client:connectGps", src)
    end
end)

AddEventHandler("playerDropped", function(reason)
    TriggerEvent("fizzfau-gps:dropGPS", source)
end)

print("^1 [fizzfau-gps] ^0Server file loaded succesfully! ^1(https://www.fivemsociety.com)")