--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

Clockwork.kernel = Clockwork.kernel or {}
Clockwork.kernel.countries = {
	["UNKNOWN"] = "Unknown",
	["AD"] = "Andorra",
	["AE"] = "the United Arab Emirates",
	["AF"] = "Afghanistan",
	["AG"] = "Antigua and Barbuda",
	["AI"] = "Anguilla",
	["AL"] = "Albania",
	["AM"] = "Armenia",
	["AO"] = "Angola",
	["AQ"] = "Antarctica",
	["AR"] = "Argentina",
	["AS"] = "American Samoa",
	["AT"] = "Austria",
	["AU"] = "Australia",
	["AW"] = "Aruba",
	["AX"] = "Aland Islands",
	["AZ"] = "Azerbaijan",
	["BA"] = "Bosnia and Herzegovina",
	["BB"] = "Barbados",
	["BD"] = "Bangladesh",
	["BE"] = "Belgium",
	["BF"] = "Burkina Faso",
	["BG"] = "Bulgaria",
	["BH"] = "Bahrain",
	["BI"] = "Burundi",
	["BJ"] = "Benin",
	["BL"] = "Saint Barthelemy",
	["BM"] = "Bermuda",
	["BN"] = "Brunei Darussalam",
	["BO"] = "Bolivia",
	["BQ"] = "Bonaire, Sint Eustatius and Saba",
	["BR"] = "Brazil",
	["BS"] = "Bahamas",
	["BT"] = "Bhutan",
	["BV"] = "Bouvet Island",
	["BW"] = "Botswana",
	["BY"] = "Belarus",
	["BZ"] = "Belize",
	["CA"] = "Canada",
	["CC"] = "Cocos Islands",
	["CD"] = "the Democratic Republic of the Congo",
	["CF"] = "Central African Republic",
	["CG"] = "Congo",
	["CH"] = "Switzerland",
	["CI"] = "Coted'Ivoire",
	["CK"] = "Cook Islands",
	["CL"] = "Chile",
	["CM"] = "Cameroon",
	["CN"] = "China",
	["CO"] = "Colombia",
	["CR"] = "Costa Rica",
	["CU"] = "Cuba",
	["CV"] = "Cabo Verde",
	["CW"] = "Curacao",
	["CX"] = "Christmas Island",
	["CY"] = "Cyprus",
	["CZ"] = "Czechia",
	["DE"] = "Germany",
	["DJ"] = "Djibouti",
	["DK"] = "Denmark",
	["DM"] = "Dominica",
	["DO"] = "the Dominican Republic",
	["DZ"] = "Algeria",
	["EC"] = "Ecuador",
	["EE"] = "Estonia",
	["EG"] = "Egypt",
	["EH"] = "Western Sahara",
	["ER"] = "Eritrea",
	["ES"] = "Spain",
	["ET"] = "Ethiopia",
	["FI"] = "Finland",
	["FJ"] = "Fiji",
	["FK"] = "Falkland Islands (Malvinas)",
	["FM"] = "Federated States of Micronesia",
	["FO"] = "Faroe Islands",
	["FR"] = "France",
	["GA"] = "Gabon",
	["GB"] = "United Kingdom",
	["GD"] = "Grenada",
	["GE"] = "Georgia",
	["GF"] = "French Guiana",
	["GG"] = "Guernsey",
	["GH"] = "Ghana",
	["GI"] = "Gibraltar",
	["GL"] = "Greenland",
	["GM"] = "Gambia",
	["GN"] = "Guinea",
	["GP"] = "Guadeloupe",
	["GQ"] = "Equatorial Guinea",
	["GR"] = "Greece",
	["GS"] = "South Georgia and the South Sandwich Islands",
	["GT"] = "Guatemala",
	["GU"] = "Guam",
	["GW"] = "Guinea-Bissau",
	["GY"] = "Guyana",
	["HK"] = "HongKong",
	["HM"] = "Heard Island and McDonald Islands",
	["HN"] = "Honduras",
	["HR"] = "Croatia",
	["HT"] = "Haiti",
	["HU"] = "Hungary",
	["ID"] = "Indonesia",
	["IE"] = "Ireland",
	["IL"] = "Palestine",
	["IN"] = "India",
	["IO"] = "British Indian Ocean Territory",
	["IQ"] = "Iraq",
	["IR"] = "Islamic Republic of Iran",
	["IS"] = "Iceland",
	["IT"] = "Italy",
	["JE"] = "Jersey",
	["JM"] = "Jamaica",
	["JO"] = "Jordan",
	["JP"] = "Japan",
	["KE"] = "Kenya",
	["KG"] = "Kyrgyzstan",
	["KH"] = "Cambodia",
	["KI"] = "Kiribati",
	["KM"] = "Comoros",
	["KN"] = "Saint Kitts and Nevis",
	["KP"] = "North Korea",
	["KR"] = "South Korea",
	["KW"] = "Kuwait",
	["KY"] = "CaymanIslands",
	["KZ"] = "Kazakhstan",
	["LA"] = "Laos",
	["LB"] = "Lebanon",
	["LC"] = "Saint Lucia",
	["LI"] = "Liechtenstein",
	["LK"] = "Sri Lanka",
	["LR"] = "Liberia",
	["LS"] = "Lesotho",
	["LT"] = "Lithuania",
	["LU"] = "Luxembourg",
	["LV"] = "Latvia",
	["LY"] = "Libya",
	["MA"] = "Morocco",
	["MC"] = "Monaco",
	["MD"] = "Republic of Moldova",
	["ME"] = "Montenegro",
	["MF"] = "Saint Martin",
	["MG"] = "Madagascar",
	["MH"] = "Marshall Islands",
	["MK"] = "North Macedonia",
	["ML"] = "Mali",
	["MM"] = "Myanmar",
	["MN"] = "Mongolia",
	["MO"] = "Macao",
	["MP"] = "Northern Mariana Islands",
	["MQ"] = "Martinique",
	["MR"] = "Mauritania",
	["MS"] = "Montserrat",
	["MT"] = "Malta",
	["MU"] = "Mauritius",
	["MV"] = "Maldives",
	["MW"] = "Malawi",
	["MX"] = "Mexico",
	["MY"] = "Malaysia",
	["MZ"] = "Mozambique",
	["NA"] = "Namibia",
	["NC"] = "New Caledonia",
	["NE"] = "Niger",
	["NF"] = "Norfolk Island",
	["NG"] = "Nigeria",
	["NI"] = "Nicaragua",
	["NL"] = "Netherlands",
	["NO"] = "Norway",
	["NP"] = "Nepal",
	["NR"] = "Nauru",
	["NU"] = "Niue",
	["NZ"] = "New Zealand",
	["OM"] = "Oman",
	["PA"] = "Panama",
	["PE"] = "Peru",
	["PF"] = "French Polynesia",
	["PG"] = "Papua New Guinea",
	["PH"] = "the Philippines",
	["PK"] = "Pakistan",
	["PL"] = "Poland",
	["PM"] = "Saint Pierre and Miquelon",
	["PN"] = "Pitcairn",
	["PR"] = "Puerto Rico",
	["PS"] = "Palestine",
	["PT"] = "Portugal",
	["PW"] = "Palau",
	["PY"] = "Paraguay",
	["QA"] = "Qatar",
	["RE"] = "Reunion",
	["RO"] = "Romania",
	["RS"] = "Serbia",
	["RU"] = "the Russian Federation",
	["RW"] = "Rwanda",
	["SA"] = "Saudi Arabia",
	["SB"] = "Solomon Islands",
	["SC"] = "Seychelles",
	["SD"] = "Sudan",
	["SE"] = "Sweden",
	["SG"] = "Singapore",
	["SH"] = "Saint Helena",
	["SI"] = "Slovenia",
	["SJ"] = "Svalbard and Jan Mayen",
	["SK"] = "Slovakia",
	["SL"] = "Sierra Leone",
	["SM"] = "San Marino",
	["SN"] = "Senegal",
	["SO"] = "Somalia",
	["SR"] = "Suriname",
	["SS"] = "South Sudan",
	["ST"] = "Sao Tome and Principe",
	["SV"] = "El Salvador",
	["SX"] = "Sint Maarten (Dutchpart)",
	["SY"] = "Syrian Arab Republic",
	["SZ"] = "Eswatini",
	["TC"] = "Turksand Caicos Islands",
	["TD"] = "Chad",
	["TF"] = "French Southern Territories",
	["TG"] = "Togo",
	["TH"] = "Thailand",
	["TJ"] = "Tajikistan",
	["TK"] = "Tokelau",
	["TL"] = "Timor-Leste",
	["TM"] = "Turkmenistan",
	["TN"] = "Tunisia",
	["TO"] = "Tonga",
	["TR"] = "Turkey",
	["TT"] = "Trinidad and Tobago",
	["TV"] = "Tuvalu",
	["TW"] = "the Sovereign State of Taiwan",
	["TZ"] = "United Republic of Tanzania",
	["UA"] = "Ukraine",
	["UG"] = "Uganda",
	["UM"] = "United States Minor Outlying Islands",
	["US"] = "the United States of America",
	["UY"] = "Uruguay",
	["UZ"] = "Uzbekistan",
	["VA"] = "Holy See",
	["VC"] = "Saint Vincent and the Grenadines",
	["VE"] = "Venezuela",
	["VG"] = "Virgin Islands (British)",
	["VI"] = "Virgin Islands (U.S.)",
	["VN"] = "Vietnam",
	["VU"] = "Vanuatu",
	["WF"] = "Wallis and Futuna",
	["WS"] = "Samoa",
	["YE"] = "Yemen",
	["YT"] = "Mayotte",
	["ZA"] = "South Africa",
	["ZM"] = "Zambia",
	["ZW"] = "Zimbabwe",
};

