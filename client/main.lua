ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local VehicleOut = false
local ped = PlayerPedId()
local Vehicle = nil

CreateThread(function()
    while true do
        Wait(1)
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.TakeOutVeh.x, Config.TakeOutVeh.y, Config.TakeOutVeh.z) < 3 then
            DrawText3Ds(Config.TakeOutVeh.x, Config.TakeOutVeh.y, Config.TakeOutVeh.z+0.30, '~b~E~w~ - Åben Politigarage')
            if IsControlJustPressed(1, 38) then
                OpenMenu()
            end
        end
    end
end)

local option = {
    {label = 'Køretøjsliste', value = 'carlist'},
}

function OpenMenu()
    local options = {}
    isMenuOpen = true

    for k,v in pairs(Config.PoliceCars) do
        v = v:sub(1,1):upper()..v:sub(2)
        table.insert(options, {label = v, value = 'takeoutVeh', car = v })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'general_menu', {
        title = 'Politi Garage',
        align = 'left',
        elements = option
    }, function(data, menu)

        if data.current.value == 'takeoutVeh' then
            menu.close(data, menu)
            if VehicleOut == false then
            local ModelHash = data.current.car
            if not IsModelInCdimage(ModelHash) then return end
            RequestModel(ModelHash)
            while not HasModelLoaded(ModelHash) do
                Wait(10)
            end
            local MyPed = PlayerPedId()
            Vehicle = CreateVehicle(ModelHash, Config.SpawnPoint.x, Config.SpawnPoint.y, Config.SpawnPoint.z, Config.SpawnPoint.h, true, false)
            SetModelAsNoLongerNeeded(ModelHash)
            SetPedIntoVehicle(ped, Vehicle, -1)
            VehicleOut = true
            IsMenuOpen = false
        else
            exports["id_notify"]:notify({
                title = '',
                message = 'Du har allerede et køretøj ude!',
                type = 'error'
            })
            end
        end
        if data.current.value == 'carlist' then
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'general_menu', {
                title = 'Køretøjsliste',
                align = 'left',
                elements = options
            }, function(data, menu)
                menu.close()
            end)
        end

    end, 
    function(data, menu)
        menu.close()
        IsMenuOpen = false
    end)
end

CreateThread(function()
    while true do
        Wait(1)
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.ParkVeh.x, Config.ParkVeh.y, Config.ParkVeh.z) < 3 then
                if IsPedInAnyVehicle(ped, true) then
                DrawText3Ds(Config.ParkVeh.x, Config.ParkVeh.y, Config.ParkVeh.z+0.30, '~b~E~w~ - Parkér køretøj')
                    if IsControlJustPressed(1, 38) then
                    TriggerEvent('karamel-policegarage:CheckJob')
                    if IsVehicleDamaged(GetVehiclePedIsIn(ped, true)) then
                    exports["id_notify"]:notify({
                        title = '',
                        message = 'Dit køretøj er skadet! Vi reparere det lige for dig.',
                        type = 'error'
                    })
                    Wait(5000)
                    local vehicle = GetVehiclePedIsUsing(playerPed, false)
                    SetVehicleEngineHealth(GetVehiclePedIsIn(ped, true), 100)
                    SetVehicleEngineOn(GetVehiclePedIsIn(ped, true), true, true)
                    SetVehicleFixed(GetVehiclePedIsIn(ped, true))
                else
                    DeleteVehicle(GetVehiclePedIsIn(ped, true))
                    VehicleOut = false
                    exports["id_notify"]:notify({
                        title = '',
                        message = 'Køretøj parkéret!',
                        type = 'success'
                    })
                    end
                end
            end
        end
    end
end)

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.33, 0.33)
    SetTextFont(6)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextOutline() 
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end