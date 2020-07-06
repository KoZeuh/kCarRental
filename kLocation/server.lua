ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('kLocation:PaiementFaggio')
AddEventHandler('kLocation:PaiementFaggio', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local PrixFaggio = 30
    local _source = source
    if xPlayer.getMoney() >= PrixFaggio then
        xPlayer.removeMoney(30)
        TriggerClientEvent('esx:showNotification', _source, "~b~Vous avez payé une location.~s~\nMontant: ~g~" ..PrixFaggio.. "$")
	elseif xPlayer.getMoney() <= 30 then
        xPlayer.removeMoney(30)
        TriggerClientEvent('esx:showNotification', _source, "~b~Vous avez payé une location.~s~\nMontant: ~g~" ..PrixFaggio.. "$")
    end
end)

RegisterServerEvent('kLocation:PaiementPanto')
AddEventHandler('kLocation:PaiementPanto', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local PrixPanto = 50
    local _source = source
    if xPlayer.getMoney() >= PrixPanto then
        xPlayer.removeMoney(50)
        TriggerClientEvent('esx:showNotification', _source, "~b~Vous avez payé une location.~s~\nMontant: ~g~" ..PrixPanto.. "$")
	elseif xPlayer.getMoney() <= 50 then
        xPlayer.removeMoney(50)
        TriggerClientEvent('esx:showNotification', _source, "~b~Vous avez payé une location.~s~\nMontant: ~g~" ..PrixPanto.. "$")
    end
end)