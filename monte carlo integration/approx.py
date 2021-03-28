import matplotlib.pyplot as plt
import random
import time


def main():
    other_points = circle_points = 0
    points = []
    for i in range(100):
        x = random.uniform(-1, 1)
        y = random.uniform(-1, 1)
        point = (x, y)
        points.append(point)
        if (x * x) + (y * y) > 1:
            other_points += 1
        else:
            other_points += 1
            circle_points += 1
    pi = 4.0 * float(circle_points / other_points)
    print(pi)

    x, y = zip(*points)

    figure, axes = plt.subplots()
    draw_circle = plt.Circle((0, 0), 1, fill=False)

    axes.set_aspect(1)
    axes.add_artist(draw_circle)

    plt.scatter(x, y)
    plt.title(pi)
    plt.show()
main()

