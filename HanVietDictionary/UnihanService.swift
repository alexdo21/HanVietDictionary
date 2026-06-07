//
//  UnihanService.swift
//  HanVietDictionary
//
//  Created by Alex Do on 6/6/26.
//

import Foundation

struct UnihanResult {
    let hanCharList: [String]
    let vietReadings: [String]
    let definitions: [String]
}

class UnihanService {
    var unicodeToViet: [String: [String]] = [:]
    var vietToUnicode: [String: [String]] = [:]
    var unicodeToDef: [String: [String]] = [:]

    init() async {
        await loadData()
    }
    
    private func loadData() async {
        guard let kVietnameseReadingsFileURL = Bundle.main.url(forResource: "kVietnamese_Readings", withExtension: "txt") else {
            print("Could not find readings file")
            return
        }
        guard let kVietnameseDefinitionsFileURL = Bundle.main.url(forResource: "kVietnamese_Definitions", withExtension: "txt") else {
            print("Could not find definitions file")
            return
        }
        
        do {
            for try await line in kVietnameseReadingsFileURL.lines {
                let entry = line.split(separator: "\t")
                unicodeToViet[String(entry[0]), default: []].append(String(entry[2]))
                vietToUnicode[String(entry[2]), default: []].append(String(entry[0]))
            }
        } catch {
            print("Error parsing readings")
        }

        do {
            for try await line in kVietnameseDefinitionsFileURL.lines {
                let entry = line.split(separator: "\t")
                unicodeToDef[String(entry[0]), default: []].append(String(entry[2]))
            }
        } catch {
            print("Error parsing definitions")
        }
    }
    
    private func unicodeToHan(_ unicode: String) -> Character? {
        let hexString = unicode.dropFirst(2)
        guard let codePoint = UInt32(hexString, radix: 16) else { return nil }
        guard let scalar = UnicodeScalar(codePoint) else { return nil }
        return Character(scalar)
    }
    
    private func hanToUnicode(_ han: Character) -> String? {
        guard let firstScalar = han.unicodeScalars.first else { return nil }
        let hexString = String(firstScalar.value, radix: 16, uppercase: true)
        return "U+\(hexString)"
    }
    
    func getReadingsAndDefinitions(byInput input: String) -> UnihanResult? {
        let input = input.lowercased()
        if let unicode_list = vietToUnicode[input] {
            let hanCharList: [String] = unicode_list.map {
                if let han = unicodeToHan($0) {
                    return String(han)
                } else {
                    return ""
                }
            }
            var vietReadings: [String] = []
            for unicode in unicode_list {
                if let vietList = unicodeToViet[unicode] {
                    vietReadings.append(contentsOf: vietList)
                } else {
                    vietReadings.append("")
                }
            }
            var hanDefList: [String] = []
            for unicode in unicode_list {
                if let def = unicodeToDef[unicode] {
                    hanDefList.append(contentsOf: def)
                } else {
                    hanDefList.append("")
                }
            }
            print("Han: \(hanCharList)")
            print("Viet: \(vietReadings)")
            print("Def: \(hanDefList)")
            return UnihanResult(hanCharList: hanCharList, vietReadings: vietReadings, definitions: hanDefList)
        } else {
            let unicode = input.count == 1 ? hanToUnicode(Character(input)) : nil
            if let unicode, unicodeToViet[unicode] != nil {
                let vietReadings: [String] = unicodeToViet[unicode] ?? []
                let hanDefList: [String] = unicodeToDef[unicode] ?? []
                print("Han: \(input)")
                print("Viet: \(vietReadings)")
                print("Def: \(hanDefList)")
                return UnihanResult(hanCharList: [input], vietReadings: vietReadings, definitions: hanDefList)
            } else {
                print("Invalid input or no entry found in dictionary.")
            }
        }
        return nil
    }
}
