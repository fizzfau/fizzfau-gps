Config = {
    UpdateTick = 500, --msec (Blip update süresi) / (Blip Update Interval)
    ShowYourself = true, -- (Kişinin haritada kendini görüp göremeyeceğini seçin) / (You can see your own blip if true)
    VehicleBlips = true, -- (Araçtayken blip işaretinin değişmesi ayarı) / (Blip sprite changes in vehicle if true)
    Jobs = {
        ["ambulance"] = {
            sprite = 1,
            color = 1,
        },
        ["police"] = {
            sprite = 1,
            color = 84,
        },
        ["sheriff"] = {
            sprite = 1,
            color = 64,
        },
        -- ["fbi"] = { 
        --     sprite = 1, -- (Blip tipi) / (Blip Type)
        --     color = 64, -- Blip Rengi / (Blip Color)
        -- }, -- (Yeni meslekleri bu şekilde ekleyebilirsiniz) / (You can add new jobs as example)
    },
    Codes = {
        ["steam:10000100"] = "M100", -- (Kişilerin telsiz kodlarını bu şekilde kolayca ekleyebilirsiniz) / (You can set players badge codes by using steam identifier)
    },
    Locales = {
        ["unknown"] = "Bilinmiyor",
        ["gps_closed"] = "GPS kapandı!",
        ["gps_opened"] = "Gps açıldı!"
    }
}

--[[ (https://www.fivemsociety.com için özel olarak fizzfau tarafından yazılmıştır.) / (Created by fizzfau for https://www.fivemsociety.com) ]]