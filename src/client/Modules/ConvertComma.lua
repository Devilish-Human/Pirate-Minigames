return function(num)
	local x = tostring(num)
	if #x >= 10 then
		local important = (#x - 9)
		return x:sub(0, important)
			.. ","
			.. x:sub(important + 1, important + 3)
			.. ","
			.. x:sub(important + 4, important + 6)
			.. ","
			.. x:sub(important + 7)
	elseif #x >= 7 then
		local important = (#x - 6)
		return x:sub(0, important) .. "," .. x:sub(important + 1, important + 3) .. "," .. x:sub(important + 4)
	elseif #x >= 4 then
		return x:sub(0, (#x - 3)) .. "," .. x:sub((#x - 3) + 1)
	else
		return num
	end
end