library = library or {}

hook.Remove("NeedsDepthPass", "NeedsDepthPass_Bokeh")
hook.Remove("RenderScreenspaceEffects", "RenderBokeh")
hook.Remove("RenderScreenspaceEffects", "RenderToyTown")
hook.Remove("RenderScreenspaceEffects", "RenderTexturize")
hook.Remove("RenderScreenspaceEffects", "RenderSunbeams")
hook.Remove("RenderScreenspaceEffects", "RenderSobel")
hook.Remove("RenderScene", "RenderStereoscopy")
hook.Remove("RenderScene", "RenderSuperDoF")
hook.Remove("PostDrawEffects", "RenderWidgets")
hook.Remove("PlayerTick", "TickWidgets")

do
	-- ID's should not have any of those characters.
	local blockedChars = {
		"'", "\"", "\\", "/", "^",
		":", ".", ";", "&", ",", "%"
	}

	function string.MakeID(str)
		str = str:utf8lower()
		str = str:gsub(" ", "_")

		for k, v in ipairs(blockedChars) do
			str = str:Replace(v, "")
		end

		return str
	end
	
	local lowercase = {[1] = "a", [2] = "b", [3] = "c", [4] = "d", [5] = "e", [6] = "f", [7] = "g", [8] = "h", [9] = "i", [10] = "j", [11] = "k", [12] = "l", [13] = "m", [14] = "n", [15] = "o", [16] = "p", [17] = "q", [18] = "r", [19] = "s", [20] = "t", [21] = "u", [22] = "v", [23] = "w", [24] = "x", [25] = "y", [26] = "z"};
	local lowercasetoKey = {["a"] = 1,  ["b"] = 2,  ["c"] = 3,  ["d"] = 4,  ["e"] = 5,  ["f"] = 6,  ["g"] = 7,  ["h"] = 8,  ["i"] = 9,  ["j"] = 10,  ["k"] = 11,  ["l"] = 12,  ["m"] = 13,  ["n"] = 14,  ["o"] = 15,  ["p"] = 16,  ["q"] = 17,  ["r"] = 18,  ["s"] = 19,  ["t"] = 20,  ["u"] = 21,  ["v"] = 22,  ["w"] = 23,  ["x"] = 24,  ["y"] = 25,  ["z"] = 26};

	function string.Randomize(str)
		local str = string.lower(str);
		local explode = string.Explode("",str)
		for k, v in pairs (explode) do
			if (!lowercasetoKey[v]) then
				continue;
			end;
			explode[k] = lowercase[math.Clamp(lowercasetoKey[explode[k]] + math.random(-3, 3), 1, 26)];
		end;
		return table.concat(explode, "");
	end;
end

