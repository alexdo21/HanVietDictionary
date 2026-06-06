import sys
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


def test():
    read_path = Path(__file__).parent.parent / "output" / "kVietnamese_Readings.txt"
    han_to_viet = {}
    viet_to_han = {}
    with open(read_path, 'r') as file:
        line = file.readline()
        while line:
            entry = line.split("\t")
            han_to_viet[entry[0]] = entry[2]
            viet_to_han[entry[2]] = entry[0]
            line = file.readline().strip()
    read_path = Path(__file__).parent.parent / "output" / "kVietnamese_Definitions.txt"
    han_to_def = {}
    with open(read_path, 'r') as file:
        line = file.readline()
        while line:
            entry = line.split("\t")
            han_to_def[entry[0]] = entry[2]
            line = file.readline().strip()

    while True:
        print("Enter Han character or Vietnamese:")
        uin = input()
        if uin in viet_to_han:
            unicode = viet_to_han[uin]
            print(f"Han: {unicode_to_han(unicode)}")
            print(f"Viet: {han_to_viet[unicode]}")
            print(f"Def: {han_to_def[unicode]}")
        else:
            unicode = han_to_unicode(uin)
            if unicode in han_to_viet:
                print(f"Han: {uin}")
                print(f"Viet: {han_to_viet[unicode]}")
                print(f"Def: {han_to_def[unicode]}")
            else:
                print("Invalid input or no entry found in dictionary.")
        print()
        


if __name__ == "__main__":
    if len(sys.argv) == 1:
        scrape()
    else:
        test()
