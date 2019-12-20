with open('pitch_freq_table.txt', 'r') as f:
    with open('pitch_period_table.coe', 'w') as coe_file:
        coe_file.write('memory_initialization_radix = 10;\n')
        coe_file.write('memory_initialization_vector = \n')
        coe_file.write(',\n'.join(
            [str(round(1 / float(x) * 1e9)) for x in f.read().split()]))
