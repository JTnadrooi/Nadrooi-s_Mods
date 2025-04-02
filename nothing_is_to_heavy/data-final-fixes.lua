for _, item in pairs(data.raw["item"]) do
    if item.weight and (item.weight > 1000000) then
        item.weight = 1000000
    end
end