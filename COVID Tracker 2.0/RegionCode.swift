//
//  ISO2ISO3.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 2/8/22.
//

import Foundation

struct RegionCode {
    static let iso2ToiSO3: [String: String] = ["AF": "AFG", "AX": "ALA", "AL": "ALB", "DZ": "DZA", "AS": "ASM", "AD": "AND", "AO": "AGO", "AI": "AIA", "AQ": "ATA", "AG": "ATG", "AR": "ARG", "AM": "ARM", "AW": "ABW", "AU": "AUS", "AT": "AUT", "AZ": "AZE", "BS": "BHS", "BH": "BHR", "BD": "BGD", "BB": "BRB", "BY": "BLR", "BE": "BEL", "BZ": "BLZ", "BJ": "BEN", "BM": "BMU", "BT": "BTN", "BO": "BOL", "BQ": "BES", "BA": "BIH", "BW": "BWA", "BV": "BVT", "BR": "BRA", "IO": "IOT", "BN": "BRN", "BG": "BGR", "BF": "BFA", "BI": "BDI", "CV": "CPV", "KH": "KHM", "CM": "CMR", "CA": "CAN", "KY": "CYM", "CF": "CAF", "TD": "TCD", "CL": "CHL", "CN": "CHN", "CX": "CXR", "CC": "CCK", "CO": "COL", "KM": "COM", "CG": "COG", "CD": "COD", "CK": "COK", "CR": "CRI", "CI": "CIV", "HR": "HRV", "CU": "CUB", "CW": "CUW", "CY": "CYP", "CZ": "CZE", "DK": "DNK", "DJ": "DJI", "DM": "DMA", "DO": "DOM", "EC": "ECU", "EG": "EGY", "SV": "SLV", "GQ": "GNQ", "ER": "ERI", "EE": "EST", "SZ": "SWZ", "ET": "ETH", "FK": "FLK", "FO": "FRO", "FJ": "FJI", "FI": "FIN", "FR": "FRA", "GF": "GUF", "PF": "PYF", "TF": "ATF", "GA": "GAB", "GM": "GMB", "GE": "GEO", "DE": "DEU", "GH": "GHA", "GI": "GIB", "GR": "GRC", "GL": "GRL", "GD": "GRD", "GP": "GLP", "GU": "GUM", "GT": "GTM", "GG": "GGY", "GN": "GIN", "GW": "GNB", "GY": "GUY", "HT": "HTI", "HM": "HMD", "VA": "VAT", "HN": "HND", "HK": "HKG", "HU": "HUN", "IS": "ISL", "IN": "IND", "ID": "IDN", "IR": "IRN", "IQ": "IRQ", "IE": "IRL", "IM": "IMN", "IL": "ISR", "IT": "ITA", "JM": "JAM", "JP": "JPN", "JE": "JEY", "JO": "JOR", "KZ": "KAZ", "KE": "KEN", "KI": "KIR", "KP": "PRK", "KR": "KOR", "KW": "KWT", "KG": "KGZ", "LA": "LAO", "LV": "LVA", "LB": "LBN", "LS": "LSO", "LR": "LBR", "LY": "LBY", "LI": "LIE", "LT": "LTU", "LU": "LUX", "MO": "MAC", "MK": "MKD", "MG": "MDG", "MW": "MWI", "MY": "MYS", "MV": "MDV", "ML": "MLI", "MT": "MLT", "MH": "MHL", "MQ": "MTQ", "MR": "MRT", "MU": "MUS", "YT": "MYT", "MX": "MEX", "FM": "FSM", "MD": "MDA", "MC": "MCO", "MN": "MNG", "ME": "MNE", "MS": "MSR", "MA": "MAR", "MZ": "MOZ", "MM": "MMR", "NA": "NAM", "NR": "NRU", "NP": "NPL", "NL": "NLD", "NC": "NCL", "NZ": "NZL", "NI": "NIC", "NE": "NER", "NG": "NGA", "NU": "NIU", "NF": "NFK", "MP": "MNP", "NO": "NOR", "OM": "OMN", "PK": "PAK", "PW": "PLW", "PS": "PSE", "PA": "PAN", "PG": "PNG", "PY": "PRY", "PE": "PER", "PH": "PHL", "PN": "PCN", "PL": "POL", "PT": "PRT", "PR": "PRI", "QA": "QAT", "RE": "REU", "RO": "ROU", "RU": "RUS", "RW": "RWA", "BL": "BLM", "SH": "SHN", "KN": "KNA", "LC": "LCA", "MF": "MAF", "PM": "SPM", "VC": "VCT", "WS": "WSM", "SM": "SMR", "ST": "STP", "SA": "SAU", "SN": "SEN", "RS": "SRB", "SC": "SYC", "SL": "SLE", "SG": "SGP", "SX": "SXM", "SK": "SVK", "SI": "SVN", "SB": "SLB", "SO": "SOM", "ZA": "ZAF", "GS": "SGS", "SS": "SSD", "ES": "ESP", "LK": "LKA", "SD": "SDN", "SR": "SUR", "SJ": "SJM", "SE": "SWE", "CH": "CHE", "SY": "SYR", "TW": "TWN", "TJ": "TJK", "TZ": "TZA", "TH": "THA", "TL": "TLS", "TG": "TGO", "TK": "TKL", "TO": "TON", "TT": "TTO", "TN": "TUN", "TR": "TUR", "TM": "TKM", "TC": "TCA", "TV": "TUV", "UG": "UGA", "UA": "UKR", "AE": "ARE", "GB": "GBR", "US": "USA", "UM": "UMI", "UY": "URY", "UZ": "UZB", "VU": "VUT", "VE": "VEN", "VN": "VNM", "VG": "VGB", "VI": "VIR", "WF": "WLF", "EH": "ESH", "YE": "YEM", "ZM": "ZMB", "ZW": "ZWE"]
    
