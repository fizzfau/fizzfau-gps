local Keys, blips, ESX, retval = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}, {}, nil, false

Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(50)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
	local found = false
	PlayerData.job = job
	for k,v in pairs(Config.Jobs) do
		if PlayerData.job.name == k then
			found = true
			break
		end
	end
	TriggerServerEvent("fizzfau-gps:dropGPS")
	if found then
		TriggerServerEvent("fizzfau-gps:connectGps")
	end
	-- Units[GetPlayerServerId((PlayerId()))].job = PlayerData.job.name
end)

function CreateBlipThread()
	retval = true
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(Config.UpdateTick)
			if not retval then
				return
			end
			ESX.TriggerServerCallback("fizzfau-gps:getData", function(Units)
				CreateBlips(Units)
			end)
		end
	end)
end

RegisterNetEvent("fizzfau-gps:client:connectGps")
AddEventHandler("fizzfau-gps:client:connectGps", function()
	print("^1 [fizzfau-gps] ^0Connected to GPS Services ^1(https://www.fivemsociety.com)")
	CreateBlipThread()
end)

RegisterNetEvent("fizzfau-gps:client:dropGPS")
AddEventHandler("fizzfau-gps:client:dropGPS", function(id)
	print("^1 [fizzfau-gps] ^0Dropped from GPS Services ^1(https://www.fivemsociety.com)")
	if id == GetPlayerServerId(PlayerId()) then
		retval = false
		RemoveExistingBlips()
	end
	if blips[id] then
		RemoveBlip(blips[id])
		blips[id] = nil
	end
end)

function CreateBlips(Units)
	for k,v in pairs(Units) do
		if v ~= nil then
			local blip
			if k ~= GetPlayerServerId(PlayerId()) or Config.ShowYourself then
				if not DoesBlipExist(blips[k]) then
					blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
					-- SetBlipShowCone(blip, true)
					-- SetPedAiBlipHasCone(blip ,true)
					blips[k] = blip
				else
					SetBlipCoords(blips[k], v.coords.x, v.coords.y, v.coords.z)
				end
				SetBlipSprite(blips[k], (v.inVehicle == true and Config.VehicleBlips) and 225 or Config.Jobs[v.job].sprite)
				SetBlipColour(blips[k], Config.Jobs[v.job].color)
				SetBlipScale(blips[k], ((v.inVehicle == true and Config.VehicleBlips) and 0.6 or Config.Jobs[v.job].scale) or 0.8)
				SetBlipAsShortRange(blips[k], true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(v.code ~= nil and v.code or Config.Locales["unknown"]..  " | "..v.name)
				EndTextCommandSetBlipName(blips[k])
				
			end
		end
	end
end

function RemoveExistingBlips()
	for k,v in pairs(blips) do
		if DoesBlipExist(v) then
			RemoveBlip(v)
			blips[k] = nil
		end
	end
end