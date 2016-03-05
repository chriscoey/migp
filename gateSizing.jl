
using Convex, SCS, Pajarito, Gurobi, ECOS

fe = [1, 0.8, 1, 0.7, 0.7, 0.5, 0.5] .* [1, 2, 1, 1.5, 1.5, 1, 2]
Cout6 = 10
Cout7 = 10

xUB = 5 #40


y = Variable(7)
z = Variable(xUB,7,Positive(),:Bin)

D1 = exp(-y[1]) + exp(-y[1] + y[4])
D2 = 2 * exp(-y[2]) + exp(-y[2] + y[4]) + exp(-y[2] + y[5])
D3 = 2 * exp(-y[3]) + exp(-y[3] + y[5]) + exp(-y[3] + y[7])
D4 = 2 * exp(-y[4]) + exp(-y[4] + y[6]) + exp(-y[4] + y[7])
D5 = exp(-y[5]) + exp(-y[5] + y[7])
D6 = Cout6 * exp(-y[6])
D7 = Cout7 * exp(-y[7])

problem = minimize(maximum([
    (D1+D4+D6), (D1+D4+D7), (D2+D4+D6), (D2+D4+D7),
    (D2+D5+D7), (D3+D5+D6), (D3+D7)]),
    y >= 0,
    sum(fe .* exp(y)) <= 20,
    sum(exp(y)) <= 100,
    )

for i=1:7
    problem.constraints += sum(z[:,i]) == 1
    problem.constraints += y[i] == sum([log(j) * z[j,i] for j=1:xUB])
end

#solve!(problem, SCSSolver(verbose=0))





Convex.solve!(problem, PajaritoConicSolver(
    mip_solver=GurobiSolver(),
    conic_solver=ECOSSolver()))
