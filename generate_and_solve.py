import subprocess
import os

def sphere_call(radius):
    subprocess.call(f"clingo asp_codes/sphere_gen.lp -c radius={radius} -V0 --out-atomf=%s. | head -n 1 > outputs/sphere.db", shell=True)

def generator_call(nb_cuboids, add_args):
    subprocess.call(f"clingo asp_codes/generator.lp outputs/sphere.db asp_codes/rotation.lp -t 8 -c nb_pieces={nb_cuboids} {add_args} -V0 --out-atomf=%s. | head -n 1 >  outputs/cuboids.db", shell=True)

def solver_call(add_args):
    subprocess.call(f"clingo asp_codes/solver.lp asp_codes/rotation.lp outputs/sphere.db outputs/cuboids.db -t 4 {add_args} --outf=2  > outputs/sol.json", shell=True)




if __name__ == "__main__":
    print("Generating sphere")
    sphere_call(2)
    print("Generating problem")
    generator_call(4, "-c realistic=1")
    print("Trying to solve this problem")
    solver_call("-c realistic=1")
