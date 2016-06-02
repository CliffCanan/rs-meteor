@fixtures ?= {}
@fixtures["Users"] =
	admin:
		role: "admin"
		profile:
			name: "Admin"
		emails: [
			address: "admin@rentscene.com"
			verified: true
		]
		isFixture: true
		services:
			password:
				bcrypt: "$2a$10$xLZT6i0IcSPNxo8idlvh7uixc5F9bUDlsG1ReweQzNS7Y.XKIpBky" # 123123