    static let states: [String:String] = [
        "AK": "Alaska", "AL": "Alabama", "AR": "Arkansas", "AZ": "Arizona", "CA": "California",
        "CO": "Colorado", "CT": "Connecticut", "DC": "District of Columbia", "DE": "Delaware",
        "FL": "Florida", "GA": "Georgia", "HI": "Hawaii", "IA": "Iowa", "ID": "Idaho", "IL": "Illinois",
        "IN": "Indiana", "KS": "Kansas", "KY": "Kentucky", "LA": "Louisiana", "MA": "Massachusetts",
        "MD": "Maryland", "ME": "Maine", "MI": "Michigan", "MN": "Minnesota", "MO": "Missouri",
        "MS": "Mississippi", "MT": "Montana", "NC": "North Carolina", "ND": "North Dakota", "NE": "Nebraska",
        "NH": "New Hampshire", "NJ": "New Jersey", "NM": "New Mexico", "NV": "Nevada","NY": "New York",
        "OH": "Ohio", "OK": "Oklahoma", "OR": "Oregon", "PA": "Pennsylvania", "RI": "Rhode Island",
        "SC": "South Carolina", "SD": "South Dakota", "TN": "Tennessee", "TX": "Texas", "UT": "Utah",
        "VA": "Virginia", "VT": "Vermont", "WA": "Washington", "WI": "Wisconsin", "WV": "West Virginia",
        "WY": "Wyoming"]
    
    static let prefectures: [String:Coodinate] = [
        "Hokkaido": Coodinate(lat: 43.064170000000004, long: 141.34694), "Aomori" : Coodinate(lat: 40.82444, long: 140.74),
        "Iwate" : Coodinate(lat: 39.70361, long: 141.1525), "Miyagi" : Coodinate(lat: 38.26889, long: 140.87194),
        "Akita" : Coodinate(lat: 39.71861, long: 140.1025), "Yamagata" : Coodinate(lat: 38.240559999999995, long: 140.36333),
        "Fukushima" : Coodinate(lat: 37.75, long: 140.46778), "Ibaraki" : Coodinate(lat: 36.341390000000004, long: 140.44666999999998),
        "Tochigi" : Coodinate(lat: 36.56583, long: 139.88361), "Gunma" : Coodinate(lat: 36.39111, long: 139.06083),
        "Saitama" : Coodinate(lat: 35.85694, long: 139.64889), "Chiba" : Coodinate(lat: 35.60472, long: 140.12333),
        "Tokyo" : Coodinate(lat: 35.689440000000005, long: 139.69167), "Kanagawa" : Coodinate(lat: 35.44778, long: 139.6425),
        "Niigata" : Coodinate(lat: 37.90222, long: 139.02361000000002), "Toyama" : Coodinate(lat: 36.69528, long: 137.21139),
        "Ishikawa" : Coodinate(lat: 36.594440000000006, long: 136.62556), "Fukui" : Coodinate(lat: 36.06528, long: 136.22194),
        "Yamanashi" : Coodinate(lat: 35.66389, long: 138.56833), "Nagano" : Coodinate(lat: 36.65139, long: 138.18111000000002),
        "Gifu" : Coodinate(lat: 35.39111, long: 136.72222), "Shizuoka" : Coodinate(lat: 34.97694, long: 138.38306),
        "Aichi" : Coodinate(lat: 35.180279999999996, long: 136.90667), "Mie" : Coodinate(lat: 34.73028, long: 136.50861),
        "Shiga" : Coodinate(lat: 35.00444, long: 135.86833000000001), "Kyoto" : Coodinate(lat: 35.021390000000004, long: 135.75556),
        "Osaka" : Coodinate(lat: 34.68639, long: 135.52), "Hyogo" : Coodinate(lat: 34.691390000000006, long: 135.18306),
        "Nara" : Coodinate(lat: 34.68528, long: 135.83278), "Wakayama" : Coodinate(lat: 34.22611, long: 135.1675),
        "Tottori" : Coodinate(lat: 35.503609999999995, long: 134.23833), "Shimane" : Coodinate(lat: 35.47222, long: 133.05056000000002),
        "Okayama" : Coodinate(lat: 34.66167, long: 133.935), "Hiroshima" : Coodinate(lat: 34.396390000000004, long: 132.45944),
        "Yamaguchi" : Coodinate(lat: 34.185829999999996, long: 131.47138999999999), "Tokushima" : Coodinate(lat: 34.06583, long: 134.55944),
        "Kagawa" : Coodinate(lat: 34.34028, long: 134.04333), "Ehime" : Coodinate(lat: 33.84167, long: 132.76611),
        "Kochi" : Coodinate(lat: 33.55972, long: 133.53111), "Fukuoka" : Coodinate(lat: 33.606390000000005, long: 130.41806),
        "Saga" : Coodinate(lat: 33.24944, long: 130.29889), "Nagasaki" : Coodinate(lat: 32.74472, long: 129.87361),
        "Kumamoto" : Coodinate(lat: 32.78972, long: 130.74167), "Oita" : Coodinate(lat: 33.23806, long: 131.6125),
        "Miyazaki" : Coodinate(lat: 31.911109999999997, long: 131.42389), "Kagoshima" : Coodinate(lat: 31.56028, long: 130.55806),
        "Okinawa" : Coodinate(lat: 26.2125, long: 127.68111)
    ]
}
