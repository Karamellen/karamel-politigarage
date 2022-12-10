ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('karamel-policegarage:CheckJob', function()
    local souce = source
    local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.job.name == 'police' then
    end
end)