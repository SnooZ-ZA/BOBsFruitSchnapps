local ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) 
    ESX = obj 
end)


RegisterServerEvent("esx-fruit:sellSchnapps")
AddEventHandler("esx-fruit:sellSchnapps", function()
    local player = ESX.GetPlayerFromId(source)

    local currentSchnapps = player.getInventoryItem("schnapps")["count"]
    
    if currentSchnapps > 0 then
        math.randomseed(os.time())
        local randomSchnappsMoney = math.random((Config.SchnappsReward[1] or 1), (Config.SchnappsReward[2] or 4))

        player.removeInventoryItem("schnapps", currentSchnapps)
        player.addMoney(randomSchnappsMoney * currentSchnapps)

        TriggerClientEvent("esx:showNotification", source, ("You had %s Schnapps and got paid $%s."):format(currentSchnapps, currentSchnapps * randomSchnappsMoney))
    else
        TriggerClientEvent("esx:showNotification", source, "You don't have any Schnapps to sell.")
    end
end)