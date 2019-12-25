from coe_writer import write_coe

if __name__ == "__main__":
    with open('pitch_period_table.txt', 'r') as f:
        write_coe('pitch_period_table.coe', 10,  [
                  round(1 / float(x) * 1e9) for x in f.read().split()], True)
