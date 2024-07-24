local usedSpawnPositions = {} 
local vehiclesSpawned = false 

function GetUniqueSpawnPosition()
    local unusedSpawnPositions = {}
    for i = 1, #Config.VehicleInfo.SpawnPositions do
        local spawnPosition = Config.VehicleInfo.SpawnPositions[i]
        if not usedSpawnPositions[tostring(spawnPosition)] then
            table.insert(unusedSpawnPositions, spawnPosition)
        end
    end

    if #unusedSpawnPositions == 0 then
        return nil
    end

    local randomIndex = math.random(1, #unusedSpawnPositions)
    local spawnPosition = unusedSpawnPositions[randomIndex]
    usedSpawnPositions[tostring(spawnPosition)] = spawnPosition
    return spawnPosition
end

RegisterNetEvent("uggishresources:client:spawnCars")
AddEventHandler("uggishresources:client:spawnCars", function()
    if vehiclesSpawned then
        print("Vehicles have already been spawned.")
        return
    end

    vehiclesSpawned = true
    print("Cars Spawned")

    for i = 1, #Config.VehicleInfo.VehicleModels do
        local chosenModel = Config.VehicleInfo.VehicleModels[i]

        RequestModel(chosenModel)
        while not HasModelLoaded(chosenModel) do
            Citizen.Wait(0)
        end

        local spawnPosition = GetUniqueSpawnPosition()
        if spawnPosition then
            local vehicle = CreateVehicle(chosenModel, spawnPosition.x, spawnPosition.y, spawnPosition.z, Config.VehicleInfo.HeadingPosition.Heading, true, false)

            SetVehicleOnGroundProperly(vehicle)
            SetVehicleDoorsLockedForAllPlayers(vehicle)
            SetVehicleAlarm(vehicle)
            Citizen.Wait(100) 
        else
            print("No available spawn positions.")
            break
        end
    end
end)


RegisterCommand("cars", function()
    TriggerEvent("uggishresources:client:spawnCars")
end)


Citizen.CreateThread(function()
    Citizen.Wait(0)
    if BlipSettings.showBlips then 
        for i = 1, #BlipSettings.Blips, 1 do 
            local blipCoords = BlipSettings.Blips[i]
            local uBlip = AddBlipForCoord(blipCoords.x, blipCoords.y, blipCoords.z)
            SetBlipAsShortRange(uBlip, true)
            SetBlipColour(uBlip, BlipSettings.BlipColour)
            SetBlipSprite(uBlip, BlipSettings.BlipModel)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(BlipSettings.TextOnMap)
            EndTextCommandSetBlipName(uBlip)
        end
    end
end)

    
