-- File: Number
-- Author: PirateNinja
-- Date: 07/16/2021

local Number = {}

function Number:Mutlipy(num1, num2)
    return (num1 * num2)
end

function Number:Divide (num1 , num2)
    return (num1 / num2)
end

function Number:Add (num1: number, num2: number)
    return (num1 + num2)
end

function Number:Subtract (num1: number, num2: number)
    return (num1 - num2)
end

return Number