import numpy as np
import random
import json


import matplotlib.pyplot as plt
import json
import random as random
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.ticker as ticker

def set_axis_equal(ax, diameter):
    """
    Make axes of 3D plot have equal scale so that spheres appear as spheres,
    cubes as cubes, etc.

    Input
      ax: a matplotlib axis, e.g., as output from plt.gca().
    """
    
    max_range = diameter
    Xb = 0.5*max_range*np.mgrid[-1:2:2,-1:2:2,-1:2:2][0].flatten() + 0.5
    Yb = 0.5*max_range*np.mgrid[-1:2:2,-1:2:2,-1:2:2][1].flatten() + 0.5
    Zb = 0.5*max_range*np.mgrid[-1:2:2,-1:2:2,-1:2:2][2].flatten() + 0.5
    for xb, yb, zb in zip(Xb, Yb, Zb):
      ax.plot([xb], [yb], [zb], 'w')



def read_sphere_radius(sphere_file) -> int:
    with open(sphere_file) as file:
       for line in file:
          rules = line.split()
          for rule in rules:
             if rule.startswith("radius"):
                rule = rule.split("(")
                value = rule[1].split(")")[0]
                return int(value)
    return -1





def generated_cuboid_map_id(cuboid_file):
    cuboid_map = {}
    color_dict = {}
    count = 0
    with open(cuboid_file) as file:
        for line in file:
            rules = line.split()
            for rule in rules:
                if rule.startswith("output_cuboid"):
                    rule = rule.removeprefix("output_cuboid(").removesuffix(").").split(",")
                    id = rule[0]
                    if id not in cuboid_map:
                        color_dict[id] = (random.random(), random.random(), random.random(), 0.5)
                        cuboid_map[id] = count
                        count += 1
    return (cuboid_map, color_dict)





def solution_cuboid_map_id(json_sol_file):
    cuboid_map = {}
    color_dict = {}
    count = 0
    with open(json_sol_file) as json_data:
        all_pieces_rotated = json.load(json_data)
        for rule in all_pieces_rotated["Call"][0]["Witnesses"][0]["Value"]:
            if rule.startswith("placed_on_grid"):
                rule = rule.removeprefix("placed_on_grid(").removesuffix(")").split(",")
                id = rule[0]
                if id not in cuboid_map:
                    color_dict[id] = (random.random(), random.random(), random.random(), 0.5)
                    cuboid_map[id] = count
                    count += 1
    return (cuboid_map, color_dict)





def get_sphere_data(json_sol_file, radius, cuboid_color_map):
    diameter = radius * 2
    
    cuboid_data = np.zeros([diameter + 1 , diameter + 1 , diameter + 1 ], dtype=np.bool)
    colors = np.zeros([diameter + 1 , diameter + 1 , diameter + 1 , 1], dtype=tuple)
    with open(json_sol_file) as json_data:
        all_pieces_rotated = json.load(json_data)
        for rule in all_pieces_rotated["Call"][0]["Witnesses"][0]["Value"]:
            if rule.startswith("placed_on_grid"):
                rule = rule.removeprefix("placed_on_grid(").removesuffix(")").split(",")
                id = rule[0]
                x,y,z = radius - int(rule[1]), radius - int(rule[2]), radius - int(rule[3])

                cuboid_data[x,y,z] = True
                colors[x,y,z, 0] = cuboid_color_map[id]

    return (cuboid_data, colors)



def get_cuboids_data(cuboids_file, generated_cuboid_map, cuboid_color_map, radius):
    diameter = radius * 2
    nb_cuboids = len(cuboid_color_map)
    
    cuboid_data = np.zeros([nb_cuboids, diameter + 1, diameter + 1, diameter + 1], dtype=np.bool)
    colors = np.zeros([nb_cuboids, diameter + 1, diameter + 1, diameter + 1, 1], dtype=tuple)
    
    with open(cuboids_file) as file:
        for line in file:
            rules = line.split()
            for rule in rules:
                if rule.startswith("output_cuboid"):
                    rule = rule.removeprefix("output_cuboid(").removesuffix(").").split(",")
                    id = rule[0]
                    x,y,z = int(rule[1]), int(rule[2]), int(rule[3])

                    cuboid_data[generated_cuboid_map[id], x, y, z] = True
                    colors[generated_cuboid_map[id], x, y, z, 0] = cuboid_color_map[id]

    return (cuboid_data, colors)



def plot_sphere(fig, axe, data, color_data, radius):
    diameter = radius * 2
    fig.suptitle(f"Resulting sphere of radius {radius}.")

    labels = list(range(0, diameter))


    axe.set_box_aspect([1.,1.,1.])
    set_axis_equal(axe, diameter)
    
    axe.xaxis.set_major_formatter(ticker.NullFormatter())

    format_reversed = [str(i-radius) for i in labels] 
    
    # break
    axe.xaxis.set_minor_locator(ticker.FixedLocator(np.array(labels) + 0.5))
    axe.xaxis.set_minor_formatter( ticker.FixedFormatter(format_reversed) )


    axe.yaxis.set_major_formatter(ticker.NullFormatter())

    axe.yaxis.set_minor_locator(ticker.FixedLocator(np.array(labels) + 0.5))
    axe.yaxis.set_minor_formatter( ticker.FixedFormatter(format_reversed) )


    axe.zaxis.set_major_formatter(ticker.NullFormatter())

    axe.zaxis.set_minor_locator(ticker.FixedLocator(np.array(labels) + 0.5))
    axe.zaxis.set_minor_formatter( ticker.FixedFormatter(format_reversed) )

    axe.voxels(data, facecolors=color_data, edgecolors='black', alpha=1)


# def data_color_grid(json_sol_file, radius, cuboid_id_map, color_id_map):
#     diameter = radius * 2
#     nb_shapes = len(color_id_map)
    
#     cuboid_data = np.zeros([diameter , diameter , diameter ], dtype=np.bool)
#     colors = np.zeros([diameter , diameter , diameter , 1], dtype=tuple)
#     with open(json_sol_file) as json_data:
#         all_pieces_rotated = json.load(json_data)
#         for rule in all_pieces_rotated["Call"][0]["Witnesses"][0]["Value"]:
#             if rule.startswith("output_cuboid"):
#                 rule = rule.removeprefix("placed_on_grid(").removesuffix(")").split(",")
#                 id = rule[0]
#                 x,y,z = int(rule[1]), int(rule[2]), int(rule[3])

#                 cuboid_data[cuboid_id_map[id], x,y,z] = True
#                 colors[cuboid_id_map[id], x,y,z, 0] = color_id_map[id]

#     return (cuboid_data, colors)