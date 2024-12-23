#!/usr/bin/env python3

import json
import sys

fileName = sys.argv[1]
with open(fileName, 'r') as file:
    data = json.load(file)
    print("Clocks:")
    for key, value in data["fmax"].items():
        print("    {:>20}: {:>8.2f} MHz max (Constraint: {:.2f} MHz)".format(key, value["achieved"], value["constraint"]))
    print()
    print("Utilization:")
    for key, value in data["utilization"].items():
        used = value["used"]
        available = value["available"]
        if (used > 0 and available > 0):
            print("    {:>20}: {:>8} {:>8} {:>8.1f}%".format(key, used, available, (used / (available)) * 100))
