function utf8.sub(s, i, j)
    i = utf8.offset(s, i)
    j = utf8.offset(s, j + 1) - 1
    return string.sub(s, i, j)
end

function levenstein(str1, str2)
    D = {}
    
    for i = 1, utf8.len(str1) + 1 do
        D[i] = {}
        for j = 1, utf8.len(str2) + 1 do
            if (j == 1) and (i > 1) then
                D[i][j] = i - 1
            elseif (i == 1) and (j > 1) then
                D[i][j] = j - 1
            end
        end
    end

    D[1][1] = 0

    for i = 2, utf8.len(str1) + 1 do
        for j = 2, utf8.len(str2) + 1 do
            -- char1 = string.sub(str1, utf8.offset(str1, i - 1), utf8.offset(str1, i - 1))
            -- char2 = string.sub(str2, utf8.offset(str2, j - 1), utf8.offset(str2, j - 1))

            char1 = utf8.sub(str1, i - 1, i - 1)
            char2 = utf8.sub(str2, j - 1, j - 1)

            val = 1
            if char1 == char2 then
                val = 0
            end

            D[i][j] = math.min(
                D[i][j - 1] + 1,
                D[i - 1][j] + 1,
                D[i - 1][j - 1] + val
            )
        end
    end

    for i = 1, #D do
        print(table.concat(D[i]," "))
    end
    print()

    return D[utf8.len(str1) + 1][utf8.len(str2) + 1]
end

print(levenstein('', ''))
print('-------------------')
print(levenstein('a', 'b'))
print('-------------------')
print(levenstein('a', 'a'))
print('-------------------')
print(levenstein('polynomial', 'exponential'))
