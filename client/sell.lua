ESX                           = nil


Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) 
            ESX = obj 
        end)

        Citizen.Wait(5)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)

    for locationIndex = 1, #Config.SellSchnapps do
        local locationPos = Config.SellSchnapps[locationIndex]

        local blip = AddBlipForCoord(locationPos)

        SetBlipSprite (blip, 499)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, 0.6)
        SetBlipColour (blip, 2)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Sell Schnapps")
        EndTextCommandSetBlipName(blip)
		
    end

    while true do
        local sleepThread = 500

        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)

        for locationIndex = 1, #Config.SellSchnapps do
            local locationPos = Config.SellSchnapps[locationIndex]

            local dstCheck = GetDistanceBetweenCoords(pedCoords, locationPos, true)

            if dstCheck <= 5.0 then
                sleepThread = 5

                local text = "Sell Schnapps"

                if dstCheck <= 1.5 then
                    text = "[~g~E~s~] " .. text

                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent("esx-fruit:sellSchnapps")
						 TriggerEvent("esx-fruit:box")
                    end
                end
                
                ESX.Game.Utils.DrawText3D(locationPos, text, 1.4)
            end
        end

        Citizen.Wait(sleepThread)
    end
end)

RegisterNetEvent("esx-fruit:box")
AddEventHandler("esx-fruit:box",function(source)
		RequestAnimDict("anim@heists@box_carry@")
		while not HasAnimDictLoaded("anim@heists@box_carry@") do
		Citizen.Wait(1)
		end
		TaskPlayAnim(GetPlayerPed(-1),"anim@heists@box_carry@","idle",1.0, -1.0, -1, 49, 0, 0, 0, 0)
		Citizen.Wait(100)
		attachModel = GetHashKey('v_ret_ml_beerpat2')
		boneNumber = 28422
		SetCurrentPedWeapon(GetPlayerPed(-1), 0xA2719263) 
		local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumber)
		RequestModel(attachModel)
			while not HasModelLoaded(attachModel) do
				Citizen.Wait(100)
			end
		attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
		AttachEntityToEntity(attachedProp, GetPlayerPed(-1), bone, 0.0, -0.10, -0.20, -0.20, 0.90, 0.0, 1, 1, 0, 1, 0, 1)
		Citizen.Wait(3000)							
		RemoveAnimDict("anim@heists@box_carry@")
		DeleteEntity(attachedProp)
		ClearPedTasks(PlayerPedId())
end)