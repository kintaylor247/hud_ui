ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    ESX.PlayerData = ESX.GetPlayerData()
end)

local toghud = true

RegisterNetEvent('hud:toggleui')
AddEventHandler('hud:toggleui', function(show)

    if show == true then
        toghud = true
    else
        toghud = false
    end

end)

Citizen.CreateThread(function()
    while true do

        if toghud == true then
            if (not IsPedInAnyVehicle(PlayerPedId(), false) )then
                DisplayRadar(0)
            else
                DisplayRadar(1)
            end
        else
            DisplayRadar(0)
        end 
        
        TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
            TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)

                    local myhunger = hunger.getPercent()
                    local mythirst = thirst.getPercent()

                    SendNUIMessage({
                        action = "updateStatusHud",
                        show = toghud,
                        hunger = myhunger,
                        thirst = mythirst,
                    })
                end)
            end)
        Citizen.Wait(5000)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer) 
	local data = xPlayer
	local job = data.job
	SendNUIMessage({action = "setValue", key = "job", value = job.label.." - "..job.grade_label, icon = job.name})
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  SendNUIMessage({action = "setValue", key = "job", value = job.label.." - "..job.grade_label, icon = job.name})
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        local player = PlayerPedId()
        local health = (GetEntityHealth(player) - 100)
        local armor = GetPedArmour(player)
        local oxy = GetPlayerUnderwaterTimeRemaining(PlayerId()) * 10

        SendNUIMessage({
            action = 'updateStatusHud',
            show = toghud,
            health = health,
            armour = armor,
            oxygen = oxy,
        })
        Citizen.Wait(200)
    end
end)
