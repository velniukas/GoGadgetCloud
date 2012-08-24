# puppet master
node ip-10-128-69-153 {
	include ntp
}

# jenkins client
node ip-10-128-49-231 {
	include ntp
	include bootstrap
}
