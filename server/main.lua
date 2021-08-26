ESX = nil

TriggerEvent("esx:getSharedObject", function(response)
    ESX = response
end)

RegisterServerEvent('esx_fruit:getFruit')
AddEventHandler('esx_fruit:getFruit', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local fruitQuantity = xPlayer.getInventoryItem('fruit').count
	
	if fruitQuantity < 50 then
	TriggerClientEvent('esx:showNotification', source, 'You got Fruit')
	xPlayer.addInventoryItem('fruit', Config.FruitPickup)
	else
	TriggerClientEvent('esx:showNotification', source, '~r~You cant carry more fruit.')
	end

end)

RegisterServerEvent('esx_fruit:getSchnapps')
AddEventHandler('esx_fruit:getSchnapps', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	TriggerClientEvent('esx:showNotification', source, 'You got Schnapps')
	xPlayer.addInventoryItem('schnapps', Config.SchnappsDistill)
	
end)

RegisterServerEvent('esx_fruit:getStill')
AddEventHandler('esx_fruit:getStill', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	TriggerClientEvent('esx:showNotification', source, 'You picked up the Still')
	xPlayer.addInventoryItem('still', 1)
	
end)

RegisterServerEvent('esx_fruit:checkFruit')
AddEventHandler('esx_fruit:checkFruit', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local fruitQuantity = xPlayer.getInventoryItem('fruit').count
	
	if fruitQuantity >= 5 then
		local schnappsQuantity = xPlayer.getInventoryItem('schnapps').count
			if schnappsQuantity < 10 then
				xPlayer.removeInventoryItem("fruit", Config.FruitDistill)
				TriggerClientEvent('esx_fruit:success', source)
			else
				TriggerClientEvent('esx:showNotification', source, '~r~You cant carry more schnapps.')
			end
	else
		TriggerClientEvent('esx:showNotification', source, '~r~You dont have enough Fruit.')	
	end	

end)


ESX.RegisterUsableItem('schnapps', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('schnapps', 1)
	
	TriggerClientEvent('esx_fruit:onDrinkSchanapps', source)
	TriggerClientEvent('esx_status:add', source, 'drunk', 250000)
	TriggerClientEvent('esx:showNotification', source, '~b~You drank Schnapps.')

end)

ESX.RegisterUsableItem('fruit', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('fruit', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 100000)
	TriggerClientEvent('esx_status:add', source, 'thirst', 100000)
	TriggerClientEvent('esx_fruit:onEatFruit', source)
	TriggerClientEvent('esx:showNotification', source, '~b~You ate fruit.')
end)

ESX.RegisterUsableItem('still', function(source)
local xPlayer = ESX.GetPlayerFromId(source)
xPlayer.removeInventoryItem('still', 1)
TriggerClientEvent("esx_fruit:spawnStill", source)
end)