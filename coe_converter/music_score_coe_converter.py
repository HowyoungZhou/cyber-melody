import re
import sys
import math
from coe_writer import write_coe

num_notes_map = {
    "0": -1,
    "1": 0,
    "#1": 1,
    "2": 2,
    "#2": 3,
    "3": 4,
    "#3": 5,
    "4": 5,
    "#4": 6,
    "5": 7,
    "#5": 8,
    "6": 9,
    "#6": 10,
    "7": 11,
}

notes_map = {
    "C": 0,
    "C#": 1,
    "D": 2,
    "D#": 3,
    "E": 4,
    "F": 5,
    "F#": 6,
    "G": 7,
    "G#": 8,
    "A": 9,
    "A#": 10,
    "B": 11
}

notes = ['Rest', 'C', 'C#', 'D', 'D#', 'E',
         'F', 'F#', 'G', 'G#', 'A', 'A#', 'B', '(invalid)', '(invalid)', '(EOF)']


def lenoc_generator():
    with open(sys.argv[1]) as f:
        base_num, key_note, key_octave = re.match(
            r'(#?[0-7])\s*=\s*([A-G]#?)([0-9])', f.readline()).groups()
        _, beats = re.match(r'([0-9]*)\s*\/\s*([0-9]+)', f.readline()).groups()
        bpm, = re.match(r'BPM\s*=\s*([0-9]+)', f.readline()).groups()
        beats = int(beats)
        bpm = int(bpm)
        base_num = num_notes_map[base_num]
        key_note = notes_map[key_note]
        key_octave = int(key_octave)
        base_note = key_octave * 12 + key_note
        items = f.read().split()
        for note in items:
            (length, note, octave) = parse_note(note, base_num, base_note)
            print('%3.3lf %4s %1d' % (length * beats, notes[note], octave))
            length *= beats * 60 * 1000 / bpm
            yield math.floor(length) << 8 | note << 4 | octave


def parse_note(item: str, base_num: int, base_note: int):
    length = 1/4
    note_code = base_note
    state = 'prefix'
    note_str = ''
    dotted_result = 1
    dot_counts = 0
    for ch in item:
        if state == 'prefix':
            if ch == '.':
                note_code += 12
            elif ch.isdigit() or ch == '#' or ch == 'E':
                state = 'note'
        if state == 'note':
            if ch.isdigit() or ch == '#' or ch == 'E':
                note_str += ch
            else:
                state = 'postfix'
        if state == 'postfix':
            if ch == '.':
                note_code -= 12
            elif ch == '_':
                length /= 2
            elif ch == '-':
                length += 1/4
            elif ch == '*':
                dot_counts += 1
                dotted_result += 1/2**dot_counts
    length *= dotted_result
    if note_str == '0':
        return (length, 0, 0)
    if note_str == 'E':
        return (0, 15, 0)
    note_code += num_notes_map[note_str]-base_num
    octave = note_code // 12
    note = note_code % 12
    return (length, note + 1, octave)


if __name__ == "__main__":
    write_coe(sys.argv[2], 16, lenoc_generator())
