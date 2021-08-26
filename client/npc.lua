local koordinaten = {
    {-686.20, 5794.85, 16.33,"Drogendealer",178.59,0xF06B849D,"s_m_m_autoshop_02"}
}


Citizen.CreateThread(function()

    for _,v in pairs(koordinaten) do
      RequestModel(GetHashKey(v[7]))
      while not HasModelLoaded(GetHashKey(v[7])) do
        Wait(1)
      end
  
      RequestAnimDict("facials@p_m_one@variations@normal")
      while not HasAnimDictLoaded("facials@p_m_one@variations@normal") do
        Wait(1)
      end
      ped =  CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, true)
      SetEntityHeading(ped, v[5])
      FreezeEntityPosition(ped, true)
      SetEntityInvincible(ped, true)
      SetBlockingOfNonTemporaryEvents(ped, true)
      TaskPlayAnim(ped,"facials@p_m_one@variations@normal","normal", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    end
end)