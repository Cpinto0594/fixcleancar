local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) 
            ESX = obj 
        end)
        Citizen.Wait(0)
    end
end)

RegisterCommand( 'fixvh' , function(source, args, rawCommand) 
	ESX.TriggerServerCallback( 'fixvh:getPerms' , function( group ) 
		if  isGroupAllowed( group ) then
			fixVehicle()
		else
			TriggerEvent('fixvh:noPerms')
		end
	end)
end , false )

RegisterCommand( 'cleanvh' , function(source, args, rawCommand) 
	ESX.TriggerServerCallback( 'fixvh:getPerms' , function( group ) 
		if  isGroupAllowed( group ) then
			cleanVehicle()
		else
			TriggerEvent('fixvh:noPerms')
		end
	end)
end , false )

RegisterNetEvent('fixvh:noPerms')
AddEventHandler('fixvh:noPerms', function()
	notification("~r~You don't have permissions to do this to your vehicle.")
end)

function notification(msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(false, false)
end

function fixVehicle()
	local playerPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleEngineHealth(vehicle, 1000)
		SetVehicleEngineOn( vehicle, true, true )
		SetVehicleFixed(vehicle)
		checkFuelLevel(vehicle)
		notification("~g~Your vehicle has been fixed!")
	else
		notification("~o~You're not in a vehicle! There is no vehicle to fix!")
	end
end

function cleanVehicle() 
	local playerPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleDirtLevel(vehicle, 0)
		notification("~b~Your vehicle has been cleaned!")
	else
		notification("~o~You're not in a vehicle! There is no vehicle to clean!")
	end
end

function checkFuelLevel(vehicle)
	local flevel = GetVehicleFuelLevel(vehicle)
	if  Config.MinFuelLEvel > flevel then
		SetVehicleFuelLevel(vehicle, Config.RestoredFuelLEvel)
	end
end

function isGroupAllowed( role )
	for k,v in ipairs(Config.AllowedRoles) do
		if v == role then
			return true
		end
	end
	return false
end