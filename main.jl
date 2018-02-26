using CEC17, Metaheuristics


TOL = 1e-8

function terminationc(p)
	c = CEC17.getBest(p)
	return 
end

function DPW(data)
	N = size(data, 1)
	s = 0.0
	for i = 1:N
		for j = (i+1):N
			s += norm(data[i,:] - data[j,:])
		end
	end
	return  (2.0 / (N * (N - 1) )) * s
end


function runn(func_num, run_num, D, solverName)
    fval = 100func_num
    fitnessFunc(x) = begin 
                        return abs(fval - cec17_test_func(x, func_num))
                    end

    if solverName == "eca"
        solver = eca
    elseif solverName == "GSA"
        solver = GSA
    elseif solverName == "SA"
        solver = SA
    elseif solverName == "WOA"
        solver = WOA
    elseif solverName == "diffEvolution"
        solver = diffEvolution
    else
        return
    end

    myPath = "tmp/$solverName"
    if !isdir(myPath)
        mkdir(myPath)
    end

    n1 = "$myPath/popu_D_$(D)_f$(func_num)_r$(run_num).csv"
    n2 = "$myPath/conver_D_$(D)_f$(func_num)_r$(run_num).csv"
    
    approx, f = solver(fitnessFunc, D;
                               saveLast = n1,
                        saveConvergence = n2)

    if f < TOL
        f = 0.0        
    end

    return f
end

function main()
    
    println("Starting...")
    nruns = 2
    a = parse(Int, ARGS[1])
    b = parse(Int, ARGS[2])
    D = parse(Int, ARGS[3])

    # solver functions names
    solvers = ["eca", "GSA", "SA", "WOA", "diffEvolution"]

    for solverName in solvers
        z = []
        for f = a:b
            
            fdata = zeros(nruns)

            for r = 1:nruns
                f_val = runn(f, r, D, solverName)
                @printf("run = %d \t fnum = %d \t f = %e \n", r, f, f_val)

                fdata[r] = f_val
            end

            writecsv("tmp/$(solverName)_info_f$(f)_D$(D).csv", fdata)

            push!(z, [ minimum(fdata) mean(fdata) median(fdata) maximum(fdata) std(fdata)])
            
            println("====================================")
        end
        
        writecsv("tmp/$(solverName)_summary_D$(D)_$(a)_$(b).csv", z)
    end

    println("Done!")
end



main()
