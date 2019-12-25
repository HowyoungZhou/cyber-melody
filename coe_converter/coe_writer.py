def write_coe(path, radix, vectors, newline = False):
    formatter = {10: '%d', 16: '%X'}[radix]
    with open(path, 'w') as f:
        f.write('memory_initialization_radix = %d;\n' % radix)
        f.write('memory_initialization_vector = \n')
        f.write((',\n' if newline else ', ').join([formatter % v for v in vectors]))
