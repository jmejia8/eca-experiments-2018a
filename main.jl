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



function runn(func_num, run_num, D)
    mfes = 10000D

    D_g = 1
    D_h = 1

    fitnessFunc(x) = begin 
    					return cec17_test_func(x, func_num), [0.0], [0.0]
    				end

    terminationCriteria(p) = begin
		    					c = Metaheuristics.getBest(p)
								return abs(c.f - func_num*100) < TOL
		    				end

    approx = ecaConstrained(fitnessFunc, D, D_g, D_h;
                             limits = [-100.0, 100.0],
                         correctSol = true,
                        showResults = true,
                        termination = terminationCriteria,
                            saveLast= "tmp/output/gen_D$(D)_f$(func_num)_r$(run_num).csv",
                    saveConvergence = "tmp/output/converg_D$(D)_f$(func_num)_r$(run_num).csv",
                          max_evals = mfes)

    err = abs(func_num*100 - approx.f)

    if err < TOL
        err = 0.0        
    end

    return err
end

function main()
    
    nruns = 31
    a = parse(Int, ARGS[1])
    b = parse(Int, ARGS[2])
    D = parse(Int, ARGS[3])

    z = []
    for f = a:b
        
        fdata = zeros(nruns)

        for r = 1:nruns
            f_val = runn(f, r, D)
            @printf("run = %d \t fnum = %d \t f = %e \n", r, f, f_val)

            fdata[r] = f_val
        end

        writecsv("tmp/info_f$(f)_D$(D).csv", fdata)

        push!(z, [ minimum(fdata) mean(fdata) median(fdata) maximum(fdata) std(fdata)])
        
        println("====================================")
        # break
    end
    
    writecsv("tmp/summary_D$(D)_$(a)_$(b).csv", z)
end



main()
