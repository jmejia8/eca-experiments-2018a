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



function runn(func_num, run_num)
    D = 30 #parse(Int, ARGS[1])
    K = 7

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
                              η_max = 2.0,
                                  N = 2K*D,
                             limits = [-100.0, 100.0],
                         correctSol = true,
                        showResults = false,
                        termination = terminationCriteria,
                            saveLast= "tmp/output/t2_gen_f$(func_num)_r$(run_num).csv",
                    saveConvergence = "tmp/output/t2_converg_f$(func_num)_r$(run_num).csv",
                          max_evals = 20000D)

    return abs(func_num*100 - approx.f)
end

function main()
    
    nruns = 1 #NRUNS
    a = 1  #parse(Int, ARGS[2])
    b = 30 #parse(Int, ARGS[3])
    for f = a:b
        
        for rrr = 1:nruns
            r = 15
            ff = runn(f, r)
            @printf("run = %d \t fnum = %d \t f = %e \n", r, f, ff)
        end
        
        println("====================================")
        # break
    end
end



main()
