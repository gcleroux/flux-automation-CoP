package main

import (
	"flag"
	"log"
	"net/http"
	"strconv"
)

var (
	width  int
	height int
	port   int
)

func catHandler(w http.ResponseWriter, r *http.Request) {
	// Directly use the URL from LoremFlickr for a random cat image
	imageUrl := "https://loremflickr.com/" +
		strconv.Itoa(width) +
		"/" +
		strconv.Itoa(height) +
		"/cat"

	// Serve an HTML page that displays the image
	w.Write([]byte("<html><body><img src='" + imageUrl + "' alt='Random Cat' /></body></html>"))
}

func main() {
	flag.IntVar(&width, "width", 1280, "image width")
	flag.IntVar(&height, "height", 720, "image height")
	flag.IntVar(&port, "port", 8080, "webapp port")

	flag.Parse()
	http.HandleFunc("/", catHandler)
	log.Fatal(http.ListenAndServe(":"+strconv.Itoa(port), nil))
}
