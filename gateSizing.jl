
using Convex, SCS

fe = [1, 0.8, 1, 0.7, 0.7, 0.5, 0.5] .* [1, 2, 1, 1.5, 1.5, 1, 2]
Cout6 = 10
Cout7 = 10

y = Variable(7)

C = ones(7) + exp(y)
A = sum(exp(y))
P = sum(fe .* exp(y))
R = exp(-y)

D1 = exp(-y[1]) + 1
D2 = 2 * exp(-y[2]) + exp(-y[2] + y[4]) + exp(-y[2] + y[5])
D3 = 2 * exp(-y[3]) + exp(-y[3] + y[5]) + exp(-y[3] + y[7])
D4 = 2 * exp(-y[4]) + exp(-y[4] + y[6]) + exp(-y[4] + y[7])
D5 = exp(-y[5]) + exp(-y[5] + y[7])
D6 = Cout6 * exp(-y[6])
D7 = Cout7 * exp(-y[7])

problem = minimize(maximum([
    (D1+D4+D6), (D1+D4+D7), (D2+D4+D6), (D2+D4+D7),
    (D2+D5+D7), (D3+D5+D6), (D3+D7)]
    ), y >= 0, P <= 20, A <= 100)

solve!(problem, SCSSolver(verbose=0))

println(problem.optval)
println(y.value)
