struct Response: Codable {
	let coord: Coord
	let weather: [Weather]
	let base: String?
	let main: Main
	let visibility: Int?
	let wind: Wind
	let clouds: Clouds
	let dt: Int?
	let sys: Sys
	let id: Int?
	let name: String?
	let cod: Int?
}
