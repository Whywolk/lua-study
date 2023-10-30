function factorial(n)
    local res = 1.0
    if n == 0 then
        return res
    else
        for i = 1, n, 1 do
            res = res * i
        end
        return res
    end
end

function factorialRecursive(n)
    if n == 0 then
        return 1
    else
        return n * factorialRecursive(n - 1)
    end
end

while true do
    print("Enter a number: ")
    n = io.read("*n")
    print(factorial(n))
    print(factorialRecursive(n))
end
