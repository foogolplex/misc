import random
import matplotlib.pyplot as plt
import numpy as np

def main():
    other_points = sphere_points = 0
    xs = []
    ys = []
    zs = []
    for i in range(500):
        x = random.uniform(-1, 1)
        y = random.uniform(-1, 1)
        z = random.uniform(-1, 1)
        xs.append(x)
        ys.append(y)
        zs.append(z)
        if (x * x) + (y * y) + (z * z) > 1:
            other_points += 1
        else:
            sphere_points += 1
            other_points += 1
    # pi = 6 * volume of sphere / volume of cube
    pi = 6.0 * sphere_points / other_points
    print(pi)

    fig = plt.figure()
    ax = fig.add_subplot(projection='3d')
    ax.scatter(xs, ys, zs)
    u, v = np.mgrid[0:2*np.pi:20j, 0:np.pi:10j]
    x = np.cos(u)*np.sin(v)
    y = np.sin(u)*np.sin(v)
    z = np.cos(v)
    ax.plot_wireframe(x, y, z, color="r")
    plt.title(pi)
    plt.show()
main()