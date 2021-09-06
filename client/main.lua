ESX        = nil
percent    = false
searching  = false
cachedFruit = {}

closestFruit = {
    "v_ret_247_fruit",
    "prop_fruit_stand_01",
	"prop_fruit_stand_02",
	"prop_fruit_stand_03",
	"prop_fruitstand_01",
	"prop_fruitstand_b"
}

closestStill = {
    "prop_still"
}

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(5)

		TriggerEvent("esx:getSharedObject", function(library)
			ESX = library
		end)
    end

    if ESX.IsPlayerLoaded() then
		ESX.PlayerData = ESX.GetPlayerData()
	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	ESX.PlayerData = response
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)
    while true do
        
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for i = 1, #closestFruit do
            local x = GetClosestObjectOfType(playerCoords, 1.0, GetHashKey(closestFruit[i]), false, false, false)
            local entity = nil
            if DoesEntityExist(x) then
                sleep  = 5
                entity = x
                Fruit   = GetEntityCoords(entity)
				drawText3D(Fruit.x, Fruit.y, Fruit.z + 0.6, '⚙️')
                while IsControlPressed(0, 38) do
                drawText3D(Fruit.x, Fruit.y, Fruit.z + 0.5, 'Press [~g~H~s~] to pickup ~b~ Fruit ~s~')
				break
				end
                if IsControlJustReleased(0, 74) then
                   TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
					Citizen.Wait(5000)
					ClearPedTasks(PlayerPedId())					
					TriggerServerEvent('esx_fruit:getFruit')
                end
                break
            else
                sleep = 1000
            end
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)
    while true do
        
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for i = 1, #closestStill do
            local x = GetClosestObjectOfType(playerCoords, 1.0, GetHashKey(closestStill[i]), false, false, false)
            local entity = nil
            if DoesEntityExist(x) then
                sleep  = 5
                entity = x
                Still   = GetEntityCoords(entity)
				drawText3D(Still.x, Still.y, Still.z + 0.4, '⚙️')
                while IsControlPressed(0, 38) do
                drawText3D(Still.x, Still.y, Still.z + 0.2, '[~g~H~s~] to distill. [~b~F~s~] to pickup.')
				break
				end
                if IsControlJustReleased(0, 74) then
				TriggerServerEvent('esx_fruit:checkFruit')
				elseif IsControlJustReleased(0, 23) and DoesEntityExist(entity) then
				TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
				Citizen.Wait(3000)
				DeleteObject(entity)
				TriggerServerEvent('esx_fruit:getStill')
				ClearPedTasks(PlayerPedId())
                end
                break
            else
                sleep = 1000
            end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent('esx_fruit:success')
AddEventHandler('esx_fruit:success', function (source)	
ESX.ShowNotification('5 Fruit = 1 Schnapps!')
		searching  = true
		exports.rprogress:Custom({
								Async = true,
								x = 0.5,
								y = 0.5,
								From = 0,
								To = 100,
								Duration = 20000,
								Radius = 60,
								Stroke = 10,
								MaxAngle = 360,
								Rotation = 0,
								Easing = "easeLinear",
								Label = "MAKING SCHNAPPS",
								LabelPosition = "right",
								Color = "rgba(255, 255, 255, 1.0)",
								BGColor = "rgba(107, 109, 110, 0.95)",
								Animation = {
								scenario = "PROP_HUMAN_BUM_BIN", -- https://pastebin.com/6mrYTdQv
								--animationDictionary = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", -- https://alexguirre.github.io/animations-list/
								--animationName = "machinic_loop_mechandplayer",
								},
								DisableControls = {
								Mouse = false,
								Player = true,
								Vehicle = true
								},
								})
				Citizen.Wait(20000)
				searching  = false
				TriggerServerEvent('esx_fruit:getSchnapps')	
		
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)
    while true do

        local sleep = 1000

        if percent then

            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            for i = 1, #closestFruit do

                local x = GetClosestObjectOfType(playerCoords, 1.0, GetHashKey(closestFruit[i]), false, false, false)
                local entity = nil
                
                if DoesEntityExist(x) then
                    sleep  = 5
                    entity = x
                    Fruit    = GetEntityCoords(entity)
                    drawText3D(Fruit.x, Fruit.y, Fruit.z + 0.2, TimeLeft .. '~g~%~s~')
                    break
                end
            end
        end
        Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if searching then
            DisableControlAction(0, 38) 
			DisableControlAction(0, 47)
			DisableControlAction(0, 74)
        end
    end
end)


RegisterNetEvent('esx_fruit:spawnStill')
AddEventHandler('esx_fruit:spawnStill', function()
	TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
	Citizen.Wait(3000)
	ClearPedTasks(PlayerPedId())
    AddStill()
end)


function AddStill()
	local ped= PlayerPedId()
    local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.2, 0.0)
    local heading = GetEntityHeading(ped)
	local pedcoords = GetEntityCoords(ped)

		local stillinfo = {
            x= coords.x,
            y= coords.y,
            z= coords.z,
            h= heading,
            propid=0,
            }

            local ModelHash = GetHashKey('prop_still')
            local Prop = CreateObject(ModelHash, 0, 0, 0, true, true, true)
            stillinfo.propid = Prop
                SetEntityCoords(Prop, stillinfo.x, stillinfo.y, stillinfo.z-1.00, 0, 0, 0, false)
                SetEntityHeading(Prop, stillinfo.h)
                FreezeEntityPosition(stillinfo.propid, true)
    check = true
end
