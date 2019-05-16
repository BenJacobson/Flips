from itertools import combinations
from random import randrange

def make_file_name(combo, i):
    file_name = ''.join(combo)
    file_name += str(i) + 'x' + str(i)
    return file_name


level_data_path = "..\\leveldata\\"
cell_types = ['G', 'B', 'R']
sizes = [4, 5, 6]
levels_per_pack = 20
manifest_file_name = "manifest"
manifest_data = ""

for size in sizes:
    for i in range(1, len(cell_types)+1):
        for combo in combinations(cell_types, i):
            file_name = make_file_name(combo, size)
            manifest_data += file_name + '\n'
            with open(level_data_path + file_name, "w") as f:
                f.write(''.join(combo) + '\n')
                f.write(str(size) + ' ' + str(size) + '\n')
                for _ in range(levels_per_pack):
                    level_data = ''.join([c.upper() if randrange(2) else c.lower() for c in [combo[randrange(len(combo))] for j in range(size*size)]])
                    f.write(level_data + '\n')

with open(level_data_path + manifest_file_name, "w") as f:
    f.write(manifest_data)
