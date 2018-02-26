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


function runn(func_num, run_num, D, solver)
    fval = 100func_num
    fitnessFunc(x) = begin 
                        return abs(fval - cec17_test_func(x, func_num))
                    end


    approx, f = solver(fitnessFunc, D)

    if f < TOL
        f = 0.0        
    end

    return f
end

function main()
    
    println("Starting...")
    nruns = 1
    a = parse(Int, ARGS[1])
    b = parse(Int, ARGS[2])
    D = parse(Int, ARGS[3])

    z = []
    for f = a:b
        
        fdata = zeros(nruns)

        for r = 1:nruns
            f_val = runn(f, r, D, eca)
            @printf("run = %d \t fnum = %d \t f = %e \n", r, f, f_val)

            fdata[r] = f_val
        end

        # writecsv("tmp/woa_info_f$(f)_D$(D).csv", fdata)

        push!(z, [ minimum(fdata) mean(fdata) median(fdata) maximum(fdata) std(fdata)])
        
        println("====================================")
        # break
    end
    
    # writecsv("tmp/woa_summary_D$(D)_$(a)_$(b).csv", z)
    println("Done!")
end



main()
