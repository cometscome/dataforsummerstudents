using JSON

struct Atomic_data
    names::Vector{String}
    num_kinds::Int64
    num_totalatoms::Int64
    energy::Float64
    num_atoms::Vector{Int64}
    num_elements::Vector{Int64}
    data::Vector{Matrix{Float64}}
end

function make_train_test_data()
    dirname = "../../structures/"
    files = readdir(dirname)
    files = dirname .* files
    numfiles = length(files)
    #println(files)
    alldata = []
    #data = make_data(files[1])
    for file in files
        data = make_data(file)
        input = Matrix[data.data[i] for i = 1:data.num_kinds]
        #=
            input[1] はTiのデータ。サイズはアトム数x係数。
            input[2] はOのデータ。サイズはアトム数x係数。
            アトム数はデータによって変化している。
        =#
        push!(alldata, (input, data.energy))
        #make_data(file)
    end
    #println(alldata[1])

    test_ratio = 0.1
    num_test = ceil(Int64, test_ratio * numfiles)
    num_train = numfiles - num_test
    A = rand(1:numfiles, numfiles) #インデックスをシャッフル
    testdata = []
    traindata = []

    for i = 1:num_train
        push!(traindata, alldata[A[i]])
    end
    for i = 1:num_test
        push!(testdata, alldata[A[num_train+i]])
    end

    return traindata, testdata

end



function make_data(file)
    jsonfile = JSON.parsefile(file)
    names = jsonfile["names"]
    num_kinds = length(names)
    num_totalatoms = jsonfile["num_totalatoms"]
    energy = jsonfile["energy"]
    num_elements = zeros(Int64, num_kinds)
    num_atoms = zeros(Int64, num_kinds)
    data = Vector{Matrix{Float64}}(undef, num_kinds)

    for i = 1:num_kinds
        data_i = jsonfile[names[i]]
        num_elements[i] = data_i["num_elements"]
        num_atoms[i] = data_i["num_atoms"]

        data[i] = zeros(Float64, num_elements[i], num_atoms[i])
        for iatom = 1:num_atoms[i]
            for j = 1:num_elements[i]
                data[i][j, iatom] = data_i["data"][iatom][j]
            end
        end
    end

    return Atomic_data(
        names,
        num_kinds,
        num_totalatoms,
        energy,
        num_atoms,
        num_elements,
        data,
    )


end