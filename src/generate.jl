using Plots
using Random
function main()
    @assert length(ARGS) == 2 "type like julia hoge.jl 100 test"
    numdata = parse(Int64,ARGS[1])
    filenameheader = ARGS[2]
    filename = filenameheader*"_$(numdata)"
    f(x,y) = cos(x+y)*exp(-x) + x^2 + x*y +sin(4x*y) +exp(-2y) + sin(4x)*cos(5x)
    xs = range(0,1,length=numdata)
    ys = range(0,1,length=numdata)
    z =[f(i,j) for i in xs, j in ys]'
    p = plot(xs,ys,z, st=:wireframe)
    savefig("$filename.png")
    fp = open(filename*"2d.txt","w")
    for i=1:numdata
        x = rand()
        y = rand()
        z = f(x,y) +(2*rand()-1)*1e-1
        println(fp,"$(x) $(y) $z")
    end
    close(fp)
end

using SpecialFunctions

function make_3d()
    Random.seed!(123)
    @assert length(ARGS) == 2 "type like julia hoge.jl 100 test"
    numdata = parse(Int64,ARGS[1])
    filenameheader = ARGS[2]
    filename = filenameheader*"_$(numdata)"
    f(x,y,z) = besselj(2,z)*cos(4x)+x*y*z^2+cos(x*y*z) + sin(3y*z) + exp((x^2+y^2)/3)
    fp = open(filename*"_3d.txt","w")
    tdata = zeros(Float64,numdata)
    for i=1:numdata
        x = rand()
        y = rand()
        z = rand()
        t = f(x,y,z) +(2*rand()-1)*1e-1
        println(fp,"$(x) $(y) $(z) $t")
        #println(t)
        tdata[i] = t
    end
    close(fp)
    histogram(tdata,bins=50)
    savefig(filename*"_3d_hist.png")
end
make_3d()
#main()