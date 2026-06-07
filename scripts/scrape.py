import sys
import collections
from pathlib import Path


def unicode_to_han(unicode):
    return chr(int(unicode[2:], 16))


def han_to_unicode(han):
    return f"U+{ord(han):X}"


def scrape():
    read_path = Path(__file__).parent.parent / "Unihan" / "Unihan_Readings.txt"
    kVietnamese_entries = []
    with open(read_path, 'r') as file:
        line = file.readline()
        # skip comment section
        while line and line[0] == '#':
            line = file.readline().strip()
        # just find the U 
        while line and line[0] == 'U':
            if "kDefinition" in line:
                kVietnamese_entries.append(line)
            line = file.readline()

    write_path = Path(__file__).parent.parent / "output" / "kVietnamese_Definitions.txt"
    with open(write_path, 'w') as file:
        for entry in kVietnamese_entries:
            file.write(entry)


def read_data():
    read_path = Path(__file__).parent.parent / "output" / "kVietnamese_Readings.txt"
    unicode_to_viet = collections.defaultdict(list) 
    viet_to_unicode = collections.defaultdict(list)
    with open(read_path, 'r') as file:
        line = file.readline()
        while line:
            entry = line.split("\t")
            unicode_to_viet[entry[0]].append(entry[2])
            viet_to_unicode[entry[2]].append(entry[0])
            line = file.readline().strip()

    read_path = Path(__file__).parent.parent / "output" / "kVietnamese_Definitions.txt"
    unicode_to_def = collections.defaultdict(list) 
    with open(read_path, 'r') as file:
        line = file.readline()
        while line:
            entry = line.split("\t")
            unicode_to_def[entry[0]].append(entry[2])
            line = file.readline().strip()
    return unicode_to_viet, viet_to_unicode, unicode_to_def


def test():
    unicode_to_viet, viet_to_unicode, unicode_to_def = read_data()
    while True:
        print("Enter Han character or Vietnamese:")
        uin = input()
        # user inputted vietnamese
        if uin in viet_to_unicode:
            unicode_list = viet_to_unicode[uin]
            print(f"Han: {[unicode_to_han(unicode) for unicode in unicode_list]}")
            print(f"Viet: {[unicode_to_viet[unicode] for unicode in unicode_list]}")
            print(f"Def: {[unicode_to_def[unicode] for unicode in unicode_list]}")
        else:
            # user inputted han character
            unicode = han_to_unicode(uin) if len(uin) == 1 else None
            if unicode in unicode_to_viet: # valid mapping to vietnamese
                print(f"Han: {uin}")
                print(f"Viet: {unicode_to_viet[unicode]}")
                print(f"Def: {unicode_to_def[unicode]}")
            else:
                print("Invalid input or no entry found in dictionary.")
        print()


if __name__ == "__main__":
    if len(sys.argv) == 1:
        scrape()
    else:
        test()