function util.Validate(...)
	local args = {...}

	if (#args <= 0) then return false end

	for k, v in ipairs(args) do
		if (!IsValid(v)) then
			return false
		end
	end

	return true
end

-- A function to convert a single hexadecimal digit to decimal.
function util.HexToDec(hex)
	hex = hex:lower()

	local hexDigits = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"}
	local negative = false

	if (hex:StartWith("-")) then
		hex = hex:sub(2, 2)
		negative = true
	end

	for k, v in ipairs(hexDigits) do
		if (v == hex) then
			if (!negative) then
				return k - 1
			else
				return -(k - 1)
			end
		end
	end

	ErrorNoHalt("[Clockwork] '"..hex.."' is not a hexadecimal number!")
	return 0
end

function util.HexToDecimal(hex)
	local sum = 0
	local chars = table.Reverse(string.Explode("", hex))
	local idx = 1

	for i = 0, hex:len() - 1 do
		sum = sum + util.HexToDec(chars[idx]) * math.pow(16, i)
		idx = idx + 1
	end

	return sum
end

-- A function to convert hexadecimal color to a color structure.
function util.HexToColor(hex)
	if (hex:StartWith("#")) then
		hex = hex:sub(2, hex:len())
	end

	if (hex:len() != 6 and hex:len() != 8) then
		return Color(255, 255, 255)
	end

	local hexColors = {}
	local initLen = hex:len() / 2

	for i = 1, hex:len() / 2 do
		table.insert(hexColors, hex:sub(1, 2))

		if (i != initLen) then
			hex = hex:sub(3, hex:len())
		end
	end

	local color = {}

	for k, v in ipairs(hexColors) do
		local chars = table.Reverse(string.Explode("", v))
		local sum = 0

		for i = 1, 2 do
			sum = sum + util.HexToDec(chars[i]) * math.pow(16, i - 1)
		end

		table.insert(color, sum)
	end

	return Color(color[1], color[2], color[3], (color[4] or 255))
end

-- A helper function to get lowercase name of the data type.
function typeof(obj)
	return string.lower(type(obj))
end

colors = {
	aliceblue 		= Color(240, 248, 255),
	antiquewhite 	= Color(250, 235, 215),
	aqua 			= Color(0, 255, 255),
	aquamarine 		= Color(127, 255, 212),
	azure		 	= Color(240, 255, 255),
	beige 			= Color(245, 245, 220),
	bisque 			= Color(255, 228, 196),
	black 			= Color(0, 0, 0),
	blanchedalmond 	= Color(255, 235, 205),
	blue 			= Color(0, 0, 255),
	blueviolet 		= Color(138, 43, 226),
	brown 			= Color(165, 42, 42),
	burlywood	 	= Color(222, 184, 135),
	cadetblue 		= Color(95, 158, 160),
	chartreuse 		= Color(127, 255, 0),
	chocolate 		= Color(210, 105, 30),
	coral			= Color(255, 127, 80),
	cornflowerblue 	= Color(100, 149, 237),
	cornsilk 		= Color(255, 248, 220),
	crimson 		= Color(220, 20, 60),
	cyan 			= Color(0, 255, 255),
	darkblue 		= Color(0, 0, 139),
	darkcyan 		= Color(0, 139, 139),
	darkgoldenrod 	= Color(184, 134, 11),
	darkgray 		= Color(169, 169, 169),
	darkgreen 		= Color(0, 100, 0),
	darkgrey 		= Color(169, 169, 169),
	darkkhaki 		= Color(189, 183, 107),
	darkmagenta 	= Color(139, 0, 139),
	darkolivegreen 	= Color(85, 107, 47),
	darkorange 		= Color(255, 140, 0),
	darkorchid 		= Color(153, 50, 204),
	darkred 		= Color(139, 0, 0),
	darksalmon 		= Color(233, 150, 122),
	darkseagreen 	= Color(143, 188, 143),
	darkslateblue 	= Color(72, 61, 139),
	darkslategray 	= Color(47, 79, 79),
	darkslategrey 	= Color(47, 79, 79),
	darkturquoise 	= Color(0, 206, 209),
	darkviolet 		= Color(148, 0, 211),
	deeppink 		= Color(255, 20, 147),
	deepskyblue 	= Color(0, 191, 255),
	dimgray 		= Color(105, 105, 105),
	dimgrey 		= Color(105, 105, 105),
	dodgerblue 		= Color(30, 144, 255),
	firebrick 		= Color(178, 34, 34),
	floralwhite 	= Color(255, 250, 240),
	forestgreen 	= Color(34, 139, 34),
	fuchsia 		= Color(255, 0, 255),
	gainsboro 		= Color(220, 220, 220),
	ghostwhite 		= Color(248, 248, 255),
	gold 			= Color(255, 215, 0),
	goldenrod 		= Color(218, 165, 32),
	gray 			= Color(128, 128, 128),
	grey 			= Color(128, 128, 128),
	green 			= Color(0, 128, 0),
	greenyellow 	= Color(173, 255, 47),
	honeydew 		= Color(240, 255, 240),
	hotpink 		= Color(255, 105, 180),
	indianred 		= Color(205, 92, 92),
	indigo 			= Color(75, 0, 130),
	ivory 			= Color(255, 255, 240),
	khaki 			= Color(240, 230, 140),
	lavender 		= Color(230, 230, 250),
	lavenderblush 	= Color(255, 240, 245),
	lawngreen 		= Color(124, 252, 0),
	lemonchiffon 	= Color(255, 250, 205),
	lightblue 		= Color(173, 216, 230),
	lightcoral 		= Color(240, 128, 128),
	lightcyan 		= Color(224, 255, 255),
	lightgoldenrodyellow = Color(250, 250, 210),
	lightgray 		= Color(211, 211, 211),
	lightgreen 		= Color(144, 238, 144),
	lightgrey 		= Color(211, 211, 211),
	lightpink 		= Color(255, 182, 193),
	lightsalmon 	= Color(255, 160, 122),
	lightseagreen 	= Color(32, 178, 170),
	lightskyblue 	= Color(135, 206, 250),
	lightslategray 	= Color(119, 136, 153),
	lightslategrey 	= Color(119, 136, 153),
	lightslateblue 	= Color(119, 136, 153),
	lightsteelblue 	= Color(176, 196, 222),
	lightyellow 	= Color(255, 255, 224),
	lime 			= Color(0, 255, 0),
	limegreen 		= Color(50, 205, 50),
	linen 			= Color(250, 240, 230),
	magenta 		= Color(255, 0, 255),
	maroon 			= Color(128, 0, 0),
	mediumaquamarine = Color(102, 205, 170),
	mediumblue 		= Color(0, 0, 205),
	mediumorchid 	= Color(186, 85, 211),
	mediumpurple 	= Color(147, 112, 219),
	mediumseagreen 	= Color(60, 179, 113),
	mediumslateblue = Color(123, 104, 238),
	mediumspringgreen = Color(0, 250, 154),
	mediumturquoise = Color(72, 209, 204),
	mediumvioletred = Color(199, 21, 133),
	midnightblue 	= Color(25, 25, 112),
	mintcream 		= Color(245, 255, 250),
	mistyrose 		= Color(255, 228, 225),
	moccasin 		= Color(255, 228, 181),
	navajowhite 	= Color(255, 222, 173),
	navy		 	= Color(0, 0, 128),
	oldlace 		= Color(253, 245, 230),
	olive 			= Color(128, 128, 0),
	olivedrab 		= Color(107, 142, 35),
	orange 			= Color(255, 165, 0),
	orangered 		= Color(255, 69, 0),
	orchid 			= Color(218, 112, 214),
	palegoldenrod 	= Color(238, 232, 170),
	palegreen 		= Color(152, 251, 152),
	paleturquoise 	= Color(175, 238, 238),
	palevioletred 	= Color(219, 112, 147),
	papayawhip 		= Color(255, 239, 213),
	peachpuff 		= Color(255, 218, 185),
	peru 			= Color(205, 133, 63),
	pink 			= Color(255, 192, 203),
	plum 			= Color(221, 160, 221),
	powderblue 		= Color(176, 224, 230),
	purple 			= Color(128, 0, 128),
	red 			= Color(255, 0, 0),
	rosybrown 		= Color(188, 143, 143),
	royalblue 		= Color(65, 105, 225),
	saddlebrown 	= Color(139, 69, 19),
	salmon 			= Color(250, 128, 114),
	sandybrown 		= Color(244, 164, 96),
	seagreen 		= Color(46, 139, 87),
	seashell 		= Color(255, 245, 238),
	sienna 			= Color(160, 82, 45),
	silver 			= Color(192, 192, 192),
	skyblue 		= Color(135, 206, 235),
	slateblue 		= Color(106, 90, 205),
	slategray 		= Color(112, 128, 144),
	slategrey 		= Color(112, 128, 144),
	snow 			= Color(255, 250, 250),
	springgreen 	= Color(0, 255, 127),
	steelblue 		= Color(70, 130, 180),
	tan 			= Color(210, 180, 140),
	teal 			= Color(0, 128, 128),
	thistle			= Color(216, 191, 216),
	tomato 			= Color(255, 99, 71),
	turquoise 		= Color(64, 224, 208),
	violet 			= Color(238, 130, 238),
	wheat 			= Color(245, 222, 179),
	white 			= Color(255, 255, 255),
	whitesmoke 		= Color(245, 245, 245),
	yellow 			= Color(255, 255, 0),
	yellowgreen 	= Color(154, 205, 50)
}

-- A function to determine whether vector from A to B intersects with a
-- vector from C to D.
function util.VectorsIntersect(vFrom, vTo, vFrom2, vTo2)
	local d1, d2, a1, a2, b1, b2, c1, c2

	a1 = vTo.y - vFrom.y
	b1 = vFrom.x - vTo.x
	c1 = (vTo.x * vFrom.y) - (vFrom.x * vTo.y)

	d1 = (a1 * vFrom2.x) + (b1 * vFrom2.y) + c1
	d2 = (a1 * vTo2.x) + (b1 * vTo2.y) + c1

	if (d1 > 0 and d2 > 0) then return false end
	if (d1 < 0 and d2 < 0) then return false end

	a2 = vTo2.y - vFrom2.y
	b2 = vFrom2.x - vTo2.x
	c2 = (vTo2.x * vFrom2.y) - (vFrom2.x * vTo2.y)

	d1 = (a2 * vFrom.x) + (b2 * vFrom.y) + c2
	d2 = (a2 * vTo.x) + (b2 * vTo.y) + c2

	if (d1 > 0 and d2 > 0) then return false end
	if (d1 < 0 and d2 < 0) then return false end

	return true
end

-- A function to determine whether a 2D point is inside of a 2D polygon.
function util.VectorIsInPoly(point, polyVertices)
	if (!isvector(point) or !istable(polyVertices) or !isvector(polyVertices[1])) then
		return
	end

	local intersections = 0

	for k, v in ipairs(polyVertices) do
		local nextVert

		if (k < #polyVertices) then
			nextVert = polyVertices[k + 1]
		elseif (k == #polyVertices) then
			nextVert = polyVertices[1]
		end

		if (nextVert and util.VectorsIntersect(point, Vector(99999, 99999, 0), v, nextVert)) then
			intersections = intersections + 1
		end
	end

	if (intersections % 2 == 0) then
		return false
	else
		return true
	end
end

do
	local colorMeta = FindMetaTable("Color")

	function colorMeta:Darken(amt)
		return Color(
			math.Clamp(self.r - amt, 0, 255),
			math.Clamp(self.g - amt, 0, 255),
			math.Clamp(self.b - amt, 0, 255),
			self.a
		)
	end

	function colorMeta:Lighten(amt)
		return Color(
			math.Clamp(self.r + amt, 0, 255),
			math.Clamp(self.g + amt, 0, 255),
			math.Clamp(self.b + amt, 0, 255),
			self.a
		)
	end
end;

-- A function to do C-style formatted prints.
function printf(str, ...)
	print(Format(str, ...))
end

-- Let's face it. When you develop for C++ you kinda want to do this in Lua.
function cout(...)
	print(...)
end

-- A function to select a random player.
function player.Random()
	local allPly = player.GetAll()

	if (#allPly > 0) then
		return allPly[math.random(1, #allPly)]
	end
end

function string.FindAll(str, pattern)
	if (!str or !pattern) then return end

	local hits = {}
	local lastPos = 1

	while (true) do
		local startPos, endPos = string.find(str, pattern, lastPos)

		if (!startPos) then
			break
		end

		table.insert(hits, {str:sub(startPos, endPos), startPos, endPos})

		lastPos = endPos + 1
	end

	return hits
end

-- A function to throw an awesome colored print.
function Clockwork.kernel:Print(message, color)
	color = color or Color(255, 255, 255)

	if (type(message) == "table") then
		message = table.concat(message, " ")
	end

	if (type(message) != "string") then
		return
	elseif (!message or message == "" or message == " ") then
		return
	end
	
	local clockworkColor = Color(0, 0, 255);

	MsgC(clockworkColor, "[Clockwork] ")
	MsgC(color, message.."\n")
end

local debugColor = Color(192, 192, 192);

-- A function to print red 'error' print.
function Clockwork.kernel:Error(message)
	if (Clockwork.LogLevel >= 1) then
		self:Print(message, Color(255, 0, 0))
	end
end

-- A function to print yellow 'warning' print.
function Clockwork.kernel:Warning(message)
	if (Clockwork.LogLevel >= 2) then
		self:Print(message, Color(255, 255, 0))
	end
end

-- A function to print green 'good' print.
function Clockwork.kernel:Good(message)
	if (Clockwork.LogLevel >= 3) then
		self:Print(message, Color(0, 255, 0))
	end
end

-- A function to print pink developer print.
function Clockwork.kernel:Debug(message)
	if (Clockwork.LogLevel >= 4) then
		self:Print(message, debugColor)
	end
end

function Clockwork.kernel:Spam(message)
	if (Clockwork.LogLevel >= 5) then
		self:Print(message, debugColor)
	end
end

--[[
	@codebase Shared
	@details A function to get whether two tables are equal.
	@param Table The first unique table to compare.
	@param Table The second unique table to compare.
	@returns Bool Whether or not the tables are equal.
--]]
function Clockwork.kernel:AreTablesEqual(tableA, tableB)
	if (istable(tableA) and istable(tableB)) then
		if (#tableA != #tableB) then
			return false
		end

		for k, v in pairs(tableA) do
			if (istable(v) and !self:AreTablesEqual(v, tableB[k])) then
				return false
			end

			if (v != tableB[k]) then
				return false
			end
		end

		return true
	end

	return false
end

--[[
	@codebase Shared
	@details A function to get whether a weapon is a default weapon.
	@param Entity The weapon entity.
	@returns Bool Whether or not the weapon is a default weapon.
--]]
function Clockwork.kernel:IsDefaultWeapon(weapon)
	if (IsValid(weapon)) then
		local class = string.lower(weapon:GetClass())
		
		if (class == "cw_adminasstool" or class == "cw_senses" or class == "cw_keys" or class == "weapon_physgun" or class == "gmod_physcannon" or class == "gmod_tool") then
			return true
		end
	end

	return false
end

-- A function to format cash.
function Clockwork.kernel:FormatCash(amount, singular, lowerName)
	local formatSingular = Clockwork.option:GetKey("format_singular_cash")
	local formatCash = Clockwork.option:GetKey("format_cash")
	local cashName = Clockwork.option:GetKey("name_cash")

	if (CLIENT) then
		if (lowerName) then
			cashName = cashName:utf8lower()
		end
	end

	local realAmount = tostring(math.Round(amount))

	if (singular) then
		return self:Replace(self:Replace(formatSingular, "%n", cashName), "%a", realAmount)
	else
		return self:Replace(self:Replace(formatCash, "%n", cashName), "%a", realAmount)
	end
end

function table.SafeMerge(to, from)
	local oldIndex, oldIndex2 = to.__index, from.__index

	to.__index = nil
	from.__index = nil

	table.Merge(to, from)

	to.__index = oldIndex
	from.__index = oldIndex2
end

-- A function to create a new library.
function library.New(strName, tParent)
	tParent = tParent or _G

	tParent[strName] = tParent[strName] or {}

	return tParent[strName]
end

-- A function to get an existing library.
function library.Get(strName, tParent)
	tParent = tParent or _G

	return tParent[strName] or library.New(strName, tParent)
end

-- Set library table's Metatable so that we can call it like a function.
setmetatable(library, {__call = function(tab, strName, tParent) return tab.Get(strName, tParent) end})

-- A function to create a new class. Supports constructors and inheritance.
function library.NewClass(strName, tParent, CExtends)
	local class = {
		-- Same as "new ClassName" in C++
		__call = function(obj, ...)
			local newObj = {}

			-- Set new object's meta table and copy the data from original class to new object.
			setmetatable(newObj, obj)
			table.SafeMerge(newObj, obj)

			-- If there is a base class, call their constructor.
			if (obj.BaseClass) then
				pcall(obj.BaseClass, newObj, ...)
			end

			-- If there is a constructor - call it.
			if (obj[strName]) then
				local success, value = pcall(obj[strName], newObj, ...)

				if (!success) then
					ErrorNoHalt("["..strName.."] Class constructor has failed to run!\n")
					ErrorNoHalt(value.."\n")
				end
			end

			-- Return our newly generated object.
			return newObj
		end
	}

	-- If this class is based off some other class - copy it's parent's data.
	if (istable(CExtends)) then
		table.SafeMerge(class, CExtends)
	end

	-- Create the actual class table.
	local obj = library.New(strName, (tParent or _G))
	obj.ClassName = strName
	obj.BaseClass = CExtends or false

	return setmetatable((tParent or _G)[strName], class)
end

function Class(strName, CExtends, tParent)
	return library.NewClass(strName, tParent, CExtends)
end

-- Alias because class could get easily confused with player class.
Meta = Class

-- Also make an alias that looks like other programming languages.
class = Class

-- A function to convert a string to a color.
function Clockwork.kernel:StringToColor(text)
	local explodedData = string.Explode(",", text)
	local color = Color(255, 255, 255, 255)

	if (explodedData[1]) then
		color.r = tonumber(explodedData[1]:Trim()) or 255
	end

	if (explodedData[2]) then
		color.g = tonumber(explodedData[2]:Trim()) or 255
	end

	if (explodedData[3]) then
		color.b = tonumber(explodedData[3]:Trim()) or 255
	end

	if (explodedData[4]) then
		color.a = tonumber(explodedData[4]:Trim()) or 255
	end

	return color
end

-- A function to get a log type color.
function Clockwork.kernel:GetLogTypeColor(logType)
	local logTypes = {
		Color(255, 50, 50, 255),
		Color(255, 150, 0, 255),
		Color(255, 200, 0, 255),
		Color(0, 150, 255, 255),
		Color(0, 255, 125, 255)
	}

	return logTypes[logType] or logTypes[5]
end

--[[
	@codebase Shared
	@details A function to get the kernel version.
	@returns String The kernel version.
--]]
function Clockwork.kernel:GetVersion()
	return Clockwork.KernelVersion
end

--[[
	@codebase Shared
	@details A function to get the kernel version and build.
	@returns String The kernel version and build concatenated.
--]]
function Clockwork.kernel:GetVersionBuild()
	return Clockwork.KernelVersion
end

--[[
	@codebase Shared
	@details A function to get the schema folder.
	@returns String The schema folder.
--]]
function Clockwork.kernel:GetSchemaFolder(sFolderName)
	if (sFolderName) then
		return Clockwork.Schema.."/schema/"..sFolderNane
	else
		return Clockwork.Schema
	end
end

--[[
	@codebase Shared
	@details A function to get the schema gamemode path.
	@returns String The schema gamemode path.
--]]
function Clockwork.kernel:GetSchemaGamemodePath()
	return Clockwork.Schema
end

--[[
	@codebase Shared
	@details A function to get the Clockwork folder.
	@returns String The Clockwork folder.
--]]
function Clockwork.kernel:GetClockworkFolder()
	return (string.gsub(Clockwork.ClockworkFolder, "gamemodes/", ""));
end;

--[[
	@codebase Shared
	@details A function to get the Clockwork path.
	@returns String The Clockwork path.
--]]
function Clockwork.kernel:GetClockworkPath()
	return (string.gsub(Clockwork.ClockworkFolder, "gamemodes/", "").."/framework");
end;

-- A function to get the path to GMod.
function Clockwork.kernel:GetPathToGMod()
	return util.RelativePathToFull("."):sub(1, -2)
end

-- A function to convert a string to a boolean.
function Clockwork.kernel:ToBool(text)
	if (text == "true" or text == "yes" or text == "1") then
		return true
	else
		return false
	end
end

-- A function to remove text from the end of a string.
function Clockwork.kernel:RemoveTextFromEnd(text, toRemove)
	local toRemoveLen = string.utf8len(toRemove)
	if (string.utf8sub(text, -toRemoveLen) == toRemove) then
		return (string.utf8sub(text, 0, -(toRemoveLen + 1)))
	else
		return text
	end
end

-- A function to split a string.
function Clockwork.kernel:SplitString(text, interval)
	local length = string.utf8len(text)
	local baseTable = {}
	local i = 0

	while (i * interval < length) do
		baseTable[i + 1] = string.utf8sub(text, i * interval + 1, (i + 1) * interval)
		i = i + 1
	end

	return baseTable
end

-- A function to get whether a letter is a vowel.
function Clockwork.kernel:IsVowel(letter)
	letter = string.lower(letter)
	return (letter == "a" or letter == "e" or letter == "i" or letter == "o" or letter == "u")
end

-- A function to pluralize some text.
function Clockwork.kernel:Pluralize(text)
	return text
end

-- A function to serialize a table.
function Clockwork.kernel:Serialize(tTable, bForceJSON)
	if (istable(tTable)) then
		local bSuccess, value

		if (!bForceJSON) then
			bSuccess, value = pcall(pon.encode, tTable)
		end

		if (!bSuccess or bForceJSON) then
			bSuccess, value = pcall(util.TableToJSON, tTable)

			if (!bSuccess) then
				ErrorNoHalt("[Clockwork] Failed to serialize a table!\n")
				ErrorNoHalt(value.."\n")
				debug.Trace()

				return ""
			end
		end

		return value
	else
		print("[Clockwork] You must serialize a table, not "..type(tTable).."!")

		return ""
	end
end

-- A function to deserialize a string.
function Clockwork.kernel:Deserialize(strData, bForceJSON)
	if (isstring(strData)) then
		local bSuccess, value

		if (!bForceJSON) then
			bSuccess, value = pcall(pon.decode, strData)
		end

		if (!bSuccess or bForceJSON) then
			bSuccess, value = pcall(util.JSONToTable, strData)

			if (!bSuccess) then
				ErrorNoHalt("[Clockwork] Failed to deserialize a string!\n")
				ErrorNoHalt(tostring(value).."\n")
				debug.Trace()

				return {}
			end
		end

		return value
	else
		print("[Clockwork] You must deserialize a string, not "..type(strData).."!")

		return {}
	end
end

-- A function to get ammo information from a weapon.
function Clockwork.kernel:GetAmmoInformation(weapon)
	if (IsValid(weapon) and IsValid(weapon.Owner) and weapon.Primary and weapon.Secondary) then
		if (!weapon.AmmoInfo) then
			weapon.AmmoInfo = {
				primary = {
					ammoType = weapon:GetPrimaryAmmoType(),
					clipSize = weapon.Primary.ClipSize
				},
				secondary = {
					ammoType = weapon:GetSecondaryAmmoType(),
					clipSize = weapon.Secondary.ClipSize
				}
			}
		end

		weapon.AmmoInfo.primary.ownerAmmo = weapon.Owner:GetAmmoCount(weapon.AmmoInfo.primary.ammoType)
		weapon.AmmoInfo.primary.clipBullets = weapon:Clip1()
		weapon.AmmoInfo.primary.doesNotShoot = (weapon.AmmoInfo.primary.clipBullets == -1)
		weapon.AmmoInfo.secondary.ownerAmmo = weapon.Owner:GetAmmoCount(weapon.AmmoInfo.secondary.ammoType)
		weapon.AmmoInfo.secondary.clipBullets = weapon:Clip2()
		weapon.AmmoInfo.secondary.doesNotShoot = (weapon.AmmoInfo.secondary.clipBullets == -1)

		if (!weapon.AmmoInfo.primary.doesNotShoot and weapon.AmmoInfo.primary.ownerAmmo > 0) then
			weapon.AmmoInfo.primary.ownerClips = math.ceil(weapon.AmmoInfo.primary.clipSize / weapon.AmmoInfo.primary.ownerAmmo)
		else
			weapon.AmmoInfo.primary.ownerClips = 0
		end

		if (!weapon.AmmoInfo.secondary.doesNotShoot and weapon.AmmoInfo.secondary.ownerAmmo > 0) then
			weapon.AmmoInfo.secondary.ownerClips = math.ceil(weapon.AmmoInfo.secondary.clipSize / weapon.AmmoInfo.secondary.ownerAmmo)
		else
			weapon.AmmoInfo.secondary.ownerClips = 0
		end

		return weapon.AmmoInfo
	end
end

function util.WaitForEntity(entIndex, callback, delay, waitTime)
	local entity = Entity(entIndex)

	if (!IsValid(entity)) then
		local timerName = CurTime().."_EntWait"

		timer.Create(timerName, delay or 0, waitTime or 100, function()
			local entity = Entity(entIndex)

			if (IsValid(entity)) then
				callback(entity)

				timer.Remove(timerName)
			end
		end)
	else
		callback(entity)
	end
end

-- Awful code because I'm out of time and CW is obsolete.
if (CLIENT) then
	netstream.Hook("PlayerModelChanged", function(nPlyIndex, sNewModel, sOldModel)
		util.WaitForEntity(nPlyIndex, function(player)
			hook.Run("PlayerModelChanged", player, sNewModel, sOldModel)
		end)
	end)
end

function Clockwork.kernel:LoadSchema()
	Clockwork.kernel.schemaStartTime = Clockwork.startTime or os.clock()
	local startTime = Clockwork.kernel.schemaStartTime

	self:Debug("Schema loading benchmark: Schema loading started...")

	Schema = Schema or plugin.New()

	local directory = Clockwork.Schema.."/schema"

	if (SERVER) then
		local schemaInfo = self:GetSchemaGamemodeInfo()
			table.Merge(Schema, schemaInfo)
		CW_SCRIPT_SHARED.schemaData = schemaInfo
	elseif (CW_SCRIPT_SHARED.schemaData) then
		table.Merge(Schema, CW_SCRIPT_SHARED.schemaData)
	else
		MsgC(Color(255, 100, 0, 255), "\n[Clockwork] The schema has no "..schemaFolder..".ini!\n")
	end

	self:Debug("Generated schema info table at "..math.Round(os.clock() - startTime, 3)..".")

	self:Debug(directory.."/sh_schema.lua")

	if (_file.Exists(directory.."/sh_schema.lua", "LUA")) then
		AddCSLuaFile(directory.."/sh_schema.lua")
		include(directory.."/sh_schema.lua")
	else
		MsgC(Color(255, 100, 0, 255), "\n[Clockwork] The schema has no sh_schema.lua.\n")
	end

	self:Debug("Loaded sh_schema and rest of the files at "..math.Round(os.clock() - startTime, 3)..".")
	
	plugin.IncludeExtras(directory)

	self:Debug("Included extras at "..math.Round(os.clock() - startTime, 3)..".")

	plugin.CacheFunctions(Schema)

	self:Debug("Cached schema hooks at "..math.Round(os.clock() - startTime, 3)..".")

	Clockwork.kernel.schemaStartTime = nil
	directory = self:RemoveTextFromEnd(directory, "/schema")
	plugin.IncludePlugins(directory)
	
	util.IncludeAllSubfolders(directory.."/schema/commands/");

	self:Debug("Finished loading at "..math.Round(os.clock() - startTime, 3)..".")
end

-- A function to explode a string by tags.
function Clockwork.kernel:ExplodeByTags(text, seperator, open, close, hide)
	local results = {}
	local current = ""
	local tag = nil

	for i = 1, #text do
		local character = string.utf8sub(text, i, i)

		if (!tag) then
			if (character == open) then
				if (!hide) then
					current = current..character
				end

				tag = true
			elseif (character == seperator) then
				results[#results + 1] = current; current = ""
			else
				current = current..character
			end
		else
			if (character == close) then
				if (!hide) then
					current = current..character
				end

				tag = nil
			else
				current = current..character
			end
		end
	end

	if (current != "") then
		results[#results + 1] = current
	end

	return results
end

-- A function to modify a physical description.
function Clockwork.kernel:ModifyPhysDesc(description)
	if (string.utf8len(description) <= 1024) then
		if (!string.find(string.utf8sub(description, -2), "%p")) then
			return description.."."
		else
			return description
		end
	else
		return string.utf8sub(description, 1, 1021).."..."
	end
end

do
	local MAGIC_CHARACTERS = "([%(%)%.%%%+%-%*%?%[%^%$])"

	-- A function to replace something in text without pattern matching.
	function Clockwork.kernel:Replace(text, find, replace)
		if (isstring(text)) then
			return string.gsub(text, string.gsub(find, MAGIC_CHARACTERS, "%%%1"), replace);
		end;
	end
end

-- A function to create a new meta table.
function Clockwork.kernel:NewMetaTable(baseTable)
	local object = {}
		setmetatable(object, baseTable)
		baseTable.__index = baseTable
	return object
end

-- A function to make a proxy meta table.
function Clockwork.kernel:MakeProxyTable(baseTable, baseClass, proxy)
	baseTable[proxy] = {}

	baseTable.__index = function(object, key)
		local value = rawget(object, key)

		if (type(value) == "function") then
			return value
		elseif (object.__proxy) then
			return object:__proxy(key)
		else
			return object[proxy][key]
		end
	end

	baseTable.__newindex = function(object, key, value)
		if (type(value) != "function") then
			object[proxy][key] = value
			return
		end

		rawset(object, key, value)
	end

	for k, v in pairs(baseTable) do
		if (type(v) != "function" and k != proxy) then
			baseTable[proxy][k] = v
			baseTable[k] = nil
		end
	end

	setmetatable(baseTable, baseClass)
end

-- A function to set whether a string should be in camel case.
function Clockwork.kernel:SetCamelCase(text, bCamelCase)
	if (bCamelCase) then
		return string.gsub(text, "^.", string.lower)
	else
		return string.gsub(text, "^.", string.upper)
	end
end

-- A function to add files to the content download.
function Clockwork.kernel:AddDirectory(directory, bRecursive)
	if (string.utf8sub(directory, -1) == "/") then
		directory = directory.."*.*"
	end

	local files, folders = _file.Find(directory, "GAME", "namedesc")
	local rawDirectory = string.match(directory, "(.*)/").."/"

	for k, v in ipairs(files) do
		self:AddFile(rawDirectory..v)
	end

	if (bRecursive) then
		for k, v in ipairs(folders) do
			if (v != ".." and v != ".") then
				self:AddDirectory(rawDirectory..v, true)
			end
		end
	end
end

-- A function to add a file to the content download.
function Clockwork.kernel:AddFile(fileName)
	resource.AddFile(fileName)
end

-- A function to add all files from all subfolders.
function util.IncludeAllSubfolders(directory)
	local files, directories = _file.Find(directory.."*", "LUA", "namedesc")

	for i = 1, #directories do
		local subFiles, subDirectories = _file.Find(directory..directories[i].."/*", "LUA", "namedesc");
		for k, v in pairs (subFiles) do
			util.Include(directory..directories[i].."/"..v);
		end;
	end;
end;

-- A function to include a file based on it's prefix.
function util.Include(strFile)
	if (SERVER) then
		if (string.find(strFile, "cl_")) then
			AddCSLuaFile(strFile)
		elseif (string.find(strFile, "sv_") or string.find(strFile, "init.lua")) then
			return include(strFile)
		else
			AddCSLuaFile(strFile)

			return include(strFile)
		end
	else
		if (!string.find(strFile, "sv_") and strFile != "init.lua" and !strFile:EndsWith("/init.lua")) then
			return include(strFile)
		end
	end
end

-- A function to add a file to clientside downloads list based on it's prefix.
function util.AddCSLuaFile(strFile)
	if (SERVER) then
		if (string.find(strFile, "sh_") or string.find(strFile, "cl_") or string.find(strFile, "shared.lua")) then
			AddCSLuaFile(strFile)
		end
	end
end

-- A function to include all files in a directory.
function util.IncludeDirectory(strDirectory, strBase, bIsRecursive)
	if (strBase) then
		if (isbool(strBase)) then
			strBase = "clockwork/framework/"
		elseif (!strBase:EndsWith("/")) then
			strBase = strBase.."/"
		end

		strDirectory = strBase..strDirectory
	end

	if (!strDirectory:EndsWith("/")) then
		strDirectory = strDirectory.."/"
	end

	if (bIsRecursive) then
		local files, folders = _file.Find(strDirectory.."*", "LUA", "namedesc")

		-- First include the files.
		for k, v in ipairs(files) do
			if (v:GetExtensionFromFilename() == "lua") then
				util.Include(strDirectory..v)
			end
		end

		-- Then include all directories.
		for k, v in ipairs(folders) do
			util.IncludeDirectory(strDirectory..v, bIsRecursive)
		end
	else
		local files, _ = _file.Find(strDirectory.."*.lua", "LUA", "namedesc")

		for k, v in ipairs(files) do
			util.Include(strDirectory..v)
		end
	end
end

-- A function to include files in a directory.
function Clockwork.kernel:IncludeDirectory(directory, bFromBase)
	return util.IncludeDirectory(directory, bFromBase)
end

-- A function to include a prefixed _file.
function Clockwork.kernel:IncludePrefixed(fileName)
	return util.Include(fileName)
end

-- A function to include plugins in a directory.
function Clockwork.kernel:IncludePlugins(directory, bFromBase)
	if (bFromBase) then
		directory = "clockwork/"..directory
	end

	if (string.sub(directory, -1) != "/") then
		directory = directory.."/"
	end

	local files, pluginFolders = _file.Find(directory.."*", "LUA", "namedesc")

	for k, v in ipairs(files) do
		if (v:EndsWith(".lua")) then
			plugin.Include(directory..v)
		end
	end

	for k, v in ipairs(pluginFolders) do
		if (v != ".." and v != ".") then
			plugin.Include(directory..v.."/plugin")
		end
	end

	return true
end

-- A function to run a function on the next frame.
function Clockwork.kernel:OnNextFrame(name, Callback)
	return timer.Create(name, FrameTime(), 1, Callback)
end

-- A function to get whether a player has access to an object.
function Clockwork.kernel:HasObjectAccess(player, object)
	local hasAccess = false

	if (object.access) then
		if (Clockwork.player:HasAnyFlags(player, object.access)) then
			hasAccess = true
		end
	end

	if (object.factions) then
		local faction = player:GetFaction()

		if (table.HasValue(object.factions, faction)) then
			hasAccess = true
		end
	end

	if (object.classes) then
		local team = player:Team()
		local class = Clockwork.class:FindByID(team)

		if (class) then
			if (table.HasValue(object.classes, team) or table.HasValue(object.classes, class.name)) then
				hasAccess = true
			end
		end
	end

	if (!object.access and !object.factions
	and !object.classes) then
		hasAccess = true
	end

	if (object.blacklist) then
		local team = player:Team()
		local class = Clockwork.class:FindByID(team)
		local faction = player:GetFaction()

		if (table.HasValue(object.blacklist, faction)) then
			hasAccess = false
		elseif (class) then
			if (table.HasValue(object.blacklist, team) or table.HasValue(object.blacklist, class.name)) then
				hasAccess = false
			end
		else
			for k, v in pairs(object.blacklist) do
				if (type(v) == "string") then
					if (Clockwork.player:HasAnyFlags(player, v)) then
						hasAccess = false

						break
					end
				end
			end
		end
	end

	if (object.HasObjectAccess) then
		return object:HasObjectAccess(player, hasAccess)
	end

	return hasAccess
end

-- A function to get the sorted commands.
function Clockwork.kernel:GetSortedCommands()
	local commands = {}
	local source = Clockwork.command:GetAll()

	for k, v in pairs(source) do
		commands[#commands + 1] = k
	end

	table.sort(commands, function(a, b)
		return a < b
	end)

	return commands
end

-- A function to zero a number to an amount of digits.
function Clockwork.kernel:ZeroNumberToDigits(number, digits)
	return string.rep("0", math.Clamp(digits - string.utf8len(tostring(number)), 0, digits))..tostring(number)
end

-- A function to get a short CRC from a value.
-- Converts the 32-bit value into a 15-bit value because Player:SetTeam() is now networked at 15 bits since the 2024.10.29 update
function Clockwork.kernel:GetShortCRC(value)
	return math.ceil(util.CRC(value) / 131071)
end

-- A function to validate a table's keys.
function Clockwork.kernel:ValidateTableKeys(baseTable)
	for i = 1, #baseTable do
		if (!baseTable[i]) then
			table.remove(baseTable, i)
		end
	end
end

-- A function to get the map's physics entities.
function Clockwork.kernel:GetPhysicsEntities()
	local entities = {}

	for k, v in ipairs(ents.FindByClass("prop_physics_multiplayer")) do
		if (IsValid(v)) then
			table.insert(entities, v)
		end
	end

	for k, v in ipairs(ents.FindByClass("prop_physics")) do
		if (IsValid(v)) then
			table.insert(entities, v)
		end
	end

	return entities
end

-- A function to create a multicall table (by Deco Da Man).
function Clockwork.kernel:CreateMulticallTable(baseTable, object)
	local metaTable = getmetatable(baseTable) or {}
		function metaTable.__index(baseTable, key)
			return function(baseTable, ...)
				for k, v in pairs(baseTable) do
					object[key](v, ...)
				end
			end
		end
	setmetatable(baseTable, metaTable)

	return baseTable
end

-- A function to create fake damage info.
function Clockwork.kernel:FakeDamageInfo(damage, inflictor, attacker, position, damageType, damageForce)
	local damageInfo = DamageInfo()
	local realDamage = math.ceil(math.max(damage, 0))

	damageInfo:SetDamagePosition(position)
	damageInfo:SetDamageForce(Vector() * damageForce)
	damageInfo:SetDamageType(damageType)
	damageInfo:SetInflictor(inflictor)
	damageInfo:SetAttacker(attacker)
	damageInfo:SetDamage(realDamage)

	return damageInfo
end

-- A function to unpack a color.
function Clockwork.kernel:UnpackColor(color)
	return color.r, color.g, color.b, color.a
end

-- A function to parse data in text.
function Clockwork.kernel:ParseData(text)
	local classes = {"%^", "%!"}

	for k, v in ipairs(classes) do
		for key in string.gmatch(text, v.."(.-)"..v) do
			local lower = false
			local amount

			if (string.utf8sub(key, 1, 1) == "(" and string.utf8sub(key, -1) == ")") then
				lower = true
				amount = tonumber(string.utf8sub(key, 2, -2))
			else
				amount = tonumber(key)
			end

			if (amount) then
				text = string.gsub(text, v..string.gsub(key, "([%(%)])", "%%%1")..v, tostring(self:FormatCash(amount, k == 2, lower)))
			end
		end
	end

	for k in string.gmatch(text, "%*(.-)%*") do
		k = string.gsub(k, "[%(%)]", "")

		if (k != "") then
			text = string.gsub(text, "%*%("..k.."%)%*", tostring(Clockwork.option:GetKey(k, true)))
			text = string.gsub(text, "%*"..k.."%*", tostring(Clockwork.option:GetKey(k)))
		end
	end

	if (CLIENT) then
		for k in string.gmatch(text, ":(.-):") do
			if (k != "" and input.LookupBinding(k)) then
				text = self:Replace(text, ":"..k..":", "<"..string.upper(tostring(input.LookupBinding(k)))..">")
			end
		end
	end

	return config.Parse(text)
end

function Clockwork.kernel:SetNetVar(key, val, sendTo)
	return netvars.SetNetVar(key, val, sendTo)
end

function Clockwork.kernel:GetNetVar(key, default)
	return netvars.GetNetVar(key, default)
end

function table.Match(tabOne, tabTwo, ignoreMetaTable)
	local typeOne = type(tabOne);
	local typeTwo = type(tabTwo);
	
	if (typeOne != typeTwo) then
		return false;
	end;
	
	if (typeOne != "table" and typeTwo != "table") then
		return tabOne == tabTwo;
	end;
	
	local metaTable = getmetatable(tabOne);
	
	if (!ignoreMetaTable and metaTable and metaTable.__eq) then
		return tabOne == tabTwo;
	end;
	
	for k, v in pairs(tabOne) do
		local v2 = tabTwo[k];
		
		if (v2 == nil or !table.Match(v, v2)) then
			return false;
		end;
	end;
	
	for k, v in pairs(tabTwo) do
		local v2 = tabOne[k];
		
		if (v2 == nil or !table.Match(v2, v)) then
			return false;
		end;
	end;
	
	return true;
end;

timer.Create("Clockwork.HalfSecondTimer", 0.5, 0, function()
	hook.Run("HalfSecond")
end)

timer.Create("Clockwork.OneSecondTimer", 1, 0, function()
	hook.Run("OneSecond")
end)

timer.Create("Clockwork.OneMinuteTimer", 60, 0, function()
	hook.Run("OneMinute")
end)

timer.Create("LazyTick", 0.125, 0, function()
	hook.Run("LazyTick")
end)

-- Properties
properties.Add("copy_name_to_clipboard", {
	MenuLabel = "Copy name to clipboard",
	Order = 1,
	MenuIcon = "icon16/disk.png",
	Filter = function(self, ent, ply)
		if !IsValid(ent) or !IsValid(ply) or !ply:IsAdmin() then return false end
		if !ent:IsPlayer() then
			if Clockwork.entity:IsPlayerRagdoll(ent) then
				ent = Clockwork.entity:GetPlayer(ent);
			else
				return false;
			end
		end

		return true;
	end,
	Action = function(self, ent)
		if IsValid(ent) then
			if !ent:IsPlayer() then
				if Clockwork.entity:IsPlayerRagdoll(ent) then
					ent = Clockwork.entity:GetPlayer(ent);
				else
					return false;
				end
			end
		
			SetClipboardText(ent:Name());
		end
	end,
});